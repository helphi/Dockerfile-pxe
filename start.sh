touch /var/lib/dhcp/dhcpd.leases
dhcpd -cf /pxe/dhcp/dhcpd.conf
in.tftpd -s -l -c /pxe/tftp
nginx
/usr/sbin/exportfs -r
/sbin/rpcbind --
/usr/sbin/rpc.nfsd |:
/usr/sbin/rpc.mountd -F
