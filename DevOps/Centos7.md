centos7安装ssh服务

1、查看是否安装了相关软件：

rpm -qa|grep -E "openssh"
 

显示结果含有以下三个软件，则表示已经安装，否则需要安装缺失的软件
```
openssh-ldap-6.6.1p1-35.el7_3.x86_64 
openssh-clients-6.6.1p1-35.el7_3.x86_64 
openssh-6.6.1p1-35.el7_3.x86_64 
openssh-askpass-6.6.1p1-35.el7_3.x86_64 
openssh-server-6.6.1p1-35.el7_3.x86_64 
openssh-keycat-6.6.1p1-35.el7_3.x86_64 
openssh-server-sysvinit-6.6.1p1-35.el7_3.x86_64
```
2、安装缺失的软件：
```
sudo yum install openssh*
```

3、注册使用服务：
```
sudo systemctl enable sshd  
sudo systemctl start sshd 或者
service sshd start 
```

4、开启防火墙的22端口： 

具体防火墙使用可以参见：http://www.cnblogs.com/moxiaoan/p/5683743.html
```
sudo firewall-cmd --zone=public --add-port=22/tcp --permanent  
sudo service firewalld restart  
```

5、备注：虚拟机如果和主机进行测试，需要将网络模式修改为2. Bridged Adapter，具体参见：http://blog.csdn.net/ixidof/article/details/12685549

 
