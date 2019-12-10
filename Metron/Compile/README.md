
CentOS6.5-64位安装puppeteer，提示Chrome无法启动，查找并安装缺失依赖包——吕江民·敬上

https://segmentfault.com/a/1190000015802337

检测缺失的依赖包

ldd chrome | grep not


[root@node1 lib]# ls *.jar | while read jarfile; do
>     echo "$jarfile"
>     jar -tf $jarfile | grep "HdfsWriter.class"
> done

