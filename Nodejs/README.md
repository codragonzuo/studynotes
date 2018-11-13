
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

## Future of NodeJs

## APRIL 30, 2018  What is the Future of Node.js?

https://www.digitalaptech.com/what-is-the-future-of-node-js

With new technologies invading the IT industry, there has been an increase in the number of start-ups that are trying their ways with the latest innovations. And a new addition to it is Node.js. This cutting-edge technology has not only managed to pull the start-ups but also has succeeded in carving its niche in the giant companies. Basically, whenever there is a new addition in technology, the IT market goes gaga over it for the first few months and then forgets it. But the case is not the same with Node.js. It is actually a game changer and stands tall among its competitors.

Before we move forward, let’s give an introduction to Node.js. A software platform built on Google’s V8 JavaScript engine, Node.js uses an event-driven, non-blocking I/O model. Apart from being extremely efficient, it is lightweight. The largest ecosystem of open source libraries is offered by the package ecosystem of Node.js, (Node Package Manager) NPM. This is what contributes to its becoming a go-to technology for a number of companies. PayPal, Groupon, Uber, Netflix, Trello and LinkedIn are to name a few.

Here’s why you should use Node.js:
1. Present everywhere
It is because of Node.js that the JavaScript is now present both in the browser and the server. Node.js is flexible to use and it runs in the same way in the browser that is runs in the server. This is no doubt great!

2. Fast
Love speed? Use Node.js. Companies are in love with the speed at which Node.js functions. Google has developed V8 engine on which it runs and operates at an awesome speed. It uses a single thread and avoids all the problems that are related to forming separate threads. All the major actions in web applications such as reading or writing to the database and file system or network connections can be performed fast with it.

3. Real-time web applications
Are you worried about protocols and low-level sockets? Well, here’s the solution! Build real-time web applications with Node.js at a great speed and the time that is required to make it is similar to the time that is needed to make a simple blog in PHP. Aren’t you in love with Node.js already?

Some other reasons to go for Node.js web development include –

Dynamic Node Package Manager (NPM)
Easy to code
Asynchronous I/O
Solves the queries related database
Increases productivity
Community-driven
Works great with sync issues
So, what is the future of Node.js?
Node.js has turned into something that the community calls a “digital transformation framework”. It helps users to do everything from building microservices, handling the delivery of mobile application and integrating non-web systems to tapping into serverless frameworks and providing a foundation for the Internet of Things (IoT) as a platform.

Talking about the future of Node.js, it can be said that it is well-positioned in order to continue its growth in fuelling the serverless programming and as-a-service paradigm. It can be predicted that these are the two areas where we can see that there is a possibility of the Node community to grow because of its importance to those areas.

Some say that the users can expect to see a bigger variety of solutions in IoT as well as other types of instrumentation. A great deal of utility and flexibility is offered by Node.js, making it perfect for a number of different use cases.

In terms of dev community as well as user acceptance, Node.js will continue its impressive growth, but of course, users will ask for more focus on faster starting time, better utilization in CPU and memory and greater security.

Continued reliability and increased stability of Node.js will extend its surface area in the cloud as well as as-a-service offerings. It can be predicted that Node.js would benefit from enhanced and improved debugging tooling.

