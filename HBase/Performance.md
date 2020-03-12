
## HBase最佳实践－读性能优化策略

https://sq.163yun.com/blog/article/170967745293946880

![](https://nos.netease.com/cloud-website-bucket/20180629095309595e6b9b-b350-498e-9dbe-1dcc8ca06e8e.png)


hbase读性能可以，关键设计好rowkey：  
1，数据量大的读hbase  
2，数据量小的读redis  
3，也可以用redis做hbase的cache  

写是MemStore和HLog append方式所以很快，读忽略blockcache的话，由于不同的CF存储在不同的HFile中开销相对大些。  



HBase不是一个关系型数据库，它需要不同的方法定义你的数据模型，HBase实际上定义了一个四维数据模型，下面就是每一维度的定义：

行键：每行都有唯一的行键，行键没有数据类型，它内部被认为是一个字节数组。

列簇：数据在行中被组织成列簇，每行有相同的列簇，但是在行之间，相同的列簇不需要有相同的列修饰符。在引擎中，HBase将列簇存储在它自己的数据文件中，所以，它们需要事先被定义，此外，改变列簇并不容易。

列修饰符：列簇定义真实的列，被称之为列修饰符，你可以认为列修饰符就是列本身。

版本：每列都可以有一个可配置的版本数量，你可以通过列修饰符的制定版本获取数据。

![](https://pic1.zhimg.com/50/2ea41713e45f5df8ff3a8241fdaaa715_hd.jpg)


## 深入探讨hbase读性能优化探讨（20190308）

https://blog.51cto.com/12445535/2360206?source=dra

## Hbase 批量写入 put 和 批量读取 batch

