
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
	
		(system76-power graphics intel)
		(systemctl restart display-manager)
		(system76-power graphics power off)
	
	elif [ "$1" == "nvidia" ]; then
		echo "Switching to nvidia graphics..."
		(system76-power graphics nvidia)
		(system76-power graphics power on)
		(systemctl restart display-manager)
		(echo "options nvidia NVreg_DynamicPowerManagement=0x02" >> /lib/modprobe.d/nvidia-graphics-drivers.conf
)
	else
		echo "Invalid graphics input... "
	fi
fi


