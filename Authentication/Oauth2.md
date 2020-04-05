## HTTP认证方式
Basic　authentication  
Digest　authentication  
WSSE(WS-Security) HTTP authentication  
token　Authentication  
OAuth1.0 Authentication  
OAuth2.0 Authentication  
Kerberos  
NTLM  
Hawk Authentication  
AWS Signature  
https  

链接：https://www.jianshu.com/p/18fb07f2f65e

HTTP认证模式：Basic and Digest Access Authentication

https://www.cnblogs.com/XiongMaoMengNan/p/6671206.html



## OAuth 2.0 的四种方式

OAuth 2.0 规定了四种获得令牌的流程。你可以选择最适合自己的那一种，向第三方应用颁发令牌。下面就是这四种授权方式。  
  - 授权码（authorization-code）
  - 隐藏式（implicit）
  - 密码式（password）：
  - 客户端凭证（client credentials）

http://www.ruanyifeng.com/blog/2019/04/oauth-grant-types.html

1. 授权码（authorization-code）

![](https://www.wangbase.com/blogimg/asset/201904/bg2019040905.jpg)

2. 隐藏式（implicit）

![](https://www.wangbase.com/blogimg/asset/201904/bg2019040906.jpg)

3. 密码式（password）

使用用户名和密码来获取令牌。

4. 客户端凭证（client credentials）


## OAuth 2.0：Bearer Token、MAC Token区别

https://blog.csdn.net/weixin_39973810/article/details/84673548

两种类型的Access Token：Bearer类型和MAC类型

Bearer 介绍
优点：
　　调用简单，不需要对请求进行签名。
缺点：
　　请求API需要使用https协议保证信息传输安全。
　　Access Token有效期一个月，过期后需要使用Refresh Token进行刷新。

MAC 介绍
优点：
　　不依赖https协议，无协议加密带来的性能开销。
　　Access Token长期有效，无需使用Refresh Token刷新。
缺点：
　　需要进行MAC计算。


Bearer类型token定义了三种token传递策略，客户端在传递token时必须使用其中的一种，且最多一种。
放在Authorization请求首部
放在请求实体中
放在URI请求参数中

## BearerToken之JWT的介绍

Bearer认证

Bearer Token (RFC 6750) 用于OAuth 2.0授权访问资源，任何Bearer持有者都可以无差别地用它来访问相关的资源，而无需证明持有加密key。一个Bearer代表授权范围、有效期，以及其他授权事项；一个Bearer在存储和传输过程中应当防止泄露，需实现Transport Layer Security (TLS)；一个Bearer有效期不能过长，过期后可用Refresh Token申请更新。

HTTP提供了一套标准的身份验证框架：服务器可以用来针对客户端的请求发送质询(challenge)，客户端根据质询提供身份验证凭证。质询与应答的工作流程如下：服务器端向客户端返回401（Unauthorized，未授权）状态码，并在WWW-Authenticate头中添加如何进行验证的信息，其中至少包含有一种质询方式。然后客户端可以在请求中添加Authorization头进行验证，其Value为身份验证的凭证信息。

在HTTP标准验证方案中，我们比较熟悉的是"Basic"和"Digest"，前者将用户名密码使用BASE64编码后作为验证凭证，后者是Basic的升级版，更加安全，因为Basic是明文传输密码信息，而Digest是加密后传输。在前文介绍的Cookie认证属于Form认证，并不属于HTTP标准验证。

本文要介绍的Bearer验证也属于HTTP协议标准验证，它随着OAuth协议而开始流行，详细定义见： RFC 6570。

```
     +--------+                               +---------------+
     |        |--(A)- Authorization Request ->|   Resource    |
     |        |                               |     Owner     |
     |        |<-(B)-- Authorization Grant ---|               |
     |        |                               +---------------+
     |        |
     |        |                               +---------------+
     |        |--(C)-- Authorization Grant -->| Authorization |
     | Client |                               |     Server    |
     |        |<-(D)----- Access Token -------|               |
     |        |                               +---------------+
     |        |
     |        |                               +---------------+
     |        |--(E)----- Access Token ------>|    Resource   |
     |        |                               |     Server    |
     |        |<-(F)--- Protected Resource ---|               |
     +--------+                               +---------------+

                     Figure 1: Abstract Protocol Flow
```
Bearer验证中的凭证称为BEARER_TOKEN，或者是access_token，它的颁发和验证完全由我们自己的应用程序来控制，而不依赖于系统和Web服务器，Bearer验证的标准请求方式如下：

Authorization: Bearer [BEARER_TOKEN]   
JWT(JSON WEB TOKEN)  

上面介绍的Bearer认证，其核心便是BEARER_TOKEN，而最流行的**Token编码方式**便是：JSON WEB TOKEN。  

Json web token (JWT), 是为了在网络应用环境间传递声明而执行的一种基于JSON的开放标准[RFC 7519(https://tools.ietf.org/html/rfc7519)。该token被设计为紧凑且安全的，特别适用于分布式站点的单点登录（SSO）场景。JWT的声明一般被用来在身份提供者和服务提供者间传递被认证的用户身份信息，以便于从资源服务器获取资源，也可以增加一些额外的其它业务逻辑所必须的声明信息，该token也可直接被用于认证，也可被加密。

jwt主要包含以下三个内容：

头部 Header  
载荷 Payload  
签名 Signature  

Jwt Token包含了使用.分隔的三部分

{Header 头部}.{Payload 负载}.{Signature 签名}  
头部 Header  
Header 一般由两个部分组成：  

alg  
typ  
alg是是所使用的hash算法，如：HMAC SHA256或RSA，typ是Token的类型，在这里就是：JWT。  
```
{
  "alg": "HS256",
  "typ": "JWT"
}
```
然后使用Base64Url编码成第一部分

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.<second part>.<third part>

载荷 Payload  
这一部分是JWT主要的信息存储部分，其中包含了许多种的声明（claims）。

Claims的实体一般包含用户和一些元数据，这些claims分成三种类型：

reserved claims：预定义的 一些声明，并不是强制的但是推荐，它们包括 iss (issuer), exp (expiration time), sub (subject),aud(audience) 等（这里都使用三个字母的原因是保证 JWT 的紧凑）。  
public claims: 公有声明，这个部分可以随便定义，但是要注意和 IANA JSON Web Token 冲突。  
private claims: 私有声明，这个部分是共享被认定信息中自定义部分。  

一个简单的Pyload可以是这样子的：
```
{
   "user_name": "admin", 
   "scope": [
       "read","write","del"
   ], 
   "organization": "admin", 
   "exp": 1531975621, 
   "authorities": [
       "ADMIN"
   ], 
   "jti": "23408d38-8cdc-4460-beac-24c76dc7629a", 
   "client_id": "webapp"
}
```
这部分同样使用Base64Url编码成第二部分

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.<third part>

签名 Signature

Signature是用来验证发送者的JWT的同时也能确保在期间不被篡改。

签名哈希部分是对上面两部分数据签名，通过指定的算法生成哈希，以确保数据不会被篡改。

首先，需要指定一个密码（secret）。该密码仅仅为保存在服务器中，并且不能向用户公开。然后，使用标头中指定的签名算法（默认情况下为HMAC SHA256）根据以下公式生成签名。

使用Base64编码后的header和payload以及一个秘钥，使用header中指定签名算法进行签名。
```
HMACSHA256(base64UrlEncode(header) + "." + base64UrlEncode(payload), secret)
```
结果
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ
```

base64UrlEncode

如前所述，JWT头和有效载荷序列化的算法都用到了Base64URL。该算法和常见Base64算法类似，稍有差别。
作为令牌的JWT可以放在URL中（例如api.example/?token=xxx）。 Base64中用的三个字符是"+"，"/"和"="，由于在URL中有特殊含义，因此Base64URL中对他们做了替换："="去掉，"+"用"-"替换，"/"用"_"替换，这就是Base64URL算法，很简单把。

JWT的工作过程

客户端接收服务器返回的JWT，将其存储在Cookie或localStorage中。

此后，客户端将在与服务器交互中都会带JWT。如果将它存储在Cookie中，就可以自动发送，但是不会跨域，因此一般是将它放入HTTP请求的Header Authorization字段中。

<font color=red>放在Cookie里面自动发送，但是这样不能跨域，所以更好的做法是放在HTTP请求的头信息Authorization字段里面。</font>

Authorization: Bearer JWT_TOKEN

当跨域时，也可以将JWT被放置于POST请求的数据主体中。

使用JWT具有如下好处  
通用：因为json的通用性，所以JWT是可以进行跨语言支持的，像JAVA,JavaScript,NodeJS,PHP等很多语言都可以使用。  
紧凑：JWT的构成非常简单，字节占用很小，可以通过 GET、POST 等放在 HTTP 的 header 中，非常便于传输。  
扩展：JWT是自我包涵的，包含了必要的所有信息，不需要在服务端保存会话信息, 非常易于应用的扩展。  

## WEB HOOK 令牌方式



https://www.cnblogs.com/yadongliang/p/8609922.html


请求认证
基于Token的认证机制会在每一次请求中都带上完成签名的Token信息，这个Token信息可能在COOKIE
中，也可能在HTTP的Authorization头中；



客户端（APP客户端或浏览器）通过GET或POST请求访问资源（页面或调用API）；
1. 认证服务作为一个Middleware HOOK 对请求进行拦截，首先在cookie中查找Token信息，如果没有找到，则在HTTP Authorization Head中查找；
2. 如果找到Token信息，则根据配置文件中的签名加密秘钥，调用JWT Lib对Token信息进行解密和解码；
3. 完成解码并验证签名通过后，对Token中的exp、nbf、aud等信息进行验证；
4. 全部通过后，根据获取的用户的角色权限信息，进行对请求的资源的权限逻辑判断；
5. 如果权限逻辑判断通过则通过Response对象返回；否则则返回HTTP 401；

![](https://images2015.cnblogs.com/blog/34831/201606/34831-20160622152344250-1238130627.jpg)

