// ============================================================
//  AI PRACTICALS — MASTER TEMPLATE
//  DO NOT manually edit the includes section below.
//  Run `python build.py` — it manages the includes automatically.
// ============================================================
#import "variables.typ": *

// ── PAGE SETUP ───────────────────────────────────────────────
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
)

#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true, leading: 0.75em)
#set heading(numbering: none)


// ════════════════════════════════════════════════════════════
//  TITLE PAGE
// ════════════════════════════════════════════════════════════
#align(center)[
  #image("images/gne_logo.png", width: 25%)
  #v(1cm)
  #text(size: 16pt, weight: "bold")[#college]
  #v(0.5cm)
  #line(length: 80%, stroke: 0.8pt)
  #v(0.5cm)
  #text(size: 13pt)[Department of #branch]
  #v(2cm)

  #rect(width: 85%, stroke: 1pt, inset: 1.2em)[
    #text(size: 14pt, weight: "bold")[LABORATORY FILE]
    #v(0.4em)
    #text(size: 12pt)[#subject]
  ]

  #v(2cm)
  #grid(
    columns: (auto, auto),
    gutter: 1em,
    align: (right, left),
    text(weight: "bold")[Name :],       student_name,
    text(weight: "bold")[URN :],        roll_no,
    text(weight: "bold")[Class :],      year_div,
    text(weight: "bold")[Subject :],    subject,
    text(weight: "bold")[Professor :],  professor
  )
  #v(1fr)
  #text(size: 9pt, fill: luma(100))[Academic Year 2025–26]
  #v(1cm)
]

// ════════════════════════════════════════════════════════════
//  INDEX PAGE
// ════════════════════════════════════════════════════════════
#pagebreak()
#align(center)[
  #v(0.5cm)
  #text(size: 14pt, weight: "bold")[List of Practicals]
  #v(0.5cm)
]

#table(
  columns: (2cm, 1fr, 2.5cm, 2.5cm, 2cm),
  align: center,
  stroke: 0.5pt,
  inset: 6pt,
  table.header(
    text(weight: "bold")[Sr. No.],
    text(weight: "bold")[Experiment Title],
    text(weight: "bold")[Date],
    text(weight: "bold")[Sign],
    text(weight: "bold")[Marks],
  ),
  ..for (i,topic) in practicals.enumerate() {
    (
      [#(i+1)],
      [#topic],
      [],
      [],
      []
    )
  },
)

// ════════════════════════════════════════════════════════════
//  PRACTICALS — managed automatically by build.py
//  Do not edit between the sentinel comments below.
// ════════════════════════════════════════════════════════════

// ── PRACTICAL INCLUDES START ──
#pagebreak()
#include "p01.typ"

#pagebreak()
#include "p02.typ"
// ── PRACTICAL INCLUDES END ──
