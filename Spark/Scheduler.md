## Spark资源调度和任务调度的流程

1. 启动集群后，Worker节点会向Master节点汇报资源情况，Master掌握了集群资源情况。

2. 当Spark提交一个Application后，根据RDD之间的依赖关系将Application形成一个DAG有向无环图。任务提交后，Spark会在Driver端创建两个对象：DAGScheduler和TaskScheduler。

3. DAGScheduler是任务调度的高层调度器, 将DAG根据RDD之间的宽窄依赖关系划分为一个个的Stage，然后将这些Stage以TaskSet的形式提交给TaskScheduler.

TaskScheduler是任务调度的低层调度器，这里TaskSet包含一个个的task任务,也就是stage中的并行度task任务）

4. TaskSchedule会遍历TaskSet集合，将task发送到计算节点Executor中去执行（ 发送到Executor中的线程池ThreadPool去执行）。

5. task在Executor线程池中的运行情况会向TaskScheduler反馈，

6. 当task执行失败时，则由TaskScheduler负责重试，将task重新发送给Executor去执行，默认重试3次。如果重试3次依然失败，那么这个task所在的stage就失败了。

7. stage失败了则由DAGScheduler来负责重试，重新发送TaskSet到TaskSchdeuler，Stage默认重试4次。如果重试4次以后依然失败，那么这个job就失败了。job失败则Application失败。

8. TaskScheduler不仅能重试失败的task,还会重试straggling（落后，缓慢）task（也就是执行速度比其他task慢太多的task）。

如果有运行缓慢的task那么TaskScheduler会启动一个新的task来与这个运行缓慢的task执行相同的处理逻辑。两个task哪个先执行完，就以哪个task的执行结果为准。这就是Spark的推测执行机制。在Spark中推测执行默认是关闭的。推测执行可以通过spark.speculation属性来配置。


DAGScheduler：负责分析用户提交的应用，并根据计算任务的依赖关系建立DAG，且将DAG划分为不同的Stage，每个Stage可并发执行一组task。注：DAG在不同的资源管理框架实现是一样的。

TaskScheduler：DAGScheduler将划分完成的Task提交到TaskScheduler，TaskScheduler通过Cluster Manager在集群中的某个Worker的Executor上启动任务，实现类TaskSchedulerImpl。


**DAGScheduler将应用的DAG划分成不同的Stage，每个Stage由并发执行的一组Task构成，Task的执行逻辑完全相同，只是作用于不同数据。**



**DAGScheduler完成任务提交后，在判断哪些Partition需要计算，就会为Partition生成Task，然后封装成TaskSet，提交至TaskScheduler。等待TaskScheduler最终向集群提交这些Task，监听这些Task的状态。**

