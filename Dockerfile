FROM registry.fedoraproject.org/fedora-minimal:30
ENV container oci
ENV WAN_INT enp3s0
ENV LAN_INT enp4s0
ENV SECURE_MODE yes
ENV ALLOW_SUBNETS 192.168.100.0/24
ENV ALLOW_PORT_RANGE 1024-65536

RUN microdnf install --nodocs -y miniupnpd iproute iptables which \
  && rm -vf /etc/init.d/miniupnpd \
  && microdnf clean all

ADD miniupnpd.service /etc/systemd/system/
ADD setconfigfile.service /etc/systemd/system/
ADD setconfigfile.sh /etc/miniupnpd/

RUN chmod 755 /etc/miniupnpd/setconfigfile.sh \
  && systemctl disable systemd-resolved \
  && systemctl disable systemd-networkd \
  && systemctl enable setconfigfile \
  && systemctl enable miniupnpd

CMD ["/sbin/init"]
