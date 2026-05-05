Most commonly, the fitting methods described in @TypicalPipelines are used to find 1 set of parameters which best describe the stellar spectrum. This implicitly ignores any variability across the stellar surface. If the stellar surface contains heterogeneities, such as is common for M dwarfs, this leads to errors in the fitting procedure. Spots or faculae may produce spectral features which, together with the background photospheric spectrum of the star, cannot all be described by 1 set of stellar parameters.

This work builds on existing studies in this area by trying to find a more accurate fit for a given observed spectrum. In theory, this can be used to determine the presence of unocculted heterogeneities, helping to prevent stellar contamination within the exoplanet's signal.

Our pipeline simulates an M star's output as measured at a given SNR and resolution, and then uses an MCMC model to decompose it back into the input components. This serves as a proof-of-concept of our model.

// [just give an overall summary as to what your code does i.e.:
//   [simulates m dwarf]
//   [global optimiser]
//   [MCMC]
// }
// as explained in <unocculted-heterogeneities-section>
// , whilst ensuring our fitting parameters remain physical and explainable.

== Beyond the Disc-Integrated Spectrum

=== Spectral Components

To account for the variation in $T_"eff"$ across a stellar surface, we can approximate the stellar spectrum as being a sum of components. Each component has a different $T_"eff"$ and contributes towards the total spectrum according to some weight $f$, which is interpreted as the area-covering fraction that the spot or faculae contributes to the total flux $F_"tot"$. Hence
// #footnote[$f$ is also affected by limb darkening - see @LimbDarkening]

$ bold(F)_"tot" = sum_(i=1)^N f_i bold(F)_i $ <ComponentEquation>

where $N$ is the total number of components being considered, $F_i$ is the normalised flux contributed by the $i$th component, $f_i$ is the weight of the $i$th component, and $F_"tot"$ is the total normalised flux from the star. As explained in @ReducingDegeneracies, the [Fe/H], and $log g$ is assumed to be constant across all components to ensure our results are physical. To further prevent degeneracies, this work focuses on 2 component models.

We wish to find the stellar parameters, along with corresponding area-covering fractions $f$, which best replicate a given total spectrum $bold(F)_"tot"$. Often, this will give a range of possible spot configurations,  all of which we can interpret as being consistent with the stellar signal. This provides key information on any spectral features which could be misinterpreted as atmospheric signals from the exoplanet, as well as to how variable the host star is.

One of these components represents the photospheric temperature, which will usually cover most of the star. If the star were not variable but instead wholly homogeneous, this photospheric component would be the only contributing factor to the spectrum. Any other components which our method finds are interpreted as spots or faculae on the stellar surface.

// [explain how this might redden spots]
// [okay i actually dont know how redenning would affect things but i assume it would not be 100% equivalent to lowering the temperature? like its going to cause an overall shift to a higher wavelength sure but it might also change the spectral lines in other ways? like its going to shift the spectrum without modifying which lines are present etc so I think this might deserve a paragraph]

// [say that simulating limb darkening is often ignored and is outside the scope of this? maybe find a paper that _reasons_ why limb darkening can be ignored and mention that]
