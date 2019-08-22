

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

