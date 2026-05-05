#import "@preview/unify:0.8.0": qty, unit, num

= Results

== Validation

// PINEAPPLE

The simplest case we can validate is a simulated star made from 1 component, whose corner plot is shown inn @fig-1-component-corner. We begin with a fake star with parameters $T_"eff" = #qty(3800, "K")$, [Fe/H] = 0 and $log g = 4.5$. All of the parameters are well resolved by the model. The largest degeneracy is between [Fe/H] and $log g$, but their posterior distribution still closely reflects their true values. The plots for the other parameters form circular shapes, indicating little degeneracy. The worst-determined parameter is $T$, whose true value lies just outside of the $1 sigma$ range.

The spectrum with residuals in @fig-1-component-spectrum show that the largest amount of noise is found at higher wavelengths. This is expected, as the noise amplitude is defined relative to the peak spectrum height. Less intense areas of the spectrum therefore have a lower SNR, which is also true of real-life instruments such as JWST. Despite this, the overall shape of the spectrum and its large-scale features are determined well, and the fitted spectrum is normalised correctly.

#figure(
  image("../figures/1/a/corner_plot_1_component.svg", width: 80%),
  caption: [
		Posterior for the parameters of a 1-component star. Assumes an SNR of 20, and uses a wavelength range of $#qty(0.8, "um") - #qty(5.3, "um")$ at a uniform resolution of $#qty(0.01, "um")$. The light, medium and dark orange levels represent $1,2$ and $3 sigma$ respectively. In the histograms, the solid line represents the mean fit and the dotted lines represent $1 sigma$ of the fitted distribution. The true values are given in black.
	],
) <fig-1-component-corner>

#figure(
  image("../figures/1/a/spectrum_decomposition_1_component.svg", width: 100%),
  caption: [The fitted spectrum for the 1-component star. The fitted spectrum is defined by the parameters in @fig-1-component-corner. All spectra in this report use intensities dimensionally equivalent to Janskys, and their mean value is normalised to 1.],
) <fig-1-component-spectrum>

Building on this, we next decompose a 2-component simulated star. @fig-2-component-corner shows that the posteriors are not neat circles any more, and the degeneracies are more complex.

Our normalisation procedure explains the linear degeneracy between $f_1$ and $f_2$. The simulated star and PHOENIX spectra are all mean normalised to #num(1) Jy, and share the same uniformly spaced wavelength points over a #qty(4.5, "um") range. This is equivalent to constraining the area under the curves to be the same constant, $#num(1) "Jy" dot #qty(4.5, "um")$. Therefore, our fitted spectrum must satisfy:

$
integral f_1 F_1(lambda) + f_2 F_2(lambda) "d"lambda &= 4.5 "Jy" #unit("um") \
=> f_1 integral F_1(lambda) "d"lambda + f_2 integral F_2(lambda) "d"lambda &= 4.5 "Jy" #unit("um") \
=> f_1 (4.5 "Jy" #unit("um")) + f_2 (4.5 "Jy" #unit("um")) &= 4.5 "Jy" #unit("um") \
=> f_1 + f_2 &= 1
$

Both @fig-2-component-corner and @fig-2-component-corner-high-res show that the best-fit weights satisfy this condition.

The globally shared parameters [Fe/H] and $log g$ are found very accurately, but the other 4 parameters less so. The true values of the weights and temperatures all lie $#sym.tilde 1 sigma$ away from their true values. There is a significant amount of degeneracy between most of the other parameters, showing that the model has found a very large range of values that are consistent with this low-resolution spectrum. This leads to a very high uncertainty in the fit. For example, the temperatures have an uncertainty of $#sym.tilde 10 %$, and the weights $gt 50 %$.

// At this resolution (#qty(0.01, "um")), the model does not perform very well.

#figure(
  image("../figures/1/b/corner_plot_2_components.svg", width: 80%),
  caption: [Everything is as in @fig-1-component-corner, except with 2 stellar components - one being a large photospheric region, and the other being a smaller, cool facula. At this low resolution, only [Fe/H] and $log g$ are well-determined.],
) <fig-2-component-corner>

// [talk about the higher resolution fitted spectrum - any changes? if no then remove this figure]
// #figure(
//   image("../figures/1/b/spectrum_decomposition_2_components.svg", width: 80%),
//   caption: [A descriptive caption for your image.],
// ) <fig-2-component-spectrum>

Improving the resolution to #qty(0.1, "nm") significantly improves the fit, as shown in @fig-2-component-corner-high-res. A higher resolution means many more spectral features from the PHOENIX data are preserved. The model has more lines to optimise against, and a better understanding of the shape and depth of those absorption features. All parameters are determined extremely well: the temperatures only have a $#sym.tilde #qty(10, "K")$ error, and the other 4 parameters are determined effectively exactly.

This shows that the success of this method is highly dependent on the resolution of the data used.

#figure(
  image("../figures/1/c/corner_plot_2_components.svg", width: 80%),
  caption: [Everything is as in @fig-1-component-corner, except with a 100x higher wavelength resolution of $#qty("e-4", "um") = #qty(0.1, "nm")$. All parameters are well-determined.],
) <fig-2-component-corner-high-res>

=== Convergence

[probably unnecessary]

#figure(
  image("../figures/1/a/trace_plot_1_component.svg", width: 100%),
  caption: [A descriptive caption for your image.],
) <fig-label>

== Degeneracies

[Discuss the degeneracies seen in the figures. Reference back to the physical reasoning behind the degeneracies]

[maybe unnecessary as we've already talked about it?]

== Data Quality

// maybe should add resolution of space based and ground based instruments as vertical lines to this graph
#figure(
  image("../figures/2/correctness_as_a_function_of_resolution.svg", width: 80%),
  caption: [A descriptive caption for your image.],
) <fig-label>

== Physical Interpretation

What does this mean for M dwarfs?

== Limitations & Improvements

[include a plot for a 2-compnoent spectrum being decomposed by a 1-component model, and vice versa]
[i assume the former just reaches the average of the components, and the latter maybe does something reasonable or maybe something very unreasonable! when we test it, it was the latter :(]

[3+ components? is it even reasonable?]

[high pass filtering to help remove noise]

[using closer-in-temperature components]

== Real Spectra




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

GJ 486, etc
[1 component: v good]
[2 components: doesn't agree with others]

maybe 1 or 2 more examples