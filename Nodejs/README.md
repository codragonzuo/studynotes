
# <center>Node.JS</center>

##Asynchronous Programming
Asynchronous  programming is  one of the best and most confusing features of Node.js.

Asynchronous programming means that for every asynchronous function that you execute, you can’t expect it to return the results before moving forward with the program’s flow

![](https://camo.githubusercontent.com/87a6cdbb3801eb4d1a5a712a70739da0fea31844/68747470733a2f2f692e696d6775722e636f6d2f6f7579504b6b662e706e67)

As shown Node.js uses one thread for handling requests and many threads (actually, not true threads) to provide asynchronous non-blocking IO (e.g., to the database or to other REST server). Fewer threads means fewer memory for stack allocation and more economic usage of the CPU.

---
![](https://camo.githubusercontent.com/c698dff4f9e75a944a7bcbce1a9117a8ea5b4b67/68747470733a2f2f696d6775722e636f6d2f43314c5156587a2e706e67)

The diagram above shows multi threaded server that may be found, e.g., in Java. In this model the server spawns new thread for handling each request which sleeps on blocking IO operations consuming CPU and memory resources.

## High concurrency matters
But there’s one thing we can all agree on: At high levels of concurrency (thousands of connections) your server needs to go to asynchronous non-blocking. I would have finished that sentence with IO, but the issue is that if any part of your server code blocks you’re going to need a thread. And at these levels of concurrency, you can’t go creating threads for every connection. So the whole codepath needs to be non-blocking and async, not just the IO layer. This is where Node excels.

While Java or Node or something else may win a benchmark, no server has the non-blocking ecosystem of Node.js today. Over 50k modules all written in the async style, ready to use. Countless code examples strewn about the web. Lessons and tutorials all using the async style. Debuggers, monitors, loggers, cluster managers, test frameworks and more all expecting your code to be non-blocking async.

Until Java or another language ecosystem gets to this level of support for the async pattern (a level we got to in Node because of async JavaScript in the browser), it won’t matter whether raw NIO performance is better than Node or any other benchmark result: Projects that need big concurrency will choose Node (and put up with its warts) because it’s the best way to get their project done.


https://strongloop.com/strongblog/node-js-is-faster-than-java/

