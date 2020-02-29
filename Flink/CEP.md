# Flink-复杂事件（CEP）

什么是复杂事件CEP？
一个或多个由简单事件构成的事件流通过一定的规则匹配，然后输出用户想得到的数据，满足规则的复杂事件。


特征：
    目标：从有序的简单事件流中发现一些高阶特征
    输入：一个或多个由简单事件构成的事件流
    处理：识别简单事件之间的内在联系，多个符合一定规则的简单事件构成复杂事件
    输出：满足规则的复杂事件

![](https://pic1.zhimg.com/80/v2-1c7057bda8a3ba077a3b8059f35d9bc4_720w.jpg)



![](https://pic2.zhimg.com/80/v2-28dc9a6c4423266323934b150756e821_720w.jpg)



## -NFA非确定有限自动机
CEP-NFA是什么？

Flink 的每个模式包含多个状态，模式匹配的过程就是状态转换的过程，每个状态(state)可以理解成由Pattern构成，为了从当前的状态转换成下一个状态，用户可以在Pattern上指定条件，用于状态的过滤和转换。

实际上Flink CEP 首先需要用户创建定义一个个pattern，然后通过链表将由前后逻辑关系的pattern串在一起，构成模式匹配的逻辑表达。然后需要用户利用NFACompiler，将模式进行分拆，创建出NFA(非确定有限自动机)对象，NFA包含了该次模式匹配的各个状态和状态间转换的表达式。整个示意图就像如下：

![](https://pic3.zhimg.com/80/v2-583aaae9661ea7be6b3101ac64e4283e_720w.jpg)

CEP-三种状态迁移边
    Take: 表示事件匹配成功，将当前状态更新到新状态，并前进到“下一个”状态；
    Procceed: 当事件来到的时候，当前状态不发生变化，在状态转换图中事件直接“前进”到下一个目标状态；
    IGNORE: 当事件来到的时候，如果匹配不成功，忽略当前事件，当前状态不发生任何变化。

```
//构建链接
patterns Pattern pattern = Pattern.begin("start").where(new SimpleCondition() {
 private static final long serialVersionUID = 5726188262756267490L; 
@Override public boolean filter(Event value) throws Exception { 
return value.getName().equals("c");
            }
        }).followedBy("middle").where(new SimpleCondition() {
 private static final long serialVersionUID = 5726188262756267490L; 
@Override public boolean filter(Event value) throws Exception { 
return value.getName().equals("a");
            }
        }).optional(); 
//创建nfa NFA nfa = NFACompiler.compile(pattern, Event.createTypeSerializer(), false);
```


![](https://pic2.zhimg.com/80/v2-53f8b2f9559386babd3c560f5116c1e5_720w.jpg)

此时如果我们加入数据源如下, 理论上的输出结果应该是[event1] 和 [event1，event4]。
```
Event event0 = new Event(40, "x", 1.0); 
Event event1 = new Event(40, "c", 1.0); 
Event event2 = new Event(42, "b", 2.0); 
Event event3 = new Event(43, "b", 2.0); 
Event event4 = new Event(44, "a", 2.0); 
Event event5 = new Event(45, "b", 5.0); 
```

下面我们来分析下，当第一条消息event0来的时候，由于start状态只有Take状态迁移边，这时event0匹配失败，消息被丢失，start状态不发生任何变化；
当第二条消息event1来的时候，匹配成功，这时用event1更新start当前状态，并且进入下一个状态，既mid状态。
而这是我们发现mid状态存在Proceed状态迁移边，以为着事件来临时，可以直接进入下一个状态，这里就是endstat状态，说明匹配结束，存在第一个匹配结果[event1]；
当第三条消息event2来临时，由于之前我们已经进入了mid状态，所以nfa会让我们先匹配mid的条件，匹配失败，由于mid状态存在Ingore状态迁移边，所以当前mid状态不发生变化，event2继续往回匹配start的条件，匹配失败，这时event2被丢弃；
同样的event3也不会影响nfa的所有状态，被丢弃。
当第五条消息event4来临时，匹配mid的条件成功，更新当前mid状态，并且进入“下一个状态”，那就是endstat状态，说明匹配结束，存在第二个匹配结果[event1, event4]。

##CEP 共享缓存SharedBuffer
在引入SharedBuffer概念之前，我们先把上图的例子改一下，将原先pattern1 和 pattern2的连接关系由next，改成followedByAny。

```
Pattern pattern2 = pattern1.followedByAny("pattern2").where(new SimpleCondition() { 
private static final long serialVersionUID = 5726188262756267490L; 
@Override public boolean filter(Event value) throws Exception {
 return value.getName().equals("b");
            }
        }); 
```
followedByAny是非严格的匹配连接关系。表示前一个pattern匹配的事件和后面一个pattern的事件间可以间隔多个任意元素。所以上述的例子输出结果是[event1, event2]、[event4, event5]和[event1, event5]。当匹配event1成功后，由于event2还没到来，需要将event1保存到state1，这样每个状态需要缓冲堆栈来保存匹配成功的事件，我们把各个状态的对应缓冲堆栈集称之为缓冲区。由于上述例子有三种输出，理论上我们需要创建三个独立的缓冲区。

![](https://pic1.zhimg.com/80/v2-3a58474f0defb743992fa8361d1c0f6c_720w.jpg)

做三个独立的缓冲区实现上是没有问题，但是我们发现缓冲区3状态stat1的堆栈和缓冲区stat1的堆栈是一样的，我们完全没有必要分别占用内存。而且在实际的模式匹配场景下，每个缓冲区独立维护的堆栈中可能会有大量的数据重叠。随着流事件的不断流入，为每个匹配结果独立维护缓存区占用内存会越来越大。所以Flink CEP 提出了共享缓存区的概念(SharedBuffer),就是用一个共享的缓存区来表示上面三个缓存区。


![](https://pic2.zhimg.com/80/v2-e17e760f947c1f23d0bdc4e4842b6195_720w.jpg)

在共享缓冲区实现里头，Flink CEP 设计了一个带版本的共享缓冲区。它会给每一次匹配分配一个版本号并使用该版本号来标记在这次匹配中的所有指针。但这里又会面临另一个问题：无法为某次匹配预分配版本号，因为任何非确定性的状态都能派生出新的匹配。而解决这一问题的技术是采用杜威十进制分类法[^1]来编码版本号，它以(.)?(1≤j≤t)的形式动态增长，这里t关联着当前状态。直观地说，它表示这次运行从状态开始被初始化然后到达状态，并从中分割出的实例，这被称之为祖先运行。这种版本号编码技术也保证一个运行的版本号v跟它的祖先运行的版本号兼容。具体而言也就是说：（1）v包含了v’作为前缀或者（2）v与v’仅最后一个数值不同，而对于版本v而言要大于版本v’。根据对这段话的理解，上述共享区从e5往回查找数据，可以达到两条路径分别是[e4,e5]和[e1, e5]。

## CEP应用场景
CEP的应用场景有很多股票曲线预测、网络入侵、物流订单追踪、电商订单、IOT场景等。

## CEP应用案例


案例描述：当相同的card_id在十分钟内，从两个不同的location发生刷卡现象，就会触发报警机制，以便于监测信用卡盗刷等现象。


```
CREATE TABLE datahub_stream (
    `timestamp`               TIMESTAMP,
    card_id                   VARCHAR,
    location                  VARCHAR,
    `action`                  VARCHAR,
    WATERMARK wf FOR `timestamp` AS withOffset(`timestamp`, 1000)
) WITH (
    type = 'datahub'
    ...
);
CREATE TABLE rds_out (
    start_timestamp               TIMESTAMP,
    end_timestamp                 TIMESTAMP,
    card_id                       VARCHAR,
    event                         VARCHAR
) WITH (
    type= 'rds'
    ...
);

--案例描述
-- 当相同的card_id在十分钟内，从两个不同的location发生刷卡现象，就会触发报警机制，以便于监测信用卡盗刷等现象
-- 定义计算逻辑
insert into rds_out
select 
`start_timestamp`, 
`end_timestamp`, 
card_id, `event`
from datahub_stream
MATCH_RECOGNIZE (
    PARTITION BY card_id   -- 按card_id分区，将相同卡号的数据分到同一个计算节点上
    ORDER BY `timestamp`   -- 在窗口内，对事件时间进行排序
    MEASURES               --定义如何根据匹配成功的输入事件构造输出事件
        e2.`action` as `event`,                
        e1.`timestamp` as `start_timestamp`,   --第一次的事件事件为start_timestamp
        LAST(e2.`timestamp`) as `end_timestamp`--最新的事件事件为end_timestamp
    ONE ROW PER MATCH           --匹配成功输出一条
    AFTER MATCH SKIP TO NEXT ROW--匹配跳转到下一行后
    PATTERN (e1 e2+) WITHIN INTERVAL '10' MINUTE  -- 定义两个事件，e1/e2
    DEFINE                     --定义在PATTERN中出现的patternVariable的具体含义
        e1 as e1.action = 'Tom',    --事件一的action标记为Tom
        e2 as e2.action = 'Tom' and e2.location <> e1.location --事件二的action标记为Tom，且事件一和事件二的location不一致
);

```
