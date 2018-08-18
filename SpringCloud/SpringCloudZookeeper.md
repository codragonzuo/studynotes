
## An Intro to Spring Cloud Zookeeper

from https://www.baeldung.com/spring-cloud-zookeeper
Last modified: April 4, 2018

by baeldung CloudSpring+
I just announced the new Spring 5 modules in REST With Spring:

## 1. Introduction

In this article, we will get acquainted with Zookeeper and how it’s used for Service Discovery which is used as a centralized knowledge about services in the cloud.

Spring Cloud Zookeeper provides Apache Zookeeper integration for Spring Boot apps through autoconfiguration and binding to the Spring Environment.

## 2. Service Discovery Setup

We will create two apps:

An app that will provide a service (referred to in this article as the Service Provider)
An app that will consume this service (called the Service Consumer)
Apache Zookeeper will act as a coordinator in our service discovery setup. Apache Zookeeper installation instructions are available at the following link.

## 3. Service Provider Registration

We will enable service registration by adding the spring-cloud-starter-zookeeper-discovery dependency and using the annotation @EnableDiscoveryClient in the main application.

Below, we will show this process step by step for the service that returns the “Hello World !” in a response to GET requests.

### 3.1. Maven Dependencies

First, let’s add the required spring-cloud-starter-zookeeper-discovery, spring-web, spring-cloud-dependencies and spring-boot-starter dependencies to our pom.xml file:

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
    <version>1.5.2.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
    <artifactId>spring-web</artifactId>
        <version>4.3.7.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-zookeeper-discovery</artifactId>
        <version>1.0.3.RELEASE</version>
     </dependency>
</dependencies>
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>Brixton.SR7</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### 3.2. Service Provider Annotations

Next, we will annotate our main class with @EnableDiscoveryClient. This will make the HelloWorld application discovery-aware:

```java
@SpringBootApplication
@EnableDiscoveryClient
public class HelloWorldApplication {
    public static void main(String[] args) {
        SpringApplication.run(HelloWorldApplication.class, args);
    }
}
```
And a simple controller:
```java
@GetMapping("/helloworld")
public String helloWorld() {
    return "Hello World!";
}
```

### 3.3. YAML Configurations

Now let us create a YAML Application.yml file that will be used for configuring the application log level and informing Zookeeper that the application is discovery-enabled.

The name of the application with which gets registered to Zookeeper is the most important. Later in the service consumer, a feign client will use this name during the service discovery:

```yaml
spring:
  application:
    name: HelloWorld
  cloud:
    zookeeper:
      discovery:
        enabled: true
logging:
  level:
    org.apache.zookeeper.ClientCnxn: WARN
```

The spring boot application looks for zookeeper on default port 2181. If zookeeper is located somewhere else, the configuration needs to be added:

```yaml
spring:
  cloud:
    zookeeper:
      connect-string: localhost:2181
```
## 4. Service Consumer

Now we will create a REST service consumer and registered it using spring Netflix Feign Client.

### 4.1. Maven Dependency

First, let’s add the required spring-cloud-starter-zookeeper-discovery, spring-web, spring-cloud-dependencies, spring-boot-starter-actuator and spring-cloud-starter-feign dependencies to our pom.xml file:

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-zookeeper-discovery</artifactId>
        <version>1.0.3.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
        <version>1.5.2.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-feign</artifactId>
        <version>1.2.5.RELEASE</version>
    </dependency>
</dependencies>
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>Brixton.SR7</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```
### 4.2. Service Consumer Annotations

As with the service provider, we will annotate the main class with @EnableDiscoveryClient to make it discovery-aware:

```java
@SpringBootApplication
@EnableDiscoveryClient
public class GreetingApplication {
  
    public static void main(String[] args) {
        SpringApplication.run(GreetingApplication.class, args);
    }
}
```

### 4.3. Discover Service with Feign Client

We will use the Spring Cloud Feign Integration, a project by Netflix that lets you define a declarative REST Client. We declare how the URL looks like and feign takes care of connecting to the REST service.

The Feign Client is imported via the spring-cloud-starter-feign package. We will annotate a @Configuration with @EnableFeignClients to make use of it within the application.

Finally, we annotate an interface with @FeignClient(“service-name”) and auto-wire it into our application for us to access this service programmatically.

Here in the annotation @FeignClient(name = “HelloWorld”), we refer to the service-name of the service producer we previously created.

```java
@Configuration
@EnableFeignClients
@EnableDiscoveryClient
public class HelloWorldClient {
  
