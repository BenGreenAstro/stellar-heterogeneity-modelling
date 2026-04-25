#import "@preview/unify:0.8.0": qty, unit, num

== Synthetic Spectra

=== PHOENIX

PHOENIX is a stellar atmosphere code that can reproduce spectra for many astrophysical bodies, including cool and hot stars, planets, and supernovae. [https://www.cambridge.org/core/services/aop-cambridge-core/content/view/DD2793408B0BE18330C2F66C340CB6F8/S0074180900133212a.pdf/highlights-of-stellar-modeling-with-phoenix.pdf]. Since its development in the 1990s, it has seen significant use as a code for generating synthetic stellar spectra [insert refs for some uses]. The PHOENIX code solves the radiative transfer equation in spherical geometry, including the effects of relativity. [https://www.sciencedirect.com/science/article/pii/S0377042799001533#BIB1]

=== Gottingen Library

There are multiple databases of synthetic spectra produced using the PHOENIX code available [insert some refs]. However, one which includes a large number of spectra which fully span the parameter space for M dwarfs is the Gottingen Spectral Library. @PHOENIX Each spectrum is specified at a given effective temperature $T_"eff"$, metallicity [[Fe\/H]], surface gravity $log g$ and alpha element abundance [$alpha$/Fe].#footnote[[$alpha$/Fe] represents the abundance of elements involved in the alpha-process. ]

[ ref for teffs of m dwarfs:
https://www.aanda.org/articles/aa/full_html/2023/07/aa44249-22/F2.html
https://academic.oup.com/mnras/article/389/2/585/972867
]

[maybe state how each of these affects the spectum shape / lines]
[define alpha/Fe] [at some point we need to reason why we only care about T F L / only T].

Specifically, it covers effective temperatures from 2.3K to 12K (i.e. well above what we need for studying M dwarfs), metallicies from -4 to 1, and log g from 0.0 to 6.0. This range covers the vast majority of known M dwarfs [insert a ref to a paper which shows the dist of these parameters for stars]. The creators of this library note that a few spectra were unable to be computed, and were interpolated (along the T_eff axis only).

Furthermore, the wavelength range of the spectra is [write 500Angstrom in um] to 5.5um, which is the same range as used by NIRISS [give range], NIRSPEC (give range), etc [list instruments]. Furthermore, the synthetic spectra have a resolution far higher than [insert JWST instruments] and comparable to [...] but lower than [...]. This allows us to use a wavelength range and resolution relevant to modern astronomy when simulating stellar component retrievals. Downsampling is done using a gaussian convolution at a given resolution [maybe move this to methodology, if this PHOENIX section isn't already within the methodology section]

The resolution of the parameters T_eff, FeH and log g is given in [table …]. However, there are existing methods which use interpolation on these parameters to achieve a much higher resolution [ref the chi-squared minimisation paper, and make sure to note what their resolution actually was].

==== Parameter Space

As much of the parameter space of this library is outside our M-dwarf scope, there is no need to download all of the provided spectra. In total, we used 2691 spectra, covering the ranges as given in @table-used-PHOENIX-ranges. This fully covers the M dwarf parameter space as [define M dwarf temps and metallicity etc].

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 7pt,
    align: center,
    stroke: none,
    
    // Toprule
    table.hline(stroke: 1.5pt),
    
    // Header
    [Parameter], [Range], [Step size],
    
    // Midrule
    table.hline(y: 1, stroke: 0.5pt),
    
    [$T_"eff"$ [K]], [2300 to 4500],  [100],
    [[Fe\/H] [dex]], [-4 to -2],  [1],
    [[Fe\/H] [dex]], [-2 to 1],  [0.5],
    [$log g$ [dex]], [0 to 6],  [0.5],
    [[$alpha\/"Fe"$] [dex]], [0],  [-],

    // Bottomrule
    table.hline(stroke: 1.5pt),
  ),
  caption: [
    The range of parameters used to generate simulated spectra within our model. Only a small number of spectra in the Gottingen library with non-zero alpha element abundance [$alpha\/"Fe"$] are provided, so we use $[alpha\/"Fe"] = 0$ for simplicity. Given the degeneracies between the other 3 parameters (see @Degeneracies), including [$alpha\/"Fe"$] variation would add significantly more complexity. In total, this space contains $23 times 9 times 13=2691$ spectra.
  ],
) <table-used-PHOENIX-ranges>

==== Wavelength Downsampling

[talk about downsampling using convolution & nyquist]