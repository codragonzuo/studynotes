
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

![Onlie PDF Download](http://file.allitebooks.com/20150428/High%20Performance%20MySQL,%203rd%20Edition.pdf)




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

