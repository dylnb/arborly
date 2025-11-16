#import "../src/lib.typ": *
#import "@preview/cetz:0.4.2"

#show heading: set block(above: 2em, below: 1em)

// update defaults for remainder of document
#let set-tree(..args) = arborly-defaults.update(old => cetz.util.merge-dictionary(old, args.named()))
#set-tree(child-lines:(stroke:(thickness:0.5pt)))

// shorthands for specific attributes
#let sep(amount) = a(sep: amount)
#let roof = a(triangle: true)
#let leaves(..args) = a(leaves: args.named())
#let inherit(..args) = a(inherit: args.named())
#let edge(n,..args) = a(parent-line: (name: n) + args.named())
// place a label under a node
#let lab(l, dy:.9em, ..args) = place(dy:dy, center, text(size:.7em, l))

// just a wrapper around #tree to style a little more ergonomically
#let oldtree = tree
#let tree(body, scale:100%, pos:center, traversal:(ltr,ttb), code:none, vgap:.75em, snap:0pt, ..args) = {
  set text(size: scale * 1em)
  let t = oldtree(body, style:args.named(), code:code, traversal:traversal,
                  vertical-gap:vgap, vertical-snapping-threshold:snap)
  align(pos, t)
}


== fixed angle tests

#let t1 = [
 [aaa]
 [
  [ccccccc]
  [
  #sep(.5em)  
   [
    [
     [
      [hhhh]
      [iiiiiiii]
     ]
     [bbbbb]
    ]
   ]
   [
    [[eeeeeeee #roof]]
    [#text(ligatures:false)[fff]]
   ]
  ]
 ]
]

#grid(columns:3, column-gutter:4em, row-gutter:1cm,
   tree(t1), tree(angle:60deg, t1), tree(angle:90deg, t1)
 )

== display tests

#let t2 = [
 S  
 [xxxxxxx #a(text:(fill:gray))] //  display supersedes text if there's a conflict
 [blah \ blah
  [#rect(height:2em, width:1em)
    [yy] [zz]
  ]
  [#rect(height:1em, width:2em)
   #leaves(display: text.with(blue)) // leaf attrs supersede inherited attrs
   [yy]
   [
   #a(inherit:(sep:1em))
    [
     [
      [a] 
      [b]
     ]
     [cccc #a(display: text.with(maroon))] // local attrs supersede all others
    ]
    [d]
   ]
  ]
 ]
]

#grid(columns:3, column-gutter:2em, row-gutter:1cm,
  tree(t2, angle:60deg, display: text.with(red)),
  tree(t2, angle:60deg, display: highlight),
  tree(t2, angle:60deg, display: it => ellipse(inset:2pt, [_#{it}_]))
)

== traversal tests

#let r = counter("r")
#stack(dir:ltr, spacing:2.5em, ..
  ((ltr,ttb, "preorder"),
   (ltr,btt, "postorder"),
   (rtl,ttb, "reverse preorder"),
   (rtl,btt, "reverse postorder"))
  .map(order => {
    r.update(0) // reset the node counter
    align(center, order.pop()) // show the label
    tree(traversal:order, display: _ => {r.step(); context r.display()})[
      [ [] [] ]
      [ [] [] ]
    ]
  }
  )
)

#v(1em)

#let r = state("r",0)
#stack(dir:ltr, spacing:.5em, ..
  range(5).map(i => {
    r.update(1) // reset the node counter
    let tick(it) = context { // display function
      r.update(n=>n+1)
      let it = square(size:1em, inset:0pt, outset:1pt, align(center+horizon,it))
      if r.get() < i {it} else if r.get() == i {text(red,it)} else {show text:hide; it}
    }
    tree(sep:1.3em, traversal:(btt, rtl), display:tick)[
     #leaves(display:c=>c)
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
}
))

== branching tests

#let body = [
  S
  [DP \ subj1]
  [DP \ subj2]
  [DP \ blah]
  [VP [V \ verb] [DP \ obj]]
]

#grid(columns: 2, column-gutter:1cm, row-gutter:1cm)[
1. #tree(sep:2em, body)
][
2. #tree(angle:60deg, body)
][
3. #tree(angle:90deg, body)
][
4. #tree(angle:80deg)[
  S
  [DP #a(angle:50deg) [S [DP] [VP]] [S [DP] [VP]]]
  [DP \ subj2] [DP \ blah] [VP #a(angle:40deg) [V \ verb] [DP \ obj]]]
]


== cetz tests

// draw a rectilinear arrow from one node to another
#let mv(from, to, dy:-.6em, dx:0, dash:"solid", ..args) = {import cetz.draw:*
  let source = from + ".south"
  let dest = if dx == 0 {to + ".south"} else {to + ".west"}
  let hinge = (rel:(x:dx), to:dest, update:false)
  set-style(stroke: (thickness:.5pt, dash:dash),
            mark: (end: (symbol:"curved-stealth", stroke: (dash:"solid"))))
  line(source, (rel:(y:dy)), ((),"-|", hinge), hinge, dest, ..args)
}

#tree(vgap: 1.25em,
[A
#lab[*LAB*]
 [B
 #a(name:"high")
  [words words #roof]
 ]
 [C
  [D
  #edge("e1", stroke:red)
  ]
  [F \ $forall w. thin W(w) -> W(w)$
   [$mono((e t)t)$ \ Word
    [$mono(e)$ \ word
    #edge("shift")
    #a(name:"low")
    ]
   ]
  [G
   [blue word
   #a(name:"blue",text:(fill:blue))
   ]
   [#text(gray, box(stroke:gray,inset:(x:1cm,y:0pt),outset:.5em)[fill in words])
   #lab(smallcaps("lab"))
    [$emptyset$ [$emptyset$ [$emptyset$]]]
    [#a(padding:none)
    #lab(dy:.5em,"???")
    #sep(2cm)
    [#text(green.darken(25%))[green word]
    #a(name:"green")
    ]
    [H
    #a(inherit:(angle:50deg))
    #lab(highlight(fill:black,top-edge:"cap-height",text(white, "xxx")))
     [
     #lab(dy:.5em)[_yyy_]
      [
      #lab(dy:.5em, highlight[_zzz_])
       [
        [word #a(name:"lw")]
        [word]
       ] 
       [word]
      ]
      [word]
     ]
     [word]
    ]
    ]
   ]
  ]
  ]
 ]
],
code: {import cetz.draw:*
  content("shift", text(size:.75em, sym.arrow.t), padding:(left:.5))
  content("e1", text(red, $a b c$), angle:"e1.start", anchor:"north")
  mv("low","high", dx:-3em, dash:"dashed", name:"el")
  mv("green","blue", dy:-5em, mark:(end:"o",start:"o"), name:"gb")
  content("gb.75%", [_nonsense_], anchor:"south", angle:90deg, padding:.1)
  bezier("lw.west", "el.25%", (rel:(x:-7,y:-1)))
})

== frame tests

#set-tree(child-lines:(stroke:(paint:blue)))

#grid(columns:3, column-gutter:1em, row-gutter:1cm,

tree(code:mv("v","subj"))[
S
#sep(4em)
 [DP \ subj #a(name:"subj")]
 [VP
 #sep(3em)
 #a(frame:true)
  [V \ verb #a(name:"v")]
  [VP
   [DP \ ob #a(name:"ob")]
   [PP \ hmmm]
  ]
 ]
]

,

tree(angle:60deg,sep:3em)[
S
 [DP \ subj #a(name:"subj")]
 [
 #a(frame:(stroke:red, padding:(bottom:.1), radius:(rest:(20%,50%))))
  [V \ verb #a(name:"v")]
  [
  #sep(2em)
   [DP
   #a(sep:1em,frame:true)
    [D]
    [NP]
   ] 
   [PP \ hmmm]
  ]
 ]
]

,

tree(code:mv("vp","subj"))[
S
[DP \ subj #a(name:"subj")]
[#a(name:"vp")
 #rect(inset:(y:4pt,x:0pt))[
   // embedded #trees have isolated namespaces; no conflict re-using 'vp'
   #tree(code:mv("obj","vp"))[
   VP #a(name:"vp")
    [V \ verb]
    [DP \ obj #a(name:"obj")]
   ]
 ] 
]
]

) // close grid

== math tests

#set-tree(child-lines:(stroke:(paint:black,thickness:.5pt)))

#let var = square(size:1em, fill: gradient.conic(..color.map.rainbow))
#let t(ctx, ..args) = tree(code:mv("v","subj"), ..args)[
 S
 #sep(4em)
 [DP \ subj #a(name:"subj")]
 [VP
 #sep(3em)
  [V \ verb #a(name:"v")]
  [VP
   [#ctx]
   [PP \ hmmm]
  ]
 ]
]

$
[|
#t(var)
|]^(#var |-> (#tree[U [V [Y] [Z]] [X]]))
=
#t(scale:80%)[#tree[U [V [Y] [Z]] [X]]]
$

#stack(dir:ltr, spacing:2em,

tree[
 $forall x. thin P x$
 [$forall x$]
 [$mono(t) \ P x and Q x$
  [$mono(t) \ Q x$
   [$Q$]
   [$x$]
  ]
  [$and$ \ and]
  [$mono(t) \ P x$
   [$P$]
   [$x$]
  ]
 ]
]
,

tree[
 $ forall x. thin P x $
 [$forall x$]
 [$ mono(t) \ P x and Q x $
  [$ mono(t) \ Q x $
   [$Q$]
   [$x$]
  ]
  [$and$ \ and]
  [$ mono(t) \ P x $
   [$P$]
   [$x$]
  ]
 ]
]
,

// doesn't work, sadly; can't delay evaluation of content
tree(display: it => $ #it $)[
 forall x. thin P x
 [forall x]
 [mono(t) \ P x and Q x
  [mono(t) \ Q x
   [Q]
   [x]
  ]
  [and \ "and"]
  [mono(t) \ P x
   [P]
   [x]
  ]
 ]
]

)

