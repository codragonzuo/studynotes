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



![](https://d2h0cx97tjks2p.cloudfront.net/blogs/wp-content/uploads/sites/2/2017/02/Complex-Event-Processing-with-Apache-Flink-V02-m.jpg)

Pattern API in Flink
Flink CEP program can be written using the pattern API that allows defining complex event patterns. So, each pattern consists of multiple stages or states. The pattern needs to start with initial state and then to go from one state to the next, the user can specify conditions. Now, each state must have a unique name to identify the matched events later on.  So, we can append states to detect complex patterns.

Flink CEP 
## Flink CEP – Pattern API in Apache Flink

Do you know different pattern operations? Let us see some of the most commonly used CEP pattern operations:

a. Begin
It defines pattern starting state and is written as below:
Pattern<Event, ?> start = Pattern.<Event>begin("start");

b. Next
It appends a new pattern state and matching event need to succeed the previous matching pattern as below:
Pattern<Event, ?> next = start.next("next");

c. FollowedBy
It appends a new pattern state but here other events can occur between 2 matching events as below:
Pattern<Event, ?> followedBy = start.followedBy("next");

d. Where
It defines a filter condition for current pattern state and if the event passes the filter, it can match the state as below:
```
patternState.where(new FilterFunction <Event>() {
@Override
public boolean filter(Event value) throws Exception {
return ... // some condition
}
});
```
e. Or
It adds a new filter condition which is ORed with an existing filter condition. Only if an event passes the filter condition, it can match the state.

f. Within
It defines the maximum time interval for an event sequence to match the pattern post which it discards. We can write it as:
patternState.within(Time.seconds(10));


## weather warning scene
Imagine we are designing an application to generate warnings based on certain weather events.

The application should generate weather warnings from a Stream of incoming measurements:
        Extreme Cold (less than -46 °C for three days)
        Severe Heat (above 30 °C for two days)
        Excessive Heat (above 41°C for two days)
        High Wind (wind speed between 39 mph and 110 mph)
        Extreme Wind (wind speed above 110 mph)

https://bytefish.de/blog/apache_flink_series_5/

### Warnings and Patterns
First of all we are designing the model for Warnings and their associated patterns.

All warnings in the application derive from the marker Interface IWarning.
```
// Copyright (c) Philipp Wagner. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

package app.cep.model;

/**
 * Marker interface used for Warnings.
 */
public interface IWarning {

}
```
A warning is always generated by a certain pattern, so we create an interface IWarningPattern for it. The actual patterns for Apache Flink will be defined with the Pattern API.

Once a pattern has been matched, Apache Flink emits a Map<String, TEventType> to the environment, which contains the names and events of the match. So implementations of the IWarningPattern also define how to map between the Apache Flink result and a certain warning.

And finally to simplify reflection when building the Apache Flink stream processing pipeline, the IWarningPattern also returns the type of the warning.
```
// Copyright (c) Philipp Wagner. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

package app.cep.model;

import org.apache.flink.cep.pattern.Pattern;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * A Warning Pattern describes the pattern of a Warning, which is triggered by an Event.
 *
 * @param <TEventType> Event Type
 * @param <TWarningType> Warning Type
 */
public interface IWarningPattern<TEventType, TWarningType extends IWarning> extends Serializable {

    /**
     * Implements the mapping between the pattern matching result and the warning.
     *
     * @param pattern Pattern, which has been matched by Apache Flink.
     * @return The warning created from the given match result.
     */
    TWarningType create(Map<String, List<TEventType>> pattern);

    /**
     * Implementes the Apache Flink CEP Event Pattern which triggers a warning.
     *
     * @return The Apache Flink CEP Pattern definition.
     */
    Pattern<TEventType, ?> getEventPattern();

    /**
     * Returns the Warning Class for simplifying reflection.
     *
     * @return Class Type of the Warning.
     */
    Class<TWarningType> getWarningTargetType();

}
```
### Excessive Heat Warning
Now we can implement the weather warnings and their patterns. The patterns are highly simplified in this article.

One of the warnings could be a warning for Excessive Heat, which is described on Wikipedia as:

Excessive Heat Warning – Extreme Heat Index (HI) values forecast to meet or exceed locally defined warning criteria for at least two days. Specific criteria varies among local Weather Forecast Offices, due to climate variability and the effect of excessive heat on the local population.

Typical HI values are maximum daytime temperatures above 105 to 110 °F (41 to 43 °C) and minimum nighttime temperatures above 75 °F (24 °C).

### Warning Model
The warning should be issued if we expect daytime temperatures above 41 °C for at least two days. So the ExcessiveHeatWarning class takes two LocalWeatherData measurements, and also provides a short summary in its toString method.
```
// Copyright (c) Philipp Wagner. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

package app.cep.model.warnings.temperature;

import app.cep.model.IWarning;
import model.LocalWeatherData;

public class ExcessiveHeatWarning implements IWarning {

    private final LocalWeatherData localWeatherData0;
    private final LocalWeatherData localWeatherData1;

    public ExcessiveHeatWarning(LocalWeatherData localWeatherData0, LocalWeatherData localWeatherData1) {
        this.localWeatherData0 = localWeatherData0;
        this.localWeatherData1 = localWeatherData1;
    }

    public LocalWeatherData getLocalWeatherData0() {
        return localWeatherData0;
    }

    public LocalWeatherData getLocalWeatherData1() {
        return localWeatherData1;
    }

    @Override
    public String toString() {
        return String.format("ExcessiveHeatWarning (WBAN = %s, First Measurement = (%s), Second Measurement = (%s))",
                localWeatherData0.getStation().getWban(),
                getEventSummary(localWeatherData0),
                getEventSummary(localWeatherData1));
    }

    private String getEventSummary(LocalWeatherData localWeatherData) {

        return String.format("Date = %s, Time = %s, Temperature = %f",
                localWeatherData.getDate(), localWeatherData.getTime(), localWeatherData.getTemperature());
    }
}
```
### Warning Pattern

Now comes the interesting part, the Pattern. The ExcessiveHeatWarningPattern implements the IWarningPattern interface and uses the Pattern API to define the matching pattern. You can see, that we are using strict contiguity for the events, using the the next operator. The events should occur for the maximum temperature of 2 days, so we expect these events to be within 2 days.
```
// Copyright (c) Philipp Wagner. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

package app.cep.model.patterns.temperature;

import app.cep.model.IWarningPattern;
import app.cep.model.warnings.temperature.ExcessiveHeatWarning;
import model.LocalWeatherData;
import org.apache.flink.cep.pattern.Pattern;
import org.apache.flink.cep.pattern.conditions.SimpleCondition;
import org.apache.flink.streaming.api.windowing.time.Time;

import java.util.List;
import java.util.Map;

/**
 * Excessive Heat Warning – Extreme Heat Index (HI) values forecast to meet or exceed locally defined warning criteria for at least two days.
 * Specific criteria varies among local Weather Forecast Offices, due to climate variability and the effect of excessive heat on the local
 * population.
 *
 * Typical HI values are maximum daytime temperatures above 105 to 110 °F (41 to 43 °C) and minimum nighttime temperatures above 75 °F (24 °C).
 */
public class ExcessiveHeatWarningPattern implements IWarningPattern<LocalWeatherData, ExcessiveHeatWarning> {

    public ExcessiveHeatWarningPattern() {}

    @Override
    public ExcessiveHeatWarning create(Map<String, List<LocalWeatherData>> pattern) {
        LocalWeatherData first = pattern.get("First Event").get(0);
        LocalWeatherData second = pattern.get("Second Event").get(0);

        return new ExcessiveHeatWarning(first, second);
    }

    @Override
    public Pattern<LocalWeatherData, ?> getEventPattern() {
        return Pattern
                .<LocalWeatherData>begin("First Event").where(
                        new SimpleCondition<LocalWeatherData>() {
                            @Override
                            public boolean filter(LocalWeatherData event) throws Exception {
                                return event.getTemperature() >= 41.0f;
                            }
                        })
                .next("Second Event").where(
                        new SimpleCondition<LocalWeatherData>() {
                            @Override
                            public boolean filter(LocalWeatherData event) throws Exception {
                                return event.getTemperature() >= 41.0f;
                            }
                        })
                .within(Time.days(2));
    }

    @Override
    public Class<ExcessiveHeatWarning> getWarningTargetType() {
        return ExcessiveHeatWarning.class;
    }
}
```
### Converting a Stream into a Stream of Warnings

Now it's time to apply these patterns on a DataStream<TEventType>. In this example we are operating on the Stream of historical weather measurements, which have been used in previous articles. These historical values could easily be exchanged with forecasts, so it makes a nice example.

I have written a method toWarningStream, which will take a DataStream<LocalWeatherData> and generate a DataStream with the warnings.
```java
// Copyright (c) Philipp Wagner. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

package app.cep;

import app.cep.model.IWarning;
import app.cep.model.IWarningPattern;
import app.cep.model.patterns.temperature.SevereHeatWarningPattern;
import app.cep.model.warnings.temperature.SevereHeatWarning;
import model.LocalWeatherData;
import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.api.java.functions.KeySelector;
import org.apache.flink.api.java.typeutils.GenericTypeInfo;
import org.apache.flink.cep.CEP;
import org.apache.flink.cep.PatternSelectFunction;
import org.apache.flink.cep.PatternStream;
import org.apache.flink.streaming.api.TimeCharacteristic;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.datastream.KeyedStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.timestamps.AscendingTimestampExtractor;
import org.apache.flink.streaming.api.windowing.time.Time;
import stream.sources.csv.LocalWeatherDataSourceFunction;
import utils.DateUtilities;

import java.time.ZoneOffset;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class WeatherDataComplexEventProcessingExample {

    public static void main(String[] args) throws Exception {

        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        // Use the Measurement Timestamp of the Event:
        env.setStreamTimeCharacteristic(TimeCharacteristic.EventTime);

        // Path to read the CSV data from:
        final String csvStationDataFilePath = "C:\\Users\\philipp\\Downloads\\csv\\201503station.txt";
        final String csvLocalWeatherDataFilePath = "C:\\Users\\philipp\\Downloads\\csv\\201503hourly_sorted.txt";


        // Add the CSV Data Source and assign the Measurement Timestamp:
        DataStream<model.LocalWeatherData> localWeatherDataDataStream = env
                .addSource(new LocalWeatherDataSourceFunction(csvStationDataFilePath, csvLocalWeatherDataFilePath))
                .assignTimestampsAndWatermarks(new AscendingTimestampExtractor<LocalWeatherData>() {
                    @Override
                    public long extractAscendingTimestamp(LocalWeatherData localWeatherData) {
                        Date measurementTime = DateUtilities.from(localWeatherData.getDate(), localWeatherData.getTime(), ZoneOffset.ofHours(0));

                        return measurementTime.getTime();
                    }
                });

        // First build a KeyedStream over the Data with LocalWeather:
        KeyedStream<LocalWeatherData, String> localWeatherDataByStation = localWeatherDataDataStream
                // Filter for Non-Null Temperature Values, because we might have missing data:
                .filter(new FilterFunction<LocalWeatherData>() {
                    @Override
                    public boolean filter(LocalWeatherData localWeatherData) throws Exception {
                        return localWeatherData.getTemperature() != null;
                    }
                })
                // Now create the keyed stream by the Station WBAN identifier:
                .keyBy(new KeySelector<LocalWeatherData, String>() {
                    @Override
                    public String getKey(LocalWeatherData localWeatherData) throws Exception {
                        return localWeatherData.getStation().getWban();
                    }
                });

        // Now take the Maximum Temperature per day from the KeyedStream:
        DataStream<LocalWeatherData> maxTemperaturePerDay =
                localWeatherDataByStation
                        // Use non-overlapping tumbling window with 1 day length:
                        .timeWindow(Time.days(1))
                        // And use the maximum temperature:
                        .maxBy("temperature");

        // Now apply the SevereHeatWarningPattern on the Stream:
        DataStream<SevereHeatWarning> warnings =  toWarningStream(maxTemperaturePerDay, new SevereHeatWarningPattern());

        // Print the warning to the Console for now:
        warnings.print();

       // Finally execute the Stream:
        env.execute("CEP Weather Warning Example");
    }

    private static <TWarningType extends IWarning> DataStream<TWarningType> toWarningStream(DataStream<LocalWeatherData> localWeatherDataDataStream, IWarningPattern<LocalWeatherData, TWarningType> warningPattern) {
        PatternStream<LocalWeatherData> tempPatternStream = CEP.pattern(
                localWeatherDataDataStream.keyBy(new KeySelector<LocalWeatherData, String>() {
                    @Override
                    public String getKey(LocalWeatherData localWeatherData) throws Exception {
                        return localWeatherData.getStation().getWban();
                    }
                }),
                warningPattern.getEventPattern());

        DataStream<TWarningType> warnings = tempPatternStream.select(new PatternSelectFunction<LocalWeatherData, TWarningType>() {
            @Override
            public TWarningType select(Map<String, List<LocalWeatherData>> map) throws Exception {
                return warningPattern.create(map);
            }
        }, new GenericTypeInfo<TWarningType>(warningPattern.getWarningTargetType()));

        return warnings;
    }

}
```

## Flink example

https://github.com/zylklab/flink_cep_examples

https://github.com/ravthiru/flink-cep-examples

## A FlinkCEP Use Case

https://www.ververica.com/blog/complex-event-processing-flink-cep-update

To explore the potential of FlinkCEP, imagine you are an online retailer and want to trace all shipments that start at one location (A), end at another (B), have at least 5 stops along the way, and are completed within 24 hours. I'll walk through this use case in detail below with a simplified code example (you can find the full code here).

![](https://www.ververica.com/hs-fs/hubfs/Imported_Blog_Media/flink-cep-post-image2-1.png?width=1280&height=720&name=flink-cep-post-image2-1.png)

![](https://www.ververica.com/hs-fs/hubfs/Imported_Blog_Media/flink-cep-post-image5-1.png?width=1280&height=720&name=flink-cep-post-image5-1.png)

![](https://www.ververica.com/hs-fs/hubfs/Imported_Blog_Media/flink-cep-post-image4-1.png?width=1280&height=720&name=flink-cep-post-image4-1.png)

![](https://www.ververica.com/hs-fs/hubfs/Imported_Blog_Media/flink-cep-post-image6-1.png?width=1280&height=720&name=flink-cep-post-image6-1.png)



