
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

## dubbo
1. 透明化的远程调用，就像调用本地方法一样调用远程方法。
2. 软负载均衡几容错机制，可在内网替代F5等硬件负载均衡器
3. 服务自动注册与发现，不需要写死服务提供方地址
