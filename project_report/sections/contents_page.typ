#show outline.entry.where(level: 1): it => {
  v(12pt, weak: true) 
  strong(it)
}

// #show outline: set text(size: 9pt)

// 3. The Table of Contents
#outline(
  title: [CONTENTS], 
  indent: 2em,
  depth: 2
)