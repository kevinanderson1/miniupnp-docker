#!/bin/bash

read -r -a WAN <<< "${WAN_INT}"

echo "Setting the WAN Interface to: $WAN"

sed -i "s|^#ext_ifname=eth1$|ext_ifname=${WAN}|" /etc/miniupnpd/miniupnpd.conf

read -r -a LAN <<< "${LAN_INT}"

echo "Setting the LAN Interface to: $LAN"

sed -i "s|^#listening_ip=eth0$|listening_ip=${LAN}|" /etc/miniupnpd/miniupnpd.conf

exit 0
