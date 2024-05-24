#set page(
  width: 600pt, 
  height: 300pt,
  margin: (x: 0pt, top: 0pt, bottom: 0pt),
  header: [
    #align(top)[
      #line(length: 100%, stroke: 12pt + rgb("AB63FF"))
    ]
  ]
)
#set text(font: "Poppins", size: 11pt)
#set par(leading: 0.75em)
#show par: set block(spacing: 1.2em)
#show heading: set block(above: 32pt, below: 16pt)
#show link: it => underline(stroke: 1.5pt + rgb("#e63274"), it)


#align(center, [
  #figure(image(width: 100%, "banner.png"))
  #place(top + center, [
    #v(75pt)
    #box(fill: white.transparentize(20%), inset: 10pt,
      [
        #text(size: 36pt, weight: 600, fill: rgb("511299"), [CodeChella Madrid 2024])
      ]
    )
  ])
  
  // #text(size: 36pt, weight: 600, [CodeChella Madrid 2024])
])