![](https://images2015.cnblogs.com/blog/1004194/201608/1004194-20160829174157699-296881431.png)

![](https://img-blog.csdn.net/20180209104005592)


## 宽依赖 和 窄依赖

宽依赖(Wide or shffle Dependencies)和窄依赖(Narrow Dependencies)

![](https://upload-images.jianshu.io/upload_images/1935267-8486023be40f27d3.jpg)

原图： https://miro.medium.com/max/633/0*kAw8hogu1oZPy9QU.png

窄依赖（图左）：父partition对子partition是一对一或多对一（只有一个儿子）。

宽依赖（图右）：父partition对子partition是一对多(有多个儿子)。

窄依赖一般是对RDD进行map，filter，union等Transformations。

宽依赖一般是对RDD进行groupByKey，reduceByKey等操作，就是对RDD中的partition中的数据进行重分区（shffle）。

join操作即可能是宽依赖也可能是窄依赖，当要对RDD进行join操作时，如果RDD进行过重分区则为窄依赖，否则为宽依赖。


为什么Spark将依赖分为窄依赖和宽依赖

- 窄依赖(narrow dependency)
可以支持在同一个集群Executor上，以pipeline管道形式顺序执行多条命令，例如在执行了map后，紧接着执行filter。分区内的计算收敛，不需要依赖所有分区的数据，可以并行地在不同节点进行计算。所以它的失败回复也更有效，因为它只需要重新计算丢失的parent partition即可

- 宽依赖(shuffle dependency)
则需要所有的父分区都是可用的，必须等RDD的parent partition数据全部ready之后才能开始计算，可能还需要调用类似MapReduce之类的操作进行跨节点传递。从失败恢复的角度看，shuffle dependency牵涉RDD各级的多个parent partition。

RDD之间的依赖关系就形成了DAG（有向无环图）

在Spark作业调度系统中，调度的前提是判断多个作业任务的依赖关系，这些作业任务之间可能存在因果的依赖关系，也就是说有些任务必须先获得执行，然后相关的依赖人物才能执行，但是任务之间显然不应出现任何直接或间接的循环依赖关系，所以本质上这种关系适合用DAG表示

## Stage的划分

宽依赖：需要Shuffle，Spark根据宽依赖将Job划分不同的Stage

窄依赖：RDD的每个Partition依赖固定数量的parent RDD的Partition，可以通过一个Task并行处理这些相互独立的Partition

注意：宽依赖支持两种Shuffle Manager， HashShuffleManager（基于Hash的Shuffle机制）和SortShuffleManager（基于排序的Shuffle机制）


shuffle依赖就必须分为两个阶段(stage)去做：

（1）第1个阶段(stage)需要把结果shuffle到本地，例如reduceByKey，首先要聚合某个key的所有记录，才能进行下一步的reduce计算，这个汇聚的过程就是shuffle。

(2) 第二个阶段(stage)则读入数据进行处理。

为什么要写在本地？

后面的RDD多个分区都要去读这个信息，如果放到内存，假如出现数据丢失，后面所有的步骤全部不能进行，违背了之前所说的需要父RDD分区数据全部ready的原则。

同一个stage里面的task是可以并发执行的，下一个stage要等前一个stage ready(和map reduce的reduce需要等map过程ready一脉相承)。

Spark 将任务以 shuffle 依赖(宽依赖)为边界打散，划分多个 Stage. 最后的结果阶段叫做 ResultStage, 其它阶段叫 ShuffleMapStage, 从后往前推导，依将计算。


![](https://upload-images.jianshu.io/upload_images/1900685-e784179c0fd1f80c.png)

1.从后往前推理，遇到宽依赖就断开，遇到窄依赖就把当前RDD加入到该Stage

2.每个Stage里面Task的数量是由该Stage中最后一个RDD的Partition的数量所决定的。

3.最后一个Stage里面的任务类型是ResultTask，前面其他所有的Stage的任务类型是ShuffleMapTask。

4.代表当前Stage的算子一定是该Stage的最后一个计算步骤

表面上看是数据在流动，实质上是算子在流动。

（1）数据不动代码动


（2）在一个Stage内部算子为何会流动（Pipeline）？首先是算子合并，也就是所谓的函数式编程的执行的时候最终进行函数的展开从而把一个Stage内部的多个算子合并成为一个大算子（其内部包含了当前Stage中所有算子对数据的计算逻辑）；其次，是由于Transformation操作的Lazy特性！在具体算子交给集群的Executor计算之前首先会通过Spark Framework(DAGScheduler)进行算子的优化（基于数据本地性的Pipeline）。




## 容灾

![](https://upload-images.jianshu.io/upload_images/1935267-b4ee77195a62d50d.jpg)

如上图所示：A,B,C,D,E,F,G代表RDD

当执行算子有shffle操作的时候，就划分一个Stage。（即宽依赖来划分Stage）

窄依赖会被划分到同一个Stage中，这样它们就能以管道的方式迭代执行。

宽依赖由于依赖的上游RDD不止一个，所以往往需要跨节点传输数据。

从容灾角度讲，它们恢复计算结果的方式不同。窄依赖只需要重新执行父RDD的丢失分区的计算即可恢复。
而宽依赖则需要考虑恢复所有父RDD的丢失分区，并且同一RDD下的其他分区数据也重新计算了一次。


## shuffle原理和调优
http://sharkdtu.com/posts/spark-shuffle.html

与MapReduce计算框架一样，Spark的Shuffle实现大致如下图所示，在DAG阶段以shuffle为界，划分stage，上游stage做map task，每个map task将计算结果数据分成多份，每一份对应到下游stage的每个partition中，并将其临时写到磁盘，该过程叫做shuffle write；下游stage做reduce task，每个reduce task通过网络拉取上游stage中所有map task的指定分区结果数据，该过程叫做shuffle read，最后完成reduce的业务逻辑。举个栗子，假如上游stage有100个map task，下游stage有1000个reduce task，那么这100个map task中每个map task都会得到1000份数据，而1000个reduce task中的每个reduce task都会拉取上游100个map task对应的那份数据，即第一个reduce task会拉取所有map task结果数据的第一份，以此类推。

![](http://sharkdtu.com/images/spark-shuffle-overview.png)

在map阶段，除了map的业务逻辑外，还有shuffle write的过程，这个过程涉及到序列化、磁盘IO等耗时操作；在reduce阶段，除了reduce的业务逻辑外，还有前面shuffle read过程，这个过程涉及到网络IO、反序列化等耗时操作。所以整个shuffle过程是极其昂贵的，spark在shuffle的实现上也做了很多优化改进，随着版本的迭代发布，spark shuffle的实现也逐步得到改进。

- 序列号
- 磁盘IO
- 网络IO
- 反序列化



### Spark Architecture: Shuffle

![](https://i2.wp.com/0x0fff.com/wp-content/uploads/2015/08/spark_tungsten_sort_shuffle.png)

https://0x0fff.com/spark-architecture-shuffle/


## 分区

Spark RDD 是一种分布式的数据集，由于数据量很大，因此要它被切分并存储在各个结点的分区当中。从而当我们对RDD进行操作时，实际上是对每个分区中的数据并行操作。

![](https://img-blog.csdn.net/20180706010015323)

![](https://img-blog.csdn.net/20180706005211170)

![](https://img-blog.csdn.net/20180706005229905)

分区的3种方式

1、HashPartitioner

HashPartitioner确定分区的方式：partition = key.hashCode () % numPartitions



2、RangePartitioner

RangePartitioner会对key值进行排序，然后将key值被划分成3份key值集合。


3、CustomPartitioner

CustomPartitioner可以根据自己具体的应用需求，自定义分区。

如何设置合理的分区数

1、分区数越多越好吗？

不是的，分区数太多意味着任务数太多，每次调度任务也是很耗时的，所以分区数太多会导致总体耗时增多。

2、分区数太少会有什么影响？

分区数太少的话，会导致一些结点没有分配到任务；另一方面，分区数少则每个分区要处理的数据量就会增大，从而对每个结点的内存要求就会提高；还有分区数不合理，会导致数据倾斜问题。

3、合理的分区数是多少？如何设置？

总核数=executor-cores * num-executor 

一般合理的分区数设置为总核数的2~3倍


## Spark on YARN


### 1. YARN通用流程
YARN架构里的角色：RM、NM、AM、Container。

![](https://img-blog.csdnimg.cn/20190609233225778.png)

1.client（比如spark）提交一个作业到RM上；
2.RM会找一个NM，并在上面启动一个Container；
3.在Container里面跑AM(作业的主程序)；
4.一个作业如果要跑的话要申请资源的，所以AM要到RM上面去申请资源。假如说现在拿到了资源：可以在三个NM上面分别启动Container。
5.拿到了资源列表后，去三个NM上面启动分别启动Container来运行task。

这里task就是Spark的的Application Master主程序（main函数驱动程序）。

![](https://img-blog.csdnimg.cn/20190610003606586.png)

### Spark on Yarn

https://spark.apache.org/docs/latest/running-on-yarn.html





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


