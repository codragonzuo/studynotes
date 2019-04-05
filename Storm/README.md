## Why use Storm?
Apache Storm is a free and open source distributed realtime computation system. Storm makes it easy to reliably process unbounded streams of data, doing for realtime processing what Hadoop did for batch processing. 

Storm is simple, can be used with any programming language, and is a lot of fun to use!

Storm has many use cases: realtime analytics, online machine learning, continuous computation, distributed RPC, ETL, and more. 

Storm is fast: a benchmark clocked it at over a million tuples processed per second per node. 

It is scalable, fault-tolerant, guarantees your data will be processed, and is easy to set up and operate.

Storm integrates with the queueing and database technologies you already use. 
A Storm topology consumes streams of data and processes those streams in arbitrarily complex ways, repartitioning the streams between each stage of the computation however needed. 
Read more in the tutorial.

Apache Storm是一个分布式实时大数据处理系统。Storm设计用于在容错和水平可扩展方法中处理大量数据。它是一个流数据框架，具有最高的摄取率。



Storm框架主要由7部分组成

- Topology：一个实时应用的计算任务被打包作为Topology发布，这同Hadoop的MapReduce任务相似。 
- Spout：Storm中的消息源，用于为Topology生产消息（数据），一般是从外部数据源（如Message Queue、RDBMS、NoSQL、Realtime Log）不间断地读取数据并发送给Topology消息（tuple元组）。 
- Bolt：Storm中的消息处理者，用于为Topology进行消息的处理，Bolt可以执行过滤，聚合， 查询数据库等操作，而且可以一级一级的进行处理。 
- Stream：产生的数据（tuple元组）。 
- Stream grouping：在Bolt任务中定义的Stream进行区分。 
- Task：每个Spout或者Bolt在集群执行许多任务。 
- Worker：Topology跨一个或多个Worker节点的进程执行。



Storm distinguishes between the following three main entities that are used to actually run a topology in a Storm cluster:

- Worker processes
- Executors (threads)
- Tasks
Here is a simple illustration of their relationships:
![](https://www.michael-noll.com/assets/uploads/Storm_worker-processes_executors_tasks.png)
