
# Registry

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/dubbo-architecture.jpg)

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/zookeeper.jpg)

流程说明：

 - 服务提供者启动时: 向 /dubbo/com.foo.BarService/providers 目录下写入自己的 URL 地址
 - 服务消费者启动时: 订阅 /dubbo/com.foo.BarService/providers 目录下的提供者 URL 地址。并向 /dubbo/com.foo.BarService/consumers 目录下写入自己的 URL 地址
 - 监控中心启动时: 订阅 /dubbo/com.foo.BarService 目录下的所有提供者和消费者 URL 地址。
