#import "layout.typ": report_layout

#set page(paper: "a4", margin: 2cm)
#set text(font: "STIX Two Text", size: 11pt)

#include("sections/title_page.typ")

#pagebreak()

#show: report_layout

#include("sections/introduction.typ")
#include("sections/methodology.typ")

