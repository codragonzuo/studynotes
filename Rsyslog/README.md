
# Rsyslog

# 日志代理方案选择
## 1,简介
日志代理需要部署在客户的机子上,所以不能太大,也不能消耗太多性能,根据我们的需求找了以下几个开源的方案:  

名称 | 开发语言 | rpm安装包大小
:-:|:-:|:-:
filebeat|golang | 22.8m
rsyslog|c|717kb

这是网上的比较,比较全面:
`https://www.jianshu.com/p/8384f6cd0f22`  

## 2,两种工具的比较
### **1,filebeat**
#### 1,filebeat支持的日志获取方式  

1)通过模块获取对象 :
Apache ,  Auditd ,  AWS ,  CEF ,  Cisco ,  Coredns  Elasticsearch ,  Envoyproxy ,  Google Cloud ,  haproxy ,  IBM MQ ,  Icinga ,  IIS ,  Iptables ,  Kafka ,  Kibana ,  Logstash ,  MongoDB ,  MSSQL ,  MySQL ,  nats ,  NetFlow ,  Nginx ,  Osquery ,  Palo Alto Networks ,  PostgreSQL ,  RabbitMQ ,  Redis ,  Santa ,  Suricata ,  System ,  Traefik ,  Zeek (Bro)   
这是官网上对应的详细信息:https://www.elastic.co/guide/en/beats/filebeat/7.4/filebeat-,  s.html  

2)通过手动配置filebeat :
Log ,  Stdin ,  Container ,  Kafka ,  Redis ,  UDP ,  Docker ,  TCP ,  Syslog ,  s3 ,  NetFlow ,  Google Pub/Sub  
这是手动配置的详细说明:  
https://www.elastic.co/guide/en/beats/filebeat/current/configuration-filebeat-options.html


#### 2,filebeat日志输出方式
支持以下几种输出方式:  
Elasticsearch ,  Logstash ,  Kafka ,  Redis ,  File ,  Console ,  Elastic Cloud
这是官网的详细信息:  
https://www.elastic.co/guide/en/beats/filebeat/current/configuring-output.html  

#### 3,优势
Filebeat 只是一个二进制文件没有任何依赖。它占用资源极少，尽管它还十分年轻，正式因为它简单，所以几乎没有什么可以出错的地方，所以它的可靠性还是很高的。它也为我们提供了很多可以调节的点，例如：它以何种方式搜索新的文件，以及当文件有一段时间没有发生变化时，何时选择关闭文件句柄。

#### 4,劣势
Filebeat 的应用范围十分有限，所以在某些场景下我们会碰到问题。例如，如果使用 Logstash 作为下游管道，我们同样会遇到性能问题。正因为如此，Filebeat 的范围在扩大。开始时，它只能将日志发送到 Logstash 和 Elasticsearch，而现在它可以将日志发送给 Kafka 和 Redis，在 5.x 版本中，它还具备过滤的能力。

### **2,rsyslog**
#### 1,rsyslog支持的日志获取方式  
获取对象 :  
RFC3195  ,  Batch report  ,  Docker  ,  Text File  ,  GSSAPI Syslog  ,  Systemd Journal  ,  read from Apache KafkaKernel Log  ,  /dev/kmsg Log  ,  Mark Message  ,  Program integration  ,  Generate Periodic Statistics of Internal Counters ,  Plain TCP Syslog ,  RELP  ,  Solaris  ,  TCP Syslog  ,  Tuxedo ULOG  ,  UDP Syslog  ,  Unix Socket  
这是官网的详细说明:  
https://www.rsyslog.com/doc/v8-stable/configuration/modules/idx_input.html  
#### 2,rsyslog日志输出方式
支持以下几种输出方式:AMQP 1.0 Messaging    ,  ClickHouse    ,  Elasticsearch ,  File ,  syslog Forwarding    ,  Hadoop Filesystem    ,  Redis ,  HTTP ,  Hadoop HTTPFS ,  Systemd Journal ,  write to Apache KafkaGeneric Database ,  Mail ,  MongoDB ,  MySQL Database    ,  Oracle Database ,  PostgreSQL Database ,  Pipe ,  Program integration ,  RabbitMQ ,  RELP ,  ruleset output/including  ,  SNMP Trap ,  stdout output ,  UDP spoofing output ,  notify users ,  Unix sockets ,  GuardTime Log Signature Provider (gt) ,  Keyless Signature Infrastructure Provider (ksi) ,  KSI Signature Provider (rsyslog-ksi-ls12)  
这是官网的详细说明:  
https://www.rsyslog.com/doc/v8-stable/configuration/modules/idx_output.html

