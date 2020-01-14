# Groovy

http://www.groovy-lang.org/documentation.html


# Java内嵌Groovy脚本引擎进行业务规则剥离（一）

https://my.oschina.net/skymozn/blog/828930?p=2


JAVA嵌入运行Groovy脚本

https://www.pleus.net/articles/grules/grules.pdf

基于Groovy的规则脚本引擎实战

https://juejin.im/post/5ba449f7e51d450e664b41b0



# Custom ClassLoader in java for loading jar from hdfs

```java
class HdfsClassLoaderclassLoader(classLoader: ClassLoader) extends URLClassLoader(Array.ofDim[URL](0), classLoader) {

    def addJarToClasspath(jarName: String) {
        synchronized {
            var conf = new Configuration
            val fileSystem = FileSystem.get(conf)
            val path = new Path(jarName);
            if (!fileSystem.exists(path)) {
                println("File does not exists")
            }
            val uriPath = path.toUri()
            val urlPath = uriPath.toURL()
            println(urlPath.getFile)
            addURL(urlPath)
        }
    }
}
```

Groovy与Java集成常见的坑

性能问题

https://www.cnblogs.com/duanxz/p/10133079.html


Groovy深入探索——Groovy的ClassLoader体系

https://www.iteye.com/blog/johnnyjian-1847151

