Title: Binary Integer Programming With Python
Date: 2013-05-29 20:14
Author: Michelle Gill
Slug: binary_integer_programming_with_python
Tags: science, python

My research is focused on [biomolecular NMR](http://modernscientist.com/pages/about.html) and, as such, often involves transferring resonance assignments from one multidimensional NMR spectrum to another. In theory this should be a simple task, but it can be extremely time consuming due to small variations in the sample used to acquire the data or in the way the data were acquired.

The good news, however, is that it is possible to automate this process using an optimization. Optimization problems, such as aligning x-ray crystallographic models of homologous proteins, are often encountered in structural biology. In the case of a structural alignment, the transformed structure can occupy any set of coordinates, provided the shape of the molecule itself is not changed. The transfer of resonance assignments is different in that individual resonances are either matched with each other or not. The transformation from one set of data onto another is effectively discrete (more specifically, it is binary). This type of optimization is known as “binary integer programming.” 


When I attempted to write a script to perform this type of optimization using python, I found some excellent background [reading](http://www.sce.carleton.ca/faculty/chinneck/po/Chapter13.pdf) but very little information on how to implement such a calculation. Being someone who learns by example, I thought it would be useful to share how I setup a simple binary integer programming calculation using two different python libraries[^openopt] that interact with open source solvers written in ANSI C.[^slow_os]

---------

[^slow_os]: The two solvers, GLPK and lp_solve, are somewhat old and, it would seem, neither particularly fast or robust compared to more modern [implementations](http://www.statistik.tuwien.ac.at/forschung/CS/CS-2012-1complete.pdf), but they are well-tested and more than sufficient for my purposes.

[^openopt]: I have used a third python library, [OpenOpt](http://openopt.org/Welcome), which also interfaces with GLPK. It is not demonstrated here as the syntax is similar that utilized by CVXOPT.




{% notebook BinaryIntegerProgramming.ipynb cells[1:] %}

---------

*This post was written in an IPython notebook, which can be downloaded [here](https://github.com/modernscientist/modernscientist.github.com/blob/master/notebooks/BinaryIntegerProgramming.ipynb), or viewed statically [here](http://nbviewer.ipython.org/url/modernscientist.github.com/notebooks/BinaryIntegerProgramming.ipynb).* 

