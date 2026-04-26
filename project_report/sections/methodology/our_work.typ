// should this be in the methodology section? like is the theory that this work is contributing classed as theory or methodology?

== Beyond the Disc-Integrated Spectrum

=== Spectral Components

To account for the variation in $T_"eff"$ across a stellar surface, we can approximate the stellar spectrum as being a sum of components. Each component has a different $T_"eff"$ and contributes towards the total spectrum according to some weight $f$, which is interpreted as the area-covering fraction#footnote[$f$ is also affected by limb darkening - see @LimbDarkening] that the spot or faculae contributes to the total flux $F_"tot"$:

$ bold(F)_"tot" = sum_(i=1)^N f_i bold(F)_i $ <ComponentEquation>

where $N$ is the total number of components being considered, $F_i$ is the normalised flux contributed by the $i$th component, $f_i$ is the weight of the $i$th component, and $F_"tot"$ is the total normalised flux from the star. As explained in @ReducingDegeneracies, the [Fe/H] and $log g$ is assumed to be constant across all components to ensure our results are physical. To further prevent degeneracies, this work focuses on 2-component models.

Hence, in our case, we wish to find 2 or 3 stellar parameters, along with corresponding area-covering fractions $f$, which best replicate a given total spectrum $bold(F)_"tot"$. Often, this will give a range of possible spot configurations,  all of which we can interpret as being consistent with the stellar signal. This provides key information on any spectral features which could be misinterpreted as atmospheric signals from the exoplanet, as well as to how variable the host star is.

One of these components represents the photospheric temperature, which will usually cover most of the star. If the star was not variable but instead wholly homogoneous, this photospheric component would be the only contributing factor to the spectrum. Any other components which our method finds are due to spots or faculae on the stellar surface.

=== Normalisation

// convolutions
// convert to janskys
// normalise - reason why this is a valid normalisation and have a good couple of sentences for why not: integrate and average & why not do everything after minusing out a black body spectrum.
// [little explanation of the different approaches which are possible - can link back to the section on how this is all done for one-component]
// need to say somewhere in methodology we are doing this on simulated stars

In order for our $f_i$ factors to correctly represent the area-covering fraction of the components, we need to normalise both the simulated PHOENIX spectra and the observed spectrum. A simple way to do this which is often used in literature is 

=== Effects of Limb Reddening & Darkening <LimbDarkening>

Photons originating from different positions within a star travel on different paths through the stellar material to reach us. Since the effective temperature of the photosphere decreases with radius, the edges of a star appear redder than the center. @LimbReddeningGraphPaper Furthermore, optical depth decreases when viewing the star further from its center, so the brightness at the edge of a star is lower. @LimbDarkeningReview

// and is of order ??? in the IR [ref - maybe the diagram from pettinis notes (might be able to find a link in our chat with dylan) or the source of that diagram if its from a paper etc].

This dimming means that the weights in equation [ref] are not precisely the actual area covering fractions. A spot or facula at the edge of a disc will appear dimmer than one of the same size at the center of the disc. Since we ignore this effect, our optimised weights in @ComponentEquation will underestimate the size of any spots near the edge of the star, as they would need to be larger to produce the same intensity. Furthermore, heterogeneities at the edge of a star will appear redder, which will shift their spectral energy distribution towards higher wavelengths. This may change the fitted value of $T_"eff"$, as spectra with lower $T_"eff"$ also peak at higher wavelengths. Simulating these effects within our pipeline is outside the scope of this work.

// [explain how this might redden spots]
// [okay i actually dont know how redenning would affect things but i assume it would not be 100% equivalent to lowering the temperature? like its going to cause an overall shift to a higher wavelength sure but it might also change the spectral lines in other ways? like its going to shift the spectrum without modifying which lines are present etc so I think this might deserve a paragraph]

// [say that simulating limb darkening is often ignored and is outside the scope of this? maybe find a paper that _reasons_ why limb darkening can be ignored and mention that]
