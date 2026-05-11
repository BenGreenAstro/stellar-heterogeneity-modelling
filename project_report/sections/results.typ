#import "@preview/unify:0.8.0": qty, unit, num

= Results

== Validation

// PINEAPPLE

=== 1 Component

The simplest case we can validate is a simulated star made from 1 component, whose corner plot is shown in @fig-1-component-corner. We begin with a fake star with parameters $T_"eff" = #qty(3800, "K")$, [Fe/H] = 0 and $log g = 4.5$, and use an SNR and wavelength range representative of JWST data. All of the parameters are well resolved by the model. The largest degeneracy is between [Fe/H] and $log g$, but their posterior distribution still closely reflects their true values. The plots for the other parameters form circular shapes, indicating little degeneracy. The worst-determined parameter is $T$, whose true value lies just outside of the $1 sigma$ range.

The spectrum with residuals in @fig-1-component-spectrum show that the largest amount of noise is found at higher wavelengths. This is expected, as the noise amplitude is defined relative to the peak spectrum height. Less intense areas of the spectrum therefore have a lower SNR, which is also true of real-life instruments such as JWST. Despite this, the overall shape of the spectrum and its large-scale features are determined well, and the fitted spectrum is normalised correctly.

#place(
  top,
  float: true,
  scope: "parent",
  [
    // You can group multiple figures here
    #figure(
      image("../figures/1/a/corner_plot_1_component.svg", width: 70%),
      caption: [
        Posterior for the parameters of a 1-component star. Assumes an SNR of 20, and uses a wavelength range of $#qty(0.8, "um") - #qty(5.3, "um")$ at a uniform resolution of $#qty(0.01, "um")$. The light, medium and dark orange levels represent $1,2$ and $3 sigma$ respectively. In the histograms, the solid line represents the mean fit and the dotted lines represent $1 sigma$ of the fitted distribution. The true values are given in black. The value of $T_"eff"$ is underestimated by $#sym.tilde #qty(50, "K")$, and the uncertainty is slighty underreported. The same is true for $log g$, whilst the [Fe/H] has been is found accurately. 
      ],
    ) <fig-1-component-corner>

    #figure(
      image("../figures/1/a/spectrum_decomposition_1_component.svg", width: 60%),
      caption: [The fitted spectrum for the 1-component star. The fitted spectrum is defined by the parameters in @fig-1-component-corner. All spectra in this report use intensities dimensionally equivalent to Janskys, and their mean value is normalised to 1. The residual error is strongest (sometimes $gt #sym.tilde 0.5$) at the higher end of the spectrum, above $#qty(4, "um")$.],
    ) <fig-1-component-spectrum>
  ]
)

=== 2 Components

Building on this, we next decompose a 2-component simulated star. @fig-2-component-corner shows that the posteriors are not neat circles any more, and the degeneracies are more complex.

Our normalisation procedure explains the linear degeneracy between $f_1$ and $f_2$. The simulated star and PHOENIX spectra are all mean normalised to #num(1) Jy. This is equivalent to constraining the area under the curves to be the same constant, $#num(1) "Jy" dot #qty(4.5, "um")$. Therefore, our fitted spectrum must satisfy:

$
integral f_1 F_1(lambda) + f_2 F_2(lambda) "d"lambda &= 4.5 "Jy" #unit("um") \
=> f_1 integral F_1(lambda) "d"lambda + f_2 integral F_2(lambda) "d"lambda &= 4.5 "Jy" #unit("um") \
=> f_1 (4.5 "Jy" #unit("um")) + f_2 (4.5 "Jy" #unit("um")) &= 4.5 "Jy" #unit("um") \
=> f_1 + f_2 &= 1
$

Both @fig-2-component-corner and @fig-2-component-corner-high-res show that the best-fit weights satisfy this condition, which validates that our normalisation is working correctly. In future, this condition could be enforced by defining $f_2 = 1 - f_1$ (or, more generally, $f_n = 1 - f_(n-1)$ for an $n$-component fit) to reduce the dimensionality of the problem.

The globally shared parameters [Fe/H] and $log g$ are found very accurately, but the other 4 parameters less so. The fitted values of the weights and temperatures all lie $#sym.tilde 1 sigma$ away from their true values. There is a significant amount of degeneracy between most of the other parameters, showing that the model has found a very large range of values that are consistent with this low-resolution spectrum. This leads to a very high uncertainty in the fit. For example, the temperatures have an uncertainty of $#sym.tilde 10 %$, and the weights $gt 50 %$.

// At this resolution (#qty(0.01, "um")), the model does not perform very well.

#place(
  top,
  float: true,
  scope: "parent",
  [
    #figure(
      image("../figures/1/b/corner_plot_2_components.svg", width: 55%),
      caption: [Everything is as in @fig-1-component-corner, except with 2 stellar components - one being a large photospheric region, and the other being a smaller, cool facula. At this low resolution, only [Fe/H] and $log g$ are well-determined. Significantly more degeneracy is observed: most of the plots are no longer circular, but elongated over a large parameter range. $f_1$ and $f_2$ are poorly found, with uncertainties $#sym.tilde 75%$. Both $T_1$ and $T_2$ are underestimated by $100 - 200$ K],
    ) <fig-2-component-corner>

    #figure(
      image("../figures/1/c/corner_plot_2_components.svg", width:55%),
      caption: [Everything is as in @fig-1-component-corner, except with a 100x higher wavelength resolution of $#qty("e-4", "um") = #qty(0.1, "nm")$. All parameters are well-determined and their true values lie within $1 sigma$ of the fitted mean. The uncertainties have all significantly decreased. The uncertainty in $T_1$ and $T_2$ has dropped to $lt 3%$ and their means lie only $#sym.tilde #qty(10, "K")$ away from their true values. The magnitude of degeneracy between the parameters has also decreased.],
    ) <fig-2-component-corner-high-res>
  ]
)

