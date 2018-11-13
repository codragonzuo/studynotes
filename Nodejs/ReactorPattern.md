# Reactor Pattern

 In a reactor pattern based application for each offered service, a separate request handler is introduced that processes these types of requests. Incoming requests are registered and queued for processing.
 
 The task of demultiplexing and dispatching is typically done in a so-called event loop. The event loop runs in a single thread and will await events to occur that signal when the underlying resources are ready to be consumed without a blocking call. These events are for example, when a network connection is available or a file is ready for reading from a disk or network. In such a case, the event loop will dispatch the event to the associated request handler to invoke the right method. As a result, the whole operation of that request is executed in an asynchronous non-blocking way.
 
 Summing up, the benefit of the reactor pattern is to avoid the creation of a thread for each request that needs to be handled.
 
 ## Event Loop
In computer science, the event loop, message dispatcher, message loop, message pump, or run loop is a programming construct that waits for and dispatches events or messages in a program.

It works by making a request to some internal or external "event provider" (that generally blocks the request until an event has arrived), and then it calls the relevant event handler ("dispatches the event").

The event-loop may be used in conjunction with a reactor, if the event provider follows the file interface, which can be selected or 'polled' (the Unix system call, not actual polling).

The event loop almost always operates asynchronously with the message originator.

![](https://camo.githubusercontent.com/8765d358da0dcfff20ab1765c160147ece065580/687474703a2f2f626572622e6769746875622e696f2f6469706c6f6d612d7468657369732f6f726967696e616c2f7265736f75726365732f65762d7365727665722e737667)
 
 ---
 ![](https://camo.githubusercontent.com/c28263fd7266502977baa3f5712a72970977ccb1/687474703a2f2f6d69636861656c6b7574792e6769746875622e696f2f76657274782d6764672f696d672f6576656e746c6f6f702e706e67)
 
 ---
 ![](https://camo.githubusercontent.com/244696806d1dc0dfd452e26be2162bf70efe8d7d/68747470733a2f2f736f667477617265656e67696e656572696e676461696c792e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031352f30372f6576656e742d6c6f6f702e6a7067)
 
 ---
 ![](https://camo.githubusercontent.com/c52b058fddead54a1557e71a1a97852b3bdd1c76/68747470733a2f2f7363722e7361642e737570696e666f2e636f6d2f61727469636c65732f7265736f75726365732f3136343836322f323230342f312e706e67)
 ---


## 

https://medium.com/@vishalkalaskar/we-must-have-come-across-the-terms-callbacks-non-blocking-i-o-and-event-looping-while-927a5e2150c0

[Event Loop in NodeJS: How It Works!](https://medium.com/@vishalkalaskar/we-must-have-come-across-the-terms-callbacks-non-blocking-i-o-and-event-looping-while-927a5e2150c0)

---
## Programming inception (or understanding Node.js event loop)

https://tiagodev.wordpress.com/2014/07/19/programming-inception-or-understanding-node-js-event-loop-2/

[understanding Node.js event loop](https://tiagodev.wordpress.com/2014/07/19/programming-inception-or-understanding-node-js-event-loop-2/)

![](https://cdn-images-1.medium.com/max/800/1*X0m82lpBhRONFvRGCRu84w.jpeg)



![](https://tiagodev.files.wordpress.com/2014/07/node_loop.png)
