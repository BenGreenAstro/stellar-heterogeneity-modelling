from matplotlib import pyplot as plt
import numpy as np
import rich
import scipy as sp
from astropy import units as u

from phoenix_grid_creator.spectral_grid import spectral_grid
from spectrum_component_analyser.interpolated_spectrum import get_interpolated_phoenix_spectrum
from spectrum_component_analyser.phoenix_spectrum import phoenix_spectrum
from spectrum_component_analyser.spectrum import spectrum

class ChiHelper():
    def __init__(
            self,
            spec_grid : spectral_grid,
            number_of_components : int,
            number_of_parameters : int,
            observed_spectrum : spectrum
    ):
        self.spec_grid = spec_grid
        self.number_of_components = number_of_components
        self.number_of_parameters = number_of_parameters
        self.observed_spectrum = observed_spectrum
    
    def chi_squared_error(self, params):
        observed = self.observed_spectrum.Fluxes.copy()
        simulated : np.ndarray = []
        
        for i in range(self.number_of_components):
            weight = params[0 + i * self.number_of_parameters]
            t = params[1 + i * self.number_of_parameters]
            f = params[2 + i * self.number_of_parameters]
            l = params[3 + i * self.number_of_parameters]

            t *= u.K
            f *= u.dex
            l *= u.dex

            spec : phoenix_spectrum = get_interpolated_phoenix_spectrum(t, f, l, star_name="simulated spectrum", spec_grid=self.spec_grid)

            if len(simulated) == 0:
                simulated = weight * spec.Fluxes
            else:
                simulated += weight * spec.Fluxes

        e = np.sum(((observed - simulated)**2).value)

        return e

    def get_r(self, parameter_bounds) -> sp.optimize.OptimizeResult:
        initial_guess = [
            1,
            3000,
            0.0,
            0.0
        ]

        r : sp.optimize.OptimizeResult = sp.optimize.differential_evolution(
            func=self.chi_squared_error,
            # x0 = initial_guess * number_of_components,
            bounds=parameter_bounds * self.number_of_components,
            callback=print,
            maxiter=100
        )

        return r
    
    def plot(self, r : sp.optimize.OptimizeResult):
        total_flux = []

        for i in range(self.number_of_components):
            w_title : str = f"weight {i}"
            t_title : str = f"teff {i}"
            f_title : str = f"feh {i}"
            l_title : str = f"log_g {i}"

            w = r.x[0 + self.number_of_parameters*i]
            t = r.x[1 + self.number_of_parameters*i] * u.K
            f = r.x[2  + self.number_of_parameters*i] * u.dex
            l = r.x[3 + self.number_of_parameters*i] * u.dex

            print(f"{w_title:<20} : {w}")
            print(f"{t_title:<20} : {t}")
            print(f"{f_title:<20} : {f}")
            print(f"{l_title:<20} : {l}")
            print("\n")

            
            componentised_spectrum = get_interpolated_phoenix_spectrum(t, f, l, star_name= f"simulated spectrum component {i}", spec_grid=self.spec_grid)

            componentised_spectrum.Fluxes *= w

            componentised_spectrum.plot(clear=False)

            if len(total_flux) == 0:
                total_flux = componentised_spectrum.Fluxes
            else:
                total_flux += componentised_spectrum.Fluxes

        plt.legend()
        plt.show()

        # plot components neatly
        # make subplot with: literature belief parameters & residuals, our 1 component solution & residuals, our 2 / 3 etc component solution

        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(30, 16), sharex=True)

        my_result : spectrum = spectrum(
            wavelengths = self.observed_spectrum.Wavelengths,
            fluxes=total_flux,
            normalised_point=None,
            observational_resolution=None,
            observational_wavelengths=None,
            temperature=None,
            name="my result",
            normalise=False
        )

        # normalise everything for now as im unsure
        self.observed_spectrum.normalise_flux()
        my_result.normalise_flux()

        ax1.plot(self.observed_spectrum.Wavelengths, self.observed_spectrum.Fluxes, label="simulated spectrum", color="black")
        ax1.plot(my_result.Wavelengths, my_result.Fluxes, label="my result", color="orange")

        my_residuals = np.abs(my_result.Fluxes - self.observed_spectrum.Fluxes) / self.observed_spectrum.Fluxes

        # ax2.plot(self.observed_spectrum.Wavelengths, literature_residuals, label="literature", color="orange")
        ax2.plot(self.observed_spectrum.Wavelengths, my_residuals, label="my result", color="blue")
        ax2.set_ylabel(r"Residual = $\frac{\mathrm{Fitted\ Flux}-\mathrm{Observed\ Flux}}{\mathrm{Observed\ Flux}}$")

        ax1.legend()
        ax2.legend()

        plt.show()

        print(np.sum(np.abs(my_residuals)))