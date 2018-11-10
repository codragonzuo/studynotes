
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

