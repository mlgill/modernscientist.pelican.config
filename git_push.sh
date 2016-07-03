#!/usr/bin/env zsh -f

date_str=`date '+Site updated at %Y-%m-%d %H:%M:%S %z'`

# Push blog to github
cd output
git add . -A
git commit -m "$date_str"
git push -u origin master
cd ..

# Push theme files to github
cd themes/octopress-theme_MLG
git add . -A
git commit -m "$date_str"
git push -u origin master
cd ../..

# Push config files to github
git add . -A
git commit -m "$date_str"
git push -u origin master

