# Folder Structure Specification

The structure assumed by `readers.py`:

`neater_observed_spectra_folder/target_name/instrument_name/<any_file_name>.fits`

- `target_name`: name of stellar target (in same format as the exoplanet archive)
- `instrument_name`: NIRISS (lower wavelengths) or NIRSPECLower / NIRSPECHigher (higher wavelengths, split into 2 sections of the instrument)
- `<any_file_name>` is ignored; just read in all *.fits in the specified folder and stitch them together to form the transmission curve (we assume they are ordered correctly)
