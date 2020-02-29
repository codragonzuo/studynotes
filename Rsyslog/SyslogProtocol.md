

# The Syslog Protocol

For many years, the standard RFC for the Syslog protocol was RFC3194 (http://www.ietf.org/rfc/rfc3164.txt). Now RFC5424 (http://tools.ietf.org/search/rfc5424) is the new proposed draft standard for the Syslog protocol. In other words, RFC5424 obsoletes RFC3194.

RFC5424 is a much-needed revamp of the older Syslog protocol. One of the biggest changes to the protocol is the specification of timestamps that adhere to RFC3339 (http://tools.ietf.org/search/rfc3339). 

The older protocol didn’t specify much in the way of a timestamps. 

If you were lucky the log message you received contained the bare minimum of month, day, hour and, second.

Typically there was no year in the timestamp and time zone information was nonexistent. This made it very difficult from an analysis standpoint. RFC5424 also adds structured data such as name=value pairs to syslog which promises to dramatically simplify automated log analysis.

We encourage you to review the RFCs presented and get a basic feel for what the protocol is and has to offer.

RFC5424协议手册地址：https://tools.ietf.org/html/rfc5424
RFC3164协议手册地址：https://tools.ietf.org/html/rfc3164

Syslog常被用来日志等数据的传输协议，数据格式遵循规范主要有RFC3164，RFC5424；
RFC5424 相比 RFC3164 主要是数据格式的不同，RFC3164相对来说格式较为简单，能适应大部分使用场景，但是已废弃，RFC5424已作为Syslog的业界规范；下面就来分别讲讲两个协议；

RFC 5424 规定消息最大长度为2048个字节，如果收到Syslog报文，超过这个长度，需要注意截断或者丢弃；

截断：如果对消息做截断处理，必须注意消息内容的有消息，很好理解，UTF-8编码，一个中文字符对应3个字节，截断后的字符可能就是非法的；

丢弃：如果该syslog应用的场景下，认为超出长度的就是非法的，则可做丢弃处理；


- rsion
版本用来表示Syslog协议的版本，RFC5424的版本号为“1”；

- MESTAMP

时间戳格式为：yyyy-mm-ddTHH:MM:SS.xxxxxx+/-HH:MM

有以下几个要求：

"T" "Z"必须大写
"T"是必须的
不能使用闰秒

如果无法获取时间戳，必须使用"-"代替

举例如下：

```
1985-04-12T23:20:50.52Z #有效

1985-04-12T19:20:50.52-04:00#有效

2003-10-11T22:14:15.003Z#有效

2003-08-24T05:14:15.000003-07:00#有效

2003-08-24T05:14:15.000000003-07:00#非法，小数点后超过6位

```
