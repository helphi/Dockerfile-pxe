touch /var/lib/dhcp/dhcpd.leases
dhcpd -cf /pxe/dhcp/dhcpd.conf
in.tftpd -s -l -c /pxe/tftp
nginx -p "deamon off:"
