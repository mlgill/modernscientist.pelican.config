Title: Weekend Hacks: My Own Deep Learning Box
Date: 2017-06-11 20:14
Author: Michelle Gill
Slug: weekend_hacks_my_very_deep_learning_box
Tags: deep learning, artificial intelligence, data science

Deep learning is becoming my favorite topic for personal projects. Its proliferation in the last few years has produced a vast array of applications and made it much more accessible. The one aspect of it I don't love is its impact on my AWS bill. GPU instances can get costly, even when using the less expensive spot instances.

So, I decided to take matters into my own hands (and apartment). On Wednesday, I ordered the parts, and this weekend, I built my own deep learning box. I've tinkered with hardware--both scientific and computational--since graduate school, so I was excited to get started Friday evening. It was every bit as satisfying as I remembered. Read on for a breakdown of parts and my setup.

## The Hardware

You can see my equipment list [here](https://pcpartpicker.com/user/mlgill/saved/2YhQ7P). The damage came to around $2,200 after some discounts were applied.

The GPU is the most important choice for a deep learning box. I opted for the NVIDIA GTX 1080 Ti video card due to its [excellent performance](http://timdettmers.com/2017/04/09/which-gpu-for-deep-learning/). This machine may also serve dual purpose as a gaming box in the future[^1], so I chose a decent CPU and a motherboard well-suited for overclocking. The deep learning box is topped off with 64 GB of RAM and two 500 GB SSDs. I'd like to purchase a larger spinning drive in the future.

[^1]: If my spouse has anything to say about it.

A picture of the final build is below. An album with more pictures is also available [here](https://www.icloud.com/sharedalbum/#B0dG4TcsmGK19ZW).

!["My Deep Learning Box"][image1]

[image1]: {static}/images/2017-06-11_weekend_hacks_my_own_deep_learning_box_1.jpeg "My Deep Learning Box"


## Operating System

Ubuntu is my Linux distribution of choice. I created a bootable USB drive using [UNetbootin](https://unetbootin.github.io) and the downloaded Ubuntu image. After I booted from the USB drive, the operating system installation completed in a few minutes.

## Deep Learning Software

Deep learning software is something I regularly install for my own projects. I also assist students with it in the bootcamp I co-instruct. For the deep learning box, I adapted a shell script that I use on AWS to serve dual purpose. The script is available [here](https://github.com/mlgill/deeplearn_setup_scripts).

The shell script is roughly divided into two parts: non-python and python setup. The first part handles development tools and the CUDA drivers. The second part creates a series of conda environments. The first environment contains general data science and machine learning packages, as well as Jupyter notebook. The second environment contains all of these packages plus several deep learning libraries (theano, tensorflow, and keras).

## Benchmarking

I wasn't able to do extensive benchmarking this weekend, but it is on my to-do list. A quick test using the [MNIST example in Keras](https://github.com/fchollet/keras/blob/master/examples/mnist_mlp.py) indicates my deep learning box is 2.0 - 2.5 times faster than the K80 GPU on AWS. I'm surprised the time difference is this large, but the MNIST example doesn't take long to train and thus the time differential may not hold for more substantial tasks.

I'm looking forward to all the projects I plan to tackle with this setup!


