#let report_layout(doc) = {
  set page(
    paper: "us-letter",
    margin: (x: 2.5cm, y: 3cm),
    numbering: "1",
  )
  
  set text(font: "New Computer Modern", size: 11pt)
  
  // 1. Set Roman Numeral numbering
  set heading(numbering: "I.")

  // 2. LaTeX Standard Paragraphs
  // Typst defaults to no-indent on the first paragraph automatically.
  set par(
    justify: true,
    first-line-indent: 1.5em,
    spacing: 0.65em, // This is the "leading" between blocks; standard LaTeX is tight
  )

  // 3. Level 1 Headings: Centered
  show heading.where(level: 1): it => {
    set align(center)
    set text(14pt, weight: "bold")
    v(2em)
    upper(it)
    v(1em)
  }

  doc
}