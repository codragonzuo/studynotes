

### HDFS权限控制函数
```JAVA
public class RangerHdfsAuthorizer extends INodeAttributeProvider {

		@Override
		public void checkPermission(String fsOwner, String superGroup, UserGroupInformation ugi,
									INodeAttributes[] inodeAttrs, INode[] inodes, byte[][] pathByNameArr,
									int snapshotId, String path, int ancestorIndex, boolean doCheckOwner,
									FsAction ancestorAccess, FsAction parentAccess, FsAction access,
									FsAction subAccess, boolean ignoreEmptyDir) throws AccessControlException 
```

### 审计日志
```JAVA


				auditHandler = doNotGenerateAuditRecord ? null : new RangerHdfsAuditHandler(resourcePath, isTraverseOnlyCheck);

				if(auditHandler != null) {
					auditHandler.flushAudit();
				}
```

```JAVA
class RangerHdfsAuditHandler extends RangerDefaultAuditHandler {


//审计日志存储
	public void logAuthzAudit(AuthzAuditEvent auditEvent) {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerDefaultAuditHandler.logAuthzAudit(" + auditEvent + ")");
		}

		if(auditEvent != null) {
			populateDefaults(auditEvent);

			AuditHandler auditProvider = RangerBasePlugin.getAuditProvider(auditEvent.getRepositoryName());//根据事件获取
			if (auditProvider == null || !auditProvider.log(auditEvent)) //存储日志
      {
				MiscUtil.logErrorMessageByInterval(LOG, "fail to log audit event " + auditEvent);
			}
		}

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerDefaultAuditHandler.logAuthzAudit(" + auditEvent + ")");
		}
	}
```

在checkPermission里, 创建RangerHdfsAuditHandler对象。
```JAVA
class RangerHdfsAuditHandler extends RangerDefaultAuditHandler
class RangerHdfsAuditHandler extends RangerDefaultAuditHandler
public class RangerMultiResourceAuditHandler extends RangerDefaultAuditHandler
public class RangerDefaultAuditHandler implements RangerAccessResultProcessor

auditHandler = doNotGenerateAuditRecord ? null : new RangerHdfsAuditHandler(resourcePath, isTraverseOnlyCheck);
```JAVA


RangerDefaultAuditHandler##logAuthzAudit里，auditProvider.log进行日志记录
```JAVA
	public void logAuthzAudit(AuthzAuditEvent auditEvent) {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerDefaultAuditHandler.logAuthzAudit(" + auditEvent + ")");
		}

		if(auditEvent != null) {
			populateDefaults(auditEvent);

			AuditHandler auditProvider = RangerBasePlugin.getAuditProvider(auditEvent.getRepositoryName());
			if (auditProvider == null || !auditProvider.log(auditEvent)) {
				MiscUtil.logErrorMessageByInterval(LOG, "fail to log audit event " + auditEvent);
			}
		}

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerDefaultAuditHandler.logAuthzAudit(" + auditEvent + ")");
		}
	}
```

AuditHandler接口
```JAVA
public interface AuditHandler {
	boolean log(AuditEventBase event);
	boolean log(Collection<AuditEventBase> events);	

	boolean logJSON(String event);
	boolean logJSON(Collection<String> events);	

    void init(Properties prop);
    void init(Properties prop, String basePropertyName);
    void start();
    void stop();
    void waitToComplete();
    void waitToComplete(long timeout);

    /**
     * Name for this provider. Used only during logging. Uniqueness is not guaranteed
     */
    String getName();

    void flush();
}
```



### 事件日志写入
AuthzAuditEvent保存了事件日志的每个字段，并提供了每个字段，整个日志的JSON序列化和反序列化。
```JAVA
public abstract class AuditEventBase {

	protected AuditEventBase() {
	}

	public abstract void persist(DaoManager daoManager);
	
	public abstract String getEventKey();
	public abstract Date getEventTime ();
	public abstract void setEventCount(long eventCount);
	public abstract void setEventDurationMS(long eventDurationMS);
}

public class AuthzAuditEvent extends AuditEventBase ;
```

