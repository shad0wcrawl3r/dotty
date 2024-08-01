#!/usr/bin/env bash

function backup {
	if [[ -L $1 ]]; then # if the file is a symlink, just unlink(delete) it.
		unlink $1
	elif [[ -e $1 ]]; then # if the file exists
		mv -v $1{,.$(date +%s).bak}
	fi
}
set -xe
OS_ID=$(cat /etc/os-release | grep "^ID=" | cut -d= -f2)
OS_NAME=$(cat /etc/os-release | grep "^NAME=" | cut -d= -f2)

# For NixOS based hosts
function deploy_nix_config() {
	echo "Running dmidecode to detect system information"
	dmidecode_out=$(nix-shell -p dmidecode --run "sudo dmidecode -s system-product-name")
	[[ $dmidecode_out =~ "FA507RM" ]] && device_hostname_should_be="wrath"
	[[ $dmidecode_out =~ "GA503QM" ]] && device_hostname_should_be="CrYbAbY58"
	if [[ $(grep $device_hostname_should_be /etc/nixos/flake.nix) ]]; then
		echo "Buidling with the $device_hostname_should_be profile"
		[[ $EUID == 0 ]] || echo "Building with Effective User ID (EUID) = $EUID. Might fail "
		nixos-rebuild switch
	else
		echo "Cannot find the expected hostname in flake.nix. Exiting..."
		exit 1
	fi
}

function first_nix_setup() {
	if [[ $EUID != 0 ]]; then
		echo "Effective User ID is not 0. Rerun the script as root"
		exit 1
	fi
	if [[! $(which sbctl) ]]; then
		echo "No sbctl found. Assuming Fist configuration. Sleeping for 10s to allow for forced exiting."
		sleep 10
		nix-shell -p sbctl --command sbctl create-keys
		deploy_nix_config
		nix-shell -p sbctl --command sbctl verify
		echo "It is expected some files are not signed. Crosscheck with the documentation if anything is not working."
		echo "https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md"
	fi
}

## For Hyprland ecosystem
function hypr() {
	config_root=~/.config/hypr/
	mkdir -p $config_root # Because Hyprland.conf will be created by home-manager in most cases
	ln -sv $(pwd)/hypr/hyprland.ext.conf $config_root
	ln -sv $(pwd)/hypr/hyprpaper.conf $config_root
	ln -sv $(pwd)/hypr/hyprlock.conf $config_root
}
# if [[ $OS_NAME == "NixOS" && $OS_ID == "nixos" ]]; then
# 	git submodule update --init nix-config
# 	if [[ $EUID != 0 ]]; then
# 		echo "Rewriting NixOS configuration requires root privilege. Cancel and rerun the script with sudo, else after a sleep period of 10s, the script will continue "
# 		sleep 10
# 	else
# 		backup /etc/nixos
# 		ln -sv $(pwd)/nix-config /etc/nixos
# 	fi
# 	nixos-rebuild switch
# 	exit 0
# fi
function main() {
	if [[ $(which hyprctl) ]]; then
		hypr
	fi

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

	# Configure Rofi if installed
	if [[ $(which rofi) ]]; then
		config_path=~/.config/rofi
		backup $config_path
		ln -sv $(pwd)/rofi $config_path
	fi

	#Configure neovim if installed
	if [[ $(which nvim) ]]; then
		config_path=~/.config/nvim
		git submodule update --init neovim
		backup $config_path
		rm -vrf ~/.local/share/nvim/
		rm -vrf ~/.local/state/nvim/
		rm -vrf ~/.cache/nvim{,.bak}
		ln -sv $(pwd)/neovim $config_path
	fi

}
#
main
#deploy_nix_config
