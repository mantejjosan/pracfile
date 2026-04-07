#!/usr/bin/env python3
"""
AI Practicals Build Script
===========================
Watches p__.ipynb files, converts them via pandoc, wraps them in
the Typst practical template, then runs `typst watch main.typ`.

Usage:
    python build.py          # watch mode (recommended)
    python build.py --once   # build once and exit
"""

import re
import subprocess
import sys
import time
from pathlib import Path

# ── CONFIG ───────────────────────────────────────────────────────────────────

PRACTICALS_DIR = Path(".")          # where your p__.ipynb files live
PANDOC_CMD     = "pandoc"
TYPST_CMD      = "typst"

# How many practicals exist (matches variables.typ list length)
NUM_PRACTICALS = 10

# ─────────────────────────────────────────────────────────────────────────────


def parse_notebook_meta(ipynb_path: Path) -> tuple[str, str]:
    """
    Read the first markdown cell of the notebook and extract:
      Date: DD/MM/YYYY
      Aim:  ...
    Returns (date_str, aim_str). Falls back to empty strings if not found.
    """
    import json
    try:
        nb = json.loads(ipynb_path.read_text(encoding="utf-8"))
    except Exception as e:
        print(f"  [warn] Could not read {ipynb_path.name}: {e}")
        return "", ""

    date_str = ""
    aim_str  = ""

    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "markdown":
            src = "".join(cell.get("source", []))
            # Look for "Date: ..." and "Aim: ..."
            date_m = re.search(r"(?i)^date\s*:\s*(.+)$", src, re.MULTILINE)
            aim_m  = re.search(r"(?i)^aim\s*:\s*(.+)$",  src, re.MULTILINE)
            if date_m:
                date_str = date_m.group(1).strip()
            if aim_m:
                aim_str = aim_m.group(1).strip()
            if date_str or aim_str:
                break   # only check first markdown cell

    return date_str, aim_str


def convert_notebook_to_raw_typ(ipynb_path: Path, raw_typ_path: Path):
    """Run pandoc to convert .ipynb → .typ (raw, no wrapper)."""
    result = subprocess.run(
        [PANDOC_CMD, str(ipynb_path), "-o", str(raw_typ_path)],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"  [pandoc error] {result.stderr}")
        return False
    return True


def strip_meta_cell(raw_typ: str) -> str:
    """
    Remove the first content block that pandoc produces from our
    Date:/Aim: metadata cell — we don't want it duplicated in the body.
    """
    # Pandoc wraps markdown paragraphs; the first one will contain "Date:" 
    # We remove everything up to and including the first blank line after it
    lines = raw_typ.split("\n")
    # Find lines that look like our meta block
    skip_until = 0
    for i, line in enumerate(lines):
        if re.match(r"(?i)(date|aim)\s*:", line.strip()):
            # skip forward to next blank line
            for j in range(i, len(lines)):
                if lines[j].strip() == "":
                    skip_until = j + 1
                    break
            break
    return "\n".join(lines[skip_until:]).lstrip("\n")


