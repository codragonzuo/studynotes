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

- INodeAttributeProvider 的start 和 stop方法
```JAVA
  /**
   * Initialize the provider. This method is called at NameNode startup
   * time.
   */
  public abstract void start();

  /**
   * Shutdown the provider. This method is called at NameNode shutdown time.
   */
  public abstract void stop();
```
- getAttributes
- getExternalAccessControlEnforcer
```JAVA
  public INodeAttributes getAttributes(String fullPath, INodeAttributes inode) {
    return getAttributes(getPathElements(fullPath), inode);
  }

  public abstract INodeAttributes getAttributes(String[] pathElements,
      INodeAttributes inode);

  /**
   * Can be over-ridden by implementations to provide a custom Access Control
   * Enforcer that can provide an alternate implementation of the
   * default permission checking logic.
   * @param defaultEnforcer The Default AccessControlEnforcer
   * @return The AccessControlEnforcer to use
   */
  public AccessControlEnforcer getExternalAccessControlEnforcer(
      AccessControlEnforcer defaultEnforcer) {
    return defaultEnforcer;
  }
```

**在重载的getExternalAccessControlEnforcer里返回的AccessControlEnforcer RangerAccessControlEnforcer 在执行自定义的权限控制。**

```JAVA
	@Override
	public AccessControlEnforcer getExternalAccessControlEnforcer(AccessControlEnforcer defaultEnforcer) {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerHdfsAuthorizer.getExternalAccessControlEnforcer()");
		}

		RangerAccessControlEnforcer rangerAce = new RangerAccessControlEnforcer(defaultEnforcer);

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerHdfsAuthorizer.getExternalAccessControlEnforcer()");
		}

		return rangerAce;
	}
```

## HADOOP HDFS文件权限枚举类型 和 文件系统权限命令对应关系
···
import org.apache.hadoop.fs.permission.FsAction;

```JAVA

public enum FsAction {
  // POSIX style
  NONE("---"),
  EXECUTE("--x"),
  WRITE("-w-"),
  WRITE_EXECUTE("-wx"),
  READ("r--"),
  READ_EXECUTE("r-x"),
  READ_WRITE("rw-"),
  ALL("rwx");
```

