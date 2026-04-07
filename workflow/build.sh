#!/bin/bash

# ── PATHS ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

WORKFLOW="$SCRIPT_DIR"
ROOT_DIR="$(dirname "$WORKFLOW")"
NOTEBOOKS="$ROOT_DIR/notebooks"
OBTAINED="$WORKFLOW/obtained_files"
MAIN="$WORKFLOW/main.typ"
LOG="$WORKFLOW/build.log"
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

# ── STEP 3: Rebuild include section ─────────────────────────────────────────

TMP_FILE=$(mktemp)

# Copy everything BEFORE the include section
awk '
/\/\/ ── PRACTICAL INCLUDES START ──/ {print; exit}
{print}
' "$MAIN" > "$TMP_FILE"

echo "" >> "$TMP_FILE"

# Rebuild includes fresh
for file in "$OBTAINED"/p*.typ; do
    [ -f "$file" ] || continue

    basename=$(basename "$file")

    CUSTOM_FILE="$WORKFLOW/custom/$basename"
    DEFAULT_PATH="obtained_files/$basename"
    CUSTOM_PATH="custom/$basename"

    if [ -f "$CUSTOM_FILE" ]; then
        include_path="$CUSTOM_PATH"
        echo "Using custom version for $basename" | tee -a "$LOG"

        if ! diff -q "$CUSTOM_FILE" "$file" >/dev/null 2>&1; then
            echo "⚠️  $basename differs from generated version" | tee -a "$LOG"
        fi
    else
        include_path="$DEFAULT_PATH"
    fi

    echo "#pagebreak()" >> "$TMP_FILE"
    echo "#include \"$include_path\"" >> "$TMP_FILE"
    echo "" >> "$TMP_FILE"
done

# Add end marker
echo "// ── PRACTICAL INCLUDES END ──" >> "$TMP_FILE"

# Replace main.typ
mv "$TMP_FILE" "$MAIN"

echo "=== Build complete at $(date) ===" | tee -a "$LOG"
echo ""
echo "Running: cd $WORKFLOW && typst watch main.typ"

cd $WORKFLOW && typst watch main.typ
