== Overview

=== Transmission Spectra

[intro - what are transmission spectra, very brief note on their history e.g. how long has this been possible. maybe mention upcoming transit missions or one or two famous transit measurements - prove this field is relevant]

A key component of habitability research is analysis of extrasolar planets, including their atmospheres. Transmission spectra are one method of determining the species present within an exoplanet's atmosphere, which gives hints to possible signs of life through biosignatures, as well as the planet's evolution and geological processes. [refs]

If an exoplanet crosses the line of sight between its host star and Earth, starlight will pass through its atmosphere. Various mechanisms [list them] will cause a wavelength-dependent absorption or amplification of this starlight as it interacts with the species present within the atmosphere. The intensity shift caused by the atmosphere is given by:

delta = 2 Rp H / R\*^2 (delta-equation)

where H = NHsc = N k_b T / mu m_H g

Rp is the planet radius, R\* is the stellar radius, N is a dimensionless factor describing the strength of the interaction, H_sc is the scale height of the atmosphere, mu is the molecular mass of the planet's atmosphere and g is the surface gravity of the planet. [refs for this formula]

Atmospheric retrievals can be used on the decontamined // cleaned spectra to determine the content of the atmosphere. [ref].

=== Why M dwarfs?

[formula from lectures about why m dwarfs & then explain why m dwarfs]
[give the formula for the actual signal. give typical orders of magnitudes of the parameters for different star-planet pairs, and compare this to current / future instrumentation]
[insert table of exoplanet-star type pair, the parameters which define them and then an estimated order of magnitude of delta. then give the SNR needed by modern instrumentation to see this. then conclude that m dwarfs are good for reasons. use https://cambridgelectures.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=d1acdc7e-9fd1-442c-8079-b3b700ed0a18 at 31:00 ish to help.]

(delta-equation) places constraints on the planet-star systems which are most favourable for atmospheric analysis. Ideally, we want to search for configurations which maximise delta whilst keeping the planet habitable. [table ref] shows the approximate signal strength for different systems, and we can see…

[insert table with different configurations, inc earth-like around sun-like etc. maybe have another column of a real-life example of this configuration]

The signal-to-noise ratio (SNR) of a measurement is given by:

SNR = delta / sigma

where sigma = ?

Measuring an Earth-like planet around a sun-like star is of key interest to exoplanetary research [ref]. However, [table] shows that, even if such a system was detected, its delta signal would likely be below the minimum needed by space-based observations. If we wish to measure an Earth-like planet, then we must decrease R_s to increase our delta and our SNR. This corresponds to smaller stars, such as M dwarfs. This is one of the primary reasons why M dwarfs feature heavily in exoplanet surveys. [ref]

[also need to explicitly state why IR]

=== Atmospheric Retrievals & Data Analysis

Astronomical databases often provide calibrated spectra, which take into account the wavelength dependent sensitivity of the instrument, etc [expand on this & ref jwst docs]. , For example, JWST's stage 2 pipeline [maybe be more specific about which] deals with [list effects]. Since there are multiple ways [list them] to isolate the contribution from the exoplanet, this is not done by the instrument pipeline, and further steps must be taken before atmospheric analysis can be done. Since this project focuses on the JWST pipeline, we do not calibrate the spectra, although we need to be aware of any possible systematics in the data [list them. if we do a jwst section a discussion of any possible instrument systematics or errors might be nice].

The total spectrum outputted by such a calibrated pipeline is the stellar signal, with the exoplanet's signal imprinted on top. In order to carry out an atmospheric retrieval [ref to a madhu paper on retrievals], we need an accurate spectrum produced by only the planet with the stellar signal removed. In theory, this would leave us with only the absorption or emission lines [is that valid? idk what an increase in amplitude is called here] produced by the planet, as given by (delta-equation). This can then be used to carry out analysis of the species present within the atmosphere, which is the main goal of transmission spectroscopy. [ref cos idk if there are any other purposes. but i think this is true?]

Typically, the disc-integrated / average spectrum captured before transit is subtracted from the total spectrum to give the exoplanet's contribution.[ref papers] However, this neglects any variability across the stellar surface, which leads to errors described by the transit light source effect (see section [insert link]). To increase the SNR, an average of multiple pre-transit measurements is usually taken.[ref(s) in the literature that do this / say that they do this / say that this reduces SNR]

[maybe talk about sources of SNR?]

=== Typical Pipelines // THE DISC-INTEGRATED SPECTRUM

[discuss how this is done for one component only // how the disc-integrated spectrum is found]

There are multiple methods used in the literature to determine the disc-integrated pre-transit spectrum. This involves determining the stellar parameters, such as T F L, that most closely reproduce the observed spectrum.

==== Chi Squared

A Chi-squared method aims to minimise the residual between a simulated and observed spectrum by varying the simulated spectrum's input parameters. For example, [https://www.aanda.org/articles/aa/pdf/2018/07/aa32312-17.pdf] vary the T F L of spectra generated using the PHOENIX-ACES model. The residual is calculated using:

[insert formula for chi-squared]

and a minimisation routine [which? even just give examples, maybe find some other papers that maybe do this with least squared instead of chi-squared, etc] is used to find the T F L values which minimises the error. In order to understand the degeneracy between the parameters, a brute force search can be done over a given range of parameters and a colourmap of the chisquared value can be produced. This yields the shape and size of the minimum.

Interpolation can be used to improve the resolution of this method [chi squared ref again]. Exhaustively simulating spectra at a resolution of ~[insert chi squared ref's resolution for all parameters] resolution would take too long [ref]. instead, [linearly?] interpolating spectra (along multiple dimensions) allows us to search the parameter space in finer detail. Furthermore, some degeneracy between the parameters can be reduced [or removed?] by approximating log g with the photometric log g [https://www.aanda.org/articles/aa/pdf/2021/12/aa41584-21.pdf & https://arxiv.org/abs/2101.02242 & maybe ref the chi squared paper again] [do i need to explain this idk].

[insert equation for photometric log g determination; would be cool to use this on some simulated or observational targets to see if it agrees with the mcmc fitted values. gives an extra graph]

==== MCMC

==== Line depths

Empirical relations have been determined which link the line depth ratio (LDR) between a given pair of absorption lines and the stellar parameters T_eff and log g. For example, [https://arxiv.org/pdf/2106.09995] describe pairs of Fe i–Fe ii, Ca i–Ca ii and Fe i–Fe i line pairs which can be used to determine Teff and log g to a resolution of 50K and 0.2 dex respectively. The downside of this approach is that it requires spectra of a much higher resolution than space-based telescopes, making it not suitable for analysing HST or JWST spectra. [maybe mention the actual required resolution of ~28k specified by that LDR article] [should i mention which telescopes can use this method? or is that just extraneous?]

==== ML

[idk]

=== Degeneracies
// [maybe move some / the bulk of the discussion of this to results? idk. also this should maybe be above the previous section as the previous section refs degeneracies implicitly]

[probably good to put this here: can link back into the chi squared method and how that paper increased contrast // reduced the degenerate area.]
[photometric log g]
[FeH variation]
[include how much each of the parameters we are varying change]

== THE TRANSIT LIGHT SOURCE EFFECT

The section of the stellar surface which illuminates the exoplanet's atmosphere in the direction of our line of sight is only a circular region behind the planet. Over the course of a transit, the planet sweeps out a region called the transit chord, and it is only this region which affects the measured spectra. Therefore, if spots or faculae are present, the true illuminating spectrum will differ from the disc-integrated spectrum.

There are two broad cases of heterogeneities - occulted and unocculted spots - which are dealt with in different ways.

=== OCCULTED HETEROGENEITIES

Perhaps paradoxically, spots which are contained within the transit chord and which directly contribute to the illuminating spectrum are typically easier to address [ref]. This is because, if the heterogeneity is of sufficient size [what size? if its smaller than this can it still affect the spectrum or at that point will it not affect it much?], the transit curve will appear asymmetrical. This provides a clear sign that a heterogeneity is present and must be removed, which differs from the case of unocculted spots.

Furthermore, there is already a python package, starry, that can be used to infer properties of a heterogeneous stellar surface using spherical harmonics. [https://ui.adsabs.harvard.edu/abs/2019AJ....157...64L/abstract] This has been used in the literature to directly model starspots. [https://iopscience.iop.org/article/10.3847/1538-3881/adf72f/pdf]

=== UNOCCULTED HETEROGENEITIES

Unocculted heterogeneities are usually harder to detect and more challenging to remove from the measured spectrum. An unocculted faculae (hotter region) increases the average surface temperature to be higher than the true illuminating spectrum of the exoplanet. Generally therefore, using the disc integrated spectrum will over-subtract at lower wavelengths, and under-subtract at higher wavelengths. Furthermore, the depth and presence of molecular features varies with temperature [ref]. Therefore, not using the true illuminating spectrum in your analysis can lead to falsely attributing stellar spectral features to the exoplanet.

[maybe mention that not many papers deal with this effect? idk. maybe ref some recent ones that explicitly say they assume a disc integrated spectrum? or ref the few that are now beginning to do it - e.g.  Sarah E. Moran et al 2026 ApJL 948 L11 ? idk]

The major issue presented by unocculted heterogeneities is that the false features they create can easily be mistaken as true molecular features [ref to trappist1 paper here: https://iopscience.iop.org/article/10.3847/1538-3881/aade4f, and maybe find some others]. [maybe say "determining this is therefore important" but idk if that should even be in a theory section - maybe it should be in the introduction - and maybe its just implicit / unnecessary anyway?]. Even when stellar variability is suspected of contaminating a spectrum, the features may be consistent with a large range of spot distributions (see section [section of our results that discusses degeneracies]), [ref papers which say "stellar variability is consistent with lots of range of parameters" - the rackham one about trappist 1 (above) and maybe some others]. This makes distinguishing molecular features from contamination in active stars, such as [maybe add a qualifier like young/old here] M dwarfs, more complex.