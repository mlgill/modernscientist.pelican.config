#!/usr/bin/env zsh -f

# Push blog to github
cd output
git add . -A
git commit -m "`date '+Site updated at %Y-%m-%d %H:%M:%S %z'`"
git push -u origin master
cd ..

# Push theme files to github
cd themes/octopress-theme_MLG
git add . -A
git commit -m "`date '+Site updated at %Y-%m-%d %H:%M:%S %z'`"
git push -u origin master
cd ../..

# Push config files to github
git add . -A
git commit -m "`date '+Site updated at %Y-%m-%d %H:%M:%S %z'`"
git push -u origin master

