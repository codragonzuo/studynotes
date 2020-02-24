
# Logstash

![](https://upload-images.jianshu.io/upload_images/4191539-d5e23e3b3fccbdef.png)

![](https://upload-images.jianshu.io/upload_images/4191539-842d031314a66ccc.png)

![](https://upload-images.jianshu.io/upload_images/4191539-b2a602870837aea6.png)

![](https://upload-images.jianshu.io/upload_images/4191539-bfb9ba42e71690dd.png)

![](https://upload-images.jianshu.io/upload_images/4191539-d6acea1657d59510.png)

![](https://upload-images.jianshu.io/upload_images/4191539-940179d9bd1201ac.png)

![](https://upload-images.jianshu.io/upload_images/4191539-e998fccdfcf3979d.png)

事件的声明周期

1. 数据输入到Input 中（可以有多个Input）
2. Input中的Codec 将输入数据转换为 Event
3. Event 存储到 Queue 队列中
4. 每一个 Batcher->Filter->Output 都占有1个工作线程
5. Batcher 从 Queue 队列中获取 Event，当 Batcher 中的Event数量达到阈值或者达到等待时长后，Batcher会将Event发送到Filter中处理
6. Filter处理完Event后，将Event传到Output中，Output中Codec将Event转换为输出数据输出
7. Output输出后通知Queue ACK for persistence，Queue将标记已完成的Event（在持久化队列Persistent Queue中将用到ACK）

![](https://upload-images.jianshu.io/upload_images/4191539-e998fccdfcf3979d.png)

工作流程

1. 红1. 数据从Input输入，转换为Event后提交到PQ（Persistent Queue）中
2. 红2. PQ将数据备份到磁盘Disk中
3. 红3. Disk备份成功
4. 红4. PQ返回EventResponse给Input，告诉Input数据已经收到（需要Input支持EventResponse机制，支持这种机制Input可以感知Logstash的处理能力，即背压机制，FileBeat支持该机制，FileBeat如果没有收到logstash的EventResponse，则会减少输入，缓解Logstash的压力）
5. 蓝1. Event被Fileter和Output处理
6. 蓝2. Output处理完发送ACK通知PQ处理完毕该Event
7. 蓝3. PQ从磁盘中删除该Event记录

![](https://upload-images.jianshu.io/upload_images/4191539-fd0f689d1b9d3683.png)

线程简介

![](https://upload-images.jianshu.io/upload_images/4191539-18c2aaa729278327.png)


## 性能优化
说一说我的实际经验吧，自己搭了一套ELK收集公司某大型系统的日志。

Filebeat节点大概有30个，logstash节点3个（8C16G），数据一天1TB左右。

开始遇到的问题是logstash发送数据有延迟，通过调整线程数和batch size将logstash集群的吞吐量提升到5000e/s后始终突破不上去。于是加入了三台Kafka集群（均8C8G），每个Topic分3个分区，让三个logstash消费，现在可以达到10000e/s，基本满足需求就没有继续优化了。

如果你未来有扩容或数据量增大的情况，建议加入消息队列做缓冲，而且以后方便管理，比如你要加Logstash节点，不需要每个filebeat做更改。

感觉ELK还是很吃资源的，如果保证实时性的话。


## logstash是怎么工作的呢？

　　Logstash是一个开源的、服务端的数据处理pipeline（管道），它可以接收多个源的数据、然后对它们进行转换、最终将它们发送到指定类型的目的地。
  
  Logstash是通过插件机制实现各种功能的，读者可以在https://github.com/logstash-plugins 下载各种功能的插件，也可以自行编写插件。

　　Logstash实现的功能主要分为接收数据、解析过滤并转换数据、输出数据三个部分，对应的插件依次是input插件、filter插件、output插件，其中，filter插件是可选的，其它两个是必须插件。也就是说在一个完整的Logstash配置文件中，必须有input插件和output插件。
  
- 日志接收
- 日志解析过滤，日志转换
- 日志输出

## Logstash管道pipeline特性

插件式的pipeline架构---混合和编排不同的input、filter以及output构建pipeline。

Logstash事件处理管道协调input、filter和output的执行。

Logstash pipeline中的每个input阶段都在自己的线程中运行。input将事件写入内存（默认）或磁盘上的中央队列。每个pipeline的工作线程从这个队列中取出一批事件，通过配置的filter运行这批事件，然后通过output输出经过过滤、转换的事件。

默认情况下，Logstash在pipeline的stage之间使用内存中的有界队列缓存事件。如果Logstash异常终止，存储在内存中的事件会丢失。为了防止数据丢失，可以配置将运行的事件持久化到磁盘。


## 如何配置logstash集群

推荐 logstash 消费 kafka 消息
多个 logstash 订阅同一个主题，使用同一个 group 
这样一条消息只可能被一个 logstash 节点消费
当某一个节点挂了，并不影响其他节点对该 topic 消息的消费
这样即可解决 logstash 单点问题


如果是filebeat-logstash这种使用场景，filebeat里面配置多个logstash的IP即可

logstash目前版本没有集群这一概念，flume有，可以在系统层面搞个软负载，keepalive haproxy。


## logstash的lumberjack协议解析

是一种TCP协议。

https://segmentfault.com/a/1190000006087978?utm_medium=referral&utm_source=tuicool