    @Autowired
    private TheClient theClient;
 
    @FeignClient(name = "HelloWorld")
    interface TheClient {
  
        @RequestMapping(path = "/helloworld", method = RequestMethod.GET)
        @ResponseBody
    String helloWorld();
    }
    public String HelloWorld() {
        return theClient.HelloWorld();
    }
}
```
### 4.4. Controller Class

The following is the simple service controller class that will call the service provider function on our feign client class to consume the service (whose details are abstracted through service discovery) via the injected interface helloWorldClient object and displays it in response:

```java
@RestController
public class GreetingController {
  
    @Autowired
    private HelloWorldClient helloWorldClient;
 
    @GetMapping("/get-greeting")
    public String greeting() {
        return helloWorldClient.helloWorld();
    }
}
```

### 4.5. YAML Configurations

Next, we create a YAML file Application.yml very similar to the one used before. That configures the application’s log level:

```yaml
logging:
  level:
    org.apache.zookeeper.ClientCnxn: WARN
```
The application looks for the Zookeeper on default port 2181. If Zookeeper is located somewhere else, the configuration needs to be added:


```yaml
spring:
  cloud:
    zookeeper:
      connect-string: localhost:2181
```
## 5. Testing the Setup

The HelloWorld REST service registers itself with Zookeeper on deployment. Then the Greeting service acting as the service consumer calls the HelloWorld service using the Feign client.

Now we can build and run these two services.

Finally, we’ll point our browser to http://localhost:8083/get-greeting, and it should display:

```
Hello World!
```
## 6. Conclusion

In this article, we have seen how to implement service discovery using Spring Cloud Zookeeper and we registered a service called HelloWorld within Zookeeper server to be discovered and consumed by the Greeting service using a Feign Client without knowing its location details.

As always, the code for this article is available on the GitHub.
https://github.com/eugenp/tutorials/tree/master/spring-cloud/spring-cloud-zookeeper

---
# Spring Cloud 中使用zookeeper作为服务注册中心与配置中心

前段时间，了解了通过spring-cloud-config-server与spring-cloud-eureka-server作为配置中心与注册中心，同时了解到基于zookeeper或consul可以完成同样的事情，所以必须了解一下，这样有利于实际工作的技术对比与选型。

## 1.安装zookeeper

解压
```
tar -xvf zookeeper-3.4.10.tar.gz
```
1
## 2.启动zookeeper

cd zookeeper-3.4.10
cd conf
cp zoo_sample.cfg zoo.cfg
cd ../bin
sh zkServer.sh start

## 3使用zookeeper作为服务注册中心

maven依赖
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zookeeper-discovery</artifactId>
</dependency>
```
```java
package com.garlic.springcloudzookeeperclientapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * zookeeper作为服务注册中心，应用启动类
 */
@SpringBootApplication
@EnableDiscoveryClient
public class SpringCloudZookeeperClientAppApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringCloudZookeeperClientAppApplication.class, args);
    }
}
```

application.properties

### 配置应用名称
spring.application.name=spring-cloud-zookeeper-client-app

### 配置服务端口
server.port=8080

### 关闭安全控制
management.security.enabled=false

### 配置zookeeper地址
spring.cloud.zookeeper.connect-string=localhost:2181

使用DiscoveryClient获取注册服务列表
```java
package com.garlic.springcloudzookeeperclientapp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

/**
 * 提供Rest Api，根据实例名称获取注册服务列表
 */
@RestController
@RequestMapping("/zookeeper")
public class ZookeeperController {

    @Value("${spring.application.name}")
    private String instanceName;

    private final DiscoveryClient discoveryClient;

    @Autowired
    public ZookeeperController(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
    }

    @GetMapping
    public String hello() {
        return "Hello,Zookeeper.";
    }

    @GetMapping("/services")
    public List<String> serviceUrl() {
        List<ServiceInstance> list = discoveryClient.getInstances(instanceName);
        List<String> services = new ArrayList<>();
        if (list != null && list.size() > 0 ) {
            list.forEach(serviceInstance -> {
                services.add(serviceInstance.getUri().toString());
            });
        }
        return services;
    }


}
```
注：可以启动不同的实例，此处我启动了端口8080与8081两个实例，然后使用端点可以查询到所注册的服务列表
同样可以通过zookeeper相关命令查询到说注册的服务列表
sh zkCli.sh

