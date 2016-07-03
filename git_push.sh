#!/usr/bin/env zsh -f

cd output
git add . -A
git commit -m "`date '+Site updated at %Y-%m-%d %H:%M:%S %z'`"
git push -u origin master


