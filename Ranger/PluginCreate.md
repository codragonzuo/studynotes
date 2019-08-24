
# 自定义插件


```
ranger:创建插件配置流程
1. Router.js的appRoutes存在如下映射
    "!/service/:serviceType/create"     : "serviceCreateAction",
  serviceCreateAction函数在Controller.js中定义并实现，通过RangerServiceDef.js，使用restful从org.apache.ranger.rest.ServiceREST的public RangerServiceDef updateServiceDef(RangerServiceDef serviceDef)接口获取。
2. 客户端流程
    客户端点击某个插件的+按钮，该按钮通过Router.js路由到Controller.js中的serviceCreateAction，
    然后通过RangerServiceDef.js、RangerServiceDefBase.js提供的restful，使用XAGlobals.baseURL + 'plugins/definitions'，
    配合ID，提交到后台，后台解析结果返回客户端。
3. 服务端流程
  org.apache.ranger.rest.ServiceREST的public RangerServiceDef updateServiceDef(RangerServiceDef serviceDef)接口接受请求。
  
  根据ID分别从表x_service_config_def、x_resource_def、x_access_type_def、x_policy_condition_def、
  x_context_enricher_def、x_enum_def、x_datamask_type_def中获取对应id的数据。
```
