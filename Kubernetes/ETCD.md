

ETCD 是一个高可用的分布式键值数据库，可用于服务发现。ETCD 采用 raft 一致性算法，基于 Go 语言实现。

特点

简单：安装配置使用简单，提供 HTTP API 

安全：支持 SSL 证书 

可靠：采用 raft 算法，实现分布式系统数据的可用性和一致性

特点：
- 简单：基于HTTP+JSON的API让你用curl就可以轻松使用。
- 安全：可选SSL客户认证机制。
- 快速：每个实例每秒支持一千次写操作。
- 可信：使用Raft算法充分实现了分布式。

分布式系统中的数据分为控制数据和应用数据。etcd的使用场景默认处理的数据都是控制数据，对于应用数据，只推荐数据量很小，但是更新访问频繁的情况。

应用场景有如下几类：
- 场景一：服务发现（Service Discovery）
- 场景二：消息发布与订阅
- 场景三：负载均衡
- 场景四：分布式通知与协调
- 场景五：分布式锁、分布式队列
- 场景六：集群监控与Leader竞选

举个最简单的例子，如果你需要一个分布式存储仓库来存储配置信息，并且希望这个仓库读写速度快、支持高可用、部署简单、支持http接口，那么就可以使用etcd。

目前，cloudfoundry使用etcd作为hm9000的应用状态信息存储，kubernetes用etcd来存储docker集群的配置信息等。

ETCD读写性能

按照官网给出的[Benchmark], 在2CPU，1.8G内存，SSD磁盘这样的配置下，单节点的写性能可以达到16K QPS, 而先写后读也能达到12K QPS。这个性能还是相当可观的。


## ETCD：从应用场景到实现原理的全方位解读

https://www.infoq.cn/article/etcd-interpretation-application-scenario-implement-principle

