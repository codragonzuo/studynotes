
策略引擎

RangerPolicyEngine把要对策略进行处理的接口抽象处理， 然后在具体插件中进行具体的处理。
好像没干啥具体的活？？

RangerPolicyEngineImpl#isAccessAllowed中会从RangerPolicyRepository中查找该资源的所有Policy，遍历执行RangerDefaultPolicyEvaluator#evaluatePolicyItems，来进行评估是否有权限访问。

在同一类型的Evaluators中只需找出一个就可以。

```JAVA
RangerHdfsAuthorizer##checkPermission
RangerHdfsAuthorizer##isAccessAllowed
RangerAccessResult result = plugin.isAccessAllowed(request, auditHandler);
RangerBasePlugin##isAccessAllowed
RangerPolicyEngine##isAccessAllowed
RangerPolicyEngineImpl##isAccessAllowed
RangerDefaultPolicyEvaluator##isAccessAllowed
RangerDefaultPolicyEvaluator##getDeterminingPolicyItem
```
901行的isAccessAllowed进行估算
```JAVA
public boolean isAccessAllowed(RangerPolicy policy, String user, Set<String> userGroups, Set<String> roles, String accessType) {
```


RangerDefaultPolicyEvaluator.java里，调用isAccessAllowed进行判断，再调用getDeterminingPolicyItem。
```JAVA
//RangerDefaultPolicyEvaluator
protected boolean isAccessAllowed(String user, Set<String> userGroups, Set<String> roles, String accessType) {

       RangerPolicyItemEvaluator item = this.getDeterminingPolicyItem(user, userGroups, roles, accessType);
```

## getDeterminingPolicyItem找到匹配的Item
getDeterminingPolicyItem里先进行getMatchingPolicyItem    denyEvaluators和denyExceptionEvaluators判断，再进行allowEvaluators和allowExceptionEvaluators。找到匹配的Item。
```JAVA
RangerDefaultPolicyEvaluator##getDeterminingPolicyItem
	/*
	 *  1. if a deny matches without hitting any deny-exception, return that
	 *  2. if an allow matches without hitting any allow-exception, return that
	 */
	ret = getMatchingPolicyItem(user, userGroups, roles, accessType, , denyExceptionEvaluators);

	if(ret == null) {
		ret = getMatchingPolicyItem(user, userGroups, roles, accessType, allowEvaluators, allowExceptionEvaluators);
	}
```

## 在item中如何判断匹配
**同时判断User,Group,Role, AccessType,是AND关系**
```
//RangerDefaultPolicyEvaluator
//1169行
	private <T extends RangerPolicyItemEvaluator> T getMatchingPolicyItem(String user, Set<String> userGroups, Set<String> roles, String accessType, List<T> evaluators, List<T> exceptionEvaluators) {
//同时判断User,Group,Role, AccessType,是AND关系
                if(exceptionEvaluator.matchUserGroup(user, userGroups, roles) && exceptionEvaluator.matchAccessType(accessType)) {
```
## 算法


```
private List<RangerPolicyItemEvaluator> allowEvaluators;
private List<RangerPolicyItemEvaluator> denyEvaluators;
private List<RangerPolicyItemEvaluator> allowExceptionEvaluators;
private List<RangerPolicyItemEvaluator> denyExceptionEvaluators;
```

item 调用IsMatch, IsMatch里进行了matchUserGroupAndOwner 和 matchCustomConditions。
```
D:\Project\ranger-master\agents-common\src\main\java\org\apache\ranger\plugin\policyevaluator\RangerDefaultPolicyItemEvaluator.java
	@Override
	public boolean isMatch(RangerAccessRequest request) {
		if(LOG.isDebugEnabled()) {
			LOG.debug("==> RangerDefaultPolicyItemEvaluator.isMatch(" + request + ")");
		}

		boolean ret = false;

		RangerPerfTracer perf = null;

		if(RangerPerfTracer.isPerfTraceEnabled(PERF_POLICYITEM_REQUEST_LOG)) {
			perf = RangerPerfTracer.getPerfTracer(PERF_POLICYITEM_REQUEST_LOG, "RangerPolicyItemEvaluator.isMatch(resource=" + request.getResource().getAsString()  + ")");
		}

		if(policyItem != null) {
			if(matchUserGroupAndOwner(request)) {
				if (request.isAccessTypeDelegatedAdmin()) { // used only in grant/revoke scenario
					if (policyItem.getDelegateAdmin()) {
						ret = true;
					}
				} else if (CollectionUtils.isNotEmpty(policyItem.getAccesses())) {
					boolean isAccessTypeMatched = false;

					if (request.isAccessTypeAny()) {
						if (getPolicyItemType() == POLICY_ITEM_TYPE_DENY || getPolicyItemType() == POLICY_ITEM_TYPE_DENY_EXCEPTIONS) {
							if (hasAllPerms) {
								isAccessTypeMatched = true;
							}
						} else {
							for (RangerPolicy.RangerPolicyItemAccess access : policyItem.getAccesses()) {
								if (access.getIsAllowed()) {
									isAccessTypeMatched = true;
									break;
								}
							}
						}
					} else {
						for (RangerPolicy.RangerPolicyItemAccess access : policyItem.getAccesses()) {
							if (access.getIsAllowed() && StringUtils.equalsIgnoreCase(access.getType(), request.getAccessType())) {
								isAccessTypeMatched = true;
								break;
							}
						}
					}

					if(isAccessTypeMatched) {
						if(matchCustomConditions(request)) {
							ret = true;
						}
					}
				}
			}
		}

		RangerPerfTracer.log(perf);

		if(LOG.isDebugEnabled()) {
			LOG.debug("<== RangerDefaultPolicyItemEvaluator.isMatch(" + request + "): " + ret);
		}

		return ret;
	}
```

