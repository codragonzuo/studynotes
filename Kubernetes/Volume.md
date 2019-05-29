
# Volumes

On-disk files in a Container are ephemeral, which presents some problems for non-trivial applications when running in Containers. First, when a Container crashes, kubelet will restart it, but the files will be lost - the Container starts with a clean state. Second, when running Containers together in a Pod it is often necessary to share files between those Containers. The Kubernetes Volume abstraction solves both of these problems.


## Kubernetes存储系统介绍及机制实现

https://www.kubernetes.org.cn/3462.html


## The brief of PV and PVC

https://zhuanlan.zhihu.com/p/45503920

![](https://pic4.zhimg.com/v2-487b1bb79f3888c9febaf155767224dd_1200x500.gif)




