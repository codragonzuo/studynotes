## 关于Rete算法以及JSR94的简单介绍 
  rogerhjh 发布于 2015/06/18 10:21 字数 2669 阅读 559 收藏 1 点赞 0  评论 0

规则引擎简介

Java规则引擎是推理引擎的一种，它起源于基于规则的专家系统。

Java规则引擎将业务决策从应用程序代码中分离出来，并使用预定义的语义模块编写业务决策。Java规则引擎接受数据输入，解释业务规则，并根据规则作出业务决策。从这个意义上来说，它是软件方法学在"关注点分离"上的一个重要的进展。

JSR-94规范定义了独立于厂商的标准API，开发人员可以通过这个标准的API使用Java规则引擎规范的不同产品实现。但值得注意的是，这个规范并没有强制统一规则定义的语法，因此，当需要将应用移植到其他的Java规则引擎实现时，可能需要变换规则定义。


基于规则的专家系统（RBES）

专家系统是人工智能的一个分支，它模仿人类的推理方式，使用试探性的方法进行推理，并使用人类能理解的术语解释和证明它的推理结论。专家系统有很多分类：神经网络、基于案例推理和基于规则系统等。

规则引擎则是基于规则的专家系统的一部分。为了更深入的了解Java规则引擎，下面简要地介绍基于规则的专家系统（RBES）。



RBES的技术架构

RBES包括三部分：Rule Base（knowledge base）、Working Memory（fact base）和Rule Engine（推理引擎）。它们的结构如下所示：

 


 


如上图所示，规则引擎包括三部分：Pattern Matcher、Agenda和Execution Engine。Pattern Matcher决定选择执行哪个规则，何时执行规则；Agenda管理PatternMatcher挑选出来的规则的执行次序；Execution Engine负责执行规则和其他动作。



RBES的推理（规则）引擎

和人类的思维相对应，规则引擎存在两者推理方式：演绎法（Forward-Chaining）和归纳法（Backward-Chaining）。演绎法从一个初始的事实出发，不断地应用规则得出结论（或执行指定的动作）。而归纳法则是从假设出发，不断地寻找符合假设的事实。

Rete算法是目前效率最高的一个Forward-Chaining推理算法，Drools项目是Rete算法的一个面向对象的Java实现。

规则引擎的推理步骤如下：

1. 将初始数据（fact）输入Working Memory。

2. 使用Pattern Matcher比较规则（rule）和数据（fact）。

3. 如果执行规则存在冲突（conflict），即同时激活了多个规则，将冲突的规则放入冲突集合。

4. 解决冲突，将激活的规则按顺序放入Agenda。

5. 使用规则引擎执行Agenda中的规则。重复步骤2至5，直到执行完毕所有Agenda中的规则。


JSR 94：Java规则引擎API

基于规则编程是一种声明式的编程技术，这种技术让你可以使用试探性的规则而不是过程性的指令来解决问题。规则引擎是一个软件模块，它决定了如何将规则作用于推理数据。在保险业和金融服务业都广泛地使用了基于规则的编程技术，当需要在大量的数据上应用复杂的规则时，规则引擎技术特别有用。

Java规则引擎API由javax.rules包定义，是访问规则引擎的标准企业级API。Java规则引擎API允许客户程序使用统一的方式和不同厂商的规则引擎产品交互，就像使用JDBC编写独立于厂商访问不同的数据库产品一样。Java规则引擎API包括创建和管理规则集合的机制，在Working Memory中添加，删除和修改对象的机制，以及初始化，重置和执行规则引擎的机制。


使用Java规则引擎API

Java规则引擎API把和规则引擎的交互分为两类：管理活动和运行时活动。管理活动包括实例化规则引擎和装载规则。而运行时活动包括操作Working Memory和执行规则。如果你在J2SE环境中使用Java规则引擎，你可能需要在代码中执行以上所有的活动。相反，在J2EE环境中，Java规则引擎的管理活动是应用服务器的一部分。JSR 94的参考实现包括了一个JCA连接器，用于通过JNDI获得一个RuleServiceProvider。



设置规则引擎

Java规则引擎的管理活动阶段开始于查找一个合适的javax.rules.RuleServiceProvider对象，这个对象是应用程序访问规则引擎的入口。在J2EE环境中，你可能可以通过JNDI获得RuleServiceProvider。否则，你可以使用javax.rules.RuleServiceProviderManager类：
```
javax.rules.RuleServiceProviderManager class:


String implName = "org.jcp.jsr94.ri.RuleServiceProvider";

Class.forName(implName);

RuleServiceProvider serviceProvider = RuleServiceProviderManager.getRuleServiceProvider(implName);
```
一旦拥有了RuleServiceProvider对象，你可以获得一个javax.rules.admin.RuleAdministrator类。从RuleAdministrator类中，你可以得到一个RuleExecutionSetProvider，从类名可以知道，它用于创建javax.rules.RuleExecutionSets对象。RuleExecutionSet基本上是一个装入内存的，准备好执行的规则集合。

