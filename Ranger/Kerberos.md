
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


### BaseClient kerberos处理

ranger-master\agents-common\src\main\java\org\apache\ranger\plugin\client\BaseClient.java

```JAVA
public abstract class BaseClient {
	private HadoopConfigHolder configHolder;

	protected void login() {
		ClassLoader prevCl = Thread.currentThread().getContextClassLoader();
		try {
			//Thread.currentThread().setContextClassLoader(configHolder.getClassLoader());
			 String lookupPrincipal = SecureClientLogin.getPrincipal(configHolder.getLookupPrincipal(), java.net.InetAddress.getLocalHost().getCanonicalHostName());
			 String lookupKeytab = configHolder.getLookupKeytab();
			 String nameRules = configHolder.getNameRules();
			 if(StringUtils.isEmpty(nameRules)){
				 if(LOG.isDebugEnabled()){
					 LOG.debug("Name Rule is empty. Setting Name Rule as 'DEFAULT'");
				 }
				 nameRules = DEFAULT_NAME_RULE;
			 }
			 String userName = configHolder.getUserName();
			 if(StringUtils.isEmpty(lookupPrincipal) || StringUtils.isEmpty(lookupKeytab)){
				 if (userName == null) {
					throw createException("Unable to find login username for hadoop environment, [" + serviceName + "]", null);
				 }
				 String keyTabFile = configHolder.getKeyTabFile();
				 if (keyTabFile != null) {
					 if ( configHolder.isKerberosAuthentication() ) {
						 LOG.info("Init Login: security enabled, using username/keytab");
						 loginSubject = SecureClientLogin.loginUserFromKeytab(userName, keyTabFile, nameRules);
					 }
					 else {
						 LOG.info("Init Login: using username");
						 loginSubject = SecureClientLogin.login(userName);
					 }
				 }
				 else {
					 String encryptedPwd = configHolder.getPassword();
					 String password = null;
					 if (encryptedPwd != null) {
					     try {
					         password = PasswordUtils.decryptPassword(encryptedPwd);
					     } catch(Exception ex) {
					         LOG.info("Password decryption failed; trying connection with received password string");
					         password = null;
					     } finally {
					         if (password == null) {
					             password = encryptedPwd;
					         }
					     }
					 } else {
					     LOG.info("Password decryption failed: no password was configured");
					 }
					 if ( configHolder.isKerberosAuthentication() ) {
						 LOG.info("Init Login: using username/password");
						 loginSubject = SecureClientLogin.loginUserWithPassword(userName, password);
					 }
					 else {
						 LOG.info("Init Login: security not enabled, using username");
						 loginSubject = SecureClientLogin.login(userName);
					 }
				 }
			 }else{
				 if ( configHolder.isKerberosAuthentication() ) {
					 LOG.info("Init Lookup Login: security enabled, using lookupPrincipal/lookupKeytab");
					 loginSubject = SecureClientLogin.loginUserFromKeytab(lookupPrincipal, lookupKeytab, nameRules);
				 }else{
					 LOG.info("Init Login: security not enabled, using username");
					 loginSubject = SecureClientLogin.login(userName);
				 }
			 }
		} catch (IOException ioe) {
			throw createException(ioe);
		} catch (SecurityException se) {
			throw createException(se);
		} finally {
			Thread.currentThread().setContextClassLoader(prevCl);
		}
	}
```

service/client 目录结构

ranger下有 authorization/hadoop和services/hdfs/client目录。前者被hadoop调用进行权限授权处理，后者在ranger里调用进行资源获取，连接测试。

```shell
[XXX]  /mnt/d/Project/ranger-master/hdfs-agent
[XXX]  tree
.
+--- .gitignore
+--- conf
|   +--- hdfs-site-changes.cfg
|   +--- ranger-hdfs-audit-changes.cfg
|   +--- ranger-hdfs-audit.xml
|   +--- ranger-hdfs-security-changes.cfg
|   +--- ranger-hdfs-security.xml
|   +--- ranger-policymgr-ssl-changes.cfg
|   +--- ranger-policymgr-ssl.xml
+--- disable-conf
|   +--- hdfs-site-changes.cfg
+--- pom.xml
+--- scripts
|   +--- install.properties
|   +--- install.sh
|   +--- uninstall.sh
+--- src
|   +--- main
|   |   +--- java
|   |   |   +--- org
|   |   |   |   +--- apache
|   |   |   |   |   +--- ranger
|   |   |   |   |   |   +--- authorization
|   |   |   |   |   |   |   +--- hadoop
|   |   |   |   |   |   |   |   +--- exceptions
|   |   |   |   |   |   |   |   |   +--- RangerAccessControlException.java
|   |   |   |   |   |   |   |   +--- HDFSAccessVerifier.java
|   |   |   |   |   |   |   |   +--- RangerHdfsAuthorizer.java
|   |   |   |   |   |   +--- services
|   |   |   |   |   |   |   +--- hdfs
|   |   |   |   |   |   |   |   +--- client
|   |   |   |   |   |   |   |   |   +--- HdfsClient.java
|   |   |   |   |   |   |   |   |   +--- HdfsConnectionMgr.java
|   |   |   |   |   |   |   |   |   +--- HdfsResourceMgr.java
|   |   |   |   |   |   |   |   +--- RangerServiceHdfs.java
|   |   +--- resources
|   |   |   +--- META-INF
|   |   |   |   +--- MANIFEST.MF
|   +--- test
|   |   +--- java
|   |   |   +--- org
|   |   |   |   +--- apache
|   |   |   |   |   +--- ranger
|   |   |   |   |   |   +--- services
|   |   |   |   |   |   |   +--- hdfs
|   |   |   |   |   |   |   |   +--- client
|   |   |   |   |   |   |   |   |   +--- HdfsClientTest.java
|   |   |   |   |   |   |   |   +--- HDFSRangerTest.java
|   |   |   |   |   |   |   |   +--- RangerAdminClientImpl.java
|   |   |   |   |   |   |   |   +--- RangerHdfsAuthorizerTest.java
|   |   +--- resources
|   |   |   +--- hdfs-policies-tag.json
|   |   |   +--- hdfs-policies.json
|   |   |   +--- hdfs_version_3.0
|   |   |   |   +--- hdfs-policies-tag.json
|   |   |   |   +--- hdfs-policies.json
|   |   |   +--- log4j.properties
|   |   |   +--- ranger-hdfs-security.xml

```
