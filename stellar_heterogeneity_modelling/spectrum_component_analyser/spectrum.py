"""
super simple class that just wraps 2 arrays for arbitrary x, y axes for a spectrum

also has some util functions for working with spectra in general e.g. normalisation, convolution to a given resolution
"""

import numpy as np
import astropy.units as u
import scipy as sp
from astropy.visualization import quantity_support
quantity_support()
from matplotlib import pyplot as plt
import specutils
from astropy.units import Quantity
import warnings
from scipy.ndimage import gaussian_filter1d
from astropy.modeling import models
import spectres

DEFAULT_FLUX_UNIT = u.Jy

class spectrum:
	def __init__(
			self,
			wavelengths : np.array,
			fluxes : np.array,
			normalised_point : Quantity,
			observational_wavelengths : np.ndarray = None,
			temperature : Quantity[u.K] = None,
			name : str = None,
			normalise : bool = True
		):
		"""
		Flux is going to be stored in Janskys from now on

		This initialiser will normalise janskys for us; any reference to normalise_janskys outside of this class is redundant (if only python had private functions :/)

		Leave desired_resolution or normalised_point both to ignore regridding to a given resolution and/or normalising respectively.

		output_wavelengths must have a resolution of (at least approximately) the input desired resolution.

		Parameters
		----------

		wavelengths : np.array
			an array of astropy quantities

		phoenix_fluxes : np.array
			an array of astropy quantities (with some units that are convertible to Janskys by u.spectral_density equivalencies; e.g. Janskys themself or [erg / (s * cm**2 * cm)])

		temperature
			Used for normalisation
		"""

		wavelengths = np.atleast_1d(wavelengths)
		fluxes = np.atleast_1d(fluxes)
		
		if len(wavelengths) != len(fluxes):
			raise ValueError("Input wavelength and flux arrays must have the same length")
		
		fluxes_janskys = fluxes.to(DEFAULT_FLUX_UNIT, equivalencies=u.spectral_density(wavelengths))

		# make sure the wavelengths are in ascending order, so that normalising_janskys doesn't break
		indices = np.argsort(wavelengths) # get the indices that would sort the wavelengths np.array

		self.Wavelengths : np.array = wavelengths[indices]
		self.Fluxes : np.array = fluxes_janskys[indices]
		self.Name : str = name

		

		# Replace your interpolation step with:
		# n
		if normalise:
			self.normalise_flux()

		# sample onto a set of wavelengths (for an instrument with observational_wavelengths)
		if observational_wavelengths != None:
			self.regrid_flux(observational_wavelengths)
		
		self.Normalised_Point = normalised_point

	def regrid_flux(self, observational_wavelengths : np.ndarray) -> None:
		# spectres.spectres(new_wavs, spec_wavs, spec_fluxes, spec_errs=None, fill=None, verbose=True)
		self.Fluxes = spectres.spectres(observational_wavelengths.value, self.Wavelengths.to(observational_wavelengths.unit).value, self.Fluxes.value) * self.Fluxes.unit
		self.Wavelengths = observational_wavelengths
	
	def normalise_flux(self) -> None:
		"""
		normalise the average flux to 1 Jansky, in a similar vein to Passegger (2016) http://dx.doi.org/10.1051/0004-6361/201322261
		"""
		if (u.get_physical_type(self.Fluxes[0].unit) != u.get_physical_type(u.Jy)):
			raise ValueError(f"fluxes are in units of {self.Fluxes.unit}. this is not in a unit convertible to janskys. no normalisation will be carried out.")

		average_flux : Quantity[u.Jy] = np.average(self.Fluxes[np.where(np.isfinite(self.Fluxes))])
		self.Fluxes /= average_flux.value
		return

	def air_wavelengths(self, conversion_method : str = None): # use specutil default
		"""
		this assumes that the hdf5 is in vacuum units; can easily check metadata of hdf5 file
		"""
		if conversion_method is None:
			return specutils.utils.wcs_utils.vac_to_air(self.Wavelengths)
		else:
			return specutils.utils.wcs_utils.vac_to_air(self.Wavelengths, method=conversion_method)			
	
	def __getitem__(self, idx):
		"""
		Allow slicing, indexing, and boolean masks.
		Returns a new spectrum with sliced wavelength and flux arrays.
		"""
		return spectrum(self.Wavelengths[idx],
				  self.Fluxes[idx],
				  name=self.Name,
				  normalised_point=None, # no extra convolution or resampling is done on sliced spectra; we assume the fluxes and wavelengths are already as desired
				  observational_wavelengths=None,
				  temperature=None)
	def plot(self, clear : bool = True):
		if clear:
			plt.clf()
		plt.title(f"Observational Spectrum for {self.Name}")
		plt.plot(self.Wavelengths, self.Fluxes, label=self.Name)
	
	def __len__(self):
		if len(self.Wavelengths) != len(self.Fluxes):
			raise ValueError("wavelengths and fluxes must have the same length. (Length is not well defined)")
		
		return len(self.Fluxes)
	
	def __iter__(self):
		"""
		pandas complains very hard when trying to print dataframes containing spectrum objects if we dont define our own iterator
		"""
		return iter(self.Fluxes)
	
	def __repr__(self):
		unit = getattr(self.Fluxes, "unit", None)
		return f"<spectrum name={self.Name} len={len(self)} unit={unit}>"

	def __str__(self):
		return self.__repr__()
