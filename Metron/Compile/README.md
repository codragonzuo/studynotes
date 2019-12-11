
CentOS6.5-64位安装puppeteer，提示Chrome无法启动，查找并安装缺失依赖包——吕江民·敬上

https://segmentfault.com/a/1190000015802337

检测缺失的依赖包

ldd chrome | grep not

```shell
[root@node1 lib]# ls *.jar | while read jarfile; do
>     echo "$jarfile"
>     jar -tf $jarfile | grep "HdfsWriter.class"
> done
```

[root@node3 metron_0.7.1]# mvn clean install -DskipTests -X


maven 裁剪反应堆
-am:同时构所列模块的依赖模块
-amd:同时构建依赖于所列模块的模块
-pl <arg> :构建指定的模块，之间用逗号分隔

mvn clena install -pl account-emil -am
