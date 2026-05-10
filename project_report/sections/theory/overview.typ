#import "@preview/unify:0.8.0": qty, unit, num
#import "@preview/cetz:0.5.2": canvas, draw

== M Dwarf Activity - Spots and Faculae

Heterogeneities on the stellar surface, or photosphere, can be grouped into 2 categories. Spots are cooler regions, and faculae are hotter regions. These heterogeneities occur due to magnetic activity at the stellar surface @GouldingVariabilityThesis.

The most obvious candidate for observing spots and faculae is our own sun, and a significant amount of research has been carried out in this field over the last two centuries. However, spot distributions on other stars have also been measured, both directly through interferometry, and indirectly through transit curves.

The majority of M dwarfs have been found to exhibit surface activity, often being variable over both long and short timescales @MDwarfTemperatures. This presents an extra challenge for transit spectroscopy in M dwarf systems, as significant activity can cause stellar contamination when analysing exoplanets (see @TransitLightSourceEffect).

// maybe ref this interferometry & direct imaging & transit curve observation fact
// Sunspots consist of a cool central region called the umbra, surrounded by a larger and hotter region called the penumbra.

For simplicity, this report uses the term "spot" to mean any region of temperature variation, including both hotter and cooler regions (unless a distinction is required within a physical interpretation or discussion).

== Transmission Spectra

// === Overview

=== Transit Depth

If an exoplanet crosses the line of sight between its host star and Earth, it will block part of the starlight from reaching us, which we measure as a temporary drop in intensity. This is called a transit, and the fractional drop in flux received is called the transit depth. The transit depth is given by @LauraExoplanetReview

$ Delta = (R_p / R_ast)^2 $

where $R_p$ is the planet radius and $R_ast$ is the host star's radius.

Plotting the transit depth as a function of time produces a transit curve or a light curve. // which can be used to determine parameters such as planetary radius and density. [maybe say what transit curves are used to determine. or maybe move that to talking about the transit light source affecting results derived from light curves]

=== Atmospheric Signal

// [maybe mention upcoming transit missions or one or two famous transit measurements - prove this field is relevant. maybe add the date of the first exoplanet transmission spectrum and the first jwst spectrum and evidence that this field is evolving rapidly]

A key component of habitability research is analysis of extrasolar planets, including their atmospheres. Transmission spectra are one method of determining the species present within an exoplanet's atmosphere, which gives valuable hints to signs of life through biosignatures, as well as the planet's evolutionary history and climate @LauraExoplanetReview.

During an exoplanet's transit, starlight will pass through its atmosphere (if one is present). Any species present within the atmosphere will cause a wavelength-dependent absorption or amplification of this starlight, imprinting an exoplanetary signal on top of the stellar signal. Assuming $R_p << R_*$, the total intensity shift is given by @LauraExoplanetReview

$ delta approx (2 H R_"p") / R_ast^2 $ <delta-equation>

where $ H = N H_"sc" = (N k_B T) / (mu m_H g) $

and  $N$ is a dimensionless factor describing the number of scale heights crossed at high opacity, $H_"sc"$ is the scale height of the atmosphere, $mu$ is the molecular mass of the planet's atmosphere and $g$ is the surface gravity of the planet. $N$ is wavelength-dependent and determines the spectrum of the exoplanet that is imprinted on top of the stellar signal.

Atmospheric retrievals can be used on the extracted exoplanet signal to determine the content of the atmosphere @MadhusudhanAtmosphericRetrievals.

=== Why study M dwarfs?

Measuring an Earth-like planet around a sun-like star is of key interest to exoplanetary research @SunlikeAroundEarth. However, if such a system were detected, its transit signal would likely be below the minimum needed by space-based observations for detection or analysis. If we wish to measure an Earth-like planet, one approach is to look for hosts with a small $R_*$, increasing our measured $delta$ and signal-to-noise ratio (SNR). This corresponds to smaller stars, such as M dwarfs. This is one of the primary reasons why M dwarfs feature heavily in exoplanet surveys: small planets around small stars are easier to detect and analyse @SHIELDS20161.