## conditionEvaluator  调用
RangerDefaultPolicyItemEvaluator里matchCustomConditions调用conditionEvaluator  
```JAVA
//RangerDefaultPolicyItemEvaluator
//public boolean matchCustomConditions(RangerAccessRequest request)
boolean conditionEvalResult = conditionEvaluator.isMatched(request);
```

# evaluator处理

## 如何生成evaluator

 RangerPolicyRepository里根据policyId来生成对应的evaluator，有几个policyId, 就产生对应的evaluator
``` 
// RangerPolicyRepository
RangerPolicyEvaluator addPolicy(RangerPolicy policy)
private RangerPolicyEvaluator buildPolicyEvaluator(RangerPolicy policy, RangerServiceDef serviceDef, RangerPolicyEngineOptions options) 
```

可能有两种类型，RangerCachedPolicyEvaluator和RangerOptimizedPolicyEvaluator
``` 
        if(StringUtils.equalsIgnoreCase(options.evaluatorType, RangerPolicyEvaluator.EVALUATOR_TYPE_CACHED)) {
            ret = new RangerCachedPolicyEvaluator();
        } else {
            ret = new RangerOptimizedPolicyEvaluator();
        }

        ret.init(policy, serviceDef, options);
```
RangerOptimizedPolicyEvaluator的init进行初始化

Init提取需要预处理的信息。
```
//RangerOptimizedPolicyEvaluator
void init(RangerPolicy policy, RangerServiceDef serviceDef, RangerPolicyEngineOptions options)
```

# PolicyRepository 策略仓库里保存估算器表
```
    private List<RangerPolicyEvaluator>       policyEvaluators;
    private List<RangerPolicyEvaluator>       dataMaskPolicyEvaluators;
    private List<RangerPolicyEvaluator>       rowFilterPolicyEvaluators;
```

## 估算器调用流程

RangerPolicyEngineImpl进行估算
```JAVA
public class RangerPolicyEngineImpl implements RangerPolicyEngine {

	public RangerAccessResult evaluatePolicies(RangerAccessRequest request, int policyType, RangerAccessResultProcessor resultProcessor) {
	public Collection<RangerAccessResult> evaluatePolicies(Collection<RangerAccessRequest> requests, int policyType, RangerAccessResultProcessor resultProcessor) {

```

RangerPolicyEngineImpl里evaluatePoliciesNoAudit进行估算。
```JAVA


 private RangerAccessResult evaluatePoliciesNoAudit(RangerAccessRequest request, int policyType, String zoneName, RangerPolicyRepository policyRepository, RangerPolicyRepository tagPolicyRepository) {



                List<RangerPolicyEvaluator> evaluators = policyRepository.getLikelyMatchPolicyEvaluators(request.getResource(), policyType);
                for (RangerPolicyEvaluator evaluator : evaluators) {
		evaluator.evaluate(request, ret);
```
在evaluatePoliciesNoAudit，遍历所有的估算器进行估算。

```JAVA



    private RangerAccessResult evaluatePoliciesNoAudit(RangerAccessRequest request, int policyType, String zoneName, RangerPolicyRepository policyRepository, RangerPolicyRepository tagPolicyRepository) {


public class RangerDefaultPolicyEvaluator extends RangerAbstractPolicyEvaluator {


evaluatePolicies->zoneAwareAccessEvaluationWithNoAudit->evaluatePoliciesNoAudit
->evaluateTagPolicies ->evaluator.evaluate(tagEvalRequest, tagEvalResult);

public class RangerDefaultPolicyEvaluator extends RangerAbstractPolicyEvaluator {
RangerDefaultPolicyEvaluator##evaluate(RangerAccessRequest request, RangerAccessResult result)

evaluatePolicyItems(request, matchType, result);
->RangerPolicyItemEvaluator matchedPolicyItem = getMatchingPolicyItem(request, result);
->RangerPolicyItemEvaluator::updateAccessResult




```

getResourceACLs查找所有符合资源匹配的的ACL

```
	public RangerResourceACLs getResourceACLs(RangerAccessRequest request) {
``
