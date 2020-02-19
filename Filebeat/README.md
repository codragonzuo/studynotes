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
  
  
  
  
