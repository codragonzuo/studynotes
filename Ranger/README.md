

## 策略定时更新
### 在RangerBasePlugin::init里启动策略定时更新任务

```JAVA
class RangerBasePlugin
    private Timer                     policyDownloadTimer;
    private final BlockingQueue<DownloadTrigger> policyDownloadQueue = new LinkedBlockingQueue<>();
    private final BlockingQueue<DownloadTrigger> policyDownloadQueue = new LinkedBlockingQueue<>();
    private final DownloadTrigger                accessTrigger       = new DownloadTrigger();
```
BlockingQueue即阻塞队列，它是基于ReentrantLock，利用它可以实现生产者与消费者模式。

成产者：队列满了，等待直到队列有可用空间。

消费者：队列空了，等待直到队列有新的资源。

BlockingQueue的主要区别在于在存储结构上或对元素操作上的不同，但是对于take与put操作的原理，却是类似的。

```
offer(E e)：如果队列没满，立即返回true； 如果队列满了，立即返回false-->不阻塞
put(E e)：如果队列满了，一直阻塞，直到队列不满了或者线程被中断-->阻塞
offer(E e, long timeout, TimeUnit unit)：在队尾插入一个元素,，如果队列已满，则进入等待，直到出现以下三种情况：-->阻塞
被唤醒
等待时间超时
当前线程被中断
出队
poll()：如果没有元素，直接返回null；如果有元素，出队
take()：如果队列空了，一直阻塞，直到队列不为空或者线程被中断-->阻塞
poll(long timeout, TimeUnit unit)：如果队列不空，出队；如果队列已空且已经超时，返回null；如果队列已空且时间未超时，则进入等待，直到出现以下三种情况：
被唤醒
等待时间超时
当前线程被中断

```

DownloadTrigger用于synchronized 信号通知。
```JAVA
package org.apache.ranger.plugin.util;

public final class DownloadTrigger {
    private boolean isNotified = false;

    public synchronized void waitForCompletion() throws InterruptedException {
        while (!isNotified) {
            wait();
        }
        isNotified = false;
    }

    public synchronized void signalCompletion() {
        isNotified = true;
        notifyAll();
    }
}
```

```java
public void refreshPoliciesAndTags() 
```
- setPolicies

获取当前策略引擎

- getDefaultSvcPolicies

setPolicies里，如果当前策略为空，取缺省策略。

```java
	private ServicePolicies getDefaultSvcPolicies() {
		ServicePolicies ret = null;

		RangerServiceDef serviceDef = getServiceDef();
		if (serviceDef == null) {
			serviceDef = getDefaultServiceDef();
		}
		if (serviceDef != null) {
			ret = new ServicePolicies();
			ret.setServiceDef(serviceDef);
			ret.setServiceName(serviceName);
			ret.setPolicies(new ArrayList<RangerPolicy>());
		}
		return ret;
	}
```

```JAVA
public void init() {

		policyDownloadTimer = new Timer("policyDownloadTimer", true);

		try {
			policyDownloadTimer.schedule(new DownloaderTask(policyDownloadQueue), pollingIntervalMs, pollingIntervalMs);
			if (LOG.isDebugEnabled()) {
				LOG.debug("Scheduled policyDownloadRefresher to download policies every " + pollingIntervalMs + " milliseconds");
			}
		} catch (IllegalStateException exception) {
			LOG.error("Error scheduling policyDownloadTimer:", exception);
			LOG.error("*** Policies will NOT be downloaded every " + pollingIntervalMs + " milliseconds ***");
			policyDownloadTimer = null;
		}
}
```

```JAVA
//有两种AbstractRangerAdminClient接口的实现类
public class RangerAdminJersey2RESTClient extends AbstractRangerAdminClient 
public class RangerAdminRESTClient extends AbstractRangerAdminClient 
```

在ranger-hbase-security.xml定义策略源
```XML

	<property>
		<name>ranger.plugin.hbase.policy.source.impl</name>
		<value>org.apache.ranger.admin.client.RangerAdminRESTClient</value>
		<description>
			Class to retrieve policies from the source
		</description>
	</property>
```

```
//public class RangerBasePlugin {
//创建RangerAdminClient对象
//
public static RangerAdminClient createAdminClient(String rangerServiceName, String applicationId, String propertyPrefix) {
//createAdminClient实现中，先检查配置文件是否有对应插件指定的AdminClient
//如果没有，就使用RangerAdminRESTClient
		if(ret == null) {
			ret = new RangerAdminRESTClient();
		}

		ret.init(rangerServiceName, applicationId, propertyPrefix);
```

```JAVA
public class RangerAdminClientImpl extends AbstractRangerAdminClient {
    private static final Logger LOG = LoggerFactory.getLogger(RangerAdminClientImpl.class);
    private final static String cacheFilename = "storm-policies.json";
    private final static String tagFilename = "storm-policies-tag.json";
    private Gson gson;

    public void init(String serviceName, String appId, String configPropertyPrefix) {
        Gson gson = null;
        try {
            gson = new GsonBuilder().setDateFormat("yyyyMMdd-HH:mm:ss.SSS-Z").setPrettyPrinting().create();
        } catch(Throwable excp) {
            LOG.error("RangerAdminClientImpl: failed to create GsonBuilder object", excp);
        }
        this.gson = gson;
    }

    public ServicePolicies getServicePoliciesIfUpdated(long lastKnownVersion, long lastActivationTimeInMillis) throws Exception {

        String basedir = System.getProperty("basedir");
        if (basedir == null) {
            basedir = new File(".").getCanonicalPath();
        }

        java.nio.file.Path cachePath = FileSystems.getDefault().getPath(basedir, "/src/test/resources/" + cacheFilename);
        byte[] cacheBytes = Files.readAllBytes(cachePath);

        return gson.fromJson(new String(cacheBytes), ServicePolicies.class);
    }
```

GSON可以将JSON数据转化成JAVA对象。
