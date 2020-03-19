# Rete Algorithm

## RETE算法简述 & 实践


1. 概述
Rete 算法是卡内基梅隆大学的 Charles L.Forgy 博士在 1974 年发表的论文中所阐述的算法。 该算法提供了专家系统的一个高效实现。

Rete 在拉丁语中译为”net”（即网络）。Rete 是一种进行大量模式集合和大量对象集合间比较的高效方法，通过网络筛选的方法找出所有匹配各个模式的对象和规则。

其核心思想是用分离的匹配项构造匹配网络，同时缓存中间结果。以空间换时间。规则编译（rule compilation）和运行时执行（runtime execution）。

2. 规则编译（rule compilation）
规则编译是指根据规则集生成高效推理网络的过程

2.1. 相关概念：
Fact（事实）:对象之间及对象属性之间的关系
Rule（规则）:是由条件和结论构成的推理语句，一般表示为if…Then。一个规则的if部分称为LHS（left-hand-side），then部分称为RHS（right hand side）。
Module（模式）：就是指IF语句的条件。这里IF条件可能是有几个更小的条件组成的大条件。模式就是指的不能在继续分割下去的最小的原子条件。
2.2. RETE网络节点类型
RETE网络示意图

![](https://upload-images.jianshu.io/upload_images/13416824-241499e42e8e218c.png)

Root Node：所有对象进入网络的入口，在一个网络中只有一个根节点。借用Rete算法经典的示例：

1-input node：可分为ObjectTypeNode, AlphaNode, LeftInputAdapterNode等。

Object Type Node：事实从根节点进入Rete网络后，会立即进入Object Type Node节点。Object Type Node提供了按对象类型过滤对象的能力，通过此类节点可使规则引擎不做额外的工作。Cheese类型的事实进入网络后，只需经过类型为Cheese的Object Type Node之后的节点。如下图

![](https://upload-images.jianshu.io/upload_images/13416824-520f19a1d3b1abbc.png)

Alpha Node：Alpha 节点是规则的条件部分的一个模式。通常用于评估字面的条件。如下图，两个Alpha Node 分别评估了Cheese事实的name和strength属性。

![](https://upload-images.jianshu.io/upload_images/13416824-40b8f67eb6f193a0.png)

Left Input Adapter Node：作用是输入一个对象，传播为一个单对象列表（元组）。这块有疑问。后续会考究。

2-input node（Beta Node）: 拥有两个输入的节点。Beta Node 节点用于比较两个对象。两个对象可能是相同或不同的类型。Beta Node主要包含Join Node 和 Not Node两种类型。
Join Node：用作连接（join）操作的节点，相当于数据库的表连接操作。
NotNode：根据右边输入对左边输入的对象数组进行过滤，两个 NotNode 可以完成‘ exists ’检查。

Terminal Node：到达一个终端节点，表示单条规则匹配了所有的条件，网络中有多个终端节点。当单条规则中有or时，也会产生多个终端节点。

完整的示例：
```
规则文件
rule1
when
Cheese($cheddar : name == "cheddar" )
$person : Person( favouriteCheese == $cheddar )
then
System.out.println($person.getName() + " likes cheddar" );
end

rule2
when
Cheese( $cheddar : name == "cheddar" )
$person : Person( favouriteCheese != $cheddar )
then
System.out.println($person.getName() + " does not like cheddar" );
end
```
Rete网络：

![](https://upload-images.jianshu.io/upload_images/13416824-4573bbcc0037a1cd.png)

从图上可以看到，编译后的RETE网络中，AlphaNode是共享的，而BetaNode不是共享的。两条规则的BetaNode的不同。然后这两条规则有各自的Terminal Node。

2.3. 创建Rete网络
RETE算法通过构建一个网络进行匹配，具体过程如下：

创建root节点（根节点），推理网络的入口。
拿到规则1，从规则1中取出模式1（模式就是最小的原子条件）。

a) 检查模式1中的参数类型，如果是新类型，添加一个类型节点。
b) 检查模式1对应的Alpha节点是否存在，如果存在记录下节点的位置；如果没有，将模式1作为一个Alpha节点加入到网络中。同时根据Alpha节点建立Alpah内存表。
c) 重复b，直到处理完所有模式。
d) 组合Beta节点：Beta(2)左输入节点为Alpha(1)，右输入节点为Alpha(2)；Beta(i)左输入节点是Beta(i-1),右输入节点为Alpha(i)，并将两个父节点的内存表内联成为自己的内存表
e) 重复d，直到所有Beta节点处理完毕
f) 将动作Then部分封装成最后节点做为Beta（n）

