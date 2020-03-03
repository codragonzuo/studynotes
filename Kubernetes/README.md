
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


## Spring Cloud or Kubernetes?
Kubernetes 在网易云中的落地优化实践

https://www.kubernetes.org.cn/4489.html

Spring Cloud 和 Kubernetes 都是一个利器。它们面向的用户和解决思路是不一样的。Spring Cloud 更多的是面向开发者们，尤其是 Java 开发者，他们是从代码级别去考虑微服务是怎么去设计的。开发者们需要去处理，比如注册、环境配置怎么拿到？对于他们来说，除了做业务开发，他还要关心一些业务之外的东西。

Kubernetes 更多是面向 DevOps，它是希望通过提供一个平台，一个通用性的方案把微服务中间需要处理的细节放在平台上解决。不用去关注服务发现和 DNS 这些东西，就比如说在 Spring Cloud 里面的服务发现。你需要代码去拿这些信息。

但是在 Kubernetes 里，你只需要去创建一个服务，然后访问这个 Kubernetes 服务，你不用去关心后台策略是怎么做、服务是怎么发现、请求是怎么传到后面的 Pod。所以它是从不同的层面去解决这个问题的。因为 Spring Cloud 和 Kubernetes，不是一个完全对应的产品。作为微服务的一些基础要点，它们是有自己不同的解决方案。这里是做了一个相对的比较。你会发现无论是 Spring Cloud，还是 Kubernetes，其实都有他自己的方式去解决问题。

比较来看，如果做微服务，并不是说我只选 Kubernetes，或是 Spring Cloud，而是把它们结合起来用，更能发挥他们各自的优势。再比如服务发现、负载均衡、高可用、调度、部署这部分，我们是用 Kubernetes。比如故障隔离，我们用 Hystrix 去做进程内隔离，但是做进程间隔离，是通过 Kubernetes 的资源配额去做。比如像配置问题，Docker 能解决应用和运行环境等问题。


![](https://www.kubernetes.org.cn/img/2018/08/20180822221145.jpg)

![](https://www.kubernetes.org.cn/img/2018/08/20180822221215.jpg)

![](https://www.kubernetes.org.cn/img/2018/08/20180822221223.jpg)

Kubernetes 加 Docker，我们可以比较好的解决部分问题。有一些问题 Kubernetes 自己可以解决，但用起来不是很方便。还有一些只能用第三方工具，或者自己的方式来解决。比如说像监控，我们就是用第三方工具。比如说 ELK 是用 Grafana 去做监控。分步式追踪，我们做了一个 APM 分布步式追踪。




# Kubinception: using Kubernetes to run Kubernetes
https://www.codemotion.com/magazine/dev-hub/backend-dev/kubinception-using-kubernetes-to-run-kubernetes/


# I Flink You Freaky And I like you a lot!

https://itnext.io/i-flink-you-freaky-and-i-like-you-a-lot-68554f7629df

![](https://miro.medium.com/max/500/1*wNe01uWnZ0sbJ2HUnKnAUg.gif)
