from typing import Tuple
from astropy import units as u
import matplotlib.pyplot as plt
import astropy.units as u
import numpy as np
import corner
import emcee
from matplotlib import pyplot as plt
import numpy as np
import scipy as sp
from tqdm import tqdm

from phoenix_grid_creator.spectral_grid import spectral_grid
from spectrum_component_analyser.interpolated_spectrum import get_interpolated_phoenix_spectrum
from spectrum_component_analyser.spectral_component import spectral_component
from spectrum_component_analyser.spectrum import spectrum
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
    
    def plot_corner(self, sampler : emcee.EnsembleSampler, samples : np.ndarray, true_components : list[spectral_component]):
        labels = []
        for i in range(self.number_of_components):
            labels += [f"W {i+1}", f"T_eff {i+1}", f"Fe/H {i+1}", f"logg {i+1}"]

        true_params = []

        if true_components != None:
            for c in true_components:
                print(c.Weight)
                true_params += [c.Weight, c.T_eff.value, c.FeH.value, c.Log_g.value]

            true_params = np.array(true_params, dtype=float)

            fig = corner.corner(
                samples, 
                labels=labels, 
                truths=true_params,            
                quantiles=[0.16, 0.5, 0.84], 
                show_titles=True, 
                title_kwargs={"fontsize": 12}
            )
        else:
            fig = corner.corner(
                samples, 
                labels=labels, 
                truths=None,           
                quantiles=[0.16, 0.5, 0.84], 
                show_titles=True, 
                title_kwargs={"fontsize": 12}
            )

        plt.show()

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

    def print_parameters(self, samples : np.ndarray):
        import numpy as np
        import rich
        from astropy.units import Quantity

        # axis=0 calculates these across the flattened samples
        percentiles = np.percentile(samples, [16, 50, 84], axis=0)
        results_table = spectral_component.return_default_table()

        teffs = [percentiles[1, 1 + i * self.number_of_parameters] for i in range(self.number_of_components)]

        # Get indices for descending order (highest weight first)
        sorted_indices = np.argsort(teffs)[::-1]
        print(teffs)

        for i in sorted_indices:
            index_offset = i * self.number_of_parameters
            
            def get_stats(idx):
                low, med, high = percentiles[:, idx]
                err = (high - low) / 2
                return med, err

            weight_med, weight_err = get_stats(index_offset)
            teff_med, teff_err     = get_stats(index_offset + 1)
            feh_med, feh_err       = get_stats(index_offset + 2)
            logg_med, logg_err     = get_stats(index_offset + 3)
            
            display_weight = f"{weight_med:.2f} ± {weight_err:.2f}"
            display_teff   = f"{teff_med:.2f} ± {teff_err:.2f} K"
            display_feh    = f"{feh_med:.2f} ± {feh_err:.2f} dex"
            display_logg   = f"{logg_med:.2f} ± {logg_err:.2f} dex"
            
            recovered_component : spectral_component = spectral_component(
                teff_med * u.K, 
                feh_med * u.dex, 
                logg_med * u.dex, 
                weight_med
            )

            recovered_component.pretty_print(results_table)
            
            last_row_idx = len(results_table.rows) - 1
            results_table.columns[0]._cells[last_row_idx] = display_weight
            results_table.columns[1]._cells[last_row_idx] = display_teff
            results_table.columns[2]._cells[last_row_idx] = display_feh
            results_table.columns[3]._cells[last_row_idx] = display_logg

        print("\n[MCMC RECOVERED PARAMETERS WITH 1-SIGMA ERRORS]")
        rich.print(results_table)

    def log_prior(self, params):
        """Checks if parameters are within the physical bounds of your grid."""
        full_bounds = self.parameter_bounds * self.number_of_components
        
        for i in range(self.ndim):
            low, high = full_bounds[i]
            if not (low <= params[i] <= high):
                return -np.inf  # probability is zero outside bounds
        return 0.0

    def log_likelihood(self, params):
        """
        Equivalent to -0.5 * chi_square.
        Assumes constant noise (sigma). If you have flux errors, replace 1.0 with errPsors.
        """
        observed = self.ObservedSpectrum.Fluxes.value
        simulated = np.zeros_like(observed)
        
        for i in range(self.number_of_components):
            idx = i * self.number_of_parameters
            weight = params[idx]
            t = params[idx + 1] * u.K
            f = params[idx + 2] * u.dex
            l = params[idx + 3] * u.dex
            
            spec = get_interpolated_phoenix_spectrum(t, f, l, star_name="sim", spec_grid=self.spec_grid)
            simulated += weight * spec.Fluxes.value

        sigma = np.std(observed) * 0.2
        chi2 = np.sum(((observed - simulated) ** 2) / sigma**2)
        return -0.5 * chi2

    def log_probability(self, params):
        lp = self.log_prior(params)
        if not np.isfinite(lp):
            return -np.inf
        
        # enforce teffs to be decreasing (help remove symmetry)
        teffs = params[1::self.number_of_parameters]
        if np.any(np.diff(teffs) >= 0):
            return -np.inf
        
        return lp + self.log_likelihood(params)
    
    def plot_spectrum(self, samples : np.ndarray) -> None:
        best_params : np.ndarray = np.median(samples, axis=0)

        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(30, 16), sharex=True, 
                                    gridspec_kw={'height_ratios': [3, 1]})
        plt.subplots_adjust(hspace=0.05)

        total_flux : u.Quantity = np.zeros(len(self.ObservedSpectrum.Wavelengths)) * u.Jy

        colors = ["#3498db", "#e74c3c", "#2ecc71"]

        for i in range(self.number_of_components):
            idx = i * self.number_of_parameters
            
            w = best_params[idx]
            t = best_params[idx + 1] * u.K
            f = best_params[idx + 2] * u.dex
            l = best_params[idx + 3] * u.dex
            
            mcmc_component = get_interpolated_phoenix_spectrum(
                t, f, l, 
                star_name=f"MCMC Component {i}", 
                spec_grid=self.spec_grid
            )

            weighted_flux = mcmc_component.Fluxes * w
            total_flux += weighted_flux

            # weighted_flux /= np.sum(weighted_flux.value)

            ax1.plot(
                self.ObservedSpectrum.Wavelengths, 
                weighted_flux.to(u.Jy), 
                label=f"Component {i}: {t:.0f}, {f:.1f}FeH", 
                color=colors[i % len(colors)], 
                alpha=0.5, 
                linestyle='--'
            )

        my_result : spectrum = spectrum(
            wavelengths=self.ObservedSpectrum.Wavelengths,
            fluxes=total_flux,
            normalised_point=None,
            name="MCMC Median Fit",
            normalise=False,
            observational_wavelengths=None,
            temperature=None
        )

        obs_flux_norm = self.ObservedSpectrum.Fluxes
        fit_flux_norm = my_result.Fluxes

        ax1.plot(self.ObservedSpectrum.Wavelengths, obs_flux_norm, label="Fake Data", color="black", linewidth=1.5)
        ax1.plot(my_result.Wavelengths, fit_flux_norm, label="MCMC Fit", color="orange", linewidth=2)
        
        my_residuals = (fit_flux_norm - obs_flux_norm) / obs_flux_norm

        ax2.plot(self.ObservedSpectrum.Wavelengths, my_residuals.value, color="blue", alpha=0.7)
        ax2.axhline(0, color='black', linestyle=':', alpha=0.5)

        # Formatting labels with units
        ax1.set_ylabel(f"Flux")
        ax1.legend(loc="upper right", ncol=2)
        ax2.set_ylabel(r"$\frac{F_{fit} - F_{obs}}{F_{obs}}$")
        ax2.set_xlabel(f"Wavelength ({self.ObservedSpectrum.Wavelengths.unit})")

        # Smart zoom for residuals
        res_min, res_max = np.percentile(my_residuals.value, [1, 99])
        ax2.set_ylim(res_min - 0.01, res_max + 0.01)

        plt.show()

        print(f"Total Absolute Residual: {np.sum(np.abs(my_residuals.value))}")