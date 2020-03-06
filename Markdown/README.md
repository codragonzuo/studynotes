
```puml
@startuml;

[*] --> State1;
State1 --> [*];
State1 : this is a string;
State1 : this is another string;

State1 -> State2;
State2 --> [*];

@enduml
```

\[ z = \frac{1}{x^2+y^2} \]




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


### C4-PlantUML

https://c4model.com/

https://github.com/RicardoNiepel/C4-PlantUML

XXX.puml

```puml
@startuml LAYOUT_AS_SKETCH Sample
!includeurl file:///E:/Document/C4_Container.puml


LAYOUT_AS_SKETCH

Person(admin, "Administrator")
package "Sample System" <<boundary>> as c1 {
    Container(web_app, "Web Application", "C#, ASP.NET Core 2.1 MVC", "Allows users to compare multiple Twitter timelines")
}
System(twitter, "Twitter")

Rel(admin, web_app, "Uses", "HTTPS")
Rel(web_app, twitter, "Gets tweets from", "HTTPS")
@enduml
```

![](https://camo.githubusercontent.com/c33308e4ad261ef36002776f5be1973bd6f0cac8/687474703a2f2f7777772e706c616e74756d6c2e636f6d2f706c616e74756d6c2f706e672f4c4c3144497944303442713779585f3655416247346f675566394a363837676d664a49663769697336546c355f4d397447595a595674554d51656a7836505a74766474694639336d723669355a6f423835636758645338716b5041634c4e73376c4c546d38374258654959793646417a6634455f776d467772586632477462685452364d685632544e4b6671673868675f6451625841374475684e47385831774e63716876576a6671455545785438614a4c526557704b5a714d62666e66324c535366304e663372734b73514544352d595a7232545765357a5036725430524a775378736658462d45396b313244314575326a4457445f504f704a5752596b534f7a627474343766644541383941743955354c545a7736694c5f646f6755344a5a74324e4a73336e4c614d694c436545304d4233303649317770643135447168615a353543715a59496131496573416c3441442d66796166744f584543326c7a3459455339636a4b56714b6c714a51316874632d444373675a6870384569434e664d5361705a395737315f557764797453704754562d5746)