Furthermore, M dwarfs are the most numerous main-sequence stars in the Milky Way. Due to their low luminosity, their habitable zones (HZ) are closer in, meaning that any exoplanets in the HZ would have a more favourable orbit geometry and be more convenient to analyse with transit spectroscopy @ExoplanetMDwarfStatistics.

@delta-equation places constraints on the planet-star systems which are most favourable for atmospheric analysis. Ideally, we want to search for configurations that maximise the exoplanet signal $delta$, whilst staying in a regime where any detected planet could be habitable. @table-Mdwarf-signal shows the approximate signal strength for different systems. Since M dwarf hosts are smaller, they place the atmospheric signal for an Earth-like planet within range of being detected by space-based instruments such as the James Webb Space Telescope (JWST). One example of such a planet which has been characterised by JWST is LHS 475b, discovered in early 2023 @LustigYaeger2023.

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
    Approximate transit depths and atmospheric signal strengths for an Earth-like planet around different stars. Late M dwarfs have radii $#sym.tilde 0.25 R_dot.o$ @MDwarfSizes, leading to an order of magnitude increase in signal. Larger planets such as sub-Neptunes, with radii of $#sym.tilde 2.5 R_plus.o$ @SuperEarthSizes, can increase the signal further. JWST can constrain atmospheric signals to \~50 ppm @LustigYaeger2023.
  ],
) <table-Mdwarf-signal>

// [maybe have another column of a real-life example of this configuration]

The signal-to-noise ratio (SNR) of a transmission spectrum at a certain wavelength is given by @Zhou2013

$ "SNR" = delta / sigma $ <SNR-equation>

where $sigma$ is the noise intensity. To maximise the SNR of our data, it's necessary to measure near the peak of the exoplanet's spectrum. This corresponds to the near and mid infrared, motivating why many ground-based and space-based instruments target this range @Encrenaz2014. Furthermore, near infrared observations can reduce the effects of stellar contamination as the spectrum's shape becomes less temperature sensitive @SeagerMidIRContaminationMinimisation.

=== Atmospheric Retrievals & The Disc-Integrated Spectrum

Astronomical databases often provide calibrated spectra, which take into account the wavelength dependent sensitivity of the instrument, and any other necessary calibration steps. This leads to data products which can be directly used for scientific analysis. For example, JWST's stage 2 & 3 pipelines provide calibrated 1 dimensional spectra @StagesofJWSTDataProcessing2025. However, isolating the exoplanet signal from the total spectrum is not done by the JWST pipeline, and further steps must be taken before atmospheric analysis can be done. Since this project focuses on the JWST pipeline, we do not consider any steps related to calibrating the spectra.

// although we need to be aware of any possible systematics in the data [list them. if we do a jwst section a discussion of any possible instrument systematics or errors might be nice].

The total spectrum output by such a calibrated pipeline is the stellar signal, with the exoplanet's signal imprinted on top. In order to carry out an atmospheric retrieval, we need an accurate spectrum produced by the planet with the stellar signal removed. This leaves us with only the absorption or emission lines produced by the planet, as given by @delta-equation. This can then be used to carry out an analysis of the species present within the atmosphere.

The disc-integrated spectrum is a measurement of the total flux from a star, which ignores any spatial variation on its surface. The pre-transit stellar spectrum is measured, and the whole stellar surface is assumed to emit light according to this intensity distribution. In effect, the star is assumed to be spatially uniform. The most common and simplest way of isolating the exoplanetary signal is to subtract the disc-integrated spectrum from the total spectrum during transit to give the exoplanet's contribution @Rackham-2018.

To increase the SNR of the disc-integrated spectrum, an average of multiple pre-transit measurements is usually taken.

// [maybe talk about sources of Noise?]

== Typical Pipelines <TypicalPipelines>

There are multiple methods used to determine the disc-integrated pre-transit spectrum. This involves determining the stellar parameters, such as $T_"eff"$, [Fe/H], and $log g$, that most closely reproduce the observed spectrum.

