# Dockerfile-pxe

# ubuntu server
```bash
mkdir /pxe /pxe/dhcp /pxe/tftp 
wget http://mirror.bjtu.edu.cn/ubuntu-releases/16.04/ubuntu-16.04-server-amd64.iso
mount ubuntu-16.04-server-amd64.iso /mnt
cp -arf /mnt/. /pxe/tftp
ln -s /pxe/tftp /pxe/nginx
cd /pxe/tftp/preseed
wget https://raw.githubusercontent.com/helphi/Dockerfile-pxe/master/preseed/auto.seed

cat << EOF >> /pxe/tftp/install/netboot/pxelinux.cfg/default
label autoinstall
        menu label ^Auto install
        kernel ubuntu-installer/amd64/linux
        append vga=788 initrd=ubuntu-installer/amd64/initrd.gz auto=true preseed/url=tftp://192.168.1.110/preseed/auto.seed priority=critical ---
EOF

cat << EOF > /pxe/dhcp/dhcpd.conf
allow booting;
allow bootp;
subnet 192.168.1.0 netmask 255.255.255.0 {
         default-lease-time 600;
         max-lease-time 7200;
         range 192.168.1.50 192.168.1.70;
         option routers 192.168.1.1;
         option domain-name-servers 192.168.1.1;
         filename "install/netboot/pxelinux.0";
}
EOF

docker run -d --net host -v /pxe:/pxe helphi/pxe 
```

# ubuntu desktop
```bash
mkdir -p /pxe2/tftp/install/netboot
cd /pxe2/tftp/install/netboot
wget http://cc.archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/netboot.tar.gz
tar xzf netboot.tar.gz

mkdir -p /pxe2/tftp/preseed
cd /pxe2/tftp/preseed
wget https://raw.githubusercontent.com/helphi/Dockerfile-pxe/master/preseed/auto.seed
sed -i "s/192.168.1.110/cc.archive.ubuntu.com/g" auto.seed

cat << EOF >> /pxe2/tftp/install/netboot/pxelinux.cfg/default
label autoinstall
        menu label ^Auto install
        kernel ubuntu-installer/amd64/linux
        append vga=788 initrd=ubuntu-installer/amd64/initrd.gz auto=true preseed/url=tftp://192.168.1.110/preseed/auto.seed priority=critical ---
EOF

mkdir -p /pxe2/dhcp
cat << EOF > /pxe2/dhcp/dhcpd.conf
allow booting;
allow bootp;
subnet 192.168.1.0 netmask 255.255.255.0 {
         default-lease-time 600;
         max-lease-time 7200;
         range 192.168.1.50 192.168.1.70;
         option routers 192.168.1.1;
         option domain-name-servers 192.168.1.1;
         filename "install/netboot/pxelinux.0";
}
EOF

docker run -d --net host -v /pxe2:/pxe helphi/pxe
```
