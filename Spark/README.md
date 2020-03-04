
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

