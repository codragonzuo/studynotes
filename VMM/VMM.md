## Hypervisor

Hypervisor——一种运行在基础物理服务器和操作系统之间的中间软件层，可允许多个操作系统和应用共享硬件。也可叫做VMM（ virtual machine monitor ），即虚拟机监视器。

Hypervisors是一种在虚拟环境中的“元”操作系统。他们可以访问服务器上包括磁盘和内存在内的所有物理设备。Hypervisors不但协调着这些硬件资源的访问，也同时在各个虚拟机之间施加防护。当服务器启动并执行Hypervisor时，它会加载所有虚拟机客户端的操作系统同时会分配给每一台虚拟机适量的内存，CPU，网络和磁盘。

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
