

# 开源流量分析系统 Apache Spot 概述


Apache Spot 是一个基于网络流量和数据包分析，通过独特的机器学习方法，发现潜在安全威胁和未知网络攻击能力的开源方案。Apache Spot 利用开源且被优化过的解码器接入二进制网络流量数据和数据包，利用机器学习的方法（主要是LDA 算法）从网络流量中分离出可疑流量，以及特征化独特的网络流量行为。经过上下文增强、噪声过滤、白名单和启发式算法等等一系列手段，最终产生少量且准确的安全威胁事件呈现给用户。

https://www.cnblogs.com/pythonal/p/9242374.html

Apache Spot 是一个基于网络流量和数据包分析，通过独特的机器学习方法，发现潜在安全威胁和未知网络攻击能力的开源方案。目前Apache Spot 已支持对Netflow、sflow、DNS、Proxy 的网络流量分析，主要依靠HDFS、Hive 提供存储能力，Spark提供计算能力，基于LDA 算法提供无监督式机器学习能力，最终依赖Jupyter 提供图形化交互能力。

该项目由Intel 和Cloudera 向Apache 基金会贡献，目前尚处于孵化阶段，最新发布版本为Apache Spot 1.0。


Apache Spot 利用开源且被优化过的解码器接入二进制网络流量数据和数据包，利用机器学习的方法（主要是LDA 算法）从网络流量中分离出可疑流量，以及特征化独特的网络流量行为。经过上下文增强、噪声过滤、白名单和启发式算法等等一系列手段，最终产生少量且准确的安全威胁事件呈现给用户。

Apache Spot 关键特性
 - 识别可疑DNS数据包（Suspicious DNS Packets）

利用深度包检测技术（Deep-packet Inspection）对DNS流量进行画像，经过可视化、正则化以及模式匹配处理，向安全分析师呈现出DNS流量数据中最有可能是威胁的部分。

 - 威胁应急响应（Threat Incident and Response）

给定一个IP地址，Apache Spot能够将跟该IP相关的所有数据按时间序列整合在一起，便于运维人员对威胁事件进行响应。

 - 可疑网络连接发现（Suspicious Connects）

通过机器学习的方法对在网络上进行通信的机器及其通信模式建立相应的模型，数十条原始数据在经过一系列处理后，仅剩余几百条，这些剩余的数据就是最有可能是威胁的部分。

 - 故事板（Storyboard）

安全分析师对威胁事件完成调查后，可以通过故事板去表现事件的来龙去脉，也就是说在故事板中，我们可以了解到攻击者是什么时候攻入系统的？都拿下了哪些机器？怎么拿下的？

 - 开放数据模型（Open Data Models）

为了让威胁检测模型的开发过程更加简单高效，保证个人、企业、社区输出的检测模型的兼容性，Apache Spot 对网络、终端、用户等相关数据进行了标准化定义，规范了这些数据在逻辑层以及物理层的形态。简而言之，开放数据模型保障了不同的开发者在用同一种“语言”在进行威胁检测模型的开发。

 - 协作（Collaboration）

Apache Spot 平台运行于Hadoop大数据平台之上，通过其定义的开放数据模型，使得个人、企业、社区开发者的产出可以无缝衔接。正如攻击者可以利用其它攻击者制作的攻击工具一样，防护方也能够使用其它防护者制作的防护工具。

系统架构

![](http://blog.nsfocus.net/wp-content/uploads/2018/06/3-2.png)

### 组件视图
 1. spot-setup 系统配置、初始化
 2. spot-ingest 数据采集
 3. spot-ml 机器学习数据分析
 4. spot-oa 用户交互界面

### 数据流视图
图详细呈现了Apache Spot整个平台的主要数据流，数据从数据源（左上）起始，先经过数据采集器进行解析处理，而后由流式处理组件完成入库，存储到HDFS中。之后，机器学习组件负责对数据进行分析计算，并将计算结果入库存储。分析结果最终通过用户界面呈现出来（右下）。

![](http://blog.nsfocus.net/wp-content/uploads/2018/06/4-2.png)

### 服务视图

![](http://blog.nsfocus.net/wp-content/uploads/2018/06/5-1.png)

上图是Apache Spot推荐的集群部署下，各个节点上部署的服务。其中：

Master节点作为大数据平台的主节点，主要负责提供数据存储、检索及资源管理服务；

Cloudera Manager节点作为大数据平台的管理节点，也是Apache Spot平台的管理入口；

Worker节点作为大数据平台的计算节点，主要负责提供数据分析能力；

Edge节点作为大数据平台的数据采集节点，主要负责从网络环境中采集数据。



### Apache Spot 环境&部署
#### 基础环境
CDH 5.7+
Spark 2.1.0
YARN
Hive
IMPALA
KAFKA
SPARK(YARN)
Zookeeper

#### Docker 部署
下载镜像：

docker pull apachespot/spot-demo
启动镜像：

 
1
docker run -it -p 8889:8889 apachespot/spot-demo
访问地址：

http://localhost:8889/files/ui/flow/suspicious.html#date=2016-07-08

#### 单机部署
Apache Spot 项目1.0 版本的成熟度还比较低，部署过程中需要人工安装、编译、配置若干基础组件，才能保证Spot 组件的正常运行。又因为Spot 当前的说明文档不够完善，对依赖的组件版本缺乏明确的说明，导致在部署过程中会浪费一些时间。

部署安装的大致流程为：

Hadoop大数据环境部署
Spot-setup初始化配置
Spot-Ingest组件配置数据采集
Spot-Ml组件编译、部署
Spot-OA组件构建、部署

#### 集群部署
Apache Spot 各组件推荐部署位置，结合5.4 服务视图查看：

Component	Node
spot-setup	Edge Server (Gateway)
spot-ingest	Edge Server (Gateway)
spot-ml	YARN Node Manager
spot-oa	Node with Cloudera Manager


### Apache Spot 数据采集
#### Proxy 数据采集
将Spot-Ingest 组件部署到Proxy 服务器上，通过编辑数据采集组件配置文件（$SPOT_INGEST_HOME/ingest_conf.json）指定待采集Proxy 服务器的日志路径来完成Proxy 数据的采集。

#### Flow 数据采集

Spot-Ingest依赖spot-nfdump 解析流量数据包，可通过nfdump 工具包中的nfcapd 将接受netflow 数据并保存到指定的文件。

nfcapd 接收流量的方式示例：


nfcapd -b 0.0.0.0 -p 515 -4 -t 60 -w -D -l /data/spot/flow

注：绿盟IPS 可产生netflow 流量数据，在【系统】-> 【系统配置】—> 【NETFLOW配置】页面配置接收流量的地址即可。

#### DNS 数据采集

Spot-Ingest依赖tshark 解析DNS 数据包。

使用tshark 抓取DNS 数据包保存为pcap 文件示例：


tshark -i em1 -b filesize:2 -w dns-dump.pcap udp port 53

使用tcpdump 抓取DNS 数据包保存为pcap 文件示例：

tcpdump -i eth1 -nt udp dst port 53 -s 0 -G 5 -w "dns-dump_%Y%m%d%H%M%S".pcap -Z root
 
