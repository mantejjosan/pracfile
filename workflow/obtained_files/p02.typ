#import "../variables.typ": *

#let prac_no    = 2
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
= Aim
<aim>
Water jug problem
#box(image("images/waterjug.webp", alt: "images/waterjug.webp"))

] <762d726e-db7d-4c86-b4c6-ed1beefa563b>
#block[
```python
def main():
    print('hello water')
main()
```

#block[
```
hello water
```

]
] <c1e128f5-524d-4c77-913a-c195d52b19ce>
#block[
```python
```

] <8547fb20-eb0d-4c76-9c37-b9a0e5708411>

// ── SIGN ROW ─────────────────────────────────────────────────
#v(1fr)
#line(length: 100%, stroke: 0.4pt + luma(180))
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  text(size: 9pt)[Date: ],
  text(size: 9pt)[Faculty Signature: #box(width: 4cm, stroke: (bottom: 0.4pt))],
)
