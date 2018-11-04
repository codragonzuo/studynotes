
InnoDB is a storage engine for the database management system MySQL. MySQL 5.5, December 2010, and later use it by default replacing MyISAM.[1] It provides the standard ACID-compliant transaction features, along with foreign key support (Declarative Referential Integrity). It is included as standard in most binaries distributed by MySQL AB, the exception being some OEM versions.

## MyISAM和InnoDB的对比 
Mysql数据库中,最常用的两种引擎是innordb和myisam。InnoDB是Mysql的默认存储引擎。
- 事务处理上方面MyISAM强调的是性能,查询的速度比InnoDB类型更快,但是不提供事务支持。InnoDB提供事务支持事务。
- 外键MyISAM不支持外键,InnoDB支持外键。
- 锁 MyISAM只支持表级锁,InnoDB支持行级锁和表级锁,默认是行级锁,行锁大幅度提高了多用户并发操作的性能。
- innodb比较适合于插入和更新操作比较多的情况,而myisam则适合用于频繁查询的情
