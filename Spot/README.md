


![](http://blog.nsfocus.net/wp-content/uploads/2018/06/%E5%9B%BE%E7%89%87-1-1.png)
```
仅有外部流量(perimeter flows)

隐蔽扫描识别(Stealthy Scanning)
侧信道攻击检测(Side-Channel Data Escapes)
反射攻击检测(Reflection Attacks)
异常数据流检测(Unusual Data Flows)
信标检测(Beaconing)
增加了DNS数据后，可提供的功能有：

外部流量 + DNS

DNS隧道检测(DNS Tunneling)
DNS隐蔽信道识别(Convert DNS Channels)
内部DNS探测(Internal DNS Recon)
增加proxy数据后，可提供的功能有：

外部流量+ DNS + Proxy

跨站脚本攻击检测(Cross site scripting(XSS))
C&C主机发现(Command and Control)
URL混淆检测(URL obfuscation)
异常的POST数据发现(Unusual Data POSTs)
增加internal flows数据后，可以提供的功能有：

外部流量+ DNS + Proxy + 内部流量

横向移动检测(Lateral Movement)
完整的威胁可见性(Complete Threat Visibility)
```

Apache Spot 利用开源且被优化过的解码器接入二进制网络流量数据和数据包，利用机器学习的方法（主要是LDA 算法）从网络流量中分离出可疑流量，以及特征化独特的网络流量行为。经过上下文增强、噪声过滤、白名单和启发式算法等等一系列手段，最终产生少量且准确的安全威胁事件呈现给用户。

![](http://blog.nsfocus.net/wp-content/uploads/2018/06/2-2.png)
