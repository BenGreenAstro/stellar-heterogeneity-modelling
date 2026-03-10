from astropy import units as u
from astropy.units import Quantity

import typer
from rich.console import Console
from rich.table import Table
import rich
from rich import box

class spectral_component():
    """
    Represents a tuple of T_eff (in Kelvin), FeH (in dex) and Log_g (in dex)

    Provides an iterable which is unpacked in the order: T_eff, FeH, Log_g
    """
    def __init__(self,
			  t_eff : Quantity[u.K],
              feh : Quantity[u.dex],
              log_g : Quantity[u.dex],
              weight : float = 1.0):
        self.T_eff = t_eff
        self.FeH = feh
        self.Log_g = log_g
        self.Weight = weight

    def __iter__(self):
        yield self.T_eff
        yield self.FeH
        yield self.Log_g
        yield self.Weight

    def pretty_print_singular(self, header : bool = True):
        table = Table("Weight", "T_eff", "[FeH]", "log g", box=box.MINIMAL)
        table.add_row(str(self.Weight), str(self.T_eff), str(self.FeH), str(self.Log_g))
        rich.print(table)
    
    def pretty_print(self, table : Table):
        table.add_row(str(self.Weight), str(self.T_eff), str(self.FeH), str(self.Log_g))

class spectral_component_list():
    def __init__(self, components : list[spectral_component]):
        self.Components = components
    
    def pretty_print(self):
        table = Table("Weight", "T_eff", "[FeH]", "log g", box=box.MINIMAL)
        c : spectral_component
        for c in self.Components:
            c.pretty_print(table)
        rich.print(table)
    
    # could also define a plotting function which visualises x axis: [FeH] y axis: log g, component is plotted as a circle with area \propto weight and colour determined by T_eff (redder for higher wavelengths) - or just a somewhat accurate colour of a star with that temperature

if __name__ == "__main__":
    test_component = spectral_component(1 * u.K, 1 * u.dex, 1 * u.dex, .4)
    test_component.pretty_print_singular()

    other_test_component = spectral_component(2000 * u.K, 1 * u.dex, 0 * u.dex, .6)

    list = spectral_component_list([test_component, other_test_component])

    list.pretty_print()