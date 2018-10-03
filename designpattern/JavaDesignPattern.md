

### Class Diagram Annotation
```puml
@startuml
Person  <|-- Police : Extension(Inherence)
Human    *-- Leg    : Composition 
Library  o-- Book   : Aggregation(has)
Customer <-- Order  :Association (reference)
@enduml
```


```puml
@startuml
Class07 .. Class08 :link
Class09 -- Class10 :link
@enduml
```


### Facade Pattern

```puml
@startuml
class client1
class client2
class Facade
client1 --> Facade :DoSthing()
client2 --> Facade :DoSthing()
package subsystem1 {
Facade --> Class01
Class01 --> Class02
}
package subsystem2 {
Facade --> Class03
}
package subsystem3 {
Class03 --> Class04
}
@enduml
```


### Dependency Injection
Dependency Injection (DI) is a software design pattern that implements inversion of control for resolving dependencies.

 - An injection is the passing of a dependency to a dependent object that would use it.
 - DI is a process whereby objects define their dependencies. The other objects they work with—only through constructor arguments or arguments to a factory method or property—are set on the object instance after it is constructed or returned from a factory method.

 - The container then injects those dependencies, and it creates the bean. This process is named Inversion of Control (IoC) (the bean itself controls the instantiation or location of its dependencies by using direct construction classes or a Service Locator).

 - DI refers to the process of supplying an external dependency to a software component.

```puml
@startuml
object Builder
object ClientClass
object Service1
object IService1

Service1 --> ClientClass
ClientClass -->IService1:3.Uses
Service1 --|> IService1 :Inheritance 
Builder -.> ClientClass : 1.Create
Builder --> Service1 : 2.Injects denpendencies
@enduml
```


###  Decorator Class Diagram
Decorator pattern introduces some boilerplate code to an existing class hierarchy. The pattern introduces a shared interface between the target class and the decorator. The decorator must have a reference to an instance of this interface.


```puml
@startuml  
skinparam handwritten true
title Decorator Pattern

class Component{
    Operator()
}

class ConcreteComponent{
    Operator()
}
class Decorator
{
    component
    Operator()
}
class ConcreteDecorator{
    Operator()
}

Component::Operator <-- ConcreteComponent
Component::Operator <-- Decorator
Decorator <-- ConcreteDecorator
Decorator *--- Component

@enduml
```


