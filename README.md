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

wget http://mirror.bjtu.edu.cn/ubuntu-releases/16.04/ubuntu-16.04-desktop-amd64.iso
mount ubuntu-16.04-desktop-amd64.iso /mnt
cp -arf /mnt/. /pxe/nginx

cd /pxe/tftp
wget http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/current/images/netboot/netboot.tar.gz
tar xzf netboot.tar.gz

docker run -d --net host -v /pxe:/pxe helphi/pxe 
```
