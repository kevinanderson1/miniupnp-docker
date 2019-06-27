#!/bin/bash
set -e

read -r -a WAN <<< "${WAN_INT}"
echo "Setting the WAN Interface to: $WAN"
sed -i "s|^#ext_ifname=eth1$|ext_ifname=${WAN}|" /etc/miniupnpd/miniupnpd.conf

read -r -a LAN <<< "${LAN_INT}"
echo "Setting the LAN Interface to: $LAN"
sed -i "s|^#listening_ip=eth0$|listening_ip=${LAN}|" /etc/miniupnpd/miniupnpd.conf

read -r -a SECURE <<< "${SECURE_MODE}"
echo "Setting secure mode to: ${SECURE}"
if [[ ${SECURE} == "yes" ]]; then
  sed -i "s|^secure_mode=no|secure_mode=yes|g" /etc/miniupnpd/miniupnpd.conf
fi

read -r -a SUBNETS <<< "${ALLOW_SUBNETS}"
read -r -a PORT_RANGE <<< "${ALLOW_PORT_RANGE}"
echo "Allowing UPNP for the following subnets and ranges: ${SUBNETS} ${PORT_RANGE} "
sed -i -r 's/^allow.*//g' /etc/miniupnpd/miniupnpd.conf
sed -i -r 's/^deny.*//g' /etc/miniupnpd/miniupnpd.conf
for subnet in ${SUBNETS}; do
	echo "allow ${PORT_RANGE} ${subnet} ${PORT_RANGE}" >> /etc/miniupnpd/miniupnpd.conf
done
echo "deny 0-65535 0.0.0.0/0 0-65535" >> /etc/miniupnpd/miniupnpd.conf

exit 0
