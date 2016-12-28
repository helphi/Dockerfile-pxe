touch /var/lib/dhcp/dhcpd.leases
dhcpd -cf /pxe/dhcp/dhcpd.conf enp0s3
in.tftpd -s -l -c /pxe/tftp
nginx -p "deamon off;"