=== Resolution

// [talk about the higher resolution fitted spectrum - any changes? if no then remove this figure]
// #figure(
//   image("../figures/1/b/spectrum_decomposition_2_components.svg", width: 80%),
//   caption: [A descriptive caption for your image.],
// ) <fig-2-component-spectrum>

Improving the resolution by a factor of $100$ to #qty(0.1, "nm") significantly improves the fit, as shown in @fig-2-component-corner-high-res. A higher resolution means many more spectral features from the PHOENIX data are preserved. The model has more lines to optimise against, and a better understanding of the shape and depth of those absorption features. We have moved from a regime where the model was trying to fit the overall shape of the spectrum and a few lines (low resolution) to one where the model can identify small scale features. There are much fewer combinations of parameters which can sum to describe all of these small scale, sensitive features simultaneously, which has reduced the degeneracy of the fit greatly.

All parameters are determined extremely well: the temperatures only have a $#sym.tilde #qty(50, "K")$ error, and the other 4 parameters are determined effectively exactly. The histograms also have a much more Gaussian shape, illustrating the reduced degeneracy. @fig-2-component-corner and @fig-2-component-corner-high-res show that the accuracy of our model is highly dependent on the resolution of the data used.

== Degeneracies

@fig-multiple-solutions directly illustrates how degenerate our fitting procedure is. 2 sets of parameters are shown, which both have log likelihoods which lie within 10% of the maximum log likelihood. The resolution of the spectra is $#qty(0.01, "um")$. Despite the significant difference in their $T_"eff"$ and $f$ values, they both sum to almost exactly the same total spectrum. The middle plot shows they have exactly the same shape, and the bottom residual shows the differ by a maximum of $1.5 %$.

Above $#qty(3, "um")$, the spectra differ by $<< 1%$. This implies that this wavelength region is less sensitive to temperature changes. Only using certain wavelength bands that are known to be sensitive to the 3 parameters $T_"eff"$, [Fe/H] and $log g$ could therefore reduce the degeneracies within the model.

Both of the parameter sets in @fig-multiple-solutions have similar [Fe/H] and $log g$ values: both vary by only $0.1$ dex between the two components, and are within 0.15 dex of the true values. We also note that in @fig-2-component-corner and @fig-2-component-corner-high-res, the width of the [Fe/H] and $log g$ histograms is typically very small compared to the other parameters' uncertainties. This implies that our constraint of using a global [Fe/H] and $log g$ has helped reduce the amount of degeneracy.

// near the tail end, much similar -> more degenerate, future work could explore constraining the minimisation to certain wavelength bands

// two solutions that are within 10% of the max log likelihood, but far apart in param space

// when multiple components are involved, a much longer MCMC run (more steps) are needed, increasing the run time by 1 order of magnitude or so

// both solutions had similar feh, logg (within 0.1 dex of each other, and within 0.15 dex of the maximum likelihood solution)
// maybe should clarify that best fit means maximum likelihood, but we take the median + std dev to show the degenerate region best

#place(
  top,
  float: true,
  scope: "parent",
  [
    #figure(
      image("../illustrative_diagrams/multiple_solutions.svg", width: 100%),
      caption: [
        A demonstration of the cause of degeneracy within the model. For the same 2 component star as in @fig-2-component-corner, two different fits, together with their sum, are shown in the top left and right. The $T_"eff"$ values differ by $#sym.tilde #qty(100, "K")$, and the $f$ values differ by $#sym.tilde 0.2$. The middle plot compares their total spectra (note that one of the spectra is shifted down in order to visible). Both of these parameter sets are found by our model as a good fit.
      ],
    ) <fig-multiple-solutions>
  ]
)

== Data Quality

