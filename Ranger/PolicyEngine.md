
策略引擎

RangerPolicyEngine把要对策略进行处理的接口抽象处理， 然后在具体插件中进行具体的处理。
好像没干啥具体的活？？

RangerPolicyEngineImpl#isAccessAllowed中会从RangerPolicyRepository中查找该资源的所有Policy，遍历执行RangerDefaultPolicyEvaluator#evaluatePolicyItems，来进行评估是否有权限访问。遍历过程中如果发现了匹配的规则，决定了deny还是allow，遍历就会break。每一次的遍历先从denyEvaluators里查找匹配的deny权限，如果没有找到，就从allowEvaluators里查找匹配的allow权限。



# evaluator处理

```JAVA
public class RangerPolicyEngineImpl implements RangerPolicyEngine {

	public RangerAccessResult evaluatePolicies(RangerAccessRequest request, int policyType, RangerAccessResultProcessor resultProcessor) {
	public Collection<RangerAccessResult> evaluatePolicies(Collection<RangerAccessRequest> requests, int policyType, RangerAccessResultProcessor resultProcessor) {
```

