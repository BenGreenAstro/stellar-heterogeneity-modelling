#import "@preview/nth:1.0.1": *
#import "@preview/unify:0.8.0": qty, unit, num

#let my-date(date) = nth(date.day()) + date.display(" [month repr:long] [year]")

#let reporttitle = [Accurate Modelling of Stellar Variability \ in Exoplanet Hosting M Dwarf Spectra]
#let reportsubtitle = ""
#let reportauthor = "Benjamin Green"
#let crsID = "bg462"
#let crsID = ""
#let supervisor = "Lalitha Sairam"
#let uto = "Nikkhu Madhusudhan"
#let myabstract = [
The transit light source effect presents a significant barrier to being able to confidently and correctly analyse exoplanetary atmospheres. Stellar contamination can create false spectral features, which may appear similar to coveted biosignatures. We present a method to analyse the spot and facula coverage on the stellar surface, in order to better understand the prescence of any unocculted heterogeneities.

M dwarf spectra are generated using PHOENIX spectra and processed to simulate current space-based instrumentation. The star's $T_"eff"$, [Fe/H], $log g$ and area covering fractions $f$ are determined. Bayesian inference is used to determine the values of these parameters and visualise the degree of degeneracy between them. Physical constraints are placed upon [Fe/H] and $log g$ to reduce uncertainty in the fit. [Fe/H] and $log g$ are found within 0.3 dex, even at low resolutions of $R approx 100$ / $#qty(0.01, "um")$. The model is capable of determining all parameters at high resolution, with uncertainties in $T_"eff"$ being $lt 3%$.

Low resolution spectra with $R gt #qty(1, "nm")$ are found to display large degeneracies between $T_"eff"$ and $f$, preventing accurate determination of these two stellar parameters. Uncertainty in $f$ can be $gt 50%$, and that in $T_"eff"$ can be $gt #qty(300, "K")$. The source of this degeneracy is explored.

// problem, method, setup, key quantitative result, main limitation.

] // PINEAPPLE
// PINEAPPLE: change to the standard PhD format

#align(center, [
  // Logo Section
  #align(center, image("../aesthetics/cam.pdf", width: 10cm))
  #v(0.8cm)

  // Title Section
  // #line(length: 100%, stroke: 0.5mm)
  #v(0.4cm)
  #text(size: 2em, weight: "bold", reporttitle) \
  #text(size: 1.5em, weight: "bold", reportsubtitle)
  #v(0.4cm)

  #text(size: 1.2em, weight: "light", ("by"))
  #v(0.4cm)
  #text(size: 1.2em, weight: "bold", ("Benjamin Green"))
  #v(0.05cm)

  // Heading Sections
  #text(size: 1em, weight: "regular", ("St Catharine's College")) \
  #text(size: 1em, weight: "regular", ("Institute of Astronomy")) \
  #v(0.6cm)
  #text(size: 1em, ("Research Project Report / " + (my-date(datetime.today()))))\
  #v(0.6cm)

  #grid(
    columns: (auto, auto), // Column 1 fits labels, Column 2 fits names
    column-gutter: 1em,  // Space between the colon and the name
    row-gutter: 0.6em,     // Space between rows
    align: (right, left),
    
    // Row 1
    "Supervisor:", (supervisor),
    
    // Row 2
    "UTO:", (uto)
  )
  
  #v(0.6cm)

  // Abstract Section
  #block(width: 80%)[
    #align(center, text(weight: "bold", "Abstract"))
    #v(0.5em)
    #set text()
    #align(left, myabstract)
  ]

  // #v(1fr) // Fills remaining space
])
