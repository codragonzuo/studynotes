

https://github.com/LMAX-Exchange/disruptor/wiki/Introduction

LMAX Disruptor简介


LMAX是什么？

要说Disruptor需要先说下LMAX,LMAX是一个英国外汇黄金交易所，它是第一家也是唯一一家采用多边交易设施Multilateral Trading Facility(MTF)，拥有交易所拍照和经纪商拍照的欧洲顶级金融公司。而LMAX所用的Disruptor技术，在一个线程每秒处理6百万订单。没错，这个Disruptor就是我们这里的
Disruptor。

而Disruptor只是LMAX平台一部分，LMAX是一个新型零售金融交易平台，它能够达到低延迟、高吞吐量(大量交易)。这个系统建立在JVM平台上，核心是一个逻辑处理器，每秒能够处理600百万订单。业务逻辑处理器完全运行在内存中(in-memory)，使用事件源驱动方式(event sourcing)。而业务逻辑处理器核心是Disruptor，这是一个并发组件，能够在无锁情况下实现网络并发查询操作。他们研究表明，现在所谓的高性能研究方向似乎和现在CPU设计是相左的。

什么是Disruptor

Disruptor

Disruptor实现了队列的功能，而且是一个有界的队列。所以应用场景自然就是"生产者-消费者"模型了。可以看下JDK中的BlockingQuery是一个FIFO队列，生产者(Producer)发布(Publish)一项事件(Event，消息)时，消费者(Consumer)能够获得通知；当队列中没有事件时，消费者会被阻塞，直到生产者发布了新的事件。而Disruptor不仅仅只是这些：

同一个事件可以有多个消费者，消费者之间可以并行处理，可以相互依赖处理

预分配用于存储事件的内存

针对极高的性能目标而实现极度优化和无锁设计

可能你对这种场景还不是很明白，简单说就是当需要两个独立的处理过程(两个线程)之间需要传递数据时，就可以使用Disruptor，当然可以使用队列。

https://www.jianshu.com/p/a44b779c22cb

