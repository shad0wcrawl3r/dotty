#!/usr/bin/env bash
#

# Configure EWW if eww is preinstalled
if [[ $(which eww) ]]; then
	if [[ -d ~/.config/eww/ ]]; then
		mv -v ~/.config/eww{,.bak}
	fi
	ln -sv $(pwd)/eww ~/.config/eww
	eww open mainBar
fi
