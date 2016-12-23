dhcpd -cf /pxe/dhcp/dhcpd.conf
in.tftpd -s -l -c /pxe/tftp
nginx -g daemon off
