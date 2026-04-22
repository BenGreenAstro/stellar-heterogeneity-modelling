from typing import Tuple
import numpy as np
import emcee
import corner
import scipy as sp
from tqdm import tqdm
import matplotlib.pyplot as plt
from astropy import units as u
import rich

from spectrum_component_analyser.spectral_component import spectral_component
from phoenix_grid_creator.spectral_grid import spectral_grid
from spectrum_component_analyser.interpolated_spectrum import get_interpolated_phoenix_spectrum
from spectrum_component_analyser.spectral_component import spectral_component
from spectrum_component_analyser.spectrum import spectrum

class ConstrainedMCMCHelper():
    def __init__(
            self,
            parameter_bounds,
            number_of_components : int,
            observed_spectrum,
            spec_grid,
            n_walkers = 64,
            n_steps = 1000
            ):
        self.number_of_components = number_of_components
        # Vector structure: [W1, T1, W2, T2, ..., Wn, Tn, shared_FeH, shared_logg]
        self.ndim = (2 * number_of_components) + 2
        self.ObservedSpectrum = observed_spectrum
        self.spec_grid = spec_grid
        
        # parameter_bounds should be list of 4 tuples: [(wmin, wmax), (tmin, tmax), (fmin, fmax), (lmin, lmax)]
        self.parameter_bounds = parameter_bounds
        self.n_walkers = n_walkers
        self.n_steps = n_steps

    def run(self, r : sp.optimize.OptimizeResult) -> Tuple[emcee.EnsembleSampler, np.ndarray]:
        """
        r.x is expected to be the output from a global optimizer (e.g. differential_evolution).
        If r.x is length 4*N, we squash it to 2*N+2.
        """
        raw_params = r.x.copy()
        
        if len(raw_params) == 4 * self.number_of_components:
            # Reformat 4N vector to 2N+2 vector
            params_matrix = raw_params.reshape(self.number_of_components, 4)
            # Sort by Teff (index 1) descending to break symmetry
            params_matrix = params_matrix[np.argsort(params_matrix[:, 1])[::-1]]
            
            new_params = []
            for i in range(self.number_of_components):
                new_params.extend([params_matrix[i, 0], params_matrix[i, 1]]) # W and T
            
            new_params.append(np.mean(params_matrix[:, 2])) # Mean FeH
            new_params.append(np.mean(params_matrix[:, 3])) # Mean logg
            starting_params = np.array(new_params)
        else:
            starting_params = raw_params

        initial_pos = starting_params + 1e-4 * np.random.randn(self.n_walkers, self.ndim)

        sampler = emcee.EnsembleSampler(self.n_walkers, self.ndim, self.log_probability)

        tqdm.write("Running MCMC...")
        sampler.run_mcmc(initial_pos, self.n_steps, progress=True)

        samples = sampler.get_chain(discard=200, thin=15, flat=True)
        best_params = np.median(samples, axis=0)
        
        print(f"MCMC Median Shared Fe/H: {best_params[-2]:.2f}")
        print(f"MCMC Median Shared logg: {best_params[-1]:.2f}")
        print(f"Mean acceptance fraction: {np.mean(sampler.acceptance_fraction):.3f}")

        return sampler, samples

    def log_prior(self, params):
        w_bounds, t_bounds, f_bounds, l_bounds = self.parameter_bounds
        
        # Check per-component weights and temperatures
        for i in range(self.number_of_components):
            w = params[i*2]
            t = params[i*2 + 1]
            if not (w_bounds[0] <= w <= w_bounds[1]): return -np.inf
            if not (t_bounds[0] <= t <= t_bounds[1]): return -np.inf
            
        # Check shared FeH and logg (last two elements)
        if not (f_bounds[0] <= params[-2] <= f_bounds[1]): return -np.inf
        if not (l_bounds[0] <= params[-1] <= l_bounds[1]): return -np.inf
        
        return 0.0

    def log_likelihood(self, params):
        observed = self.ObservedSpectrum.Fluxes.value
        simulated = np.zeros_like(observed)
        
        shared_feh = params[-2] * u.dex
        shared_logg = params[-1] * u.dex
        
        for i in range(self.number_of_components):
            weight = params[i*2]
            teff = params[i*2 + 1] * u.K
            
            spec = get_interpolated_phoenix_spectrum(
                teff, shared_feh, shared_logg, 
                star_name="sim", spec_grid=self.spec_grid
            )
            simulated += weight * spec.Fluxes.value

        sigma = np.std(observed) * 0.2 
        chi2 = np.sum(((observed - simulated) ** 2) / sigma**2)
        return -0.5 * chi2

    def log_probability(self, params):
        lp = self.log_prior(params)
        if not np.isfinite(lp):
            return -np.inf
        
        # Enforce decreasing temperatures (symmetry breaking)
        teffs = params[1 : 2*self.number_of_components : 2]
        if np.any(np.diff(teffs) >= 0):
            return -np.inf
        
        return lp + self.log_likelihood(params)

    def plot_corner(self, sampler, samples, true_components=None):
        labels = []
        for i in range(self.number_of_components):
            labels += [f"W {i+1}", f"T_eff {i+1}"]
        labels += ["Shared Fe/H", "Shared logg"]

        fig = corner.corner(
            samples, 
            labels=labels, 
            quantiles=[0.16, 0.5, 0.84],
            show_titles=True
        )
        plt.show()

    def plot_spectrum(self, samples : np.ndarray) -> None:
        best_params = np.median(samples, axis=0)
        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(20, 10), sharex=True, 
                                    gridspec_kw={'height_ratios': [3, 1]})
        
        total_flux = np.zeros(len(self.ObservedSpectrum.Wavelengths)) * u.Jy
        shared_f = best_params[-2] * u.dex
        shared_l = best_params[-1] * u.dex

        for i in range(self.number_of_components):
            w = best_params[i*2]
            t = best_params[i*2 + 1] * u.K
            
            comp = get_interpolated_phoenix_spectrum(t, shared_f, shared_l, star_name="modelled spectrum", spec_grid=self.spec_grid)
            weighted_flux = comp.Fluxes * w
            total_flux += weighted_flux

            ax1.plot(self.ObservedSpectrum.Wavelengths, weighted_flux.to(u.Jy), 
                    label=f"Comp {i+1}: {t.value:.0f}K", alpha=0.5, linestyle='--')

        ax1.plot(self.ObservedSpectrum.Wavelengths, self.ObservedSpectrum.Fluxes, label="Data", color="black")
        ax1.plot(self.ObservedSpectrum.Wavelengths, total_flux, label="Fit", color="orange")
        
        res = (total_flux.value - self.ObservedSpectrum.Fluxes.value) / self.ObservedSpectrum.Fluxes.value
        ax2.plot(self.ObservedSpectrum.Wavelengths, res, color="blue")
        ax1.legend()
        plt.show()

    def print_parameters(self, samples: np.ndarray):
        # 1. Calculate the 16th, 50th, and 84th percentiles
        percentiles = np.percentile(samples, [16, 50, 84], axis=0)

        # 2. Prepare the table
        results_table = spectral_component.return_default_table()

        # 3. Extract the SHARED parameters (the last two columns)
        def get_stats(idx):
            low, med, high = percentiles[:, idx]
            err = (high - low) / 2
            return med, err

        feh_med, feh_err   = get_stats(-2)
        logg_med, logg_err = get_stats(-1)
        
        display_feh  = f"{feh_med:.2f} ± {feh_err:.2f} dex"
        display_logg = f"{logg_med:.2f} ± {logg_err:.2f} dex"

        # 4. Extract per-component Teffs for sorting
        teff_indices = [i * 2 + 1 for i in range(self.number_of_components)]
        teff_medians = [percentiles[1, idx] for idx in teff_indices]
        sorted_indices = np.argsort(teff_medians)[::-1]

        # 5. Process each component
        for i in sorted_indices:
            w_idx = i * 2
            t_idx = i * 2 + 1
            
            weight_med, weight_err = get_stats(w_idx)
            teff_med, teff_err     = get_stats(t_idx)

            display_weight = f"{weight_med:.2f} ± {weight_err:.2f}"
            display_teff   = f"{teff_med:.2f} ± {teff_err:.2f} K"

            # Instantiate component for the logic/table structure
            recovered_component = spectral_component(
                teff_med * u.K, 
                feh_med * u.dex, 
                logg_med * u.dex, 
                weight_med
            )

            # Add to table
            recovered_component.pretty_print(results_table)
            
            # Overwrite the row with our uncertainty strings
            last_row_idx = len(results_table.rows) - 1
            results_table.columns[0]._cells[last_row_idx] = display_weight
            results_table.columns[1]._cells[last_row_idx] = display_teff
            results_table.columns[2]._cells[last_row_idx] = display_feh
            results_table.columns[3]._cells[last_row_idx] = display_logg

        print("\n[MCMC RECOVERED PARAMETERS (SHARED FEH/LOGG) WITH 1-SIGMA ERRORS]")
        rich.print(results_table)