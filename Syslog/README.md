
# Syslog


## What is Syslog: Daemons, Message Formats and Protocols
https://sematext.com/blog/what-is-syslog-daemons-message-formats-and-protocols/

https://www.rfc-editor.org/rfc/rfc5424.html

## syslog

https://www.paessler.com/it-explained/syslog

## Cisco syslog

An Overview of the syslog Protocol

Cisco 的syslog有什么不同？

## UDP 514 port

![](https://stackify.com/wp-content/uploads/2017/06/flylib-syslog-screenshot-12386.jpg)

## The Syslog Format
Syslog has a standard definition and format of the log message defined by RFC 5424. As a result, it is composed of a header, structured-data (SD) and a message. Within the header, you will see a description of the type such as:
```
Priority
Version
Timestamp
Hostname
Application
Process id
Message id
```

```
Here are the Syslog Message Levels:

Emergency Messages–System is unavailable and unusable (Could be a “panic” condition due to a natural disaster)
Alert Messages–Action needs to be taken immediately (an example is loss of backup ISP connection)
Critical Messages–Critical conditions (this could be a loss of primary ISP connection)
Error Messages–Error conditions (must be resolved within a specified time frame)
Warning Messages–Warning conditions (indicates an error may occur if action is not taken)
Notification Messages–Things are normal, but this is still a significant condition (immediate action is usually not required)
Informational Messages–Informational messages (for reporting and measuring)
Debugging Messages–Debug-level messages (Offers information around debugging apps)
```

You can also rotate a log file once it reaches a particular size. Nonetheless, the UNIX logrotate utility will continue to write the log information to a new file after rotating the old file. Here are the keys to use:

```
/usr/sbin/logrotate–The logrotate command
/etc/cron.daily/logrotate–The shell script that executes the logrotate command on a daily basis.
/etc/logrotate.conf–This is used as log rotation for all the log entries in this file
/etc/logrotate.d–For individual packages
```

## 不同的日志服务器

https://stackify.com/syslog-101/

![](https://stackify.com/wp-content/uploads/2017/06/flylib-syslog-screenshot-12386.jpg)

![](https://stackify.com/wp-content/uploads/2017/06/Syslog-Message-Destination-min.png)

## How To View and Write To System Log Files on Ubuntu

https://www.howtogeek.com/117878/how-to-view-write-to-system-log-files-on-ubuntu/

Writing to the System Log

```
logger “Hello World”


logger –t ScriptName “Hello World”


dmesg | grep something


dmesg | less


dmesg | grep something | less

grep something /var/log/syslog

less /var/log/syslog

head -n 10 /var/log/syslog

tail -n 10 /var/log/syslog

```

## syslog详解及配置远程发送日志和远程日志分类

https://www.cnblogs.com/haimeng/p/10823699.html

![](https://img2018.cnblogs.com/blog/1225529/201905/1225529-20190507112121594-392854954.png)

Syslog再UNIX系统中应用非常广泛，它是一种标准协议，负责记录系统事件的一个后台程序，记录内容包括核心、系统程序的运行情况及所发生的事件。Syslog协议使用UDP作为传输协议，通过514端口通信，Syslog使用syslogd后台进程，syslogd启动时读取配置文件/etc/syslog.conf，它将网络设备的日志发送到安装了syslog软件系统的日志服务器，Syslog日志服务器自动接收日志数据并写到指定的日志文件中。


## Send Logs to multiple syslog servers

https://unix.stackexchange.com/questions/244707/send-logs-to-multiple-syslog-servers

As you have not specified, and also for the benefit of other readers, I will describe what to do using syslog-ng and rsyslog to have a server logging simultaneously to two remote syslog servers.

If you have syslog-ng logging to a central syslog server, modify /etc/syslog-ng.conf

As an example:
```
source s_src { unix-dgram("/dev/log"); internal();
         file("/proc/kmsg" program_override("kernel"));
};

destination d_loghost {udp("10.10.1.1" port(514));};
log { source(s_src); destination(d_loghost); };
```
To syslog to a 2nd destination, add:
```
destination d_loghost2 {udp("10.10.1.2" port(514));};
log { source(s_src); destination(d_loghost2); };
```
If running rsyslog, then actually it is simpler.The configuration file is /etc/rsyslog.conf

Where you find a destination:
```
*.* @10.10.1.1:514
```
you add a 2nd destination:
```
*.* @10.10.1.2:514
```
After changing the configuration, the syslog daemons in the client side need to be restart. Being it respectively,
```
sudo service syslog-ng restart
```
or
```
sudo service rsyslog restart
```
As the syslog daemon sends all messages to all destinations configured, unless you explicitly filter out services or log levels, you do not need to configure anything else [in the client side]. Both will receive exactly the same logs.

