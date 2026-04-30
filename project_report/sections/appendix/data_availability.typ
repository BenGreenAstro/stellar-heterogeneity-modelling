#let cleancite(label) = {
  show regex("[\(\)\[\]]"): none
  cite(label, form: "normal")
}

== Data Availability

The work in this report makes use of the following codes and datasets:
- https://github.com/BenGreenAstro/stellar-heterogeneity-modelling (this work)
- https://emcee.readthedocs.io/en/stable/ (emcee, #cleancite(<emcee>))
- https://www.astropy.org/ (astropy, #cleancite(<Astropy-Latest>))
- https://phoenix.astro.physik.uni-goettingen.de/data/ (PHOENIX Göttingen library, #cleancite(<PHOENIX>)).

The observational JWST data described in section [insert section] can be obtained from the MAST JWST archive at 
- MAST JWST portal