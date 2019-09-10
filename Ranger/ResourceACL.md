
# ResourceACLs

- 针对publicGroup, usr, group, role 都有一个map <accessType, AccessResult>
- 对map进行遍历，如果 publicGroup对应的 map 在 map里，并且 accessresult.getIsFinal 非真，就从map里去掉 <accessType, AccessResult>。


```JAVA
public class RangerResourceACLs {

	public void finalizeAcls() {
		Map<String, AccessResult>  publicGroupAccessInfo = groupACLs.get(RangerPolicyEngine.GROUP_PUBLIC);
		if (publicGroupAccessInfo != null) {

			for (Map.Entry<String, AccessResult> entry : publicGroupAccessInfo.entrySet()) {
				String accessType = entry.getKey();
				AccessResult accessResult = entry.getValue();
				int access = accessResult.getResult();

				if (access == ACCESS_DENIED || access == ACCESS_ALLOWED) {
					for (Map.Entry<String, Map<String, AccessResult>> mapEntry : userACLs.entrySet()) {
						Map<String, AccessResult> mapValue = mapEntry.getValue();
						AccessResult savedAccessResult = mapValue.get(accessType);
						if (savedAccessResult != null && !savedAccessResult.getIsFinal()) {
							mapValue.remove(accessType);
						}
					}

					for (Map.Entry<String, Map<String, AccessResult>> mapEntry : groupACLs.entrySet()) {
						if (!StringUtils.equals(mapEntry.getKey(), RangerPolicyEngine.GROUP_PUBLIC)) {
							Map<String, AccessResult> mapValue = mapEntry.getValue();
							AccessResult savedAccessResult = mapValue.get(accessType);
							if (savedAccessResult != null && !savedAccessResult.getIsFinal()) {
								mapValue.remove(accessType);
							}
						}
					}
				}
			}
		}
		finalizeAcls(userACLs);
		finalizeAcls(groupACLs);
		finalizeAcls(roleACLs);
	}
  

```
