#import "@preview/unify:0.8.0": qty, unit, num

= Conclusion

In conclusion, this work focused on modelling M dwarf spectra as a sum of photospheric and spotted components. Fake stellar spectra were produced using PHOENIX data, and processed using a simple pipeline to simulate how they would be observed by current space-based telescopes. The degree to which the input parameters $T_"eff"$, [Fe/H], $log g$ and $f$ could be reproduced was analysed.

Retrieving the parameters for a homogeneous star is accurate, and presents little degeneracy. The model correctly determines all parameters with little error and small uncertainty. $T_"eff"$ is determined to $< #qty(50, "K")$, and [Fe/H] and $log g$ are correctly found to $lt #sym.tilde 0.2$ dex.

However, the story is more complicated for multi-component stars. 2 component M dwarfs were shown to be significantly more difficult to analyse. When the simulated SNR and resolution was comparable to modern space-based instrumentation, the model could not accurately determine all the parameters. The most significant roadblock to being able to fit the inputted stellar parameters is resolution. At low resolution, the senstive small scale spectral lines are lost, and there is not enough information contained within the spectra to meaningfully differentiate different spectral components. However, our multi-component model works well at SNRs comparable to JWST and resolutions of $#qty(0.1, "nm")$ or below.

// == Physical Interpretation

// What does this mean for M dwarfs?

