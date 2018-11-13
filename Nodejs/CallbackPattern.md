# Callback Pattern

Callbacks are the materialization of the handlers of the reactor pattern and they are 
literally one of those imprints that give Node.js its distinctive programming style. 
Callbacks are functions that are  are invoked to propagate the result of an operation 
and this is exactly what we need when dealing with asynchronous operations. 
They practically replace the use of the return instruction that,  as we know, always 
executes synchronously. JavaScript is a great language to represent callbacks, 
because as we know, functions are first class objects and can be easily assigned to 
variables, passed as arguments, returned from another function invocation, or stored 
into data structures. Also, closures are an ideal construct for implementing callbacks. 

With closures, we can in fact reference the environment in which a function was 
created, practically, we can always maintain the context in which the asynchronous 
operation was requested, no matter where its callback is invoked.

![](https://www.tutorialspoint.com/nodejs/images/event_loop.jpg)

Node.js uses events heavily and it is also one of the reasons why Node.js is pretty fast compared to other similar technologies. As soon as Node starts its server, it simply initiates its variables, declares functions and then simply waits for the event to occur.

In an event-driven application, there is generally a main loop that listens for events, and then triggers a callback function when one of those events is detected.

##Event Loop

Although events look quite similar to callbacks, the difference lies in the fact that callback functions are called 
when an asynchronous function returns its result, whereas event handling works on the observer pattern. The functions 
that listen to events act as Observers. Whenever an event gets fired, its listener function starts executing.

Node.js has multiple in-built events available through events module and EventEmitter class 
which are used to bind events and event-listeners as follows −
