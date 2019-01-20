Title: pdLSR: Pandas-aware least squares regression
Date: 2016-07-17 20:14
Author: Michelle Gill
Slug: pdLSR_pandas_aware_least_squares_regression
Tags: science, python

I have a new Python project I would like to share with the community. Actually, this project isn't so new. I developed an initial version about two years before completing my postdoctoral research, and it has undergone various revisions over the past three years. Having finally made time to give it the clean-up it needed,[^nudge] I am excited to share it on [GitHub](https://github.com/mlgill/pdLSR).

[^nudge]: And with a helpful nudge in the form of the excellent [data science bootcamp](http://www.thisismetis.com) I'm currently attending. Stay tuned for more about that!

## Overview

`pdLSR` is a library for performing least squares minimization. It attempts to seamlessly incorporate this task in a Pandas-focused workflow. Input data are expected in dataframes, and multiple regressions can be performed using functionality similar to Pandas `groupby`. Results are returned as grouped dataframes and include best-fit parameters, statistics, residuals, and more. The results can be easily visualized using [`seaborn`](https://github.com/mwaskom/seaborn).

`pdLSR` currently utilizes [`lmfit`](https://github.com/lmfit/lmfit-py), a flexible and powerful library for least squares minimization, which in turn, makes use of `scipy.optimize.leastsq`. I began using `lmfit` because it is one of the few libraries that supports non-linear least squares regression, which is commonly used in the natural sciences. I also like the flexibility it offers for testing different modeling scenarios and the variety of assessment statistics it provides. However, I found myself writing many `for` loops to perform regressions on groups of data and aggregate the resulting output. Simplification of this task was my inspiration for writing `pdLSR`.

`pdLSR` is related to libraries such as [`statsmodels`](http://statsmodels.sourceforge.net) and [`scikit-learn`](http://scikit-learn.org/stable/) that provide linear regression functions that operate on dataframes. However, these libraries don't directly support grouping operations on dataframes. 

The aggregation of minimization output parameters that is performed by `pdLSR` has many similarities to the [R library `broom`](https://github.com/dgrtwo/broom), which is written by [David Robinson](http://varianceexplained.org/) and with whom I had an excellent conversation about our two libraries. `broom` is more general in its ability to accept input from many minimizers, and I think expanding `pdLSR` in this fashion, for compatibility with `statsmodels` and `scikit-learn` for example, could be useful in the future.

<!-- PELICAN_END_SUMMARY -->

{% notebook pdLSR_demo.ipynb cells[4:17] %}

## Visualization

The results can be visualized in facet plots with Seaborn. To make it easier to view the data, all intensities have been normalized.  

{% notebook pdLSR_demo.ipynb cells[20:23] %}

## Conclusion

Easy right? Using `pdLSR` over the past few years has made my Python-based analytical workflows much smoother. Let me know how it works for you if you decide to try it!

If you are interested in trying `pdLSR`, you can do so without even installing it. There is a live demo available on GitHub. Click [here](http://mybinder.org/repo/mlgill/pdLSR) and navigate to `pdLSR --> demo --> pdLSR_demo.ipynb`.

The package can be installed in three different ways:

* [Using `conda`](https://anaconda.org/mlgill/pdlsr) with `conda install -c mlgill pdlsr`
* [Using `pip`](https://pypi.python.org/pypi/pdLSR) with `pip install pdLSR`
* Manually from the [GitHub repo](https://github.com/mlgill/pdLSR)

*This post was written in a Jupyter notebook, which can be downloaded and viewed statically [here](https://github.com/mlgill/modernscientist.github.com/blob/master/notebooks/pdLSR_demo.ipynb).*




