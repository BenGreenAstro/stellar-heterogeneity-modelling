import datetime
import itertools
from pathlib import Path
from typing import Self, Sequence, Tuple
from astropy.units import Quantity
import numpy as np
import astropy.units as u
from io import BytesIO
from joblib import Parallel, delayed
import requests
from requests.adapters import Retry
from tqdm import tqdm
import numpy as np
from astropy.io import fits
from astropy import units as u
from pathlib import Path
import datetime
import h5py
from astropy.units import Unit
import time
import random

# versioning - used to save correct version into the hdf5 file
from importlib.metadata import version
__version__ = version("spots_and_faculae_model")

# internal imports
from phoenix_grid_creator.PHOENIX_filename_conventions import *
from spectrum_component_analyser.phoenix_spectrum import phoenix_spectrum
from spectrum_component_analyser.spectrum import DEFAULT_FLUX_UNIT
from constants import *

PHOENIX_FLUX_UNITS : Quantity = u.erg / (u.s * u.cm**2 * u.cm)

UNIT_METADATA_NAME : str = "units"
WAVELENGTH_DATASET_NAME : str = "wavelengths"
TEFF_DATASET_NAME : str = "Teff"
FEH_DATASET_NAME : str = "FeH"
LOGG_DATASET_NAME : str = "log_g"
FLUX_DATASET_NAME : str = "fluxes"

MAIN_GRID_NAME : str = "main_grid"

USES_REGULARISED_WAVELENGTHS_METADATA_NAME : str = "includes interpolated wavelengths?"
USES_REGULARISED_TEMPERATURES_METADATA_NAME : str = "includes interpolated temperatures?"

def get_phoenix_wavelengths() -> Sequence[Quantity]:
	"""
	returns 1D array consisting of astropy Quantities of dimension length
	"""
	# read in the wavelength (1D) grid so we can save this into our mega-grid correctly

	script_dir = Path(__file__).resolve().parent
	WAVELENGTH_GRID_RELATIVE_PATH = Path("calibration_files/WAVE_PHOENIX-ACES-AGSS-COND-2011.fits")
	wavelength_grid_absolute_path = (package_path / WAVELENGTH_GRID_RELATIVE_PATH).resolve()

	if not wavelength_grid_absolute_path.exists():
		raise FileNotFoundError(f"wavelength grid file not found at : {wavelength_grid_absolute_path}.")

	with fits.open(wavelength_grid_absolute_path) as hdul:
		# there is only 1 HDU in this wavelength grid file
		WAVELENGTH_GRID_HDU_INDEX = 0
		wavelengths = hdul[WAVELENGTH_GRID_HDU_INDEX].data
		# the fits file is big endian; pandas requires little endian. this swaps between them
		wavelengths = wavelengths.byteswap().view(wavelengths.dtype.newbyteorder())
		wavelengths *= u.Angstrom
		print("[PHOENIX GRID CREATOR] : phoenix wavelength grid found & loaded in")

	return wavelengths

def get_configured_session(number_of_workers : int = 4):
	session = requests.Session()
	retry_strategy = Retry(
		total=5,
		backoff_factor=2,
		status_forcelist=[429, 500, 502, 503, 504]
	)
	adapter = requests.adapters.HTTPAdapter(pool_connections=number_of_workers, pool_maxsize=number_of_workers, max_retries=retry_strategy)
	session.mount('https://', adapter)
	session.headers.clear()
	session.headers.update({
		"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
		"Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
		"Accept-Encoding": "gzip, deflate, br",
		"Accept-Language": "en-US,en;q=0.9",
		"Cache-Control": "max-age=0",
		"Sec-Ch-Ua": '"Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"',
		"Sec-Ch-Ua-Mobile": "?0",
		"Sec-Ch-Ua-Platform": '"Windows"',
		"Upgrade-Insecure-Requests": "1"
	})
	return session