包javax.rules.admin包括两个不同的RuleExecutionSetProvider类。RuleExecutionSetProvider类本身包括了从Serializable对象创建RuleExecutionSets的方法，因此在规则引擎位于远程服务器的情况下，仍然可以使用RuleExecutionSetProvider类，构造器的参数可以通过RMI来传递。另一个类是LocalRuleExecutionSetProvider，包含了其他方法，用于从非Serializable资源（如java.io.Reader－本地文件）创建RuleExectionSets。假设拥有了一个RuleServiceProvider对象，你可以从本地文件rules.xml文件创建一个RuleExectionSet对象。如以下的代码所示：
```
RuleAdministrator admin = serviceProvider.getRuleAdministrator();
HashMap properties = new HashMap();
properties.put("name", "My Rules");
properties.put("description", "A trivial rulebase");

FileReader reader = new FileReader("rules.xml");
RuleExecutionSet ruleSet = null;
try {
     LocalRuleExecutionSetProvider lresp =
     admin.getLocalRuleExecutionSetProvider(properties);

     ruleSet = lresp.createRuleExecutionSet(reader, properties);
} finally {
     reader.close();
}
···
接下来，你可以使用RuleAdministrator注册获得的RuleExecutionSet，并给它分配一个名称。在运行时，你可以用同一个名称创建一个RuleSession；该RuleSession使用了这个命名的RuleExecutionSet。参见下面的例子：
admin.registerRuleExecutionSet("rules", ruleSet, properties);


  
执行规则引擎

在运行时阶段，你可以参见一个RuleSession对象。RuleSession对象基本上是一个装载了特定规则集合的规则引擎实例。你从RuleServiceProvider得到一个RuleRuntime对象，接下来，从javax.rules.RuleRuntime得到RuleSession对象。

RuleSession分为两类：stateful和stateless。它们具有不同的功能。StatefulRuleSession的Working Memory能够在多个方法调用期间保存状态。你可以在多个方法调用期间在Working Memory中加入多个对象，然后执行引擎，接下来还可以加入更多的对象并再次执行引擎。相反，StatelessRuleSession类是不保存状态的，为了执行它的executeRules方法，你必须为Working Memory提供所有的初始数据，执行规则引擎，得到一个内容列表作为返回值。

下面的例子中，我们创建一个StatefulRuleSession实例，添加两个对象（一个Integer和一个String）到Working Memory，执行规则，然后得到Working Memory中所有的内容，作为java.util.List对象返回。最后，我们调用release方法清理RuleSession：
```
RuleRuntime runtime = rsp.getRuleRuntime();
StatefulRuleSession session = (StatefulRuleSession)
runtime.createRuleSession("rules", properties,
RuleRuntime.STATEFUL_SESSION_TYPE);
session.addObject(new Integer(1));
session.addObject("A string");
session.executeRules();
List results = session.getObjects();
session.release();
```

集成JSR 94产品实现

支持JSR 94规范的产品实现既有收费的商业产品，也有免费的开源项目。目前最为成熟，功能最强大的商业产品是ILOG公司的JRules，该公司也是JSR 94规范的积极推动者之一。支持JSR 94规范的开源项目目前很少，只有Drools和JLisa项目。值得注意的是，Jess不是开源项目，它可以免费用于学术研究，但用于商业用途则要收费。
```
  JSR 94的产品实现
        Java规则引擎商业产品有：
           l. ILOG公司的JRules
          2. BlazeSoft公司的Blaze
          3. Rules4J
          4. Java Expert System Shell （JESS）
        开源项目的实现包括：
          l. Drools项目

         2. JLisa项目
         3. OFBiz Rule Engine（不支持JSR 94）
         4. Mandarax（目前不支持JSR 94）
```

使用Spring集成

集成Java规则引擎的目标是，使用标准的Java规则引擎API封装不同的实现，屏蔽不同的产品实现细节。这样做的好处是，当替换不同的规则引擎产品时，可以不必修改应用代码。

封装JSR94实现

RuleEngineFacade类封装Java规则引擎，使用ruleServiceProviderUrl和ruleServiceProviderImpl两个参数，屏蔽了不同产品的配置。代码如下：
```
public class RuleEngineFacade {

      private RuleAdministrator ruleAdministrator;
      private RuleServiceProvider ruleServiceProvider;
      private LocalRuleExecutionSetProvider ruleSetProvider;
      private RuleRuntime ruleRuntime;

