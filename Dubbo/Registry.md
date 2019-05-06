
# Registry

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/dubbo-architecture.jpg)

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/zookeeper.jpg)

流程说明：

 - 服务提供者启动时: 向 /dubbo/com.foo.BarService/providers 目录下写入自己的 URL 地址
 - 服务消费者启动时: 订阅 /dubbo/com.foo.BarService/providers 目录下的提供者 URL 地址。并向 /dubbo/com.foo.BarService/consumers 目录下写入自己的 URL 地址
 - 监控中心启动时: 订阅 /dubbo/com.foo.BarService 目录下的所有提供者和消费者 URL 地址。


dubbo的register层；此层封装服务地址的注册与发现，以服务URL为中心，扩展接口为RegistryFactory, Registry, RegistryService；

Registry主要提供了注册(register)，注销(unregister)，订阅(subscribe)，退订(unsubscribe)等功能；dubbo提供了多种注册方式分别是：Multicast ，Zookeeper，Redis以及Simple方式；

具体的Register是在RegistryFactory中生成的，具体看一下接口定义；

RegistryFactory接口

接口定义如下：
```JAVA
@SPI("dubbo")
public interface RegistryFactory {

    @Adaptive({"protocol"})
    Registry getRegistry(URL url);

}
```
RegistryFactory提供了SPI扩展，默认使用dubbo，具体有哪些扩展可以查看META-INF/dubbo/internal/com.alibaba.dubbo.registry.RegistryFactory：
```
dubbo=com.alibaba.dubbo.registry.dubbo.DubboRegistryFactory
multicast=com.alibaba.dubbo.registry.multicast.MulticastRegistryFactory
zookeeper=com.alibaba.dubbo.registry.zookeeper.ZookeeperRegistryFactory
redis=com.alibaba.dubbo.registry.redis.RedisRegistryFactory
```


ZookeeperRegistryFactory，提供了createRegistry方法：
```JAVA
private ZookeeperTransporter zookeeperTransporter;
 
 public Registry createRegistry(URL url) {
        return new ZookeeperRegistry(url, zookeeperTransporter);
 }
```
实例化ZookeeperRegistry，两个参数分别是url和zookeeperTransporter，zookeeperTransporter是操作Zookeeper的客户端组件,包括：zkclient和curator两种方式
```
@SPI("curator")
public interface ZookeeperTransporter {

    @Adaptive({Constants.CLIENT_KEY, Constants.TRANSPORTER_KEY})
    ZookeeperClient connect(URL url);

}
```

ZookeeperTransporter同样提供了SPI扩展，默认使用curator方式；接下来重点看一下Zookeeper注册中心。


***通过RegistryFactory实例化Registry，Registry可以接收RegistryProtocol传过来的注册(register)和订阅(subscribe)消息，然后Registry通过ZKClient来向Zookeeper指定的目录下写入url信息，如果是订阅消息Registry会通过NotifyListener来通知RegitryDirctory进行更新url，最后就是Cluster层通过路由，负载均衡选择具体的提供方；***

失败重试

FailbackRegistry从名字可以看出来具有：失败自动恢复，后台记录失败请求，定时重发功能；在FailbackRegistry的构造器中启动了一个定时器：
```JAVA
this.retryFuture = retryExecutor.scheduleWithFixedDelay(new Runnable() {
            @Override
            public void run() {
                // Check and connect to the registry
                try {
                    retry();
                } catch (Throwable t) { // Defensive fault tolerance
                    logger.error("Unexpected error occur at failed retry, cause: " + t.getMessage(), t);
                }
            }
        }, retryPeriod, retryPeriod, TimeUnit.MILLISECONDS);
```

