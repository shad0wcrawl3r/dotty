#!/usr/bin/env bash
#
set -e
# Configure EWW if eww is preinstalled
if [[ $(which eww) ]]; then
	if [[ -d ~/.config/eww/ ]]; then
		mv -v ~/.config/eww{,.bak}
	fi
	ln -sv $(pwd)/eww ~/.config/eww
	eww open mainBar
fi

# COnfigure alacritty if installed
if [[ $(which alacritty) ]]; then
	git submodule update --init alacritty/catppuccin
	if [[ -d ~/.config/alacritty ]]; then
		mv -v ~/.config/alacritty{,.bak}
	fi
	ln -sv $(pwd)/alacritty ~/.config/alacritty
fi
