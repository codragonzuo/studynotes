# Windows Logging

## nxlog

### 特性

支持windows和linux平台。

跨平台：NXLog使用Apache Portable Runtime Library，这使得NXLog能够像Apache一样，在不同的平台下运行，在Windows下，它使用Windows本地库进行编写，不依赖Cygwin这种库。

模块化的架构：NXLog具有一个轻量级模块化的架构，它使得模块是可插拔的，和Apache Web服务器类似。日志格式化、传输协议、数据库出来、NXLog语言扩展都是模块。只有当模块是需要使用的时候，才会被加载，这能够让程序使用更少的内存。NXLog的核心只具备出来文件和Socket的能力，其他的功能都被放到了各个模块里面，模块具备统一的API，开发者可以轻易的编写新的模块去扩展NXLog

客户端-服务端模式：NXLog可以作为客户端，也可以作为服务器端。它能够采集客户机上的日志并传输给远程服务器。它也能够接收从其他节点传输过来的日志信息并转发到数据库、文件等其他地方

多种输入以及输出：除了可以从日志文件采集日志消息，NXLog还支持许多不同的网络和传输层协议，例如TCP、UDP、TLS/SSL、数据库、还有Socket等方式，它既支持从这些协议里面读，也支持从这些协议里面写。

可扩展的多线程架构：NXLog使用基于事件的架构，NXLog在处理日志消息的时候还会采用并行的模式，读取消息、输出消息等日志消息处理操作都是并行处理的。例如：当单线程的syslog进程在尝试输出日志消息到数据库的时候，它会发生堵塞，后面的UDP输入将会丢丢弃，而多线程架构的NXLog不仅避免了这个问题还充分的发挥了操作系统的并行处理能力

　　高吞吐量：常规的POSIX系统为监控文件描述提供了select或poll的系统调用，但是这些方式都是不可扩展的。现代操作系统具备一些I/O就绪通知的API用于处理大量的文件打开以及网络连接并发的情况。NXLog就是使用这些高性能的API对日志消息进行处理的。

　　消息缓冲：当日志消息由于网络问题导致输入堵塞的时候，NXlog会主动调整输入的流量。这能够避免日志消息丢失的情况。同时，NXLog还提供了一些消息缓存的模块可以让日志消息暂存到磁盘或内存中。当问题解决之后，缓冲会全部刷出，并被清空。除了使用现有的模块，还可以使用NXLog的语言对消息进行自定义的处理

　　优先级：不是所有的日志消息都是非常重要的，有些日志消息需要被更加有限的处理，NXLog支持为日志路由设定优先级。例如，这可以避免TCP输入过载导致系统丢弃UDP syslog输入的情况
避免丢弃消息：内置的流程控制器不支持丢弃日志消息，所以你不会看到类似这种日志消息被丢弃的情况 Dec 18 18:42:42 server syslog-ng[1234]: STATS: dropped 42。当然，在提供丢弃日志消息的条件后，NXLog也能够主动丢弃日志消息。UDP协议下的Syslog是一个非常典型的案例，当kernel的缓冲区用满后，操作系统会丢掉UDP的消息。当日志消息处理导致系统非常繁忙的时候，系统内核的UDP缓冲区就会被非常快的写满。

　　Apache风格的配置：配置方式和Apache服务器的方式很类似，容易学

　　内置的配置语言：内置的配置语言能够让管理员更加容易的个性化去处理日志消息，Perl是解决日志处理问题的一个挺流行的语言。内置的nxlog语言和perl的语法非常类似

　　任务管理器：NXLog内置了一个类似Cron的作业调度器，并且提供了更多的功能，使用这种特性，管理员能够自动的执行一些例如日志轮转，系统检查等的任务。

　　日志轮转：当日志达到了一定的大小，或者到了某个具体的时间，是需要被日志轮转工具进行轮转的，file input reader模块支持扩展的日志轮转脚本，它能够对日志文件进行转移/重命名等动作，类似的，file output writer 模块能够监控文件的轮转，并在轮转完后重新打开输出。
多种多样的日志消息格式化工具：NXLog支持许多种类型的日志格式，例如Syslog、新颁布的IETF Syslog标准、GELF、JSON等等。使用日志转换函数，NXLog还能够处理多行日志消息或者自定义的日志消息。
高级日志消息处理能力：除了一些内置的功能之外，使用扩展模块可以使NxLog能够具备解决一些日志格式化，事件管理、正则匹配，日志过滤、重写、告警等动作

　　离线消息处理模式：有些时候日志需要离线处理，NXLog提供了这种模式

　　字符集和i18n支持：日志消息可能是各种各样的字符集写出来的，例如UTF-8、latin-2等，Nxlog具备字符集的转换能力。
  

### 输出到kafka

https://github.com/filipealmeida/nxlog-kafka-output-module

https://nxlog.co/documentation/nxlog-user-guide/om_kafka.html

https://nxlog.co/documentation/nxlog-user-guide/im_kafka.html

### 使用Nxlog将Windows日志以syslog形式发送至日志Syslog服务器

https://blog.csdn.net/c1052981766/article/details/79638364


## windows event log

win32 api

https://docs.microsoft.com/en-us/windows/win32/eventlog/event-logging

https://www.loggly.com/ultimate-guide/windows-logging-basics/

### WEF

SIEM中心日志节点WEF搭建说明

https://www.freebuf.com/articles/es/197812.html

Windows WEF 环境配置

