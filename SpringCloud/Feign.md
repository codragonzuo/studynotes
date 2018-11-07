
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
