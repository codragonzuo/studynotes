# Metron




# nfdump
```shell
yum install rrdtool-devel
tar -xf  v1.6.18.tar.gz
cd nfdump-1.6.18/
yum install libtool
cd nfdump-1.6.18/
./autogen.sh
yum install flex
yum  install python-devel
yum  install bzip2
yum install  bzip2-devel.x86_64
./configure --prefix=/opt/nfdump-1.6.18 
yum install byacc


wget https://github.com/redBorder/pygennf/raw/master/download/pygennf-0.1-1.noarch.rpm
rpm -vUh pygennf-0.1-1.noarch.rpm

wget https://github.com/redBorder/pygennf/raw/master/download/pygennf-0.1.tar.gz
```

https://github.com/redBorder/pygennf

https://github.com/bitkeks/python-netflow-v9-softflowd

https://github.com/phaag/nfdump

http://nfdump.sourceforge.net/

https://meetings.ripe.net/ripe-50/presentations/ripe50-plenary-tue-nfsen-nfdump.pdf
