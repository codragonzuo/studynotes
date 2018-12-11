

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