=== $chi^2$

$chi^2$ methods aim to minimise the residual between a simulated and observed spectrum by varying the simulated spectrum's input parameters. For example, #cite(<PasseggerCARMENES>, form: "prose") vary the $T_"eff", ["Fe"\/"H"] "and" log g$ of spectra generated using the PHOENIX-ACES model. The $chi^2$ value is calculated using:

$ chi^2 = (|bold(F_"model") - bold(F_"observed")|^2) / bold(sigma)^2 $ <ChiSquared>

where $bold(F)$ is a vector containing the spectrum's intensity across the chosen wavelength range, and $bold(sigma)$ contains the noise intensities.

Specific bands or lines are chosen to be used in the minimisation, and then the parameter space is searched to find the global minimum of $chi^2$. The parameters at this minimum, for example $T_"eff"$ $["Fe"\/"H"]$, and $log g$, are interpreted as the best fitting stellar parameters. In order to understand the degeneracy between the parameters, a brute force search can be done over a given range of parameters and a colourmap of the $chi^2$ value can be produced. This yields the shape and size of the minimum.

Interpolation can be used to improve the resolution of this method. Using linear interpolation to search the parameter space in finer detail is much faster than exhaustively simulating spectra with parameter resolutions of $#sym.tilde #qty("10", "K")$ and $#sym.tilde #num("0.01")$ dex.

=== Bayesian Inference

Bayesian inference is a common method to produce posterior distributions of fitting parameters, and has seen recent use to analyse stellar contamination within systems such as LHS 1440b @Cadieux2024. A likelihood is defined which, similar to the $chi^2$ method, describes the error between a fitted spectrum and ground truth. Markov-chain Monte Carlo (MCMC) provides a way to efficiently search the parameter space without the need for brute force.

// maybe ref a conrer plot fig here when we say "corner plots concisely..."
One major advantage of this method is that it naturally produces a way to visualise the degeneracies between all of the varied parameters. Corner plots concisely show the shape and size of the global minimum, as well as the presence of any other nearby minima. The posteriors are visualised using histograms, and the uncertainty for each parameter is generated. Whilst these visualisations are possible with other minimisation methods, Bayesian inference doesn't require a brute force search.
// : itprovides an accepted way to explore the search space efficiently instead.

// PINEAPPLE: say that a non-degenerate fit will have circular plots & WHY

=== Line Depths

Empirical relations have been determined that link the line depth ratio (LDR) between a given pair of absorption lines and the stellar parameters $T_"eff"$ and $log g$. For example, #cite(<Matsunaga_2021>, form: "prose") describe Fe i–Fe ii, Ca i–Ca ii and Fe i–Fe i line pairs which can be used to determine $T_"eff"$ and $log g$ to a resolution of #qty("50","K") and #num("0.2") dex respectively. The downside of this approach is that it requires spectra of a much higher resolution than space-based telescopes, making it not suitable for analysing space-based data, such as spectra produced by HST or JWST. 

// [maybe mention the actual required resolution of ~28k specified by that LDR article]
// [should i mention which telescopes can use this method? or is that just extraneous?]

// === ML

// PINEAPPLE

== The Transit Light Source Effect <TransitLightSourceEffect>

// define photosphere
// This work provides a method that does not strictly require an assumption of homogeneity, and provides a step towards a more accurate way of parameterising M dwarf spectra.
// (maybe say: see TRAPPIST 1 [ref paper that says how TRAPPIST-1 water features are consistent with stellar variability])
// diagrams!
// 
// // PINEAPPLE - create diagram(s) for the transit light source effect

Within the context of exoplanet transmission spectroscopy, stellar heterogeneities can cause significant problems. The section of the stellar surface which illuminates the exoplanet's atmosphere in the direction of our line of sight is only a circular region behind the planet. Over the course of a transit, the planet sweeps out a region called the transit chord, and it is only this region which affects the measured spectra. Therefore, if spots or faculae are present, the true illuminating spectrum will differ from the disc-integrated spectrum. This effect is called the transit light source effect.

