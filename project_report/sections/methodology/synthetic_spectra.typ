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

Specifically, it covers $T_"eff"$ from 2300 to 12000 K, [Fe/H] from -4 to 1 dex, and $log g$ from 0.0 to 6.0 dex. The creators of this library note that a few spectra could not be computed, and were interpolated (along the $T_"eff"$ axis only).

=== Parameter Space

As much of the parameter space of the Göttingen library is outside our M dwarf scope, there is no need to download all of the provided spectra. In total, we used 2691 spectra, covering the ranges as given in @table-used-PHOENIX-ranges. This subset covers the majority of known M dwarfs @MDwarfTemperatures @MDwarfMetallicities.
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

// maybe give range for these instruments
The wavelength range of the provided PHOENIX spectra spans $qty("0.05", "um")$ to $qty("5.5", "um")$, which overlaps with many of the spectroscopic instruments found on JWST, such as NIRISS, NIRSPEC and MIRI. The synthetic spectra have a resolution orders of magnitude larger than these instruments. This allows us to use a wavelength range and resolution relevant to modern astronomy when fitting stellar components.

In order to simulate an instruments LSF, we need to convolve the data with a normalised Gaussian. This Gaussian's standard deviation acts as the effective resolution of the simulated instrument.  However, JWST instruments have wavelength resolutions $R #sym.tilde 100 - 1000$ in the IR @JWSTNIRSpecResolution, which is orders of magnitude less than PHOENIX's $R = 100,000$. This makes directly convolving the original data very computationally heavy and slow, as there are $#sym.tilde 100,000$ convolutions needed, which all span $#sym.tilde 1000$ data points. This method was found to take #sym.tilde 1 second per spectrum, which would be infeasible for analysing $1000$s of spectra. 

To speed this up, we use the method shown in @diagram-wavelength-downsampling-procedure. This takes advantage of Nyquist's theorem. We first directly downsample (without using a convolution) the original PHOENIX spectra to a wavelength grid which has ~5 points per resolution width. We _then_ convolve this with the Gaussian LSF. Finally, we linearly interpolate this data onto the desired wavelength points.

As per Nyquist's theorem, the initial downsample only removes information on scales much less than the desired resolution, and the final convolution generates the correct end result.

// For simplicity, we assume a constant wavelength resolution over the desired wavelength range. This means that the linear interpolation correctly rebins the fluxes onto the new wavelengths. In reality, the resolution of spectroscopic instruments is wavelength dependent.#footnote[In this case, the final rebinning step could be done using a code such as `SpectRes` @Spectres, which rebins fluxes correctly even over a non-uniform wavelength grid.]

#figure(
  image("../../illustrative_diagrams/wavelength_downsampling_procedure.svg", width: 100%),
  caption: [
    The process used to simulate an observational spectrum with resolution 1 nm, starting from high resolution PHOENIX data. The spectrum is downsampled to a "safe" resolution of $#qty(1 / 5, "nm")$. It's then convolved with a simulated LSF, which is modelled as a Gaussian. Finally, the fluxes are rebinned to a wavelength array of resolution $#qty(1, "nm")$. The final plot also includes the final spectrum calculated by convolving directly with the high resolution PHOENIX spectrum (shifted down by $0.1$ Jy for visibility). The error between these two methods is negligible. This confirms that our computationally efficient downsampling method does not alter the final simulated spectrum. All downsampling is done using `SpectRes` @Spectres which correctly rebins fluxes whilst preserving the total flux. `SpectRes` also works when rebinning to or from non-uniform wavelength arrays, such as the first downsample from the non-uniform PHOENIX wavelengths. Downsampling removes features smaller than the resolution and reduces line depths. The removal of these features makes fitting more difficult. The PHOENIX spectrum used in this illustration has parameters $T_"eff" = #qty(4000.0, "K")$, [Fe/H] = 0.5 dex and $log g$ = 3.0 dex.
  ],
  placement: top,
) <diagram-wavelength-downsampling-procedure>

=== Normalisation

// convolutions
// convert to janskys
// normalise - reason why this is a valid normalisation and have a good couple of sentences for why not: integrate and average & why not do everything after minusing out a black body spectrum.
// [little explanation of the different approaches which are possible - can link back to the section on how this is all done for one-component]
// need to say somewhere in methodology we are doing this on simulated stars

In order for our $f_i$ factors to correctly represent the area-covering fraction of the components, we need to normalise both the simulated PHOENIX spectra and the observed spectrum. We normalise all spectra to have a mean flux of $1$.

// this is wrong: to find an integral numerically, a uniform wavelength range doesnt really matter! still need simpsons rule or whatevs to get a better integral than just a riemann sum
// Since we downsample the PHOENIX spectra to a uniform wavelength range, our numerical integral is equivalent to

// $ integral F(lambda) "d"lambda = Delta lambda sum_lambda F(lambda) $

// making it simple to carry out this normalisation.
// A simple way to do this which is often used in literature is [okay idk].
