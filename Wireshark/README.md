

## 4. 虚拟环境网络

GNS3- Ciso设备

eNSP - HW设备


## 本地流量捕获

使用RawCap捕获本地的127.0.0.1的流量。

捕获的数据包保存在pcap文件，可以用Wireshark查看。

## 虚拟机流量捕获

桥接模式 ---- 选择物理网卡

host-only  ---- 选择VMware Wmnet1网卡

NAT模式     ---- Vmnet8

## 7 网络延迟分析

## 8 网络连通

查看缓存IP和MAC地址对应关系

arp -a

获取域名服务器的IP地址

检查网络的连通性

tarcert  www.baidu.com

## 9 链路层攻击

- MAC地址欺骗: 制造错误的CAM表
- MAC地址洪泛：CAM表爆满造成交换机退化成集线器   （查看交换机的MAC地址学习记录）
- STP攻击：  伪造BPDU报文控制交换端口转发状态，将所有网络流量劫持到本机
- 广播风暴： ARP报文，DHCP报文占用网络资源带宽

使用Kali Linux macof 发起MAC地址泛洪攻击

限制交换机接口的MAC地址数量

## 10 中间人攻击

使用arpspoof发起攻击

防御： 静态绑定ARP

## 11 泪滴攻击 TearDrop

发送畸形数据包

想目标主机发送异常的数据包碎片，使得IP数据包碎片在重组的过程中有重合的部分，从而导致目标系统无法对其进行重组，进一步导致系统奔溃而停止服务。

根据TTL值判断攻击的来源。


## 12 传输层洪水攻击  SYN Flooding

TCP连接握手

利用TCP连接的第3次握手， 当服务器收到客户端的SYN请求后，会发出一个SYN_ACK回应，连接进入半开状态。

半开的连接设置一个计数器，如果计数完成了还没有收到客户端的ACK回应，就会重新发送SYN_ACK消息，直到超过一定次数才会释放连接。

当出现数量众多的半开连接时，服务器会资源耗尽，通知对所有请求的响应。

使用Hping3发起SYN flooding攻击

## 13 数据流功能

## 14 洪水攻击 UDP flooding

反射型DDos

amcharts 图表生成软件

https://www.cloudflare.com/learning/ddos/memcached-ddos-attack/

## 15 缓冲区溢出


## 16 Wireshark扩展

lua脚本



