# Filebeat

filebeat 源码分析

https://segmentfault.com/a/1190000006124064


通过filebeat来实现日志的收集。日志采集的工具有很多种，如fluentd, flume, logstash,betas等等。首先要知道为什么要使用filebeat呢？因为logstash是jvm跑的，资源消耗比较大，启动一个logstash就需要消耗500M左右的内存，而filebeat只需要10来M内存资源。常用的ELK日志采集方案中，大部分的做法就是将所有节点的日志内容通过filebeat送到kafka消息队列，然后使用logstash集群读取消息队列内容，根据配置文件进行过滤。然后将过滤之后的文件输送到elasticsearch中，通过kibana去展示。

　　Filebeat由两个主要组成部分组成：prospector和 harvesters。这些组件一起工作来读取文件并将事件数据发送到您指定的output。
- 什么是harvesters？
　　harvesters负责读取单个文件的内容。harvesters逐行读取每个文件，并将内容发送到output中。
  
  每个文件都将启动一个harvesters。harvesters负责文件的打开和关闭，这意味着harvesters运行时，文件会保持打开状态。如果在收集过程中，即使删除了这个文件或者是对文件进行重命名，Filebeat依然会继续对这个文件进行读取，这时候将会一直占用着文件所对应的磁盘空间，直到Harvester关闭。默认情况下，Filebeat会一直保持文件的开启状态，直到超过配置的close_inactive参数，Filebeat才会把Harvester关闭。

关闭Harvesters会带来的影响：
　　file Handler将会被关闭，如果在Harvester关闭之前，读取的文件已经被删除或者重命名，这时候会释放之前被占用的磁盘资源。
　　
  当时间到达配置的scan_frequency参数，将会重新启动为文件内容的收集。
　
 如果在Havester关闭以后，移动或者删除了文件，Havester再次启动时，将会无法收集文件数据。
　
 当需要关闭Harvester的时候，可以通过close_*配置项来控制。

- 什么是Prospector？
　　Prospector负责管理Harvsters，并且找到所有需要进行读取的数据源。如果input type配置的是log类型，Prospector将会去配置度路径下查找所有能匹配上的文件，然后为每一个文件创建一个Harvster。每个Prospector都运行在自己的Go routine里。
　　
  Filebeat目前支持两种Prospector类型：log和stdin。每个Prospector类型可以在配置文件定义多个。
  
  log Prospector将会检查每一个文件是否需要启动Harvster，启动的Harvster是否还在运行，或者是该文件是否被忽略（可以通过配置 ignore_order，进行文件忽略）。
  
  如果是在Filebeat运行过程中新创建的文件，只要在Harvster关闭后，文件大小发生了变化，新文件才会被Prospector选择到。
  
  
  - Filebeat架构
  ![](https://img2018.cnblogs.com/blog/1251723/201907/1251723-20190702173514655-621256648.png)
  
  每个harvester读取新的内容一个日志文件，新的日志数据发送到spooler（后台处理程序），它汇集的事件和聚合数据发送到你已经配置了Filebeat输出。
  
  
  
  
  ## 负载均衡
  
  filebeat输出到 Redis, Logstash, and Elasticsearch 时，可以配置负载均衡。
  
  kafka自身有负载均衡的功能。
  
  


## Ansible实例：filebeat配置管理

https://blog.csdn.net/goodlife111/article/details/101423624


## Filebeat配置详解

https://www.cnblogs.com/whych/p/9958188.html


## 高可用logstash


![](https://qbox.io/img/blog/logstash2_170804_143027.png)

有两种方式， HaProxy和DNS两种方式进行 高可用 配置。


## 解决单点故障 + 负载均衡 ---- Keepalive + Haproxy

单点故障(单点故障是指一旦某一点出现故障就会导致整个系统架构的不可用).

In the load balanced scenario we just saw, there is a single point of failure. The single point of failure is the load balancer itself. This can be solved by using something called keepalived.

You can solve this problem by introducing another Haproxy server, which in total is two Haproxy servers with identical configuration. The idea is to have only one Haproxy act as the ACTIVE one and the other as standby. The standby will become ACTIVE if the other goes down.

A single IP address keeps on floating between two Haproxy nodes. If the active one is not available, the standby will assign the ip address to itself, so that requests from client will automatically be routed to it.

We basically need two Haproxy servers( with identical configuration - the configuration that we saw above) and both of them should have keepalived configured.

LVS（Linux Virtual Server）即Linux虚拟服务器，是由章文嵩博士主导的开源负载均衡项目，目前LVS已经被集成到Linux内核模块中。该项目在Linux内核中实现了基于IP的数据请求负载均衡调度方案.


## 调优

### filebeat内存泄漏问题分析及调优

https://blog.csdn.net/u013613428/article/details/84557827

- 监控文件数过多
- 多行问题
- 非常频繁的rotate日志

### 通过pprof优化filebeat性能

https://segmentfault.com/a/1190000021307490

日志收集延迟的问题，最差的情况，延迟两天以上。严重影响了下游数据分析项目。

之前我们在压测的时候，已经设置了output批量发送。再加上观察kafka集群的性能监控，基本上可以排查是下游集群的影响。

由于大量的小日志，在写到kafka之前，都在大量的gzip压缩，造成了大量的CPU时间浪费在了GC上。？？？？？


## beats

beats是一组轻量级采集程序的统称，这些采集程序包括并不限于：

- filebeat: 进行文件和目录采集，主要用于收集日志数据。
- metricbeat: 进行指标采集，指标可以是系统的，也可以是众多中间件产品的，主要用于监控系统和软件的性能。
- packetbeat: 通过网络抓包、协议分析，对一些请求响应式的系统通信进行监控和数据收集，可以收集到很多常规方式无法收集到的信息。
- Winlogbeat: 专门针对windows的event log进行的数据采集。
- Heartbeat: 系统间连通性检测，比如icmp, tcp, http等系统的连通性监控。

![](https://img-blog.csdnimg.cn/2019021310341265.png)

## Filebeat
Filebeat 是 Elastic Stack 的一部分，因此能够与 Logstash、Elasticsearch 和 Kibana 无缝协作。无论您要使用 Logstash 转换或充实日志和文件，还是在 Elasticsearch 中随意处理一些数据分析，亦或在 Kibana 中构建和分享仪表板，Filebeat 都能轻松地将您的数据发送至最关键的地方。

![](https://img-blog.csdnimg.cn/20190213103441971.png)



## filebeat 源码分析

https://segmentfault.com/a/1190000006124064

