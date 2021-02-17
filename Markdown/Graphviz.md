
https://renenyffenegger.ch/notes/tools/Graphviz/examples/index


```puml
digraph R {
  rankdir=LR
  node [style="filled"]
  node1 [fillcolor=orange,shape=box]
  User [label="User", fillcolor=orange,shape=box]
  node2 [fillcolor=yellow, style="rounded,filled", shape=diamond]
  UserService [label="User service", shape=octagon,fillcolor=darkgreen,fontcolor=white]
  User->UserService
  
}
```


```puml
class fff extends aaa implements aaa{
    int fff;
}
```



```dot
digraph G {
subgraph cluster0 {
node [style=filled,color=white];
style=filled;
color=lightgrey;
a0 -> a1 -> a2 -> a3;
label = "process #1";
}

subgraph cluster1 {
node [style=filled];
b0 -> b1 -> b2 -> b3;
label = "process #2";
color=blue
}
start -> a0;
start -> b0;
a1 -> b3;
b2 -> a3;
a3 -> a0;
a3 -> end;
b3 -> end;

start [shape=Mdiamond];
end [shape=Msquare];
}
```


```dot
digraph st2{
  fontname = "Verdana";
  fontsize = 10;
  rankdir=TB;
  
  node [fontname = "Verdana", fontsize = 10, color="skyblue", shape="record"];
  
  edge [fontname = "Verdana", fontsize = 10, color="crimson", style="solid"];
  
  st_hash_type [label="{<head>st_hash_type|(*compare)|(*hash)}"];
  st_table_entry [label="{<head>st_table_entry|hash|key|record|<next>next}"];
  st_table [label="{st_table|<type>type|num_bins|num_entries|<bins>bins}"];
  
  st_table:bins -> st_table_entry:head;
  st_table:type -> st_hash_type:head;
  st_table_entry:next -> st_table_entry:head [style="dashed", color="forestgreen"];
}
```

```dot
digraph st{
  fontname = "Verdana";
  fontsize = 10;
  rankdir = LR;
  rotate = 0;
  
  node [ shape="record", width=.1, height=.1];
  node [fontname = "Verdana", fontsize = 10, color="skyblue", shape="record"];
  
  edge [fontname = "Verdana", fontsize = 10, color="crimson", style="solid"];
  node [shape="plaintext"];
  
  st_table [label=<
      <table border="0" cellborder="1" cellspacing="0" align="left">
      <tr>
      <td>st_table</td>
      </tr>
      <tr>
      <td>num_bins=5</td>
      </tr>
      <tr>
      <td>num_entries=3</td>
      </tr>
      <tr>
      <td port="bins">bins</td>
      </tr>
      </table>
  >];
  
  node [shape="record"];
  num_bins [label=" <b1> | <b2> | <b3> | <b4> | <b5> ", height=2];
  node[ width=2 ];
  
  entry_1 [label="{<e>st_table_entry|<next>next}"];
  entry_2 [label="{<e>st_table_entry|<next>null}"];
  entry_3 [label="{<e>st_table_entry|<next>null}"];
  
  st_table:bins -> num_bins:b1;
  num_bins:b1 -> entry_1:e;
  entry_1:next -> entry_2:e;
  num_bins:b3 -> entry_3:e;
}
```

```dot
digraph H {

  aHtmlTable [
   shape=plaintext
   color=black1       // The color of the border of the table
   label=<

     <table border='0' cellborder='1' cellspacing='0'>
       <tr><td>col 1</td><td>foo</td></tr>
       <tr><td>COL 2</td><td>bar</td></tr>
     </table>

  >];

}
```

```dot
digraph D {

    node [fontname="Arial"];

    node_A [shape=record    label="shape=record|{above|middle|below}|right"];
    node_C [shape=record    label="{record|{middle|fdefa}|right}"];
    node_B [shape=plaintext label="shape=plaintext|{curly|braces and|bars without}|effect"];


}
```


```dot
digraph idp_modules{

  rankdir = TB;
  fontname = "Microsoft YaHei";
  fontsize = 12;
  
  node [ fontname = "Microsoft YaHei", fontsize = 12, shape = "record" ];
  edge [ fontname = "Microsoft YaHei", fontsize = 12 ];
  
      subgraph cluster_sl{
          label="IDP支持层";
          bgcolor="mintcream";
          node [shape="Mrecord", color="skyblue", style="filled"];
          network_mgr [label="网络管理器"];
          log_mgr [label="日志管理器"];
          module_mgr [label="模块管理器"];
          conf_mgr [label="配置管理器"];
          db_mgr [label="数据库管理器"];
      };
  
      subgraph cluster_md{
          label="可插拔模块集";
          bgcolor="lightcyan";
          node [color="chartreuse2", style="filled"];
          mod_dev [label="开发支持模块"];
          mod_dm [label="数据建模模块"];
          mod_dp [label="部署发布模块"];
      };
  
  mod_dp -> mod_dev [label="依赖..."];
  mod_dp -> mod_dm [label="依赖..."];
  mod_dp -> module_mgr [label="安装...", color="yellowgreen", arrowhead="none"];
  mod_dev -> mod_dm [label="依赖..."];
  mod_dev -> module_mgr [label="安装...", color="yellowgreen", arrowhead="none"];
  mod_dm -> module_mgr [label="安装...", color="yellowgreen", arrowhead="none"];
}
```


```dot
digraph R{
    UserService [label="XXXX Process\n YYY", shape=rect,fillcolor=lightyellow,fontcolor=green]
    subgraph cluster_inr {
      graph [style=filled, fillcolor=lightyellow, label="Thread One", color=blue ];
      node [style=filled,fillcolor=lightpink,color=lightblue];
      edge [style="dashed"];
      lx_start;
      SendSignal;
      lx_start ->SendSignal ->Close_Isp ->GiveSemphone; 
    }    
    subgraph cluster_cd {
      graph [style=filled, fillcolor=lightyellow, label="Thread Two", color=blue ];
      node [style=filled,fillcolor=lightpink,color=lightblue];
      edge [style="dashed"];
      lx_startf;
      lm_startf;
      lx_startf ->lm_startf->TakeSemoph->ReaData; 
    }
}
```

