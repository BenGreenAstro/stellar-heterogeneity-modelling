"""
class that includes the current literature belief for parameters

usually uses the most recent paper from the exoplanet archive e.g. https://exoplanetarchive.ipac.caltech.edu/overview/LTT%203780
"""

from dataclasses import dataclass

from astropy.units import Quantity
import astropy.units as u

@dataclass(frozen=True)
class JWSTTarget:
    name : str
    t_eff : Quantity[u.K]
    feh : Quantity[u.dimensionless_unscaled]
    log_g : Quantity[u.dimensionless_unscaled]

LTT3780 : JWSTTarget = JWSTTarget(
    name="LTT 3780",
    t_eff=3358 * u.K,
    feh=0.06,
    log_g = 4.85
)

LTT144A : JWSTTarget = JWSTTarget(
    name="LTT 1445A",
    t_eff=3340 * u.K,
    feh=-0.34,
    log_g = 4.967
)

K218 : JWSTTarget = JWSTTarget(
    name="K2-18",
    t_eff=3449 * u.K,
    feh=0.0,
    log_g = 4.6
)

TRAPPIST1 : JWSTTarget = JWSTTarget(
    name="TRAPPIST-1",
    t_eff=2566 * u.K,
    feh=0.0520,
    log_g = 5.2396
)