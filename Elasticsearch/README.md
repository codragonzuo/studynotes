
# Elasticsearch


## Ingest Node

Ingest Node(预处理节点)是 ES 用于功能上命名的一种节点类型，可以通过在 elasticsearch.xml 进行如下配置来标识出集群中的某个节点是否是 Ingest Node.缺省启用。

Ingest Node 里通过API定义 pipeline, 每个pipeline里可以包含若干 Processor

### Processors 类型详解
```
Append Processor 追加处理器
Convert Processor 转换处理器
Date Processor 日期转换器
Date Index Name Processor 日期索引名称处理器
Fail Processor 失败处理器
Foreach Processor 循环处理器
Grok Processor Grok 处理器
Gsub Processor
Join Processor
JSON Processor
KV Processor
Lowercase Processor
Remove Processor
Rename Processor
Script Processor
Split Processor
Sort Processor
Trim Processor
Uppercase Processor
Dot Expander Processor
```

![](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/ingest/enrich/enrich-process.svg)


https://hacpai.com/article/1512990272091


## index lifecycle management (ILM) 

Get started: Automate rollover with ILMedit

This tutorial demonstrates how to use index lifecycle management (ILM) to manage indices that contain time-series data.

When you continuously index timestamped documents into Elasticsearch using Filebeat, Logstash, or some other mechanism, you typically use an index alias so you can periodically roll over to a new index. This enables you to implement a hot-warm-cold architecture to meet your performance requirements for your newest data, control costs over time, enforce retention policies, and still get the most out of your data.

To automate rollover and management of time-series indices with ILM, you:

1. Create a lifecycle policy with the ILM put policy API.
2. Create an index template to apply the policy to each new index.
3. Bootstrap an index as the initial write index.
4. Verify indices are moving through the lifecycle phases as expected with the ILM explain API.

https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-index-lifecycle-management.html



