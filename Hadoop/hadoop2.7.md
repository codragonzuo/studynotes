
# hadoop2.7.3在centos7上部署安装（单机版）

## 下载解压

tar -zxvf 

配置hadoop

1.修改/usr/hadoop/hadoop-2.7.3/etc/hadoop/hadoop-env.sh 文件的java环境，将java安装路径加进去：

```
 export JAVA_HOME=/alidata/server/java-1.7.0  
```

配置hadoop环境变量

vi /etc/profile
```
export HADOOP_HOME=/usr/hadoop/hadoop-2.7.3  
export PATH=$PATH:$HADOOP_HOME/bin  
```
注意中间的是冒号


使之生效
```
source /etc/profile 
```

2.修改/usr/hadoop/hadoop2.7.3/etc/hadoop/core-site.xml 文件，
```
<configuration>  
    <!-- 指定HDFS老大（namenode）的通信地址 -->  
    <property>  
        <name>fs.defaultFS</name>  
        <value>hdfs://localhost:9000</value>  
    </property>  
    <!-- 指定hadoop运行时产生文件的存储路径 -->  
    <property>  
        <name>hadoop.tmp.dir</name>  
        <value>/usr/hadoop/tmp</value>  
    </property>  
</configuration> 
```
fs.defaultFS直接用localhost就行，如果重命名了主机名，也可以用重命名的。


3.修改/usr/hadoop/hadoop2.7.3/etc/hadoop/hdfs-site.xml 
```
<configuration>  
    <property>  
        <name>dfs.name.dir</name>  
        <value>/usr/hadoop/hdfs/name</value>  
        <description>namenode上存储hdfs名字空间元数据 </description>   
    </property>  
  
    <property>  
        <name>dfs.data.dir</name>  
        <value>/usr/hadoop/hdfs/data</value>  
        <description>datanode上数据块的物理存储位置</description>  
    </property>  
  
  
    <!-- 设置hdfs副本数量 -->  
    <property>  
        <name>dfs.replication</name>  
        <value>1</value>  
    </property>  
</configuration> 
```

SSH免密码登录
```
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa  
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys  
chmod 0600 ~/.ssh/authorized_keys  
```


.hdfs启动与停止

第一次启动hdfs需要格式化，之后启动就不需要的：
```
cd /usr/hadoop/hadoop-2.7.3  
./bin/hdfs namenode -format  
```

启动命令：

./sbin/start-dfs.sh

停止命令：

/sbin/stop-dfs.sh  

浏览器输入：http://localhost:50070     查看效果：

## Yarn配置

6.接下来配置yarn文件. 配置/usr/hadoop/hadoop-2.7.3/etc/hadoop/mapred-site.xml   

。这里注意一下，hadoop里面默认是mapred-site.xml.template 文件，如果配置yarn，把mapred-site.xml.template   重命名为mapred-site.xml 。
如果不启动yarn，把重命名还原。

hadoop 8088端口无法访问


Hadoop成功启动后 localhost:50070可以访问到页面，但是localhost:8088提示无法访问该网站。

问题出在hadoop文件夹下/etc/hadoop/目录下的配置文件：yarn-site.xml

修改yarn-site.xml文件，将其<configuration></configuration>中的配置修改为：
```
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
  <name>yarn.resourcemanager.address</name>
    <value>localhost:8032</value>
  </property>
  <property>
    <name>yarn.resourcemanager.scheduler.address</name>
    <value>localhost:8030</value>
  </property>
  <property>
    <name>yarn.resourcemanager.resource-tracker.address</name>
    <value>localhost:8031</value>
  </property>
  <property>
    <name>yarn.resourcemanager.admin.address</name>
    <value>localhost:8033</value>
  </property>
  <property>
    <name>yarn.resourcemanager.webapp.address</name>
    <value>localhost:8088</value>
  </property>
```
注意：yarn.resourcemanager.webapp.address的value的端口号为8088

如果不设置成localhost用ip也可以，则访问地址为：XXX.XXX.XXX.XXX(ip):8088

##
Hadoop无法访问web50070端口
Hadoop安装成功之后，访问不了web界面的50070端口

先查看端口是否启用
[hadoop@s128 sbin]$ netstat -ano |grep 50070

然后查看防火墙的状态，是否关闭，如果没有，强制性关闭
查看防火墙状态：

[hadoop@s128 sbin]$ service iptables status

关闭防火墙

 chkconfig iptables off
 
 service iptables stop
 
访问web界面（ip+端口号）

http://192.168.109.128:50070




 一般最好是关闭防火墙比较关闭。 
 
 systemctl  stop   firewalld.service 
 
 关闭防火墙；  
 
 禁止自动启动就用
 
 systemctl  disable  firewalld.service  . 就可以了。
