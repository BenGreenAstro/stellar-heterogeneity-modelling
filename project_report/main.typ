#import "layout.typ": report_layout

#set page(paper: "a4", margin: (x: 2.5cm, y: 3cm))
#set text(font: "STIX Two Text", size: 11pt, lang: "en")
#set math.equation(numbering: "(1)")

#include("sections/title_page.typ")
#pagebreak()

#show: report_layout

#include("sections/contents_page.typ")
#pagebreak()

#include("sections/introduction.typ")
#pagebreak()

#include("sections/theory.typ")
#pagebreak()

#include("sections/methodology.typ")
#pagebreak()

#include("sections/results.typ")
#pagebreak()

#include("sections/conclusions.typ")

#pagebreak()
#bibliography("references.bib", style: "apa")