重复2，直到所有规则处理完毕

3. 运行时执行（runtime execution）
推理引擎在进行模式匹配时，先对事实进行断言，为每一个事实建立WME(Working Memory Element)，然后将WME从RETE鉴别网络的根结点开始匹配，因为WME传递到的结点类型不同采取的算法也不同，所以需要对alpha结点和beta结点处理WME的不同情况而分开讨论。

1)如果WME的类型和根节点的后继结点TypeNode(alpha结点的一种)所指定的类型相同，则会将该事实保存在该TypeNode结点对应的alpha存储区中，该WME被传到后继结点继续匹配，否则会放弃该WME的后续匹配；
2)如果WME被传递到alpha结点，则会检测WME是否和该结点对应的模式相匹配，若匹配，则会将该事实保存在该alpha结点对应的存储区中，该WME被传递到后继结点继续匹配，否则会放弃该WME的后续匹配：
3)如果WME被传递到beta结点的右端，则会加入到该beta结点的right存储区，并和left存储区中的Token进行匹配(匹配动作根据beta结点的类型进行，例如：join，projection，selection)，匹配成功，则会将该WME加入到Token中，然后将Token传递到下一个结点，否则会放弃该WME的后续匹配：
4)如果Token被传递到beta结点的左端，则会加入到该beta结点的left存储区，并和right存储区中的WME进行匹配(匹配动作根据beta结点的类型进行，例如：join，projection，selection)，匹配成功，则该Token会封装匹配到的WME形成新的Token，传递到下一个结点，否则会放弃该Token的后续匹配；
5)如果WME被传递到beta结点的左端，将WME封装成仅有一个WME元素的WME列表做为Token，然后按照 4) 所示的方法进行匹配：
6)如果Token传递到终结点，则和该根结点对应的规则被激活，建立相应的Activation，并存储到Agenda当中，等待激发。

   7)如果WME被传递到终结点，将WME封装成仅有一个WME元素的WME列表做为Token，然后按照 6) 所示的方法进行匹配；

4. 一些实践
```
由于从事运输行业，故以业内的典型场景作为实践示例。
例如：我们需要将提供“机票+酒店”、“机票+酒店+贵宾休息室”两种类型的产品给旅客。
机票、酒店、贵宾休息室需要满足一些基本的限制条件。并且：
“机票+酒店”产品要保障：酒店位于目的地且到达当天可以入住。
“机票+酒店+贵宾休息室”产品要保障：酒店位于目的地且到达当天可以入住。贵宾休息室位于出发城市。
```
下图展示了打包规则所构成的RETE网络。

