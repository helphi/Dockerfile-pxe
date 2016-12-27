# Dockerfile-pxe

```bash
mkdir /pxe /pxe/dhcp /pxe/tftp /pxe/nginx 

cat << EOF > /pxe/dhcp/dhcpd.conf
allow booting;
allow bootp;
subnet 192.168.1.0 netmask 255.255.255.0 {
         default-lease-time 600;
         max-lease-time 7200;
         range 192.168.1.50 192.168.1.70;
         option routers 192.168.1.1;
         filename "pxelinux.0";
}
EOF


mount *.iso /mnt
cp -arf /mnt/. /pxe/nginx
cd /pxe/tftp
tar xzf netboot.tar.gz

docker run -d --net host -v /pxe:/pxe helphi/pxe 
```
