#import "../variables.typ": *

#let prac_no    = 1
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
A Simple Reflex Agent

] <4cd4ebc0-6329-4d92-aaec-46c087809836>
#block[
== Theory
<theory>
A simple reflex agent selects actions based only on the current percept,
ignoring all prior history. It uses condition-action rules of the form
#emph[if percept then action]. The vacuum-cleaner world consists of two
locations (A and B), each of which can be dirty or clean. The agent
perceives its current location and whether it is dirty, then acts
accordingly --- either cleaning or moving to the other location.

] <5edf32dd-193d-4baa-9d91-e47ff5bb6609>
#block[
== Task Requirement
<task-requirement>
#figure(
  align(center)[#table(
    columns: (29.03%, 18.06%, 23.23%, 29.68%),
    align: (auto,auto,auto,auto,),
    table.header([Performance
      Measure], [Environment], [Actuators], [Sensors],),
    table.hline(),
    [1. Energy efficiency (battery saved)], [A room or grid of
    squares], [Suction pump, wheels, motor], [Dirt detector, location
    sensor, bump sensor],
    [2. Time saved], [], [], [],
    [3. Cleanliness (percent of space clean)], [], [], [],
  )]
  , kind: table
  )

] <dee1300a-94f2-425b-8aeb-d899ce773f5f>
#block[
== Code
<code>
A simple implementation using `if-else` that runs the simulation only
for 1 episode.

] <25b060aa-aad1-473c-881e-dc8d843da3d8>
#block[
```python
def reflex_agent(location, status):
      if status == "Dirty":
          return "Suck"
      elif location == "A":
          return "MoveRight"
      else:
          return "MoveLeft"

# Test the agent
world = [("A", "Dirty"), ("A", "Clean"), ("B", "Dirty"), ("B", "Clean")]

print(f" {'location':<8} | {'Status':<6} | Action")
print("-" * 35)
for loc, stat in world:
  action = reflex_agent(loc, stat)
  print(f" {loc:<8} | {stat:<6} | {action}")
```

#block[
```
 location | Status | Action
-----------------------------------
 A        | Dirty  | Suck
 A        | Clean  | MoveRight
 B        | Dirty  | Suck
 B        | Clean  | MoveLeft
```

]
] <64341755-28c1-45be-a51f-0d79cb4d8738>
#block[
== Conclusion
<conclusion>
The simple reflex agent was successfully implemented for the
vacuum-cleaner world. The agent correctly determines its action based
solely on the current percept without any memory of past states. This
demonstrates the basic structure of a condition-action rule-based agent.

] <7866de2d-6198-482c-86e6-240cf77e748e>
#block[
```python
```

] <f0c7637a-b645-4563-ba73-763a25b7237e>

// ── SIGN ROW ─────────────────────────────────────────────────
#v(1fr)
#line(length: 100%, stroke: 0.4pt + luma(180))
#grid(
  columns: (1fr, 1fr),
  align: (left, right),
  text(size: 9pt)[Date: ],
  text(size: 9pt)[Faculty Signature: #box(width: 4cm, stroke: (bottom: 0.4pt))],
)
