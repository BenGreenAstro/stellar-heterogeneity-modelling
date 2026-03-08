"""
class that includes the current literature belief for parameters

usually uses the most recent paper from the exoplanet archive e.g. https://exoplanetarchive.ipac.caltech.edu/overview/LTT%203780
"""

from dataclasses import dataclass
from astropy.units import Quantity
import astropy.units as u

from matplotlib import pyplot as plt
from spectrum_component_analyser.internals.phoenix_spectrum import phoenix_spectrum
from spectrum_component_analyser.interpolated_spectrum import get_interpolated_phoenix_spectrum
from spectrum_component_analyser.internals.spectral_grid import spectral_grid

@dataclass(frozen=True)
class JWSTTarget:
    name : str
    t_eff : Quantity[u.K]
    feh : Quantity[u.dimensionless_unscaled]
    log_g : Quantity[u.dimensionless_unscaled]

    def plot(self, spec_grid : spectral_grid, clear : bool = True):
        interpolated : phoenix_spectrum = get_interpolated_phoenix_spectrum(
                T_eff=self.t_eff,
                FeH=self.feh,
                Log_g=self.log_g,
                star_name=self.name + " literature belief",
                spec_grid=spec_grid
                )
        interpolated.plot(clear = clear)

LTT3780 : JWSTTarget = JWSTTarget(
    name="LTT 3780",
    t_eff=3358 * u.K,
    feh=0.06 * u.dex,
    log_g = 4.85 * u.dex
)

LTT144A : JWSTTarget = JWSTTarget(
    name="LTT 1445A",
    t_eff=3340 * u.K,
    feh=-0.34 * u.dex,
    log_g = 4.967 * u.dex
)

K218 : JWSTTarget = JWSTTarget(
    name="K2-18",
    t_eff=3449 * u.K,
    feh=0.0 * u.dex,
    log_g = 4.6 * u.dex
)

TRAPPIST1 : JWSTTarget = JWSTTarget(
    name="TRAPPIST-1",
    t_eff=2566 * u.K,
    feh=0.0520 * u.dex,
    log_g = 5.2396 * u.dex
)