# <center>Maven命令
### 常用的maven命令

Maven命令列表
mvn –version
显示版本信息
mvn clean
清理项目生产的临时文件,一般是模块下的target目录
mvn compile
编译源代码，一般编译模块下的src/main/java目录
mvn package
项目打包工具,会在模块下的target目录生成jar或war等文件
mvn test
测试命令,或执行src/test/java/下junit的测试用例.
mvn install
将打包的jar/war文件复制到你的本地仓库中,供其他模块使用
mvn deploy
将打包的文件发布到远程参考,提供其他人员进行下载依赖
mvn site
生成项目相关信息的网站
mvn eclipse:eclipse
将项目转化为Eclipse项目
mvn dependency:tree
打印出项目的整个依赖树  
mvn archetype:generate
创建Maven的普通java项目
mvn tomcat:run
在tomcat容器中运行web应用
mvn jetty:run
调用 Jetty 插件的 Run 目标在 Jetty Servlet 容器中启动 web 应用

注意：运行maven命令的时候，首先需要定位到maven项目的目录，也就是项目的pom.xml文件所在的目录。否则，必以通过参数来指定项目的目录。



### 命令参数

很多命令都可以携带参数以执行更精准的任务。

Maven命令可携带的参数类型如下：

#### 1.   -D 传入属性参数

比如命令：

mvn package -Dmaven.test.skip=true

以“-D”开头，将“maven.test.skip”的值设为“true”,就是告诉maven打包的时候跳过单元测试。同理，“mvn deploy-Dmaven.test.skip=true”代表部署项目并跳过单元测试。



#### 2.   -P 使用指定的Profile配置

比如项目开发需要有多个环境，一般为开发，测试，预发，正式4个环境，在pom.xml中的配置如下：

[html] view plain copy
 在CODE上查看代码片派生到我的代码片
```xml
<profiles>  
      <profile>  
             <id>dev</id>  
             <properties>  
                    <env>dev</env>  
             </properties>  
             <activation>  
                    <activeByDefault>true</activeByDefault>  
             </activation>  
      </profile>  
      <profile>  
             <id>qa</id>  
             <properties>  
                    <env>qa</env>  
             </properties>  
      </profile>  
      <profile>  
             <id>pre</id>  
             <properties>  
                    <env>pre</env>  
             </properties>  
      </profile>  
      <profile>  
             <id>prod</id>  
             <properties>  
                    <env>prod</env>  
             </properties>  
      </profile>  
</profiles>  

<build>  
      <filters>  
             <filter>config/${env}.properties</filter>  
      </filters>  
      <resources>  
             <resource>  
                    <directory>src/main/resources</directory>  
                    <filtering>true</filtering>  
             </resource>  
      </resources>  
   

   
</build>  
```
profiles定义了各个环境的变量id，filters中定义了变量配置文件的地址，其中地址中的环境变量就是上面profile中定义的值，resources中是定义哪些目录下的文件会被配置文件中定义的变量替换。

通过maven可以实现按不同环境进行打包部署，命令为: 

mvn package -P dev

其中“dev“为环境的变量id,代表使用Id为“dev”的profile。



#### 3.  -e 显示maven运行出错的信息

#### 4.  -o 离线执行命令,即不去远程仓库更新包

#### 5.   -X 显示maven允许的debug信息

#### 6.   -U 强制去远程更新snapshot的插件或依赖，默认每天只更新一次



### maven命令实例

下面结合几个实例来看看maven命令的使用方法。



#### archetype:create & archetype:generate

“archetype”是“原型”的意思，maven可以根据各种原型来快速创建一个maven项目。

archetype:create是maven 3.0.5之前创建项目的命令，例如创建一个普通的Java项目：

mvn archetype:create -DgroupId=packageName -DartifactId=projectName -Dversion=1.0.0-SNAPSHOT

后面的三个参数用于指定项目的groupId、artifactId以及version。

创建Maven的Web项目：  
```shell
mvnarchetype:create -DgroupId=packageName -DartifactId=projectName -DarchetypeArtifactId=maven-archetype-webapp
```
archetypeArtifactId参数用于指定使用哪个maven原型，这里使用的是maven-archetype-webapp，maven会按照web应用的目录结构生成项目。

需要注意的是，在maven 3.0.5之后，archetype:create命令不在使用，取而代之的是archetype:generate命令。

