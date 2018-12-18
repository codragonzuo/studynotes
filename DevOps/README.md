

DevOps看作开发（软件工程）、技术运营Operation和质量保障（QA）三者的交集.

![](https://gss1.bdstatic.com/-vo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=5bc64265356d55fbd1cb7e740c4b242f/5fdf8db1cb1349547472c6df5e4e9258d1094a18.jpg)

有一种观点认为，占主导地位的“传统”美国式管理风格（“斯隆模型 vs 丰田模型”）会导致“烟囱式自动化”，从而造成开发与运营之间的鸿沟，因此需要DevOps能力来克服由此引发的问题。

## DevOps对应用发布的影响

在很多企业中，应用程序发布是一项涉及多个团队、压力很大、风险很高的活动。然而在具备DevOps能力的组织中，应用程序发布的风险很低，原因如下 ：

（1）减少变更范围

与传统的瀑布式开发模型相比，采用敏捷或迭代式开发意味着更频繁的发布、每次发布包含的变化更少。由于部署经常进行，因此每次部署不会对生产系统造成巨大影响，应用程序会以平滑的速率逐渐生长。

（2）加强发布协调

靠强有力的发布协调人来弥合开发与运营之间的技能鸿沟和沟通鸿沟；采用电子数据表、电话会议、即时消息、企业门户（wiki、sharepoint）等协作工具来确保所有相关人员理解变更的内容并全力合作。

（3）自动化

强大的部署自动化手段确保部署任务的可重复性、减少部署出错的可能性。
与传统开发方法那种大规模的、不频繁的发布（通常以“季度”或“年”为单位）相比，敏捷方法大大提升了发布频率（通常以“天”或“周”为单位）。


![](https://images2015.cnblogs.com/blog/1190892/201707/1190892-20170711181750743-1188576503.png)


## 实现DevOps需要什么？

硬性要求：工具上的准备

上文提到了工具链的打通，那么工具自然就需要做好准备。现将工具类型及对应的不完全列举整理如下：

代码管理（SCM）：GitHub、GitLab、BitBucket、SubVersion

构建工具：Ant、Gradle、maven

自动部署：Capistrano、CodeDeploy

持续集成（CI）：Bamboo、Hudson、Jenkins

配置管理：Ansible、Chef、Puppet、SaltStack、ScriptRock GuardRail

容器：Docker、LXC、第三方厂商如AWS

编排：Kubernetes、Core、Apache Mesos、DC/OS

服务注册与发现：Zookeeper、etcd、Consul

脚本语言：python、ruby、shell

日志管理：ELK、Logentries

系统监控：Datadog、Graphite、Icinga、Nagios

性能监控：AppDynamics、New Relic、Splunk

压力测试：JMeter、Blaze Meter、loader.io

预警：PagerDuty、pingdom、厂商自带如AWS SNS

HTTP加速器：Varnish

消息总线：ActiveMQ、SQS

应用服务器：Tomcat、JBoss

Web服务器：Apache、Nginx、IIS

数据库：MySQL、Oracle、PostgreSQL等关系型数据库；cassandra、mongoDB、redis等NoSQL数据库

项目管理（PM）：Jira、Asana、Taiga、Trello、Basecamp、Pivotal Tracker


![](https://cdn2.hubspot.net/hubfs/208250/Blog_Images/CA%20%281%29%20%281%29.png)

