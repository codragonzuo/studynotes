# Stream Processing with Apache Flink

https://www.xenonstack.com/blog/stream-processing/

Apache Flink is a stream processing framework which is developed by Apache Software Foundation. It is an open source platform which is a streaming data flow engine that provides communication, and data-distribution for distributed computations over data streams. Apache Flink is a distributed data processing platform which is used in big data applications and primarily involves the analysis of data stored in the Hadoop clusters. Apache flink is capable of handling both the batch and stream processing jobs. It is the alternative of Map-reduce.

Some of the best features of Apache Flink are as follows –

Unified framework –Flink is a unified framework, that allows to build a single data workflow and holds streaming, batch, and SQL. Flink can also process graph with its own Gelly library and use the Machine learning algorithm from its FlinkML library. Apart from This, Flink also supports iterative algorithms and interactive queries.

Custom Memory Manager – Flink implements its memory management inside the JVM and its features are as follows

C++ style memory management inside the JVM.
User data stored in serialized bytes array in JVM.
Memory can be quickly allocated and de allocated.
Native Closed Loop Iteration Operators: Flink has its dedicated support for iterative computations. It iterates on data by using streaming Architecture. The concept of an iterative algorithm is tightly bounded into the flink query optimizer.

## Use Cases of Apache Flink
Apache Flink is one of the best options to develop and run several types of applications because of its extensive features. Some of the use cases of Flink are as follows –

Event Driven Applications – An event-driven application is a type of stateful application through which events are ingested from one or more event streams, and it also reacts to the incoming events. Event-driven applications are based on stateful stream processing applications.

Some of the event-driven applications are as follows –

Fraud Detection  
Anomaly Detection  
Web Application  
Data Analytics Application – These types of applications extract the information from the Raw data. With the help of a proper stream processing engine, analytics can also be done in real time.  
Some of the data analytics Applications are as follows –  

Quality monitoring of networks  
Analysis of product updates and experiment evaluation  
Large scale graph analysis  
Data Pipeline Applications – For converting and moving data from one system to another, ETL, i.e. Extract, Transform and Load operation is the general approach and even ETL jobs are periodically triggered for copying the data from the transaction database to analytical database.  
Some of the data pipeline applications are as follows –  

Continuous ETL operations in e-commerce  
Real-time search index building in e-commerce  



# Use Cases

https://flink.apache.org/usecases.html
