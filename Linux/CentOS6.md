
### 修改网卡配置文件
```
cd  '/etc/sysconfig/network-scripts'
vi ifcfg-eth0
ONBOOT=yes
BOOTPROTO=dhcp
reboot
```

yum安装wget提示Centos7_Base库缺少GPG公钥
```
添加Centos7_Base库的GPG公钥
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

### 安装wget
yum install wget

### 安装gcc
yun install gcc
yun install gcc-c++

```
http://mirrors.aliyun.com/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.gz
./contrib/download_prerequisites
./configure --enable-checking=release --enable-languages=c,c++ --disable-multilib
make 
make install
reboot
```
