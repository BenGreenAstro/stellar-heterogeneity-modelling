#import "@preview/nth:1.0.1": *

#let my-date(date) = nth(date.day()) + date.display(" [month repr:long] [year]")

#let reporttitle = [Stellar Variability \ in Exoplanet Hosting M Dwarf Spectra]
#let reportsubtitle = ""
#let reportauthor = "Benjamin Green"
#let crsID = "bg462"
#let crsID = ""
#let supervisor = "Lalitha Sairam"
#let uto = "Nikkhu Madhusudhan"
#let myabstract = "" // PINEAPPLE

// PINEAPPLE: change to the standard PhD format

#align(center, [
  // Logo Section
  #align(center, image("../aesthetics/cam.pdf", width: 10cm))
  #v(0.5cm)

  // Heading Sections
  #text(size: 1.2em, weight: "bold", smallcaps("Institute of Astronomy"))
  #v(0.5cm)
  #text(size: 1em, smallcaps("Research Project Report / " + smallcaps(my-date(datetime.today()))))\
  #v(0.5cm)

  // Title Section
  // #line(length: 100%, stroke: 0.5mm)
  #v(0.4cm)
  #text(size: 2em, weight: "bold", reporttitle) \
  #text(size: 1.5em, weight: "bold", reportsubtitle)
  #v(0.4cm)
  // #line(length: 100%, stroke: 0.5mm)
  #v(1.5cm)

  // Author & Supervisor Section
  #grid(
    columns: (1fr, 1fr),
    gutter: 1cm,
    align(left, [
      #emph("Author:") \
      #reportauthor \
      #crsID
    ]),
    align(right, 
      grid(
        columns: (auto, auto), // Column 1 fits labels, Column 2 fits names
        column-gutter: 1em,  // Space between the colon and the name
        row-gutter: 0.6em,     // Space between rows
        align: (right, left),
        
        // Row 1
        emph("Supervisor:"), [#supervisor],
        
        // Row 2
        emph("UTO:"), [#uto]
      )
    )
  )
  #v(2cm)

  // Abstract Section
  #block(width: 80%)[
    #align(center, text(weight: "bold", "Abstract"))
    #v(0.5em)
    #set text(fill: gray)
    #align(left, myabstract)
  ]

  // #v(1fr) // Fills remaining space
])
