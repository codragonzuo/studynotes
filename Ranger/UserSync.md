# UserSync

UserSync定期从LDAP/Unix/File中加载用户，上报给RangerAdmin

```Shell
./ Project/ranger-master/ugsync
[XXX] ➤ tree
.
+--- .gitignore
+--- filesourceusersynctool
|   +--- run-filesource-usersync.sh
+--- ldapconfigchecktool
|   +--- ldapconfigcheck
|   |   +--- .gitignore
|   |   +--- conf
|   |   |   +--- input.properties
|   |   +--- pom.xml
|   |   +--- scripts
|   |   |   +--- run.sh
|   |   +--- src
|   |   |   +--- main
|   |   |   |   +--- java
|   |   |   |   |   +--- org
|   |   |   |   |   |   +--- apache
|   |   |   |   |   |   |   +--- ranger
|   |   |   |   |   |   |   |   +--- ldapconfigcheck
|   |   |   |   |   |   |   |   |   +--- AuthenticationCheck.java
|   |   |   |   |   |   |   |   |   +--- CommandLineOptions.java
|   |   |   |   |   |   |   |   |   +--- LdapConfig.java
|   |   |   |   |   |   |   |   |   +--- LdapConfigCheckMain.java
|   |   |   |   |   |   |   |   |   +--- UserSync.java
+--- pom.xml
+--- src
|   +--- main
|   |   +--- java
|   |   |   +--- org
|   |   |   |   +--- apache
|   |   |   |   |   +--- ranger
|   |   |   |   |   |   +--- ldapusersync
|   |   |   |   |   |   |   +--- process
|   |   |   |   |   |   |   |   +--- CustomSSLSocketFactory.java
|   |   |   |   |   |   |   |   +--- LdapDeltaUserGroupBuilder.java
|   |   |   |   |   |   |   |   +--- LdapPolicyMgrUserGroupBuilder.java
|   |   |   |   |   |   |   |   +--- LdapUserGroupBuilder.java
|   |   |   |   |   |   |   |   +--- PolicyMgrUserGroupBuilder.java
|   |   |   |   |   |   +--- unixusersync
|   |   |   |   |   |   |   +--- config
|   |   |   |   |   |   |   |   +--- UserGroupSyncConfig.java
|   |   |   |   |   |   |   +--- model
|   |   |   |   |   |   |   |   +--- FileSyncSourceInfo.java
|   |   |   |   |   |   |   |   +--- GetXGroupListResponse.java
|   |   |   |   |   |   |   |   +--- GetXUserGroupListResponse.java
|   |   |   |   |   |   |   |   +--- GetXUserListResponse.java
|   |   |   |   |   |   |   |   +--- GroupUserInfo.java
|   |   |   |   |   |   |   |   +--- LdapSyncSourceInfo.java
|   |   |   |   |   |   |   |   +--- MUserInfo.java
|   |   |   |   |   |   |   |   +--- UgsyncAuditInfo.java
|   |   |   |   |   |   |   |   +--- UnixSyncSourceInfo.java
|   |   |   |   |   |   |   |   +--- UserGroupInfo.java
|   |   |   |   |   |   |   |   +--- UserGroupList.java
|   |   |   |   |   |   |   |   +--- XGroupInfo.java
|   |   |   |   |   |   |   |   +--- XUserGroupInfo.java
|   |   |   |   |   |   |   |   +--- XUserInfo.java
|   |   |   |   |   |   |   +--- poc
|   |   |   |   |   |   |   |   +--- InvalidGroupException.java
|   |   |   |   |   |   |   |   +--- InvalidUserException.java
|   |   |   |   |   |   |   |   +--- ListRangerUser.java
|   |   |   |   |   |   |   |   +--- ListRangerUserGroup.java
|   |   |   |   |   |   |   |   +--- ListUserGroupTest.java
|   |   |   |   |   |   |   |   +--- ListUserTest.java
|   |   |   |   |   |   |   |   +--- RangerClientUserGroupMapping.java
|   |   |   |   |   |   |   |   +--- RangerJSONParser.java
|   |   |   |   |   |   |   |   +--- RangerUserGroupMapping.java
|   |   |   |   |   |   |   |   +--- RestClientPost.java
|   |   |   |   |   |   |   +--- process
|   |   |   |   |   |   |   |   +--- FileSourceUserGroupBuilder.java
|   |   |   |   |   |   |   |   +--- PolicyMgrUserGroupBuilder.java
|   |   |   |   |   |   |   |   +--- UnixUserGroupBuilder.java
|   |   |   |   |   |   +--- usergroupsync
|   |   |   |   |   |   |   +--- AbstractMapper.java
|   |   |   |   |   |   |   +--- AbstractUserGroupSource.java
|   |   |   |   |   |   |   +--- Mapper.java
|   |   |   |   |   |   |   +--- RegEx.java
|   |   |   |   |   |   |   +--- UserGroupSink.java
|   |   |   |   |   |   |   +--- UserGroupSource.java
|   |   |   |   |   |   |   +--- UserGroupSync.java
|   +--- test
|   |   +--- java
|   |   |   +--- org
|   |   |   |   +--- apache
|   |   |   |   |   +--- ranger
|   |   |   |   |   |   +--- unixusersync
|   |   |   |   |   |   |   +--- process
|   |   |   |   |   |   |   |   +--- TestFileSourceUserGroupBuilder.java
|   |   |   |   |   |   |   |   +--- TestUnixUserGroupBuilder.java
|   |   |   |   |   |   +--- usergroupsync
|   |   |   |   |   |   |   +--- LdapPolicyMgrUserGroupBuilderTest.java
|   |   |   |   |   |   |   +--- PolicyMgrUserGroupBuilderTest.java
|   |   |   |   |   |   |   +--- TestLdapUserGroup.java
|   |   |   |   |   |   |   +--- TestRegEx.java
|   |   +--- resources
|   |   |   +--- ADSchema.ldif
|   |   |   +--- groupFile.txt
|   |   |   +--- passwordFile.txt
|   |   |   +--- ranger-ugsync-site.xml
|   |   |   +--- usergroups-dns.csv
|   |   |   +--- usergroups-other-delim.csv
|   |   |   +--- usergroups.csv
|   |   |   +--- usergroups.json
```
───

