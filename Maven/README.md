
```
mvn archetype:generate     -DgroupId=com.mycom.helloworld     -DartifactId=helloworld     -DarchetypeArtifactId=maven-archetype-quickstart     -DinteractiveMode=false     -DarchetypeCatalog=http://maven.aliyun.com/nexus/content/groups/public/
```


### 配置maven 的阿里云远程仓库

maven阿里云中央仓库的两种方式    
1、修改maven根目录下的conf文件夹中的setting.xml文件，内容如下：  
```
<mirror>
    <id>alimanven</id>
    <name>aliyun maven</name>
    <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
    <mirrorOf>central</mirrorOf>
</mirror>
```
2、修改pom.xml文件，增加如下内容：  
```
<repositories>
    <repository>
        <id>maven - ali</id>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>true</enabled>
            <updatePolicy>always</updatePolicy>
            <checksumPolicy>fail</checksumPolicy>
        </snapshots>
    </repository>
</repositories>
```

## catalog文件

手工下载 https://repo1.maven.org/maven2/archetype-catalog.xml保存到windows用户目录的.m2目录下