      // configuration parameters
      private String ruleServiceProviderUrl;
      private Class ruleServiceProviderImpl;

public void setRuleServiceProviderUrl(String url) {
      this.ruleServiceProviderUrl = url;
}
 public void setRuleServiceProviderImpl(Class impl) {
      this.ruleServiceProviderImpl = impl;
}
 public void init() throws Exception {
      RuleServiceProviderManager.registerRuleServiceProvider(
      ruleServiceProviderUrl, ruleServiceProviderImpl);

      ruleServiceProvider = RuleServiceProviderManager.getRuleServiceProvider(ruleServiceProviderUrl);

      ruleAdministrator = ruleServiceProvider.getRuleAdministrator();
      ruleSetProvider = ruleAdministrator.getLocalRuleExecutionSetProvider(null);
}

public void addRuleExecutionSet(String bindUri,InputStream resourceAsStream)
          throws Exception {

      Reader ruleReader = new InputStreamReader(resourceAsStream);
      RuleExecutionSet ruleExecutionSet =
      ruleSetProvider.createRuleExecutionSet(ruleReader, null);

      ruleAdministrator.registerRuleExecutionSet(bindUri,ruleExecutionSet,null);
}

public StatelessRuleSession getStatelessRuleSession(String key)
         throws Exception {

      ruleRuntime = ruleServiceProvider.getRuleRuntime();
      return (StatelessRuleSession) ruleRuntime.createRuleSession(key, null, RuleRuntime.STATELESS_SESSION_TYPE);
}

public StatefulRuleSession getStatefulRuleSession(String key)
         throws Exception {

      ruleRuntime = ruleServiceProvider.getRuleRuntime();
      return (StatefulRuleSession) ruleRuntime.createRuleSession(
      key, null, RuleRuntime.STATEFUL_SESSION_TYPE);
}

public RuleServiceProvider getRuleServiceProvider() {
      return this.ruleServiceProvider;
}
}
```

    
封装规则

Rule类封装了具体的业务规则，它的输入参数ruleName是定义规则的配置文件名，并依赖于RuleEngineFacade组件。代码如下：
```
public class Rule {

         private String ruleName;
         private RuleEngineFacade engineFacade;
 
         public void init() throws Exception {
              InputStream is = Rule.class.getResourceAsStream(ruleName);
              engineFacade.addRuleExecutionSet(ruleName, is);
              is.close();
        }
 
        public void setRuleName(String name) {
             this.ruleName = name;
        }
 
        public void setEngineFacade(RuleEngineFacade engine) {
            this.engineFacade = engine;
        }
 
        public StatelessRuleSession getStatelessRuleSession()
                     throws Exception {
            return engineFacade.getStatelessRuleSession(ruleName);
        }
 
        public StatefulRuleSession getStatefuleRuleSession()
                     throws Exception {
            return engineFacade.getStatefulRuleSession(ruleName);
        }
    }
```

组装规则组件

组装规则的配置文件如下：
```
<bean id="ruleEngine" class="spring.RuleEngineFacade" init-method="init" singleton="false">
      <property name="ruleServiceProviderUrl">
           <value>http://drools.org/</value>
      </property>
      <property name="ruleServiceProviderImpl">
           <value>org.drools.jsr94.rules.RuleServiceProviderImpl</value>
      </property>
</bean>
<bean id="fibonacci" class="spring.Rule" init-method="init">
      <property name="ruleName">
          <value>/test/fibonacci.drl</value>
      </property>
      <property name="engineFacade">
          <ref local="ruleEngine"/>
      </property>
</bean>
```

    测试用例
       最后，我们编写测试用例，代码如下：
```
public class JSRTest extends TestCase {

      ApplicationContext ctx = null;

      protected void setUp() throws Exception {
           super.setUp();
           ctx = new FileSystemXmlApplicationContext("testrule.xml");
      }
      public void testGetRuleSession() throws Exception {
           Rule rule = (Rule)ctx.getBean("fibonacci");
           assertNotNull(rule.getStatefuleRuleSession());
           assertNotNull(rule.getStatelessRuleSession());
      }
      public void testStatelessRule() throws Exception {
           Rule rule = (Rule)ctx.getBean("fibonacci");
           Fibonacci fibonacci = new Fibonacci(50);
           List list = new ArrayList();
           list.add(fibonacci);
           StatelessRuleSession session = rule.getStatelessRuleSession();
           session.executeRules(list);
           session.release();
      }
      public void testStatefulRule() throws Exception {
            Rule rule = (Rule)ctx.getBean("fibonacci");
            Fibonacci fibonacci = new Fibonacci(50);
            StatefulRuleSession session = rule.getStatefuleRuleSession();
            session.addObject(fibonacci);
            session.executeRules();
            session.release();
       }
}
```
 

运行测试用例，出现绿条，测试通过。


规则定义语言之间的变换

因为JSR 94规范并没有强制统一规则定义的语法，因此，当需要将应用移植到其他的Java规则引擎实现时，可能需要变换规则定义，如将Drools私有的DRL规则语言转换成标准的ruleML，Jess规则语言转换成ruleML等。这个工作一般由XSLT转换器来完成。
