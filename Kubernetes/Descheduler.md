

## kubernetes调度重平衡工具 Descheduler

https://www.cnblogs.com/evenchen/p/12143653.html

工具简介

Descheduler 的出现就是为了解决 Kubernetes 自身调度（一次性调度）不足的问题。它以定时任务方式运行，根据已实现的策略，重新去平衡 pod 在集群中的分布。

截止目前，Descheduler 已实现的策略和计划中的功能点如下：

 

已实现的调度策略

```
RemoveDuplicates
移除重复 pod
LowNodeUtilization
节点低度使用
RemovePodsViolatingInterPodAntiAffinity
移除违反pod反亲和性的 pod
RemovePodsViolatingNodeAffinity
```

路线图中计划实现的功能点
```
Strategy to consider taints and tolerations
考虑污点和容忍
Consideration of pod affinity
考虑 pod 亲和性
Strategy to consider pod life time
考虑 pod 生命周期
Strategy to consider number of pending pods
考虑待定中的 pod 数量
Integration with cluster autoscaler
与集群自动伸缩集成
Integration with metrics providers for obtaining real load metrics
与监控工具集成来获取真正的负载指标
Consideration of Kubernetes’s scheduler’s predicates
考虑 k8s 调度器的预判机制
``` 

策略介绍

- RemoveDuplicates
此策略确保每个副本集(RS)、副本控制器(RC)、部署(Deployment)或任务(Job)只有一个 pod 被分配到同一台 node 节点上。如果有多个则会被驱逐到其它节点以便更好的在集群内分散 pod。

- LowNodeUtilization
a. 此策略会找到未充分使用的 node 节点并在可能的情况下将那些被驱逐后希望重建的 pod 调度到该节点上。  
b. 节点是否利用不足由一组可配置的 阈值(thresholds) 决定。这组阈值是以百分比方式指定了 CPU、内存以及 pod数量 的。只有当所有被评估资源都低于它们的阈值时，该 node 节点才会被认为处于利用不足状态。  
c. 同时还存在一个 目标阈值(targetThresholds)，用于评估那些节点是否因为超出了阈值而应该从其上驱逐 pod。任何阈值介于 thresholds 和 targetThresholds 之间的节点都被认为资源被合理利用了，因此不会发生 pod 驱逐行为（无论是被驱逐走还是被驱逐来）。  
d. 与之相关的还有另一个参数numberOfNodes，这个参数用来激活指定数量的节点是否处于资源利用不足状态而发生 pod 驱逐行为。  

- RemovePodsViolatingInterPodAntiAffinity
此策略会确保 node 节点上违反 pod 间亲和性的 pod 被驱逐。比如节点上有 podA 并且 podB 和 podC（也在同一节点上运行）具有禁止和 podA 在同一节点上运行的反亲和性规则，则 podA 将被从节点上驱逐，以便让 podB 和 podC 可以运行。

- RemovePodsViolatingNodeAffinity
此策略会确保那些违反 node 亲和性的 pod 被驱逐。比如 podA 运行在 nodeA 上，后来该节点不再满足 podA 的 node 亲和性要求，如果此时存在 nodeB 满足这一要求，则 podA 会被驱逐到 nodeB 节点上。

 
遵循机制

当 Descheduler 调度器决定于驱逐 pod 时，它将遵循下面的机制：

- Critical pods (with annotations scheduler.alpha.kubernetes.io/critical-pod) are never evicted
关键 pod（带注释 scheduler.alpha.kubernetes.io/critical-pod）永远不会被驱逐。

- Pods (static or mirrored pods or stand alone pods) not part of an RC, RS, Deployment or Jobs are never evicted because these pods won’t be recreated
不属于RC，RS，部署或作业的Pod（静态或镜像pod或独立pod）永远不会被驱逐，因为这些pod不会被重新创建。

- Pods associated with DaemonSets are never evicted
与 DaemonSets 关联的 Pod 永远不会被驱逐。

- Pods with local storage are never evicted
具有本地存储的 Pod 永远不会被驱逐。

- BestEffort pods are evicted before Burstable and Guaranteed pods
QoS 等级为 BestEffort 的 pod 将会在等级为 Burstable 和 Guaranteed 的 pod 之前被驱逐。

 
工具使用

Descheduler 会以 Job 形式在 pod 内运行，因为 Job 具有多次运行而无需人为介入的优势。为了避免被自己驱逐 Descheduler 将会以 关键型 pod 运行，因此它只能被创建建到 kube-system namespace 内。

关于 Critical pod 的介绍请参考：Guaranteed Scheduling For Critical Add-On Pods

要使用 Descheduler，我们需要编译该工具并构建 Docker 镜像，创建 ClusterRole、ServiceAccount、ClusterRoleBinding、ConfigMap 以及 Job。

由于文档中有一些小问题，手动执行这些步骤不会很顺利，我们推荐使用有人维护的现成 helm charts。

项目地址：https://github.com/komljen/helm-charts/tree/master/descheduler

使用方式：

```
helm repo add akomljen-charts \
     https://raw.githubusercontent.com/komljen/helm-charts/master/charts/
helm install --name ds --namespace kube-system akomljen-charts/descheduler
```
 

该 Chart 默认设置如下：


Descheduler 以 CronJob 方式运行，每 30 分钟执行一次，可根据实际需要进行调整；

在 ConfigMap 中同时内置了 4种策略，可根据实际需要禁用或调整；

值得注意的是，Descheduler 项目文档中是以 Job 方式运行，属于一次性任务。

 
问题处理

在手动编译构建 Descheduler 过程中，我们发现官方文档有个小问题。

比如，文档中 Job 的启动方式如下：
```
     command:
     - "/bin/sh"
     - "-ec"
     - |
    /bin/descheduler --policy-config-file /policy-dir/policy.yaml
```
即，指定使用 sh 来运行 descheduler，然而该工具的 Dockerfile 却是以白手起家（FROM scratch）方式添加 descheduler 的编译产物到容器内，新容器并不包含工具sh, 这就导致 Job 在运行后因为没有 sh 而失败并不断拉起新的 Job，短时间内大量 Job 被创建, node 节点资源也逐渐被消耗。

关于该问题我提交了一个 isusse #133，解决办法有2种：

从 command 中移除 /bin/sh -ec  
修改 Dockerfile 中 From scratch 为 From alpine 或 busybox 或 centos 等  
然后重新构建并创建 Job。


