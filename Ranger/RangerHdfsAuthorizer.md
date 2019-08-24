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
  
  
  
//在start函数里建立文件系统权限和Ranger定义权限的对应关系
		access2ActionListMapper.put(FsAction.NONE,          new HashSet<String>());
		access2ActionListMapper.put(FsAction.ALL,           Sets.newHashSet(READ_ACCCESS_TYPE, WRITE_ACCCESS_TYPE, EXECUTE_ACCCESS_TYPE));
		access2ActionListMapper.put(FsAction.READ,          Sets.newHashSet(READ_ACCCESS_TYPE));
		access2ActionListMapper.put(FsAction.READ_WRITE,    Sets.newHashSet(READ_ACCCESS_TYPE, WRITE_ACCCESS_TYPE));
		access2ActionListMapper.put(FsAction.READ_EXECUTE,  Sets.newHashSet(READ_ACCCESS_TYPE, EXECUTE_ACCCESS_TYPE));
		access2ActionListMapper.put(FsAction.WRITE,         Sets.newHashSet(WRITE_ACCCESS_TYPE));
		access2ActionListMapper.put(FsAction.WRITE_EXECUTE, Sets.newHashSet(WRITE_ACCCESS_TYPE, EXECUTE_ACCCESS_TYPE));
		access2ActionListMapper.put(FsAction.EXECUTE,       Sets.newHashSet(EXECUTE_ACCCESS_TYPE));
```

- AccessControlEnforcer接口里的方法只有checkPermission
```JAVA
  /**
   * The AccessControlEnforcer allows implementations to override the
   * default File System permission checking logic enforced on a file system
   * object
   */
  public interface AccessControlEnforcer {

    /**
     * Checks permission on a file system object. Has to throw an Exception
     * if the filesystem object is not accessessible by the calling Ugi.
     * @param fsOwner Filesystem owner (The Namenode user)
     * @param supergroup super user geoup
     * @param callerUgi UserGroupInformation of the caller
     * @param inodeAttrs Array of INode attributes for each path element in the
     *                   the path
     * @param inodes Array of INodes for each path element in the path
     * @param pathByNameArr Array of byte arrays of the LocalName
     * @param snapshotId the snapshotId of the requested path
     * @param path Path String
     * @param ancestorIndex Index of ancestor
     * @param doCheckOwner perform ownership check
     * @param ancestorAccess The access required by the ancestor of the path.
     * @param parentAccess The access required by the parent of the path.
     * @param access The access required by the path.
     * @param subAccess If path is a directory, It is the access required of
     *                  the path and all the sub-directories. If path is not a
     *                  directory, there should ideally be no effect.
     * @param ignoreEmptyDir Ignore permission checking for empty directory?
     * @throws AccessControlException
     */
    public abstract void checkPermission(String fsOwner, String supergroup,
        UserGroupInformation callerUgi, INodeAttributes[] inodeAttrs,
        INode[] inodes, byte[][] pathByNameArr, int snapshotId, String path,
        int ancestorIndex, boolean doCheckOwner, FsAction ancestorAccess,
        FsAction parentAccess, FsAction access, FsAction subAccess,
        boolean ignoreEmptyDir)
            throws AccessControlException;

  }
```

authzStatus需要根据ancestorAccess,parentAccess,access,subAccess来综合判断。

- ancestorIndex
- ancestorAccess
- parentAccess
- access
- subAccess
