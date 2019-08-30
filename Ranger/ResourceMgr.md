# HdfsResourceMgr

```JAVA
//HdfsResourceMgr.java

public class HdfsResourceMgr {

    public static Map<String, Object> connectionTest(String serviceName, Map<String, String> configs) throws Exception
    public static List<String> getHdfsResources(String serviceName, String serviceType, Map<String, String> configs,ResourceLookupContext context) throws Exception {
}
```

1. ResourceLookupContext里保存了用户进行资源查找的 resourceName, userInput, resources。
2. getHdfsResources调用hdfsClient.listFiles(finalBaseDir,	finalWildCardToMatch, pathList); 返回查询结果。
3. FileSystem##listStatus 返回FileStatus包含了目录下的信息。

```JAVA
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
```

# HBaseResourceMgr

HBaseClient调用hbase的接口获取TableList, ColumnFamilyList, ColumnList.

```JAVA
public class HBaseResourceMgr {
    public static Map<String, Object> connectionTest(String serviceName, Map<String, String> configs) throws Exception
    public static List<String> getHBaseResource(String serviceName, String serviceType, Map<String, String> configs,ResourceLookupContext context) throws Exception
}

///////
import org.apache.hadoop.hbase.*;
import org.apache.hadoop.hbase.client.*;
public class HBaseClient extends BaseClient {

public class HBaseClient extends BaseClient {
    public List<String> getTableList(final String tableNameMatching, final List<String> existingTableList ) throws HadoopException
    public List<String> getColumnFamilyList(final String columnFamilyMatching, final List<String> tableList,final List<String> existingColumnFamilies)
}



```

# HiveSourceMgr

```JAVA
//HiveResourceMgr
public static List<String> getHiveResources(String serviceName, String serviceType, Map<String, String> configs,ResourceLookupContext context) throws Exception  

hiveClient.getDatabaseList(finalDbName, finaldatabaseList);
hiveClient.getTableList(finalTableName,finaldatabaseList,finaltableList);
hiveClient.getColumnList(finalColName,finaldatabaseList,finaltableList,finalcolumnList);

import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hadoop.hive.metastore.HiveMetaStoreClient;
import org.apache.hadoop.hive.metastore.api.FieldSchema;
import org.apache.hadoop.hive.metastore.api.MetaException;
```