This effect can cause stellar contamination. This is where features from the stellar spectrum are not removed from the total transit signal, and are instead attributed to the exoplanet. These are known as false spectral features. This contamination can be confused with biosignatures, such as water features in the TRAPPIST-1 system @Zhang-2018. This highlights how important it is to understand and account for these effects if we want to understand planetary conditions, and potential habitability, in extrasolar systems.

There are two broad cases of heterogeneities - occulted and unocculted spots - which affect the transit curve & spectrum differently, and are hence dealt with in different ways.

#figure(
  align(center)[
  #canvas({
    import draw: *
    scale(x:85%, y: 85%)

    let star_radius = 5.0
    let planet_radius = 1.0
    let spot_1_radius = 0.5
    let spot_2_radius = 0.4
    let spot_3_radius = 0.8
    let spot_1_angle = .7
    let spot_2_angle = 2.85
    let spot_3_angle = 1.6
    let atmosphere_radius = planet_radius * 1.4

    rotate(10deg)
    let a = star_radius * 1.7
    let b = star_radius / 4
    // circle((0, 0), radius: (a, b))
    
    arc((0,0), start: 0deg, stop: 180deg, radius: (a, b), name: "back", anchor: "origin")
    circle((0.0, 0.0), radius: star_radius, fill: rgb("#EF8E38").lighten(20%), name: "star", stroke: 0pt)
    arc((0,0), start: 180deg, stop: 360deg, radius: (a, b), name: "front", anchor: "origin")
    // manually adjust :( idk how to work out these delta theta shifts from moving the arc up/down

    circle("front.50%", radius: planet_radius, fill: white.transparentize(100%), name: "planet", stroke:0pt)

    circle((rel: (calc.cos(spot_1_angle) * planet_radius * 1.2, calc.sin(spot_1_angle) * planet_radius * 1.2), to: "planet"), radius: spot_1_radius, fill: red.darken(20%).transparentize(30%), name: "spot_1", stroke:0pt)
    circle((rel: (calc.cos(spot_2_angle) * planet_radius * 3, calc.sin(spot_2_angle) * planet_radius * 3), to: "planet"), radius: spot_2_radius, fill: red.transparentize(30%), name: "spot_2", stroke:0pt)
    
    circle((rel: (calc.cos(spot_3_angle) * planet_radius * 4, calc.sin(spot_3_angle) * planet_radius * 4), to: "planet"), radius: spot_3_radius, fill: red.lighten(10%).transparentize(30%), name: "spot_3", stroke:0pt)

    rotate(-10deg)
    line(
      "spot_2",
      (-5.1,1),
      stroke: (dash: "dotted", paint: black, thickness: 1pt),
      name: "label_line_2"
    )
    content(
      "label_line_2.end",
      align(center)[Spot \ occulted earlier in the transit],
      anchor: "east",
      padding: .1
    )
    line(
      "spot_1",
      (4.5,-3.5),
      stroke: (dash: "dotted", paint: black, thickness: 1pt),
      name: "label_line_1"
    )
    content(
      "label_line_1.end",
      [Occulted spot],
      anchor: "west",
      padding: .1
    )
    line(
      "spot_3",
      (
        horizontal: (5,0),
        vertical: "spot_3"
      ),
      stroke: (dash: "dotted", paint: black, thickness: 1pt),
      name: "label_line_3"
    )
    content(
      "label_line_3.end",
      [Unocculted facula],
      anchor: "west",
      padding: .1
    )
    rotate(10deg)


    circle("front.50%", radius: atmosphere_radius, fill: white.transparentize(60%), name: "atmosphere", stroke:0pt)
    circle("front.50%", radius: planet_radius, fill: gray.darken(50%).transparentize(0%), name: "planet", stroke:0pt)

    arc((0, atmosphere_radius), start: 180deg + calc.acos(star_radius/a) + .3deg, stop: 360deg - calc.acos(star_radius/a) - .3deg, radius: (a, b), name: "transit_chord_top", anchor: "origin", stroke: (dash: "dashed", paint: black, thickness: 1pt))
    arc((0, -atmosphere_radius), start: 180deg + calc.acos(star_radius/a) + 5.4deg, stop: 360deg - calc.acos(star_radius/a) - 5.4deg, radius: (a, b), name: "transit_chord_bottom", anchor: "origin", stroke: (dash: "dashed", paint: black, thickness: 1pt))

    // rotate(-10deg)
    // let gy = -8.0
    // line((-5, gy), (5, gy), stroke: 0.5pt, name: "x_axis")
    // content((rel: (0.2, 0), to: "x_axis.end"), [Time], anchor: "west")

    // line((-5, gy), (-5, gy + 2.5), stroke: 0.5pt, name: "y_axis")
    // content((rel: (-0.8, 0), to: "y_axis.50%"), [Flux], anchor: "south")

    // let pts = (
    //   "y_axis.80%",
    //   (
    //     rel: (1, 0),
    //     to: "y_axis.80%"
    //   ),
    //   (
    //     rel: (-spot_2_radius, 0),
    //     to: (
    //       horizontal: "spot_2", 
    //       vertical: "y_axis.20%"
    //     )
    //   ),
    //   (
    //     rel: (-spot_2_radius/2, .2),
    //     to: (
    //       horizontal: "spot_2", 
    //       vertical: "y_axis.20%"
    //     )
    //   ),
    //   (
    //     rel: (spot_2_radius/2, .2),
    //     to: (
    //       horizontal: "spot_2", 
    //       vertical: "y_axis.20%"
    //     )
    //   ),
    //   (
    //     rel: (spot_2_radius, 0),
    //     to: (
    //       horizontal: "spot_2", 
    //       vertical: "y_axis.20%"
    //     )
    //   )
    // )
    // catmull(..pts, stroke: black + 1pt, tension: .6)
  })
  ],
  caption: [Illustration of the transit light source effect. An exoplanet is currently transiting its host star, and its atmosphere is partially covering a spot. If not accounted for, all 3 spots will cause stellar contamination in the exoplanet's transmission spectrum. The band between the dashed lines is the transit chord. Spots which overlap the transit chord will directly affect the measured light curve. At this moment, a cooler - and hence dimmer - spot is being covered, which would temporarily increase the received flux and decrease the transit depth. The unocculted spot doesn't cause any time-dependent features in the transit curve.#footnote[This assumes the transit time is much less than the rotational period of the star, which is usually the case for observed exoplanets around M dwarfs.]],// Orbit, planet and atmosphere not to scale.],
)

