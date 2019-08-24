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