该命令会以交互的模式创建maven项目，不需要像archetype:create那样在后面跟一堆参数，很容易出错。

但是，在命令行直接运行archetype:generat，往往会出现下面的结果：



程序卡在了“Generatingproject in Interactive mode”这一步，加入“-X”参数显示详细信息：

mvn -X archetype:generate

运行结果如下：



可见，最终是卡到这一行，maven默认会从远程服务器上获取catalog，archetypeCatalog 表示插件使用的archetype元数据，默认值为remote,local，即中央仓库archetype元数据 （http://repo1.maven.org/maven2/archetype-catalog.xml）加上插件内置元数据，由于中央仓库的archetype太多（几千个）而造成程序的阻滞。实际上我们使用不了那么多的原型，加入-DarchetypeCatalog=internal参数就可以避免这种情况，只使用内置的原型就够了：

mvn archetype:generate -DarchetypeCatalog=internal

然后maven会告诉你，archetype没有指定，默认使用maven-archetype-quickstart，或者你从下面的列表中选择一个可用的原型：



列表中可用的内置原型共有10个，我们选择使用maven-archetype-quickstart原型（相当于一个“HelloWorld”模板）来创建项目，输入对应的序号“7”即可。

然后会依次提醒你输入groupId、artifactId、version(默认1.0-SNAPSHOT)以及创建的第一个包名。



如果构建成功就会在你的当前目录下，按照你输入的参数生成一个maven项目。



eclipse:eclipse

正式的开发环境中，代码一般是通过cvs、svn或者git来管理，我们从服务器下载下来源代码，然后执行mvn eclipse:eclipse生成ecllipse项目文件，然后导入到eclipse就行了。



tomcat:run

用了maven后，可以不需要用eclipse里的tomcat来运行web项目(实际工作中经常会发现用它会出现不同步更新的情况)，只需在对应目录里运行 mvn tomat:run命令，然后就可在浏览器里运行查看了。

首先来看一下maventomcat插件的配置：

[html] view plain copy
 在CODE上查看代码片派生到我的代码片
<plugin>  
      <groupId>org.apache.tomcat.maven</groupId>  
      <artifactId>tomcat7-maven-plugin</artifactId>  
      <version>2.2</version>  
      <configuration>  
             <port>8080</port>  
             <path>/dubbo-admin</path>  
             <uriEncoding>UTF-8</uriEncoding>  
             <finalName>dubbo-admin</finalName>  
             <server>tomcat7</server>  
      </configuration>  
</plugin>  

然后配置jsp，servlet依赖等：

[html] view plain copy
 在CODE上查看代码片派生到我的代码片
```xml
<dependency>  
      <groupId>javax.servlet</groupId>  
      <artifactId>servlet-api</artifactId>  
      <version>2.5</version>  
      <scope>provided</scope>  
</dependency>  
<dependency>  
      <groupId>javax.servlet.jsp</groupId>  
      <artifactId>jsp-api</artifactId>  
      <version>2.2</version>  
      <scope>provided</scope>  
</dependency>  
<dependency>  
      <groupId>javax.servlet</groupId>  
      <artifactId>jstl</artifactId>  
      <version>1.2</version>  
</dependency>  
<dependency>  
      <groupId>jsptags</groupId>  
      <artifactId>pager-taglib</artifactId>  
      <version>2.0</version>  
      <scope>provided</scope>  
</dependency>  
```
然后按照下面的方式运行：



还可以加入以下参数：跳过测试:-Dmaven.test.skip(=true)；指定端口:-Dmaven.tomcat.port=9090；忽略测试失败:-Dmaven.test.failure.ignore=true当然，如果你的其它关联项目有过更新的话，一定要在项目根目录下运行mvn clean install来执行更新，再运行mvn tomcat:run使改动生效。



help:describe

maven有各种插件，插件又有各种目标。我们不可能记得每个插件命令。maven提供了查询各类插件参数的命令：mvn help:describe。

例如：mvn help:describe -Dplugin=help

代表查询help 插件的命令规范，然后maven就会告诉你该命令有几个goal，各种参数的的意义以及配置方法：

下面的命令则代表插叙该插件的详细命令参数：



mvn help:describe -Dplugin=help -Dfull

### spring boot  mvn spring-boot:run 参数详解
https://blog.csdn.net/qwfys200/article/details/79983170

