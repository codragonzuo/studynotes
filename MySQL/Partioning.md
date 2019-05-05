
![](http://cdn.venublog.com/images/MySQL5.1MixOfHandlersinPartitions_133B5/partition.png)

## 分库分表分区
### partition
SQL不关心数据库存储的物理存储形式。但是innodb提供了和和物理文件目录和文件关联的功能，来提高效率。

表分区，是指根据一定规则，将数据库中的一张表分解成多个更小的，容易管理的部分。从逻辑上看，只有一张表，但是底层却是由多个物理分区组成。

Partitioning Types
 1. RANGE Partitioning
 2. LIST Partitioning
 3. COLUMNS Partitioning
 4. HASH Partitioning
 5. KEY Partitioning
 6. Subpartitioning
 7. How MySQL Partitioning Handles NULL


- MySQL分区的优点

 1. 分区使得在一个表中存储比单个磁盘或文件系统分区中存储更多的数据成为可能。不知道可不可以这么理解，假如每个文件上限100M，那么分区4个，就可以存400M！
 2. 原本一些有用的数据无效了，通过移除相应的分区就可以快捷的移除相应的数据。同样的为特别的数据添加分区也是非常便捷的。
优化查询。在使用分区指定列进行查询时，数据库可以根据指定列定位到相应的物理文件进行查询。另外MySQL同样支持显式的分区查询

《理解MySQL分区》, 一起来围观吧 https://blog.csdn.net/sayWhat_sayHello/article/details/89005939

 - Range Partion
```sql
CREATE TABLE members (
    firstname VARCHAR(25) NOT NULL,
    lastname VARCHAR(25) NOT NULL,
    username VARCHAR(16) NOT NULL,
    email VARCHAR(35),
    joined DATE NOT NULL
)
PARTITION BY RANGE( YEAR(joined) ) (
    PARTITION p0 VALUES LESS THAN (1960),
    PARTITION p1 VALUES LESS THAN (1970),
    PARTITION p2 VALUES LESS THAN (1980),
    PARTITION p3 VALUES LESS THAN (1990),
    PARTITION p4 VALUES LESS THAN MAXVALUE
);
```
 - List Partion
```sqlCREATE TABLE employees (
    id INT NOT NULL,
    fname VARCHAR(30),
    lname VARCHAR(30),
    hired DATE NOT NULL DEFAULT '1970-01-01',
    separated DATE NOT NULL DEFAULT '9999-12-31',
    job_code INT,
    store_id INT
)
PARTITION BY LIST(store_id) (
    PARTITION pNorth VALUES IN (3,5,6,9,17),
    PARTITION pEast VALUES IN (1,2,10,11,19,20),
    PARTITION pWest VALUES IN (4,12,13,14,18),
    PARTITION pCentral VALUES IN (7,8,15,16)
);
```
 - Range Column
```Sql
mysql> CREATE TABLE rcx (
    ->     a INT,
    ->     b INT,
    ->     c CHAR(3),
    ->     d INT
    -> )
    -> PARTITION BY RANGE COLUMNS(a,d,c) (
    ->     PARTITION p0 VALUES LESS THAN (5,10,'ggg'),
    ->     PARTITION p1 VALUES LESS THAN (10,20,'mmm'),
    ->     PARTITION p2 VALUES LESS THAN (15,30,'sss'),
    ->     PARTITION p3 VALUES LESS THAN (MAXVALUE,MAXVALUE,MAXVALUE)
    -> );
Query OK, 0 rows affected (0.15 sec)
```

问题 
- 1.NULL值使得分区过滤无效
- 2.分区列和索引列不匹配
