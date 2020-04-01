## Data Modelling

https://www.guru99.com/data-modelling-conceptual-logical.html

![](https://www.guru99.com/images/1/022218_0657_WhatisDataM1.png)


MongoDB also has its own way of representing this kind of relationship. In fact, there are two ways:  
•  Embedded documents  
•  References  

There is no rule when embedding data in MongoDB, but overall, we should observe:  
•  Whether we have a one-to-one relationship between documents.  
•  Whether we have a one-to-many relationship between documents, and whether the "many" part of the relationship is very dependent of the "one"  part. This means, for instance, that every time we present the "one" part,  we will also present the "many" part of the relationship.   
If our model fits in one of the preceding scenarios, we should consider using embedded documents.

- Working with references
Normalization is a fundamental process to help build relational data models. In order to minimize redundancy, in this process we divide larger tables into smaller ones and define relationships among them. We can say that creating a reference in MongoDB is the way we have to "normalize" our model. This reference will describe the relationship between documents.


There is no rule for references using MongoDB, but overall, we should observe:  
•  Whether we are duplicating the same information many times while embedding data (this shows poor reading performance)  
•  Whether we need to represent many-to-many relationships  
•  Whether our model is a hierarchy  

If our model fits in one of the preceding scenarios, we should consider the use  of references.

- Atomicity
Another important concept that will affect our decisions when designing a document is atomicity. In MongoDB, operations are atomic at the document level. This means that we can modify one document at a time. Even if we have an operation that  works in more than one document in a collection, this operation will happen in  one document at a time.

Hence, when we decide to model a document with embedded data, we simply write operations, since all the data we need is in the same document. This is opposed to what happens when we choose to reference data, where we require many write operations that are not atomic.


- Common document patterns
Now that we understood the way we can design our documents, let's take some examples of real-life problems, such as how to write a data model that better describes the relationship between entities.

This section will present you with patterns that illustrate when to embed or when to reference documents. Until now, we have considered as a deciding factor:
•  Whether consistency is the priority一致性优先  
•  Whether read is the priority 读优先  
•  Whether write is the priority 写优先  
•  What update queries we will make 更改优先  
•  Document growth  文档增长  