```
[services, zookeeper]
[zk: localhost:2181(CONNECTED) 1] ls /
[services, zookeeper]
[zk: localhost:2181(CONNECTED) 2] ls /services
[spring-cloud-zookeeper-client-app]
[zk: localhost:2181(CONNECTED) 3] ls /services/spring-cloud-zookeeper-client-app
[be61af3d-ffc2-4ffc-932c-26bc0f94971c, bcf21ece-e9e1-4a91-b985-8828688370b8]
[zk: localhost:2181(CONNECTED) 4]
```

### 使用zookeeper作为配置中心

### 使用zkCli创建配置信息
```
[zk: localhost:2181(CONNECTED) 27] create /config ""
Created /config
[zk: localhost:2181(CONNECTED) 28] create /config ""
Created /config/garlic
[zk: localhost:2181(CONNECTED) 29] create /config/garlic/name "default"
Created /config/garlic/name
[zk: localhost:2181(CONNECTED) 30] set /config/garlic-dev/name "dev"
Node does not exist: /config/garlic-dev/name
[zk: localhost:2181(CONNECTED) 31] create /config/garlic-dev/name "dev"
Created /config/garlic-dev/name
[zk: localhost:2181(CONNECTED) 32] create /config/garlic-test/name "test"
Created /config/garlic-test/name
[zk: localhost:2181(CONNECTED) 33] create /config/garlic-prod/name "prod"
```

maven依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zookeeper-config</artifactId>
</dependency>
```

bootstrap.properties

### 启用zookeeper作为配置中心
spring.cloud.zookeeper.config.enabled = true

### 配置根路径
spring.cloud.zookeeper.config.root = config

### 配置默认上下文
spring.cloud.zookeeper.config.defaultContext = garlic

### 配置profile分隔符
spring.cloud.zookeeper.config.profileSeparator = -


spring.cloud.zookeeper.config.root对应zkCli创建的config目录，defaultContext对应创建的garlic或garlic-*目录，根据profile来确定获取dev还是test或者prod配置
application.properties

### 配置应用名称
spring.application.name=spring-cloud-zookeeper-config-app

### 配置服务端口
server.port=10000

### 关闭安全控制
management.security.enabled=false

spring.profiles.active=dev

编写Controller来动态获取zookeeper配置中心的数据
```java
package com.garlic.springcloudzookeeperconfigapp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 提供Rest Api，获取配置在zookeeper中的配置信息
 */
@RestController
@RequestMapping("/zookeeper")
@RefreshScope // 必须添加，否则不会自动刷新name的值
public class ZookeeperController {

    @Autowired
    private Environment environment;

    @Value("${name}")
    private String name;

    @GetMapping
    public String hello() {
        return "Hello, " + name;
    }

