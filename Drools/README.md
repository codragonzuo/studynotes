
# Drools

Drools规则引擎技术指南

## Drools高级用法

### 1. excel决策表和drl规则

决策表的关键字和DRL规则文件的关键字对应。

通过java代码可把excel决策表转换为drl规则。

### 2. DSL领域语言

dsl模板文件

xml配置文件

### 3. 规则模板

规则模板drt文件 + 模板数据源xls文件

xml规则模板配置


规则数据文件


### 4. 规则流 Rule Flow

规则流通过Workbench 或 IDE构建。

流文件 bpmn


规则流属性必须添加流程文件， 规则体重的规则流属性要和流程文件规则元素组件的RuleFlowGroup一一对应。

### 规则流事件

### 5. 规则流网关

- split
- join

### 规则构建

- KieServices
- KieContainer
- KieBase
- KieSession


### 6. 事件监听

- RuleRuntimeEventListener

规则运行时的监听， 监听 instert, update, delete操作

- AgendaEventListener

议程事项的监听，提供10个接口方法。比如调用规则前，调用规则后，监听规则流的调用前和调用后。



- ProcessEventListener

流程事项的监听。提供12种方法。主要针对流程与流程中元素节点的天天。

## 动态规则

动态规则，是指在不重启服务器的前提下使业务规则发生变化，且不影响服务器的正常使用，从而实现动态业务变化的规则。

动态规则的7种方式：

- 字符串方式
- 通过规则模板方式对规则进行修改
- Workbench自动扫描
- Workbench整合Kie-Server
- 指定文件方式，通过规则文件执行规则
- 通过代码生成kjar
- 模仿官方文档方式
kieservices--kiecontainer--sessionname--kiesession


## 规则引擎

核心目的之一是把业务决策从代码中分离，是代码和业务解耦合。

通过特定的语法内容编写业务模块，由API进行解析并对外提供执行接口，并接收输入数据，进行业务逻辑处理并返回执行结果。





## Understanding Complex Event Processing (CEP)

https://mapr.com/blog/better-complex-event-processing-scale-using-microservices-based-streaming-architecture-part-1/

CEP is about applying business rules to streaming event data. Event data is simply data with a timestamp field.

- CEP Rule-engine vs. Hand Coding

What are the parts of this type of project?

Data ingest

Defining rules on the data

Executing the rules

Taking action from rules when the conditions are met.

---

第一篇 基 石 篇

第1章 Drools概述 002

1.1 程序来源于生活 003

1.2 Drools是什么 003

1.3 Drools简要概述 003

1.4 Drools发展趋势 004

1.5 Drools版本 004

1.6 Drools新特性 005

1.7 KIE生命周期 006

1.8 为什么要用规则引擎 006

第2章 Drools入门实例 008

2.1 经典Hello World 009

2.2 对象引用 013

2.3 Drools配置文件 020

第二篇 基 础 篇

第3章 Drools基础语法 026

3.1 规则文件 027

3.2 规则体语法结构 028

3.3 pattern（匹配模式） 028

3.4 运算符 030

3.5 约束连接 032

3.6 语法扩展 048

3.7 规则文件drl 056

第4章 Drools规则属性 057

4.1 属性no-loop 058

4.2 属性ruleflow-group 063

4.3 属性lock-on-active 063

4.4 属性salience 065

4.5 属性enabled 067

4.6 属性dialect 068

4.7 属性date-effective 069

4.8 属性date-expires 070

4.9 属性duration 073

4.10 属性activation-group 073

4.11 属性agenda-group 076

4.12 属性auto-focus 082

4.13 属性timer 082

第5章 关键字及错误信息 085

5.1 关键字说明 086

5.2 错误信息 086

第三篇 中 级 篇

第6章 规则中级语法 090

6.1 package说明 091

6.2 global全局变量 094

6.3 query查询 101

6.4 function函数 104

6.5 declare声明 109

6.6 规则when 115

6.7 规则then 146

6.8 kmodule配置说明 150

第7章 指定规则名调用 153

第8章 Spring整合Drools 161

8.1 Spring+Drools简单配置 162

8.2 Drools整合Spring+Web 167

8.3 Drools整合Spring Boot 173

第9章 KieSession状态 209

9.1 有状态的KieSession 211

9.2 无状态的StatelessKieSession 211

第四篇 高 级 篇

第10章 Drools高级用法 218

10.1 决策表 219

10.2 DSL领域语言 227

10.3 规则模板 234

10.4 规则流 240

10.5 规则构建过程 272

10.6 Drools事件监听 277

第11章 Workbench 283

11.1 Workbench 284

11.2 Windows安装方式 284

11.3 KIE-WB 6.4版本安装 287

11.4 Workbench操作手册 291

11.5 Workbench与Java交互 330

11.6 构建项目的版本控制 344

11.7 Workbench上传文件与添加依赖关系 345

11.8 Workbench中设置Kbase+KieSession 349

11.9 Workbench构建jar包到Maven私服 352

第12章 Kie-Server 353

12.1 整合部署 354

12.2 分离部署 362

12.3 集群部署 364

12.4 Kie-Server与Java交互 380

第13章 动态规则 385

第14章 多线程中的Drools 401

14.1 同KieHelper 同KieSession（有状态） 404

14.2 同KieHelper 不同KieSession（有状态） 407

14.3 不同KieHelper 不同KieSession（有状态），KieSession只创建一次 409

14.4 不同KieHelper 不同KieSession（有状态），KieSession在线程代码中创建 411

14.5 同KieHelper 同StatelessKieSession（无状态） 413

14.6 同KieHelper 不同StatelessKieSession（无状态） 415

14.7 不同KieHelper不同StatelessKieSession（无状态），StatelessKieSession只创建一次 417

14.8 不同KieHelper不同StatelessKieSession（无状态），StatelessKieSession在线程代码中创建 419

第五篇 源 码 篇

第15章 Drools源码分析 424

15.1 KieServices分析 425

15.2 KieContainer分析 433

15.3 KieSession分析 438

15.4 KieBase分析 440

15.5 KieFileSystem分析 441

15.6 KieHelper分析 442

第六篇 扩 展 篇

第16章 Drools扩展说明 446

16.1 规则引擎优化方案 447

16.2 规则实战架构 450

16.3 规则引擎项目的定位 453

16.4 规则引擎实战应用思想 454

16.5 规则引擎日志输出 455

参考文献 458


