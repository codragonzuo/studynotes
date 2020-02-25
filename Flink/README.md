
# Flink

Introducing Apache Flink’s State Processor API

https://dzone.com/articles/introducing-apache-flinks-state-processor-api

Is it possible for Flink state to replace the database

https://developpaper.com/is-it-possible-for-flink-state-to-replace-the-database/


## Flink初探-为什么选择Flink

https://www.jianshu.com/p/442521ddc28f

最显而易见的原因
网上最热的两个原因:

- Flink灵活的窗口
- Exactly once语义保证

这两个原因可以大大的解放程序员, 加快编程效率, 把本来需要程序员花大力气手动完成的工作交给框架, 下面简单介绍一下这两个特征.

![](https://upload-images.jianshu.io/upload_images/1324594-2134a36e28355ef2.png)

### Exactly-once语义保证 ----- 有状态的数据计算

Exactly-once state consistency: Flink’s checkpointing and recovery algorithms guarantee the consistency of application state in case of a failure. Hence, failures are transparently handled and do not affect the correctness of an application.

可以看出, Exactly-once 是为有状态的计算准备的!!!

![](https://upload-images.jianshu.io/upload_images/1324594-e6a658a530ef4c0b.png)

### 解决数据延迟问题。

假设一个程序(下面示例是Flink代码)每5秒聚合一次记录:
```
dataStream
    .map(transformRecords)
    .groupBy("sessionId")
    .window(Time.of(5, TimeUnit.SECONDS))
    .sum("price")
```
这些应用非常适合微批处理模型. 系统累积5秒的数据, 对它们求和, 并在流上进行一些转换后进行聚合计算. 下游应用程序可以直接消费上述5秒聚合后的结果, 例如在仪表板上显示. 但是, 现在假设背压开始起作用(transformRecords需要消耗超过5秒钟的时间), 开发人员决定将窗口间隔改为7秒, 增加吞吐量, 然后, 微批次大小变的不可控制. 这意味着下游应用程序(例如, 包含最近5秒统计的 Web 仪表板)读取的聚合结果是错误的, 下游应用程序需要自己处理此问题, 这显然是不合理的.


例如事件在7分钟的时候到达了, 就会触发一个窗口, 这在流处理模型中很容易实现, 但在微批处理模型中却很难实现, 因为窗口与微批量并不对应.
这种架构的容错工作原理如下: 通过算子的每个中间记录与更新的状态以及后续产生的记录一起创建一个提交记录, 该记录以原子性的方式追加到事务日志或插入到数据库中. 在失败的情况下, 重放部分数据库日志来恢复计算状态, 以及重放丢失的记录.
事务更新体系结构具有许多优点. 事实上, 它实现了我们在本文开头提出的所有需求. 该体系结构的基础是能够频繁地写入具有高吞吐量的分布式容错存储系统中

High-throughput, low-latency, and exactly-once stream processing with Apache Flink
Flink流计算编程--状态与检查点
Flink 原理与实现：Window 机制


https://www.da-platform.com/blog/high-throughput-low-latency-and-exactly-once-stream-processing-with-apache-flink

https://blog.csdn.net/lmalds/article/details/51982696

http://wuchong.me/blog/2016/05/25/flink-internals-window-mechanism/