=== Occulted Heterogeneities

// [what size? if its smaller than this can it still affect the spectrum or at that point will it not affect it much?]
Spots which are contained within the transit chord directly contribute to the illuminating spectrum are typically easier to address @Rackham-2018. This is because, if the heterogeneity is of sufficient size, the transit curve will appear asymmetrical. This provides a clear sign that a heterogeneity is present and must be removed, which differs from the case of unocculted spots. #cite(<Rackham-2018>, form:"prose") note that this variation in the transit curve can be used to determine the $T_"eff"$ and area covering fraction of the spot or facula.

Furthermore, there is already a Python package, `starry`, that can be used to infer properties of a heterogeneous stellar surface using spherical harmonics @Luger_2019. This has been used in the literature to directly model starspots @Tamburo2025. As such, the work presented here does not address occulted heterogeneities, but instead focuses on unocculted ones.

=== Unocculted Heterogeneities

Unocculted heterogeneities are usually harder to detect and more challenging to remove from the measured spectrum. For example, an unocculted faculae (hotter region) increases the average surface temperature to be higher than the true illuminating spectrum of the exoplanet. According to Wein's law

$ lambda_"peak" = b / T $

the peak wavelength of a spectrum is inversely correlated with temperature. In this example, using the disc-integrated spectrum would over-subtract at lower wavelengths, and under-subtract at higher wavelengths. Furthermore, the depth and presence of molecular features varies with $T_"eff"$. Both of these effects lead to stellar spectral features that are not removed from the total signal, which contaminates the derived exoplanet signal. Most importantly, there is no simple warning sign that an unocculted spot is present.