MAX_WORKERS = 1
TIMEOUT_SETTINGS = (10, 60) # (Connect timeout, Read timeout)

shared_session = get_configured_session(MAX_WORKERS)

def download_spectrum(T_eff : Quantity[u.K],
					  FeH : Quantity[u.dex],
					  log_g : Quantity[u.dex],
					  lte : bool,
					  alphaM : float,
					  phoenix_wavelengths : np.array,
					  normalising_point : Quantity,
					  observational_resolution : Quantity,
					  observational_wavelengths : np.ndarray,
					  name : str) -> phoenix_spectrum:
	"""
	we'll use this function to parallelise getting the spectra

	if you want to use the original phoenix spectrum, just leave regularised_wavelengths as none
	"""
	time.sleep(random.uniform(1.0, 3.0)) # random jitter to not appear like abot
	try:
		file = get_file_name(
			lte=lte,
			T_eff=T_eff,
			FeH=FeH,
			log_g=log_g,
			alphaM=alphaM
			)
		url = get_url(file)
	except ValueError as e:
		tqdm.write(f"[PHOENIX GRID CREATOR] : filename or urlname error: {e}. continuing onto next requested spectrum")
		return
	try:
		with shared_session.get(url, stream=True, timeout=TIMEOUT_SETTINGS) as response:
			response.raise_for_status()
	
			# the index of the header data unit the data we want is in (looks to be 0 being the spectra, and 1 being the abundances, and those are the only 2 HDUs in the .fits files)
			SPECTRA_HDU_INDEX = 0

			with fits.open(BytesIO(response.content)) as hdul:
				# for some reason, the fits file is big-endian; pandas required little-endian
				fluxes = hdul[SPECTRA_HDU_INDEX].data
				fluxes = fluxes.byteswap().view(fluxes.dtype.newbyteorder())
				fluxes *= PHOENIX_FLUX_UNITS

				# interpolation onto observational // physical wavelengths is done by the internals.
				spec = phoenix_spectrum(
					wavelengths=phoenix_wavelengths,
					fluxes=fluxes,
					t_eff=T_eff,
					feh=FeH,
					log_g=log_g,
					normalising_point=normalising_point,
					observational_resolution=observational_resolution,
					observational_wavelengths=observational_wavelengths,
					name=name)

				return spec
	except requests.exceptions.HTTPError as e:
		tqdm.write(f"[PHOENIX GRID CREATOR] : HTTPError raised with the following parameters:\nlte: {lte}\nT_eff={T_eff}\nlog_g={log_g}\nFeH={FeH}\nalphaM={alphaM}")
		tqdm.write(f"attempted url = {url}")
		tqdm.write("\n continuing with the next file...")
		return

import subprocess

def download_raw_spectrum(
					  T_eff : Quantity[u.K],
					  FeH : Quantity[u.dex],
					  log_g : Quantity[u.dex],
					  lte : bool,
					  alphaM : float) -> phoenix_spectrum:
	"""
	we'll use this function to parallelise getting the spectra

	if you want to use the original phoenix spectrum, just leave regularised_wavelengths as none
	"""
	file = get_file_name(
		lte=lte,
		T_eff=T_eff,
		FeH=FeH,
		log_g=log_g,
		alphaM=alphaM
		)
	url = get_url(file)

	output_path : Path = package_path / Path("new_raw_phoenix_spectra") / Path(file)

	output_path.parent.mkdir(parents=True, exist_ok=True)
	
	if output_path.exists():
		if output_path.stat().st_size < 1000000:
			output_path.unlink()
			print("fits file too small: assumed its probably a corrupted error page or something. deleting file and re-downloading")
		else:
			print(f"{output_path} already exists: skipping")
			return
	
	wait_time = random.uniform(0.1, .3)
	tqdm.write(f"waiting for {round(wait_time, 2)}s")
	time.sleep(wait_time) # random jitter to not appear like abot

	subprocess.run(
		[
			"curl",
			"--limit-rate", "2000k",
			"-L",
			"-A", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
			"-o",
			str(output_path),
			url
		], check=True)

