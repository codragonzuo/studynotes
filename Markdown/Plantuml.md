
@startuml;

[*] --> State1;
State1 --> [*];
State1 : this is a string;
State1 : this is another string;

State1 -> State2;
State2 --> [*];

@enduml




```sequence{theme=hand}
Andrew->China: Says Hello
Note right of China: China thinks\nabout it
China-->Andrew: How are you?
Andrew->>China: I am good thanks!
```

```puml
@startuml  mychart
start
:dosomtething;
if (cond?) then (val1)
    :dosomtething;
else (val2)
    :dosomtething;
endif
:画;
:dosomtething;
end
@enduml
```

```dot
digraph R {
  rankdir=LR
  node [style="rounded,filled"]
  node1 [fillcolor=orange,shape=box]
  node2 [fillcolor=yellow, style="rounded,filled", shape=diamond]
  node3 [shape=record, label="{ a | b | c }"]
  node1 -> node2 -> node3
}
```




```puml

@startuml

Person  <|-- Police : Generation(Extension, Inherence)
IBrush  <|.. PenBrush : Realization(Extension, Interface)



class Customer
class Order
Customer "1" <-- "n" Order  : Association (reference)
Water  <..  Animal  : Dependency



Human    *-- "2" Leg    : Composition（contain）
Library  o-- "n" Book   : Aggregation(has)



ClassA .. ClassB :link
ClassC -- ClassD :link


@enduml
```


```puml
@startuml  mychart
start
:dosomtething;
if (cond?) then (val1)
    :dosomtething;
else (val2)
    :dosomtething;
endif
:画;
:dosomtething;
end
@enduml
```
