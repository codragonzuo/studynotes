
# Json-to-plantuml把JSON数据转换成UML图

https://www.npmjs.com/package/json-to-plantuml

从vscode里搜寻拷贝plantuml.jar

```shell
$ echo '{"foo": "bar"}' | json-to-plantuml | java -jar plantuml.jar -pipe > foobar.png
$ json-to-plantuml -f .\data\albumdata.json | java -jar plantuml.jar -pipe > albumdata.png
```


## 把UML图转换成JSON Schema.

https://www.npmjs.com/package/esf-puml

PlantUML (subset) parser and generator of JSON Schema.
