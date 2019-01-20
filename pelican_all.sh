#!/usr/bin/env zsh

#setupconda 3 

./pre_pelican.sh

pelican -s publishconf.py

cp -R static/tipuesearch output/theme/.
cp -R static/bigfoot output/theme/.

./post_pelican.py
# ./git_push.sh
