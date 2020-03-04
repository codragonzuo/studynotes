
# Spark 

1. 当调用一个collect动作时， 图会被提交到一个有向无环图DAG调度程序。  
2. DAG调度程序将运算图划分为一些阶段stage。 一个阶段由基于输入数据分区的任务组成。 DAG调度进行运算图优化。  
3. 一个阶段由基于输入数据分区的任务组成。  

输入可能以多个文件的形式存储在HDFS上，每个File都包含了很多块，称为Block。  
当Spark读取这些文件作为输入时，会根据具体数据格式对应的InputFormat进行解析，一般是将若干个Block合并成一个输入分片，称为InputSplit，  

注意InputSplit不能跨越文件。  
随后将为这些输入分片生成具体的Task。InputSplit与Task是一一对应的关系。  
随后这些具体的Task每个都会被分配到集群上的某个节点的某个Executor去执行。  

每个节点可以起一个或多个Executor。  
每个Executor由若干core组成，每个Executor的每个core一次只能执行一个Task。  
每个Task执行的结果就是生成了目标RDD的一个partiton。  


注意: 

这里的core是虚拟的core而不是机器的物理CPU核，可以理解为就是Executor的一个工作线程。

而 Task被执行的并发度 = Executor数目 * 每个Executor核数。

至于partition的数目：

对于数据读入阶段，例如sc.textFile，输入文件被划分为多少InputSplit就会需要多少初始Task。  
在Map阶段partition数目保持不变。  
在Reduce阶段，RDD的聚合会触发shuffle操作，聚合后的RDD的partition数目跟具体操作有关，例如repartition操作会聚合成指定分区数，还有一些算子是可配置的。  



##  Parallelism, Partitions, and Tasks 
```
Task parallelism is the single most important factor when it comes to performance in Spark Streaming. 
Finding the optimum value is nontrivial: setting it too high leads to contention, whereas setting it too low 
results in underutilization of resources. 
You know that each  DStream  is made up of RDDs that in turn are made up of partitions. Each partition 
is a self-contained piece of data, which is operated on by a task. Therefore, there is an almost one-to-one 
mapping between the number of partitions in an RDD and the number of tasks. In a typical setting, the 
number of partitions in a stage (and, in turn, its parallelism) remains the same. This is known as a   narrow 
dependency   : a partition gets its data from a single partition in the preceding transformation, leading to 
pipelined execution. This applies to  map() ,  flatMap() ,  filter() ,  union() , and so on.  coalesce()  with 
shuffle set to  false  also results in a narrow dependency even though it takes in multiple partitions. 
The number of tasks across partitions can vary, which results in a  wide dependency : a partition reads 
in records from multiple partitions in the preceding transformation. This applies to all  *ByKey  operations, 
such as  groupByKey() and  reduceByKey() ; joining operations, such as  join() ,  cogroup() , and so on; and 
repartition() . Let’s go through an example to drive home the point. 
The code in Listing  4-1  enables you to gauge the presence of a solar particle event  17   based on the data from 
Voyager 1. Solar particle events are caused by accelerated particles, such as protons emitted by the Sun. A solar 
storm can disrupt communication and can become a radiation hazard to spaceships. Attributes 19 to 29 in 
Table  4-1  represent proton  flux   readings binned by energy. Your goal is to find the distribution of solar storms 
across years. Let’s use an overly sensitive threshold of 1.0 pfu for any one of the energy bins for storm detection. 
To minimize the amount of data per record up front, you perform a projection to keep only year and energy 
bins (lines 3–4). The next step is to filter out records that do not reach the threshold of 1.0 (line 5). Following this, 
records are grouped by year, aggregated, and sorted (lines 5–7). You finally write the output to a directory (line 7). 
```
        Listing 4-1.     Yearly Histogram of Proton Flux Events (pfu > 1.0)   
1.   val voyager1 = ssc.textFileStream(inputPath)    
2.   voyager1.map(rec => {    
3.     val attrs = rec.split("\\s+")    
4.     ((attrs(0).toInt), attrs.slice(18, 28).map(_.toDouble))    
5.   }).filter(pflux => pflux._2.exists(_ > 1.0)).map(rec => (rec._1, 1))    
6.     .reduceByKey(_ + _)    
7.      .transform(rec => rec.sortByKey(ascending =  false , numPartitions = 1)).saveAsTextFiles(outputPath)    
```
Figure  4-1  presents the dependencies for the code in Listing  4-1 . Transforms with the same color reside 
in the same narrow dependency zone, and a color transition represents a wide dependency. For instance, 
partitions that constitute RDDs, which in turn reside in the  MappedDStream  emitted by the first  map , are 
filtered, as is by the  filter  operator. In contrast, each task of the  reduceByKey  operator needs all instances 
of the keys in its partition space, which could potentially be present in each partition of its preceding 
 MappedDStream . Note that this example ignores the internal transformations that are carried out by the input 
source and the output action.      
  Figure 4-1.     Dependency graph of the solar event distribution application.  DStream s with the same color reside 
in the same dependency zone. Additionally, straight arrows represent a narrow dependency, and crossed 
arrows represent a wide dependency (or a shuffle operation).       
```
### Task Parallelism 
 The number of partitions dictates the number of tasks assigned to each  DStream . Put differently,   DStream    
parallelism   is a function of the number of partitions. This number depends on the dependency type: the   
number of partitions across the  DStream s that fall in a narrow dependency zone remains the same, but it   
changes across a shuffle zone due to a wide dependency. This is illustrated in Figure  4-2  for the same sample   
code. The input  DStream  has eight partitions, each corresponding to an HDFS split. The same number of   
partitions propagates until  reduceByKey , which necessitates a shuffle operation. The number of partitions   
for shuffle operations is dictated by either  spark.default.parallelism  (details in Table  4-3 ) or the number   
of maximum partitions in the RDDs that constitute the parent  DStream  if  spark.default.parallelism  is not   
set. Additionally, this number can be tweaked by explicitly passing a parallelism value to the transformation.   
This is useful when you know that the amount of data after the transformation will expand or shrink. 

For instance,  reduceByKey  in Listing  4-1  shrinks the number of data records to a number per year, and keeping  
four partitions for a handful of data records is a waste. Therefore, you explicitly pass a value of 1 to the  
 sortByKey  transform.     

Spark Streaming and Flink who are the favorite of data developers  
http://www.programmersought.com/article/8475147017/  
Spark Streaming – under the hood  
https://techmagie.wordpress.com/tag/spark/  
Kafka Stream background  
http://www.programmersought.com/article/1096146270/  

