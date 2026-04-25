#import "@preview/unify:0.8.0": qty, unit, num

== Stellar Heterogeneities

=== Spots and Faculae

[define them]

[what leads to them]

[say that we use spots to mean either spots or faculae for simplicity]

=== Why are M dwarfs more variable?

== Transmission Spectra

// === Overview

=== Transit Depth

If an exoplanet crosses the line of sight between its host star and Earth, it will block part of the starlight from reaching us, which we measure as a temporary drop in intensity. This is called a transit and the fractional drop in flux recieved is called the transit depth. The transit depth is given by:

$ Delta = (R_p / R_ast)^2 $ 

where $R_p$ is the planet radius and $R_ast$ is the host star's radius. @LauraExoplanetReview

Plotting the transit depth as a function of time produces a transit curve or a light curve. // which can be used to determine parameters such as planetary radius and density. [maybe say what transit curves are used to determine. or maybe move that to talking about the transit light source affecting results derived from light curves]

=== Atmospheric Signal

// [maybe mention upcoming transit missions or one or two famous transit measurements - prove this field is relevant. maybe add the date of the first exoplanet transmission spectrum and the first jwst spectrum and evidence that this field is evolving rapidly]

A key component of habitability research is analysis of extrasolar planets, including their atmospheres. Transmission spectra are one method of determining the species present within an exoplanet's atmosphere, which gives valuable hints to signs of life through biosignatures, as well as the planet's evolutionary history and climate. @LauraExoplanetReview

During an exoplanet's transit, starlight will pass through its atmosphere (if one is present). Any species present within the atmosphere will cause a wavelength-dependent absorption or amplification of this starlight, imprinting an exoplanetary signal ontop of the stellar signal. The total intensity shift is given by:

$ delta approx (2 H R_"p") / R_ast^2 $ <delta-equation>

where $ H = N H_"sc" = (N k_B T) / (mu m_H g) $

and  $N$ is a dimensionless factor describing the number of scale heights crossed at high opacity, $H_"sc"$ is the scale height of the atmosphere, $mu$ is the molecular mass of the planet's atmosphere and $g$ is the surface gravity of the planet. $N$ is wavelength-dependent and determines the spectrum of the exoplanet that is imprinted on top of the stellar signal. @delta-equation assumes $R_p << R_*$. @LauraExoplanetReview

Atmospheric retrievals can be used on the extracted exoplanet signal to determine the content of the atmosphere. @MadhusudhanAtmosphericRetrievals

=== Why M dwarfs?

Measuring an Earth-like planet around a sun-like star is of key interest to exoplanetary research. @SunlikeAroundEarth However, if such a system was detected, its transit signal would likely be below the minimum needed by space-based observations for detection or analysis. If we wish to measure an Earth-like planet, one approach is to look for hosts with a small $R_*$, increasing our measured $delta$ and signal-to-noise ratio (SNR). This corresponds to smaller stars, such as M dwarfs. This is one of the primary reasons why M dwarfs feature heavily in exoplanet surveys: small planets around small stars are easier to detect and analyse. @SHIELDS20161

Furthermore, M dwarfs are the most numerous main-sequence stars in the Milky-Way. Due to their low luminosity, their habitable zones (HZ) are closer in, meaning that any exoplanets in the HZ would have a more favourable orbit geometry and be more convenient to analyse with transit spectroscopy. @ExoplanetMDwarfStatistics

@delta-equation places constraints on the planet-star systems which are most favourable for atmospheric analysis. Ideally, we want to search for configurations which maximise the exoplanet signal $delta$, whilst staying in a regime where any detected planet could be habitable. @table-Mdwarf-signal shows the approximate signal strength for different systems. Since M dwarf hosts are smaller, they place the atmospheric signal for an Earth-like planet within range of being detected by space-based instruments such as the James Webb Space Telescope (JWST). One example of such a planet which has been characterised by JWST is LHS 475b, discovered in early 2023. @LustigYaeger2023

