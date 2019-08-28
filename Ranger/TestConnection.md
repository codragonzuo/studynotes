
POST /ranger-admin/service/plugins/services/validateConfig

```JAVA
public class HdfsClient extends BaseClient {
	public static Map<String, Object> connectionTest(String serviceName,
			Map<String, String> configs) throws Exception {

	LOG.info("===> HdfsClient.connectionTest()" );
    Map<String, Object> responseData = new HashMap<String, Object>();
    boolean connectivityStatus = false;

    String validateConfigsMsg = null;
    try {
      validateConnectionConfigs(configs);
    } catch (IllegalArgumentException e)  {
      validateConfigsMsg = e.getMessage();
    }

    if (validateConfigsMsg == null) {

		  HdfsClient connectionObj = new HdfsClient(serviceName, configs);
		  if (connectionObj != null) {
			List<String> testResult = null;
			try {
				 testResult = connectionObj.listFiles("/", null,null);
			} catch (HadoopException e) {
				LOG.error("<== HdfsClient.connectionTest() error " + e.getMessage(),e );
					throw e;
			}

			if (testResult != null && testResult.size() != 0) {
			  	connectivityStatus = true;
			}
		}
    }
        String testconnMsg = null;
		if (connectivityStatus) {
			testconnMsg = "ConnectionTest Successful";
			generateResponseDataMap(connectivityStatus, testconnMsg, testconnMsg,
					null, null, responseData);
		} else {
			testconnMsg = "Unable to retrieve any files using given parameters, "
				+ "You can still save the repository and start creating policies, "
				+ "but you would not be able to use autocomplete for resource names. "
				+ "Check ranger_admin.log for more info. ";
      String additionalMsg = (validateConfigsMsg != null)  ?
        validateConfigsMsg : testconnMsg;
			generateResponseDataMap(connectivityStatus, testconnMsg, additionalMsg,
					null, null, responseData);
		}
		LOG.info("<== HdfsClient.connectionTest(): Status " + testconnMsg );
		return responseData;
	}
```
