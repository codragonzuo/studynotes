
## RegionServer Groupy用户隔离


https://blog.csdn.net/b6ecl1k7BS8O/article/details/83663271


使用RegionServer Groupy 对不同用户的表 进行分组， 避免

***这样两个表如果其中一个表的请求量增大，也不会对另外一个表所在机器的 CPU、内存和 JVM 有影响。 ***

不过目前同一个集群底层的 HDFS 还是一套磁盘的流量，IO 压力还是要注意。有独立分组的用户也不是无限制的去使用集群资源的。

应用 RegionServer Group 之后，资源分配计算我们总结了方案，通过以下方法来大致判断用户的流量以及需要分配多少资源。

https://www.sohu.com/a/282318219_315839

