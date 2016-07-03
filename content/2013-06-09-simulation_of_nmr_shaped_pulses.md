Title:	Simulation of NMR Shaped Pulses: NumPy vs Fortran
Date:	2013-06-09 15:35
Author: Michelle Gill
Slug:	simulation_of_nmr_shaped_pulses
Tags:	science, python
Latex:

Bandwidth-selective excitation in NMR is commonly accomplished through the use of shaped pulses. These pulses require careful calibration to ensure power levels and pulse lengths are correctly determined for optimal excitation of only the desired frequency range. Simulating the shaped pulse over a range of frequencies is one way of accomplishing this task. Many spectrometer control programs contain software capable of this (Bruker's TopSpin has ShapeTool and Aglient's VNMRJ has Pbox), but these simulations can also be performed quite easily in an IPython notebook.

---------

{% notebook NMRShapedPulseSimulation.ipynb cells[1:39] %}

None of my attempts at automatically vectorizing this function were successful.[^sympytheano] Since the matrix is only 3x3, it is not difficult to calculate each of the nine matrix elements. Their symbolic values can be determined by printing each element of the SymPy function. Note the use of SymPy's `simplify` function for algebraic simplification.

{% notebook NMRShapedPulseSimulation.ipynb cells[40:51] %}

As expected, this function is much faster than the original NumPy version. In this case, the speed increase over the improved NumPy version is rather modest.[^numbacython] The relative speed of the fortran function will likely grow as the number of points increases, but this is also a lesson about spending time optimizing a particular technique before moving onto something more powerful. (If major improvements can be made to either of the subroutines, then there is also a lesson about being familiar with the nuances of a language.)

{% notebook NMRShapedPulseSimulation.ipynb cells[52:] %}

[^sympytheano]: Ideally this function could be vectorized with something like SymPy's [lambdify](http://docs.sympy.org/dev/modules/utilities/lambdify.html), [autowrap](http://ojensen.wordpress.com/2010/08/10/fast-ufunc-ish-hydrogen-solutions/), or [ufuncify](http://docs.sympy.org/0.7.0/modules/utilities/autowrap.html#ufuncify) functions or with the [Theano](http://matthewrocklin.com/blog/work/2013/03/19/SymPy-Theano-part-1/) package. Unfortunately, `lambdify` isn't compatible with NumPy arrays. Likewise, `autowrap` isn't compatible with SymPy's `Matrix` function [yet](https://groups.google.com/forum/?fromgroups#!msg/sympy/Lo62rCmPTm8/G4GuHzp5wpQJ). I was unsuccessful in getting `unfuncify` to work with this case, and my MacBook Air doesn't have the graphics card necessary for GPU computing, so I didn't attempt to use Theano.

[^numbacython]: It would also be interesting to compare the speed of these functions to versions implemented in [Numba](http://numba.pydata.org) and [Cython](http://www.cython.org). My efforts at implementing this subroutine in Numba were not very successful and I'm not fond of C, so I decided to pass on Cython.

---------

*Edit:* The original version of this notebook contained two errors. The [first](https://gist.github.com/mlgill/5774126) involved the modification of NumPy ndarray views during matrix multiplication within the faster NumPy function. The [second](http://themodernscientist.com/posts/2013/2013-06-09-simulation_of_nmr_shaped_pulses/#comment-929405468) chose `vectorComponent` from the wrong axis at the conclusion of the faster NumPy function and in the Python wrapper that calls the Fortran function. This resulted in an inversion of the *y*-axis magnetization. Both errors have been corrected. Thanks to [Joshua Adelman](https://twitter.com/synapticarbors) for catching the second error. A minor change to the matrix simplification calculation due to an update of the SymPy package was also made, however this change had no effect on the result.

*Edit:* A Cython version of the propagator function provided by Joshua Adelman has been added above.

*This post was written in an IPython notebook, which can be downloaded [here](https://github.com/modernscientist/modernscientist.github.com/blob/master/notebooks/NMRShapedPulseSimulation.ipynb), or viewed statically [here](http://nbviewer.ipython.org/url/modernscientist.github.com/notebooks/NMRShapedPulseSimulation.ipynb).* 