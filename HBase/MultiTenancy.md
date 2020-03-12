
# Multi Tenancy

HBase多租户

https://blog.csdn.net/pengzhouzhou/article/details/91349835

Quota&Throttle

由于集群的资源及服务能力是有上限的，Quota用于限制各个资源的数据量的大小及访问速度。

1、Throttle Quota

Throttle限制单位时间内，访问资源的次数或数据量。

支持的时间单位包括sec, min, hour, day。

使用req限制请求的次数；

使用B, K, M, G, T, P限制请求的数据量的大小；

使用CU限制请求的读/写容量单位，一个读/写容量单位是指一次读出/写入数据量小于1KB的请求，如果一个请求读出了2.5K的数据，则需要消耗3个容量单位。可以通过hbase.quota.read.capacity.unit或hbase.quota.write.capacity.unit配置一个容量单位的数据量。

Machine scope代表throttle额度配置在单台RS上。Cluster代表throttle配额被集群的全部RS共享。如果不指定QuotaScope的话，默认为Machine。

2、Space Quota

Space用于限制资源的数据量大小，配置在namespace或者table上。当数据量达到限额时，执行配置的违反策略，包括：

Disable：disable table/ the tables of namespace

NoInserts：禁止除Delete以外的Mutation操作，允许Compaction

NoWrites：禁止Mutation操作，允许Compaction

NoWritesCompactions：禁止Mutation操作，禁止Compaction



https://blog.csdn.net/pengzhouzhou/article/details/91349835


