= Results

== Validation

LARGE PINEAPPLE

The simplest case we can validate is a simulated star made from 1 component, whose corner plot is shown inn @fig-1-component-corner. The parameters are well resolved. The largest degeneracy is between [Fe/H] and $log g$, but their posterior distribution still closely reflects their true values. The worst-determined parameter is $T_2$, whose true value lies just outside of the $1 sigma$ range.

As shown in @fig-1-component-spectrum, the largest amount of noise is found at higher wavelengths. This is expected, as the noise amplitude is defined relative to the peak spectrum height. Less intense areas of the spectrum therefore have a lower SNR, which is also true of instruments, including JWST.

#figure(
  image("../figures/1/a/corner_plot_1_component.svg", width: 80%),
  caption: [
		Posterior for the parameters of a 1-component star. Assumes an SNR of 20, and uses a wavelength range of $#qty(0.8, "um") - #qty(5.3, "um")$ at a uniform resolution of $#qty(0.01, "um")$.
	],
) <fig-1-component-corner>

#figure(
  image("../figures/1/a/spectrum_decomposition_1_component.svg", width: 100%),
  caption: [The fitted spectrum for the 1-component star. The fitted spectrum is defined by the parameters in @fig-1-component-corner],
) <fig-1-component-spectrum>

Building on this, we next decompose a 2-component simulated star. @fig-2-component-corner shows that the posteriors are not neat circles any more, and the degeneracies are more complex. The linear degeneracy between $f_1$ and $f_2$ can be explained physically:

any component's intensities must sum to the same as

The globally shared parameters [Fe/H] and $log g$ have been found very accurately, but the other parameters less so. At this resolution (#qty(0.01, "um")), the model does not perform perfectly, although its findings do give a reasonable estimate of the temperature and area covering fractions.

#figure(
  image("../figures/1/b/corner_plot_2_components.svg", width: 80%),
  caption: [A descriptive caption for your image.],
) <fig-2-component-corner>

[talk about the higher resolution fitted spectrum - any changes? if no then remove this figure]
#figure(
  image("../figures/1/b/spectrum_decomposition_2_components.svg", width: 80%),
  caption: [A descriptive caption for your image.],
) <fig-label>

[Improving the resolution to... does...]

#figure(
  image("../figures/1/c/corner_plot_2_components.svg", width: 80%),
  caption: [A descriptive caption for your image.],
) <fig-label>



[include a plot for a 2-compnoent spectrum being decomposed by a 1-component model, and vice versa]
[i assume the former just reaches the average of the components, and the latter maybe does something reasonable or maybe something very unreasonable! when we test it, it was the latter :(]

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

== Limitations

== Real Spectra

GJ 486, etc
[1 component: v good]
[2 components: doesn't agree with others]

maybe 1 or 2 more examples