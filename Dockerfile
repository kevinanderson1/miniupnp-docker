FROM registry.fedoraproject.org/fedora-minimal:30
ENV container oci
ENV WAN_INT enp3s0
ENV LAN_INT enp4s0

RUN microdnf install --nodocs -y miniupnpd iproute iptables which \
  && rm -vf /etc/init.d/miniupnpd \
  && microdnf clean all

ADD miniupnpd.service /etc/systemd/system/
ADD setconfigfile.service /etc/systemd/system/
ADD setconfigfile.sh /etc/miniupnpd/

RUN chmod 755 /etc/miniupnpd/setconfigfile.sh \
  && systemctl enable setconfigfile \
  && systemctl enable miniupnpd

CMD ["/sbin/init"]
