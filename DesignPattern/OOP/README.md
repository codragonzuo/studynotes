## 面向对象设计的7个原则

面向对象设计原则：OOPS（Object-Oriented Programming System，面向对象的程序设计系统），面向对象编程的特性“抽象”、“封装”、“多态”、“继承” 等。

1.单一职责 SRP（The Single Responsibility Principle）

    一个类或接口的职责明确且唯一，即“高内聚，低耦合”；

2.开闭原则 OCP（The Open Closed Principle）

   对扩展开发，对修改关闭，即当你需要修改一个类时，你可以继承它，添加接口，而不是修改接口，添加代码，而不是修改代码；

3.里氏代换原则  LSP（The Liskov Substitution Principle）

   父类可以出现的地方，子类都可以出现；

4.依赖倒置原则 DIP（The Dependency Inversion Principle）

   依赖于抽象而不依赖于具体，我们尽量使用接口来规范依赖；

5.接口分离原则  ISP（The Interface Segregation Principle）

    每一个接口的职责单一明确，所以当我们要实现一个复杂的类时，我们尽量去实现多个接口，

而不要把多个接口的功能放到一个接口；

6.迪米特（最少知道）原则  LOD（Law of Demeter）

    对象之间应该要尽量少的了解对方；

7.合成/复合原则  CRP （ Composite Reuse Principle）

   尽量使用对象组合，而不是继承来达到复用的目的。
