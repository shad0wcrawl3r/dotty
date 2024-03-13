#!/usr/bin/env bash

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

OS_ID=$(cat /etc/os-release | grep "^ID=" | cut -d= -f2)
OS_NAME=$(cat /etc/os-release | grep "^NAME=" | cut -d= -f2)

if [[ $OS_NAME == "NixOS" && $OS_ID == "nixos" ]]; then
	git submodule update --init nix-config
	if [[ $EUID != 0 ]]; then
		echo "Rewriting NixOS configuration requires root privilege. Cancel and rerun the script with sudo, else after a sleep period of 30s, the script will continue "
		sleep 30
	else
		backup /etc/nixos
		ln -sv $(pwd)/nix-config /etc/nixos/
	fi
fi
