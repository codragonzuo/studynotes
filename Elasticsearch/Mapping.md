
## 自动检测及动态映射Dynamic Mapping

Mapping is the process of defining how a document should be indexed to Elasticsearch. 

映射就是描述字段的类型、如何进行分析、如何进行索引等内容。

In addition to this, how to analyze the fields of the target query is determined by mapping.

Types are created according to the mapping information. It is important to know that Elasticsearch creates mapping automatically based on the data sent. When data is added, Elasticsearch tries to identify the data structure and makes it searchable. 
This process is known as dynamic mapping.

Mapping is very important for relevant search results, and from this point it should 
be understood quite well that how a field is analyzed is determined by mapping.



动态映射



ES中有一个非常重要的特性——动态映射，即索引文档前不需要创建索引、类型等信息，在索引的同时会自动完成索引、类型、映射的创建。
那么什么是映射呢？映射就是描述字段的类型、如何进行分析、如何进行索引等内容。

**当ES在文档中碰到一个以前没见过的字段时，它会利用动态映射来决定该字段的类型，并自动地对该字段添加映射。**

有时这正是需要的行为，但有时不是，需要留意。你或许不知道在以后你的文档中会添加哪些字段，但是你想要它们能够被自动地索引。或许你只是想要忽略它们。
或者，尤其当你将ES当做主要的数据存储使用时，大概你会希望这些未知的字段会抛出异常来提醒你注意这一问题。

幸运的是，你可以通过dynamic设置来控制这一行为，它能够接受以下的选项：

true：默认值。动态添加字段  
false：忽略新字段  
strict：如果碰到陌生字段，抛出异常  
dynamic设置可以适用在根对象上或者object类型的任意字段上。

你应该默认地将dynamic设置为strict，但是为某个特定的内部对象启用它：  



