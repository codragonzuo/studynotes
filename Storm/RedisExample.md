
# Storm集成Redis(使用redis的发布订阅功能)

在上一篇中，我们搭建了一套实时日志分析平台，目前该平台的主要需求就是监测日志中是否含有某些敏感信息，对于不同的日志来源渠道，规则是不同的。
 
有些是默认规则，有些是用户个性化需求，比如A系统，我的日志里面不允许出现hello这个单词，B系统我的日志里面不允许出现world这个单词，当用户新增了敏感信息后，要求应用能够近乎实时的更新其本地缓存(默认情况下，当storm启动的时候，会加载默认规则到bolt里面，而不是每次都从DB查询)，这里我们采用redis的发布订阅来实现。

https://blog.csdn.net/charry_a/article/details/79289820




## redis实现消息队列&发布/订阅模式使用


　　在项目中用到了redis作为缓存，再学习了ActiveMq之后想着用redis实现简单的消息队列，下面做记录。

 　　Redis的列表类型键可以用来实现队列，并且支持阻塞式读取，可以很容易的实现一个高性能的优先队列。同时在更高层面上，Redis还支持"发布/订阅"的消息模式，可以基于此构建一个聊天系统。

一、redis的列表类型天生支持用作消息队列。(类似于MQ的队列模型--任何时候都可以消费，一条消息只能消费一次)
二、发布/订阅模式(类似于MQ的主题模式-只能消费订阅之后发布的消息，一个消息可以被多个订阅者消费)

- Redis 发布订阅
https://www.runoob.com/redis/redis-pub-sub.html




## Storm存储结果至Redis

https://www.cnblogs.com/mmaa/p/5789853.html

