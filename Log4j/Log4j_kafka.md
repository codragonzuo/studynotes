## Log4j日志写入Kafka（实战）

https://blog.csdn.net/BCDMW233/article/details/93747986

1.引入依赖-pom
这里为了避免包冲突，过滤掉了log4j12

```xml
 <dependency>
     <groupId>org.apache.kafka</groupId>
     <artifactId>kafka_2.10</artifactId>
     <version>0.8.2.2</version>
     <exclusions>
    <exclusion>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-log4j12</artifactId>
    </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>kafka-log4j-appender</artifactId>
    <version>0.10.2.1</version>
</dependency>
```

2.编写log4j.properties
```
log4j.rootLogger=INFO,console,KAFKA
## appender KAFKA
log4j.appender.KAFKA=kafka.producer.KafkaLog4jAppender
log4j.appender.KAFKA.topic=topic ## topic名字
log4j.appender.KAFKA.brokerList=127.0.0.1:9092 ##设置kafka

log4j.appender.KAFKA.compressionType=none
log4j.appender.KAFKA.syncSend=true
log4j.appender.KAFKA.layout=org.apache.log4j.PatternLayout
log4j.appender.KAFKA.ThresholdFilter.level=ERROR ##设置需要发送的日志级别
log4j.appender.KAFKA.ThresholdFilter.onMatch=ACCEPT
log4j.appender.KAFKA.ThresholdFilter.onMismatch=DENY

log4j.appender.KAFKA.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L %% - %m%n

## appender console
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.target=System.out
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=%d (%t) [%p - %l] %m%n
```


3.编写测试类
```java
import org.apache.log4j.Logger;

/**
 * 模拟日志产生
 */
public class KafkaLog4jApp {

   private static Logger logger = Logger.getLogger(KafkaLog4jApp.class.getName());

   public static void main(String[] args) throws Exception {
      int index = 0;

      while(true) {
         Thread.sleep(1000);
         logger.info("value is: " + index++);
      }
   }
}
```
4. 测试结果

PS:这里不再阐述如何安装和使用kafka，但是这里写点坑吧

如何在docker容器内操作查看topic

查看topic里面的消息内容

docker exec kafka kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic topicname --from-beginning

查看topic列表

docker exec kafka kafka-topics.sh --list --zookeeper localhost:2181

原文链接：https://blog.csdn.net/BCDMW233/article/details/93747986

