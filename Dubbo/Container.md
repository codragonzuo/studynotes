
## 架构

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/dubbo-architecture.jpg)

  Provider	暴露服务的服务提供方
  
  Consumer	调用远程服务的服务消费方
  
  Registry	服务注册与发现的注册中心
  
  Monitor	统计服务的调用次数和调用时间的监控中心
  
  Container	服务运行容器
  

服务运行容器只是一个简单的Main方法，并加载一个简单的Spring容器，用于暴露服务。

com.alibaba.dubbo.container.Main 是服务启动的主类，缺省只加载 spring.

start方法里用  context = new ClassPathXmlApplicationContext(configPath.split("[,\\s]+"), false);读取spring xml的配置。
