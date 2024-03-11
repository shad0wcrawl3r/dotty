#!/usr/bin/env bash
#
#
function backup {
	if [[ -L $1 ]]; then # if the file is a symlink, just unlink(delete) it.
		unlink $1
	elif [[ -e $1 ]]; then # if the file exists
		mv -v $1{,.$(date +%s).bak}
	fi
}
set -e
# Configure EWW if eww is preinstalled
if [[ $(which eww) ]]; then
	config_path=~/.config/eww
	backup $config_path
	ln -sv $(pwd)/eww $config_path
	eww open mainBar
fi

# COnfigure alacritty if installed
if [[ $(which alacritty) ]]; then
	config_path=~/.config/alacritty
	git submodule update --init alacritty/catppuccin
	backup $config_path
	ln -sv $(pwd)/alacritty $config_path
fi

if [[ $(which nvim) ]]; then
	config_path=~/.config/nvim
	git submodule update --init neovim
	backup $config_path
	rm -vrf ~/.local/share/nvim/
	rm -vrf ~/.local/state/nvim/
	rm -vrf ~/.cache/nvim{,.bak}
	ln -sv $(pwd)/neovim $config_path

fi
