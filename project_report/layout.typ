#let report_layout(doc) = {
  set page(
    // paper: "a4",
    // margin: (x: 2.5cm, y: 3cm),
    numbering: "1",
  )

  set math.equation(numbering: "(1)")

  // set heading(numbering: "1.")

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

  set cite(style: "apa")

  show figure: set block(spacing: 2.5em)

  // force correct indents after headings and figures
  show heading: it => {
    it
    par(text(size: 0pt, ""))
  }

  show figure: it => {
    it
    par(text(size: 0pt, ""))
  }
  
	show figure.caption: it => [
  	#strong(it.supplement)
  	#strong(context it.counter.display(it.numbering))#it.separator#it.body
	]

  // show cite: it => {
  //     show "& others": "et al."
  //     it
  //   }

  show link: set text(fill: blue.darken(20%))

  doc
}