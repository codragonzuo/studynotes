



```JAVA
//有两种AbstractRangerAdminClient接口的实现类
public class RangerAdminJersey2RESTClient extends AbstractRangerAdminClient 
public class RangerAdminRESTClient extends AbstractRangerAdminClient 
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
