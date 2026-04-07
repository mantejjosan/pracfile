#let student_name = "Mantej Singh Josan"
#let roll_no      = "2435087"
#let branch       = "Computer Science & Engineering"
#let year_div     = "Second Year — Div C2"
#let subject      = "Artificial Intelligence"
#let college      = "Guru Nanak Dev Engineering College, Ludhiana"
#let professor    = "Prof. Jasdeep Kaur Joia"

// common stuff
#let practicals = (
  "Implement a simple reflex agent for the vacuum-cleaner world.",
  "Implement BFS and DFS for water jug problem.",
  "Implement Hill Climbing search algorithm.",
  "Implement A* algorithm for eight puzzle problem.",
  "Develop Tic Tac Toe using Minimax with alpha-beta pruning.",
  "Represent a real-world domain using frames and semantic networks.",
  "Implement Goal Stack Planning for the Blocks World.",
  "Implement Bayes Rule to classify emails as spam or not spam.",
  "Build a small neural network from scratch.",
  "Generate images from text using a pre-trained diffusion/GAN model."
)

// ── HELPER: section label ────────────────────────────────────
#let section(title, body) = {
  v(0.6em)
  text(weight: "bold", size: 11pt, underline(title))
  v(0.3em)
  body
  v(0.4em)
}

// ── HELPER: blank facing page ────────────────────────────────
#let blank_page(label: "Diagrams / Output") = {
  pagebreak()
  page(
    margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2cm),
  )[
    #align(center)[
      #v(1fr)
      #rect(
        width: 90%,
        height: 70%,
        stroke: 0.5pt + luma(180),
        radius: 4pt,
      )[
        #align(center + horizon)[
          #text(fill: luma(180), size: 13pt)[#label]
        ]
      ]
      #v(1fr)
    ]
  ]
  pagebreak()
}

// ── HELPER: image page ───────────────────────────────────────
#let image_page(path, caption: "") = {
  pagebreak()
  page(
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2cm, right: 2cm),
  )[
    #align(center + horizon)[
      #image(path, width: 95%)
      #if caption != "" {
        v(0.5em)
        text(size: 9pt, style: "italic", fill: luma(80), caption)
      }
    ]
  ]
  pagebreak()
}
