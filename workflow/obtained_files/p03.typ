#import "../variables.typ": *

#let prac_no    = 3
#let prac_title = practicals.at(prac_no - 1)

// ── PRACTICAL HEADER ─────────────────────────────────────────
#rect(width: 100%, stroke: 0.6pt, inset: 0.8em)[
  #grid(
    columns: (1fr, auto),
    [
      #text(weight: "bold")[Experiment No: #prac_no] \
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
#block[
= Water Jug
<water-jug>
#box(image("images/waterjug.webp", alt: "water jug"))

] <6ea79584-6157-4f6c-b700-81e019740782>
#block[
```python
```

] <3b794260-3b36-440a-b41d-c91e9b6c3af5>
#block[
= Aim
<aim>
IDK

] <04904529-1fc0-4308-ac15-0090b4d59db7>
#block[
```python
def main():
    print(f"{'yo':*^10}")
main()
```

#block[
```
****yo****
```

]
] <c834c80e-fa96-4224-9e93-aa733ec3aab9>
#block[
```python
```

] <6bb5be56-d14d-4602-905c-c63bcb9401ab>

// ── SIGN ROW ─────────────────────────────────────────────────
#v(1fr)
#line(length: 100%, stroke: 0.4pt + luma(180))
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  text(size: 9pt)[Date: ],
  text(size: 9pt)[Faculty Signature: #box(width: 4cm, stroke: (bottom: 0.4pt))],
)
