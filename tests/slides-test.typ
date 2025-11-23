#import "../src/lib.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/polylux:0.4.0": *

#show heading: set block(above: 2em, below: 1em)

// place a label under a node
#let lab(l, dy:.9em, ..args) = place(dy:dy, center, text(size:.7em, l))

#set page(paper: "presentation-16-9")
#set text(size: 20pt)
#set align(center)

#slide[
  = Tree reveals

  #let reveal(it) = {
    let labels = it.children.filter(c => c.func() == place)
    let nodes = it.children.filter(c => c.func() != place)
    square(size:1em, inset:0pt, outset:1pt, align(center+horizon, {
      later(nodes.sum())
      labels.sum()
    }))
  }

  #stack(dir:ltr, spacing:4em, ..
  ((btt,rtl,"reverse postorder"),
   (ltr,ttb,"forward preorder"))
  .map(order => {

    align(center, order.pop())

    tree(vertical-gap:.75em, traversal:order)[
     #a(sep:2em, inherit:(display:reveal), leaves:(display:c=>c))
     11 #lab($-$)
     [18 #lab($times$)
      [2] [9]
     ]
     [7 #lab($+$)
      [4]
      [3 #lab($-$)
       [6] [3]
      ]
     ]
    ]

  }))

]