#figure(
  table(
    columns: (auto, auto, auto, auto),
    inset: 7pt,
    align: center,
    stroke: none,
    
    // Toprule
    table.hline(stroke: 1.5pt),
    
    // Header
    [Host star], [Planet], [$Delta \/ "ppm"$], [$delta \/ "ppm"$],
    
    // Midrule
    table.hline(y: 1, stroke: 0.5pt),
    
    [Sun-like], [Earth-like],  [100], [1],
    [M dwarf], [Earth-like],  [1000], [10],

    // Bottomrule
    table.hline(stroke: 1.5pt),
  ),
  caption: [
    Approximate transit depths and atmospheric signal strengths for an Earth-like planet around different stars. Late M dwarfs have radii $#sym.tilde 0.25 R_dot.o$ @MDwarfSizes, leading to an order of magnitude increase in signal. Larger planets such as sub-Neptunes, with radii of $#sym.tilde 2.5 R_plus.o$0 @SuperEarthSizes, can increase the signal further. JWST can constrain atmospheric signals to \~50 ppm. @LustigYaeger2023
  ],
) <table-Mdwarf-signal>

// [maybe have another column of a real-life example of this configuration]

The signal-to-noise ratio (SNR) of a transmission spectrum at a certain wavelength is given by:

$ "SNR" = delta / sigma $ <SNR-equation>

where $sigma$ is the noise intensity. @Zhou2013 In order to maximise the SNR of our data, its necessary to measure near the peak of the exoplanet's spectrum. This corresponds to the near and mid infrared, motivating why many ground-based and space-based instruments target this range. @Encrenaz2014

=== Atmospheric Retrievals & Data Analysis

Astronomical databases often provide calibrated spectra, which take into account the wavelength dependent sensitivity of the instrument, etc [expand on this & ref jwst docs]. , For example, JWST's stage 2 pipeline [maybe be more specific about which] deals with [list effects]. Since there are multiple ways [list them] to isolate the contribution from the exoplanet, this is not done by the instrument pipeline, and further steps must be taken before atmospheric analysis can be done. Since this project focuses on the JWST pipeline, we do not calibrate the spectra, although we need to be aware of any possible systematics in the data [list them. if we do a jwst section a discussion of any possible instrument systematics or errors might be nice].

The total spectrum outputted by such a calibrated pipeline is the stellar signal, with the exoplanet's signal imprinted on top. In order to carry out an atmospheric retrieval [ref to a madhu paper on retrievals], we need an accurate spectrum produced by the planet with the stellar signal removed. This leaves us with only the absorption or emission lines produced by the planet, as given by (delta-equation). This can then be used to carry out analysis of the species present within the atmosphere, which is the main goal of transmission spectroscopy. [ref cos idk if there are any other purposes. but i think this is true?]

Typically, the disc-integrated / average spectrum captured before transit is subtracted from the total spectrum to give the exoplanet's contribution.[ref papers] However, this neglects any variability across the stellar surface, which leads to errors described by the transit light source effect (see section [insert link]). To increase the SNR, an average of multiple pre-transit measurements is usually taken.[ref(s) in the literature that do this / say that they do this / say that this reduces SNR]

[maybe talk about sources of SNR?]

== Typical Pipelines & The Disc-Integrated Spectrum

Typically, the average stellar spectrum pre-transit is measured, and assumed to be the illuminating spectrum during transit. @Rackham-2018 There are multiple methods used to determine the disc-integrated pre-transit spectrum. This involves determining the stellar parameters, such as $T_"eff"$ metallacity, and $log g$, that most closely reproduce the observed spectrum.

=== Chi Squared

$chi^2$ methods aim to minimise the residual between a simulated and observed spectrum by varying the simulated spectrum's input parameters. For example, #cite(<PasseggerCARMENES>, form: "prose") vary the $T_"eff", ["Fe"\/"H"] "and" log g$ of spectra generated using the PHOENIX-ACES model. The residual is calculated using:

[insert formula for chi-squared]

and a minimisation routine [which? even just give examples, maybe find some other papers that maybe do this with least squared instead of chi-squared, etc] is used to find the T F L values which minimises the error. In order to understand the degeneracy between the parameters, a brute force search can be done over a given range of parameters and a colourmap of the chisquared value can be produced. This yields the shape and size of the minimum.