- 服务注册发现
![](https://static001.infoq.cn/resource/image/e7/d8/e7d6918c1c9b7c9f2829779966ffb5d8.jpg)

- 分布式消息
![](https://static001.infoq.cn/resource/image/5f/0b/5fb77bf6f5751c45f44cbe9df8ee250b.jpg)

- 负载均衡
![](https://static001.infoq.cn/resource/image/67/be/6782904921fa103f42f30113fbf0babe.jpg)

- 分布式协调
![](https://static001.infoq.cn/resource/image/38/97/38bee3d541dd88e6f772e64beab92697.jpg)

- 分布式锁
![](https://static001.infoq.cn/resource/image/46/dc/46ff86e2e2c2157bc3f0409845f0e1dc.jpg)

- 分布式队列
![](https://static001.infoq.cn/resource/image/a0/73/a08ce82fb3bee55d0e31d6e2d062a273.jpg)

- Leader竞选
![](https://static001.infoq.cn/resource/image/2d/8c/2dc062ceed9f882ab99ff41f1ca7b18c.jpg)

## etcd 架构图

![](https://static001.infoq.cn/resource/image/cf/94/cf0851c4bcbd2555d09674e7e2a07394.jpg)

从 etcd 的架构图中我们可以看到，etcd 主要分为四个部分。

HTTP Server： 用于处理用户发送的 API 请求以及其它 etcd 节点的同步与心跳信息请求。
Store：用于处理 etcd 支持的各类功能的事务，包括数据索引、节点状态变更、监控与反馈、事件处理与执行等等，是 etcd 对用户提供的大多数 API 功能的具体实现。
Raft：Raft 强一致性算法的具体实现，是 etcd 的核心。
WAL：Write Ahead Log（预写式日志），是 etcd 的数据存储方式。除了在内存中存有所有数据的状态以及节点的索引以外，etcd 就通过 WAL 进行持久化存储。WAL 中，所有的数据提交前都会事先记录日志。Snapshot 是为了防止数据过多而进行的状态快照；Entry 表示存储的具体日志内容。
通常，一个用户的请求发送过来，会经由 HTTP Server 转发给 Store 进行具体的事务处理，如果涉及到节点的修改，则交给 Raft 模块进行状态的变更、日志的记录，然后再同步给别的 etcd 节点以确认数据提交，最后进行数据的提交，再次同步。


## Proxy 模式
Proxy 模式也是新版 etcd 的一个重要变更，etcd 作为一个反向代理把客户的请求转发给可用的 etcd 集群。这样，你就可以在每一台机器都部署一个 Proxy 模式的 etcd 作为本地服务，如果这些 etcd Proxy 都能正常运行，那么你的服务发现必然是稳定可靠的。

![](https://static001.infoq.cn/resource/image/fd/0f/fd17db8d2165fb60009b77bd4810410f.jpg)

## Raft
新版 etcd 中，raft 包就是对 Raft 一致性算法的具体实现。

Raft 中一个 Term（任期）是什么意思？ Raft 算法中，从时间上，一个任期讲即从一次竞选开始到下一次竞选开始。从功能上讲，如果 Follower 接收不到 Leader 节点的心跳信息，就会结束当前任期，变为 Candidate 发起竞选，有助于 Leader 节点故障时集群的恢复。发起竞选投票时，任期值小的节点不会竞选成功。如果集群不出现故障，那么一个任期将无限延续下去。而投票出现冲突也有可能直接进入下一任再次竞选。
 
![](https://static001.infoq.cn/resource/image/74/e0/740e703fb347a074addb3be1e10d33e0.jpg)

Term 示意图

Raft 状态机是怎样切换的？ Raft 刚开始运行时，节点默认进入 Follower 状态，等待 Leader 发来心跳信息。若等待超时，则状态由 Follower 切换到 Candidate 进入下一轮 term 发起竞选，等到收到集群多数节点的投票时，该节点转变为 Leader。Leader 节点有可能出现网络等故障，导致别的节点发起投票成为新 term 的 Leader，此时原先的老 Leader 节点会切换为 Follower。Candidate 在等待其它节点投票的过程中如果发现别的节点已经竞选成功成为 Leader 了，也会切换为 Follower 节点。

![](https://static001.infoq.cn/resource/image/16/3b/167e2a4f72b05a18425e7ab3baf7a03b.jpg)

Raft 状态机

如何保证最短时间内竞选出 Leader，防止竞选冲突？ 在 Raft 状态机一图中可以看到，在 Candidate 状态下， 有一个 times out，这里的 times out 时间是个随机值，也就是说，每个机器成为 Candidate 以后，超时发起新一轮竞选的时间是各不相同的，这就会出现一个时间差。在时间差内，如果 Candidate1 收到的竞选信息比自己发起的竞选信息 term 值大（即对方为新一轮 term），并且新一轮想要成为 Leader 的 Candidate2 包含了所有提交的数据，那么 Candidate1 就会投票给 Candidate2。这样就保证了只有很小的概率会出现竞选冲突。
如何防止别的 Candidate 在遗漏部分数据的情况下发起投票成为 Leader？ Raft 竞选的机制中，使用随机值决定超时时间，第一个超时的节点就会提升 term 编号发起新一轮投票，一般情况下别的节点收到竞选通知就会投票。但是，如果发起竞选的节点在上一个 term 中保存的已提交数据不完整，节点就会拒绝投票给它。通过这种机制就可以防止遗漏数据的节点成为 Leader。
Raft 某个节点宕机后会如何？ 通常情况下，如果是 Follower 节点宕机，如果剩余可用节点数量超过半数，集群可以几乎没有影响的正常工作。如果是 Leader 节点宕机，那么 Follower 就收不到心跳而超时，发起竞选获得投票，成为新一轮 term 的 Leader，继续为集群提供服务。需要注意的是；etcd 目前没有任何机制会自动去变化整个集群总共的节点数量，即如果没有人为的调用 API，etcd 宕机后的节点仍然被计算为总节点数中，任何请求被确认需要获得的投票数都是这个总数的半数以上。

![](https://static001.infoq.cn/resource/image/6c/59/6c0d225b6ab0cbb4a89afd4b12de0c59.jpg)

节点宕机

为什么 Raft 算法在确定可用节点数量时不需要考虑拜占庭将军问题？ 拜占庭问题中提出，允许 n 个节点宕机还能提供正常服务的分布式架构，需要的总节点数量为 3n+1，而 Raft 只需要 2n+1 就可以了。其主要原因在于，拜占庭将军问题中存在数据欺骗的现象，而 etcd 中假设所有的节点都是诚实的。etcd 在竞选前需要告诉别的节点自身的 term 编号以及前一轮 term 最终结束时的 index 值，这些数据都是准确的，其他节点可以根据这些值决定是否投票。另外，etcd 严格限制 Leader 到 Follower 这样的数据流向保证数据一致不会出错。
用户从集群中哪个节点读写数据？ Raft 为了保证数据的强一致性，所有的数据流向都是一个方向，从 Leader 流向 Follower，也就是所有 Follower 的数据必须与 Leader 保持一致，如果不一致会被覆盖。即所有用户更新数据的请求都最先由 Leader 获得，然后存下来通知其他节点也存下来，等到大多数节点反馈时再把数据提交。一个已提交的数据项才是 Raft 真正稳定存储下来的数据项，不再被修改，最后再把提交的数据同步给其他 Follower。因为每个节点都有 Raft 已提交数据准确的备份（最坏的情况也只是已提交数据还未完全同步），所以读的请求任意一个节点都可以处理。
etcd 实现的 Raft 算法性能如何？ 单实例节点支持每秒 1000 次数据写入。节点越多，由于数据同步涉及到网络延迟，会根据实际情况越来越慢，而读性能会随之变强，因为每个节点都能处理用户请求。


参考文献

https://github.com/coreos/etcd

https://groups.google.com/forum/#!topic/etcd-dev/wmndjzBNdZo

http://jm-blog.aliapp.com/?p=1232

http://progrium.com/blog/2014/07/29/understanding-modern-service-discovery-with-docker/

http://devo.ps/blog/zookeeper-vs-doozer-vs-etcd/

http://jasonwilder.com/blog/2014/02/04/service-discovery-in-the-cloud/

http://www.infoworld.com/article/2612082/open-source-software/has-apache-lost-its-way-.html

http://en.wikipedia.org/wiki/WAL

http://www.infoq.com/cn/articles/coreos-analyse-etcd

http://www.activestate.com/blog/2014/05/service-discovery-solutions

https://ramcloud.stanford.edu/raft.pdf

