## Why use Storm?
Apache Storm is a free and open source distributed realtime computation system. Storm makes it easy to reliably process unbounded streams of data, doing for realtime processing what Hadoop did for batch processing. 

Storm is simple, can be used with any programming language, and is a lot of fun to use!

Storm has many use cases: realtime analytics, online machine learning, continuous computation, distributed RPC, ETL, and more. 

Storm is fast: a benchmark clocked it at over a million tuples processed per second per node. 

It is scalable, fault-tolerant, guarantees your data will be processed, and is easy to set up and operate.

Storm integrates with the queueing and database technologies you already use. 
A Storm topology consumes streams of data and processes those streams in arbitrarily complex ways, repartitioning the streams between each stage of the computation however needed. 
Read more in the tutorial.

![](http://storm.apache.org/images/storm-flow.png)

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

## Documentation
### Concepts
http://storm.apache.org/releases/1.2.2/Concepts.html
 - Topologies
 - Streams
 - Spouts
 - Bolts
 - Stream groupings
 - Reliability
 - Tasks
 - Workers

### Javadoc/Storm API
http://storm.apache.org/releases/1.2.2/javadocs/index.html

### 
###
## Tutorial
http://storm.apache.org/releases/1.1.2/Tutorial.html

Components of a Storm cluster

A Storm cluster is superficially similar to a Hadoop cluster. Whereas on Hadoop you run "MapReduce jobs", on Storm you run "topologies". "Jobs" and "topologies" themselves are very different -- one key difference is that a MapReduce job eventually finishes, whereas a topology processes messages forever (or until you kill it).

There are two kinds of nodes on a Storm cluster: the master node and the worker nodes. The master node runs a daemon called "Nimbus" that is similar to Hadoop's "JobTracker". Nimbus is responsible for distributing code around the cluster, assigning tasks to machines, and monitoring for failures.

Each worker node runs a daemon called the "Supervisor". The supervisor listens for work assigned to its machine and starts and stops worker processes as necessary based on what Nimbus has assigned to it. Each worker process executes a subset of a topology; a running topology consists of many worker processes spread across many machines.

![](http://storm.apache.org/releases/1.1.2/images/storm-cluster.png)

Storm cluster

All coordination between Nimbus and the Supervisors is done through a Zookeeper cluster. Additionally, the Nimbus daemon and Supervisor daemons are fail-fast and stateless; all state is kept in Zookeeper or on local disk. This means you can kill -9 Nimbus or the Supervisors and they'll start back up like nothing happened. This design leads to Storm clusters being incredibly stable.

Topologies

To do realtime computation on Storm, you create what are called "topologies". A topology is a graph of computation. Each node in a topology contains processing logic, and links between nodes indicate how data should be passed around between nodes.

Running a topology is straightforward. First, you package all your code and dependencies into a single jar. Then, you run a command like the following:

storm jar all-my-code.jar org.apache.storm.MyTopology arg1 arg2
This runs the class org.apache.storm.MyTopology with the arguments arg1 and arg2. The main function of the class defines the topology and submits it to Nimbus. The storm jar part takes care of connecting to Nimbus and uploading the jar.

Since topology definitions are just Thrift structs, and Nimbus is a Thrift service, you can create and submit topologies using any programming language. The above example is the easiest way to do it from a JVM-based language. See Running topologies on a production cluster] for more information on starting and stopping topologies.

Streams

The core abstraction in Storm is the "stream". A stream is an unbounded sequence of tuples. Storm provides the primitives for transforming a stream into a new stream in a distributed and reliable way. For example, you may transform a stream of tweets into a stream of trending topics.

The basic primitives Storm provides for doing stream transformations are "spouts" and "bolts". Spouts and bolts have interfaces that you implement to run your application-specific logic.

A spout is a source of streams. For example, a spout may read tuples off of a Kestrel queue and emit them as a stream. Or a spout may connect to the Twitter API and emit a stream of tweets.

A bolt consumes any number of input streams, does some processing, and possibly emits new streams. Complex stream transformations, like computing a stream of trending topics from a stream of tweets, require multiple steps and thus multiple bolts. Bolts can do anything from run functions, filter tuples, do streaming aggregations, do streaming joins, talk to databases, and more.

Networks of spouts and bolts are packaged into a "topology" which is the top-level abstraction that you submit to Storm clusters for execution. A topology is a graph of stream transformations where each node is a spout or bolt. Edges in the graph indicate which bolts are subscribing to which streams. When a spout or bolt emits a tuple to a stream, it sends the tuple to every bolt that subscribed to that stream.

A Storm topology

Links between nodes in your topology indicate how tuples should be passed around. For example, if there is a link between Spout A and Bolt B, a link from Spout A to Bolt C, and a link from Bolt B to Bolt C, then everytime Spout A emits a tuple, it will send the tuple to both Bolt B and Bolt C. All of Bolt B's output tuples will go to Bolt C as well.

Each node in a Storm topology executes in parallel. In your topology, you can specify how much parallelism you want for each node, and then Storm will spawn that number of threads across the cluster to do the execution.

A topology runs forever, or until you kill it. Storm will automatically reassign any failed tasks. Additionally, Storm guarantees that there will be no data loss, even if machines go down and messages are dropped.
