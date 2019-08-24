
Backbone 为复杂Javascript应用程序提供模型(models)、集合(collections)、视图(views)的结构。其中模型用于绑定键值数据和自定义事件；集合附有可枚举函数的丰富API； 视图可以声明事件处理函数，并通过RESTful JSON接口连接到应用程序。

backbone.js提供了一套web开发的框架，通过Models进行key-value绑定及custom事件处理,通过Collections提供一套丰富的API用于枚举功能,通过Views来进行事件处理及与现有的Application通过RESTful JSON接口进行交互.它是基于jquery和underscore的一个js框架。
主要组成：

1.model：创建数据，进行数据验证，销毁或者保存到服务器上

2.collection：可以增加元素，删除元素，获取长度，排序，比较等一系列工具方法，说白了就是一个保存 models的集合类

3.view：绑定html模板，绑定界面元素的事件，初始的渲染，模型值改变后的重新渲染和界面元素的销毁等

优势：

1. 将数据和界面很好的分离开来。

2. 将事件的绑定很好的剥离出来，便于管理和迭代。

3. 使得Javascript程序的模块化更加清晰、明了。

![](https://gss2.bdstatic.com/9fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=95ab9f6d4c2309f7f362a54013676796/48540923dd54564e48b96ec0b9de9c82d0584f6f.jpg)

![](https://gss2.bdstatic.com/9fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=83dff51a39dbb6fd3156ed74684dc07d/0b46f21fbe096b6324211fb10c338744ebf8ac13.jpg)


```
Ranger前台分析 (2018-07-26 11:57:18)转载▼
分类： Ranger
一、前台登录流程：
j_spring_security_check跳转
org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
第二种是自定义一个filter让它继承自UsernamePasswordAuthenticationFilter，然后重写attemptAuthentication方法在这个方法中实现验证码的功能，如果验证码错误就抛出一个继承自AuthenticationException的验证吗错误的异常比如（CaptchaException），
然后这个异常就会被SpringSecurity捕获到并将异常信息返回到前台，这种实现起来比较简单
登录认证成功后
在custom-filter中可以使用before|position|after三种方式，将自定义过滤器放在对应名称的位置上，或者位置之前，或者位置之后。

ranger-admin登录后调用的rest接口：
@GET
@Path("/definitions")
@Produces({ "application/json", "application/xml" })

二、RangerAdminServer打开pam鉴权和远程登陆，可以使用Linux用户登陆Ranger管理页面
root用户新建文件/etc/pam.d/ranger-remote，配置如下:
# check authorization
auth       required     pam_unix.so
account    required     pam_unix.so
修改ranger-0.6.0-admin的install.properties参数如下：
#LDAP|ACTIVE_DIRECTORY|UNIX|NONE
authentication_method=NONE 修改为：UNIX
执行setup.sh，或者使用upgrade更新配置脚本，使ranger-admin-site.xml文件的相应配置修改为：
        ranger.authentication.method
        UNIX
重启ranger-0.6.0-usersync，使配置生效

pamCredValidator.c
credValidator.c

三、前台引用require.js
require.js作用：
（1）实现js文件的异步加载，避免网页失去响应；
（2）管理模块之间的依赖性，便于代码的编写和维护。
有人可能会想到，加载这个文件，也可能造成网页失去响应。解决办法有两个，一个是把它放在网页底部加载，另一个是写成下面这样：
　　
async属性表明这个文件需要异步加载，避免网页失去响应。IE不支持这个属性，只支持defer，所以把defer也写上。

require.js其主要API主要是下面三个函数:
define– 该函数用户创建模块。每个模块拥有一个唯一的模块ID，它被用于RequireJS的运行时函数，define函数是一个全局函数，不需要使用requirejs命名空间.
require– 该函数用于读取依赖。同样它是一个全局函数，不需要使用requirejs命名空间.
config– 该函数用于配置RequireJS.

四、ranger-admin web页面点击+号新增service服务：
点击+号新增服务跳转逻辑
1、Router.js中匹配如下：
   "!/service/:serviceType/create" : "serviceCreateAction",

2、serviceCreateAction在Controller.js中实现
   serviceCreateAction :function(serviceTypeId){...}
   
   依次加载：
   RangerServiceDef.js中分两部分：
   ---Service Details :固定写死，
   ---Config Properties :动态加载
      ajax: { 
url: "service/plugins/services",

ServiceCreate_tmpl.html中是service页面的按钮部分

en.js保存的提示信息

点击+号新增服务，后台获取服务配置项代码：ServiceREST.java
@Path("/definitions/{id}")
getServiceDef

Controller.js总的入口：
var view = require('views/service/ServiceCreate');
var RangerServiceDef = require('models/RangerServiceDef');
var RangerService    = require('models/RangerService');

-----ServiceCreate.js
   ServiceForm.js里面实现的是加载服务的页面参数配置
-----BackboneFormDataType.js
formObj = getValidators(formObj, v);此方法是判断输入框是否必填，必填就加*号  mandatory参数为true  则必填
-----ConfigurationList.js
-----RangerServiceDef.js
-----RangerService.js
gautam  pmc commiter
Velmurugan Periasamy


五、ranger加载服务主页
1、Router.js中匹配如下：
   "!/policymanager/:resource" : "serviceManagerAction",
2、serviceManagerAction在Controller.js中实现
serviceManagerAction中最终展示通过如下代码：
var view = require('views/policymanager/ServiceLayout');
App.rContent.show(new view({
  collection : collection,
  type : type
  }));
实现在ServiceLayout.js中
-----RangerServiceList.js
-----RangerServiceListBase.js
-----RangerService.js
-----RangerServiceBase.js
XALinks.js
3、ranger页面加载服务默认的policytype为0
  对应的js代码：XAHelpers.js
-----Handlebars.registerHelper('getServices', function(services, serviceDef) {
var XAEnums = require('utils/XAEnums');
var tr = '', serviceOperationDiv = '';
------>>修改的逻辑，使spark的policytype为1，隐藏access tab页
var serviceType = serviceDef.get('name');
var policyType;
if(serviceType == 'spark'){
policyType = XAEnums.RangerPolicyType.RANGER_MASKING_POLICY_TYPE.value;
}else{
policyType = XAEnums.RangerPolicyType.RANGER_ACCESS_POLICY_TYPE.value;
}
//policyType = XAEnums.RangerPolicyType.RANGER_ACCESS_POLICY_TYPE.value; 
------>>修改的逻辑，使spark的policytype为1，隐藏access tab页
if(!_.isUndefined(services[serviceType])){
_.each(services[serviceType],function(serv){
serviceName = serv.get('name');
if(SessionMgr.isSystemAdmin() || SessionMgr.isKeyAdmin()){
serviceOperationDiv = '
\
\
\
\
'
}
tr += '';
});
}
return tr;
});  

ranger前台service创建页面动态加载输入框，增加提示功能
XAOverrides.js中设置了输入框的格式，例如：TextFiledWithIcon 等

BackboneFormDataType.js
\
'+_.escape(serv.attributes.name)+''+serviceOperationDiv+'\
 

```
