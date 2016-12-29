# Dockerfile-pxe
--------------------

- 以下脚本在`Ubuntu 16.04.1 LTS` + `docker 1.12.4`上经过测试
- 以下安装示例为 ubuntu 16.04 的安装示例，如果需要使用本 docker 镜像服务于其他 linux 版本的安装可能需要定制脚本
- 使用以下脚本时将`192.168.1.110` 替换为自己的 ip 
- `ubuntu server` 的安装方式：将 iso 文件放到 web 服务器（nginx）和 tftp 服务上，然后通过 pxe 从网络启动并配置安装过程从该 web 服务器上获取这些文件进行安装
- `ubuntu desktop` 的安装方式：由于 ubuntu desktop 的 iso 文件默认没有包含网络安装的启动文件，所以示例中并没有使用 iso，而是单独从 ubuntu mirror 下载网络安装启动文件然后配置安装过程从该 ubuntu mirror 安装（示例中使用的是官方 mirror，如果在你的局域网有 mirror 也可以从该 mirror 下载网络安装启动文件并配置安装过程中使用该 mirror） 

## Install ubuntu server
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

## Install ubuntu desktop
```bash
mkdir -p /pxe2/tftp/install/netboot
cd /pxe2/tftp/install/netboot
wget http://cc.archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/netboot.tar.gz
tar xzf netboot.tar.gz

mkdir -p /pxe2/tftp/preseed
cd /pxe2/tftp/preseed
wget https://raw.githubusercontent.com/helphi/Dockerfile-pxe/master/preseed/auto.seed

# 使用官方 mirror
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