https://www.rsyslog.com/downloads/download-v8-stable/

#### 3,优势
rsyslog 是经测试过的最快的传输工具。如果只是将它作为一个简单的 router/shipper 使用，几乎所有的机器都会受带宽的限制，但是它非常擅长处理解析多个规则。它基于语法的模块（mmnormalize）无论规则数目如何增加，它的处理速度始终是线性增长的。这也就意味着，如果当规则在 20-30 条时，如解析 Cisco 日志时，它的性能可以大大超过基于正则式解析的 grok ，达到 100 倍（当然，这也取决于 grok 的实现以及 liblognorm 的版本）。
它同时也是我们能找到的最轻的解析器，当然这也取决于我们配置的缓冲。

#### 4,劣势
rsyslog 的配置工作需要更大的代价（这里有一些例子），这让两件事情非常困难：
文档难以搜索和阅读，特别是那些对术语比较陌生的开发者。
5.x 以上的版本格式不太一样（它扩展了 syslogd 的配置格式，同时也仍然支持旧的格式），尽管新的格式可以兼容旧格式，但是新的特性（例如，Elasticsearch 的输出）只在新的配置下才有效，然后旧的插件（例如，Postgres 输出）只在旧格式下支持。

尽管在配置稳定的情况下，rsyslog 是可靠的（它自身也提供多种配置方式，最终都可以获得相同的结果），它还是存在一些 bug 。

## 3,总结
通过对两种工具的对比,双方的拓展性都不错,但是filebeat的使用难度远小于rsyslog.所以如果强调性能推荐rsyslog,如果强调快速开发及易维护,则推荐filebeat


# Filebeat配置

## Filebeat kafka输出配置 

```YAML
output.kafka:
  # initial brokers for reading cluster metadata
  hosts: ["kafka1:9092", "kafka2:9092", "kafka3:9092"]

  # message topic selection + partitioning
  topic: '%{[fields.log_topic]}'
  partition.round_robin:
    reachable_only: false

  required_acks: 1
  compression: gzip
  max_message_bytes: 1000000
```


## 

目前用的最多的日志管理技术应该是ELK,E应该没有太多的疑问基本上很多公司都是采用的这个作为存储索引引擎。L及logstash是一个日志采集工具支持文件采集等多种方式，但是基于容器的日志采集又跟传统的文件采方式略有不同，虽然docker本身提供了一些log driver但是还是无法很好的满足我们的需求。现在kubernetes官方有一个日志解决方案是基于fluentd的。至于为什么最后选择采用filebeat而没有用fluentd主要有一下几点：

首先filebeat是go写的，我本身是go开发，fluentd是ruby写的很抱歉我看不太懂
filbeat比较轻量，filbeat现在功能虽然比较简单但是已经基本上够用，而且打出来镜像只有几十M
filbeat性能比较好，没有具体跟fluentd对比过，之前跟logstash对比过确实比logstash好不少，logtash也是ruby写的我想应该会比fluentd好不少
filbeat虽然功能简单，但是代码结构非常易于进行定制开发
还有就是虽然用了很久fluentd但是fluentd的配置文件实在是让我很难懂

作者：YiQinGuo
链接：https://www.jianshu.com/p/fe3ac68f4a7a
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 基于filebeat二次开发Kubernetes日志采集

https://www.jianshu.com/p/fe3ac68f4a7a



