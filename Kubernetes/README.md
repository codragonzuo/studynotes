
# Kubernetes

kubernetes，简称K8s，是用8代替8个字符“ubernete”而成的缩写。是一个开源的，用于管理云平台中多个主机上的容器化的应用，Kubernetes的目标是让部署容器化的应用简单并且高效（powerful）,Kubernetes提供了应用部署，规划，更新，维护的一种机制。

### 

Kubernetes提供了一套简单的用于发送请求的API，对底层基础设施进行抽象。Kubernetes会尽其最大能力来满足这些请求。比如说，可以简单地请求“Kubernetes启动4个x镜像的容器”，然后Kubernetes会找出利用率不足的节点，在这些节点中启动新的容器。

![](http://dockone.io/uploads/article/20180424/0fb45b05694fb2ec35c3c44c984ab043.png)

### Pod

![](http://dockone.io/uploads/article/20180424/472ba22083a5b2c481afe0500ea41fd1.png)

### LoadBalancer Service

![](http://dockone.io/uploads/article/20180424/56c3f5be08699ea34146959ea12ea591.gif)

### 江湖路远，Kubernetes 版图扩张全记录

![](https://www.kubernetes.org.cn/img/2018/01/20180120095026.jpg)

### 

<div style="width: 640px;" class="wp-video"><video class="wp-video-shortcode" id="video-227-1" width="640" height="360" preload="metadata" controls="controls"><source type="video/mp4" src="https://dn-linuxcn.qbox.me/The%20Illustrated%20Children%27s%20Guide%20to%20Kubernetes-4ht22ReBjno.mp4?_=1" /><a href="https://dn-linuxcn.qbox.me/The%20Illustrated%20Children%27s%20Guide%20to%20Kubernetes-4ht22ReBjno.mp4">https://dn-linuxcn.qbox.me/The%20Illustrated%20Children%27s%20Guide%20to%20Kubernetes-4ht22ReBjno.mp4</a></video></div>


What is Kubernetes? Container orchestration explained

https://www.infoworld.com/article/3268073/kubernetes/what-is-kubernetes-container-orchestration-explained.html

Containers and Orchestration Explained
https://www.mongodb.com/containers-and-orchestration-explained


Docker 和 Kubernetes 从听过到略懂：给程序员的旋风教程

http://dockone.io/article/8299
https://1byte.io/developer-guide-to-docker-and-kubernetes/

## Operator原理

Operator基于Third Party Resources扩展了新的应用资源，并通过控制器来保证应用处于预期状态。比如etcd operator通过下面的三个步骤模拟了管理etcd集群的行为：
1. 通过Kubernetes API观察集群的当前状态；
2. 分析当前状态与期望状态的差别；
3. 调用etcd集群管理API或Kubernetes API消除这些差别

![](https://img-blog.csdn.net/20170719091123592?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQveWFuMjM0MjgwNTMz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)


Operator本质是通过在Kubenertes中部署对应的Third-Party Resource (TPR)插件，然后通过部署Third-Party Resource的方式来部署对应的应用。Third-Party Resource会调用Kubenertes部署API部署相应的Kubenertes资源，并对资源状态进行管理。

![](https://img-blog.csdn.net/20170719092402185?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQveWFuMjM0MjgwNTMz/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