To add to the difficulty, even if stellar variability is suspected of contaminating a stellar spectrum, the features may be consistent with a large range of spot configurations. More specifically, there is likely to be multiple sets of parameters $T_"eff"$, [Fe/H], $log g$ and area-covering fraction which match the observed stellar spectrum. This makes constraining unocculted heterogeneities in active stars, such as M dwarfs, complex.

// [ref papers which say "stellar variability is consistent with lots of range of parameters" - the rackham one about trappist 1 (above) and maybe some others]. 
// 
// [maybe mention that not many papers deal with this effect? idk. maybe ref some recent ones that explicitly say they assume a disc-integrated spectrum? or ref the few that are now beginning to do it - e.g.  Sarah E. Moran et al 2026 ApJL 948 L11 ? idk]


== Degeneracies <Degeneracies>

// [maybe state how each of the parameters T F L alpha/Fe affects the spectum shape / lines. Or maybe that should be in the theory section]
// 
// Degeneracies occur both in single-component models and in models which account for spots or faculae. 
Variations in one stellar parameter can affect the spectrum in a way similar to variations in another parameter. Multi-component models, such as the one proposed in this work, inherently include more dimensions and hence are more vulnerable to degeneracies. However, these degeneracies are still present within simpler 1 component models and must be addressed in order to achieve high resolution, low uncertainty fitting.

=== Physical Basis

// PINEAPPLE

// show some plots of PHOENIX that show clearly how the parameters can change a low res spectrum in ways similar or identical to changes in other parameters 

=== Reducing Fitting Degeneracies <ReducingDegeneracies>

// [maybe move some / the bulk of the discussion of this to methodology? idk. also this should maybe be above the previous section as the previous section refs degeneracies implicitly]

Degeneracies can lead to large, over-inflated minima which contain non-physical or nonsensical parameter values, which is a major problem for any form of minimisation method. The most common ways to prevent this can all be classified as attempts to constrain some of the parameters to physical values.

// need to add ranges of these parameters to contextualise how big/small these dex and T changes are
The metallicity [Fe/H] has been shown to vary by only $#sym.tilde 0.05$ dex within stellar spots @MetallicityVariations. Since our targets are main-sequence M dwarfs, $log g$ is also likely to lie within a narrow range. For example, #cite(<MDwarfTemperatures>, form: "prose")'s sample of 177 M dwarfs mostly contained stars with masses between $0.3 - 0.7 M_dot.o$, which corresponds to a dex shift of $log(0.7 / 0.3) = 0.36$ dex.

Compare this to reasonable spot temperatures for M dwarfs, which could vary by up to $#sym.tilde #qty("500", "K")$ from the photospheric temperature and significantly modify the shape and structure of the spectrum.

// Therefore, it is reasonable to expect that [Fe/H] and $log g$ will not change significantly within the spots and faculae of a star. This constraint offers us a simple and effective way to address the spectroscopic degeneracy between $T_"eff"$, [Fe/H] and $log g$. 

Hence one of the easiest ways to reduce degeneracies, and hence prevent non-physical minima, is to enforce a constant $log g$ and [Fe/H] between the photospheric background and all spots or faculae. This allows us to focus on the most important variations and keep our results physical. This is the approach used in this work.

Another method to alleviate degeneracies is to determine some of the parameters using a method independent from our minimisation procedure. For example, the stellar $log g$ can be approximated using the photometric $log g$, as is done by #cite(<PasseggerCARMENES>, form: "prose").

// probably good to put this here: can link back into the chi squared method and how that paper increased contrast / reduced the degenerate area.
// 
// [https://www.aanda.org/articles/aa/pdf/2021/12/aa41584-21.pdf & https://arxiv.org/abs/2101.02242 & maybe ref the chi squared paper again] [do i need to explain this idk].

// [insert equation for photometric log g determination; would be cool to use this on some simulated or observational targets to see if it agrees with the mcmc fitted values. gives an extra graph]

