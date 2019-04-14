
## Performance Tuning

## MySQL performance tuning settings
tuning	英['tju:nɪŋ]   美['tju:nɪŋ]

[Ten MySQL performance tuning settings after installation](https://www.percona.com/blog/2014/01/28/10-mysql-performance-tuning-settings-after-installation/)

- innodb_buffer_pool_size
- innodb_log_file_size
- max_connections
- innodb_file_per_table
- innodb_flush_log_at_trx_commit
- innodb_flush_method
- innodb_log_buffer_size
- query_cache_size
- log_bin
- skip_name_resolve


[MySQL 5.7 Performance Tuning Immediately After Installation](https://www.percona.com/blog/2016/10/12/mysql-5-7-performance-tuning-immediately-after-installation/)

https://www.percona.com/blog/2016/10/12/mysql-5-7-performance-tuning-immediately-after-installation/

![](https://www.percona.com/blog/wp-content/uploads/2016/10/Screen-Shot-2016-10-03-at-12.49.22-PM.png)

![](https://www.percona.com/blog/wp-content/uploads/2016/10/Screen-Shot-2016-10-03-at-12.48.13-PM.png)

![](https://www.percona.com/blog/wp-content/uploads/2016/10/Screen-Shot-2016-10-03-at-12.43.52-PM.png)



### 浅入浅出 MySQL 和 InnoDB

https://draveness.me/mysql-innodb

---

### High Performance MySQL, 3rd Edition

![](https://covers.oreillystatic.com/images/0636920022343/lrg.jpg)

[Onlie PDF Download](http://file.allitebooks.com/20150428/High%20Performance%20MySQL,%203rd%20Edition.pdf)


### MySQL High Availability
![](https://covers.oreillystatic.com/images/9780596807290/lrg.jpg)


[Onlie PDF Download](http://file.allitebooks.com/20150430/MySQL%20High%20Availability.pdf)

---

InnoDB is a storage engine for the database management system MySQL. MySQL 5.5, December 2010, and later use it by default replacing MyISAM.[1] It provides the standard ACID-compliant transaction features, along with foreign key support (Declarative Referential Integrity). It is included as standard in most binaries distributed by MySQL AB, the exception being some OEM versions.

## MyISAM和InnoDB的对比 
Mysql数据库中,最常用的两种引擎是innordb和myisam。InnoDB是Mysql的默认存储引擎。
- 事务处理上方面MyISAM强调的是性能,查询的速度比InnoDB类型更快,但是不提供事务支持。InnoDB提供事务支持事务。
- 外键MyISAM不支持外键,InnoDB支持外键。
- 锁 MyISAM只支持表级锁,InnoDB支持行级锁和表级锁,默认是行级锁,行锁大幅度提高了多用户并发操作的性能。
- innodb比较适合于插入和更新操作比较多的情况,而myisam则适合用于频繁查询的情

---

MySQL 8.0 Sysbench Benchmark: IO Bound Read Only (Point Selects)

https://www.mysql.com/why-mysql/benchmarks/

![](https://www.mysql.com/common/images/benchmarks/mysql_80_benchmarks_readonly.png)

---
### Calculating InnoDB Buffer Pool Size for Your MySQL Server

https://dzone.com/articles/calculating-innodb-buffer-pool-size-for-your-mysql?fromrel=true

![](https://scalegrid.io/blog/wp-content/uploads/2018/01/chart.png)

---
### Chunk Change: InnoDB Buffer Pool Resizing

https://dzone.com/articles/chunk-change-innodb-buffer-pool-resizing?fromrel=true

The buffer pool can hold several instances, and each instance is divided into chunks. There is some information that we need to take into account: the number of instances can go from 1 to 64, and the total amount of chunks should not exceed 1000.

So, for a server with 3GB RAM, a buffer pool of 2GB with 8 instances, and chunks at default value (128MB), we are going to get 2 chunks per instance:


![](https://www.percona.com/blog/wp-content/uploads/2018/04/bp8instances.png)

### MySQL InnoDB performance improvement: InnoDB buffer pool instances

https://www.saotn.org/mysql-innodb-performance-improvement/


### XtraDB / InnoDB internals
![https://www.percona.com/blog/wp-content/uploads/2010/04/InnoDB_int2-e1272319507276.png]

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