Interpolation can be used to improve the resolution of this method [chi squared ref again]. Exhaustively simulating spectra at a resolution of ~[insert chi squared ref's resolution for all parameters] resolution would take too long [ref]. instead, [linearly?] interpolating spectra (along multiple dimensions) allows us to search the parameter space in finer detail. Furthermore, some degeneracy between the parameters can be reduced [or removed?] by approximating log g with the photometric log g [https://www.aanda.org/articles/aa/pdf/2021/12/aa41584-21.pdf & https://arxiv.org/abs/2101.02242 & maybe ref the chi squared paper again] [do i need to explain this idk].

[insert equation for photometric log g determination; would be cool to use this on some simulated or observational targets to see if it agrees with the mcmc fitted values. gives an extra graph]

=== MCMC

=== Line depths

Empirical relations have been determined which link the line depth ratio (LDR) between a given pair of absorption lines and the stellar parameters T_eff and log g. For example, #cite(<Matsunaga_2021>, form: "prose") describe Fe i–Fe ii, Ca i–Ca ii and Fe i–Fe i line pairs which can be used to determine $T_"eff"$ and $log g$ to a resolution of #qty("50","K") and #num("0.2") dex respectively. The downside of this approach is that it requires spectra of a much higher resolution than space-based telescopes, making it not suitable for analysing HST or JWST spectra. 

// [maybe mention the actual required resolution of ~28k specified by that LDR article]
// [should i mention which telescopes can use this method? or is that just extraneous?]

=== ML

[idk]

== Degeneracies <Degeneracies>
// [maybe move some / the bulk of the discussion of this to results? idk. also this should maybe be above the previous section as the previous section refs degeneracies implicitly]

[probably good to put this here: can link back into the chi squared method and how that paper increased contrast // reduced the degenerate area.]
[photometric log g]
[FeH variation]
[include how much each of the parameters we are varying change]

== The Transit Light Source Effect

(maybe say: see TRAPPIST 1 [ref paper that says how TRAPPIST-1 water features are consistent with stellar variability])

The section of the stellar surface which illuminates the exoplanet's atmosphere in the direction of our line of sight is only a circular region behind the planet. Over the course of a transit, the planet sweeps out a region called the transit chord, and it is only this region which affects the measured spectra. Therefore, if spots or faculae are present, the true illuminating spectrum will differ from the disc-integrated spectrum.

There are two broad cases of heterogeneities - occulted and unocculted spots - which are dealt with in different ways.

=== Occulted Heterogeneities

Perhaps paradoxically, spots which are contained within the transit chord and which directly contribute to the illuminating spectrum are typically easier to address [ref]. This is because, if the heterogeneity is of sufficient size [what size? if its smaller than this can it still affect the spectrum or at that point will it not affect it much?], the transit curve will appear asymmetrical. This provides a clear sign that a heterogeneity is present and must be removed, which differs from the case of unocculted spots.

Furthermore, there is already a python package, starry, that can be used to infer properties of a heterogeneous stellar surface using spherical harmonics. @Luger_2019 This has been used in the literature to directly model starspots. @Tamburo2025

=== Unocculted Heterogeneities

Unocculted heterogeneities are usually harder to detect and more challenging to remove from the measured spectrum. An unocculted faculae (hotter region) increases the average surface temperature to be higher than the true illuminating spectrum of the exoplanet. Generally therefore, using the disc integrated spectrum will over-subtract at lower wavelengths, and under-subtract at higher wavelengths. Furthermore, the depth and presence of molecular features varies with temperature [ref]. Therefore, not using the true illuminating spectrum in your analysis can lead to falsely attributing stellar spectral features to the exoplanet.

[maybe mention that not many papers deal with this effect? idk. maybe ref some recent ones that explicitly say they assume a disc integrated spectrum? or ref the few that are now beginning to do it - e.g.  Sarah E. Moran et al 2026 ApJL 948 L11 ? idk]

The major issue presented by unocculted heterogeneities is that the false features they create can easily be mistaken as true molecular features [ref to trappist1 paper here: https://iopscience.iop.org/article/10.3847/1538-3881/aade4f, and maybe find some others]. [maybe say "determining this is therefore important" but idk if that should even be in a theory section - maybe it should be in the introduction - and maybe its just implicit / unnecessary anyway?]. Even when stellar variability is suspected of contaminating a spectrum, the features may be consistent with a large range of spot distributions (see section [section of our results that discusses degeneracies]), [ref papers which say "stellar variability is consistent with lots of range of parameters" - the rackham one about trappist 1 (above) and maybe some others]. This makes distinguishing molecular features from contamination in active stars, such as [maybe add a qualifier like young/old here] M dwarfs, more complex.