![](https://upload-images.jianshu.io/upload_images/13416824-65b456a664322229.png)

基于Drools实现相关规则：

数据模型
```
package com.myspace.packagedproduct;
public class Location implements java.io.Serializable {
    static final long serialVersionUID = 1L;
    @org.kie.api.definition.type.Label(value = "\u56FD\u5BB6")
    private java.lang.String country;
    @org.kie.api.definition.type.Label(value = "\u7701\u4EFD")
    private java.lang.String province;
    @org.kie.api.definition.type.Label(value = "\u57CE\u5E02")
    private java.lang.String city;
   ...Getter、Setter方法...
}

public class Segment implements java.io.Serializable {
    static final long serialVersionUID = 1L;
    @org.kie.api.definition.type.Label("产品编码")
    private java.lang.String proCode;
    @org.kie.api.definition.type.Label("产品名称")
    private java.lang.String proName;
    @org.kie.api.definition.type.Label("出发城市")
    private java.lang.String startCity;
    @org.kie.api.definition.type.Label("到达城市")
    private java.lang.String arriveCity;
    @org.kie.api.definition.type.Label("舱位")
    private java.lang.String cabin;
    @org.kie.api.definition.type.Label("航班日期")
    private java.util.Date flightDate;
        ...Getter、Setter方法...
}

public class Hotel implements java.io.Serializable {
    static final long serialVersionUID = 1L;
    @org.kie.api.definition.type.Label("产品编码")
    private java.lang.String proCode;
    @org.kie.api.definition.type.Label("产品名称")
    private java.lang.String proName;
    @org.kie.api.definition.type.Label("房型")
    private java.lang.String roomType;
    @org.kie.api.definition.type.Label("入住日期")
    private java.util.Date checkInDate;
    @org.kie.api.definition.type.Label("位置")
    private com.myspace.packagedproduct.Location location;
    @org.kie.api.definition.type.Label(value = "\u662F\u5426\u53EF\u6253\u5305\u9500\u552E")
    private java.lang.Boolean ifCanPackageSale;
        ...Getter、Setter方法...
}

public class ReservedLounge implements java.io.Serializable {
    static final long serialVersionUID = 1L;
    @org.kie.api.definition.type.Label("产品编码")
    private java.lang.String proCode;
    @org.kie.api.definition.type.Label("产品名称")
    private java.lang.String proName;
    @org.kie.api.definition.type.Label("位置")
    private com.myspace.packagedproduct.Location location;
    @org.kie.api.definition.type.Label("是否自营")
    private boolean selfSupport;
        ...Getter、Setter方法...
}

public class PackagedProduct implements java.io.Serializable {
    static final long serialVersionUID = 1L;
    @org.kie.api.definition.type.Label(value = "\u6210\u5458\u4EA7\u54C1ID\u5217\u8868")
    private java.util.List<java.lang.String> itemProductCodes;
      ...Getter、Setter方法...
}
规则
 import java.util.Date;
 import java.text.SimpleDateFormat;
 import java.math.BigDecimal;
 import java.util.List;
 import com.alibaba.fastjson.JSON;
 import com.alibaba.fastjson.JSONObject;
 import com.alibaba.fastjson.JSONArray;
 import com.myspace.packagedproduct.*;
 import com.myspace.packagedproduct.PackagedProduct
 import java.util.ArrayList;
 global java.util.Date now;
 global java.text.SimpleDateFormat dateFormat;

rule "segment_hotel"
    when
        seg : Segment( startCity in ( "XMN", "PEK", "FOC", "HGH", "TSN", "JJN" ) , cabin == "Y" )
        hotel : Hotel( ifCanPackageSale == true , location != null , location.city == seg.arriveCity )
    then

        System.out.println("【机+酒产品】"+seg.getProCode()+" + "+hotel.getProCode());

end

rule "segment_hotel_lounge"
    dialect "java"
    when
        seg : Segment( startCity in ( "XMN", "PEK", "FOC", "HGH", "TSN", "JJN" ) , cabin == "Y" )
        hotel : Hotel( ifCanPackageSale == true , location != null , location.city == seg.arriveCity )
        lounge:ReservedLounge(selfSupport==true,location.city == seg.startCity)
    then
    System.out.println("【机+酒+休息室产品】"+seg.getProCode()+" + "+hotel.getProCode()+" + "+lounge.getProCode());
end
规则调用语句
   @Test
    public void testPackagedProduct() throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date1 = sdf.parse("2018-09-30");
        Date date2 = sdf.parse("2018-09-31");
        KieSession kieSession = this.getKieSessionBySessionName("mapAndList-rules");
        Segment seg = new Segment();
        seg.setArriveCity("PEK");
        seg.setStartCity("XMN");
        seg.setFlightDate(date1);
        seg.setCabin("Y");
        seg.setProCode("seg1");
        Segment seg2 = new Segment();
        seg2.setArriveCity("PEK");
        seg2.setStartCity("XMN");
        seg2.setFlightDate(date1);
        seg2.setCabin("T");
        seg2.setProCode("seg2");
        Segment seg3 = new Segment();
        seg3.setArriveCity("XMN");
        seg3.setStartCity("TSN");
        seg3.setFlightDate(date1);
        seg3.setCabin("Y");
        seg3.setProCode("seg3");
        Hotel hotel = new Hotel();
        hotel.setCheckInDate(date1);
        hotel.setIfCanPackageSale(true);
        hotel.setLocation(new Location("", "", "XMN"));
        hotel.setProCode("hotel1");
        Hotel hotel2 = new Hotel();
        hotel2.setCheckInDate(date2);
        hotel2.setIfCanPackageSale(true);
        hotel2.setLocation(new Location("", "", "XMN"));
        hotel2.setProCode("hotel2");
        Hotel hotel3 = new Hotel();
        hotel3.setCheckInDate(date1);
        hotel3.setIfCanPackageSale(true);
        hotel3.setLocation(new Location("", "", "NRT"));
        hotel3.setProCode("hotel3");
        Hotel hotel4 = new Hotel();
        hotel4.setCheckInDate(date1);
        hotel4.setIfCanPackageSale(true);
        hotel4.setLocation(new Location("", "", "PEK"));
        hotel4.setProCode("hotel4");

        ReservedLounge lounge = new ReservedLounge();
        lounge.setLocation(new Location("", "", "XMN"));
        lounge.setSelfSupport(true);
        lounge.setProCode("lounge1");
        ReservedLounge lounge2 = new ReservedLounge();
        lounge2.setLocation(new Location("", "", "PEK"));
        lounge2.setSelfSupport(true);
        lounge2.setProCode("lounge2");
        ReservedLounge lounge3 = new ReservedLounge();
        lounge3.setLocation(new Location("", "", "XMN"));
        lounge3.setSelfSupport(false);
        lounge3.setProCode("lounge3");
        kieSession.insert(seg);
        kieSession.insert(seg2);
        kieSession.insert(seg3);
        kieSession.insert(hotel);
        kieSession.insert(hotel2);
        kieSession.insert(hotel3);
        kieSession.insert(hotel4);
        kieSession.insert(lounge);
        kieSession.insert(lounge2);
        kieSession.insert(lounge3);
        kieSession.fireAllRules();
        kieSession.dispose();
    }
执行结果
【机+酒产品】seg1 + hotel4
【机+酒产品】seg3 + hotel1
【机+酒产品】seg3 + hotel2
【机+酒+休息室产品】seg1 + hotel4 + lounge1
```
### 5. 为何RETE算法效率高

5.1. RETE算法优于普通代码逻辑

借用上面的示例， 如：Segment，Hotel，ReservedLounge类型的产品分别有10个。按照一般的程序处理逻辑，我们要写三个For循环去处理三类产品的打包操作，计算次数为三类产品数目的笛卡尔积级别的，即：10*10*10 =1000。

而RETE算法采用空间换时间的策略，将中间的计算结果缓存下来（Alpha Memory，Beta Memory）。计算次数为10+10+10（Alpha节点计算次数）加上2次join/projection操作（Beta节点计算次数）。基于内存中的数据做join/projection/selection操作效率很高。

5.2. Rete算法优于传统的模式匹配算法。

a． Rete 算法是一种启发式算法，不同规则之间往往含有相同的模式，因此在 beta-network 中可以共享 BetaMemory 和 betanode。如果某个 betanode 被 N 条规则共享，则算法在此节点上效率会提高 N 倍。

b. Rete 算法由于采用 AlphaMemory 和 BetaMemory 来存储事实，当事实集合变化不大时，保存在 alpha 和 beta 节点中的状态不需要太多变化，避免了大量的重复计算，提高了匹配效率。

c. 从 Rete 网络可以看出，Rete 匹配速度与规则数目无直接关系，这是因为事实只有满足本节点才会继续向下沿网络传递。

### 6.RETE算法的缺点

RETE算法使用了存储区存储已计算的中间结果，以空间换取时间，从而加快系统的速度。然而存储区根据规则的条件于事实的数目成指数级增长，极端情况下会耗尽系统资源。

7. RETE算法的衍生

KIE团队改良了原生的Rete算法：ReteOO ...



## Production Matching for Large Learning Systems

http://reports-archive.adm.cs.cmu.edu/anon/1995/CMU-CS-95-113.pdf



## RETE算法翻译

https://github.com/yikebocai/rete/blob/master/2-the-basic-rete-algorithm.md
