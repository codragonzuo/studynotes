
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
