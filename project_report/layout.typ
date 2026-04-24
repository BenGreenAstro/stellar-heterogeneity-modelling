#let report_layout(doc) = {
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 3cm),
    numbering: "1",
  )
  
  set text(
      font: "STIX Two Text", 
      size: 11pt,
    )

  set heading(numbering: (..nums) => {
    let levels = nums.pos()
    if levels.len() == 1 {
      numbering("I.", ..levels)
    } else if levels.len() == 2 {
      numbering("A.", levels.last())
    } else if levels.len() == 3 {
      numbering("1.", levels.last())
    }
  })

  set par(
    justify: true,
    first-line-indent: 1.5em,
    spacing: 0.65em,
  )
  
  show heading: set align(center)

  show heading.where(level: 1): it => {
      set text(
          size: 14pt, 
          weight: "bold", 
          tracking: 0.05em,
      )
      v(2em)
      upper(it)
      v(1em)
    }

  show heading.where(level: 2): it => {
    set text(12pt, weight: "bold")
    v(1em)
    it
    v(0.5em)
  }

  show heading.where(level: 3): it => {
    set text(11pt, weight: "regular", style: "italic")
    v(1em)
    it
    v(0.5em)
  }

  doc
}