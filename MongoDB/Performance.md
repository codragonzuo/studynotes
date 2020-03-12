
## MongoDB性能篇之创建索引，组合索引，唯一索引，删除索引和explain执行计划

https://www.jb51.net/article/80067.htm


## 实现MongoDB读写分离的“读偏好”介绍

https://www.cnblogs.com/xuliuzai/p/9624508.html

大部分MongoDB驱动支持读偏好设置（read preference；或翻译为读取首选项），用来告诉驱动从特定的节点读取数据。

primary — 这是默认的设置，表明只从可复制集的主节点读取数据，因此具有强一致性。如果可复制集有问题，并且没有可选举的从节点，就表示出现错误。

premaryPreferred — 设置了此参数的驱动会从主节点读取数据，除非某些原因使主节点不可用或者没有主节点，此时它会从从节点读取数据。此种设置下，读请求无法保证一致性。

secondary — 这个设置告诉驱动应该一直从从节点读取数据。这种设置对于我们想确保读请求不会影响主节点的写入请求时非常有用。如果没有可用的从节点，读请求会抛出异常。

secondarypreferred—读请求会发出到从节点，除非没有从节点可用，此时才会从主节点读取。

nearest –驱动会尝试从最近的可复制集成员节点读取读取数据，通过网络延迟判断。可以是主节点也可以是从节点。因此读请求只会发送给驱动认为最快通信的节点。

primary是唯一一个可以确保读一致的模式。因为写请求首先在主节点完成，从服务器的更新会有些延迟，所以可能在从节点无法找到刚刚在主节点写入的文档数据。

汇总以上知识，各偏好设置下读取数据请求所发往的节点如下所示：

![](https://images2018.cnblogs.com/blog/780228/201809/780228-20180910235204059-389264792.png)

2  最大过期时间

MongoDB 3.4及更新的版本新增了maxStalenessSeconds设置。

副本集的从节点可能因为网络阻塞、磁盘吞吐低、长时间执行操作等，导致其落后于主节点。读设置maxStalenessSeconds选项让你对从节点读取定义了最大落后或“过期”时间。当从节点估计过期时间超过了maxStalenessSeconds,客户端会停止使用它进行读操作。

最大过期和primary模式不匹配，只有选择从节点成员读取操作才能应用。

当选择了使用maxStalenessSeconds进行读操作的服务端，客户端会通过比较从节点和主节点的最后一次写时间来估计从节点的过期程度。客户端会把连接指向估计落后小于等于maxStalenessSeconds的从节点。如果没有主节点，客户端使用从节点间的最近一次写操作来比较。

默认是没有最大过期时间并且客户端也不会在指向读操作时考虑从节点的落后。

必须定义maxStalenessSeconds的值大于等于90秒：定义一个更小的值会抛出异常。客户端通过定期检查每个副本集成员最后一次写时间来估计副本集过期程度。因为检查不频繁，所以估计是粗略的。因此，客户端不能强制maxStalenessSecconds小于90秒。

## Mongos 数据自动分片
对于一个读写操作，mongos需要知道应该将其路由到哪个复制集上，mongos通过将片键空间划分为若干个区间，计算出一个操作的片键的所属区间对应的复制集来实现路由。

Collection1 被划分为4个chunk，其中  
chunk1 包含（-INF，1) , chunk3 包含[20, 99) 的数据，放在shard1上。  
chunk2 包含 [1,20), chunk4 包含[99, INF) 的数据，放在shard2上。  
chunk 的信息存放在configServer 的mongod实例的 config.chunks 表中，格式如下：  

```
{   
    "_id" : "mydb.foo-a_\"cat\"",   
    "lastmod" : Timestamp(1000, 3),  
    "lastmodEpoch" : ObjectId("5078407bd58b175c5c225fdc"),   
    "ns" : "mydb.foo",   
    "min" : {         "animal" : "cat"   },   
    "max" : {         "animal" : "dog"   },   
    "shard" : "shard0004"
}
```
![](https://mc.qcloudimg.com/static/img/98ca4095b687757cb69096724d70e72a/image.png)
值得注意的是：chunk是一个逻辑上的组织结构，并不涉及到底层的文件组织方式。