// [washes out at high wavelengths, both move towards the average value and their uncertainties increase.]
// [not monotically better though: why? idk]

=== Resolution

@fig-resolution-variation shows how fitting quality is affected by resolution. We use the same fake star as in @fig-2-component-corner. At low resolutions of $#sym.tilde #qty(0.01, "um")$, the $f_i$ both tend towards $0.5$, and the temperatures become less accurate. Only when we reach #qty(0.1, "nm") do the uncertainties decrease and the fit becomes much more accurate.

A resolution of #qty(0.1, "nm") is higher than what's currently achievable with JWST. In the low resolution regime, this method cannot fully determine the input parameters into our simulated stars. However, it can determine which sets of parameters are consistent with the observed spectrum, which is still useful for identifying possible false spectral features.

=== SNR

@fig-snr-variation shows how SNR affects the fit for $T_"eff"$ and $f$. A resolution of $#qty(0.3, "nm")$ was chosen, as this is the resolution at which convergence improved in @fig-resolution-variation. Between an SNR of 0 and 20 the graph is as expected: at very low SNR, even the overall shape of the spectrum is distorted, and the model cannot find any meaningful information to fit against. This leads to uncertainties of $gt #qty(500, "K")$ and $gt #num(.4)$ in $T_"eff"$ and $f$ respectively. A medium SNR of $#sym.tilde 20$ produces graphs where the overall shape of the spectrum is preserved, and so the model is able to minimise the degeneracy better.

However, at SNRs larger than 20, the graph shows unusual behaviour within our model. Although the median values are nearer to their true values, the uncertainties massively increase. Often, the errorbars of one component overlap with the median of the other component. Furthermore, the median of the fitted distribution stays roughly constant between an SNR of 20 and 40.

One explanation which could explain this is as follows: at high SNR, the noise becomes negligible, and the maximum likelihood and median converge to their correct values. However, the small scale features of both the $#qty(3800, "K")$ and $#qty(3300, "K")$ components are similar, since they share the same [Fe/H] and $log g$. This means that the model finds a possible fit where $T_1$ and $T_2$ are swapped (or equivalently, where $f_1$ and $f_2$ are swapped) - albeit with lower $log$ likelihood. This outlier creates a long tail in the distributions for the fitted parameters, and elongates the uncertainty of each component to include the median value of the other component.

This implies that using the maximum likelihood value, instead of the median (which may be biased towards other components' values) may be more reliable. Furthermore, only looking at the effective $1 sigma$ width of the values found by the MCMC model might be misleading, especially in cases where there the distribution has a long tail. It's important to take into account the shape of the degeneracy, and analyse whether the found parameters are physical.

// maybe should add resolution of space-based and ground based instruments as vertical lines to this graph

#place(
  top,
  float: true,
  scope: "parent",
  [
    #figure(
      image("../figures/2/correctness_as_a_function_of_resolution.svg", width: 55%),
      caption: [The effect of resolution on fitting quality of $T_"eff"$ and the area covering fraction $f$ for a 2-component star. The first plot shows the difference between the true and fitted temperatures, and the bottom between the true and fitted weights, both as a function of resolution. Assumes an SNR of 20, and uses a wavelength range of $#qty(0.8, "um") - #qty(5.3, "um")$ at a uniform resolution of $#qty(0.01, "um")$. Resolutions better $#sym.tilde #qty("e-3", "um")$ perform significantly better than lower resolutions. At $qty(0.01, "um")$ resolution, the temperature uncertainty is nearly $#sym.tilde 10%$. At much higher resolutions near $qty(0.1, "nm")$, it drops to $#sym.tilde 3%$. The area covering fractions begin to converge to their true values with resolutions below $#sym.tilde qty(1.3, "nm")$.],
    ) <fig-resolution-variation>,

    #figure(
      image("../illustrative_diagrams/snr_variation.svg", width: 55%),
      caption: [
        The effect of SNR on fitting quality of $T_"eff"$ and the area covering fraction $f$ for a 2-component star. Fitting was done at a resolution of $#qty(0.3, "nm")$. At low SNR, noise prevents the model from being able to converge nearby to the input parameters. Above an SNR of $#sym.tilde 10$, the model can resolve enough detail to be able to accurately fit both $f$ and $T_"eff"$. Suprisingly, increasing the SNR above $#sym.tilde 25$ actually increases the amount of degeneracy present.
      ],
    ) <fig-snr-variation>
  ]
)

// == Real M dwarfs

// The method was applied to the M dwarf GJ486, as observed by JWST's NIRSpec instrument. The PHOENIX data was downsampled to NIRSpec's resolution, and the MCMC model was run with both 1 component and 2 components.

// The 1 component fit is shown in @fig-GJ486-1-component. The fitted parameters agree very strongly with accepted values, and little to no degeneracy is shown.

