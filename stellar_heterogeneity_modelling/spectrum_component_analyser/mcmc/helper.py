from typing import Tuple

from astropy import units as u

import corner
import emcee
from matplotlib import pyplot as plt
import numpy as np
from phoenix_grid_creator.spectral_grid import spectral_grid
import scipy as sp
from spectrum_component_analyser.interpolated_spectrum import get_interpolated_phoenix_spectrum
from spectrum_component_analyser.spectral_component import spectral_component
from spectrum_component_analyser.spectrum import spectrum
from tqdm import tqdm
from phoenix_grid_creator.spectral_grid import get_phoenix_wavelengths


class MCMCHelper():
    def __init__(
            self,
            parameter_bounds,
            number_of_components : int,
            number_of_parameters : int,
            observed_spectrum : spectrum,
            spec_grid : spectral_grid,
            n_walkers = 64,
            n_steps = 1000
            ):
        self.number_of_components = number_of_components
        self.number_of_parameters = number_of_parameters
        self.ndim = number_of_parameters * number_of_components
        self.ObservedSpectrum = observed_spectrum
        self.spec_grid = spec_grid
        self.parameter_bounds = parameter_bounds
        self.n_walkers = n_walkers
        self.n_steps = n_steps

    def run(self, r : sp.optimize.OptimizeResult) -> Tuple[emcee.EnsembleSampler, np.ndarray]:
        """
        r is from global optimisation aka its a guess at params to start out at
        """
        starting_params = r.x.copy()
        params_matrix = starting_params.reshape(self.number_of_components, self.number_of_parameters)
        teffs = params_matrix[:, 1]
        sort_indices = np.argsort(teffs)[::-1] 
        starting_params = params_matrix[sort_indices].flatten()

        # Initialize walkers in a tiny ball around your 'differential_evolution' result 
        # or a reasonable guess.
        # r.x is the result from your previous optimization
        initial_pos = starting_params + 1e-4 * np.random.randn(self.n_walkers, self.ndim)

        sampler = emcee.EnsembleSampler(self.n_walkers, self.ndim, self.log_probability)

        tqdm.write("Running MCMC...")
        sampler.run_mcmc(initial_pos, self.n_steps, progress=True)

        # Flatten the chain (discarding burn-in steps)
        samples : np.ndarray = sampler.get_chain(discard=200, thin=15, flat=True)

        # Get the median results
        best_params = np.median(samples, axis=0)
        print(f"MCMC Median Parameters: {best_params}")
        print(f"Mean acceptance fraction: {np.mean(sampler.acceptance_fraction):.3f}")
        print("Raw Teff1 Standard Deviation:", np.std(samples[:, 1]))

        return sampler, samples
    
    def plot(self, sampler : emcee.EnsembleSampler, samples : np.ndarray, true_components : list[spectral_component]):
        labels = []
        for i in range(self.number_of_components):
            labels += [f"W {i+1}", f"T_eff {i+1}", f"Fe/H {i+1}", f"logg {i+1}"]

        true_params = []
        for c in true_components:
            print(c.Weight)
            true_params += [c.Weight, c.T_eff.value, c.FeH.value, c.Log_g.value]

        true_params = np.array(true_params, dtype=float)

        # 2. Create the corner plot
        fig = corner.corner(
            samples, 
            labels=labels, 
            truths=true_params,            # Overplot the true params
            quantiles=[0.16, 0.5, 0.84], # Show median and 1-sigma uncertainties
            show_titles=True, 
            title_kwargs={"fontsize": 12}
        )

        plt.show()

        # 3. Bonus: Diagnostic Check (The "Trace Plot")
        # This ensures your walkers didn't get stuck or haven't finished "climbing the hill"
        fig, axes = plt.subplots(self.ndim, figsize=(10, 7), sharex=True)
        chain = sampler.get_chain()
        for i in range(self.ndim):
            ax = axes[i]
            ax.plot(chain[:, :, i], "k", alpha=0.3)
            ax.set_xlim(0, len(chain))
            ax.set_ylabel(labels[i])
            ax.yaxis.set_label_coords(-0.1, 0.5)

        axes[-1].set_xlabel("Step number")
        plt.tight_layout()
        plt.show()

    # 1. Define the Log-Prior
    def log_prior(self, params):
        """Checks if parameters are within the physical bounds of your grid."""
        # Expand bounds to match the full parameter vector
        full_bounds = self.parameter_bounds * self.number_of_components
        
        for i in range(self.ndim):
            low, high = full_bounds[i]
            if not (low <= params[i] <= high):
                return -np.inf  # Probability is zero outside bounds
        return 0.0

    # 2. Define the Log-Likelihood
    def log_likelihood(self, params):
        """
        Equivalent to -0.5 * chi_square.
        Assumes constant noise (sigma). If you have flux errors, replace 1.0 with errPsors.
        """
        observed = self.ObservedSpectrum.Fluxes.value # Work in raw values for speed
        simulated = np.zeros_like(observed)
        
        for i in range(self.number_of_components):
            idx = i * self.number_of_parameters
            weight = params[idx]
            t = params[idx + 1] * u.K
            f = params[idx + 2] * u.dex
            l = params[idx + 3] * u.dex
            
            # Note: Optimization usually benefits from caching these lookups
            spec = get_interpolated_phoenix_spectrum(t, f, l, star_name="sim", spec_grid=self.spec_grid)
            simulated += weight * spec.Fluxes.value

        # Gaussian log-likelihood formula
        sigma = np.std(observed) * 0.2 # 5% noise estimate, # Or use actual observational uncertainties if available
        chi2 = np.sum(((observed - simulated) ** 2) / sigma**2)
        return -0.5 * chi2

    # 3. Combine into the Log-Posterior
    def log_probability(self, params):
        lp = self.log_prior(params)
        if not np.isfinite(lp):
            return -np.inf
        
        # enforce teffs to be decreasing (help remove symmetry)
        teffs = params[1::self.number_of_parameters]
        if np.any(np.diff(teffs) >= 0):
            return -np.inf
        
        return lp + self.log_likelihood(params)