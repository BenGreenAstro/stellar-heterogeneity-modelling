#import "layout.typ": report_layout

#set page(paper: "a4", margin: (x: 2.5cm, y: 2.5cm))
#set text(font: "STIX Two Text", size: 11pt, lang: "en")

#include("sections/title_page.typ")
#pagebreak()

#show: report_layout

// PINEAPPLE: add an acknowledgements section

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

#include("sections/appendix.typ")
#bibliography("references.bib", style: "apa")