// #place(
//   top,
//   float: true,
//   scope: "parent",
//   [
//     #figure(
//       image("../illustrative_diagrams/GJ486_NIRSPECLower_1_component.svg", width: 100%),
//       caption: [
//       ],
//     ) <fig-GJ486-1-component>
//   ]
// )

// This target was chosen as a recent review by #cite(<GJ486>, form: "prose") carried out a similar analysis as the one presented here, and determined the best fitting 2 component model for the observed spectrum. A comparison between their and our fitted parameters is shown in table @....



== Limitations & Improvements

// [include a plot for a 2-component spectrum being decomposed by a 1-component model, and vice versa]
// [i assume the former just reaches the average of the components, and the latter maybe does something reasonable or maybe something very unreasonable! when we test it, it was the latter :(]

// [3+ components? is it even reasonable?]

// [high pass filtering to help remove noise]

// [using closer-in-temperature components]

=== Better Simulation of Instrument Data

One simplifying assumption used in this work is that the LSF is a Gaussian. Real telescopes' LSF are more complicated, and may be a different shape to a Gaussian. Furthermore, the resolution of the observed spectra is not a constant width, and instead a wavelength-dependent quantity. Using the true wavelength-dependent LSF for a range of different telescopes would offer greater insight into what is observable with current instrumentation.

// [use actual LSF]
// [use wavelength dependent resolution]
// [what could this change / improve about your results? does this mean your results are a lower or upper bound for how good your model is?]

=== Explore SNR Graph Further

Further exploration into the increase in degeneracy at high SNRs, shown in @fig-snr-variation, could help our understanding of the model. Determining if this effect is due to similar absorption lines between the 2 components would be of particular interest. Analysis into how to accurately represent the uncertainty and best fit in such cases would also be useful: for example, a median together with an effective $1 sigma$ range might not be appropriate if the parameter distribution has a long tail.

=== Effects of Limb Reddening & Darkening <LimbDarkening>

Photons originating from different positions within a star travel on different paths through the stellar material to reach us. Since the effective temperature of the photosphere decreases with radius, the edges of a star appear redder than the center @LimbReddeningGraphPaper. Furthermore, optical depth decreases when viewing the star further from its center, so the brightness at the edge of a star is lower @LimbDarkeningReview. 

// and is of order ??? in the IR [ref - maybe the diagram from pettinis notes (might be able to find a link in our chat with dylan) or the source of that diagram if its from a paper etc].

When analysing real spectra, this dimming would mean that the weights in @ComponentEquation are not precisely the actual area covering fractions. A spot or facula at the edge of a disc will appear dimmer than one of the same size at the center of the disc. Since we ignore this effect, our optimised weights will underestimate the size of any spots near the edge of the star, as they would need to be larger to produce the same intensity. Furthermore, heterogeneities at the edge of a star will appear redder, which will shift their spectral energy distribution towards higher wavelengths. This may change the fitted value of $T_"eff"$, as spectra with lower $T_"eff"$ also peak at higher wavelengths.

// GJ 486, etc
// [1 component: v good]
// [2 components: doesn't agree with others]

// maybe 1 or 2 more examples


//  can use this - at SNR 20 and resolution of 0.01 um over 0.8 to 5.3 um
// actually pretty good for 4 different components. it can still roughly find the involved temperatures, but the weights are heavily diluted
// [ORIGINAL PARAMETERS]
//          ╷          ╷         ╷          
//   Weight │ T_eff    │ [FeH]   │ log g    
// ╶────────┼──────────┼─────────┼─────────╴
//   0.15   │ 4000.0 K │ 0.0 dex │ 4.5 dex  
//   0.5    │ 3800.0 K │ 0.0 dex │ 4.5 dex  
//   0.1    │ 3500.0 K │ 0.0 dex │ 4.5 dex  
//   0.25   │ 3300.0 K │ 0.0 dex │ 4.5 dex  
//          ╵          ╵         ╵          

// [MCMC RECOVERED PARAMETERS (SHARED FEH/LOGG) WITH 1-SIGMA ERRORS]
//               ╷                    ╷                  ╷                  
//   Weight      │ T_eff              │ [FeH]            │ log g            
// ╶─────────────┼────────────────────┼──────────────────┼─────────────────╴
//   0.15 ± 0.16 │ 4085.57 ± 232.63 K │ -0.07 ± 0.24 dex │ 4.60 ± 0.21 dex  
//   0.26 ± 0.23 │ 3813.04 ± 148.45 K │ -0.07 ± 0.24 dex │ 4.60 ± 0.21 dex  
//   0.26 ± 0.25 │ 3573.68 ± 148.59 K │ -0.07 ± 0.24 dex │ 4.60 ± 0.21 dex  
//   0.14 ± 0.17 │ 3261.26 ± 307.09 K │ -0.07 ± 0.24 dex │ 4.60 ± 0.21 dex  
