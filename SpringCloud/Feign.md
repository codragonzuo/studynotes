
# Declarative REST Client: Feign
声明式服务调用 Feign

Feign is a declarative web service client. It makes writing web service clients easier. To use Feign create an interface and annotate it. It has pluggable annotation support including Feign annotations and JAX-RS annotations. Feign also supports pluggable encoders and decoders.

Feign使得 Java HTTP 客户端编写更方便。**Feign 灵感来源于Retrofit、JAXRS-2.0和WebSocket**。

<font color="red">Feign 最初是为了降低统一绑定Denominator 到 HTTP API 的复杂度，不区分是否支持 Restful。</font>



## Spring Data Pageable in Feign Client

https://www.cimblo.com/how-to-handle-spring-data-pageable-in-feign-client/
![](https://i2.wp.com/cimblo.com/wp-content/uploads/2018/08/How-To-Handle-Spring-Data-Pageable-in-Feign-Client.png)

## 



## Microservices security with OAuth2

https://piotrminkowski.wordpress.com/2017/12/01/part-2-microservices-security-with-oauth2/

![](https://piotrminkowski.files.wordpress.com/2017/12/oauth2-1.png)

all authentication and OAuth2 data is stored on database.

four services
 
 There are four services running inside our sample system, what is visualized on the figure below. There is nothing unusual here. We have a discovery server where our sample microservices account-service and customer-service are registered. Those microservices are both protected with OAuth2 authorization. Authorization is managed by auth-server. It stores not only OAuth2 tokens, but also users authentication data. The whole process is implemented using Spring Security and Spring Cloud libraries.
 

<p style='color:red'>This is some red text.</p>

<font color="red">This is some text!</font>

These are <b style='color:red'>red words</b>.

We have to create six tables:

- oauth_client_details
- oauth_client_token
- oauth_access_token
- oauth_refresh_token
- oauth_code
- oauth_approvals

/src/main/resources/script/schema.sql
```sql
drop table if exists oauth_client_details;
create table oauth_client_details (
  client_id VARCHAR(255) PRIMARY KEY,
  resource_ids VARCHAR(255),
  client_secret VARCHAR(255),
  scope VARCHAR(255),
  authorized_grant_types VARCHAR(255),
  web_server_redirect_uri VARCHAR(255),
  authorities VARCHAR(255),
  access_token_validity INTEGER,
  refresh_token_validity INTEGER,
  additional_information VARCHAR(4096),
  autoapprove VARCHAR(255)
);
drop table if exists oauth_client_token;
create table oauth_client_token (
  token_id VARCHAR(255),
  token LONG VARBINARY,
  authentication_id VARCHAR(255) PRIMARY KEY,
  user_name VARCHAR(255),
  client_id VARCHAR(255)
);
 
drop table if exists oauth_access_token;
CREATE TABLE oauth_access_token (
  token_id VARCHAR(256) DEFAULT NULL,
  token BLOB,
  authentication_id VARCHAR(256) DEFAULT NULL,
  user_name VARCHAR(256) DEFAULT NULL,
  client_id VARCHAR(256) DEFAULT NULL,
  authentication BLOB,
  refresh_token VARCHAR(256) DEFAULT NULL
);
 
drop table if exists oauth_refresh_token;
CREATE TABLE oauth_refresh_token (
  token_id VARCHAR(256) DEFAULT NULL,
  token BLOB,
  authentication BLOB
);
 
drop table if exists oauth_code;
create table oauth_code (
  code VARCHAR(255), authentication LONG VARBINARY
);
drop table if exists oauth_approvals;
create table oauth_approvals (
    userId VARCHAR(255),
    clientId VARCHAR(255),
    scope VARCHAR(255),
    status VARCHAR(10),
    expiresAt DATETIME,
    lastModifiedAt DATETIME
);
```


we may perform some tests. 

Config Server – http://localhost:9999/

Discovery Server – http://localhost:8761/

Account Service – http://localhost:8082/

Customer Service – http://localhost:8083/


## Why We Use Feign Client
In my previous tutorial, When EmployeeDashBoard service communicated with EmployeeService, we programmatically constructed the URL of the dependent microservice, then called the service using RestTemplate, so we need to be aware of the RestTemplate API to communicate with other microservices, which is certainly not part of our business logic.

The question is, why should a developer have to know the details of a REST API? Microservice developers only concentrate on business logic, so Spring addresses this issues and comes with Feign Client, which works on the declarative principle. We have to create an interface/contract, then Spring creates the original implementation on the fly, so a REST-based service call is abstracted from developers. Not only that — if you want to customize the call, like encoding your request or decoding the response in a Custom Object, you can do it with Feign in a declarative way. Feign, as a client, is an important tool for microservice developers to communicate with other microservices via Rest API.

![](https://1.bp.blogspot.com/-cLPct-Cfx3w/WYNgnPfYYJI/AAAAAAAAFqE/3mqTXBrAaOEA9JmkYx9uRgph0prtprSDgCLcBGAs/s1600/Microservices%2BCommunication_%2BFeign%2Bas%2BRest%2BClient.jpg)


What do we have here? At first there´s an edge service, which is the central entry point to our services. We use Zuul from the Spring Cloud Netflix Stack here. It acts as a proxy, that provides us with dynamic routes to our services (there are also many more features).

Dynamic routing is a really cool feature! But what does it mean? Speaking on a higher level, we don´t have to tell our proxy manually about all service routes. It´s the other way round – all our services register their specific routes for themselves. As all the Spring Cloud components do heavily rely on each other, Zuul uses Eureka in this scenario – another Spring Cloud Netflix tool. Eureka acts as a central service registry, where all our services register to. Zuul then obtains all the registered instances from Eureka, which we implemented in the service registry project. Having all the example applications fired up locally, you´re able to see all the registered routes if you point your Browser to the Zuul at http://localhost:8080/routes.

![](https://blog.codecentric.de/files/2017/05/multiple-apps-spring-boot-cloud-netflix.png)
