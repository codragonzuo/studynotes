# logstash采集日志配置文件

采集配置

创建配置文件,编写内容

     1.采集目录的数据

```
   input {

       file {

                type => "my_type"                                类型
                path => "/root/data/1.txt"                    路径
                discover_interval => 10                        多久检测一次是否有新数据
                start_position => "beginning"              采集位置(开始位置)
                codec => json {                                     数据格式(json格式,可以不选)
                         charset => "UTF-8"
                }         

        }

   }
```

    2.采集kafka里面的数据

```
    input {
        kafka {
                codec => "plain"                                    格式为空,默认
                group_id => "group01"                         组id
                auto_offset_reset => "earliest"              采集的起始偏移量,最初
                topics  => ["testxp"]                               采集的topic
                bootstrap_servers => ["mini1:9092,mini2:9092,mini3:9092"]        kafka服务地址
        }

   }
```

3.标准输入采集

   input{
        stdin{}

   }

 

存储

    1.标准输出

```
        output{
             stdout {}
        }
```
 

    2.存储到kafka中
```
    output {
         kafka {
             topic_id => "accesslog"
             bootstrap_servers => ["mini1:9092,mini2:9092,mini3:9092"]
        }

    }
```
    3.存储到
```
        output {
           elasticsearch {
               index => "game-%{+YYYY.MM.dd}"                                                       索引名称
               hosts => ["mini1:9200","mini2:9200","mini3:9200"]                               集群地址
          }
       }
```
 

 

执行方式:                          (<logstash>:表示logstash的根目录)
```
        <logstash>:      bin/logstash -f  配置文件
```
