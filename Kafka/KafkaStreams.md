# KafkaStreams

Kafka Streams只是一个java库，但是它可以解决如下类似问题：
```
一次一件事件的处理而不是微批处理，延迟在毫秒级别；
有状态的处理，包括连接操作（join）和聚合操作
提供了必要的流处理原语，包括高级流处理DSL和低级流处理API。高级流处理DSL提供了常用的流处理变换操作，低级处理器API支持客户端自定义处理器并与状态仓库（state store）交互；
使用类似于DataFlow的模型来处理乱序数据的事件窗口问题；
分布式处理，有容错机制，可以快速容错；
有重新处理数据的能力；
```


http://kafka.apache.org/documentation/streams/




https://medium.com/@andy.bryant/kafka-streams-work-allocation-4f31c24753cc

![](https://miro.medium.com/max/794/1*ldI6YPKtQOjW4HpWqfltog.png)
