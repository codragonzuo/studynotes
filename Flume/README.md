# Flume

## flume组合模式之高可用配置

Flume NG是一个分布式，高可用，可靠的系统，它能将不同的海量数据收集，移动并存储到一个数据存储系统中。轻量，配置简单，适用于各种日志收集，并支持 Failover和负载均衡。并且它拥有非常丰富的组件。Flume NG采用的是三层架构：Agent层，Collector层和Store层，每一层均可水平拓展。其中Agent包含Source，Channel和 Sink，三者组建了一个Agent。三者的职责如下所示：

•Source：用来消费（收集）数据源到Channel组件中

•Channel：中转临时存储，保存所有Source组件信息

•Sink：从Channel中读取，读取成功后会删除Channel中的信息

![](http://flume.apache.org/_images/DevGuide_image00.png)

从外部系统（Web Server）中收集产生的日志，然后通过Flume的Agent的Source组件将数据发送到临时存储Channel组件，最后传递给Sink组件，Sink组件直接把数据存储到HDFS文件系统中。


http://flume.apache.org/

- Setting multi-agent flow

![](http://flume.apache.org/_images/UserGuide_image03.png)

- Consolidation

![](http://flume.apache.org/_images/UserGuide_image02.png)

- http://flume.apache.org/_images/UserGuide_image02.png

![](http://flume.apache.org/_images/UserGuide_image01.png)


