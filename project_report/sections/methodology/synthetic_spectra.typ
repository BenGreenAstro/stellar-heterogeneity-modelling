#import "@preview/unify:0.8.0": qty, unit, num

== Synthetic Spectra

=== Göttingen Library of PHOENIX Spectra

PHOENIX is a stellar atmosphere code that can reproduce spectra for a variety of stars, including M dwarfs @PHOENIXOverview. Since its development in the 1990s, it has seen significant use as a code for generating synthetic stellar spectra.

// [insert refs for some uses]
// The PHOENIX code solves the radiative transfer equation in spherical geometry, including the effects of relativity @HAUSCHILDT199941.

//  [insert some refs for "multiple databases"]
There are multiple databases of synthetic spectra produced using the PHOENIX code available. However, one which includes a large number of spectra which fully span the parameter space for M dwarfs is the Göttingen Spectral Library @PHOENIX. Each spectrum is specified at a given effective temperature $T_"eff"$, metallicity [Fe/H], surface gravity $log g$ and alpha element abundance [$alpha$/Fe].#footnote[[$alpha$/Fe] represents the abundance of elements involved in the alpha process.]

// ref for teffs of m dwarfs:
// https://www.aanda.org/articles/aa/full_html/2023/07/aa44249-22/F2.html
// https://academic.oup.com/mnras/article/389/2/585/972867
// [insert a ref to a paper which shows the dist of these parameters for stars]

// [at some point we need to reason why we only care about T F L / only T & f]

Specifically, it covers $T_"eff"$ from 2300 to 12000 K, [Fe/H] from -4 to 1 dex, and $log g$ from 0.0 to 6.0 dex. The creators of this library note that a few spectra were unable to be computed, and were interpolated (along the $T_"eff"$ axis only).

=== Parameter Space

As much of the parameter space of the Göttingen library is outside our M dwarf scope, there is no need to download all of the provided spectra. In total, we used 2691 spectra, covering the ranges as given in @table-used-PHOENIX-ranges. This subset covers the majority of known M dwarfs.
// [need a reference here!]
// [define M dwarf temps and metallicity etc].

// if m dwarfs only go up to 4k or whatevs, 

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
    The range of parameters used to generate simulated spectra within our model. Only a small number of spectra in the Göttingen library with non-zero alpha element abundance [$alpha\/"Fe"$] are provided, so we use $[alpha\/"Fe"] = 0$ for simplicity. Given the degeneracies between the other 3 parameters (see @Degeneracies), including [$alpha\/"Fe"$] variation would add significantly more complexity. In total, this space contains $23 times 9 times 13=2691$ spectra.
  ],
) <table-used-PHOENIX-ranges>

=== Wavelength Downsampling

// give range for these instruments
Furthermore, the wavelength range of the provided PHOENIX spectra spans $qty("0.05", "um")$ to $qty("5.5", "um")$, which overlaps with many of the spectroscopic instruments found on JWST, such as NIRISS, NIRSPEC and MIRI. The synthetic spectra have a resolution orders of magnitude larger than these instruments. This allows us to use a wavelength range and resolution relevant to modern astronomy when simulating stellar component retrievals. Downsampling is done using a Gaussian convolution at a given resolution.

// [talk about downsampling using convolution & nyquist]