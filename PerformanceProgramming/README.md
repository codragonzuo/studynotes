
# Efficient C++ Performance Programming Techniques 
![](https://images-na.ssl-images-amazon.com/images/I/41Y6FJPBQSL._SX378_BO1,204,203,200_.jpg)

- software performance
   -  Design efficiency
       - Algorithms and data structures
       - Program decomposition
   -  Coding efficiency
       - Language constructs
       - System architecture
       - Libraries
       - Compiler optimizations
   
Programmers may have different views on C++ performance depending on their respective experiences. 
But there are a few basic principles that we all agree on: 

 - I/O is expensive. 
 - Function call overhead is a factor so we should inline short, frequently called functions. 
 - Copying objects is expensive. Prefer pass-by-reference over pass-by-value. 

### KeyPoint
 - Object definitions trigger silent execution in the form of object constructors and destructors. We call it "silent execution" as opposed to "silent overhead" because object construction and destruction are not usually overhead. If the computations performed by the constructor and destructor are always necessary, then they would be considered efficient code (inlining would alleviate the cost of call and return overhead). As we have seen, constructors and destructors do not always have such "pure" characteristics, and they can create significant overhead. In some situations, computations performed by the constructor (and/or destructor) are left unused. We should also point out that this is more of a design issue than a C++ language issue. However, it is seen less often in C because it lacks constructor and destructor support. 
 - Just because we pass an object by reference does not guarantee good performance. Avoiding object copy helps, but it would be helpful if we didn't have to construct and destroy the object in the first place. 
 - Don't waste effort on computations whose results are not likely to be used. When tracing is off, the creation of the string member is worthless and costly. 
 - Don't aim for the world record in design flexibility. All you need is a design that's sufficiently flexible for the problem domain. A char pointer can sometimes do the simple jobs just as well, 
and more efficiently, than a string. 
 - Inline. Eliminate the function call overhead that comes with small, frequently invoked function calls. Inlining the Trace constructor and destructor makes it easier to digest the Trace overhead. 


## 2. Constructors and Destructors

A programming environment typically provides multiple flavors of synchronization constructs. The flavors 
you may encounter will vary according to 

 - Concurrency level A semaphore allows multiple threads to share a resource up to a given maximum. A mutex allows only one thread to access a shared resource. 
 - Nesting Some constructs allow a thread to acquire a lock when the thread already holds the lock. Other constructs will deadlock on this lock-nesting. 
 - Notify When the resource becomes available, some synchronization constructs will notify all waiting threads. This is very inefficient as all but one thread wake up to find out that they were not fast enough and the resource has already been acquired. A more efficient notification scheme will wake up only a single waiting thread. 
 - Reader/Writer locks Allow many threads to read a protected value but allow only one to modify it. 
 - Kernel/User space Some synchronization mechanisms are available only in kernel space. 
 - Inter/Intra process Typically, synchronization is more efficient among threads of the same process than threads of distinct processes. 

### Key Points 
 - Constructors and destructors may be as efficient as hand-crafted C code. In practice, however, they often contain overhead in the form of superfluous computations. 
 - The construction (destruction) of an object triggers recursive construction (destruction) of parent and member objects. Watch out for the combinatorial explosion of objects in complex hierarchies. They make construction and destruction more expensive. 
 - Make sure that your code actually uses all the objects that it creates and the computations that they perform. We would encourage people to peer inside the classes that they use. This advice is not going to be popular with OOP advocates. OOP, after all, preaches the use of classes as encapsulated black-box entities and discourages you from looking inside. How do we balance 
between those competing pieces of advice? There is no simple answer because it is context sensitive. Although the black-box approach works perfectly well for 80% of your code, it may wreak havoc on the 20% that is performance critical. It is also application dependent. Some application will put a premium on maintainability and flexibility, and others may put performance considerations at the top of the list. As a programmer you are going to have to decide the question of what exactly you are trying to maximize. 
 - The object life cycle is not free of cost. At the very least, construction and destruction of an object may consume CPU cycles. Don't create an object unless you are going to use it. Typically, you want to defer object construction to the scope in which it is manipulated. 
 - Compilers must initialize contained member objects prior to entering the constructor body. You ought to use the initialization phase to complete the member object creation. This will save the overhead of calling the assignment operator later in the constructor body. In some cases, it will also avoid the generation of temporary objects. 

## 3.Virtual Functions

The true cost of virtual functions then boils down to the third item only.  the inability to inline a virtual function is its biggest performance penalty. 

Evaluating the performance penalty of a virtual function is equivalent to evaluating the penalty resulting 
from failure to inline that same function. This penalty does not have a fixed cost. It is dependent on the 
complexity of the function and the frequency with which it is invoked. On one end of the spectrum are the 
short functions that are invoked often. Those benefit the most from inlining, and failing to do so will result 
in a heavy penalty. At the other end of the spectrum are complex functions that are seldom invoked. 

### Key Points 
 - The cost of a virtual function stems from the inability to inline calls that are dynamically bound at run-time. The only potential efficiency issue is the speed gained from inlining if there is any. Inlining efficiency is not an issue in the case of functions whose cost is not dominated by call and return overhead. 
 - Templates are more performance-friendly than inheritance hierarchies. They push type resolution to compile-time, which we consider to be free. 

## 4. Return Value Optimization(RVO)

### Key Points 
 - If you must return an object by value, the Return Value Optimization will help performance by eliminating the need for creation and destruction of a local object. 
 - The application of the RVO is up to the discretion of the compiler implementation. You need to consult your compiler documentation or experiment to find if and when RVO is applied. 
 - You will have a better shot at RVO by deploying the computational constructor. 

## 5. Temporaries 临时对象
 
 - Object Definition
 - Type Mismatch
 - Pass by Value
 - Return by Value 
 - Eliminate Temporaries with op=()

### Key Points 
 -• A temporary object could penalize performance twice in the form of constructor and destructor 
computations. 
 -• Declaring a constructor explicit will prevent the compiler from using it for type conversion 
behind your back. 
 -• A temporary object is often created by the compiler to fix a type mismatch. You can avoid it by 
function overloading. 
 -• Avoid object copy if you can. Pass and return objects by reference. 避免对象拷贝，按引用传递和返回对象。
 -• You can eliminate temporaries by using <op>= operators where <op> may be +, -, *, or /. 


