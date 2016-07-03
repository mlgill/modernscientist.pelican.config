#!/usr/bin/env zsh -f


if [[ -e ./output/.git ]]; then
	find ./output -mindepth 1 | grep -v '\.git' | xargs -I{} rm -rf "{}"
else
	rm -rf ./output
	git clone https://github.com/modernscientist/modernscientist.github.com.git ./output
fi


