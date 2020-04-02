# Stored Fields

默认情况下，对字段值进行索引以使其可搜索，但不存储它们 (store)。 这意味着可以查询该字段，但是无法检索原始字段值。在这里我们必须理解的一点是: 如果一个字段的mapping中含有store属性为true，那么有一个单独的存储空间为这个字段做存储，而且这个存储是独立于_source的存储的。它具有更快的查询。存储该字段会占用磁盘空间。如果需要从文档中提取（即在脚本中和聚合），它会帮助减少计算。在聚合时，具有store属性的字段会比不具有这个属性的字段快。 此选项的可能值为false和true。

通常这无关紧要。 该字段值已经是_source字段的一部分，默认情况下已存储。 如果您只想检索单个字段或几个字段的值，而不是整个_source的值，则可以使用source filtering来实现。

在某些情况下，存储字段可能很有意义。 例如，如果您有一个带有标题，日期和很大的内容字段的文档，则可能只想检索标题和日期，而不必从较大的_source字段中提取这些字段。

接下来我们还是通过一个具体的例子来解释这个，虽然上面的描述有点绕口。

首先我们来创建一个叫做my_index的索引：
```
PUT my_index
{
  "mappings": {
    "properties": {
      "title": {
        "type": "text",
        "store": true 
      },
      "date": {
        "type": "date",
        "store": true 
      },
      "content": {
        "type": "text"
      }
    }
  }
}
```
在上面的mapping中，我们把title及date字段里的store属性设置为true，表明有一个单独的index fragement是为它们而配备的，并存储它们的值。我们来写入一个文档到my_index索引中：
```
PUT my_index/_doc/1
{
  "title": "Some short title",
  "date": "2015-01-01",
  "content": "A very long content field..."
}
```
接下来，我们来做一个搜索：

GET my_index/_search

显示的结果是：
```
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "my_index",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "title" : "Some short title",
          "date" : "2015-01-01",
          "content" : "A very long content field..."
        }
      }
    ]
  }
```  
在上面我们可以在_source中看到这个文档的title，date及content字段。

我们可以通过source filtering的方法提前我们想要的字段：
```
GET my_index/_search
{
  "_source": ["title", "date"]
}
```
显示的结果是：
```
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "my_index",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "date" : "2015-01-01",
          "title" : "Some short title"
        }
      }
    ]
  }
```
显然上面的结果显示我们想要的字段date及title是可以从_source里获取的。

我们也可以通过如下的方法来获取这两个字段的值：
```
GET my_index/_search
{
  "stored_fields": [
    "title",
    "date"
  ]
}
```
返回的结果是：
```
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "my_index",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "fields" : {
          "date" : [
            "2015-01-01T00:00:00.000Z"
          ],
          "title" : [
            "Some short title"
          ]
        }
      }
    ]
  }
```  
在上面，我们可以看出来在fields里有一个date及title的数组返回查询的结果。

也许我们很多人想知道到底这个store到底有什么用途呢？如果都能从_source里得到字段的值。

有一种就是我们在开头我们已经说明的情况：我们有时候并不想存下所有的字段在_source里，因为该字段的内容很大，或者我们根本就不想存_source，但是有些字段，我们还是想要获取它们的内容。那么在这种情况下，我们就可以使用store来实现。
