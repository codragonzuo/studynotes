
# Dubbo
Dubbo是阿里巴巴公司开源的一个高性能优秀的服务框架，使得应用可通过高性能的 RPC 实现服务的输出和输入功能，可以和Spring框架无缝集成。

- Provider

暴露服务方称之为“服务提供者”。

- Consumer

调用远程服务方称之为“服务消费者”。

- Registry

服务注册与发现的中心目录服务称之为“服务注册中心”。

- Monitor

统计服务的调用次数和调用时间的日志服务称之为“服务监控中心”。

![](https://gss1.bdstatic.com/-vo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=9a3d824f9b504fc2b652b85784b48c74/d01373f082025aaf111c708cfbedab64034f1a4e.jpg)



![](http://dubbo.apache.org/docs/en-us/dev/sources/images/dubbo-framework.jpg)


## dubbo
1. 透明化的远程调用，就像调用本地方法一样调用远程方法。
2. 软负载均衡几容错机制，可在内网替代F5等硬件负载均衡器
3. 服务自动注册与发现，不需要写死服务提供方地址

## 快速启动

Dubbo 采用全 Spring 配置方式，透明化接入应用，对应用没有任何 API 侵入，只需用 Spring 加载 Dubbo 的配置即可，Dubbo 基于 Spring 的 Schema 扩展 进行加载。
如果不想使用 Spring 配置，可以通过 API 的方式 进行调用。

服务提供和实现

http://dubbo.apache.org/zh-cn/docs/user/quick-start.html

## 容错策略Fault Tolerance Strategy
在集群调用失败时，Dubbo 提供了多种容错方案，缺省为 failover 重试。

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/cluster.jpg)

cluster

各节点关系：

- 这里的 Invoker 是 Provider 的一个可调用 Service 的抽象，Invoker 封装了 Provider 地址及 Service 接口信息

- Directory 代表多个 Invoker，可以把它看成 List<Invoker> ，但与 List 不同的是，它的值可能是动态变化的，比如注册中心推送变更

- Cluster 将 Directory 中的多个 Invoker 伪装成一个 Invoker，对上层透明，伪装过程包含了容错逻辑，调用失败后，重试另一个

- Router 负责从多个 Invoker 中按路由规则选出子集，比如读写分离，应用隔离等

- LoadBalance 负责从多个 Invoker 中选出具体的一个用于本次调用，选的过程包含了负载均衡算法，调用失败后，需要重选


