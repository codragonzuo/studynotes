
## netflow 流量分析模型

主题模型：  
1. 把netflow记录简化成 词，一个词在源IP或者其他词 在目的IP。
2. 每个IP的 netflow词作为 词的集合collection.  
3. 主题模型用来推断collection的主题 ，表达网络流量的一般profile.  这些主题符合某种概率分布。  
4. 每个IP是关于行为的主题的 mix.  
5. 在流量中词的概率对于某个IP 可以通过把netflow 记录简化成主题的 collection ，把词 概率合并从特定IP的 主题mix 来进行估计。



topicCount ： 主题数目  
ipToTopicMix： 数据帧，对每个文档或IP上的主题的分布   
wordToPerTopicProb： 每个词到每个主题概率的MAP   。

```
/**
  * A probabilistic model of the netflow traffic observed in a network.
  *
  * The model uses a topic-modelling approach that:
  * 1. Simplifies netflow records into words, one word at the source IP and another (possibly different) at the
  * destination IP.
  * 2. The netflow words about each IP are treated as collections of these words.
  * 3. A topic modelling approach is used to infer a collection of "topics" that represent common profiles
  * of network traffic. These "topics" are probability distributions on words.
  * 4. Each IP has a mix of topics corresponding to its behavior.
  * 5. The probability of a word appearing in the traffic about an IP is estimated by simplifying its netflow record
  * into a word, and then combining the word probabilities per topic using the topic mix of the particular IP.
  *
  * Create these models using the  factory in the companion object.
  *
  * @param topicCount         Number of topics (profiles of common traffic patterns) used in the topic modelling routine.
  * @param ipToTopicMix       DataFrame assigning a distribution on topics to each document or IP.
  * @param wordToPerTopicProb Map assigning to each word it's per-topic probabilities.
  *                           Ie. Prob [word | t ] for t = 0 to topicCount -1
  */

class FlowSuspiciousConnectsModel(topicCount: Int,
                                  ipToTopicMix: DataFrame,
                                  wordToPerTopicProb: Map[String, Array[Double]]) 
```                                  


估计某个netflow连接符合 某个源IP 或者 某个目的IP 的分布的概率值，并取这两个概率值的最小值。

```
  /**
    * Estimate the probability of a netflow connection as distributed from the source IP and from the destination IP
    * and assign it the least of these two values.
    *
    * @param hour Hour of flow record.
    * @param srcIP Source IP of flow record.
    * @param dstIP Destination IP of flow record.
    * @param srcPort Source port of flow record.
    * @param dstPort Destination port of flow record.
    * @param ipkt ipkt entry of flow record
    * @param ibyt ibyt entry of flow record
    * @param srcTopicMix topic mix assigned of source IP
    * @param dstTopicMix topic mix assigned of destination IP
    * @return Minium of probability of this word from the source IP and probability of this word from the dest IP.
    */
  def score[P <: FloatPointPrecisionUtility](precisionUtility: P)(hour: Int,
                                                                  srcIP: String,
                                                                  dstIP: String,
                                                                  srcPort: Int,
                                                                  dstPort: Int,
                                                                  protocol: String,
                                                                  ibyt: Long,
                                                                  ipkt: Long,
                                                                  srcTopicMix: Seq[precisionUtility.TargetType],
                                                                  dstTopicMix: Seq[precisionUtility.TargetType])
```                                                                  


## 分析结果输出

在ml_ops.sh中定义HDFS_SCORED_CONNECTS=${HPATH}/scores 为score输出目录。

Spot-ml模块输出文件  
$HPATH/flow/scored_results/YYYYMMDD/scores/flow_results.csv

用户评分干涉文件
/user/<user_name>/<data source>/scored_results/<date>/feedback/ml_feedback.csv


```
2.6 安装spot-nfdump[用于收集flow数据]
sudo yum -y groupinstall "Development Tools" 
git clone https://github.com/Open-Network-Insight/spot-nfdump.git 
	cd spot-nfdump
	./install_nfdump.sh
	cd ..
注意：
Flow数据收集命令为：
nfcapd -b 127.0.0.1 -p 515 -4 -t 60 -w -D -l /home/spot/res/flow[该目录可自行指定，此处指定为spot的监听目录]
关键字解释：
-b  bindhost绑定主机
-p  port 监听端口
-4  监听IPv4
-t   指定一个时间，每个时间周期生成一个文件
-w  实现文件输出时间对齐，如5分钟为输出间隔时，将时间对齐为0, 5, 10... 默认不对齐
-D :指定为守护进程模式
-l  base_directory :指定输出文件存储根目录
无法采集到数据

2.7 安装tshark[用于收集DNS数据]
sudo yum -y install gtk2-devel gtk+-devel bison qt-devel qt5-qtbase-devel sudo yum -y 	
sudo yum -y groupinstall "Development Tools"  
	sudo yum -y install libpcap-devel  
#编译libpcap
wget http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz 
tar xvf libpcap-1.7.4.tar.gz
cd libpcap-1.7.4
./configure --prefix=/usr
sudo make install 
cd ..
	#编译Wireshark
	wget  https://1.na.dl.wireshark.org/src/wireshark-2.2.3.tar.bz2
tar -xvf 	wireshark-2.2.3.tar.bz2
	cd wireshark-2.2.3
	./configure --with-gtk2 --disable-wireshark [时间很长]
	make 
	sudo make install
	cd ..
注意：
DNS的数据采集命令：
tshark -i em1 -b filesize:2 -w dns-dump.pcap udp port 53
关键命令解释：
-i <interface>           接口名或网卡编号
-b <ringbuffer opt.> 	 duration:NUM - 在NUM秒后写入下一个文件（文件名由-w参数决定）
                       interval:NUM - create time intervals of NUM secs
                       filesize:NUM - 在文件大于NUM KB后写入下一个文件
                       files:NUM - 循环缓存: 在NUM个文件后替换早前的
-w <outfile|->           使用pcapng格式将报文写入"outfile"文件
                           (或'-'表示标准输出，直接显示在终端)
    Port			端口号
可采集到数据


.17 测试文件准备
Flow：
	必要文件格式 ：nfcapd.20170224222000
	DNS：
	必要文件格式：dns-dump_20191008150128.pcap
	Proxy：
	必要文件格式：proxydata20191004.log【后缀可以自由更改】



Spot-ml模块输入    
数据类型	所需数据	数据存储位置	文件类型     
Netflow		HUSER/flow/hive/y=YEAR/m=MONTH/d=DAY/	Parquet     
DNS		HUSER/dns/hive/y=YEAR/m=MONTH/d=DAY/	Parquet     
Proxy		HUSER/proxy/hive/y=YEAR/m=MONTH/d=DAY/	Parquet    
```
