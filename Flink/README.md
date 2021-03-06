
# Flink

[Flink-复杂事件（CEP）](CEP.md)

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

## CEP Complex Event Processing

Flink复杂事件处理


- 事件定义



简单事件：简单事件存在于现实场景中，主要的特点为处理单一事件，事件的定义可以直接观察出来，处理过程中无须关注多个事件之间的关系、能够通过简单的数据处理手段将结果计算出来。例如通过对当天的订单总额按照用户维度进行单金额累加值，达到条件进行输出即可。 汇总统计，超过一定数量之后进行报告。这种情况只需要计算每个用户每天的订

复杂事件：相对于简单事件，复杂事件处理的不仅是单一的事件，也处理由多个事件组成的复合事件。复杂事件处理监测分析事件流（ Event Streaming），当特定事件发生时来触发某些动作。

- 事件关系


复杂事件中事件与事件之间包含多种类型关系，常见的有时序关系、聚合关系、层次关系、依赖关系及因果关系等。

时序关系：动作事件和动作事件之间，动作事件和状态变化事件之间，都存在时间顺序。事件和事件的时序关系决定了大部分的时序规则，例如A事件状态持续为1的同时B事件状态变为0等

聚合关系：动作事件和动作事件之间，状态事件和状态事件之间都存在聚合关系，即个体聚合形成整体集合。例如A事件状态为1的次数为10触发预警。

层次关系：动作事件和动作事件之间，状态事件和状态事件之间都存在层次关系，即父类事件和子类事件的层次关系，从父类到子类是具体化的，从子类到父类是泛化的

依赖关系：事物的状态属性之间彼此的依赖关系和约束关系。例如A事件状态触发的条件前提是B事件触发，则A与B事件之间就形成了依赖关系

因果关系：对于完整的动作过程，结果状态为果，初始状态和动作都可以视为原因。例如A事件状态的改变导致了B事件的触发，则A事件就是因，而B事件就是果。

- 事件处理


复杂事件处理的目的是通过相应的规则对实时数据执行相应的处理策略，这些策略包括了推断、查因、决策、预测等方面的应用。

事件推断：主要利用事物状态之间的约東关系，从一部分状态属性值可以推断出另一部分的状态属性值。例如由三角形一个角为90度及另一个角为45度，可以推断出第三个角为45度。

事件查因：当出现结果状态，并且知道初始状态，可以查明某个动作是原因；同样当出现结果状态，并且知道之前发生了什么动作，可以查明初始状态是原因。当然反向的推断要求原因对结果来说必须是必要条件。

事件决策：想得到某个结果状态，知道初始状态，决定执行什么动作。该过程和规则引擎相似，例如某个规则符合条件后触发行动，然后执行报警等操作。

事件预测：该种情况知道事件初始状态，以及将要做的动作，预测未发生的结果状态。例如气象局根据气象相关的数据预测未来的天气情况等。


## What is Apache Flink? — Architecture

https://flink.apache.org/flink-architecture.html

