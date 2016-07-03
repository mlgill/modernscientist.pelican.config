#!/usr/bin/env zsh

setupconda 2

./pre_pelican.sh

pelican -s publishconf.py

cp -r static/tipuesearch output/theme/.
cp -r static/bigfoot output/theme/.

./post_pelican.py
# ./git_push.sh