def build_practical_typ(prac_no: int) -> bool:
    """
    Full pipeline for practical number prac_no:
      1. find p{prac_no:02d}.ipynb
      2. parse metadata (date, aim)
      3. pandoc → raw .typ
      4. wrap with Typst header + sign row
      5. write p{prac_no:02d}.typ
    """
    tag      = f"p{prac_no:02d}"
    ipynb    = PRACTICALS_DIR / f"{tag}.ipynb"
    raw_typ  = PRACTICALS_DIR / f"{tag}_raw.typ"
    final    = PRACTICALS_DIR / f"{tag}.typ"

    if not ipynb.exists():
        return False

    print(f"  Building {tag}...")

    # 1. Parse metadata
    date_str, aim_str = parse_notebook_meta(ipynb)
    date_display = date_str or "________"
    aim_display  = aim_str  or "To be filled."

    # 2. Pandoc conversion
    if not convert_notebook_to_raw_typ(ipynb, raw_typ):
        return False

    # 3. Read and clean pandoc output
    raw_content = raw_typ.read_text(encoding="utf-8")
    body = strip_meta_cell(raw_content)

    # 4. Wrap in Typst practical template
    typst_out = f"""\
#import "variables.typ": *

#let prac_no    = {prac_no}
#let prac_title = practicals.at(prac_no - 1)
#let prac_aim   = "{aim_display}"
#let prac_date  = "{date_display}"

// ── PRACTICAL HEADER ─────────────────────────────────────────
#rect(width: 100%, stroke: 0.6pt, inset: 0.8em)[
  #grid(
    columns: (1fr, auto),
    [
      #text(weight: "bold")[Experiment No: #prac_no] \\
      #text(weight: "bold")[Date: #prac_date]
    ],
    align(right)[
      #text(size: 9pt)[#student_name — #roll_no]
    ]
  )
  #v(0.3em)
  #text(size: 12pt, weight: "bold")[#prac_title]
]

#v(0.5em)

// ── AIM ──────────────────────────────────────────────────────
#section("Aim")[
  #prac_aim
]

// ── CONTENT FROM NOTEBOOK ────────────────────────────────────
{body}

// ── SIGN ROW ─────────────────────────────────────────────────
#v(1fr)
#line(length: 100%, stroke: 0.4pt + luma(180))
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  text(size: 9pt)[Date: #prac_date],
  text(size: 9pt)[Faculty Signature: #box(width: 1fr, stroke: (bottom: 0.4pt))],
)
"""

    final.write_text(typst_out, encoding="utf-8")
    raw_typ.unlink(missing_ok=True)   # clean up temp file
    print(f"  ✓ {tag}.typ written")
    return True


def update_main_typ():
    """
    Rewrite the include section of main.typ to include every p__.typ
    that currently exists, in order.
    """
    main = PRACTICALS_DIR / "main.typ"
    if not main.exists():
        print("  [warn] main.typ not found — skipping update")
        return

    content = main.read_text(encoding="utf-8")

    # Build the new includes block
    includes = []
    for n in range(1, NUM_PRACTICALS + 1):
        tag = f"p{n:02d}"
        if (PRACTICALS_DIR / f"{tag}.typ").exists():
            includes.append(f'#pagebreak()\n#include "{tag}.typ"')

    includes_block = "\n\n".join(includes)

    # Replace everything between our sentinel comments
    pattern = r"(// ──+ PRACTICAL INCLUDES START ──+\n).*?(// ──+ PRACTICAL INCLUDES END ──+)"
    replacement = rf"\g<1>{includes_block}\n\n\g<2>"

    if re.search(pattern, content, re.DOTALL):
        new_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
        main.write_text(new_content, encoding="utf-8")
        print("  ✓ main.typ includes updated")
    else:
        print("  [warn] Sentinel comments not found in main.typ.")
        print("         Add these two lines where your #include lines are:")
        print("           // ── PRACTICAL INCLUDES START ──")
        print("           // ── PRACTICAL INCLUDES END ──")


def build_all():
    """Build every notebook that exists."""
    print("[build] Building all practicals...")
    any_built = False
    for n in range(1, NUM_PRACTICALS + 1):
        if build_practical_typ(n):
            any_built = True
    if any_built:
        update_main_typ()
    print("[build] Done.\n")


def watch_mode():
    """
    Poll for .ipynb changes and rebuild when detected.
    Typst watch handles the PDF side — we just keep the .typ files fresh.
    """
    print("[watch] Watching for notebook changes. Press Ctrl+C to stop.")
    print("        Run `typst watch main.typ` in another terminal.\n")

    mtimes: dict[Path, float] = {}

    def get_mtime(p: Path) -> float:
        try:
            return p.stat().st_mtime
        except FileNotFoundError:
            return 0.0

    # Initial build
    build_all()

    while True:
        for n in range(1, NUM_PRACTICALS + 1):
            nb = PRACTICALS_DIR / f"p{n:02d}.ipynb"
            mt = get_mtime(nb)
            if mt and mt != mtimes.get(nb, 0.0):
                mtimes[nb] = mt
                print(f"[watch] Change detected: {nb.name}")
                if build_practical_typ(n):
                    update_main_typ()
        time.sleep(2)


if __name__ == "__main__":
    if "--once" in sys.argv:
        build_all()
    else:
        try:
            watch_mode()
        except KeyboardInterrupt:
            print("\n[watch] Stopped.")
