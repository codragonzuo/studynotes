
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


 
 

