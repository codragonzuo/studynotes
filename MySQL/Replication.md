

## Replication Topology
![](https://avisheksharma.files.wordpress.com/2015/01/mysql_replication.jpg)

Explanation: 
1) There are three parallel threads working, one on the server host and remaining two(IO thread and SQL Thread) on the slave host.

2) The task of the thread on the server host, is to write all the events to a file called binary log(make sure binary recording is enabled on the server host).

3) IO Thread interact with the server host and reads all the events being recorded with specific replication co-ordinate and writes it to its local file called relay log.

4) SQL thread reads all non-run events from the relay log and applies to the slave database.

![](https://i2.wp.com/scriptingmysql.com/scriptingmysql/mysql_replication_topology_threads.png)

## Using Replication to Improve Performance During Scale-Out

Scale-Out横向扩展

Scale-Up纵向扩展



![](https://dev.mysql.com/doc/refman/5.5/en/images/scaleout.png)

## Replication for Backups
To use replication as a backup solution, replicate data from the master to a slave, and then back up the data slave. The slave can be paused and shut down without affecting the running operation of the master, so you can produce an effective snapshot of “live” data that would otherwise require the master to be shut down.

How you back up a database depends on its size and whether you are backing up only the data, or the data and the replication slave state so that you can rebuild the slave in the event of failure. There are therefore two choices:

If you are using replication as a solution to enable you to back up the data on the master, and the size of your database is not too large, the mysqldump tool may be suitable. See Section 17.3.1.1, “Backing Up a Slave Using mysqldump”.

For larger databases, where mysqldump would be impractical or inefficient, you can back up the raw data files instead. Using the raw data files option also means that you can back up the binary and relay logs that will enable you to recreate the slave in the event of a slave failure. For more information, see Section 17.3.1.2, “Backing Up Raw Data from a Slave”.

Another backup strategy, which can be used for either master or slave servers, is to put the server in a read-only state. The backup is performed against the read-only server, which then is changed back to its usual read/write operational status. 

## Switching Masters During Failover

Redundancy Using Replication, After Master Failure

![](https://dev.mysql.com/doc/refman/5.5/en/images/redundancy-after.png)


## Group Replication

基于组的复制（Group-based Replication）是一种被使用在容错系统中的技术。Replication-group（复制组）是由能够相互通信的多个服务器（节点）组成的。 
在通信层，Group replication实现了一系列的机制：比如原子消息（atomic message delivery）和全序化消息（total ordering of messages）。 
这些原子化，抽象化的机制，为实现更先进的数据库复制方案提供了强有力的支持。

MySQL Group Replication正是基于这些技术和概念，实现了一种多主全更新的复制协议。 

简而言之，一个Replication-group就是一组节点，每个节点都可以独立执行事务，而读写事务则会在于group内的其他节点进行协调之后再commit。 

因此，当一个事务准备提交时，会自动在group内进行原子性的广播，告知其他节点变更了什么内容/执行了什么事务。 
这种原子广播的方式，使得这个事务在每一个节点上都保持着同样顺序。 
这意味着每一个节点都以同样的顺序，接收到了同样的事务日志，所以每一个节点以同样的顺序重演了这些事务日志，最终整个group保持了完全一致的状态。

然而，不同的节点上执行的事务之间有可能存在资源争用。这种现象容易出现在两个不同的并发事务上。 
假设在不同的节点上有两个并发事务，更新了同一行数据，那么就会发生资源争用。 
面对这种情况，Group Replication判定先提交的事务为有效事务，会在整个group里面重演，后提交的事务会直接中断，或者回滚，最后丢弃掉。

因此，这也是一个无共享的复制方案，每一个节点都保存了完整的数据副本。图1也描述了具体的工作流程，能够简洁的和其他方案进行对比。 
这个复制方案，在某种程度上，和数据库状态机（DBSM）的Replication方法比较类似。

Mysql版本5.7.17推出Mysql group replication（组复制），相对以前传统的复制模式（异步复制模式async replication 及半同步复制模式semi-sync replication），一个主，对应一个或多个从，在主数据库上执行的事务通过binlog复制的方式传送给slave，slave通过 IO thread线程接收将事务先写入relay log，然后重放事务，即在slave上重新执行一次事务，从而达到主从事务一致的效果，

## 
