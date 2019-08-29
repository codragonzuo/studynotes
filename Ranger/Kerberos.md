
## Kerberos
- HDFS Kerberos

HDFS启用了Kerberos时，需要在Ranger HDFS plugin上进行相关配置。

(1) 创建操作系统用户rangerhdfslookup
(2) 创建Kerberos principal

    rangerhdfslookup: kadmin.local -q 'addprinc -pw rangerhdfslookup rangerhdfslookup@example.com. 

(3) 在ranger HDFS plugin service进行配置

    Ranger repository config user:	rangerhdfslookup@example.com
    Ranger repository config password:	rangerhdfslookup
    common.name.for.certificate: blank
(4) 保存service配置和重启HDFS Service
-  Hbase Kerberos
(1) 创建操作系统用户rangerhbaselookup
(2) 创建Kerberos principal

    rangerhbaselookup: kadmin.local -q 'addprinc -pw rangerhbaselookup rangerhbaselookup@example.com. 

(3) 在ranger HBase plugin service进行配置

    Ranger service config user	rangerhbaselookup@example.com
    Ranger service config password	rangerhbaselookup
    common.name.for.certificate	Blank

(4) 保存service配置和重启HBase Service

- Hive Kerberos

(1) 创建操作系统用户rangerhivelooku
(2) 创建Kerberos principal

    rangerhivelookup: kadmin.local -q 'addprinc -pw rangerhivelookup rangerhivelookup@example.com

(3) 在ranger HBase plugin service进行配置

    Configuration Property Name	Value
    Ranger service config user	rangerhivelookup@example.com
    Ranger service config password	rangerhivelookup
    common.name.for.certificate	blank

(4) 保存service配置和重启Hive Service
