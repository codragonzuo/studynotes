
- reactive programs

  ■ Are available to continuously interact with their environment

  ■ Run at a speed that is dictated by the environment, not the program itself

  ■ Work in response to external demand

- reactive applications

  ■ Responsive—React to users
  
  ■ Scalable—React to load
  
  ■ Resilient—React to failure
  
  ■ Event-driven—React to events
  
- Front-end tech

- Back-end tech

A new initiative called Reactive Streams, which we’ll talk more about in chapter 9, aims at providing a standard interface for working with ** asynchronous stream processing on the JVM **.  

 Microsoft’s Reactive Extensions (Rx; https://rx.codeplex.com/) is a library for composing asynchronous and event-based programs, available on the .NET platform and other platforms such as JavaScript. 
 
 Node.js (http://nodejs.org) is a popular platform for building asynchronous, event-driven applications in JavaScript. 
 
 On the JVM, a number of libraries enable these capabilities, such as Apache MINA (https://mina.apache.org) and Netty (http://netty.io). 
 
### Threaded Model or Evented Model
In the threaded model, large numbers of threads take care of handling the incoming requests. In an evented model, a small number of request-processing threads communicate with each other through message passing. Reactive web application servers adopt the evented model.

![](https://img-blog.csdn.net/20180310175020585)

![](https://img-blog.csdn.net/20180310175020863)

[https://img-blog.csdn.net/20180310175020863](https://img-blog.csdn.net/20180310175020863)



### MEMORY UTILIZATION IN THREADED AND EVENTED WEB SERVERS
Evented web servers make much better use of hardware resources than threaded ones. Instead of having to spawn thousands or tens of thousands of “train track” worker threads to deal with large numbers of incoming requests, only a few “waiter”
threads are necessary. There are two advantages to working with a smaller number of threads: reduced memory footprint and much improved performance due to reduced context switching, thread management time, and scheduling overhead.

Each thread created on the JVM has its own stack space, which is by default 1 MB.
The default thread pool size of Apache Tomcat is 200, which means that Apache Tomcat needs to be assigned over 200 MB of memory in order to start. 

In contrast, you can run a simple Play application with 16 MB of memory. And although 200 MB may not seem like a lot of memory these days, let’s not forget that this means that 200 MB are required to process 200 incoming HTTP requests at the same time, without taking into account the memory necessary to perform additional tasks involved in handling these requests. 

If you wanted to cater to 10,000 requests at the same time, you’d need a lot of memory, which may not always be readily available. The threaded model has difficulty scaling up to a larger number of concurrent users because of its demands on
available memory.

In addition to utilizing a lot of memory, the threaded approach results in inefficient use of the CPU.


## many-core CPU


 The new many-core architecture that CPU vendors have moved toward doesn’t make locks look any better. If a CPU offers over 1,000 real threads of execution, but the application relies on locks to synchronize access to a few regions in memory, one
can only imagine how much performance loss this mechanism will entail. There is a clear need for a programming model that better suits the multithread and multicore paradigm.

## RxJava

RxJava is a Reactive Extensions implementation for Java environment.

The library utilizes a combination of functional and reactive techniques that can represent an elegant approach to event-driven programming – with values that change over time and where the consumer reacts to the data as it comes in.

- Functional Reactive Concepts
On one side, functional programming is the process of building software by composing pure functions, avoiding shared state, mutable data, and side-effects.

On the other side, reactive programming is an asynchronous programming paradigm concerned with data streams and the propagation of change.

Together, functional reactive programming forms a combination of functional and reactive techniques that can represent an elegant approach to event-driven programming – with values that change over time and where the consumer reacts to the data as it comes in.

This technology brings together different implementations of its core principles, some authors came up with a document that defines the common vocabulary for describing the new type of applications.

### Observables
There are two key types to understand when working with Rx:

Observable represents any object that can get data from a data source and whose state may be of interest in a way that other objects may register an interest

An observer is any object that wishes to be notified when the state of another object changes

An observer subscribes to an Observable sequence. The sequence sends items to the observer one at a time.

The observer handles each one before processing the next one. If many events come in asynchronously, they must be stored in a queue or dropped.

In Rx, an observer will never be called with an item out of order or called before the callback has returned for the previous item.


![](http://reactivex.io/assets/operators/legend.png)

In ReactiveX an observer subscribes to an Observable. Then that observer reacts to whatever item or sequence of items the Observable emits. This pattern facilitates concurrent operations because it does not need to block while waiting for the Observable to emit objects, but instead it creates a sentry in the form of an observer that stands ready to react appropriately at whatever future time the Observable does so.

---


https://www.journaldev.com/19300/rxjava-flatmap-switchmap-concatmap



响应式编程（reactive programming）是一种基于数据流（data stream）和变化传递（propagation of change）的声明式（declarative）的编程范式。

ractive的编程方式，不一定能提升程序性能，但是它希望做到的是用少量线程和内存提升伸缩性，及时响应新请求。

响应式编程是一种通过异步和数据流来构建事务关系的编程模型。这里每个词都很重要，“事务的关系”是响应式编程的核心理念，“数据流”和“异步”是实现这个核心理念的关键。


