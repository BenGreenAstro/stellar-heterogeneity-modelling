from pathlib import Path

package_path : Path = (Path(__file__) / "../..").resolve()
src_path : Path = (Path(__file__) / "..").resolve()
spectral_grids_path : Path = (package_path / "spectral_grids").resolve()

raw_phoenix_path : Path = Path("raw_phoenix_spectra")

if __name__ == "__main__":
    print(f"package_path = {package_path}")
    print(f"src_path = {src_path}")