



## Cassandra和HBase对比


https://www.jianshu.com/p/91d5b50b9682

参考：  
Cassandra vs. HBase: twins or just strangers with similar looks?  

知乎

1. cassandera是p2p架构，无单点失效问题，Hbase是主从结构，有可能有单点问题

2. cassandera是AP系统，也可以通过调整参数使它成为CP系统（只要R+W>N），HBase是CP系统，HBase强一致性，对数据有强一致性需求的话使用HBase

3. cassandera是一个数据存储和数据管理系统。HBase只负责数据管理，它需要配合HDFS和zookeeper来搭建集群

4. cassandera写数据的性能好一些，但看数据性能不会损失太多

- 原因是，写的路径太长，hbase需要先到zk获取metatable的region server，然后到region server获取metatable，再在metatable获取写入数据对应的region，然后再访问region server来真正写入数据，过程比较繁琐。当然，metatable在那个region server会缓存到client端的

Moreover, the actual measurements of Cassandra’s write performance (in a 32-node cluster, almost 326,500 operations per second versus HBase’s 297,000) also prove that Cassandra is better at writes than HBase.

5. Hbase在数据一致性和scan的性能比较好，有一篇软文是datastax写的，但是里面获取的数据不是scan出来，而且数据不一致。需要用scan来在一大堆数据里找出一小堆的数据，用hbase比较好，cassandera的scan效率比hbase低，因为它用一致性哈希来分布数据，不好做scan，而hbase的数据在region内是排序的，scan效率高。cassandera的并发读写性能好，而且是可以调节的，hbase只能从一个region server获取数据，不提供并发读写特性

when it comes to scanning huge volumes of data to find a small number of results, due to having no data duplications, HBase is better. For instance, this reason applies to HBase’s ability to handle text analysis(based on web pages, social network posts, dictionaries and so on). Plus, HBase can do well with data management platforms and basic data analysis(counting, summing and such; due to its coprocessors in Java).

6. 安全方面都提供到比较细粒度的权限

7. 两个都适合存放time-series data，例如传感器数据，网站访问，用户行为，股市交易数据等

8. cassandera擅长数据接入（data ingestion），因为写性能比较好

9. 负载均衡方面，因为cassandera是基于一致性哈希，所以数据分布得比较均匀，平均读写性能比较好。HBase的maseter节点会将过载的region server上的region动态分配到压力较低的region server上，对热点数据的负载均衡比较好。cassandera支持ordered partitioning，但会形成hotspots


cassandra与hbase的利弊分析？适用场景？社区环境？  
https://www.zhihu.com/question/20152327  
Cassandra vs. HBase: twins or just strangers with similar looks?  
https://www.scnsoft.com/blog/cassandra-vs-hbase  
Cassandra vs. MongoDB vs. Couchbase vs. HBase  
https://www.datastax.com/products/compare/nosql-performance-benchmarks  


