

## Replication Topology
![](https://avisheksharma.files.wordpress.com/2015/01/mysql_replication.jpg)

Explanation: 
1) There are three parallel threads working, one on the server host and remaining two(IO thread and SQL Thread) on the slave host.

2) The task of the thread on the server host, is to write all the events to a file called binary log(make sure binary recording is enabled on the server host).

3) IO Thread interact with the server host and reads all the events being recorded with specific replication co-ordinate and writes it to its local file called relay log.

4) SQL thread reads all non-run events from the relay log and applies to the slave database.



## Using Replication to Improve Performance During Scale-Out

Scale-Out横向扩展

Scale-Up纵向扩展



![](https://dev.mysql.com/doc/refman/5.5/en/images/scaleout.png)

## Replication for Backups
To use replication as a backup solution, replicate data from the master to a slave, and then back up the data slave. The slave can be paused and shut down without affecting the running operation of the master, so you can produce an effective snapshot of “live” data that would otherwise require the master to be shut down.

How you back up a database depends on its size and whether you are backing up only the data, or the data and the replication slave state so that you can rebuild the slave in the event of failure. There are therefore two choices:

If you are using replication as a solution to enable you to back up the data on the master, and the size of your database is not too large, the mysqldump tool may be suitable. See Section 17.3.1.1, “Backing Up a Slave Using mysqldump”.

For larger databases, where mysqldump would be impractical or inefficient, you can back up the raw data files instead. Using the raw data files option also means that you can back up the binary and relay logs that will enable you to recreate the slave in the event of a slave failure. For more information, see Section 17.3.1.2, “Backing Up Raw Data from a Slave”.

Another backup strategy, which can be used for either master or slave servers, is to put the server in a read-only state. The backup is performed against the read-only server, which then is changed back to its usual read/write operational status. 

## Switching Masters During Failover

Redundancy Using Replication, After Master Failure

![](https://dev.mysql.com/doc/refman/5.5/en/images/redundancy-after.png)