![](https://flink.apache.org/img/bounded-unbounded.png)

- Leverage In-Memory Performance
Stateful Flink applications are optimized for local state access. Task state is always maintained in memory or, if the state size exceeds the available memory, in access-efficient on-disk data structures. Hence, tasks perform all computations by accessing local, often in-memory, state yielding very low processing latencies. Flink guarantees exactly-once state consistency in case of failures by periodically and asynchronously checkpointing the local state to durable storage


![](https://flink.apache.org/img/local-state.png)



## Components 

![](https://ci.apache.org/projects/flink/flink-docs-release-1.10/fig/processes.svg)



 **JobManager ResourceManager TaskManager Dispatcher**
 
 
 
# High Availability (HA)

## JobManager High Availability (HA)

- Standalone Cluster High Availability

![](https://ci.apache.org/projects/flink/flink-docs-release-1.10/fig/jobmanager_ha_overview.png)


![](HaFlinkSetup.png)

Flink依靠外部的容器编排组件 或者 资源调度组件 来进行进程级别的 高可用恢复。

When running an application as a library deployment in a container environment, such as Kubernetes, failed JobManager or TaskManagercontainers are usually automatically restarted by the container orchestration
service. 

When running on YARN or on Mesos, Flink’s remaining processes trigger the restart of JobManager or TaskManager processes. Flink does not
provide tooling to restart failed processes when running in a standalone cluster.   
Hence, it can be useful to run standby JobManagers andTaskManagers that can take over the work of failed processes.   



## Yarn 

![](https://ci.apache.org/projects/flink/flink-docs-release-1.10/fig/FlinkOnYarn.svg)

## JobGraph

![](JobGraph.png)

image for ***Stream Processing with Apache Flink Fundamentals, Implementation, and Operation of Streaming Applications

不同的TaskManager进程的task直接采用网络通信。

同一个TaskManager进程内的task采用 序列化的数据缓存队列 进行通信。

采用技术提高通信效率。

## A Deep-Dive into Flink's Network Stack

Logical View  
Physical Transport  
  Inflicting Backpressure (1)  
Credit-based Flow Control  
  Inflicting Backpressure (2)  
  What do we Gain? Where is the Catch?  
Writing Records into Network Buffers and Reading them again  
  Flushing Buffers to Netty  
  Buffer Builder & Buffer Consumer  
Latency vs. Throughput  
Conclusion  


It abstracts over the different settings of the following three concepts:

- Subtask output type (ResultPartitionType):
  - pipelined (bounded or unbounded): Sending data downstream as soon as it is produced, potentially one-by-one, either as a bounded or unbounded stream of records.
  - blocking: Sending data downstream only when the full result was produced.
- Scheduling type:
  - all at once (eager): Deploy all subtasks of the job at the same time (for streaming applications).
  - next stage on first output (lazy): Deploy downstream tasks as soon as any of their producers generated output.
  - next stage on complete output: Deploy downstream tasks when any or all of their producers have generated their full output set.
- Transport:
  - high throughput: Instead of sending each record one-by-one, Flink buffers a bunch of records into its network buffers and sends them altogether. This reduces the costs per record and leads to higher throughput.
  - low latency via buffer timeout: By reducing the timeout of sending an incompletely filled buffer, you may sacrifice throughput for latency.

![](https://flink.apache.org/img/blog/2019-06-05-network-stack/flink-network-stack1.png)


![])(https://flink.apache.org/img/blog/2019-06-05-network-stack/flink-network-stack3.png)

![](https://flink.apache.org/img/blog/2019-06-05-network-stack/flink-network-stack4.png)

![](https://flink.apache.org/img/blog/2019-06-05-network-stack/flink-network-stack6.png)

![](https://flink.apache.org/img/blog/2019-06-05-network-stack/flink-network-stack7.png)

![](https://flink.apache.org/img/blog/2019-06-05-network-stack/flink-network-stack8.png)

from https://flink.apache.org/2019/06/05/flink-network-stack.html


## Application Sumit

![](ApplicationSumit.png)

## Task Chaining
Flink features an optimization technique called task chaining that reduces the overhead of local communication under certain conditions. In order to satisfy the requirements for task chaining, two or more operators must be configured with the same parallelism and connected by local forward channels. The operator pipeline shown in Figure 3-5 fulfills theserequirements. It consists of three operators that are all configured for a task parallelism of two and connected with local forward connections.
![](TaskChaining01.png)
Figure 3-6 depicts how the pipeline is executed with task chaining. The functions of the operators are fused into a single task that is executed by a single thread. Records that are produced by a function are separately handed over to the next function with a simple method call. Hence, there are basically no serialization and communication costs for passing records between functions.
![](TaskChaining02.png)


## State Management
![](StateManagement01.png)

- Operator State
![](StateManagement02.png)

List state  
Union list state  
Broadcast list state      

- Keyed State
![](StateManagement03.png)
Value state  
List state  
Map state  

- Scaling Stateful Operators
![](StateManagement04.png)
![](StateManagement05.png)
![](StateManagement06.png)
![](StateManagement07.png)

## Checkpoints, Savepoints, and State Recovery

- Consistent Checkpoints

![](Checkpoint01.png)

- Recovery from a Consistent Checkpoint

![](Checkpoint02.png)

## Queryable State

https://ci.apache.org/projects/flink/flink-docs-stable/dev/stream/state/queryable_state.html

![](QueryableState01.png)