Windows Event Forwarding 在windows 2008时就已经启用，主要用于日志中心化收集和转储，好处很多。



#### windows2012服务器配置为日志服务器

https://social.technet.microsoft.com/Forums/sharepoint/zh-CN/cfc231e2-8ac7-4f8c-a788-e5edd65c2366/windows2012?forum=operationsmanagerzhchs

日志收集的原理是各服务器的日志转发到某台集中控制的服务器。主要要考虑几个方面：

1，网络方面：WEF (Windows Event Forwording) 使用 WinRM (Windows Remote Management) 来实现，需要开放5985 (HTTP)或者5986 (HTTPS)端口

2，认证方面：如果收集服务器 (collector) 和产生日志的服务器在同一个域内，使用 Kerberos 认证，不需要额外的配置；如果收集服务器处于工作组或者其它不信任的域，则需要配置证书来实现认证

3，权限方面：对于目标计算机，需要配置本地 Network Service 有读取 security 日志的权限 (可以通过组策略来完成)

4，转发：通过配置组策略让目标服务器转发日志

5，订阅：通过订阅来配置收集哪些日志

详细的步骤，我们可以参考：

Monitoring what matters – Windows Event Forwarding for everyone (even if you already have a SIEM.)

https://blogs.technet.microsoft.com/jepayne/2015/11/23/monitoring-what-matters-windows-event-forwarding-for-everyone-even-if-you-already-have-a-siem/

如果收集服务器是工作组计算机或者和目标计算机不在同一个信任域，可以参考：

Windows Event Forwarding to a workgroup Collector Server

https://blogs.technet.microsoft.com/thedutchguy/2017/01/24/windows-event-forwarding-to-a-workgroup-collector-server/



https://docs.microsoft.com/en-us/windows/security/threat-protection/use-windows-event-forwarding-to-assist-in-intrusion-detection


### Use Windows Event Forwarding to help with intrusion detection

https://docs.microsoft.com/en-us/windows/security/threat-protection/use-windows-event-forwarding-to-assist-in-intrusion-detection

### Windows Event Forwarding for Network Defense

https://medium.com/palantir/windows-event-forwarding-for-network-defense-cb208d5ff86f

### The Windows Event Forwarding Survival Guide

https://hackernoon.com/the-windows-event-forwarding-survival-guide-2010db7a68c4


### Monitoring what matters – Windows Event Forwarding for everyone (even if you already have a SIEM.)

WEF需要windows域相关的配置

Setting WEF up is really easy too. Prerequisites are essentially a server and a GPO. To collect security events, we'll also need to grant the local Network Service principal rights to read that log. This is just the Network Service on the machine itself, so it's not a wide privilege throughout the domain. The WinRM service will also need to be started on all the clients in the domain - just started though, not configured. This is key, as just starting the WinRM service doesn't leave it in a listening state, versus a quick config of the service would make it listening.

You absolutely could configure WEF to collect all the security logs in your domain - and maybe if you don't have any other centralized logging in your domain you should do this for forensic reasons - but the real value of WEF is targeted alerts, filtering out what really matters. This is also where WEF is a great compliment to a SIEM you already have in your environment - let the SIEM do the heavy lifting of collecting every single event and use WEF for targeted visibility, and use WEF to get important security events from workstations/member servers in your environment you may not have covered by the SIEM. The SIEM can then collect them from the WEF server, still providing you with the "single pane of glass" view.

The five basic things I think everyone should start with for monitoring in their domain (if they aren't already) are :

Security Event Logs being cleared
High value groups like Domain Admins being Changed

Local administrator groups being changed

Local users being created or deleted on member systems

New Services being installed, particularly on Domain Controllers (as this is often an indicator of malware or lateral movement behavior.)

https://blogs.technet.microsoft.com/jepayne/2015/11/23/monitoring-what-matters-windows-event-forwarding-for-everyone-even-if-you-already-have-a-siem/

### Centralizing Windows Events with Event Forwarding v4.0



https://www.beyondtrust.com/docs/archive/privilege-management/documents/defendpoint/enterprise-reporting/4-1-291-0/dp-er-event-centralization-4-0.pdf

### Centralizing Windows Logs


https://www.loggly.com/ultimate-guide/centralizing-windows-logs/


## 使用PowerShell操作日志

PowerShell – Everything you wanted to know about Event Logs and then some

https://evotec.xyz/powershell-everything-you-wanted-to-know-about-event-logs/


Microsoft offers multiple commands that allow Administrators to work with Event Logs. You can read, write and create event logs. 

For this article, I'm going to focus only on reading part of it. For this article, I will focus on the two most important commands from my perspective. The two commands that are provided with the system are: Get-EventLog and Get-WinEvent. 

Get-EventLog has been around for ages and is still available on modern systems. 

Get-WinEvent is technically replacement of it. 

While some people still use Get-EventLog it's slowly being phased out. It already is unable to report proper log sizes for event logs that are bigger than 4GB. You can read about this problem on my other blog post at Get-EventLog shows wrong maximum size of event logs. It can't work with most of the modern Event Logs created by applications either. 

You should make an effort to learn using Get-WinEvent or as I will try to show you start using my version (wrapper) called Get-Events which is available after you install PSEventViewer module.


## Sending Windows Event Logs to Logstash using powershell

https://github.com/xme/powershell_scripts

https://blog.rootshell.be/2015/08/24/sending-windows-event-logs-to-logstash/

