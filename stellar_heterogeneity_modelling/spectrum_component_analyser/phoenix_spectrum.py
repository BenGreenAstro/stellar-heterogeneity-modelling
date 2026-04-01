from pathlib import Path
from typing import Sequence
from matplotlib import pyplot as plt
import numpy as np
from astropy.units import Quantity
import astropy.units as u
from astropy.io import fits

from phoenix_grid_creator.PHOENIX_filename_conventions import decode_filename, get_file_name, get_url
from spectrum_component_analyser import spectral_component
from spectrum_component_analyser.spectrum import spectrum
from constants import *

class phoenix_spectrum(spectrum):
	def __init__(
			  self,
			  wavelengths : np.array,
			  fluxes : np.array,
			  t_eff : Quantity[u.K],
			  feh,
			  log_g,
			  normalising_point : Quantity = None,
			  observational_resolution : Quantity = None,
			  observational_wavelengths : np.ndarray = None,
			  name : str = ""
			):
			super().__init__(
				wavelengths,
				fluxes,
				normalised_point=normalising_point,
				observational_resolution=observational_resolution,
				observational_wavelengths=observational_wavelengths,
				temperature=t_eff,
				name=name
			)
			self.T_eff = t_eff
			self.FeH = feh
			self.Log_g = log_g
		
	def plot(self, clear : bool = True):
		if clear:
			plt.clf()
		plt.title(f"Simulated Spectrum for {self.Name}")
		plt.plot(self.Wavelengths, self.Fluxes, label=self.Name)
	
	FLUX_UNITS : Quantity = u.erg / (u.s * u.cm**2 * u.cm)

	@classmethod
	def from_fits(cls, T_eff : Quantity[u.K], FeH : Quantity[u.dex], log_g : Quantity[u.dex], phoenix_wavelengths : Sequence[Quantity]):
		"""
		for local fits files mirrored from https://phoenix.astro.physik.uni-goettingen.de/data/HiResFITS/
		"""
		# the index of the header data unit the data we want is in (looks to be 0 being the spectra, and 1 being the abundances, and those are the only 2 HDUs in the .fits files)
		SPECTRA_HDU_INDEX = 0

		# get filename
		file : Path = package_path / raw_phoenix_path / Path(get_file_name(T_eff, FeH, log_g, lte=True, alphaM=0))

		with fits.open(file) as hdul:
			# for some reason, the fits file is big-endian; pandas required little-endian
			fluxes = hdul[SPECTRA_HDU_INDEX].data
			fluxes = fluxes.byteswap().view(fluxes.dtype.newbyteorder())
			fluxes *= phoenix_spectrum.FLUX_UNITS

			return cls(
				wavelengths=phoenix_wavelengths,
				fluxes=fluxes,
				t_eff=T_eff,
				feh=FeH,
				log_g=log_g,
				normalising_point=None,
				observational_resolution=None,
				observational_wavelengths=None,
				name="simulated spectrum from PHOENIX fits file")