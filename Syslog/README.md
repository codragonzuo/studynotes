
# Syslog


## What is Syslog: Daemons, Message Formats and Protocols
https://sematext.com/blog/what-is-syslog-daemons-message-formats-and-protocols/

https://www.rfc-editor.org/rfc/rfc5424.html

## syslog

https://www.paessler.com/it-explained/syslog

## Cisco syslog

An Overview of the syslog Protocol

Cisco 的syslog有什么不同？

## UDP 524 port

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



