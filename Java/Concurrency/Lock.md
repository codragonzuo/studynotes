
# Locking Framework

- Lock
- Reentrant Lock
- Condition
- ReadWriteLock
- ReentrantReadWriteLock

https://www.baeldung.com/java-concurrent-locks

https://www.journaldev.com/2377/java-lock-example-reentrantlock

The java.util.concurrent.locks package provides a framework of interfaces and classes for locking and waiting for conditions in a manner that’s distinct from an object’s intrinsic lock-based synchronization and java.lang.Object’s wait/notification mechanism. The concurrency utilities include the Locking Framework that improves on  intrinsic synchronization and wait/notification by offering lock polling, timed waits, and more.

![](https://img-blog.csdn.net/2018041221082635)


Some important interfaces and classes in Java Lock API are:

- Lock: 
This is the base interface for Lock API. It provides all the features of synchronized keyword with additional ways to create different Conditions for locking, providing timeout for thread to wait for lock. Some of the important methods are lock() to acquire the lock, unlock() to release the lock, tryLock() to wait for lock for a certain period of time, newCondition() to create the Condition etc.
- Condition: 
Condition objects are similar to Object wait-notify model with additional feature to create different sets of wait. A Condition object is always created by Lock object. Some of the important methods are await() that is similar to wait() and signal(), signalAll() that is similar to notify() and notifyAll() methods.
- ReadWriteLock: 
It contains a pair of associated locks, one for read-only operations and another one for writing. The read lock may be held simultaneously by multiple reader threads as long as there are no writer threads. The write lock is exclusive.
- ReentrantLock: 
This is the most widely used implementation class of Lock interface. This class implements the Lock interface in similar way as synchronized keyword. Apart from Lock interface implementation, ReentrantLock contains some utility methods to get the thread holding the lock, threads waiting to acquire the lock etc.

synchronized block are reentrant in nature i.e if a thread has lock on the monitor object and if another synchronized block requires to have the lock on the same monitor object then thread can enter that code block. I think this is the reason for the class name to be ReentrantLock. Let’s understand this feature with a simple example.
