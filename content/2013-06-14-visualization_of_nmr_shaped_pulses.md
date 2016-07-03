Title:	Visualization of NMR Shaped Pulses: Fun with Javascript Animation
Date:	2013-06-14 15:35
Author: Michelle Gill
Slug:	visualization_of_nmr_shaped_pulses
Tags:	science, python

This IPython notebook builds on the previous [blog post](http://themodernscientist.com/posts/2013/2013-06-09-simulation_of_nmr_shaped_pulses/) which described how to simulate and plot the result of a shaped pulse on magnetization in an NMR experiment. For the purpose of teaching[^fun], it can also be useful to visualize the effect of this pulse on the magnetization at each discrete time step of the pulse.

Visualizing the time-dependent course of magnetization requires the [javascript viewer](https://github.com/jakevdp/JSAnimation) developed by Jake Vanderplas described [here](http://jakevdp.github.io/blog/2013/05/19/a-javascript-viewer-for-matplotlib-animations/) and further demonstrated [here](http://jakevdp.github.io/blog/2013/05/28/a-simple-animation-the-magic-triangle/). This library has to be installed somewhere in the path searched by Python. NymPy and Matplotlib are also required.

---------

{% notebook NMRShapedPulseAnimation.ipynb cells[2:3] %}

The steps required to created the Reburp shaped pulse and calculate its propagator have been described in the aforementioned post and are available in the downloadable and static version of this notebook linked to below. Thus, I have jumped directly to the data visualization.

{% notebook NMRShapedPulseAnimation.ipynb cells[12:] %}

[^fun]: And providing an excuse for me to play with animations in IPython notebooks.

*This post was written in an IPython notebook, which can be downloaded [here](https://github.com/modernscientist/modernscientist.github.com/blob/master/notebooks/NMRShapedPulseAnimation.ipynb), or viewed statically [here](http://nbviewer.ipython.org/url/modernscientist.github.com/notebooks/NMRShapedPulseAnimation.ipynb).* 