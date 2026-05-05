== Simulating M dwarfs

In order to validate the method, we decompose simulated observational spectra back into their original, true components. In order to create these fake M dwarf spectra, we use the PHOENIX database to construct a multi-component spectrum according to @ComponentEquation. We then add Gaussian random noise at a given SNR (measured relative to the peak spectrum intensity), and only include data within a desired wavelength range. These steps aim to create a spectrum as it would be observed by a real instrument.

We then use the method outlined in @FittingProcedure to understand to what extent the original input parameters can be retrieved.

// PINEAPPLE