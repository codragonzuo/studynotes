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

