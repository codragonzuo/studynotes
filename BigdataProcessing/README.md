
## Understanding Batch, Microbatch, and Streaming

https://streaml.io/resources/tutorials/concepts/understanding-batch-microbatch-streaming

-Batch processing

In batch processing, newly arriving data elements are collected into a group. The whole group is then processed at a future time (as a batch, hence the term “batch processing”). Exactly when each group is processed can be determined in a number of ways–for example, it can be based on a scheduled time interval (e.g. every five minutes, process whatever new data has been collected) or on some triggered condition (e.g. process the group as soon as it contains five data elements or as soon as it has more than 1MB of data).

![](https://streaml.io/media/img/batch-processing.png)

The term “microbatch” is frequently used to describe scenarios where batches are small and/or processed at small intervals. Even though processing may happen as often as once every few minutes, data is still processed a batch at a time. Spark Streaming is an example of a system that supports micro-batch processing.

Stream processing

In stream processing, each new piece of data is processed when it arrives. Unlike batch processing, there is no waiting until the next batch processing interval and data is processed as individual pieces rather than being processed a batch at a time.

![](https://streaml.io/media/img/stream-processing.png)

Stream processing
Stream processing
Although each new piece of data is processed individually, many stream processing systems do also support “window” operations that allow processing to also reference data that arrives within a specified interval before and/or after the current data arrived.

Carrying forward our analogy, a stream processing approach to organizing laundry would sort, match, and organize laundry as it is taken out of the dryer. In this approach, a bit more work is done initially for each load of laundry, but there is no longer a need to go back and reorganize the entire drawer at a later time because it is already organized, and time is no longer wasted searching through the drawer for buried pieces of clothing.

There are a growing number of systems designed for stream processing including Apache Storm and Heron. These systems are frequently deployed to support real-time processing of events.

Implications of the differences between batch and stream processing

Although it may seem that the differences between stream processing and batch, especially micro-batch, are just a matter of a small difference in timing, they actually have fundamental implications for both the architecture of data processing systems and for the applications using them.

Systems for stream processing are designed to respond to data as it arrives. That requires them to implement an event-driven architecture, an architecture in which the internal workflow of the system is designed to continuously monitor for new data and dispatch processing as soon as that data is received. On the other hand, the internal workflow in a batch processing system only checks for new data periodically, and only processes that data when the next batch window occurs.

The difference between stream and batch processing is also significant for applications. Applications built for batch processing by definition process data with a delay. In a data pipeline with multiple steps, those delays accumulate. In addition, the lag between arrival of new data and the processing of that data will vary depending on the time until the next batch processing window–from no time at all in some cases to the full time between batch windows for data that arrives just after the start of processing of a batch. As a result, batch processing applications (and their users) cannot rely on consistent response times and need to adjust accordingly to that inconsistency and to greater latency.

Batch processing is generally appropriate for use cases where having the most up-to-date data is not important and where tolerance for slower response time is higher. For example, offline analysis of historical data to compute results or identify correlations is a common batch processing use case.

Stream processing, on the other hand, is necessary for use cases that require live interaction and real-time responsiveness. Financial transaction processing, real-time fraud detection, and real-time pricing are examples that best fit stream processing.

内存计算、交互式查询分析、流计算、机器学习算法、图计算

## DATA STRATEGY – THE BIG DATA AND ANALYTICS ARCHITECTURAL PATTERNS

https://www.analyticsinsight.net/data-strategy-the-bigdata-and-analytics-architectural-patterns/

![](https://www.analyticsinsight.net/wp-content/uploads/2020/01/FigN12.png)


![](https://www.analyticsinsight.net/wp-content/uploads/2020/01/FigN13.png)

The explosion of Big data has resulted in many new opportunities for the organizations leading to a rapidly increasing demand for consumption at various levels. The big data applications are generating an enormous amount of data every day and creating scope for analysis of these datasets leading to better and smarter decisions. These decisions depend on meaningful insight and accurate predictions which leads to maximization of the quality of services and generating healthy profits. This storm of data in the form of text, picture, sound, and video (known as “ big data”) demands a better strategy, architecture and design frameworks to source and flow to multiple layers of treatment before it is consumed. The 3V’s i.e. high volume, high velocity, and variety need a specific architecture for specific use-cases.

When an organization defines a data strategy, apart from fundamentals like data vision, principles, metrics, measurements, short/long term objectives, it also considers data/analytics priorities, levels of data maturity, data governance and integration. This is very crucial for the organization’s success and a lot depends on its maturity. As the organization moves forward with the aim of satisfying the business needs, the data strategy needs to fulfill the requirements of all the business use-cases.

The use-cases differ from one another resulting in one architecture differing from another. In such scenarios, the big data demands a pattern which should serve as a master template for defining an architecture for any given use-case. Most of the architecture patterns are associated with data ingestion, quality, processing, storage, BI and analytics layer. Each of these layers has multiple options. For example, the integration layer has an event, API and other options. The selection of any of these options for each layer based on the use-case forms a pattern. Likewise, architecture has multiple patterns and each of them satisfies one of the use-cases.



The big data architecture patterns serve many purposes and provide a unique advantage to the organization. The pre-agreed and approved architecture offers multiple advantages as enumerated below;

1. Agreement between all the stakeholders of the organization

2. Better coordination between all the stakeholders within the organization especially between Data Strategy and IT

3. All the stakeholders provide their complete support for the implementation of the architecture

4. Minimal or no effort from all the stakeholders during any new architecture implementation

5. Faster implementation of new architecture

6. Early enablement of architecture will lead to the speedy implementation of the solution

 

The architecture pattern can be broadly classified as;

1. Source

2. Data Integration

3. Storage

4. Data Processing

5. Data Abstraction

6. Data Schema

Each layer has multiple architecture options along with technologies tagged to each of them. The source system or application broadly generates 3 types of data namely, structured, semi-structured and unstructured depending on the nature of the application. This data can be acquired in many ways using any of the methods like messaging, event, query, API or change data capture (CDC). The extraction of data could be either push or pull depending on which method of architecture pattern is used. Generally, API, CDC and messaging use push while query uses pull mechanism. The ingested data needs storage and this can be done on relational, distributed, Massively Parallel Processing (MPP) or NoSQL databases. In some patterns, the data resides in memory. The in-memory storage is useful when all the processing has to be done in memory without storing the data. The processing of data can be distributed, parallel or sequential. The data abstraction and schema define the output format and further redirect it to analytics, dashboards or downstream applications.

Once the architecture pattern is defined, it can be used for any new or modified use case as mentioned in the below illustration.



As an organization expands its business, it has to deal with a new set of applications and data. In this scenario, the organization’s existing data architecture supports only a structured dataset whereas the adoption of new applications generates semi-structured and unstructured data. In such scenarios, a well-defined architecture pattern, as part of the data strategy, can quickly absorb and adopt the new use case requirements. The above illustration depicts the end to end flow of the architecture that is required to bring the semi and unstructured data to support the business with the required analytics and predictive models.

Well, we have covered the architecture patterns with various options like Kappa, Lambda, polyglot, and IoT and included all the major patterns that are currently used. We will glance at other aspects of data strategy in the upcoming articles. Feel free to comment or reach out to me on basu.darawan@gmail.com / https://www.linkedin.com/in/basavaraj-darawan-0823ab54/


## 大数据计算模式分类

![](https://img-blog.csdnimg.cn/20190917234259537.png)

典型大数据计算模式与系统 

典型大数据计算模式

典型系统

大数据查询分析计算

HBase，Hive，Cassandra，Impala，Shark，Hana等

批处理计算

Hadoop MapReduce，Spark等

流式计算

Scribe，Flume，Storm，S4, Spark Steaming等 

迭代计算

HaLoop，iMapReduce，Twister，Spark等

图计算

Pregel，Giraph，Trinity，PowerGraph，GraphX等

内存计算

Dremel，Hana，Spark等



## 流式计算的三种框架：Storm、Spark和Flink

https://my.oschina.net/u/4004373/blog/3109561

我们知道，大数据的计算模式主要分为批量计算(batch computing)、流式计算(stream computing)、交互计算(interactive computing)、图计算(graph computing)等。其中，流式计算和批量计算是两种主要的大数据计算模式，分别适用于不同的大数据应用场景。

目前主流的流式计算框架有Storm、Spark Streaming、Flink三种，其基本原理如下：

Apache Storm
在Storm中，需要先设计一个实时计算结构，我们称之为拓扑（topology）。之后，这个拓扑结构会被提交给集群，其中主节点（master node）负责给工作节点（worker node）分配代码，工作节点负责执行代码。在一个拓扑结构中，包含spout和bolt两种角色。数据在spouts之间传递，这些spouts将数据流以tuple元组的形式发送；而bolt则负责转换数据流。在这里插入图片描述

Apache Spark
Spark Streaming，即核心Spark API的扩展，不像Storm那样一次处理一个数据流。相反，它在处理数据流之前，会按照时间间隔对数据流进行分段切分。Spark针对连续数据流的抽象，我们称为DStream（Discretized Stream）。 DStream是小批处理的RDD（弹性分布式数据集）， RDD则是分布式数据集，可以通过任意函数和滑动数据窗口（窗口计算）进行转换，实现并行操作。 在这里插入图片描述

Apache Flink
针对流数据+批数据的计算框架。把批数据看作流数据的一种特例，延迟性较低(毫秒级)，且能够保证消息传输不丢失不重复。 在这里插入图片描述

Flink创造性地统一了流处理和批处理，作为流处理看待时输入数据流是无界的，而批处理被作为一种特殊的流处理，只是它的输入数据流被定义为有界的。Flink程序由Stream和Transformation这两个基本构建块组成，其中Stream是一个中间结果数据，而Transformation是一个操作，它对一个或多个输入Stream进行计算处理，输出一个或多个结果Stream。

这三种计算框架的对比如下：

在这里插入图片描述

参考文章：

Streaming Big Data: Storm, Spark and Samza

![](https://img-blog.csdnimg.cn/20190910192426945.png)

![](https://img-blog.csdnimg.cn/20190910192740234.png)

![](https://img-blog.csdnimg.cn/20190910192754513.jpg)

