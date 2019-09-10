
```JAVA
public class RangerServiceResourceMatcher implements RangerPolicyResourceEvaluator {

	public RangerPolicyResourceMatcher.MatchType getMatchType(RangerAccessResource requestedResource, Map<String, Object> evalContext) {
		return policyResourceMatcher != null ?  policyResourceMatcher.getMatchType(requestedResource, evalContext) : RangerPolicyResourceMatcher.MatchType.NONE;
	}
	RangerServiceDef getServiceDef() {
		return policyResourceMatcher != null ? policyResourceMatcher.getServiceDef() : null;
	}

	static class IdComparator implements Comparator<RangerServiceResourceMatcher>, Serializable {
		@Override
		public int compare(RangerServiceResourceMatcher me, RangerServiceResourceMatcher other) {
			return Long.compare(me.getId(), other.getId());
		}
	}
```
