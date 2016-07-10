Title: pdNLS: Pandas-aware non-linear least squares minimization
Date: 2016-07-10 20:14
Author: Michelle Gill
Slug: pdNLS_pandas_aware_nonlinear_least_squares_minimization
Tags: science, python
Status: draft

I have a new Python project I would like to share with the community. Actually, this project isn't so new. I developed an initial version about two years before completing my postdoctoral research, and it has undergone various revisions over the past three years. Having finally made time to give it the clean-up it needed,[^nudge] I am excited to finally share it on [GitHub](https://github.com/mlgill/pdNLS).

[^nudge]: And with a helpful nudge in the form of the excellent [data science bootcamp](http://www.thisismetis.com) I'm currently attending.

## Overview

`pdNLS` is a library for performing non-linear least squares (NLS) minimization. It attempts to seamlessly incorporate this task in a Pandas-focused workflow. Input data are expected to be in dataframes, and multiple regressions can be performed using functionality similar to Pandas `groupby` functionality. Results are returned as grouped dataframes and include best-fit parameters, statistics, residuals, and more. The results can be easily visualized using [`seaborn`](https://github.com/mwaskom/seaborn).

`pdNLS` is related to libraries such as [`statsmodels`](http://statsmodels.sourceforge.net) and [`scikit-learn`](http://scikit-learn.org/stable/) that provide linear regression functions that operate on dataframes. However, I was unable to find any that perform non-linear regression. So, I developed `pdNLS` to fill this niche. 

The aggregation of minimization output parameters that is performed by `pdNLS` has many similarities to the [R library `broom`](https://github.com/dgrtwo/broom), which is written by [David Robinson](http://varianceexplained.org/) and with whom I had an excellent conversation about our two libraries. `broom` is more general in its ability to accept input from many minimizers, and I think expanding `pdNLS` in this fashion would be useful going forward.

<!-- PELICAN_END_SUMMARY -->

{% notebook pdNLS_demo.ipynb cells[3:13] %}

## Visualization

The results can be visualized in facet plots with Seaborn. To make it easier to view the data, all intensities have been normalized.  

*TODO: best-fit line will be added when `predict` method is fixed.*

{% notebook pdNLS_demo.ipynb cells[18:21] %}

## Conclusion

Easy right? Using `pdNLS` over the past few years has made my Python-based analytical workflows much smoother. Let me know how it works for you if you decide to try it!

If you are interested in trying `pdNLS`, you can do so without even installing it. There is a live demo available on GitHub. Click [here](http://mybinder.org/repo/mlgill/pdNLS) and navigate to `pdNLS --> demo --> pdNLS_demo.ipynb`.

The package can be installed in three different ways:

* [Using `conda`](https://anaconda.org/mlgill/pdnls) with `conda install -c mlgill pdnls`
* [Using `pip`](https://pypi.python.org/pypi/pdNLS/0.2.3) with `pip install pdNLS`
* Manually from the [GitHub repo](https://github.com/mlgill/pdNLS)




