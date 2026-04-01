import datetime
import itertools
from pathlib import Path
from typing import Self, Sequence, Tuple
from astropy.units import Quantity, Unit
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
import time
import random
import subprocess

from spectrum_component_analyser.phoenix_spectrum import phoenix_spectrum
from phoenix_grid_creator.PHOENIX_filename_conventions import get_file_name, get_url
from constants import *

def download_raw_spectrum(T_eff : Quantity[u.K],
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

	output_path : Path = package_path / Path("raw_phoenix_spectra") / Path(file)

	output_path.parent.mkdir(parents=True, exist_ok=True)
	
	if output_path.exists():
		if output_path.stat().st_size < 2_000_000: # they all look to be 6mb; this redownloads any below ~2mb
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
