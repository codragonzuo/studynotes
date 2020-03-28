## Hypervisor

Hypervisor——一种运行在基础物理服务器和操作系统之间的中间软件层，可允许多个操作系统和应用共享硬件。也可叫做VMM（ virtual machine monitor ），即虚拟机监视器。

Hypervisors是一种在虚拟环境中的“元”操作系统。他们可以访问服务器上包括磁盘和内存在内的所有物理设备。Hypervisors不但协调着这些硬件资源的访问，也同时在各个虚拟机之间施加防护。当服务器启动并执行Hypervisor时，它会加载所有虚拟机客户端的操作系统同时会分配给每一台虚拟机适量的内存，CPU，网络和磁盘。


虚拟机是一个真实存在的计算机系统的硬软件副本，其中部分虚拟处理器指令子集以本地(native)方式执行在宿主(host)处理机上，其他部分指令以仿真方式执行。

- native 本地
- host 宿主机

In computing, a hypervisor, also called virtual machine monitor (VMM), is a piece of software/hardware platform-virtualization software that allows multiple operating systems to run on a host computer concurrently.

A hypervisor, also known as a virtual machine monitor, is a process that creates and runs virtual machines (VMs). A hypervisor allows one host computer to support multiple guest VMs by virtually sharing its resources, like memory and processing. 



Generally, there are two types of hypervisors. 

Type 1 hypervisors, called “bare metal,” run directly on the host’s hardware. 

Type 2 hypervisors, called “hosted,” run as a software layer on an operating system, like other computer programs.


市场上各种x86 管理程序(hypervisor)的架构存在差异，三个最主要的架构类别包括：
- I型：虚拟机直接运行在系统硬件上，创建硬件全仿真实例，被称为“裸机”型。裸机型在虚拟化中Hypervisor直接管理调用硬件资源，不需要底层操作系统，也可以将Hypervisor看作一个很薄的操作系统。这种方案的性能处于主机虚拟化与操作系统虚拟化之间。
- II型：虚拟机运行在传统操作系统上，同样创建的是硬件全仿真实例，被称为“托管（宿主）”型。托管型/主机型Hypervisor运行在基础操作系统上，构建出一整套虚拟硬件平台（CPU/Memory/Storage/Adapter），使用者根据需要安装新的操作系统和应用软件，底层和上层的操作系统可以完全无关化，如Windows运行Linux操作系统。主机虚拟化中VM的应用程序调用硬件资源时需要经过：VM内核->Hypervisor->主机内核，因此相对来说，性能是三种虚拟化技术中最差的。
- Ⅲ型：虚拟机运行在传统操作系统上，创建一个独立的虚拟化实例（容器），指向底层托管操作系统，被称为“操作系统虚拟化”。

![](https://bkimg.cdn.bcebos.com/pic/c9fcc3cec3fdfc03751f33ced43f8794a4c22665)

图 1 三种主要的虚拟化架构类型


厂商
市场主要厂商及产品：
- VMware vSphere、
- 微软Hyper-V、
- 美国思杰公司Citrix的 XenServer 、
- IBM PowerVM
- Red Hat Enterprise Virtulization
- Huawei FusionSphere
- 开源的KVM
- 开源Xen  /zεn/
- 开源VirtualBSD

## Xen

Xen 4.11 候选版已发布，Xen 是由剑桥大学开发的 x86 开源虚拟机监控器(VMM)，支持在单个机器上高性能的虚拟化多个操作系统，是 Linux、UNIX 和 POSIX 操作系统上最强大的虚拟机解决方案之一。Xen 支持 EFI ，在 64 位硬件平台上支持多达 4095 个主机 CPU ，支持使用 xz 压缩方式压缩 dom0 内核，支持 per-device 中断重映射（interrupt remapping），以及多区段 PCI 。

Xen 项目组推出Xen 4.11作为第一批候选发行版，项目组表示 Xen 4.11 致力于支持每个 CPU tasklet，Xen 中的内存带宽分配，guest 虚拟机资源映射，支持 HVM guest 虚拟机的 NVDIMM，SMMUv3 驱动程序以及 GRUB2 的 PVH guest 虚拟机引导支持以及其他更改。 

https://wiki.xen.org/wiki/Xen_Project_Software_Overview

2012年目前国内的企业大都是采用Xen技术运营，特别是几乎所有的云主机服务商，包括阿里云，盛大云，万网云等。

Hyper-V 是基于 XEN 管理栈的修改.

![](https://forum.huawei.com/enterprise/zh/data/attachment/forum/dm/ecommunity/uploads/2015/0709/11/559de70a87249.gif)

![](https://forum.huawei.com/enterprise/zh/data/attachment/forum/dm/ecommunity/uploads/2015/0709/11/559de716e5140.gif)

![](https://forum.huawei.com/enterprise/zh/data/attachment/forum/dm/ecommunity/uploads/2015/0709/11/559de722c7c40.gif)


Xen V.S. KVM终于画上了一个完美的句号

https://zhuanlan.zhihu.com/p/33324585


Xen Project，曾经作为唯一的开源虚拟化项目，一直活跃了10几年，但是随着可能是最大的Xen使用者AWS正式宣布下一代C5实例将使用KVM, 这基本也算是正式宣布了Xen的正式落幕，其实，国内的阿里云，华为云，作为比较早的云服务提供商，也都大量的使用了Xen, 大概在3，4年前，大家就纷纷开始动手将Xen替换成KVM, 目前在国内，它们新的云服务器都已经是KVM虚拟化了，AWS的历史包袱更大，要彻底完成Xen向KVM的替换，估计还需要很长一段时间。

## Vmware ESXI 

![](https://forum.huawei.com/enterprise/zh/data/attachment/forum/dm/ecommunity/uploads/2015/0709/11/559de75f412ca.jpg)

管理工具也是直接嵌入到了 ESXi vmKernel 中，没有再分化出单独的管理工具，这一点与 Xen 是相区别的。

## KVM

![](https://pic3.zhimg.com/v2-7748256d1a6ecb430619a9c1a3958f3f_1200x500.jpg)



KVM 是一个独特的管理程序，通过将 KVM 作为一个内核模块实现，在虚拟环境下 Linux 内核集成管理程序将其作为一个可加载的模块可以简化管理和提升性能。在这种模式下，每个虚拟机都是一个常规的 Linux 进程，通过 Linux 调度程序进行调度。


## FusionSphere 

https://actfornet.com/huawei-cloud/fusionsphere.html

![](https://actfornet.com/huawei-cloud/img9.jpg)

![](https://actfornet.com/huawei-cloud/imgC1.jpg)

![](https://actfornet.com/huawei-cloud/imgE1.jpg)

![](https://actfornet.com/huawei-cloud/img11.jpg)



  
