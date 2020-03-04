## Spark Scheduler模块详解-DAGScheduler实现

https://www.jianshu.com/p/ad9610bcb4d0


![](https://github.com/vaquarkhan/vaquarkhan/blob/master/scala/02-schedulingProcess.jpg)

Questions:

  How does DAGScheduler split the DAG into stages?  
  How stages can be splitted into tasks?  
  What do executors do in the nutshell?  



    In spark-summit 2014, Aaron gives the speak A Deeper Understanding of Spark Internals , in his slide, page 17 show a stage has been splited into 4 tasks as bellow:--
![](https://i.stack.imgur.com/MjBmN.jpg)


## [Arch] Spark job submission breakdown

https://hxquangnhat.com/2015/04/03/arch-spark-job-submission-breakdown/

![](https://hxquangnhat.files.wordpress.com/2015/04/spark-job-submission.jpg)


## A-Deeper-Understanding-of-Spark-Internals（Spark内核深入理解）

https://blog.csdn.net/sdujava2011/article/details/50603427


- spark 图书github

https://github.com/vaquarkhan/vaquarkhan/tree/master/scala

https://github.com/vaquarkhan/microservices-recipes-a-free-gitbook

2012-Intro-to-Spark-Internals-MateiZ.pdf

https://github.com/vaquarkhan/vaquarkhan/blob/master/scala/2012-Intro-to-Spark-Internals-MateiZ.pdf


https://databricks.com/session/a-deeper-understanding-of-spark-internals


## Spark资源调度和任务调度的流程
1. 启动集群后，Worker节点会向Master节点汇报资源情况，Master掌握了集群资源情况。

2. 当Spark提交一个Application后，根据RDD之间的依赖关系将Application形成一个DAG有向无环图。任务提交后，Spark会在Driver端创建两个对象：DAGScheduler和TaskScheduler。

3. DAGScheduler是任务调度的高层调度器，是一个对象。DAGScheduler的主要作用就是将DAG根据RDD之间的宽窄依赖关系划分为一个个的Stage，然后将这些Stage以TaskSet的形式提交给TaskScheduler（TaskScheduler是任务调度的低层调度器，这里TaskSet其实就是一个集合，里面封装的就是一个个的task任务,也就是stage中的并行度task任务）

4. TaskSchedule会遍历TaskSet集合，拿到每个task后会将task发送到计算节点Executor中去执行（其实就是发送到Executor中的线程池ThreadPool去执行）。

5. task在Executor线程池中的运行情况会向TaskScheduler反馈，

6. 当task执行失败时，则由TaskScheduler负责重试，将task重新发送给Executor去执行，默认重试3次。如果重试3次依然失败，那么这个task所在的stage就失败了。

7. stage失败了则由DAGScheduler来负责重试，重新发送TaskSet到TaskSchdeuler，Stage默认重试4次。如果重试4次以后依然失败，那么这个job就失败了。job失败了，Application就失败了。

8. TaskScheduler不仅能重试失败的task,还会重试straggling（落后，缓慢）task（也就是执行速度比其他task慢太多的task）。如果有运行缓慢的task那么TaskScheduler会启动一个新的task来与这个运行缓慢的task执行相同的处理逻辑。两个task哪个先执行完，就以哪个task的执行结果为准。这就是Spark的推测执行机制。在Spark中推测执行默认是关闭的。推测执行可以通过spark.speculation属性来配置。


DAGScheduler：负责分析用户提交的应用，并根据计算任务的依赖关系建立DAG，且将DAG划分为不同的Stage，每个Stage可并发执行一组task。注：DAG在不同的资源管理框架实现是一样的。

TaskScheduler：DAGScheduler将划分完成的Task提交到TaskScheduler，TaskScheduler通过Cluster Manager在集群中的某个Worker的Executor上启动任务，实现类TaskSchedulerImpl。


**DAGScheduler将应用的DAG划分成不同的Stage，每个Stage由并发执行的一组Task构成，Task的执行逻辑完全相同，只是作用于不同数据。**
**Stage的划分 
宽依赖：需要Shuffle，Spark根据宽依赖将Job划分不同的Stage
窄依赖：RDD的每个Partition依赖固定数量的parent RDD的Partition，可以通过一个Task并行处理这些相互独立的Partition


**DAGScheduler完成任务提交后，在判断哪些Partition需要计算，就会为Partition生成Task，然后封装成TaskSet，提交至TaskScheduler。等待TaskScheduler最终向集群提交这些Task，监听这些Task的状态。**


