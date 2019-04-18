

### J2EE
https://tutorialseye.com/j2ee-tutorial

Java Enterprise Edition is a standard for developing applications based on enterprise softwares. Java Platform, Enterprise Edition or Java EE is an enterprise computing platform on Java from Oracle.

![](https://tutorialseye.com/wp-content/uploads/Java-Enterprise-Edition-Tutorial.png)

#### J2EE Checklists

https://tutorialseye.com/j2ee-checklists.html

#### J2EE Design Patterns
https://tutorialseye.com/j2ee-design-patterns.html

![](https://tutorialseye.com/wp-content/uploads/figure06_02.gif)

### Architecture
http://springframeworkinterviewanswers.blogspot.com/2013/07/java-j2ee-spring-enterprise-java.html

![](http://2.bp.blogspot.com/-gfSvSCrcKk0/Tnw6Gv0MehI/AAAAAAAAAEg/oSW-eNAtSb0/s1600/j2ee_components.JPG)


### MVC pattern
MVC相比于三层架构或者四层架构，突出特点是前端控制的灵活性。如果MVC的两部分View和Controller剥离出来，实际是前端控制器模式的设计模式。
MVC缺点很明显，将前端以外逻辑都放到Model里，随着业务增多，Model将越来越难维护。
MVC并不适合称为一种分层架构，更适合称为一种复合的设计模式。
MVC模式最适合新闻门户网站，展示类网站等，业务逻辑相对简单。
MVC模式适合初创时使用，因为初期逻辑简单，降低试验成本。多数可能会被淘汰。最适合产品原型的实现，注重前端。

总之，分层选择要平衡成本和风险，使收益最大化。业务逻辑不要局限于四层架构或者三层架构，依据领域业务特点可细化层次。


### Java EE未来路在何方？
Jean-François James

http://www.infoq.com/cn/articles/where-is-java-ee-going
### Where is Java EE going
https://jefrajames.wordpress.com/2018/01/09/where-is-java-ee-going/

#### What’s new with Java EE 8?
It is worth pointing out the effort made by Oracle to deliver Java EE 8 on time (September 2017), not only developing and evolving specifications, but also moving Glassfish (the Java EE Reference Implementation) to GitHub.

Java EE 8  main evolutions are:

 - Java SE 8 alignment: DateTime API, CompetableFuture, repeatable annotations
 - CDI 2.0: asynchronous events, events ordering, better integration in other specs.  With this release, CDI confirms its role of fundation of the Java EE platform
 - Servlet 4.0: HTTP/2 support (Server Push)
 - JAX-RS 2.1: Server Sent Event, reactive extensions
 - JSON Processing 1.1 and JSON Binding 1.0
 - Security: simplification, secret management, modernization, OAuth2 andOpenId support

Overall, Java EE 8 is more a restart that a strong evolution. In particular, specific ingredient of cloud-native applications are out of its scope: distributed tracing, central configuration, health check, circuit breaker, load balancing …


## J2EE Enterprise Application Model
![](https://www.oracle.com/ocom/groups/public/@otn/documents/digitalasset/148900.gif)

