
## yum安装本地rpm软件方案详解

概述

面对无法联网的centos系统，安装rpm软件包是一个比较耗时的工作，尤其是那些包含很多依赖的软件包，如果用rpm命令安装，可以说是一个噩梦。这里根据个人实践发布一个比较完整方便的解决方案。（注：本方案在centos6.564bit测试可用）

具体方案

基本环境介绍

目标操作系统：centos6.564bit，下称“目标机”（无法联网用yum安装）

本地环境：在VMware下安装的纯净centos6.564bit，下称“虚拟机”（可以联网用yum下载安装包）

本方案基本思路是在一个可以联网的系统中下载rpm安装包，然后传到无法联网的目标操作系统，建立安装源，进行安装。为了减少不必要的麻烦，在本地用虚拟机安装一个和目标操作系统一模一样的但是没有安装任何额外软件的系统，用于下载各种安装包和依赖包。

配置本地环境

在虚拟机内配置yum只下载RPM包而不安装，这里要使用–downloadonly选项，需要先安装yum-plugin-downloadonly。


### yum install yum-plugin-downloadonly

在本地环境下载rpm安装包

### yum install --downloadonly --downloaddir=/tmp RPM_Name

/tmp为指定下载的目录，RPM_Name为目标软件。

yum–downloadonly会只下载RPM包不安装，同时会把依赖的包都下载下来，注意如虚拟机已经安装了依赖包，则不会下载，因此务必确保虚拟机的纯净（如果有方案可以下载已经有的依赖包，欢迎告知）。

需要说明的是，为了在目标机构建软件源，createrepo是必不可少的模块，因此需要在虚拟机上下载createrepo相关模块。

### yum install --downloadonly --downloaddir=/tmp createrepo

一般会下载三个包，一个是createrepo，另外两个是依赖包。

上传rpm安装包到目标机

采用scp或者pscp.exe（Windows下）等方式将rpm安装包文件上传到目标机，并修改权限为可执行（chmod755RPM_Name）。

在目标机构建本地软件源

安装createrepo

在目标机安装createrepo：

### rpm -ivh deltarpm-3.5-0.5.20090913git.el6.x86_64.rpm

### rpm -ivh python-deltarpm-3.5-0.5.20090913git.el6.x86_64.rpm

### rpm -ivh createrepo-0.9.9-24.el6.noarch.rpm

createrepo构建本地软件源

假设安装包在目标机的/home/user/rpms/目录下。

### createrepo /home/user/rpms

修改yum软件源

移除现有的软件源

### mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo_bk

开启本地软件源

### vim /etc/yum.repos.d/CentOS-Media.repo

在baseurl增加一行：

=file:////home/user/rpms/

然后修改： enabled=1

这样就可以使yum采用本地源安装软件。

在目标机安装目标软件

使用yum正常安装软件即可。

### yum install demo

如果用的是纯净的虚拟机环境，并且和目标机保持一致，那么依赖包就会都安装，yum安装就会很顺利。除非个别包会有依赖冲突，A依赖B，B又依赖A，导致无法安装，此时可以用rpm命令强制安装其中一个，再用yum安装软件即可。

### rpm -ivh demo.rpm --nodeps --force




## yum install 下载后保存rpm包

keepcache=0 更改为1下载RPM包 不会自动删除

vi /etc/yum.conf 

```
[main]
cachedir=/var/cache/yum/$basearch/$releasever # 安装包默认下载地址
keepcache=1 # 不会自动删除
```
```
[root@bogon ~]# sed -n 's#keepcache=0#keepcache=1#gp' /etc/yum.conf 
keepcache=1 【最好先不要用-i参数直接修改源文件，先输出看修改是否正确，或者先备份yum.conf配置文件】
[root@bogon ~]# sed -i 's#keepcache=0#keepcache=1#g' /etc/yum.conf  【-i修改源文件配置】
[root@bogon ~]# grep "keepcache" /etc/yum.conf【检查是否已修改】
keepcache=1
```
