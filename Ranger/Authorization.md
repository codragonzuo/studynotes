# Authorization

和HBase的grant、revoke同步
配置中配置了grant、revoke的时候，是否相应的刷新ranger的标记位UpdateRangerPoliciesOnGrantRevoke

```JAVA
UpdateRangerPoliciesOnGrantRevoke = RangerConfiguration.getInstance().getBoolean(RangerHadoopConstants.HBASE_UPDATE_RANGER_POLICIES_ON_GRANT_REVOKE_PROP, RangerHadoopConstants.HBASE_UPDATE_RANGER_POLICIES_ON_GRANT_REVOKE_DEFAULT_VALUE);
RangerAuthorizationCoprocessor实现了CoprocessorService接口，将自己注册进去，监听grant、revoke。

@Override
public Service getService() {
    return AccessControlProtos.AccessControlService.newReflectiveService(this);
}
```

实现了这2个方法，在这2个方法中判断UpdateRangerPoliciesOnGrantRevoke如果为true，就更新下自己的配置。

```JAVA
/**
 * <code>rpc Grant(.GrantRequest) returns (.GrantResponse);</code>
 */
public abstract void grant(
    com.google.protobuf.RpcController controller,
    org.apache.hadoop.hbase.protobuf.generated.AccessControlProtos.GrantRequest request,
    com.google.protobuf.RpcCallback<org.apache.hadoop.hbase.protobuf.generated.AccessControlProtos.GrantResponse> done);
 
/**
 * <code>rpc Revoke(.RevokeRequest) returns (.RevokeResponse);</code>
 */
public abstract void revoke(
    com.google.protobuf.RpcController controller,
    org.apache.hadoop.hbase.protobuf.generated.AccessControlProtos.RevokeRequest request,
    com.google.protobuf.RpcCallback<org.apache.hadoop.hbase.protobuf.generated.AccessControlProtos.RevokeResponse> done);
```




## Hadoop
D:\Project\ranger-master\ranger-hdfs-plugin-shim的RangerHdfsAuthorizer文件。

RangerHdfsAuthorizer 实现了org.apache.hadoop.hdfs.server.namenode.INodeAttributeProvider接口。

```JAVA
package org.apache.ranger.authorization.hadoop;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.hdfs.server.namenode.INodeAttributeProvider;
import org.apache.hadoop.hdfs.server.namenode.INodeAttributes;
import org.apache.ranger.plugin.classloader.RangerPluginClassLoader;

public class RangerHdfsAuthorizer extends INodeAttributeProvider {
	private static final Log LOG  = LogFactory.getLog(RangerHdfsAuthorizer.class);

	private static final String   RANGER_PLUGIN_TYPE                      = "hdfs";
	private static final String   RANGER_HDFS_AUTHORIZER_IMPL_CLASSNAME   = "org.apache.ranger.authorization.hadoop.RangerHdfsAuthorizer";

	private INodeAttributeProvider 	rangerHdfsAuthorizerImpl 		= null;
	private static RangerPluginClassLoader rangerPluginClassLoader  = null;
	
	public RangerHdfsAuthorizer() {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerHdfsAuthorizer.RangerHdfsAuthorizer()");
		}

		this.init();

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerHdfsAuthorizer.RangerHdfsAuthorizer()");
		}
	}

	public void init(){
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerHdfsAuthorizer.init()");
		}

		try {
			
			rangerPluginClassLoader = RangerPluginClassLoader.getInstance(RANGER_PLUGIN_TYPE, this.getClass());
			
			@SuppressWarnings("unchecked")
			Class<INodeAttributeProvider> cls = (Class<INodeAttributeProvider>) Class.forName(RANGER_HDFS_AUTHORIZER_IMPL_CLASSNAME, true, rangerPluginClassLoader);

			activatePluginClassLoader();

			rangerHdfsAuthorizerImpl = cls.newInstance();
		} catch (Exception e) {
			// check what need to be done
			LOG.error("Error Enabling RangerHdfsPlugin", e);
		} finally {
			deactivatePluginClassLoader();
		}

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerHdfsAuthorizer.init()");
		}
	}

	@Override
	public void start() {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerHdfsAuthorizer.start()");
		}

		try {
			activatePluginClassLoader();

			rangerHdfsAuthorizerImpl.start();
		} finally {
			deactivatePluginClassLoader();
		}

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerHdfsAuthorizer.start()");
		}
	}

	@Override
	public void stop() {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerHdfsAuthorizer.stop()");
		}

		try {
			activatePluginClassLoader();

			rangerHdfsAuthorizerImpl.stop();
		} finally {
			deactivatePluginClassLoader();
		}

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerHdfsAuthorizer.stop()");
		}
	}

	@Override
	public INodeAttributes getAttributes(String fullPath, INodeAttributes inode) {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerHdfsAuthorizer.getAttributes(" + fullPath + ")");
		}

		INodeAttributes ret = null;

		try {
			activatePluginClassLoader();

			ret = rangerHdfsAuthorizerImpl.getAttributes(fullPath,inode); // return default attributes
		} finally {
			deactivatePluginClassLoader();
		}

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerHdfsAuthorizer.getAttributes(" + fullPath + "): " + ret);
		}

		return ret;
	}

	@Override
	public INodeAttributes getAttributes(String[] pathElements, INodeAttributes inode) {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerHdfsAuthorizer.getAttributes(pathElementsCount=" + (pathElements == null ? 0 : pathElements.length) + ")");
		}

		INodeAttributes ret = null;

		try {
			activatePluginClassLoader();

			ret = rangerHdfsAuthorizerImpl.getAttributes(pathElements,inode);
		} finally {
			deactivatePluginClassLoader();
		}

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerHdfsAuthorizer.getAttributes(pathElementsCount=" + (pathElements == null ? 0 : pathElements.length) + "): " + ret);
		}

		return ret;
	}

	@Override
	public AccessControlEnforcer getExternalAccessControlEnforcer(AccessControlEnforcer defaultEnforcer) {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerHdfsAuthorizer.getExternalAccessControlEnforcer()");
		}

		AccessControlEnforcer ret = null;

		ret = rangerHdfsAuthorizerImpl.getExternalAccessControlEnforcer(defaultEnforcer);

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerHdfsAuthorizer.getExternalAccessControlEnforcer()");
		}

		return ret;
	}

	private void activatePluginClassLoader() {
		if(rangerPluginClassLoader != null) {
			rangerPluginClassLoader.activate();
		}
	}

	private void deactivatePluginClassLoader() {
		if(rangerPluginClassLoader != null) {
			rangerPluginClassLoader.deactivate();
		}
	}
}

```


# Hive
```JAVA
import org.apache.hadoop.hive.ql.security.authorization.plugin.AbstractHiveAuthorizer;
public abstract class RangerHiveAuthorizerBase extends AbstractHiveAuthorizer {
public class RangerHiveAuthorizer extends RangerHiveAuthorizerBase {
	/**
	 * Check if user has privileges to do this action on these objects
	 * @param hiveOpType
	 * @param inputHObjs
	 * @param outputHObjs
	 * @param context
	 * @throws HiveAuthzPluginException
	 * @throws HiveAccessControlException
	 */
	@Override
	public void checkPrivileges(HiveOperationType         hiveOpType,
								List<HivePrivilegeObject> inputHObjs,
							    List<HivePrivilegeObject> outputHObjs,
							    HiveAuthzContext          context)
	private RangerAccessResult getDataMaskResult(RangerHiveAccessRequest request) {
	private RangerAccessResult getRowFilterResult(RangerHiveAccessRequest request) {	
```
