#!/bin/bash
# for Fedora
# Graphics switcher without reboot

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


if [ -z $1 ]; then
	echo "Provide gpu to switch to..."
	exit 1
else
	if [ "$1" == "intel" ]; then 
		echo "Switching to intel graphics... "
		
		grubby --update-kernel=ALL --remove-args="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"
		grubby --update-kernel=ALL --args="rd.driver.blacklist=nvidia,nvidia_uvm,nvidia_drm,nvidia_modeset modprobe.blacklist=nvidia,nvidia_uvm,nvidia_drm,nvidia_modeset nouveau.modeset=0"

		rm -f /etc/X11/xorg.conf.d/nvidia.conf
	
	elif [ "$1" == "nvidia" ]; then
		echo "Switching to nvidia graphics..."
		grubby --update-kernel=ALL --args="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"
		grubby --update-kernel=ALL --remove-args="rd.driver.blacklist=nvidia,nvidia_uvm,nvidia_drm,nvidia_modeset modprobe.blacklist=nvidia,nvidia_uvm,nvidia_drm,nvidia_modeset nouveau.modeset=0"

		cp -p nvidia.conf /etc/X11/xorg.conf.d/nvidia.conf
	
	elif [ "$1" == "hybrid" ]; then
		echo "Switching to hybrid graphics..."
		grubby --update-kernel=ALL --args="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"
		grubby --update-kernel=ALL --remove-args="rd.driver.blacklist=nvidia,nvidia_uvm,nvidia_drm,nvidia_modeset modprobe.blacklist=nvidia,nvidia_uvm,nvidia_drm,nvidia_modeset nouveau.modeset=0"

		rm -f /etc/X11/xorg.conf.d/nvidia.conf		
		
	else
		echo "Invalid graphics input... "
		exit
	fi
fi

echo "Graphics switched, please reboot!"



