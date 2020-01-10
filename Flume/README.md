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

## File Channel

Flume --文件通道(file channel)

文件通道是Flume的持久通道。它将所有事件写入磁盘，因此不会丢失进程或机器关机或崩溃的数据。文件通道可确保任何提交到通道的事件只有在接收到事件并提交事务时才会从通道中删除，即使机器或代理程序崩溃并重新启动。它被设计为高度并发，同时处理多个source和sink。

文件通道设计用于需要数据持久性和不能容忍数据丢失的情况。由于通道将数据写入磁盘，因此不会在数据崩溃或失败时丢失数据。由于将数据写入磁盘的事实，额外的一个好处是，该通道可以具有非常大的容量，特别是与内存通道相比。

只要磁盘空间可用，文件通道可以具有极大的容量，高达数十或数亿的事件。这是非常有用的，当预期从渠道获取的汇款将无法跟上有限的高峰期，并且大量积压的事件是可能的。如果配置正确，文件通道也可以处理更长的下游停机时间。由于通道在事件提交后不会将内存保留在内存中，因此与等效容量的内存通道相比，占用的空间要少得多。

文件通道保证写入的每个事件将通过代理和机器故障或重新启动而可用。它通过写出将通道放入磁盘的每个事件来实现。一旦提交了一个事务，该事务中的事件就可用于执行。这些事件从磁盘读取，并在从通道获取时传递给接收器，并且完全取消引用，并在提交交易事件后有资格删除。

文件通道允许用户通过将其安装在不同的安装点上来配置多个磁盘的使用。当配置为使用多个磁盘时，通道在磁盘之间循环，从而允许通道在更多磁盘可用时执行得更好。建议（尽管不需要）为文件通道检查点使用单独的磁盘。检查点反映了检查点写出时刻的通道的确切状态。文件通道使用检查点快速重新启动，而不必读取所有数据文件。它在运行时会将检查点写入磁盘。在重新启动时，通道加载最后一个写出的检查点，仅重放放样，并在该检查点之后进行，并允许通道快速启动并准备好进行正常操作。默认情况下，两个连续检查点之间的间隔设置为30秒，尽管它是可配置的。

文件通道允许用户传递几个配置参数，使他们可以根据硬件微调通道的性能。

The channel is a passive store that keeps the event until it’s consumed by a Flume sink. The file channel is one example – it is backed by the local filesystem. The sink removes the event from the channel and puts it into an external repository like HDFS (via Flume HDFS sink) or forwards it to the Flume source of the next Flume agent (next hop) in the flow. The source and sink within the given agent run asynchronously with the events staged in the channel.





# How to run Flume in HA 

https://community.cloudera.com/t5/Support-Questions/How-to-run-Flume-in-HA/td-p/95446

How to run Flume in HA ?
  
 orenault Guru
Created ‎10-28-2015 04:58 PM
Here is some of the key points to use Flume in "HA"

1. Setup File Channels instead of Memory Channels (using a RAID array is very paranoid but possible) on any Flume agent in use

2. Create a nanny process/script to watch for flume agent failures and restart immediately

3. Put the Flume agent collector/aggregation/2nd tier behind a network load balancer and use a VIP. This also has the benefit for balancing load for high ingest

4. Optionally have a sink that dumps to cycling files (separate from the drive the File Channel operates on) on the local drives in addition to a sink that forwards it on the next flume node or directly to HDFS. At least then you have the time it takes to fill a drive to correct any major issues and recover lost ingest streams.

5. Use the built in JMX counters in Flume to setup alerts in your favorite Operations Center application

