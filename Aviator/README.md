# Aviator

表达式引擎

Aviator是一个高性能、轻量级的java语言实现的表达式求值引擎，主要用于各种表达式的动态求值。现在已经有很多开源可用的java表达式求值引擎，为什么还需要Avaitor呢？

Aviator的设计目标是轻量级和高性能 ，相比于Groovy、JRuby的笨重，Aviator非常小，加上依赖包也才450K,不算依赖包的话只有70K；当然，Aviator的语法是受限的，它不是一门完整的语言，而只是语言的一小部分集合。

其次，Aviator的实现思路与其他轻量级的求值器很不相同，其他求值器一般都是通过解释的方式运行，而Aviator则是直接将表达式编译成Java字节码，交给JVM去执行。简单来说，Aviator的定位是介于Groovy这样的重量级脚本语言和IKExpression这样的轻量级表达式引擎之间。


（1）支持大部分运算操作符，包括算术操作符、关系运算符、逻辑操作符、正则匹配操作符(=~)、三元表达式?: ，并且支持操作符的优先级和括号强制优
先级，具体请看后面的操作符列表。
（2）支持函数调用和自定义函数。
（3）支持正则表达式匹配，类似Ruby、Perl的匹配语法，并且支持类Ruby的$digit指向匹配分组。自动类型转换，当执行操作的时候，会自动判断操作数类
型并做相应转换，无法转换即抛异常。
（4）支持传入变量，支持类似a.b.c的嵌套变量访问。
（5）性能优秀。
（6）Aviator的限制，没有if else、do while等语句，没有赋值语句，仅支持逻辑表达式、算术表达式、三元表达式和正则匹配。没有位运算符


https://github.com/killme2008/aviator

https://github.com/killme2008/aviator/wiki




美团酒旅实时数据规则引擎应用实践

https://tech.meituan.com/2018/04/19/hb-rt-operation.html

Java各种规则引擎

https://www.jianshu.com/p/41ea7a43093c


List of Rules Engines in Java

https://www.baeldung.com/java-rule-engines


# OPENL

支持excel rule规则描述

http://openl-tablets.org/



# Spring Expression Language (SpEL)

SpEL（Spring Expression Language），即Spring表达式语言，是比JSP的EL更强大的一种表达式语言。为什么要总结SpEL，因为它可以在运行时查询和操作数据，尤其是数组列表型数据，因此可以缩减代码量，优化代码结构。个人认为很有用。

SpEL有三种用法，一种是在注解@Value中；一种是XML配置；最后一种是在代码块中使用Expression。

https://www.jianshu.com/p/e0b50053b5d3


Java代码审计之SpEL表达式注入

https://www.freebuf.com/vuls/197008.html



https://github.com/oldratlee/java-modern-tech-practice/issues/11


https://www.baeldung.com/java-rule-engines
