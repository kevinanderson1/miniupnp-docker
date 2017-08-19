FROM fedora:26

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*; 

RUN dnf install -y selinux-policy-targeted gcc make git which procps-ng pkgconf-pkg-config iptables-devel openssl-devel iproute iptables \
  && git clone https://github.com/miniupnp/miniupnp.git \
  && cd miniupnp/miniupnpd && make -f Makefile.linux install \
  && rm -vf /etc/init.d/miniupnpd \
  && rm -rvf /miniupnp \
  && dnf clean all 

ADD miniupnpd.service /etc/systemd/system/
ADD setconfigfile.service /etc/systemd/system/
ADD setconfigfile.sh /etc/miniupnpd/

RUN chmod 755 /etc/miniupnpd/setconfigfile.sh \
  && systemctl enable setconfigfile \
  && systemctl enable miniupnpd

CMD ["/sbin/init"]
