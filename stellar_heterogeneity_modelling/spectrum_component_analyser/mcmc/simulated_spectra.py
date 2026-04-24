import random
from typing import Tuple
from astropy.units import Quantity
from matplotlib import pyplot as plt
import numpy as np
import rich
from spectrum_component_analyser.interpolated_spectrum import get_interpolated_phoenix_spectrum
from spectrum_component_analyser.spectral_component import spectral_component
from spectrum_component_analyser.spectrum import spectrum
from constants import *
from astropy import units as u

from phoenix_grid_creator.spectral_grid import spectral_grid
from spectrum_component_analyser.phoenix_spectrum import phoenix_spectrum

def random_component(max_weight : float, spec_grid : spectral_grid, FeH : Quantity[u.dex], log_g : Quantity[u.dex]) -> spectral_component:
    w = random.random() * max_weight
    t : Quantity[u.K] = spec_grid.T_effs[random.randrange(0, len(spec_grid.T_effs))]
    if FeH != None:
        f = FeH
    else:
        f : Quantity[u.K] = spec_grid.FeHs[random.randrange(0, len(spec_grid.FeHs))]
    if log_g != None:
        l = log_g
    else:
        l : Quantity[u.K] = spec_grid.Log_gs[random.randrange(0, len(spec_grid.Log_gs))]
    
    return spectral_component(t, f, l, w)

def get_random_simulated_spectrum(number_of_components : int, spec_grid : spectral_grid, FeH : Quantity[u.dex] = None, log_g : Quantity[u.dex] = None) -> Tuple[list[spectral_component], list[phoenix_spectrum], spectrum]:
    components : list[spectral_component] = []
    component_spectra : list[phoenix_spectrum] = []
    total_weight_left = 1

    for i in range(number_of_components):
        c = random_component(total_weight_left, spec_grid, FeH, log_g)
        if i == number_of_components-1:
            c.Weight = total_weight_left
        components.append(c)
        total_weight_left -= c.Weight

        spec : phoenix_spectrum = spec_grid.get_spectrum_from_sc(c, name=f"component {i}")
        spec.Fluxes *= c.Weight

        component_spectra.append(spec)



    # sort to descending as a convention
    sorted_indices = np.argsort([c.T_eff.value for c in components])[::-1]
    components = [components[i] for i in sorted_indices]
    component_spectra = [component_spectra[i] for i in sorted_indices]

    # e.g. fix 1 of the 3 variables, plot chi-squared map at a given resolution in a 3 column subplot, then add rows going down that add resolution
    # then we can try bayesian stuffs

    total_flux = np.zeros_like(component_spectra[0].Fluxes)
    for s in component_spectra:
        total_flux += s.Fluxes

    combined_spectrum : spectrum = spectrum(component_spectra[0].Wavelengths, total_flux, None, None, None, None, name="Combined")

    # add noise
    snr = 20
    noise_sigma = np.max(combined_spectrum.Fluxes.value) / snr
    noise = np.random.normal(0, noise_sigma, combined_spectrum.Fluxes.shape) * combined_spectrum.Fluxes.unit
    combined_spectrum.Fluxes += noise

    combined_spectrum.plot()
    for s in component_spectra:
        s.plot(False)
    plt.legend()
    plt.title("Components and their sum")
    plt.show()

    return components, component_spectra, combined_spectrum

def get_simulated_spectra(spec_grid : spectral_grid, components : list[spectral_component]) -> Tuple[list[spectral_component], list[phoenix_spectrum], spectrum]:
    component_spectra : list[phoenix_spectrum] = []
    total_weight_left = 1

    for c in components:
        total_weight_left -= c.Weight

        spec : phoenix_spectrum = get_interpolated_phoenix_spectrum(c.T_eff, c.FeH, c.Log_g, star_name=f"component", spec_grid=spec_grid)
        # spec : phoenix_spectrum = spec_grid.get_spectrum_from_sc(c, name=f"component")
        
        spec.Fluxes *= c.Weight

        component_spectra.append(spec)



    # sort to descending as a convention
    sorted_indices = np.argsort([c.T_eff.value for c in components])[::-1]
    components = [components[i] for i in sorted_indices]
    component_spectra = [component_spectra[i] for i in sorted_indices]

    # e.g. fix 1 of the 3 variables, plot chi-squared map at a given resolution in a 3 column subplot, then add rows going down that add resolution
    # then we can try bayesian stuffs

    total_flux = np.zeros_like(component_spectra[0].Fluxes)
    for s in component_spectra:
        total_flux += s.Fluxes

    combined_spectrum : spectrum = spectrum(component_spectra[0].Wavelengths, total_flux, None, None, None, None, name="Combined")

    # add noise
    snr = 20
    noise_sigma = np.max(combined_spectrum.Fluxes.value) / snr
    noise = np.random.normal(0, noise_sigma, combined_spectrum.Fluxes.shape) * combined_spectrum.Fluxes.unit
    combined_spectrum.Fluxes += noise

    # optional plotting
    # combined_spectrum.plot()
    # for s in component_spectra:
    #     s.plot(False)
    # plt.legend()
    # plt.title("Components and their sum")
    # plt.show()

    return components, component_spectra, combined_spectrum