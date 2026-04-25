== This Work

=== SPECTRAL COMPONENTS

To account for the variation in parameters such as T_eff log g and FeH across a stellar surface, we can approximate the stellar spectrum as being a sum of components F_tot:

[just bam in the formala of what we are trying to approximate from the interim report]

where w_(T F L) is the weight of the (T F L) component and F_{T F L} (lambda) is the flux at wavelength lambda from a spectrum with parameters T F L. The weights then represent how much a given component contributes to the spectrum, and can be interpreted as the area-covering fraction of the corresponding spot or facula (neglecting limb darkening - see section [insert link to limb darkening section])

[little explanation of the different approaches which are possible - can link back to the section on how this is all done for one-component]

=== EFFECTS OF LIMB DARKENING

// https://iopscience.iop.org/article/10.3847/1538-4357/ad0369 - talks about reddening

[explain limb darkening]

Photons originating from different positions within a star travel on different paths through the stellar material to reach us. Since the effective temperature of the photosphere decreases with radius, the edges of a star appear redder than the center. [ref] Furthermore, optical depth decreases when viewing the star further from its center [ref], so the brightness at the edge of a star is lower than at the center. This is a wavelength dependent effect [is it? or is the reddenning part the wavelength dependent bit?] and is of order 10% [ref - maybe the diagram from pettinis notes (might be able to find a link in our chat with dylan) or the source of that diagram if its from a paper etc].

[ref the things that wikepedia refs. wiki page is here: https://en.wikipedia.org/wiki/Limb_darkening]

This dimming means that the weights in equation [ref] are not necessarily the actual area covering fractions. A spot or facula at the edge of a disc will appear dimmer than one of the same size at the center of the disc. If we ignore this effect, our optimised weights in equation [ref] [okay but wait i ahven't mentioned what or how we're optimising yet] will underestimate the size of any spots near the edge of the star, as they would in reality be larger to produce the same intensity.

[explain how this might redden spots]
[okay tbh i actually dont know how redenning would affect things but i assume it would not be 100% equivalent to lowering the temperature? like its going to cause an overall shift to a higher wavelength sure but it might also change the spectral lines in other ways? like its going to shift the spectrum without modifying which lines are present etc so I think this might deserve a paragraph]

[say that simulating limb darkening is often ignored and is outside the scope of this? maybe find a paper that _reasons_ why limb darkening can be ignored and mention that]
