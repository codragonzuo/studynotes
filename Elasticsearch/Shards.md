## Shards 分片

ES中所有数据均衡的存储在集群中各个节点的分片中，会影响ES的性能、安全和稳定性.

在ES中所有数据的文件块，也是数据的最小单元块，整个ES集群的核心就是对所有分片的分布、索引、负载、路由等达到惊人的速度.

分片的设置

创建 IndexName 索引时候，在 Mapping 中可以如下设置分片 (curl)
```
PUT indexName
{
    "settings": {
        "number_of_shards": 5
    }
}
```
- 分片个数（数据节点计算）

分片个数是越多越好，还是越少越好了？根据整个索引的数据量来判断。

实列场景：

如果 IndexA 所有数据文件大小是300G，改怎么定制方案了？(可以通过Head插件来查看)

建议：（仅参考）

1、每一个分片数据文件小于30GB  
2、每一个索引中的一个分片对应一个节点  
3、节点数大于等于分片数  

根据建议，至少需要 10 个分片。

结果： 建10个节点 (Node)，Mapping 指定分片数为 10，满足每一个节点一个分片，每一个分片数据带下在30G左右。

SN(分片数) = IS(索引大小) / 30

NN(节点数) = SN(分片数) + MNN(主节点数[无数据]) + NNN(负载节点数)



## ElasticSearch 按照一定规则切分index

ElasticSearch随着数据越来越大，查询时间也越来越慢，把所有数据放入同一个索引将不是一个好的方法。

所以优化时，将其按照一定规则重新reindex将提高不少效率

按照某字段的日期  
比如将index_name重新索引为index_name-yyyy-MM-dd  
根据字段created_at，原日期格式是"yyyy-MM-dd'T'HH:mm:ss，计算得出yyyy-MM-dd  

inline中是 是类Java代码, 可以复制出来后自己编写
```
POST _reindex?wait_for_completion=false
{
  "source": {
    "index": "index_name"
  },
  "dest": {
    "index": "index_name-"
  },
  "script": {
    "inline": "def sf = new SimpleDateFormat(\"yyyy-MM-dd'T'HH:mm:ss\");def o = new SimpleDateFormat(\"yyyy-MM-dd\");def dt = sf.parse(ctx._source.created_at);ctx._index='index_name-' + o.format(dt);"
  }
}
```
按照ID范围

比如根据ID / 10000000取整，也就是1千万数据放一个index
```
POST _reindex?wait_for_completion=false
{
  "source": {
    "index": "index_name"
  },
  "dest": {
    "index": "index_name-"
  },
  "script": {
    "inline": "ctx._index='index_name-' + Long.valueOf(ctx._source.id / 10000000).toString();"
  }
}
```


## 基于elasticsearch Rest URL动态生成（索引按照日期切分）

Template: http://192.168.0.1:9200/{repeat:(prefix, dayslot, suffix)}/_search

调用方式：
```
var urlcomplie = new shyl.view.esreport.ux.EsUrlCompiler(url)，
url = urlcomplie.getValue(options);//options = {dayslot: [20140911, 20140912]} 日期需要处理好
```
结果 url= http://192.168.0.1:9200/prefix20140911suffix,prefix20140912suffix, /_search

```
/**
* url 模板编译类, 基于ES RESTFul定制数据源时， 它的URL配置往往是需要支持动态生成的，
* 所以该类主要用来处理URL的模板部分例如：
* http://host:port/{指令名称:(参数值)}/{指令名称:(参数值)}。
* 基于这样的设计，你可以定义自己想要的格式。
*
* @author wang xiu fu
*/

Ext.define('shyl.view.esreport.ux.EsUrlCompiler', {
	requires: [],
	/**
	 * 匹配模板表达式
	 */
	re: /\{([\w]+)(?:\:)\(([\w,]+)?\)\}/g,

	url: null,

	complied: Ext.emptyFn,

	commands: {
		repeat: true
	},

	isUrlCompiler: true,

	constructor: function(url, options) {
		options = options || {};
		Ext.apply(this, options);
		this.complie(url);

	},

	complie: function(url) {
		var me=this,
			bodyReturn,
			body;
		function fn (m, command, params) {
			if (!me.commands[command]) {
				Ext.Error.raise('url模板中的"+command+"不存在');
			}
			params = params || '';
			var params = params.split(','),
				len = params.length,
				prefix = '',
				suffix = '',
				array = '',
				i;
			switch(len) {
				case 1:
					array = "this['" + params[0] + "']";
					break;
				case 2:
					prefix = "'" + params[0] + "',";
					array = "this['" + params[1] + "']";
					break;
				case 3:
					prefix = "'" + params[0] + "'";
					array = "this['" + params[1] + "']";
					suffix = ",'" + params[0] + "'";
					break;
			}
			return "' + this." + command + "(" + prefix + array + suffix +") + '";
		}
		bodyReturn = "'" + url.replace(me.re, fn) + "'";
		body = "this.complied = function() { return " + bodyReturn + "; }";
		eval(body);
		return me;
	},

	getValue: function(options) {
		options = options || {};
		if (Ext.isFunction(options)) {
			options = options();
		} 
		Ext.apply(this, options);
		return this.complied();
	},

	//---------------------------------command-----------------------------------------------
	/**
	 * 重复指令，该参数有个参数
	 * 
	 */
	repeat: function(prefix, array, suffix) {
		var me=this,
			prefix = prefix || "",
			suffix = suffix || "",
			array = array || [],
			i;
		if (!array || !array.length || array.length === 0) {
			throw new Error('url模板包含错误的参数');
		}
		for (i in array) {
			array[i] = prefix + array[i] + suffix;
		}
		return array.join(',');
	}
	//其他其他指令可以在此扩展
});
```

原文链接：https://blog.csdn.net/wxf19851985/article/details/84654000
