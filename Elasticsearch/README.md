
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




