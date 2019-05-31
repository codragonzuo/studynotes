
# Volumes

On-disk files in a Container are ephemeral, which presents some problems for non-trivial applications when running in Containers. First, when a Container crashes, kubelet will restart it, but the files will be lost - the Container starts with a clean state. Second, when running Containers together in a Pod it is often necessary to share files between those Containers. The Kubernetes Volume abstraction solves both of these problems.


## Kubernetes存储系统介绍及机制实现

https://www.kubernetes.org.cn/3462.html


## The brief of PV and PVC

https://zhuanlan.zhihu.com/p/45503920

![](https://pic4.zhimg.com/v2-487b1bb79f3888c9febaf155767224dd_1200x500.gif)



# kubernetes example

http://kubernetesbyexample.com/rcs/


## Replication Controllers
Kubernetes replication controllers by example

A replication controller (RC) is a supervisor for long-running pods. An RC will launch a specified number of pods called replicas and makes sure that they keep running, for example when a node fails or something inside of a pod, that is, in one of its containers goes wrong.


Rolling Update

为了在更新服务的同时不中断业务， kubectl 支持‘滚动更新’，它一次更新一个pod，而不是同时停止整个服务。


请注意， kubectl rolling-update 仅支持Replication Controllers。 但是，如果使用Replication Controllers部署应用，请考虑将其切换到Deployments. Deployment是一种被推荐使用的更高级别的控制器，它可以对应用进行声明性的自动滚动更新。

