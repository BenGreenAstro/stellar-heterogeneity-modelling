from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import constants
import astropy.units as u

from spectrum_component_analyser.spectrum import spectrum

def get_fake_spectrum(file_path : Path) -> spectrum:
    """
    file_path : relative to the root of this repo
    """
    # usecols=[0,1,2] ignores that extra trailing comma/empty column if it exists
    df = pd.read_csv(constants.package_path / file_path, usecols=[0, 1, 2])

    # Clean up column names (removes any accidental whitespace)
    df.columns = df.columns.str.strip()

    # Access your data
    wave = df['wavelength_micron_vacuum']
    flux = df['flux_obs']
    err  = df['flux_err']

    # theres some duplicated wavelengths in the data
    unique_wave, first_indices, counts = np.unique(wave, return_index=True, return_counts=True)
    dupe_wavelengths = unique_wave[counts > 1]
    # print(dupe_wavelengths)

    wave = wave[first_indices]
    flux = flux[first_indices]
    err = err[first_indices]

    fake_spectrum = spectrum(
        wavelengths=wave.to_numpy() * u.um,
        fluxes=flux.to_numpy() * u.erg * u.s**-1 * u.cm**-2 * u.Angstrom**-1,
        normalised_point=None,
        observational_resolution=None,
        observational_wavelengths=None,
        temperature=None,
        normalise=True,
    )

    return fake_spectrum



if __name__ == "__main__":
    get_fake_spectrum("Fake_dataset.csv")