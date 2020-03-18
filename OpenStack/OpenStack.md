

 - 云计算编排平台  Cloudstack  Openstack
 - KVM/VmWare虚拟化  
 - Kubernetes
 - 分布式存储
 - 关系数据库在云上的实现
 
 


OpenStack构架知识梳理
https://www.cnblogs.com/kevingrace/p/5733508.html


完整部署CentOS7.2+OpenStack+kvm 云平台环境（1）--基础环境搭建
https://www.cnblogs.com/kevingrace/p/5707003.html

# OpenStack 架构图
![](https://images2015.cnblogs.com/blog/907596/201608/907596-20160803154744809-483681990.png)


![](https://www.openstack.org/software/images/diagram/overview-diagram-new.svg)


## Openstack Landscpace 
![](https://www.openstack.org/software/images/map/openstack-map-v20180601.svg)


## OpenStack component

https://www.openstack.org/software/project-navigator/openstack-components/#openstack-services


## OpenStack云平台的网络模式及其工作机制

https://blog.csdn.net/hilyoo/article/details/7721401

https://www.cnblogs.com/horizonli/p/5172100.html



OpenStack中network的2种ip、3种管理模式

Nova有固定IP和浮动IP的概念。  
固定IP被分发到创建的实例不再改变，浮动IP是一些可以和实例动态绑定和释放的IP地址。  

Nova支持3种类型的网络，对应3种“网络管理”类型：Flat管理模式、FlatDHCP管理模式、VLAN管理模式。默认使用VLAN摸式。

这3种类型的网络管理模式，可以在一个ОpenStack部署里面共存，可以在不同节点不一样，可以进行多种配置实现高可用性。

简要介绍这3种管理模式，后面再详细分析。

Flat（扁平）： 所有实例桥接到同一个虚拟网络，需要手动设置网桥。 

FlatDHCP： 与Flat（扁平）管理模式类似，这种网络所有实例桥接到同一个虚拟网络，扁平拓扑。不同的是，正如名字的区别，实例的ip提供dhcp获取（nova-network节点提供dhcp服务），而且可以自动帮助建立网桥。

VLAN： 为每个项目提供受保护的网段（虚拟LAN）。

## openstack学习-网络管理

https://blog.51cto.com/11555417/2438097
