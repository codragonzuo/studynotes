# RangerHdfsAuthorizer

ranger-master\hdfs-agent\src\main\java\org\apache\ranger\authorization\hadoop\RangerHdfsAuthorizer.java

RangerHdfsAuthorizer.java文件里定义下面几个类。

```JAVA
import org.apache.hadoop.hdfs.server.namenode.INodeAttributeProvider;


public class RangerHdfsAuthorizer extends INodeAttributeProvider;
{
    class RangerAccessControlEnforcer implements AccessControlEnforcer
}

class RangerHdfsPlugin extends RangerBasePlugin

class RangerHdfsResource extends RangerAccessResourceImpl 

class RangerHdfsAccessRequest extends RangerAccessRequestImpl 

class RangerHdfsAuditHandler extends RangerDefaultAuditHandler 

```
