


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


根据官网中的描述，共计有6个关键特性：

- 可疑DNS包检测(Suspicious DNS packets)：Spot对于DNS流量使用深度包检测（DPI）技术，对DNS流量进行画像，经过可视化、正则化以及模式匹配处理，向安全分析师呈现出DNS流量数据中最有可能是威胁的部分。由spot-oa模块实现，利用“GTI”进行DNS可疑流量的检测、判定。McAfee的GTI服务是要收费的，收费的，收费的。重要的事情说三遍。
- 威胁应急响应（Threat Incident and Response）：给定一个IP地址，Spot能够将该IP相关的所有数据按时间序列整合在一起，形成这个IP网络实体的“社交网络(social network)”。由spot-oa模块提供此功能，但项目提供的oa功能还是很弱的，真要在商用产品中使用，是需要进一步开发的。
- 可疑连接发现（Suspicious Connects）：通过机器学习的方法对在网络上进行通信的机器及其通信模式建立相应的模型，经过一系列处理后，这些剩余的数据就是最有可能是威胁的部分。由spot-ml模块提供此功能，可以认为此模块是Spot项目的核心模块吧，提供了无监督的机器学习算法，来帮助安全人员分析可疑的流量。
- 故事板（Storyboard）：安全分析师对威胁事件完成调查后，可以通过故事板去表现事件的来龙去脉，也就是说在故事板中，我们可以了解到攻击者是什么时候攻入系统的？都拿下了哪些机器？怎么拿下的？这个，就是吹。
- 开放数据模型（Open Data Models）：为了让威胁检测模型的开发过程更加简单高效，保证个人、企业、社区输出的检测模型的兼容性，Apache Spot 对网络、终端、用户等相关数据进行了标准化定义，规范了这些数据在逻辑层以及物理层的形态。简而言之，开放数据模型保障了不同的开发者在用同一种“语言”在进行威胁检测模型的开发。这个模型保证了Spot可以使用多种数据源，但根据了解到的信息来看，还是需要进一步开发的。
- 协作（Collaboration）：Apache Spot 平台运行于Hadoop大数据平台之上，通过其定义的开放数据模型，使得个人、企业、社区开发者的产出可以无缝衔接。正如攻击者可以利用其它攻击者制作的攻击工具一样，防护方也能够使用其它防护者制作的防护工具。没说的，空话。

从Apache Spot的github页面中，可以清晰看出其是由三大模块组成，分别是：采集模块(spot-ingest)，机器学习模块(spot-ml)，运营分析模块(spot-oa)。此外，项目中还有一个单独的安装模块（spot-setup），帮助安装Spot。

官网提供的Spot系统架构图如下：



- 采集模块： 在上图中就是“Ingest/Transform”部分。采集模块可以接受的数据输入由三种类型：Flows，DNS (pcaps)，Proxy。其中的Flows类型主要是网络采样数据，例如Netflow，sFlow等；DNS类型的数据就是pcap格式的离线dns数据包文件；Proxy类型的数据是某些代理服务器产生的代理日志文件。
- 存储模块： 在上图中就是“store”部分。Apache Spot直接使用Hadoop作为其存储设施，所以没有单独的存储模块。好处是存储容量可以随便扩展；坏处是Hadoop集群贵啊。
- 机器学习模块： 在上图中就是“Machine Learning”部分。Apache Spot中使用的是Scala语言开发的，使用Spark作为计算引擎。
- 运营分析模块： 在上图中就是“Operational Analytics”部分。此部分才是用户真正关心的部分，用于展示网络威胁情况，判定网络威胁类型等等。项目自带的spot-oa模块，是很弱的。
