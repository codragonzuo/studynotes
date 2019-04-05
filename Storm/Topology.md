


![](https://www.accenture.com/t20150521T024358__w__/us-en/_acnmedia/Accenture/Conversion-Assets/Blogs/Images/1/Accenture-Storm-Topology.png)


![](https://www.jansipke.nl/wp-content/uploads/Storm-Topology-Input-Output-Metrics.png)

![](http://matt33.com/images/2015-05-26-theBasisOfStorm/2015-05-26-topology.png)

#tuple
storm中传输的数据类型是tuple，tuple到底是什么？

感觉还是用英语来说比较容易理解吧，”A tuple is a named of values where each value can be any type.” 

tuple是一个类似于列表的东西，存储的每个元素叫做field（字段）。我们用getString(i)可以获得tuple的第i个字段。
而其中的每个字段都可以任意类型的，也可以一个很长的字符串。我们可以用：
