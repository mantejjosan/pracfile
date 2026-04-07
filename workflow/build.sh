#!/bin/bash

# ── PATHS ────────────────────────────────────────────────────────────────────
NOTEBOOKS=~/Desktop/College/sem4/ai/pracfile/notebooks
WORKFLOW=~/Desktop/College/sem4/ai/pracfile/workflow
OBTAINED=$WORKFLOW/obtained_files
MAIN=$WORKFLOW/main.typ
LOG=$WORKFLOW/build.log

# ── SETUP ────────────────────────────────────────────────────────────────────
mkdir -p "$OBTAINED"
ln -sfn "$NOTEBOOKS/images" "$OBTAINED/images"

echo "=== Build started at $(date) ===" | tee -a "$LOG"

# ── STEP 1: Convert .ipynb → .typ via pandoc ─────────────────────────────────
for file in "$NOTEBOOKS"/p*.ipynb; do
    [ -f "$file" ] || continue

    basename=$(basename "$file" .ipynb)          # e.g. p01
    out="$OBTAINED/$basename.typ"

    pandoc "$file" -o "$out"

    if [ $? -eq 0 ]; then
        echo "Converted $basename.ipynb → obtained_files/$basename.typ at $(date)" | tee -a "$LOG"
    else
        echo "ERROR: pandoc failed on $basename.ipynb" | tee -a "$LOG"
        continue
    fi

    # ── STEP 2: Prepend Typst header to each obtained .typ file ──────────────
    # Parse practical number from filename: p01 → 1, p02 → 2, etc.
    num=$(echo "$basename" | sed 's/p0*//')      # strips leading p and zeros
    num=$((10#$num))                             # force base-10

    # Read existing content, prepend header
    original=$(cat "$out")

    cat > "$out" <<TYPST_HEADER
#import "../variables.typ": *

#let prac_no    = $num
#let prac_title = practicals.at(prac_no - 1)

// ── PRACTICAL HEADER ─────────────────────────────────────────
#rect(width: 100%, stroke: 0.6pt, inset: 0.8em)[
  #grid(
    columns: (1fr, auto),
    [
      #text(weight: "bold")[Experiment No: #prac_no] \\
      #text(weight: "bold")[Date: ]
    ],
    align(right)[
      #text(size: 9pt)[#student_name --- #roll_no]
    ]
  )
  #v(0.3em)
  #text(size: 12pt, weight: "bold")[#prac_title]
]

#v(0.5em)

// ── CONTENT FROM NOTEBOOK ────────────────────────────────────
$original

// ── SIGN ROW ─────────────────────────────────────────────────
#v(1fr)
#line(length: 100%, stroke: 0.4pt + luma(180))
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  text(size: 9pt)[Date: ],
  text(size: 9pt)[Faculty Signature: #box(width: 4cm, stroke: (bottom: 0.4pt))],
)
TYPST_HEADER

    echo "  → Header injected into $basename.typ" | tee -a "$LOG"
done

# ── STEP 3: Add new includes to main.typ (no duplicates) ─────────────────────
for file in "$OBTAINED"/p*.typ; do
    [ -f "$file" ] || continue

    basename=$(basename "$file")                 # e.g. p01.typ
    include_path="obtained_files/$basename"

    # Only add if this include line isn't already in main.typ
    if ! grep -qF "$include_path" "$MAIN"; then
        echo "" >> "$MAIN"
        echo "#pagebreak()" >> "$MAIN"
        echo "#include \"$include_path\"" >> "$MAIN"
        echo "Added #include \"$include_path\" to main.typ" | tee -a "$LOG"
    else
        echo "Skipped $basename (already in main.typ)" | tee -a "$LOG"
    fi
done

echo "=== Build complete at $(date) ===" | tee -a "$LOG"
echo ""
echo "Running: cd $WORKFLOW && typst watch main.typ"

cd $WORKFLOW && typst watch main.typ