class spectral_grid():
	"""
	Recommended to not use this class manually, unless using the wrappers such as from_internet and from_hdf5.

	This is an internal class really. It's much more human readable to just use list[spectrum] or spectral_list; this is just for saving to / loading from a hdf5 file.
	"""
	def __init__(self,
			  wavelengths : Sequence[Quantity],
			  t_effs : Sequence[Quantity[u.K]],
			  fehs : Sequence[Quantity[u.dex]],
			  log_gs : Sequence[Quantity[u.dex]],
			  fluxes : Sequence[Quantity], # this needs to be convertible to Janskys aka u.Jy (code will error if not)
			  uses_regularised_wavelengths : bool,
			  uses_regularised_temperatures : bool,
			  _internal=False):
		"""
		Don't use this init: use the other wrappers that download things or load in from a hdf5 file (the structure of the fluxes array is non trivial)
		"""

		if (not _internal):
			raise RuntimeError("Spectral Grid's __init__ should only be used by internal methods: use factory methods instead")

		# 1D arrays
		self.Wavelengths = wavelengths
		self.T_effs = t_effs
		self.FeHs = fehs
		self.Log_gs = log_gs

		# this is a 4D array
		self.Fluxes = fluxes

		self.Uses_Regularised_Wavelengths = uses_regularised_wavelengths
		self.Uses_Regularised_Temperatures = uses_regularised_temperatures

		self.LookupTable = self.to_lookup_table()

	@staticmethod
	def from_internet_raw(
				   T_effs,
				   FeHs,
				   log_gs,
				   lte = True,
				   alphaM = 0,
	):
		for t, f, l in tqdm(itertools.product(T_effs, FeHs, log_gs)):
			download_raw_spectrum(t, f, l, lte, alphaM)
		
	@classmethod
	def from_internet(cls,
				   T_effs,
				   FeHs,
				   log_gs,
				   normalising_point : Quantity["length"],
				   observational_resolution : Quantity["length"],
				   observational_wavelengths : np.ndarray,
				   name : str,
				   alphaM = 0,
				   lte = True,
				   regularised_temperatures : Sequence[Quantity] = None,
				   parallelise : bool = True) -> Self:
		"""
		Download the spectra for all combinations between T_effs, FeHs and log_gs from the internet, and wrap it into a nice class.

		The list of components that go into creating this spectral grid is the cartesian product of the 3 input lists.

		Use this if you want a large number of spectra over a large parameter space.
		"""
		if regularised_temperatures != None:
			raise NotImplementedError("regularising temperatures is not added into simpler spectral grid atm")
		
		phoenix_wavelengths = get_phoenix_wavelengths()
		
		def fetch_spectra_and_indices(i, j, k, T_eff, FeH, log_g) -> Tuple[int, int, int, Quantity[u.K], Quantity[u.dex], Quantity[u.dex]]:
			spec : phoenix_spectrum = download_spectrum(
											   T_eff,
											   FeH,
											   log_g,
											   lte,
											   alphaM,
											   phoenix_wavelengths,
											   normalising_point=normalising_point,
											   observational_resolution=observational_resolution,
											   observational_wavelengths=observational_wavelengths,
											   name=f"{name}_Teff-{T_eff}_FeH-{FeH}_logg-{log_g}"
											   )
			return i, j, k, spec
		
			
		tasks = [
			(i, j, k, t, f, g)
			for i, t in enumerate(T_effs)
			for j, f in enumerate(FeHs)
			for k, g in enumerate(log_gs)
		]

		if parallelise:
			results = Parallel(n_jobs=-1, prefer="threads")(
				delayed(fetch_spectra_and_indices)(*task) for task in tqdm(tasks, desc="downloading spectra...")
			)
		else:
			results = [
				fetch_spectra_and_indices(*task) for task in tqdm(tasks, desc="downloading spectra...")
			]

		_, _, _, example_spec = results[0]
		
		# pre - allocate 4d flux array. assumes all spectra have the same wavelength array
		fluxes = np.zeros((len(T_effs), len(FeHs), len(log_gs), len(example_spec.Wavelengths)))

		spec : phoenix_spectrum
		for i, j, k, spec in results:
			# i think this removes units from fluxes silently - as this is some 4D array. maybe we can readd them somehow; doesnt rly matter for now though
			fluxes[i, j, k, :] = spec.Fluxes

		# assume all spectra have the same wavelengths
		return cls(spec.Wavelengths,
			 T_effs,
			 FeHs,
			 log_gs,
			 fluxes,
			 observational_wavelengths != None,
			 regularised_temperatures != None,
			 _internal=True)
	
	@staticmethod
	def get_file_name(grid_name : str):
		if not grid_name.endswith(".hdf5"):
			grid_name = grid_name.split('.')[0] + ".hdf5"
		return grid_name

	def save(self, grid_name : str, overwrite : bool):
		"""
		saves to Path("spectral_grids_path / grid_name")
		"""

		file_name = spectral_grid.get_file_name(grid_name)
		
		grid_path = Path(spectral_grids_path / file_name)

		if grid_path.exists() and not overwrite:
			raise FileExistsError(f"specified path already exists; and overwrite is set to false. Change the file name or turn on overwrite. (File path: {grid_path})")
		
		with h5py.File(grid_path, "w") as file:
			file.attrs["creator"] = "Ben Green"
			file.attrs["description"] = "Collection of synthetic spectra from PHOENIX dataset"
			file.attrs["github url"] = "https://github.com/Part-III-Project-48/stellar-heterogeneity-modelling"
			file.attrs["version"] = __version__
			file.attrs["creation date (of this file)"] = str(datetime.datetime.now())
			file.attrs["notes"] = "All spectra share the same wavelength grid."

			# add some metadata to the QTable e.g. (wavelength medium = vacuum, source, date)
			file.attrs["wavelength medium"] = "vacuum"
			file.attrs["source"] = "https://phoenix.astro.physik.uni-goettingen.de/data/"

			file.attrs[USES_REGULARISED_WAVELENGTHS_METADATA_NAME] = self.Uses_Regularised_Wavelengths
			file.attrs[USES_REGULARISED_TEMPERATURES_METADATA_NAME] = self.Uses_Regularised_Temperatures

			group = file.create_group(MAIN_GRID_NAME)

			# we have to remove units from our np arrays and write them to metadata to be retrieved later

			wavelength_unit = self.Wavelengths.unit
			T_eff_unit = self.T_effs.unit

			# spectrum class forces everything into DEFAULT_FLUX_UNIT (currently Janskys) (or maybe megajanskys; but its all normalised anyway so I don't think it matters much)
			flux_unit = DEFAULT_FLUX_UNIT

			wavelength_dataset = group.create_dataset(WAVELENGTH_DATASET_NAME, data=np.array(self.Wavelengths))
			wavelength_dataset.attrs[UNIT_METADATA_NAME] = str(wavelength_unit)

			T_eff_dataset = group.create_dataset(TEFF_DATASET_NAME, data=np.array([i.value for i in self.T_effs]))
			T_eff_dataset.attrs[UNIT_METADATA_NAME] = str(T_eff_unit)

			FeH_dataset = group.create_dataset(FEH_DATASET_NAME, data=self.FeHs)
			FeH_dataset.attrs[UNIT_METADATA_NAME] = str(u.dex)

			log_g_dataset = group.create_dataset(LOGG_DATASET_NAME, data=self.Log_gs)
			log_g_dataset.attrs[UNIT_METADATA_NAME] = str(u.dex)

			flux_dataset = group.create_dataset(FLUX_DATASET_NAME, data=np.array(self.Fluxes))
			flux_dataset.attrs[UNIT_METADATA_NAME] = str(flux_unit)

		print("[PHOENIX GRID CREATOR] : hdf5 saving complete")

	@classmethod
	def from_hdf5(cls, grid_name : str):
		"""
		Parameters
		----------
		grid_name
			name of the file to be loaded in from the spectral_grids folder
		"""
		
		file_name = spectral_grid.get_file_name(grid_name)
		
		with h5py.File((spectral_grids_path / file_name).resolve(), "r") as f:
			main_grid = f[MAIN_GRID_NAME]

			wavelengths = main_grid[WAVELENGTH_DATASET_NAME]
			wavelengths = np.array(wavelengths) * Unit(wavelengths.attrs[UNIT_METADATA_NAME], parse_strict='raise')

			T_effs = main_grid[TEFF_DATASET_NAME]
			T_effs = np.array(T_effs) * Unit(T_effs.attrs[UNIT_METADATA_NAME], parse_strict='raise')

			FeHs = main_grid[FEH_DATASET_NAME]
			FeHs = np.array(FeHs) * Unit(FeHs.attrs[UNIT_METADATA_NAME], parse_strict='raise')

			log_gs = main_grid[LOGG_DATASET_NAME]
			log_gs = np.array(log_gs) * Unit(log_gs.attrs[UNIT_METADATA_NAME], parse_strict='raise')

			fluxes = main_grid[FLUX_DATASET_NAME]
			fluxes = np.array(fluxes) * Unit(fluxes.attrs[UNIT_METADATA_NAME], parse_strict='raise')

			uses_regularised_wavelengths = f.attrs[USES_REGULARISED_WAVELENGTHS_METADATA_NAME]

			uses_regularised_temperatures = f.attrs[USES_REGULARISED_TEMPERATURES_METADATA_NAME]
			
		return cls(wavelengths, T_effs, FeHs, log_gs, fluxes, uses_regularised_wavelengths, uses_regularised_temperatures, _internal=True)
	
	def get_spectrum(self, T_eff : Quantity[u.K], FeH, log_g) -> phoenix_spectrum:
		i = np.where(self.T_effs == T_eff)[0][0]
		j = np.where(self.FeHs   == FeH)[0][0]
		k = np.where(self.Log_gs == log_g)[0][0]

		spec : phoenix_spectrum = phoenix_spectrum(self.Wavelengths, self.Fluxes[i, j, k, :], T_eff, FeH, log_g)

		return spec
	
	def to_lookup_table(self) -> Sequence[Quantity]:
		"""
		This is kinda fragile atm because it assumes that the structure of Fluxes isn't messed with after initialisation (maybe reasonable but arguably not)

		Usage:
			fluxes = lookup_table[T_eff, FeH, log_g]
		Remarks:
			gives the flux (as a numpy array of quantities) for those parameters (if that exists)

			and its O(1)
		"""
		return {
			(T_eff, FeH, log_g): self.Fluxes[i, j, k, :]
			for i, T_eff in enumerate(self.T_effs)
			for j, FeH in enumerate(self.FeHs)
			for k, log_g in enumerate(self.Log_gs)
		}
	

# dev testing

if __name__ == "__main__":
	import cProfile
	import pstats

	profiler = cProfile.Profile()
	
	# We use a lambda or just call it inside 'runcall'
	profiler.enable()
	download_spectrum(
		T_eff=2500 * u.K,
		FeH=1.0 * u.dex,
		log_g=1.0 * u.dex,
		normalising_point=1.0 * u.um,
		observational_resolution= .01 * u.um,
		observational_wavelengths=np.linspace(1 * u.um, 2 * u.um, 1000),
		name="test",
		lte=True,
		alphaM=0.0,
		phoenix_wavelengths=get_phoenix_wavelengths()
	)
	profiler.disable()

	stats = pstats.Stats(profiler).sort_stats('cumulative')
	stats.print_stats(20) # Top 20 most expensive calls