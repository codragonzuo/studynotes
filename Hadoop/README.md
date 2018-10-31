
## Hadoop分布式文件系统：架构和设计

### Namenode 和 Datanode
HDFS采用master/slave架构。一个HDFS集群是由一个Namenode和一定数目的Datanodes组成。Namenode是一个中心服务器，负责管理文件系统的名字空间(namespace)以及客户端对文件的访问。集群中的Datanode一般是一个节点一个，负责管理它所在节点上的存储。HDFS暴露了文件系统的名字空间，用户能够以文件的形式在上面存储数据。从内部看，一个文件其实被分成一个或多个数据块，这些块存储在一组Datanode上。Namenode执行文件系统的名字空间操作，比如打开、关闭、重命名文件或目录。它也负责确定数据块到具体Datanode节点的映射。Datanode负责处理文件系统客户端的读写请求。在Namenode的统一调度下进行数据块的创建、删除和复制。

![](http://hadoop.apache.org/docs/r1.0.4/cn/images/hdfsarchitecture.gif)

Namenode和Datanode被设计成可以在普通的商用机器上运行。这些机器一般运行着GNU/Linux操作系统(OS)。HDFS采用Java语言开发，因此任何支持Java的机器都可以部署Namenode或Datanode。由于采用了可移植性极强的Java语言，使得HDFS可以部署到多种类型的机器上。一个典型的部署场景是一台机器上只运行一个Namenode实例，而集群中的其它机器分别运行一个Datanode实例。这种架构并不排斥在一台机器上运行多个Datanode，只不过这样的情况比较少见。

集群中单一Namenode的结构大大简化了系统的架构。Namenode是所有HDFS元数据的仲裁者和管理者，这样，用户数据永远不会流过Namenode。

### 文件系统的名字空间 (namespace)
HDFS支持传统的层次型文件组织结构。用户或者应用程序可以创建目录，然后将文件保存在这些目录里。文件系统名字空间的层次结构和大多数现有的文件系统类似：用户可以创建、删除、移动或重命名文件。当前，HDFS不支持用户磁盘配额和访问权限控制，也不支持硬链接和软链接。但是HDFS架构并不妨碍实现这些特性。

Namenode负责维护文件系统的名字空间，任何对文件系统名字空间或属性的修改都将被Namenode记录下来。应用程序可以设置HDFS保存的文件的副本数目。文件副本的数目称为文件的副本系数，这个信息也是由Namenode保存的。

### 数据复制
HDFS被设计成能够在一个大集群中跨机器可靠地存储超大文件。它将每个文件存储成一系列的数据块，除了最后一个，所有的数据块都是同样大小的。为了容错，文件的所有数据块都会有副本。每个文件的数据块大小和副本系数都是可配置的。应用程序可以指定某个文件的副本数目。副本系数可以在文件创建的时候指定，也可以在之后改变。HDFS中的文件都是一次性写入的，并且严格要求在任何时候只能有一个写入者。

Namenode全权管理数据块的复制，它周期性地从集群中的每个Datanode接收心跳信号和块状态报告(Blockreport)。接收到心跳信号意味着该Datanode节点工作正常。块状态报告包含了一个该Datanode上所有数据块的列表。

![](http://hadoop.apache.org/docs/r1.0.4/cn/images/hdfsdatanodes.gif)


## Hadoop Streaming
Hadoop streaming是Hadoop的一个工具， 它帮助用户创建和运行一类特殊的map/reduce作业， 这些特殊的map/reduce作业是由一些可执行文件或脚本文件充当mapper或者reducer。例如：
```
$HADOOP_HOME/bin/hadoop  jar $HADOOP_HOME/hadoop-streaming.jar \
    -input myInputDirs \
    -output myOutputDir \
    -mapper /bin/cat \
    -reducer /bin/wc
```
#### Streaming工作原理
在上面的例子里，mapper和reducer都是可执行文件，它们从标准输入读入数据（一行一行读）， 并把计算结果发给标准输出。Streaming工具会创建一个Map/Reduce作业， 并把它发送给合适的集群，同时监视这个作业的整个执行过程。

如果一个可执行文件被用于mapper，则在mapper初始化时， 每一个mapper任务会把这个可执行文件作为一个单独的进程启动。 mapper任务运行时，它把输入切分成行并把每一行提供给可执行文件进程的标准输入。 同时，mapper收集可执行文件进程标准输出的内容，并把收到的每一行内容转化成key/value对，作为mapper的输出。 默认情况下，一行中第一个tab之前的部分作为key，之后的（不包括tab）作为value。 如果没有tab，整行作为key值，value值为null。不过，这可以定制，在下文中将会讨论如何自定义key和value的切分方式。

如果一个可执行文件被用于reducer，每个reducer任务会把这个可执行文件作为一个单独的进程启动。 Reducer任务运行时，它把输入切分成行并把每一行提供给可执行文件进程的标准输入。 同时，reducer收集可执行文件进程标准输出的内容，并把每一行内容转化成key/value对，作为reducer的输出。 默认情况下，一行中第一个tab之前的部分作为key，之后的（不包括tab）作为value。在下文中将会讨论如何自定义key和value的切分方式。

这是Map/Reduce框架和streaming mapper/reducer之间的基本通信协议。

用户也可以使用java类作为mapper或者reducer。上面的例子与这里的代码等价：
```
$HADOOP_HOME/bin/hadoop  jar $HADOOP_HOME/hadoop-streaming.jar \
    -input myInputDirs \
    -output myOutputDir \
    -mapper org.apache.hadoop.mapred.lib.IdentityMapper \
    -reducer /bin/wc
```
用户可以设定stream.non.zero.exit.is.failure true 或false 来表明streaming task的返回值非零时是 Failure 还是Success。默认情况，streaming task返回非零时表示失败。

#### 将文件打包到提交的作业中
任何可执行文件都可以被指定为mapper/reducer。这些可执行文件不需要事先存放在集群上； 如果在集群上还没有，则需要用-file选项让framework把可执行文件作为作业的一部分，一起打包提交。例如：

```
$HADOOP_HOME/bin/hadoop  jar $HADOOP_HOME/hadoop-streaming.jar \
    -input myInputDirs \
    -output myOutputDir \
    -mapper myPythonScript.py \
    -reducer /bin/wc \
    -file myPythonScript.py 
```
上面的例子描述了一个用户把可执行python文件作为mapper。 其中的选项“-file myPythonScirpt.py”使可执行python文件作为作业提交的一部分被上传到集群的机器上。

除了可执行文件外，其他mapper或reducer需要用到的辅助文件（比如字典，配置文件等）也可以用这种方式打包上传。例如：

```
$HADOOP_HOME/bin/hadoop  jar $HADOOP_HOME/hadoop-streaming.jar \
    -input myInputDirs \
    -output myOutputDir \
    -mapper myPythonScript.py \
    -reducer /bin/wc \
    -file myPythonScript.py \
    -file myDictionary.txt
```

## Hadoop HA

HA：High Available，高可用
　　在Hadoop 2.0之前,在HDFS 集群中NameNode 存在单点故障 (SPOF：A Single Point of Failure)。 对于只有一个 NameNode 的集群，如果 NameNode 机器出现故障(比如宕机或是软件、硬件 升级)，那么整个集群将无法使用，直到 NameNode 重新启动.

HDFS 的 HA 功能通过配置 Active/Standby 两个 NameNodes 实现在集群中对 NameNode 的 热备来解决上述问题。如果出现故障，如机器崩溃或机器需要升级维护，这时可通过此种方 式将 NameNode 很快的切换到另外一台机器。

　　在一个典型的 HDFS(HA) 集群中，使用两台单独的机器配置为 NameNodes 。在任何时间点， 确保 NameNodes 中只有一个处于 Active 状态，其他的处在 Standby 状态。其中 ActiveNameNode 负责集群中的所有客户端操作，StandbyNameNode 仅仅充当备机，保证一 旦 ActiveNameNode 出现问题能够快速切换。

　　为了能够实时同步 Active 和 Standby 两个 NameNode 的元数据信息（实际上 editlog），**需提 供一个共享存储系统，可以是 NFS、QJM（Quorum Journal Manager）或者 Zookeeper，Active Namenode 将数据写入共享存储系统，而 Standby 监听该系统，一旦发现有新数据写入，则 读取这些数据，并加载到自己内存中，以保证自己内存状态与 Active NameNode 保持基本一 致，如此这般，在紧急情况下 standby 便可快速切为 active namenode**。为了实现快速切换， Standby 节点获取集群的最新文件块信息也是很有必要的。为了实现这一目标，DataNode 需 要配置 NameNodes 的位置，并同时给他们发送文件块信息以及心跳检测。

![](https://images2018.cnblogs.com/blog/1228818/201803/1228818-20180323190333589-394758470.png)

Zookeeper 作为一个分布式的服务框架，主要用来解决分布式集群中应用系统的一致性问题，它能提供基于类似于文件系统的目录节点树方式的数据存储， Zookeeper 作用主要是用来维护和监控存储的数据的状态变化，通过监控这些数据状态的变化，从而达到基于数据的集群管理。 
1 Zookeeper基本框架 
Zookeeper集群主要角色有Leader，Learner（Follower，Observer(当服务器增加到一定程度，由于投票的压力增大从而使得吞吐量降低，所以增加了Observer。）以及client： 

Leader：领导者，负责投票的发起和决议，以及更新系统状态 

Follower：接受客户端的请求并返回结果给客户端，并参与投票 

Observer：接受客户端的请求，将写的请求转发给leader，不参与投票。Observer目的是扩展系统，提高读的速度。 

Client:客户端，想Zookeeper发起请求。 

Zookeeper的基本框架图如下： 
![](https://zookeeper.apache.org/doc/current/images/zkservice.jpg)

Zookeeper主要提供高效的管理集群的四点功能
- 统一命名服务
- 配置管理
- 集群管理
- 共享锁和队列管理

###What Is ZooKeeper?
ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. ZooKeeper is simple, distributed, reliable, and fast.

maintaining configuration information: It maintains cluster configuration info which is shared across all the nodes in the cluster.

naming: Zookeeper can be used as naming service, so that one node in the cluster can find another node in the large cluster ex: 1000 node cluster

providing distributed synchronization:  We can also use zookeeper for solving distributed synchronization problems in the cluster by using locks, Queues etc.

providing group services:  Zookeeper also helps in group service with the selection of a master in the cluster(Leader election process).

ZooKeeper can work in replicated mode as well as standalone mode.




