#!/usr/bin/env zsh -f

conda activate scienv3

./pre_pelican.sh

pelican -s publishconf.py

cp -R static/tipuesearch output/theme/.
cp -R static/bigfoot output/theme/.

/Volumes/Files/miniconda/envs/scienv3/bin/python post_pelican.py
# ./git_push.sh
