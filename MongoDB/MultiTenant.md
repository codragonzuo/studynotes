## Building Multi-tenant applications on MongoDB

20140812  https://web.archive.org/web/20140812091703/http://support.mongohq.com/use-cases/multi-tenant.html

MongoDB is very popular for SaaS applications, and we are frequently asked "how should I build an application that can handle multiple customers?" We have two good answers.

One database for all customers
It's reasonably easy (conceptually) to put all customer database in a single database with a single set of collections. Each document needs a customer_id field. Queries and updates should use that field to restrict the scope of documents they're working with.

Most web apps start with this method, and have for quite some time. Application frameworks, object mappers, and other toolkits generally have built in methods of handling customer segmentation at the field level. This makes development straightforward, though there's more pressure on the application to ensure security.

This setup also allows queries across data from multiple customers. "Global" views of data are very easy to generate from the application, so leaderboards, popularity feeds and other widgets are quick to implement.

From a scaling perspective, this works well with MongoDB sharding since you can keep customer data grouped together and do efficient range queries. If you do go this route, make sure you use a customer_id that's reasonably random. Incrementing customer_ids don't work as well for scale as values with a high cardinality.

MongoDB's new hashed shard keys can help with scale, even when customer_id values are incremental. This does require an additional index, though, and it's always better to minimize redundant indexes.

One database per customer

This is a good strategy, with some basic rules. First, each database in Mongo adds operational complexity and requires a minimum of 32MB of disk space. Freemium applications with many, many small customers may not be financially viable with this method.

We have a few large customers who have implemented this strategy well. On the application side, they route account data to the appropriate replica set and database name based on the customer. Operationally, it's best to only have a few hundred DBs per Mongo process (for a lot of reasons) so scaling becomes a matter of adding replica sets as the app gets more popular, with enough app logic to move new DBs to the new sets.

Exporting or deleting a customer's data is simple, and MongoDB will do a good job of reclaiming disk space when customers churn (which, hopefully, doesn't happen ...). Optimizing larger customers' databases is, likewise, pretty straightforward. Customers can even have different indexing strategies if their use case calls for it.

If you do go this route, make sure you run MongoDB with smallfiles=true and pay careful attention to how well balanced customer DBs are between replica sets.
 

One collection per customer

It is very tempting to isolate customer data by prefixing collection names with a customer identifier and cramming them all in a single database. Please do not do this, it will end up hurting your application if you have any kind of success. MongoDB is not meant to scale at the collection level and you will quickly run into namespace limits. Even worse, data management tools have a very difficult time handling more than 100 collections or so. This is a very sharp edge case that it's best to avoid.

When to use what?

A single database is preferrable for ease of initial development and lowest operational overhead. It can be painful, though, if queries vary substantially between customers and aren't easy to speed up via shared indexes. Slow queries (especially table scans) on large customers can hurt performance for everyone else. A typical use case is a multi-tenant advertising platform.

When looking for the ability to measure impact from a single customer, like a CRM system, then the database per customer route is likely a better option. CRMs require very flexible query / search capabilities and have customers with very diverse data sizes.

Running Multi-tenant on MongoHQ
With MongoHQ's dedicated platforms, we have the options to support either multi-tenant single databases or the one-database-per-customer.

One-database-per-customer is implemented on dedicated servers by giving the customer administrative access to the database. From there, the customer can create databases on the fly for customers. When outgrowing the single server, MongoHQ can add more MongoDB processes to the same server, or scale out to multiple servers.

Single database solutions should start on our Replica Set SSD plans. As the app scales, we will help you take advantage of MongoDBs auto sharding to keep up with your customer growth.

Still Need Help?

If this article didn't solve things, summon a human and get some help!

## 


https://stackoverflow.com/questions/2748825/what-is-the-recommended-approach-towards-multi-tenant-databases-in-mongodb

https://stackoverflow.com/questions/46439677/mongodb-different-collection-per-tenant



## Multi-tenant MongoDB + mongo-native driver + connection pooling

https://stackoverflow.com/questions/57345147/multi-tenant-mongodb-mongo-native-driver-connection-pooling

It's a shame since till this day, in Mongo, "connection" (network stuff, SSL, cluster identification) and authentication are 2 separate actions. Think about when you run mongo shell, you provide the host, port, replica set if any, and your in, connected! But not authenticated. You can then authenticate to user1, do stuff, and then authenticate to user2 and do stuff only user2 can do. And this is done on the same connection! without going thru the overhead creating the channel again, SSL handshake and so on...

https://www.slideshare.net/mongodb/securing-mongodb-to-serve-an-awsbased-multitenant-securityfanatic-saas-application?from_action=save

多个租户共享一个数据库，每个租户一个文档，问题在于 每个租户使用不同的身份密码取访问数据库，使用同一个线程池，每个线程采用不同的密码取访问数据库。

但是在前端，每个租户 通过认证获取令牌，取访问获取线程池， 线程里却要使用不同的密码去访问数据库。

## Guide to multi-tenancy with Spring Boot and MongoDB

https://medium.com/@alexantaniuk/guide-to-multi-tenancy-with-spring-boot-and-mongodb-78ea5ef89466
