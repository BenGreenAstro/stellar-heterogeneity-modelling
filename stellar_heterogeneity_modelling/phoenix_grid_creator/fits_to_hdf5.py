"""
this is going to download our spectrum data that meets some specified data ranges
this file should just be run once when you want to create the data grid, which is stored in the hdf5 format. Then you can load this hdf5 in quickly into a jupyter notebook etc to do the science. See basic_plotter.py for a way to read in the data
"""

# external imports
from matplotlib import pyplot as plt
import typer
import numpy as np
from astropy import units as u
from pathlib import Path

# internal imports
from phoenix_grid_creator.spectral_grid import spectral_grid
from spectrum_component_analyser.readers.JWST.instruments import NIRISS
from spectrum_component_analyser.readers.JWST.target import LTT3780
from spectrum_component_analyser.spectrum import spectrum
from spectrum_component_analyser.readers.JWST.file_reader import JWSTFileReader
from spectrum_component_analyser.readers import JWST_NORMALISING_POINT
from spectrum_component_analyser.readers.JWST.folder_reader import JWSTFolderReader
from spectrum_component_analyser.readers.fakedata_csv import get_fake_spectrum

SPECTRAL_GRID_FILENAME : Path = Path("test_JWST_not_oversmoothed.hdf5")

# data to request (these numbers have to be included in the PHOENIX dataset; view PHOENIX_filename_conventions.py for which are allowed)
T_effs = np.arange(2300, 4001, 100) * u.K
FeHs = np.array([-4, -3, -2, -1.5, -1, -0.5, 0, 0.5, 1]) * u.dex
log_gs = np.arange(0, 6.1, 0.5) * u.dex

# test values
# T_effs = [2300] * u.K
# FeHs = np.array([0])

# # # flags # # #

REGULARISE_WAVELENGTH_GRID : bool = True
# the wavelength in the df starts out in angstroms (we add units to an astropy QTable later)
MIN_WAVELENGTH_ANGSTROMS : float = 0.5 * 10**(-6) * 10**(10)
MAX_WAVELENGTH_ANGSTROMS : float = 5.5 * 10**(-6) * 10**(10) # phoenix only goes up to 5.5?
WAVELENGTH_NUMBER_OF_POINTS : int = 5
regularised_wavelengths : np.array = np.linspace(MIN_WAVELENGTH_ANGSTROMS, MAX_WAVELENGTH_ANGSTROMS, WAVELENGTH_NUMBER_OF_POINTS) * u.Angstrom

# temperature interpolation - deprecated as we can just use interpolated_phoenix_spectrum code
# REGULARISE_TEMPERATURE_GRID : bool = False
# MIN_TEMPERATURE_KELVIN = 2300
# MAX_TEMPERATURE_KELVIN = 4500
# TEMPERATURE_RESOLUTION_KELVIN = 50
# regularised_temperatures = np.arange(MIN_TEMPERATURE_KELVIN, MAX_TEMPERATURE_KELVIN + TEMPERATURE_RESOLUTION_KELVIN, TEMPERATURE_RESOLUTION_KELVIN)

def main():
	# example_spectrum_files : list[Path] = JWSTFolderReader.get_file_paths(LTT3780, NIRISS)
	# spectrum_to_decompose : spectrum = JWSTFileReader.get_spectrum(example_spectrum_files[0], instrument=NIRISS, INTEGRATION_INDEX=0, name="example spectrum")

	spectrum_to_decompose : spectrum = get_fake_spectrum("Fake_dataset.csv")

	spectral_grid.from_internet_raw(
		T_effs=T_effs,
		FeHs=FeHs,
		log_gs=log_gs
		)
	
	# spec_grid : spectral_grid = spectral_grid.from_internet(
	# 													 T_effs=T_effs,
	# 													 FeHs=FeHs,
	# 													 log_gs=log_gs,
	# 													 normalising_point=JWST_NORMALISING_POINT, # believe this is unused atm
	# 													 observational_resolution=.01 * u.um / 10, # from inspection of fake dataset its resolution is .01 * u.um
	# 													 observational_wavelengths=spectrum_to_decompose.Wavelengths,
	# 													 name="phoenix_data",
	# 													 parallelise=False
	# 													 )

	# spec_grid.save(grid_name="spectral_grid_for_fakedata", overwrite=True)

	# test_read : spectral_grid = spectral_grid.from_hdf5(grid_name="spectral_grid_for_fakedata")

	# test_read.get_spectrum(T_effs[0], FeHs[0], log_gs[0]).plot()
	# plt.show()

if __name__ == "__main__":
	typer.run(main)