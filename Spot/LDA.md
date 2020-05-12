
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
