== The Fitting Procedure <FittingProcedure>

In order to fit a multicomponent model to our simulated stars, we use a Markov chain Monte Carlo method. The Python package `emcee` @emcee is used to efficiently explore stellar parameters, in order to find the 2 components that most accurately reproduce the input spectrum.

=== Initial Estimate

To find an initial estimate for all the stellar components, we fit a 1 component model to the star. We use `scipy`'s differential_evolution @DifferentialEvolutionAlgorithm global optimiser with the 3 parameters $T_"eff"$, [Fe/H] and $log g$. This takes significantly less time than running an MCMC model and is found to give a good approximation for the average parameters for the star.

These parameters are then used as the initial guess for all stellar components, which are passed into the MCMC model.

=== Likelihood

The Python package `emcee` maximises a given log likehood over our M dwarf parameter space. Assuming a Guassian distribution, the log likelihood function takes the same form as @ChiSquared, except multiplied by $-1/2$. This is the likelihood used in our model.

=== Interpolation

In order to explore the parameter space over a finer resolution than the input simulated PHOENIX spectra, we use linear interpolation. Specifically, we allow the MCMC code to linearly interpolate along all 3 parameter dimensions ($T_"eff"$, [Fe/H], $log g$) in order to find a more optimal fit.

// However, there are existing methods which use interpolation on these parameters to achieve a much higher resolution [ref the chi-squared minimisation paper, and make sure to note what their resolution actually was].

=== Symmetry Breaking

When fitting to a spectrum with 2 similar components, the model will often find 2 minima for each parameter. One will correspond to the true parameters for the first component, and one for the second component. This significantly increases the degeneracy and prevents an accurate fit, as the minimisation process doesn't have a method to distinguish between the components.

This issue can be largely fixed by constraining the components to go in order of decreasing temperature. For example, if the model tries to explore a region where $T_1 < T_2$ then a log likelihood of $-infinity$ is returned, and the model will stop exploring that region of parameter space.

// PINEAPPLE

// Maybe show a graph that uses this, and one without to show the fix. e.g.:
// This fix can be seen in [ref figure]. [figure x b)] shows the double minima being significantly decreased, although it is still present at [give resolutions, SNR, wavelength ranges where it is / isn't present].

=== Constraints

As discussed in the #link(<ReducingDegeneracies>)[#text(fill: black)[degeneracies section]], constraining the [Fe/H] and $log g$ of all components to be the same is a physically reasonable step which prevents degeneracies. Without this step, we found the code to produce a large amount of degeneracy, which significantly decreased the usefulness of the model.

// An example can be seen in [ref figure].

// PINEAPPLE

Therefore, all components share the same variable for [Fe/H] and $log g$. This means that the total number of dimensions in our model is

$ N_"dim" = 2n + 2 $

where $n$ is the number of components. Each component has a weight $f$ and temperature $T$, and there are 2 global variables [Fe/H] and $log g$.