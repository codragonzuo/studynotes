
User Story模板 

User Story可以遵循以下模板：As a <User Type> I want to <achieve goal> So that  I can <get some value>

翻译成中文就是：作为一个<某种类型的用户>，我要<达成某些目的>，我这么做的原因是<开发的价值>。

 
User Story应遵循INVEST规则

- Independent 独立性，避免与其他Story的依赖性。
- Negotiable 可谈判性，Scrum中的story不是瀑布开始某事中的Contract, Stories不必太过详细，开发人员可以给出适当的建议。
- Valueable 有价值性， Story需要体现出对于用户的价值
- Estimable 可估计性，Story应可以估计出Task的开发时间。
- Sized Right 合理的尺寸， Stories应该尽量小，并且使得团队尽量在1个sprint(2 weeks)中完成。
- Testable 可测试性， User Story应该是可以测试的，最好有界面可以测试和自动化测试。每个任务都应有Junit Test.


一些经验：

永远不要在User Story中使用And和Or，因为这是些分支词就表示分支任务，把它们拆成两个Story.

数据整理：通常情况下1个sprint(2周一次迭代)可以做4～5个Story，极端大的Story不可大于1个sprint。

数据整理：通常情况下1个sprint(2周一次迭代)可以做50个左右的Task。

User Story用于描述用户故事，不要包括任何的技术，框架等内容。Task可以包括框架，技术等内容。

什么是用户故事？

用户故事是从用户的角度来描述用户渴望得到的功能。一个好的用户故事包括三个要素：

1.     角色：谁要使用这个功能。

2.     活动：需要完成什么样的功能。

3.     商业价值：为什么需要这个功能，这个功能带来什么样的价值。

用户故事通常按照如下的格式来表达：

英文：

As a <Role>, I want to <Activity>, so that <Business Value>.

中文：

作为一个<角色>, 我想要<活动>, 以便于<商业价值>

举例：

作为一个“网站管理员”，我想要“统计每天有多少人访问了我的网站”，以便于“我的赞助商了解我的网站会给他们带来什么收益。”

需要注意的是用户故事不能够使用技术语言来描述，要使用用户可以理解的业务语言来描述。
