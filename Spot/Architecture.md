## Architecture

![](https://spot.apache.org/library/images/architecture.png)


## Ingest
![](https://github.com/apache/incubator-spot/raw/master/docs/SPOT_Ingest_Framework1_1.png)


处理顺序：

collector --> processing --> kafka --> Streaming  -->  hadoop

- streaming.py

class StreamPipeline:
    '''
        Create an input stream that pulls netflow messages from Kafka.
        

- processing.py
'''
    Methods that will be used to process and prepare netflow data, before being sent to
Kafka cluster.
'''


## Distributed Collector


The role of the Distributed Collector is similar, as it processes the data before transmission. Distributed Collector tracks a directory backwards for newly created files. When a file is detected, it converts it into CSV format and stores the output in the local staging area. Following to that, reads the CSV file line-by-line and creates smaller chunks of bytes. The size of each chunk depends on the maximum request size allowed by Kafka. Finally, it serializes each chunk into an Avro-encoded format and publishes them to Kafka cluster.

Collector在发送数据到kafak之前进行处理。Collector监视目录变化新产生的文件，如果检测到新文件，把新文件转换成CSV格式并存储到 local staging区域。接着读取CSV文件的每一行，产生字节块数据。字节块的大小依赖于kafak最大请求数据大小。最后，把么个数据库转换成Avro编码格式数据发送到kafka集群。



Due to its architecture, Distributed Collector can run on an edge node of the Big Data infrastructure as well as on a remote host (proxy server, vNSF, etc).

Collector在大数据架构的边缘节点运行， 和远端主机类型。

In addition, option --skip-conversion has been added. When this option is enabled, Distributed Collector expects already processed files in the CSV format. Hence, when it detects one, it does not apply any transformation; just splits it into chunks and transmits to the Kafka cluster.

参数skip-conversion说明Collector以及把数据进行处理存储到CSV文件，这是就直接进行数据转换和kafak发送。

This option is also useful, when a segment failed to transmit to the Kafka cluster. By default, Distributed Collector stores the failed segment in CSV format under the local staging area. Then, using --skip-conversion option could be reloaded and sent to the Kafka cluster.

当出错没有发送到kafka，collector把错误数据存储到CSF格式。这时使用参数skip-conversion，数据会被重新加载并发送到kafka。

Distributed Collector publishes to Apache Kafka only the CSV-converted file, and not the original one. The binary file remains to the local filesystem of the current host.

Collector只把csv转换的数据发送到kafak，而不是原始数据。二进制文件仍存储在当前主机的本地文件系统里。



Streaming Listener

Streaming Listener在集中式架构里运行，监听kafka topic并行消费消息。流数据被分词batches.

按照avro格式对batches数据进行解序列化，解析， 并在对应的Hive里注册。（存储成 parquet格式数据）


In contrary, Streaming Listener can only run on the central infrastructure. Its ability is to listen to a specific Kafka topic and consumes incoming messages. Streaming data is divided into batches (according to a time interval). These batches are deserialized by the Listener, according to the supported Avro schema, parsed and registered in the corresponding table of Hive.
