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

https://www.tutorialspoint.com/nodejs/nodejs_event_loop.htm

Although events look quite similar to callbacks, the difference lies in the fact that callback functions are called 
when an asynchronous function returns its result, whereas event handling works on the observer pattern. The functions 
that listen to events act as Observers. Whenever an event gets fired, its listener function starts executing.

Node.js has multiple in-built events available through events module and EventEmitter class 
which are used to bind events and event-listeners as follows −


![](http://1.bp.blogspot.com/-XahRlUVK2vo/VVHRoY_mGGI/AAAAAAAAAQU/FBqvjWJPfWk/s1600/node_way.jpg)


## Asynchronous continuation-passing style

Asynchronous continuation-passing style
Now, let's consider the case where the add() function is asynchronous, which is  
as follows:
```java
function addAsync(a, b, callback) {
  setTimeout(function() {
    callback(a + b);
  }, 100);
}
```
In the previous code, we simply use setTimeout() to simulate an asynchronous 
invocation of the callback. Now, let's try to use this function and see how the order  
of the operations changes:
```js
console.log('before');
addAsync(1, 2, function(result) {
  console.log('Result: ' + result);
});
console.log('after');
```
The preceding code will print the following:
```
before
after
Result: 3
```
Since setTimeout() triggers an asynchronous operation, it will not wait anymore 
for the callback to be executed, but instead, it returns immediately giving the control 
back to addAsync(), and then back to its caller. This property in Node.js is crucial, 
as it allows the stack to unwind, and the control to be given back to the event loop as 
soon as an asynchronous request is sent, thus allowing a new event from the queue 
to be processed. 

When the asynchronous operation completes, the execution is then resumed  
starting from the callback provided to the asynchronous function that caused the 
unwinding. The execution will start from the Event Loop, so it will have a fresh stack. 
This is where JavaScript comes in really handy, in fact, thanks to closures it is trivial to 
maintain the context of the caller of the asynchronous function, even if the callback is 
invoked at a different point in time and from a different location.

##
http://www.juhonkoti.net/2015/12/01/problems-with-node-js-event-loop


https://blog.carbonfive.com/2013/10/27/the-javascript-event-loop-explained/

![](https://blog.carbonfive.com/wp-content/uploads/2013/10/web-workers.png)



## Problems With Node.JS Event Loop

http://www.juhonkoti.net/2015/12/01/problems-with-node-js-event-loop

![](http://www.juhonkoti.net/wp-content/uploads/2015/12/ad7e7a46bf5b9fbacec609c360dd1c09.png)

Conclusion
Node.JS is not an optimal platform to do complex request processing where different requests might contain different amount of data, especially if we want to guarantee some kind of Service Level Agreement (SLA) that the service must be fast enough. A lot of care must be taken so that a single asynchronous callback can’t do processing for too long and it might be viable to explore other languages which are not completely single threaded.


---

```js
var	Domain	=	require(	'domain'	),				domain;
domain	=	Domain.create(	);
domain.on(	'error',	function(	error	)	{
				console.log(	'Domain	error',	error.message	);
});
domain.run(	function(	)	{
				//	Run	code	inside	domain
				console.log(	process.domain	===	domain	);
				throw	new	Error(	'Error	happened'	);	
});
```

'''shell
[~/examples/example-14]$	node	index.js
true
Domain	error	Error	happened
```

---

```
process.nextTick(	function(	)	{
				domain.run(	function(	)	{
								throw	new	Error(	'Error	happened'	);
				});
				console.log(	"I	won't	execute"	);
});	
process.nextTick(	function(	)	{
				console.log(	'Next	tick	happend!'	);
});
console.log(	'I	happened	before	everything	else'	);
```

```shell
[~/examples/example-15]$	node	index.js
I	happened	before	everything	else
Domain	error	Error	happened
Next	tick	happend!
```
