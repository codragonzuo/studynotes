
# Event Sourcing

Event Sourcing（事件溯源）

a.不保存对象的最新状态，而是保存对象产生的所有事件；

b.通过事件溯源（Event Sourcing，ES）得到对象最新状态；

什么时候使用Event Sourcing
使用Event Sourcing有它的优点也有缺点，那么什么时候该使用Event Sourcing模式呢？

1. 首先是系统类型，如果你的系统有大量的CRUD，也就是增删改查类型的业务，那么就不适合使用Event Sourcing模式。Event Sourcing模式比较适用于有复杂业务的应用系统。
2. 如果你或你的团队里面有DDD（领域驱动设计）相关的人员，那么你应该优先考虑使用Event Sourcing。
3. 如果对你的系统来说，业务数据产生的过程比结果更重要，或者说更有意义，那就应该使用Event Sourcing。你可以使用Event Sourcing的事件数据来分析数据产生的过程，解决bug，也可以用来分析用户的行为。
4. 如果你需要系统提供业务状态的历史版本，例如一个内容管理系统，如果我想针对内容实现版本管理，版本回退等操作，那就应该使用Event Sourcing。


http://www.imooc.com/article/40858

http://www.imooc.com/article/40858

整个系统以事件为驱动，所有业务都由事件驱动来完成。

事件是一等公民，系统的数据以事件为基础，事件要保存在某种存储上。

业务数据只是一些由事件产生的视图，不一定要保存到数据库中。

