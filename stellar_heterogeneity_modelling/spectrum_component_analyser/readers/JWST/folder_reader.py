from enum import Enum
from pathlib import Path

import matplotlib.pyplot as plt
from spectrum_component_analyser.readers.JWST.target import TRAPPIST1, JWSTTarget
from tqdm import tqdm
import typer

from spectrum_component_analyser.readers.JWST.instruments import Instrument, NIRISS, NIRSPECLower 
from spectrum_component_analyser.readers.JWST.file_reader import JWSTFileReader
from spectrum_component_analyser.spectrum import spectrum
from internal_constants import *

import vanity

class JWSTFolderReader():
	@staticmethod
	def get_file_path(target : JWSTTarget, instrument : Instrument) -> Path:
		return Path(f"{package_path}/neater_observed_spectra_folder/{target.name}/{instrument.FolderPath}/")
	
	@staticmethod
	def get_all_spectra(target : JWSTTarget, instrument : Instrument) -> list[spectrum]:
		"""
		returns all spectra from all .fits files contained in fits_directory (specification is in get_file_path() and also a markdown file)
		"""
		fits_directory : Path = JWSTFolderReader.get_file_path(target, instrument)

		print(fits_directory)

		all_spectra : list[spectrum] = []

		files = list(fits_directory.glob("*.fits"))

		for path in tqdm(files, desc=f"Loading in JWST *.fits from {vanity.LIGHT_BLUE}{fits_directory}{vanity.RESET}"):
			all_spectra.extend(
				JWSTFileReader.get_all_spectra(
					file_path=path,
					instrument=instrument,
					verbose=False
				)
			)

		return all_spectra

def main() -> None:
	"""
	example usage
	"""
	niriss_spectra = []
	nirspec_spectra = []
	niriss_spectra = JWSTFolderReader.get_all_spectra(TRAPPIST1, NIRISS)
	# nirspec_spectra = read_all_JWST_fits(JWSTTargets.LTT3780, NIRSPEC)

	all_spectra = [*nirspec_spectra, *niriss_spectra]

	s : spectrum
	for s in all_spectra:
		s.plot(clear=False)
	
	plt.show()

if __name__ == "__main__":
	typer.run(main)