    @GetMapping("/env")
    public String test() {
        String name = environment.getProperty("name");
        System.out.println(name);
        return "Hello," + name;
    }

}
```
启动配置实例之后，可以通过zkCli修改garlic下name的值，然后通过访问端点来查看值是否变化
至此，使用zookeeper作为服务注册中心与配置中心就完成了，我们可以通过使用zookeeper作为配置中心，然后使用zuul作为API网关，配置动态路由，为服务提供者，配置数据库连接相关信息。

---

## Eureka与ZooKeeper 的比较

### Eureka的优势

1、在Eureka平台中，如果某台服务器宕机，Eureka不会有类似于ZooKeeper的选举leader的过程；客户端请求会自动切换到新的Eureka节点；当宕机的服务器重新恢复后，Eureka会再次将其纳入到服务器集群管理之中；而对于它来说，所有要做的无非是同步一些新的服务注册信息而已。所以，再也不用担心有“掉队”的服务器恢复以后，会从Eureka服务器集群中剔除出去的风险了。Eureka甚至被设计用来应付范围更广的网络分割故障，并实现“0”宕机维护需求。（多个zookeeper之间网络出现问题,造成出现多个leader，发生脑裂）当网络分割故障发生时，每个Eureka节点，会持续的对外提供服务（注：ZooKeeper不会）：接收新的服务注册同时将它们提供给下游的服务发现请求。这样一来，就可以实现在同一个子网中（same side of partition），新发布的服务仍然可以被发现与访问。
2、正常配置下，Eureka内置了心跳服务，用于淘汰一些“濒死”的服务器；如果在Eureka中注册的服务，它的“心跳”变得迟缓时，Eureka会将其整个剔除出管理范围（这点有点像ZooKeeper的做法）。这是个很好的功能，但是当网络分割故障发生时，这也是非常危险的；因为，那些因为网络问题（注：心跳慢被剔除了）而被剔除出去的服务器本身是很”健康“的，只是因为网络分割故障把Eureka集群分割成了独立的子网而不能互访而已。
幸运的是，Netflix考虑到了这个缺陷。如果Eureka服务节点在短时间里丢失了大量的心跳连接（注：可能发生了网络故障），那么这个Eureka节点会进入”自我保护模式“，同时保留那些“心跳死亡“的服务注册信息不过期。此时，这个Eureka节点对于新的服务还能提供注册服务，对于”死亡“的仍然保留，以防还有客户端向其发起请求。当网络故障恢复后，这个Eureka节点会退出”自我保护模式“。所以Eureka的哲学是，同时保留”好数据“与”坏数据“总比丢掉任何”好数据“要更好，所以这种模式在实践中非常有效。
3、Eureka还有客户端缓存功能（注：Eureka分为客户端程序与服务器端程序两个部分，客户端程序负责向外提供注册与发现服务接口）。所以即便Eureka集群中所有节点都失效，或者发生网络分割故障导致客户端不能访问任何一台Eureka服务器；Eureka服务的消费者仍然可以通过Eureka客户端缓存来获取现有的服务注册信息。甚至最极端的环境下，所有正常的Eureka节点都不对请求产生相应，也没有更好的服务器解决方案来解决这种问题
时；得益于Eureka的客户端缓存技术，消费者服务仍然可以通过Eureka客户端查询与获取注册服务信息，这点很重要。
4、Eureka的构架保证了它能够成为Service发现服务。它相对与ZooKeeper来说剔除了Leader节点的选取或者事务日志机制，这样做有利于减少使用者维护的难度也保证了Eureka的在运行时的健壮性。而且Eureka就是为发现服务所设计的，它有独立的客户端程序库，同时提供心跳服务、服务健康监测、自动发布服务与自动刷新缓存的功能。但是，如果使用ZooKeeper你必须自己来实现这些功能。Eureka的所有库都是开源的，所有人都能看到与使用这些源代码，这比那些只有一两个人能看或者维护的客户端库要好。
5、维护Eureka服务器也非常的简单，比如，切换一个节点只需要在现有EIP下移除一个现有的节点然后添加一个新的就行。Eureka提供了一个web-based的图形化的运维界面，在这个界面中可以查看Eureka所管理的注册服务的运行状态信息：是否健康，运行日志等。Eureka甚至提供了Restful-API接口，方便第三方程序集成Eureka的功能。

###ZooKeeper的劣势

   在分布式系统领域有个著名的CAP定理（C-数据一致性；A-服务可用性；P-服务对网络分区故障的容错性，这三个特性在任何分布式系统中不能同时满足，最多同时满足两个）；ZooKeeper是个CP的，即任何时刻对ZooKeeper的访问请求能得到一致的数据结果，同时系统对网络分割具备容错性；但是它不能保证每次服务请求的可用性（注：也就是在极端环境下，ZooKeeper可能会丢弃一些请求，消费者程序需要重新请求才能获得结果）。但是别忘了，ZooKeeper是分布式协调服务，它的职责是保证数据（注：配置数据，状态数据）在其管辖下的所有服务之间保持同步、一致；所以就不难理解为什么ZooKeeper被设计成CP而不是AP特性的了，如果是AP的，那么将会带来恐怖的后果（注：ZooKeeper就像交叉路口的信号灯一样，你能想象在交通要道突然信号灯失灵的情况吗？）。而且，作为ZooKeeper的核心实现算法Zab，就是解决了分布式系统下数据如何在多个服务之间保持同步问题的。

1、对于Service发现服务来说就算是返回了包含不实的信息的结果也比什么都不返回要好；再者，对于Service发现服务而言，宁可返回某服务5分钟之前在哪几个服务器上可用的信息，也不能因为暂时的网络故障而找不到可用的服务器，而不返回任何结果。所以说，用ZooKeeper来做Service发现服务是肯定错误的，如果你这么用就惨了！
   如果被用作Service发现服务，ZooKeeper本身并没有正确的处理网络分割的问题；而在云端，网络分割问题跟其他类型的故障一样的确会发生；所以最好提前对这个问题做好100%的准备。就像Jepsen在ZooKeeper网站上发布的博客中所说：在ZooKeeper中，如果在同一个网络分区（partition）的节点数（nodes）数达不到ZooKeeper选取Leader节点的“法定人数”时，它们就会从ZooKeeper中断开，当然同时也就不能提供Service发现服务了。

2、ZooKeeper下所有节点不可能保证任何时候都能缓存所有的服务注册信息。如果ZooKeeper下所有节点都断开了，或者集群中出现了网络分割的故障（注：由于交换机故障导致交换机底下的子网间不能互访）；那么ZooKeeper会将它们都从自己管理范围中剔除出去，外界就不能访问到这些节点了，即便这些节点本身是“健康”的，可以正常提供服务的；所以导致到达这些节点的服务请求被丢失了。（注：这也是为什么ZooKeeper不满足CAP中A的原因）

3、更深层次的原因是，ZooKeeper是按照CP原则构建的，也就是说它能保证每个节点的数据保持一致，而为ZooKeeper加上缓存的做法的目的是为了让ZooKeeper变得更加可靠（available）；但是，ZooKeeper设计的本意是保持节点的数据一致，也就是CP。所以，这样一来，你可能既得不到一个数据一致的（CP）也得不到一个高可用的（AP）的Service发现服务了；因为，这相当于你在一个已有的CP系统上强制栓了一个AP的系统，这在本质上就行不通的！一个Service发现服务应该从一开始就被设计成高可用的才行！

4、如果抛开CAP原理不管，正确的设置与维护ZooKeeper服务就非常的困难；错误会经常发生，导致很多工程被建立只是为了减轻维护ZooKeeper的难度。这些错误不仅存在与客户端而且还存在于ZooKeeper服务器本身。Knewton平台很多故障就是由于ZooKeeper使用不当而导致的。那些看似简单的操作，如：正确的重建观察者（reestablishing watcher）、客户端Session与异常的处理与在ZK窗口中管理内存都是非常容易导致ZooKeeper出错的。同时，我们确实也遇到过ZooKeeper的一些经典bug：ZooKeeper-1159 与ZooKeeper-1576；我们甚至在生产环境中遇到过ZooKeeper选举Leader节点失败的情况。这些问题之所以会出现，在于ZooKeeper需要管理与保障所管辖服务群的Session与网络连接资源（注：这些资源的管理在分布式系统环境下是极其困难的）；但是它不负责管理服务的发现，所以使用ZooKeeper当Service发现服务得不偿失。

一个集群有3台机器，挂了一台后的影响是什么？挂了两台呢？ 
挂了一台：挂了一台后就是收不到其中一台的投票，但是有两台可以参与投票，按照上面的逻辑，它们开始都投给自己，后来按照选举的原则，两个人都投票给其中一个，那么就有一个节点获得的票等于2，2 > (3/2)=1 的，超过了半数，这个时候是能选出leader的。
挂了两台： 挂了两台后，怎么弄也只能获得一张票， 1 不大于 (3/2)=1的，这样就无法选出一个leader了。

ZAB（ZooKeeper Atomic Broadcast ） 全称为：原子消息广播协议；ZAB可以说是在Paxos算法基础上进行了扩展改造而来的，ZAB协议设计了支持崩溃恢复，ZooKeeper使用单一主进程Leader用于处理客户端所有事务请求，采用ZAB协议将服务器数状态以事务形式广播到所有Follower上；由于事务间可能存在着依赖关系，ZAB协议保证Leader广播的变更序列被顺序的处理，：一个状态被处理那么它所依赖的状态也已经提前被处理；ZAB协议支持的崩溃恢复可以保证在Leader进程崩溃的时候可以重新选出Leader并且保证数据的完整性；

过半数（>=N/2+1） 的Follower反馈信息后，Leader将再次向集群内Follower广播Commit信息，Commit为将之前的Proposal提交；

