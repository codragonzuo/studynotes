
# Problem Solved

## 1. Kafka Offset Problem

问题描述： Metron-Paser-kafkaSpout出现 The offset [0] is below the current nextCommitOffset [3498] for [squid-0]异常。
发一个消息也会出现消息循环，大量的消息流动， 同一个消息被不停的消费， commited offset每次都复位到0
处理思路和过程：
1. 了解Metron Paser部分storm topology的架构和处理流程。
2. 查看kafka offset commit的原理。
3. 检查kafak 0.10.0.1 和storm 1.1.0的版本配合，通过ambri安装hdp 2.6.3, 里面集成的storm1.1 没有源码，在github上找到错误信息打印的storm源码.
4. 查看storm的offset commit源码
6. 查看metron paserbolt， kafakspout源码
7. 通过kafka tools查看topic，comsumer信息
8. 查看kafka 内部__consumer_offset topic信息
9. 修改增加 squid topic的消息数量大于5000， 问题解决





```
2019-11-25 20:32:56.569 o.a.s.util Thread-15-kafkaSpout-executor[4 4] [ERROR] Async loop died!
java.lang.IllegalStateException: The offset [0] is below the current nextCommitOffset [3498] for [squid-0]. This should not be possible, and likely indicates a bug in the spout's acking or emit logic.
	at org.apache.storm.kafka.spout.internal.OffsetManager.findNextCommitOffset(OffsetManager.java:142) ~[stormjar.jar:?]
	at org.apache.storm.kafka.spout.KafkaSpout.commitOffsetsForAckedTuples(KafkaSpout.java:542) ~[stormjar.jar:?]
	at org.apache.storm.kafka.spout.KafkaSpout.nextTuple(KafkaSpout.java:290) ~[stormjar.jar:?]
	at org.apache.storm.daemon.executor$fn__10182$fn__10197$fn__10228.invoke(executor.clj:647) ~[storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at org.apache.storm.util$async_loop$fn__553.invoke(util.clj:484) [storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at clojure.lang.AFn.run(AFn.java:22) [clojure-1.7.0.jar:?]
	at java.lang.Thread.run(Thread.java:748) [?:1.8.0_172]
2019-11-25 20:32:56.573 o.a.s.d.executor Thread-15-kafkaSpout-executor[4 4] [ERROR] 
##########################################################
java.lang.IllegalStateException: The offset [0] is below the current nextCommitOffset [3498] for [squid-0]. This should not be possible, and likely indicates a bug in the spout's acking or emit logic.
	at org.apache.storm.kafka.spout.internal.OffsetManager.findNextCommitOffset(OffsetManager.java:142) ~[stormjar.jar:?]
	at org.apache.storm.kafka.spout.KafkaSpout.commitOffsetsForAckedTuples(KafkaSpout.java:542) ~[stormjar.jar:?]
	at org.apache.storm.kafka.spout.KafkaSpout.nextTuple(KafkaSpout.java:290) ~[stormjar.jar:?]
	at org.apache.storm.daemon.executor$fn__10182$fn__10197$fn__10228.invoke(executor.clj:647) ~[storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at org.apache.storm.util$async_loop$fn__553.invoke(util.clj:484) [storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at clojure.lang.AFn.run(AFn.java:22) [clojure-1.7.0.jar:?]
	at java.lang.Thread.run(Thread.java:748) [?:1.8.0_172]

```


## Kafka Spont

PaserSpout ,Kafka


```
2019-11-25 20:32:20.873 STDERR Thread-2 [INFO] JMXetricAgent instrumented JVM, see https://github.com/ganglia/jmxetric
2019-11-25 20:32:20.873 STDERR Thread-1 [INFO] 十一月 25, 2019 8:32:20 下午 info.ganglia.gmetric4j.GMonitor start
2019-11-25 20:32:20.880 STDERR Thread-1 [INFO] 信息: Setting up 1 samplers
2019-11-25 20:32:23.500 o.a.s.d.worker main [INFO] Launching worker for squid-83-1574682796 on 86072b1f-f4a3-49a0-bbbe-0170a8aa9d47:6700 with id 667c6a6e-a7e6-4930-bd49-39ebbc2f4c94 and conf {"topology.builtin.metrics.bucket.size.secs" 60, "nimbus.childopts" "-Xmx1024m  -javaagent:/usr/hdp/current/storm-nimbus/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar=host=localhost,port=8649,wireformat31x=true,mode=multicast,config=/usr/hdp/current/storm-nimbus/contrib/storm-jmxetric/conf/jmxetric-conf.xml,process=Nimbus_JVM", "ui.filter.params" nil, "storm.cluster.mode" "distributed", "topology.metrics.metric.name.separator" ".", "storm.messaging.netty.client_worker_threads" 5, "client.jartransformer.class" "org.apache.storm.hack.StormShadeTransformer", "logviewer.max.per.worker.logs.size.mb" 2048, "supervisor.run.worker.as.user" false, "topology.max.task.parallelism" nil, "topology.priority" 29, "zmq.threads" 1, "storm.group.mapping.service" "org.apache.storm.security.auth.ShellBasedGroupsMapping", "transactional.zookeeper.root" "/transactional", "topology.sleep.spout.wait.strategy.time.ms" 1, "scheduler.display.resource" false, "topology.max.replication.wait.time.sec" 60, "drpc.invocations.port" 3773, "supervisor.localizer.cache.target.size.mb" 10240, "topology.multilang.serializer" "org.apache.storm.multilang.JsonSerializer", "storm.messaging.netty.server_worker_threads" 5, "nimbus.blobstore.class" "org.apache.storm.blobstore.LocalFsBlobStore", "resource.aware.scheduler.eviction.strategy" "org.apache.storm.scheduler.resource.strategies.eviction.DefaultEvictionStrategy", "topology.max.error.report.per.interval" 5, "storm.thrift.transport" "org.apache.storm.security.auth.SimpleTransportPlugin", "zmq.hwm" 0, "storm.group.mapping.service.params" nil, "worker.profiler.enabled" false, "storm.topology.submission.notifier.plugin.class" "org.apache.atlas.storm.hook.StormAtlasHook", "storm.principal.tolocal" "org.apache.storm.security.auth.DefaultPrincipalToLocal", "supervisor.worker.shutdown.sleep.secs" 3, "pacemaker.host" "localhost", "storm.zookeeper.retry.times" 5, "ui.actions.enabled" true, "zmq.linger.millis" 5000, "supervisor.enable" true, "topology.stats.sample.rate" 0.05, "storm.messaging.netty.min_wait_ms" 100, "worker.log.level.reset.poll.secs" 30, "storm.zookeeper.port" 2181, "supervisor.heartbeat.frequency.secs" 5, "topology.enable.message.timeouts" true, "supervisor.cpu.capacity" 400.0, "drpc.worker.threads" 64, "supervisor.blobstore.download.thread.count" 5, "task.backpressure.poll.secs" 30, "drpc.queue.size" 128, "topology.backpressure.enable" false, "supervisor.blobstore.class" "org.apache.storm.blobstore.NimbusBlobStore", "storm.blobstore.inputstream.buffer.size.bytes" 65536, "topology.shellbolt.max.pending" 100, "drpc.https.keystore.password" "", "nimbus.code.sync.freq.secs" 120, "logviewer.port" 8000, "nimbus.reassign" true, "topology.scheduler.strategy" "org.apache.storm.scheduler.resource.strategies.scheduling.DefaultResourceAwareStrategy", "topology.executor.send.buffer.size" 1024, "resource.aware.scheduler.priority.strategy" "org.apache.storm.scheduler.resource.strategies.priority.DefaultSchedulingPriorityStrategy", "pacemaker.auth.method" "NONE", "storm.daemon.metrics.reporter.plugins" ["org.apache.storm.daemon.metrics.reporters.JmxPreparableReporter"], "topology.worker.logwriter.childopts" "-Xmx64m", "topology.spout.wait.strategy" "org.apache.storm.spout.SleepSpoutWaitStrategy", "ui.host" "0.0.0.0", "storm.nimbus.retry.interval.millis" 2000, "nimbus.inbox.jar.expiration.secs" 3600, "dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.acker.executors" nil, "topology.fall.back.on.java.serialization" true, "topology.eventlogger.executors" 0, "supervisor.localizer.cleanup.interval.ms" 600000, "storm.zookeeper.servers" ["node1" "node2" "node3"], "topology.metrics.expand.map.type" true, "nimbus.thrift.threads" 196, "logviewer.cleanup.age.mins" 10080, "topology.worker.childopts" nil, "topology.classpath" "/etc/hbase/conf:/etc/hadoop/conf", "supervisor.monitor.frequency.secs" 3, "nimbus.credential.renewers.freq.secs" 600, "topology.skip.missing.kryo.registrations" false, "drpc.authorizer.acl.filename" "drpc-auth-acl.yaml", "pacemaker.kerberos.users" [], "storm.group.mapping.service.cache.duration.secs" 120, "topology.testing.always.try.serialize" false, "nimbus.monitor.freq.secs" 10, "storm.health.check.timeout.ms" 5000, "supervisor.supervisors" [], "topology.tasks" nil, "topology.bolts.outgoing.overflow.buffer.enable" false, "storm.messaging.netty.socket.backlog" 500, "topology.workers" 1, "pacemaker.base.threads" 10, "storm.local.dir" "/hadoop/storm", "worker.childopts" "-Xmx768m  -javaagent:/usr/hdp/current/storm-client/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar=host=localhost,port=8650,wireformat31x=true,mode=multicast,config=/usr/hdp/current/storm-client/contrib/storm-jmxetric/conf/jmxetric-conf.xml,process=Worker_%ID%_JVM", "storm.auth.simple-white-list.users" [], "topology.disruptor.batch.timeout.millis" 1, "topology.message.timeout.secs" 30, "topology.state.synchronization.timeout.secs" 60, "topology.tuple.serializer" "org.apache.storm.serialization.types.ListDelegateSerializer", "supervisor.supervisors.commands" [], "nimbus.blobstore.expiration.secs" 600, "logviewer.childopts" "-Xmx128m ", "topology.environment" nil, "topology.debug" false, "topology.disruptor.batch.size" 100, "storm.disable.symlinks" false, "storm.messaging.netty.max_retries" 30, "ui.childopts" "-Xmx768m ", "storm.network.topography.plugin" "org.apache.storm.networktopography.DefaultRackDNSToSwitchMapping", "storm.zookeeper.session.timeout" 30000, "drpc.childopts" "-Xmx768m ", "drpc.http.creds.plugin" "org.apache.storm.security.auth.DefaultHttpCredentialsPlugin", "storm.zookeeper.connection.timeout" 30000, "storm.zookeeper.auth.user" nil, "storm.meta.serialization.delegate" "org.apache.storm.serialization.GzipThriftSerializationDelegate", "topology.max.spout.pending" 1000, "storm.codedistributor.class" "org.apache.storm.codedistributor.LocalFileSystemCodeDistributor", "nimbus.supervisor.timeout.secs" 60, "nimbus.task.timeout.secs" 30, "drpc.port" 3772, "pacemaker.max.threads" 50, "storm.zookeeper.retry.intervalceiling.millis" 30000, "nimbus.thrift.port" 6627, "storm.auth.simple-acl.admins" [], "topology.component.cpu.pcore.percent" 10.0, "supervisor.memory.capacity.mb" 3072.0, "storm.nimbus.retry.times" 5, "supervisor.worker.start.timeout.secs" 120, "topology.metrics.aggregate.per.worker" true, "storm.zookeeper.retry.interval" 1000, "logs.users" nil, "storm.cluster.metrics.consumer.publish.interval.secs" 60, "worker.profiler.command" "flight.bash", "transactional.zookeeper.port" nil, "drpc.max_buffer_size" 1048576, "pacemaker.thread.timeout" 10, "task.credentials.poll.secs" 30, "drpc.https.keystore.type" "JKS", "topology.worker.receiver.thread.count" 1, "topology.state.checkpoint.interval.ms" 1000, "supervisor.slots.ports" [6700 6701], "topology.transfer.buffer.size" 1024, "storm.health.check.dir" "healthchecks", "topology.worker.shared.thread.pool.size" 4, "drpc.authorizer.acl.strict" false, "nimbus.file.copy.expiration.secs" 600, "worker.profiler.childopts" "-XX:+UnlockCommercialFeatures -XX:+FlightRecorder", "topology.executor.receive.buffer.size" 1024, "backpressure.disruptor.low.watermark" 0.4, "topology.optimize" true, "nimbus.task.launch.secs" 120, "storm.local.mode.zmq" false, "storm.messaging.netty.buffer_size" 5242880, "storm.cluster.state.store" "org.apache.storm.cluster_state.zookeeper_state_factory", "topology.metrics.aggregate.metric.evict.secs" 5, "worker.heartbeat.frequency.secs" 1, "storm.log4j2.conf.dir" "log4j2", "ui.http.creds.plugin" "org.apache.storm.security.auth.DefaultHttpCredentialsPlugin", "storm.zookeeper.root" "/storm", "topology.tick.tuple.freq.secs" nil, "drpc.https.port" -1, "storm.workers.artifacts.dir" "workers-artifacts", "supervisor.blobstore.download.max_retries" 3, "task.refresh.poll.secs" 10, "topology.metrics.consumer.register" [{"class" "org.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink", "parallelism.hint" 1, "whitelist" ["kafkaOffset\\..+/" "__complete-latency" "__process-latency" "__receive\\.population$" "__sendqueue\\.population$" "__execute-count" "__emit-count" "__ack-count" "__fail-count" "memory/heap\\.usedBytes$" "memory/nonHeap\\.usedBytes$" "GC/.+\\.count$" "GC/.+\\.timeMs$"]}], "storm.exhibitor.port" 8080, "task.heartbeat.frequency.secs" 3, "pacemaker.port" 6699, "storm.messaging.netty.max_wait_ms" 1000, "topology.component.resources.offheap.memory.mb" 0.0, "drpc.http.port" 3774, "topology.error.throttle.interval.secs" 10, "storm.messaging.transport" "org.apache.storm.messaging.netty.Context", "topology.disable.loadaware.messaging" false, "storm.messaging.netty.authentication" false, "topology.component.resources.onheap.memory.mb" 128.0, "topology.kryo.factory" "org.apache.storm.serialization.DefaultKryoFactory", "worker.gc.childopts" "", "nimbus.topology.validator" "org.apache.storm.nimbus.DefaultTopologyValidator", "nimbus.seeds" ["node2"], "nimbus.queue.size" 100000, "nimbus.cleanup.inbox.freq.secs" 600, "storm.blobstore.replication.factor" 3, "worker.heap.memory.mb" 768, "logviewer.max.sum.worker.logs.size.mb" 4096, "pacemaker.childopts" "-Xmx1024m", "ui.users" nil, "transactional.zookeeper.servers" nil, "supervisor.worker.timeout.secs" 30, "storm.zookeeper.auth.password" nil, "storm.blobstore.acl.validation.enabled" false, "client.blobstore.class" "org.apache.storm.blobstore.NimbusBlobStore", "storm.cluster.metrics.consumer.register" [{"class" "org.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsReporter"}], "storm.thrift.socket.timeout.ms" 600000, "supervisor.childopts" "-Xmx256m  -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=56431 -javaagent:/usr/hdp/current/storm-supervisor/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar=host=localhost,port=8650,wireformat31x=true,mode=multicast,config=/usr/hdp/current/storm-supervisor/contrib/storm-jmxetric/conf/jmxetric-conf.xml,process=Supervisor_JVM", "topology.worker.max.heap.size.mb" 768.0, "ui.http.x-frame-options" "DENY", "backpressure.disruptor.high.watermark" 0.9, "ui.filter" nil, "topology.receiver.buffer.size" 8, "ui.header.buffer.bytes" 4096, "topology.min.replication.count" 1, "topology.disruptor.wait.timeout.millis" 1000, "storm.nimbus.retry.intervalceiling.millis" 60000, "topology.trident.batch.emit.interval.millis" 500, "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "storm.auth.simple-acl.users" [], "drpc.invocations.threads" 64, "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib:/usr/hdp/current/storm-client/lib", "ui.port" 8744, "storm.log.dir" "/var/log/storm", "storm.exhibitor.poll.uripath" "/exhibitor/v1/cluster/list", "storm.messaging.netty.transfer.batch.size" 262144, "logviewer.appender.name" "A1", "nimbus.thrift.max_buffer_size" 1048576, "storm.auth.simple-acl.users.commands" [], "drpc.request.timeout.secs" 600}
2019-11-25 20:32:23.652 o.a.s.s.o.a.c.f.i.CuratorFrameworkImpl main [INFO] Starting
2019-11-25 20:32:23.659 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:zookeeper.version=3.4.6-235--1, built on 10/30/2017 01:54 GMT
2019-11-25 20:32:23.659 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:host.name=node1
2019-11-25 20:32:23.659 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:java.version=1.8.0_172
2019-11-25 20:32:23.660 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:java.vendor=Oracle Corporation
2019-11-25 20:32:23.660 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:java.home=/usr/local/src/jdk1.8.0_172/jre
2019-11-25 20:32:23.660 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:java.class.path=/usr/hdp/2.6.3.0-235/storm/lib/zookeeper.jar:/usr/hdp/2.6.3.0-235/storm/lib/minlog-1.3.0.jar:/usr/hdp/2.6.3.0-235/storm/lib/kryo-3.0.3.jar:/usr/hdp/2.6.3.0-235/storm/lib/storm-core-1.1.0.2.6.3.0-235.jar:/usr/hdp/2.6.3.0-235/storm/lib/servlet-api-2.5.jar:/usr/hdp/2.6.3.0-235/storm/lib/clojure-1.7.0.jar:/usr/hdp/2.6.3.0-235/storm/lib/log4j-core-2.8.2.jar:/usr/hdp/2.6.3.0-235/storm/lib/disruptor-3.3.2.jar:/usr/hdp/2.6.3.0-235/storm/lib/storm-rename-hack-1.1.0.2.6.3.0-235.jar:/usr/hdp/2.6.3.0-235/storm/lib/log4j-slf4j-impl-2.8.2.jar:/usr/hdp/2.6.3.0-235/storm/lib/slf4j-api-1.7.21.jar:/usr/hdp/2.6.3.0-235/storm/lib/ring-cors-0.1.5.jar:/usr/hdp/2.6.3.0-235/storm/lib/reflectasm-1.10.1.jar:/usr/hdp/2.6.3.0-235/storm/lib/objenesis-2.1.jar:/usr/hdp/2.6.3.0-235/storm/lib/log4j-api-2.8.2.jar:/usr/hdp/2.6.3.0-235/storm/lib/asm-5.0.3.jar:/usr/hdp/2.6.3.0-235/storm/lib/ambari-metrics-storm-sink.jar:/usr/hdp/2.6.3.0-235/storm/lib/log4j-over-slf4j-1.6.6.jar:/usr/hdp/2.6.3.0-235/storm/extlib/storm-bridge-shim-0.8.0.2.6.3.0-235.jar:/usr/hdp/2.6.3.0-235/storm/extlib/atlas-plugin-classloader-0.8.0.2.6.3.0-235.jar:/usr/hdp/current/storm-supervisor/conf:/hadoop/storm/supervisor/stormdist/squid-83-1574682796/stormjar.jar:/etc/hbase/conf:/etc/hadoop/conf:/usr/hdp/current/storm-client/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar
2019-11-25 20:32:23.660 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:java.library.path=/hadoop/storm/supervisor/stormdist/squid-83-1574682796/resources/Linux-amd64:/hadoop/storm/supervisor/stormdist/squid-83-1574682796/resources:/usr/local/lib:/opt/local/lib:/usr/lib:/usr/hdp/current/storm-client/lib
2019-11-25 20:32:23.661 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:java.io.tmpdir=/hadoop/storm/workers/667c6a6e-a7e6-4930-bd49-39ebbc2f4c94/tmp
2019-11-25 20:32:23.661 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:java.compiler=<NA>
2019-11-25 20:32:23.661 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:os.name=Linux
2019-11-25 20:32:23.661 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:os.arch=amd64
2019-11-25 20:32:23.661 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:os.version=2.6.32-754.22.1.el6.x86_64
2019-11-25 20:32:23.661 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:user.name=storm
2019-11-25 20:32:23.661 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:user.home=/home/storm
2019-11-25 20:32:23.667 o.a.s.s.o.a.z.ZooKeeper main [INFO] Client environment:user.dir=/hadoop/storm/workers/667c6a6e-a7e6-4930-bd49-39ebbc2f4c94
2019-11-25 20:32:23.668 o.a.s.s.o.a.z.ZooKeeper main [INFO] Initiating client connection, connectString=node1:2181,node2:2181,node3:2181 sessionTimeout=30000 watcher=org.apache.storm.shade.org.apache.curator.ConnectionState@46a488c2
2019-11-25 20:32:23.697 o.a.s.s.o.a.z.ClientCnxn main-SendThread(node3:2181) [INFO] Opening socket connection to server node3/192.168.20.47:2181. Will not attempt to authenticate using SASL (unknown error)
2019-11-25 20:32:23.782 o.a.s.s.o.a.z.ClientCnxn main-SendThread(node3:2181) [INFO] Socket connection established, initiating session, client: /192.168.20.45:54152, server: node3/192.168.20.47:2181
2019-11-25 20:32:23.791 o.a.s.s.o.a.z.ClientCnxn main-SendThread(node3:2181) [INFO] Session establishment complete on server node3/192.168.20.47:2181, sessionid = 0x36ea288abf90010, negotiated timeout = 30000
2019-11-25 20:32:23.794 o.a.s.s.o.a.c.f.s.ConnectionStateManager main-EventThread [INFO] State change: CONNECTED
2019-11-25 20:32:23.796 o.a.s.zookeeper main-EventThread [INFO] Zookeeper state update: :connected:none
2019-11-25 20:32:23.808 o.a.s.s.o.a.c.f.i.CuratorFrameworkImpl Curator-Framework-0 [INFO] backgroundOperationsLoop exiting
2019-11-25 20:32:23.813 o.a.s.s.o.a.z.ZooKeeper main [INFO] Session: 0x36ea288abf90010 closed
2019-11-25 20:32:23.815 o.a.s.s.o.a.c.f.i.CuratorFrameworkImpl main [INFO] Starting
2019-11-25 20:32:23.816 o.a.s.s.o.a.z.ClientCnxn main-EventThread [INFO] EventThread shut down
2019-11-25 20:32:23.816 o.a.s.s.o.a.z.ZooKeeper main [INFO] Initiating client connection, connectString=node1:2181,node2:2181,node3:2181/storm sessionTimeout=30000 watcher=org.apache.storm.shade.org.apache.curator.ConnectionState@5961e92d
2019-11-25 20:32:23.835 o.a.s.s.o.a.z.ClientCnxn main-SendThread(node3:2181) [INFO] Opening socket connection to server node3/192.168.20.47:2181. Will not attempt to authenticate using SASL (unknown error)
2019-11-25 20:32:23.836 o.a.s.s.o.a.z.ClientCnxn main-SendThread(node3:2181) [INFO] Socket connection established, initiating session, client: /192.168.20.45:54154, server: node3/192.168.20.47:2181
2019-11-25 20:32:23.839 o.a.s.s.o.a.z.ClientCnxn main-SendThread(node3:2181) [INFO] Session establishment complete on server node3/192.168.20.47:2181, sessionid = 0x36ea288abf90011, negotiated timeout = 30000
2019-11-25 20:32:23.839 o.a.s.s.o.a.c.f.s.ConnectionStateManager main-EventThread [INFO] State change: CONNECTED
2019-11-25 20:32:24.004 o.a.s.s.a.AuthUtils main [INFO] Got AutoCreds []
2019-11-25 20:32:24.008 o.a.s.d.worker main [INFO] Reading Assignments.
2019-11-25 20:32:24.182 o.a.s.m.TransportFactory main [INFO] Storm peer transport plugin:org.apache.storm.messaging.netty.Context
2019-11-25 20:32:24.627 o.a.s.m.n.Server main [INFO] Create Netty Server Netty-server-localhost-6700, buffer_size: 5242880, maxWorkers: 5
2019-11-25 20:32:24.852 o.a.s.d.worker main [INFO] Registering IConnectionCallbacks for 86072b1f-f4a3-49a0-bbbe-0170a8aa9d47:6700
2019-11-25 20:32:24.913 o.a.s.d.executor main [INFO] Loading executor __metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink:[2 2]
2019-11-25 20:32:24.938 o.a.s.d.executor main [INFO] Loaded executor tasks __metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink:[2 2]
2019-11-25 20:32:24.953 o.a.s.d.executor main [INFO] Finished loading executor __metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink:[2 2]
2019-11-25 20:32:24.971 o.a.s.d.executor main [INFO] Loading executor errorMessageWriter:[3 3]
2019-11-25 20:32:25.079 o.a.s.d.executor main [INFO] Loaded executor tasks errorMessageWriter:[3 3]
2019-11-25 20:32:25.083 o.a.s.d.executor main [INFO] Finished loading executor errorMessageWriter:[3 3]
2019-11-25 20:32:25.091 o.a.s.d.executor main [INFO] Loading executor __acker:[1 1]
2019-11-25 20:32:25.092 o.a.s.d.executor main [INFO] Loaded executor tasks __acker:[1 1]
2019-11-25 20:32:25.102 o.a.s.d.executor main [INFO] Timeouts disabled for executor __acker:[1 1]
2019-11-25 20:32:25.103 o.a.s.d.executor main [INFO] Finished loading executor __acker:[1 1]
2019-11-25 20:32:25.112 o.a.s.d.executor main [INFO] Loading executor __system:[-1 -1]
2019-11-25 20:32:25.116 o.a.s.d.executor main [INFO] Loaded executor tasks __system:[-1 -1]
2019-11-25 20:32:25.125 o.a.s.d.executor main [INFO] Finished loading executor __system:[-1 -1]
2019-11-25 20:32:25.144 o.a.s.d.executor main [INFO] Loading executor parserBolt:[5 5]
2019-11-25 20:32:25.174 o.a.s.d.executor main [INFO] Loaded executor tasks parserBolt:[5 5]
2019-11-25 20:32:25.188 o.a.s.d.executor main [INFO] Finished loading executor parserBolt:[5 5]
2019-11-25 20:32:25.200 o.a.s.d.executor main [INFO] Loading executor kafkaSpout:[4 4]
2019-11-25 20:32:25.279 o.a.s.d.executor main [INFO] Loaded executor tasks kafkaSpout:[4 4]
2019-11-25 20:32:25.292 o.a.s.d.executor main [INFO] Finished loading executor kafkaSpout:[4 4]
2019-11-25 20:32:25.304 o.a.s.d.worker main [INFO] Started with log levels: {"" #object[org.apache.logging.log4j.Level 0x6f731759 "INFO"], "STDERR" #object[org.apache.logging.log4j.Level 0x6f731759 "INFO"], "STDOUT" #object[org.apache.logging.log4j.Level 0x6f731759 "INFO"], "org.apache.storm.metric.LoggingMetricsConsumer" #object[org.apache.logging.log4j.Level 0x6f731759 "INFO"]}
2019-11-25 20:32:25.317 o.a.s.d.worker main [INFO] Worker has topology config {"topology.builtin.metrics.bucket.size.secs" 60, "nimbus.childopts" "-Xmx1024m  -javaagent:/usr/hdp/current/storm-nimbus/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar=host=localhost,port=8649,wireformat31x=true,mode=multicast,config=/usr/hdp/current/storm-nimbus/contrib/storm-jmxetric/conf/jmxetric-conf.xml,process=Nimbus_JVM", "ui.filter.params" nil, "storm.cluster.mode" "distributed", "topology.metrics.metric.name.separator" ".", "storm.messaging.netty.client_worker_threads" 5, "client.jartransformer.class" "org.apache.storm.hack.StormShadeTransformer", "logviewer.max.per.worker.logs.size.mb" 2048, "supervisor.run.worker.as.user" false, "topology.max.task.parallelism" nil, "topology.priority" 29, "zmq.threads" 1, "storm.group.mapping.service" "org.apache.storm.security.auth.ShellBasedGroupsMapping", "transactional.zookeeper.root" "/transactional", "topology.sleep.spout.wait.strategy.time.ms" 1, "scheduler.display.resource" false, "topology.max.replication.wait.time.sec" 60, "drpc.invocations.port" 3773, "supervisor.localizer.cache.target.size.mb" 10240, "topology.multilang.serializer" "org.apache.storm.multilang.JsonSerializer", "storm.messaging.netty.server_worker_threads" 5, "nimbus.blobstore.class" "org.apache.storm.blobstore.LocalFsBlobStore", "resource.aware.scheduler.eviction.strategy" "org.apache.storm.scheduler.resource.strategies.eviction.DefaultEvictionStrategy", "topology.max.error.report.per.interval" 5, "storm.thrift.transport" "org.apache.storm.security.auth.SimpleTransportPlugin", "zmq.hwm" 0, "storm.group.mapping.service.params" nil, "worker.profiler.enabled" false, "storm.topology.submission.notifier.plugin.class" "org.apache.atlas.storm.hook.StormAtlasHook", "storm.principal.tolocal" "org.apache.storm.security.auth.DefaultPrincipalToLocal", "supervisor.worker.shutdown.sleep.secs" 3, "pacemaker.host" "localhost", "storm.zookeeper.retry.times" 5, "ui.actions.enabled" true, "zmq.linger.millis" 5000, "supervisor.enable" true, "topology.stats.sample.rate" 0.05, "storm.messaging.netty.min_wait_ms" 100, "worker.log.level.reset.poll.secs" 30, "storm.zookeeper.port" 2181, "supervisor.heartbeat.frequency.secs" 5, "topology.enable.message.timeouts" true, "supervisor.cpu.capacity" 400.0, "drpc.worker.threads" 64, "supervisor.blobstore.download.thread.count" 5, "task.backpressure.poll.secs" 30, "drpc.queue.size" 128, "topology.backpressure.enable" false, "supervisor.blobstore.class" "org.apache.storm.blobstore.NimbusBlobStore", "storm.blobstore.inputstream.buffer.size.bytes" 65536, "topology.shellbolt.max.pending" 100, "drpc.https.keystore.password" "", "nimbus.code.sync.freq.secs" 120, "logviewer.port" 8000, "nimbus.reassign" true, "topology.scheduler.strategy" "org.apache.storm.scheduler.resource.strategies.scheduling.DefaultResourceAwareStrategy", "topology.executor.send.buffer.size" 1024, "resource.aware.scheduler.priority.strategy" "org.apache.storm.scheduler.resource.strategies.priority.DefaultSchedulingPriorityStrategy", "pacemaker.auth.method" "NONE", "storm.daemon.metrics.reporter.plugins" ["org.apache.storm.daemon.metrics.reporters.JmxPreparableReporter"], "topology.worker.logwriter.childopts" "-Xmx64m", "topology.spout.wait.strategy" "org.apache.storm.spout.SleepSpoutWaitStrategy", "ui.host" "0.0.0.0", "topology.submitter.principal" "", "storm.nimbus.retry.interval.millis" 2000, "nimbus.inbox.jar.expiration.secs" 3600, "dev.zookeeper.path" "/tmp/dev-storm-zookeeper", "topology.acker.executors" nil, "topology.fall.back.on.java.serialization" true, "topology.eventlogger.executors" 0, "supervisor.localizer.cleanup.interval.ms" 600000, "storm.zookeeper.servers" ["node1" "node2" "node3"], "topology.metrics.expand.map.type" true, "nimbus.thrift.threads" 196, "logviewer.cleanup.age.mins" 10080, "topology.worker.childopts" nil, "topology.classpath" "/etc/hbase/conf:/etc/hadoop/conf", "supervisor.monitor.frequency.secs" 3, "nimbus.credential.renewers.freq.secs" 600, "topology.skip.missing.kryo.registrations" false, "drpc.authorizer.acl.filename" "drpc-auth-acl.yaml", "pacemaker.kerberos.users" [], "storm.group.mapping.service.cache.duration.secs" 120, "topology.testing.always.try.serialize" false, "nimbus.monitor.freq.secs" 10, "storm.health.check.timeout.ms" 5000, "supervisor.supervisors" [], "topology.tasks" nil, "topology.bolts.outgoing.overflow.buffer.enable" false, "storm.messaging.netty.socket.backlog" 500, "topology.workers" 1, "pacemaker.base.threads" 10, "storm.local.dir" "/hadoop/storm", "worker.childopts" "-Xmx768m  -javaagent:/usr/hdp/current/storm-client/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar=host=localhost,port=8650,wireformat31x=true,mode=multicast,config=/usr/hdp/current/storm-client/contrib/storm-jmxetric/conf/jmxetric-conf.xml,process=Worker_%ID%_JVM", "storm.auth.simple-white-list.users" [], "topology.disruptor.batch.timeout.millis" 1, "topology.message.timeout.secs" 30, "topology.state.synchronization.timeout.secs" 60, "topology.tuple.serializer" "org.apache.storm.serialization.types.ListDelegateSerializer", "supervisor.supervisors.commands" [], "nimbus.blobstore.expiration.secs" 600, "logviewer.childopts" "-Xmx128m ", "topology.environment" nil, "topology.debug" false, "topology.disruptor.batch.size" 100, "storm.disable.symlinks" false, "storm.messaging.netty.max_retries" 30, "ui.childopts" "-Xmx768m ", "storm.network.topography.plugin" "org.apache.storm.networktopography.DefaultRackDNSToSwitchMapping", "storm.zookeeper.session.timeout" 30000, "drpc.childopts" "-Xmx768m ", "drpc.http.creds.plugin" "org.apache.storm.security.auth.DefaultHttpCredentialsPlugin", "storm.zookeeper.connection.timeout" 30000, "storm.zookeeper.auth.user" nil, "storm.meta.serialization.delegate" "org.apache.storm.serialization.GzipThriftSerializationDelegate", "topology.max.spout.pending" 1000, "storm.codedistributor.class" "org.apache.storm.codedistributor.LocalFileSystemCodeDistributor", "nimbus.supervisor.timeout.secs" 60, "nimbus.task.timeout.secs" 30, "storm.zookeeper.superACL" nil, "drpc.port" 3772, "pacemaker.max.threads" 50, "storm.zookeeper.retry.intervalceiling.millis" 30000, "nimbus.thrift.port" 6627, "storm.auth.simple-acl.admins" [], "topology.component.cpu.pcore.percent" 10.0, "supervisor.memory.capacity.mb" 3072.0, "storm.nimbus.retry.times" 5, "supervisor.worker.start.timeout.secs" 120, "topology.metrics.aggregate.per.worker" true, "storm.zookeeper.retry.interval" 1000, "logs.users" nil, "storm.cluster.metrics.consumer.publish.interval.secs" 60, "worker.profiler.command" "flight.bash", "transactional.zookeeper.port" nil, "drpc.max_buffer_size" 1048576, "pacemaker.thread.timeout" 10, "task.credentials.poll.secs" 30, "drpc.https.keystore.type" "JKS", "topology.worker.receiver.thread.count" 1, "topology.state.checkpoint.interval.ms" 1000, "supervisor.slots.ports" [6700 6701], "topology.transfer.buffer.size" 1024, "storm.health.check.dir" "healthchecks", "topology.worker.shared.thread.pool.size" 4, "drpc.authorizer.acl.strict" false, "nimbus.file.copy.expiration.secs" 600, "worker.profiler.childopts" "-XX:+UnlockCommercialFeatures -XX:+FlightRecorder", "topology.executor.receive.buffer.size" 1024, "backpressure.disruptor.low.watermark" 0.4, "topology.optimize" true, "topology.users" [], "nimbus.task.launch.secs" 120, "storm.local.mode.zmq" false, "storm.messaging.netty.buffer_size" 5242880, "storm.cluster.state.store" "org.apache.storm.cluster_state.zookeeper_state_factory", "topology.metrics.aggregate.metric.evict.secs" 5, "worker.heartbeat.frequency.secs" 1, "storm.log4j2.conf.dir" "log4j2", "ui.http.creds.plugin" "org.apache.storm.security.auth.DefaultHttpCredentialsPlugin", "storm.zookeeper.root" "/storm", "topology.submitter.user" "storm", "topology.tick.tuple.freq.secs" nil, "drpc.https.port" -1, "storm.workers.artifacts.dir" "workers-artifacts", "supervisor.blobstore.download.max_retries" 3, "task.refresh.poll.secs" 10, "topology.metrics.consumer.register" [{"whitelist" ["kafkaOffset\\..+/" "__complete-latency" "__process-latency" "__receive\\.population$" "__sendqueue\\.population$" "__execute-count" "__emit-count" "__ack-count" "__fail-count" "memory/heap\\.usedBytes$" "memory/nonHeap\\.usedBytes$" "GC/.+\\.count$" "GC/.+\\.timeMs$"], "class" "org.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink", "parallelism.hint" 1}], "storm.exhibitor.port" 8080, "task.heartbeat.frequency.secs" 3, "pacemaker.port" 6699, "storm.messaging.netty.max_wait_ms" 1000, "topology.component.resources.offheap.memory.mb" 0.0, "drpc.http.port" 3774, "topology.error.throttle.interval.secs" 10, "storm.messaging.transport" "org.apache.storm.messaging.netty.Context", "topology.disable.loadaware.messaging" false, "storm.messaging.netty.authentication" false, "topology.component.resources.onheap.memory.mb" 128.0, "topology.kryo.factory" "org.apache.storm.serialization.DefaultKryoFactory", "topology.kryo.register" nil, "worker.gc.childopts" "", "nimbus.topology.validator" "org.apache.storm.nimbus.DefaultTopologyValidator", "nimbus.seeds" ["node2"], "nimbus.queue.size" 100000, "nimbus.cleanup.inbox.freq.secs" 600, "storm.blobstore.replication.factor" 3, "worker.heap.memory.mb" 768, "logviewer.max.sum.worker.logs.size.mb" 4096, "pacemaker.childopts" "-Xmx1024m", "ui.users" nil, "transactional.zookeeper.servers" nil, "supervisor.worker.timeout.secs" 30, "storm.zookeeper.auth.password" nil, "storm.blobstore.acl.validation.enabled" false, "client.blobstore.class" "org.apache.storm.blobstore.NimbusBlobStore", "storm.cluster.metrics.consumer.register" [{"class" "org.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsReporter"}], "storm.thrift.socket.timeout.ms" 600000, "supervisor.childopts" "-Xmx256m  -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=56431 -javaagent:/usr/hdp/current/storm-supervisor/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar=host=localhost,port=8650,wireformat31x=true,mode=multicast,config=/usr/hdp/current/storm-supervisor/contrib/storm-jmxetric/conf/jmxetric-conf.xml,process=Supervisor_JVM", "topology.worker.max.heap.size.mb" 768.0, "ui.http.x-frame-options" "DENY", "backpressure.disruptor.high.watermark" 0.9, "ui.filter" nil, "topology.receiver.buffer.size" 8, "ui.header.buffer.bytes" 4096, "topology.min.replication.count" 1, "topology.disruptor.wait.timeout.millis" 1000, "storm.nimbus.retry.intervalceiling.millis" 60000, "topology.trident.batch.emit.interval.millis" 500, "topology.disruptor.wait.strategy" "com.lmax.disruptor.BlockingWaitStrategy", "storm.auth.simple-acl.users" [], "drpc.invocations.threads" 64, "java.library.path" "/usr/local/lib:/opt/local/lib:/usr/lib:/usr/hdp/current/storm-client/lib", "ui.port" 8744, "storm.log.dir" "/var/log/storm", "topology.kryo.decorators" [], "storm.id" "squid-83-1574682796", "topology.name" "squid", "storm.exhibitor.poll.uripath" "/exhibitor/v1/cluster/list", "storm.messaging.netty.transfer.batch.size" 262144, "logviewer.appender.name" "A1", "nimbus.thrift.max_buffer_size" 1048576, "storm.auth.simple-acl.users.commands" [], "drpc.request.timeout.secs" 600}
2019-11-25 20:32:25.318 o.a.s.d.worker main [INFO] Worker 667c6a6e-a7e6-4930-bd49-39ebbc2f4c94 for storm squid-83-1574682796 on 86072b1f-f4a3-49a0-bbbe-0170a8aa9d47:6700 has finished loading
2019-11-25 20:32:25.815 o.a.s.d.worker refresh-active-timer [INFO] All connections are ready for worker 86072b1f-f4a3-49a0-bbbe-0170a8aa9d47:6700 with id 667c6a6e-a7e6-4930-bd49-39ebbc2f4c94
2019-11-25 20:32:25.831 o.a.s.d.executor Thread-11-__system-executor[-1 -1] [INFO] Preparing bolt __system:(-1)
2019-11-25 20:32:25.841 o.a.s.d.executor Thread-11-__system-executor[-1 -1] [INFO] Prepared bolt __system:(-1)
2019-11-25 20:32:25.854 o.a.s.d.executor Thread-5-__metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink-executor[2 2] [INFO] Preparing bolt __metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink:(2)
2019-11-25 20:32:25.889 o.a.s.d.executor Thread-7-errorMessageWriter-executor[3 3] [INFO] Preparing bolt errorMessageWriter:(3)
2019-11-25 20:32:25.889 o.a.s.d.executor Thread-13-parserBolt-executor[5 5] [INFO] Preparing bolt parserBolt:(5)
2019-11-25 20:32:25.892 o.a.s.d.executor Thread-15-kafkaSpout-executor[4 4] [INFO] Opening spout kafkaSpout:(4)
2019-11-25 20:32:25.903 o.a.s.d.executor Thread-9-__acker-executor[1 1] [INFO] Preparing bolt __acker:(1)
2019-11-25 20:32:25.907 o.a.s.d.executor Thread-9-__acker-executor[1 1] [INFO] Prepared bolt __acker:(1)
2019-11-25 20:32:25.964 o.a.k.c.p.ProducerConfig Thread-7-errorMessageWriter-executor[3 3] [INFO] ProducerConfig values: 
	metric.reporters = []
	metadata.max.age.ms = 300000
	reconnect.backoff.ms = 50
	sasl.kerberos.ticket.renew.window.factor = 0.8
	bootstrap.servers = [node1:6667]
	ssl.keystore.type = JKS
	sasl.mechanism = GSSAPI
	max.block.ms = 60000
	interceptor.classes = null
	ssl.truststore.password = null
	client.id = 
	ssl.endpoint.identification.algorithm = null
	request.timeout.ms = 30000
	acks = 1
	receive.buffer.bytes = 32768
	ssl.truststore.type = JKS
	retries = 0
	ssl.truststore.location = null
	ssl.keystore.password = null
	send.buffer.bytes = 131072
	compression.type = none
	metadata.fetch.timeout.ms = 60000
	retry.backoff.ms = 100
	sasl.kerberos.kinit.cmd = /usr/bin/kinit
	buffer.memory = 33554432
	timeout.ms = 30000
	key.serializer = class org.apache.kafka.common.serialization.StringSerializer
	sasl.kerberos.service.name = null
	sasl.kerberos.ticket.renew.jitter = 0.05
	ssl.trustmanager.algorithm = PKIX
	block.on.buffer.full = false
	ssl.key.password = null
	sasl.kerberos.min.time.before.relogin = 60000
	connections.max.idle.ms = 540000
	max.in.flight.requests.per.connection = 5
	metrics.num.samples = 2
	ssl.protocol = TLS
	ssl.provider = null
	ssl.enabled.protocols = [TLSv1.2, TLSv1.1, TLSv1]
	batch.size = 65536
	ssl.keystore.location = null
	ssl.cipher.suites = null
	security.protocol = PLAINTEXT
	max.request.size = 1048576
	value.serializer = class org.apache.kafka.common.serialization.StringSerializer
	ssl.keymanager.algorithm = SunX509
	metrics.sample.window.ms = 30000
	partitioner.class = class org.apache.kafka.clients.producer.internals.DefaultPartitioner
	linger.ms = 0

2019-11-25 20:32:26.053 o.a.k.c.p.ProducerConfig Thread-7-errorMessageWriter-executor[3 3] [INFO] ProducerConfig values: 
	metric.reporters = []
	metadata.max.age.ms = 300000
	reconnect.backoff.ms = 50
	sasl.kerberos.ticket.renew.window.factor = 0.8
	bootstrap.servers = [node1:6667]
	ssl.keystore.type = JKS
	sasl.mechanism = GSSAPI
	max.block.ms = 60000
	interceptor.classes = null
	ssl.truststore.password = null
	client.id = producer-1
	ssl.endpoint.identification.algorithm = null
	request.timeout.ms = 30000
	acks = 1
	receive.buffer.bytes = 32768
	ssl.truststore.type = JKS
	retries = 0
	ssl.truststore.location = null
	ssl.keystore.password = null
	send.buffer.bytes = 131072
	compression.type = none
	metadata.fetch.timeout.ms = 60000
	retry.backoff.ms = 100
	sasl.kerberos.kinit.cmd = /usr/bin/kinit
	buffer.memory = 33554432
	timeout.ms = 30000
	key.serializer = class org.apache.kafka.common.serialization.StringSerializer
	sasl.kerberos.service.name = null
	sasl.kerberos.ticket.renew.jitter = 0.05
	ssl.trustmanager.algorithm = PKIX
	block.on.buffer.full = false
	ssl.key.password = null
	sasl.kerberos.min.time.before.relogin = 60000
	connections.max.idle.ms = 540000
	max.in.flight.requests.per.connection = 5
	metrics.num.samples = 2
	ssl.protocol = TLS
	ssl.provider = null
	ssl.enabled.protocols = [TLSv1.2, TLSv1.1, TLSv1]
	batch.size = 65536
	ssl.keystore.location = null
	ssl.cipher.suites = null
	security.protocol = PLAINTEXT
	max.request.size = 1048576
	value.serializer = class org.apache.kafka.common.serialization.StringSerializer
	ssl.keymanager.algorithm = SunX509
	metrics.sample.window.ms = 30000
	partitioner.class = class org.apache.kafka.clients.producer.internals.DefaultPartitioner
	linger.ms = 0

2019-11-25 20:32:26.054 o.a.k.c.p.ProducerConfig Thread-7-errorMessageWriter-executor[3 3] [WARN] The configuration request.required.acks = 1 was supplied but isn't a known config.
2019-11-25 20:32:26.058 o.a.k.c.u.AppInfoParser Thread-7-errorMessageWriter-executor[3 3] [INFO] Kafka version : 0.10.0.2.5.0.0-1245
2019-11-25 20:32:26.073 o.a.k.c.u.AppInfoParser Thread-7-errorMessageWriter-executor[3 3] [INFO] Kafka commitId : dae559f56f07e2cd
2019-11-25 20:32:26.081 o.a.s.d.executor Thread-7-errorMessageWriter-executor[3 3] [INFO] Prepared bolt errorMessageWriter:(3)
2019-11-25 20:32:26.108 o.a.c.f.i.CuratorFrameworkImpl Thread-13-parserBolt-executor[5 5] [INFO] Starting
2019-11-25 20:32:26.119 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:zookeeper.version=3.4.6-235--1, built on 10/30/2017 02:26 GMT
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:host.name=node1
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:java.version=1.8.0_172
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:java.vendor=Oracle Corporation
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:java.home=/usr/local/src/jdk1.8.0_172/jre
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:java.class.path=/usr/hdp/2.6.3.0-235/storm/lib/zookeeper.jar:/usr/hdp/2.6.3.0-235/storm/lib/minlog-1.3.0.jar:/usr/hdp/2.6.3.0-235/storm/lib/kryo-3.0.3.jar:/usr/hdp/2.6.3.0-235/storm/lib/storm-core-1.1.0.2.6.3.0-235.jar:/usr/hdp/2.6.3.0-235/storm/lib/servlet-api-2.5.jar:/usr/hdp/2.6.3.0-235/storm/lib/clojure-1.7.0.jar:/usr/hdp/2.6.3.0-235/storm/lib/log4j-core-2.8.2.jar:/usr/hdp/2.6.3.0-235/storm/lib/disruptor-3.3.2.jar:/usr/hdp/2.6.3.0-235/storm/lib/storm-rename-hack-1.1.0.2.6.3.0-235.jar:/usr/hdp/2.6.3.0-235/storm/lib/log4j-slf4j-impl-2.8.2.jar:/usr/hdp/2.6.3.0-235/storm/lib/slf4j-api-1.7.21.jar:/usr/hdp/2.6.3.0-235/storm/lib/ring-cors-0.1.5.jar:/usr/hdp/2.6.3.0-235/storm/lib/reflectasm-1.10.1.jar:/usr/hdp/2.6.3.0-235/storm/lib/objenesis-2.1.jar:/usr/hdp/2.6.3.0-235/storm/lib/log4j-api-2.8.2.jar:/usr/hdp/2.6.3.0-235/storm/lib/asm-5.0.3.jar:/usr/hdp/2.6.3.0-235/storm/lib/ambari-metrics-storm-sink.jar:/usr/hdp/2.6.3.0-235/storm/lib/log4j-over-slf4j-1.6.6.jar:/usr/hdp/2.6.3.0-235/storm/extlib/storm-bridge-shim-0.8.0.2.6.3.0-235.jar:/usr/hdp/2.6.3.0-235/storm/extlib/atlas-plugin-classloader-0.8.0.2.6.3.0-235.jar:/usr/hdp/current/storm-supervisor/conf:/hadoop/storm/supervisor/stormdist/squid-83-1574682796/stormjar.jar:/etc/hbase/conf:/etc/hadoop/conf:/usr/hdp/current/storm-client/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:java.library.path=/hadoop/storm/supervisor/stormdist/squid-83-1574682796/resources/Linux-amd64:/hadoop/storm/supervisor/stormdist/squid-83-1574682796/resources:/usr/local/lib:/opt/local/lib:/usr/lib:/usr/hdp/current/storm-client/lib
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:java.io.tmpdir=/hadoop/storm/workers/667c6a6e-a7e6-4930-bd49-39ebbc2f4c94/tmp
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:java.compiler=<NA>
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:os.name=Linux
2019-11-25 20:32:26.120 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:os.arch=amd64
2019-11-25 20:32:26.121 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:os.version=2.6.32-754.22.1.el6.x86_64
2019-11-25 20:32:26.121 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:user.name=storm
2019-11-25 20:32:26.121 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:user.home=/home/storm
2019-11-25 20:32:26.121 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Client environment:user.dir=/hadoop/storm/workers/667c6a6e-a7e6-4930-bd49-39ebbc2f4c94
2019-11-25 20:32:26.121 o.a.z.ZooKeeper Thread-13-parserBolt-executor[5 5] [INFO] Initiating client connection, connectString=node1:2181 sessionTimeout=60000 watcher=org.apache.curator.ConnectionState@48cfebb4
2019-11-25 20:32:26.134 o.a.h.m.s.s.StormTimelineMetricsSink Thread-5-__metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink-executor[2 2] [INFO] Preparing Storm Metrics Sink
2019-11-25 20:32:26.159 o.a.z.ClientCnxn Thread-13-parserBolt-executor[5 5]-SendThread(node1:2181) [INFO] Opening socket connection to server node1/192.168.20.45:2181. Will not attempt to authenticate using SASL (unknown error)
2019-11-25 20:32:26.160 o.a.z.ClientCnxn Thread-13-parserBolt-executor[5 5]-SendThread(node1:2181) [INFO] Socket connection established, initiating session, client: /192.168.20.45:47116, server: node1/192.168.20.45:2181
2019-11-25 20:32:26.168 o.a.z.ClientCnxn Thread-13-parserBolt-executor[5 5]-SendThread(node1:2181) [INFO] Session establishment complete on server node1/192.168.20.45:2181, sessionid = 0x16ea2894d6b0010, negotiated timeout = 60000
2019-11-25 20:32:26.202 o.a.s.d.executor Thread-5-__metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink-executor[2 2] [INFO] Prepared bolt __metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink:(2)
2019-11-25 20:32:26.205 o.a.c.f.s.ConnectionStateManager Thread-13-parserBolt-executor[5 5]-EventThread [INFO] State change: CONNECTED
2019-11-25 20:32:26.428 o.a.s.k.s.KafkaSpout Thread-15-kafkaSpout-executor[4 4] [WARN] Minimum required kafka-clients library version to enable metrics is 0.10.1.0. Disabling spout metrics.
2019-11-25 20:32:26.428 o.a.s.k.s.KafkaSpout Thread-15-kafkaSpout-executor[4 4] [INFO] Kafka Spout opened with the following configuration: KafkaSpoutConfig{kafkaProps={key.deserializer=class org.apache.kafka.common.serialization.ByteArrayDeserializer, value.deserializer=class org.apache.kafka.common.serialization.ByteArrayDeserializer, enable.auto.commit=false, group.id=squid_parser, bootstrap.servers=node2:6667,node3:6667,node1:6667, auto.offset.reset=earliest}, key=org.apache.kafka.common.serialization.ByteArrayDeserializer@22523e02, value=org.apache.kafka.common.serialization.ByteArrayDeserializer@58d10eed, pollTimeoutMs=200, offsetCommitPeriodMs=30000, maxUncommittedOffsets=10000000, firstPollOffsetStrategy=FirstPollOffsetStrategy{UNCOMMITTED_EARLIEST}, subscription=org.apache.storm.kafka.spout.NamedSubscription@7932393, translator=org.apache.metron.storm.kafka.flux.SimpleStormKafkaBuilder$SpoutRecordTranslator@6ab80090, retryService=KafkaSpoutRetryExponentialBackoff{delay=TimeInterval{length=0, timeUnit=SECONDS}, ratio=TimeInterval{length=2, timeUnit=MILLISECONDS}, maxRetries=2147483647, maxRetryDelay=TimeInterval{length=10, timeUnit=SECONDS}}, tupleListener=EmptyKafkaTupleListener, processingGuarantee=AT_LEAST_ONCE, metricsTimeBucketSizeInSecs=60}
2019-11-25 20:32:26.429 o.a.s.d.executor Thread-15-kafkaSpout-executor[4 4] [INFO] Opened spout kafkaSpout:(4)
2019-11-25 20:32:26.431 o.a.s.d.executor Thread-15-kafkaSpout-executor[4 4] [INFO] Activating spout kafkaSpout:(4)
2019-11-25 20:32:26.435 o.a.k.c.c.ConsumerConfig Thread-15-kafkaSpout-executor[4 4] [INFO] ConsumerConfig values: 
	metric.reporters = []
	metadata.max.age.ms = 300000
	partition.assignment.strategy = [org.apache.kafka.clients.consumer.RangeAssignor]
	reconnect.backoff.ms = 50
	sasl.kerberos.ticket.renew.window.factor = 0.8
	max.partition.fetch.bytes = 1048576
	bootstrap.servers = [node2:6667, node3:6667, node1:6667]
	ssl.keystore.type = JKS
	enable.auto.commit = false
	sasl.mechanism = GSSAPI
	interceptor.classes = null
	exclude.internal.topics = true
	ssl.truststore.password = null
	client.id = 
	ssl.endpoint.identification.algorithm = null
	max.poll.records = 2147483647
	check.crcs = true
	request.timeout.ms = 40000
	heartbeat.interval.ms = 3000
	auto.commit.interval.ms = 5000
	receive.buffer.bytes = 65536
	ssl.truststore.type = JKS
	ssl.truststore.location = null
	ssl.keystore.password = null
	fetch.min.bytes = 1
	send.buffer.bytes = 131072
	value.deserializer = class org.apache.kafka.common.serialization.ByteArrayDeserializer
	group.id = squid_parser
	retry.backoff.ms = 100
	sasl.kerberos.kinit.cmd = /usr/bin/kinit
	sasl.kerberos.service.name = null
	sasl.kerberos.ticket.renew.jitter = 0.05
	ssl.trustmanager.algorithm = PKIX
	ssl.key.password = null
	fetch.max.wait.ms = 500
	sasl.kerberos.min.time.before.relogin = 60000
	connections.max.idle.ms = 540000
	session.timeout.ms = 30000
	metrics.num.samples = 2
	key.deserializer = class org.apache.kafka.common.serialization.ByteArrayDeserializer
	ssl.protocol = TLS
	ssl.provider = null
	ssl.enabled.protocols = [TLSv1.2, TLSv1.1, TLSv1]
	ssl.keystore.location = null
	ssl.cipher.suites = null
	security.protocol = PLAINTEXT
	ssl.keymanager.algorithm = SunX509
	metrics.sample.window.ms = 30000
	auto.offset.reset = earliest

2019-11-25 20:32:26.446 o.a.k.c.c.ConsumerConfig Thread-15-kafkaSpout-executor[4 4] [INFO] ConsumerConfig values: 
	metric.reporters = []
	metadata.max.age.ms = 300000
	partition.assignment.strategy = [org.apache.kafka.clients.consumer.RangeAssignor]
	reconnect.backoff.ms = 50
	sasl.kerberos.ticket.renew.window.factor = 0.8
	max.partition.fetch.bytes = 1048576
	bootstrap.servers = [node2:6667, node3:6667, node1:6667]
	ssl.keystore.type = JKS
	enable.auto.commit = false
	sasl.mechanism = GSSAPI
	interceptor.classes = null
	exclude.internal.topics = true
	ssl.truststore.password = null
	client.id = consumer-1
	ssl.endpoint.identification.algorithm = null
	max.poll.records = 2147483647
	check.crcs = true
	request.timeout.ms = 40000
	heartbeat.interval.ms = 3000
	auto.commit.interval.ms = 5000
	receive.buffer.bytes = 65536
	ssl.truststore.type = JKS
	ssl.truststore.location = null
	ssl.keystore.password = null
	fetch.min.bytes = 1
	send.buffer.bytes = 131072
	value.deserializer = class org.apache.kafka.common.serialization.ByteArrayDeserializer
	group.id = squid_parser
	retry.backoff.ms = 100
	sasl.kerberos.kinit.cmd = /usr/bin/kinit
	sasl.kerberos.service.name = null
	sasl.kerberos.ticket.renew.jitter = 0.05
	ssl.trustmanager.algorithm = PKIX
	ssl.key.password = null
	fetch.max.wait.ms = 500
	sasl.kerberos.min.time.before.relogin = 60000
	connections.max.idle.ms = 540000
	session.timeout.ms = 30000
	metrics.num.samples = 2
	key.deserializer = class org.apache.kafka.common.serialization.ByteArrayDeserializer
	ssl.protocol = TLS
	ssl.provider = null
	ssl.enabled.protocols = [TLSv1.2, TLSv1.1, TLSv1]
	ssl.keystore.location = null
	ssl.cipher.suites = null
	security.protocol = PLAINTEXT
	ssl.keymanager.algorithm = SunX509
	metrics.sample.window.ms = 30000
	auto.offset.reset = earliest

2019-11-25 20:32:26.482 o.a.k.c.u.AppInfoParser Thread-15-kafkaSpout-executor[4 4] [INFO] Kafka version : 0.10.0.2.5.0.0-1245
2019-11-25 20:32:26.482 o.a.k.c.u.AppInfoParser Thread-15-kafkaSpout-executor[4 4] [INFO] Kafka commitId : dae559f56f07e2cd
2019-11-25 20:32:26.483 o.a.s.k.s.NamedSubscription Thread-15-kafkaSpout-executor[4 4] [INFO] Kafka consumer subscribed topics [squid]
2019-11-25 20:32:26.571 o.a.k.c.c.i.AbstractCoordinator Thread-15-kafkaSpout-executor[4 4] [INFO] Discovered coordinator node1:6667 (id: 2147482646 rack: null) for group squid_parser.
2019-11-25 20:32:26.574 o.a.k.c.c.i.ConsumerCoordinator Thread-15-kafkaSpout-executor[4 4] [INFO] Revoking previously assigned partitions [] for group squid_parser
2019-11-25 20:32:26.575 o.a.s.k.s.KafkaSpout Thread-15-kafkaSpout-executor[4 4] [INFO] Partitions revoked. [consumer-group=squid_parser, consumer=org.apache.kafka.clients.consumer.KafkaConsumer@62d0d7cb, topic-partitions=[]]
2019-11-25 20:32:26.575 o.a.k.c.c.i.AbstractCoordinator Thread-15-kafkaSpout-executor[4 4] [INFO] (Re-)joining group squid_parser
2019-11-25 20:32:26.597 o.a.k.c.c.i.AbstractCoordinator Thread-15-kafkaSpout-executor[4 4] [INFO] Successfully joined group squid_parser with generation 10682
2019-11-25 20:32:26.599 o.a.k.c.c.i.ConsumerCoordinator Thread-15-kafkaSpout-executor[4 4] [INFO] Setting newly assigned partitions [squid-0, squid-1] for group squid_parser
2019-11-25 20:32:26.599 o.a.s.k.s.KafkaSpout Thread-15-kafkaSpout-executor[4 4] [INFO] Partitions reassignment. [task-ID=4, consumer-group=squid_parser, consumer=org.apache.kafka.clients.consumer.KafkaConsumer@62d0d7cb, topic-partitions=[squid-0, squid-1]]
2019-11-25 20:32:26.684 o.a.s.k.s.KafkaSpout Thread-15-kafkaSpout-executor[4 4] [INFO] Initialization complete
2019-11-25 20:32:26.708 o.a.k.c.c.i.Fetcher Thread-15-kafkaSpout-executor[4 4] [INFO] Fetch offset 3498 is out of range for partition squid-0, resetting offset
2019-11-25 20:32:26.969 o.a.m.s.c.CachingStellarProcessor Thread-13-parserBolt-executor[5 5] [ERROR] Cannot create cache; missing or invalid configuration; stellar.cache.maxSize = null
2019-11-25 20:32:26.970 o.a.m.p.ParserRunnerImpl Thread-13-parserBolt-executor[5 5] [INFO] Initializing parsers...
2019-11-25 20:32:26.970 o.a.m.p.ParserRunnerImpl Thread-13-parserBolt-executor[5 5] [INFO] Creating parser for sensor squid with parser class = org.apache.metron.parsers.GrokParser and filter class = null 
2019-11-25 20:32:27.299 o.a.h.u.NativeCodeLoader Thread-13-parserBolt-executor[5 5] [WARN] Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
2019-11-25 20:32:28.323 o.a.h.h.s.DomainSocketFactory Thread-13-parserBolt-executor[5 5] [WARN] The short-circuit local reads feature cannot be used because libhadoop cannot be loaded.
2019-11-25 20:32:28.419 o.a.m.p.GrokParser Thread-13-parserBolt-executor[5 5] [INFO] File not found in HDFS, attempting to load /patterns/common from classpath using classloader for class org.apache.metron.parsers.GrokParser.
2019-11-25 20:32:28.420 o.a.m.p.GrokParser Thread-13-parserBolt-executor[5 5] [INFO] Grok parser loading common patterns from: /patterns/common
2019-11-25 20:32:28.425 o.a.m.p.GrokParser Thread-13-parserBolt-executor[5 5] [INFO] Loading parser-specific patterns from: /patterns/squid
2019-11-25 20:32:28.464 o.a.m.p.GrokParser Thread-13-parserBolt-executor[5 5] [INFO] File not found in HDFS, attempting to load /patterns/squid from classpath using classloader for class org.apache.metron.parsers.GrokParser.
2019-11-25 20:32:28.465 o.a.m.p.GrokParser Thread-13-parserBolt-executor[5 5] [INFO] Grok parser set the following grok expression for 'SQUID_DELIMITED': %{NUMBER:timestamp}[^0-9]*%{INT:elapsed} %{IP:ip_src_addr} %{WORD:action}/%{NUMBER:code} %{NUMBER:bytes} %{WORD:method} %{NOTSPACE:url}[^0-9]*(%{IP:ip_dst_addr})?
2019-11-25 20:32:28.486 o.a.m.p.GrokParser Thread-13-parserBolt-executor[5 5] [INFO] Compiled grok pattern %{SQUID_DELIMITED}
2019-11-25 20:32:28.487 o.a.k.c.p.ProducerConfig Thread-13-parserBolt-executor[5 5] [INFO] ProducerConfig values: 
	metric.reporters = []
	metadata.max.age.ms = 300000
	reconnect.backoff.ms = 50
	sasl.kerberos.ticket.renew.window.factor = 0.8
	bootstrap.servers = [node1:6667]
	ssl.keystore.type = JKS
	sasl.mechanism = GSSAPI
	max.block.ms = 60000
	interceptor.classes = null
	ssl.truststore.password = null
	client.id = 
	ssl.endpoint.identification.algorithm = null
	request.timeout.ms = 30000
	acks = 1
	receive.buffer.bytes = 32768
	ssl.truststore.type = JKS
	retries = 0
	ssl.truststore.location = null
	ssl.keystore.password = null
	send.buffer.bytes = 131072
	compression.type = none
	metadata.fetch.timeout.ms = 60000
	retry.backoff.ms = 100
	sasl.kerberos.kinit.cmd = /usr/bin/kinit
	buffer.memory = 33554432
	timeout.ms = 30000
	key.serializer = class org.apache.kafka.common.serialization.StringSerializer
	sasl.kerberos.service.name = null
	sasl.kerberos.ticket.renew.jitter = 0.05
	ssl.trustmanager.algorithm = PKIX
	block.on.buffer.full = false
	ssl.key.password = null
	sasl.kerberos.min.time.before.relogin = 60000
	connections.max.idle.ms = 540000
	max.in.flight.requests.per.connection = 5
	metrics.num.samples = 2
	ssl.protocol = TLS
	ssl.provider = null
	ssl.enabled.protocols = [TLSv1.2, TLSv1.1, TLSv1]
	batch.size = 65536
	ssl.keystore.location = null
	ssl.cipher.suites = null
	security.protocol = PLAINTEXT
	max.request.size = 1048576
	value.serializer = class org.apache.kafka.common.serialization.StringSerializer
	ssl.keymanager.algorithm = SunX509
	metrics.sample.window.ms = 30000
	partitioner.class = class org.apache.kafka.clients.producer.internals.DefaultPartitioner
	linger.ms = 0

2019-11-25 20:32:28.490 o.a.k.c.p.ProducerConfig Thread-13-parserBolt-executor[5 5] [INFO] ProducerConfig values: 
	metric.reporters = []
	metadata.max.age.ms = 300000
	reconnect.backoff.ms = 50
	sasl.kerberos.ticket.renew.window.factor = 0.8
	bootstrap.servers = [node1:6667]
	ssl.keystore.type = JKS
	sasl.mechanism = GSSAPI
	max.block.ms = 60000
	interceptor.classes = null
	ssl.truststore.password = null
	client.id = producer-2
	ssl.endpoint.identification.algorithm = null
	request.timeout.ms = 30000
	acks = 1
	receive.buffer.bytes = 32768
	ssl.truststore.type = JKS
	retries = 0
	ssl.truststore.location = null
	ssl.keystore.password = null
	send.buffer.bytes = 131072
	compression.type = none
	metadata.fetch.timeout.ms = 60000
	retry.backoff.ms = 100
	sasl.kerberos.kinit.cmd = /usr/bin/kinit
	buffer.memory = 33554432
	timeout.ms = 30000
	key.serializer = class org.apache.kafka.common.serialization.StringSerializer
	sasl.kerberos.service.name = null
	sasl.kerberos.ticket.renew.jitter = 0.05
	ssl.trustmanager.algorithm = PKIX
	block.on.buffer.full = false
	ssl.key.password = null
	sasl.kerberos.min.time.before.relogin = 60000
	connections.max.idle.ms = 540000
	max.in.flight.requests.per.connection = 5
	metrics.num.samples = 2
	ssl.protocol = TLS
	ssl.provider = null
	ssl.enabled.protocols = [TLSv1.2, TLSv1.1, TLSv1]
	batch.size = 65536
	ssl.keystore.location = null
	ssl.cipher.suites = null
	security.protocol = PLAINTEXT
	max.request.size = 1048576
	value.serializer = class org.apache.kafka.common.serialization.StringSerializer
	ssl.keymanager.algorithm = SunX509
	metrics.sample.window.ms = 30000
	partitioner.class = class org.apache.kafka.clients.producer.internals.DefaultPartitioner
	linger.ms = 0

2019-11-25 20:32:28.491 o.a.k.c.p.ProducerConfig Thread-13-parserBolt-executor[5 5] [WARN] The configuration request.required.acks = 1 was supplied but isn't a known config.
2019-11-25 20:32:28.491 o.a.k.c.u.AppInfoParser Thread-13-parserBolt-executor[5 5] [INFO] Kafka version : 0.10.0.2.5.0.0-1245
2019-11-25 20:32:28.491 o.a.k.c.u.AppInfoParser Thread-13-parserBolt-executor[5 5] [INFO] Kafka commitId : dae559f56f07e2cd
2019-11-25 20:32:28.491 o.a.s.d.executor Thread-13-parserBolt-executor[5 5] [INFO] Prepared bolt parserBolt:(5)
2019-11-25 20:32:28.746 o.a.m.s.d.f.r.BaseFunctionResolver Thread-13-parserBolt-executor[5 5] [WARN] Using System classloader
2019-11-25 20:32:56.569 o.a.s.util Thread-15-kafkaSpout-executor[4 4] [ERROR] Async loop died!
java.lang.IllegalStateException: The offset [0] is below the current nextCommitOffset [3498] for [squid-0]. This should not be possible, and likely indicates a bug in the spout's acking or emit logic.
	at org.apache.storm.kafka.spout.internal.OffsetManager.findNextCommitOffset(OffsetManager.java:142) ~[stormjar.jar:?]
	at org.apache.storm.kafka.spout.KafkaSpout.commitOffsetsForAckedTuples(KafkaSpout.java:542) ~[stormjar.jar:?]
	at org.apache.storm.kafka.spout.KafkaSpout.nextTuple(KafkaSpout.java:290) ~[stormjar.jar:?]
	at org.apache.storm.daemon.executor$fn__10182$fn__10197$fn__10228.invoke(executor.clj:647) ~[storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at org.apache.storm.util$async_loop$fn__553.invoke(util.clj:484) [storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at clojure.lang.AFn.run(AFn.java:22) [clojure-1.7.0.jar:?]
	at java.lang.Thread.run(Thread.java:748) [?:1.8.0_172]
2019-11-25 20:32:56.573 o.a.s.d.executor Thread-15-kafkaSpout-executor[4 4] [ERROR] 
##########################################################
java.lang.IllegalStateException: The offset [0] is below the current nextCommitOffset [3498] for [squid-0]. This should not be possible, and likely indicates a bug in the spout's acking or emit logic.
	at org.apache.storm.kafka.spout.internal.OffsetManager.findNextCommitOffset(OffsetManager.java:142) ~[stormjar.jar:?]
	at org.apache.storm.kafka.spout.KafkaSpout.commitOffsetsForAckedTuples(KafkaSpout.java:542) ~[stormjar.jar:?]
	at org.apache.storm.kafka.spout.KafkaSpout.nextTuple(KafkaSpout.java:290) ~[stormjar.jar:?]
	at org.apache.storm.daemon.executor$fn__10182$fn__10197$fn__10228.invoke(executor.clj:647) ~[storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at org.apache.storm.util$async_loop$fn__553.invoke(util.clj:484) [storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at clojure.lang.AFn.run(AFn.java:22) [clojure-1.7.0.jar:?]
	at java.lang.Thread.run(Thread.java:748) [?:1.8.0_172]
2019-11-25 20:32:56.591 o.a.s.util Thread-15-kafkaSpout-executor[4 4] [ERROR] Halting process: ("Worker died")
java.lang.RuntimeException: ("Worker died")
	at org.apache.storm.util$exit_process_BANG_.doInvoke(util.clj:341) [storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at clojure.lang.RestFn.invoke(RestFn.java:423) [clojure-1.7.0.jar:?]
	at org.apache.storm.daemon.worker$fn__10852$fn__10853.invoke(worker.clj:763) [storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at org.apache.storm.daemon.executor$mk_executor_data$fn__10068$fn__10069.invoke(executor.clj:276) [storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at org.apache.storm.util$async_loop$fn__553.invoke(util.clj:494) [storm-core-1.1.0.2.6.3.0-235.jar:1.1.0.2.6.3.0-235]
	at clojure.lang.AFn.run(AFn.java:22) [clojure-1.7.0.jar:?]
	at java.lang.Thread.run(Thread.java:748) [?:1.8.0_172]
2019-11-25 20:32:56.592 o.a.s.d.worker Thread-18 [INFO] Shutting down worker squid-83-1574682796 86072b1f-f4a3-49a0-bbbe-0170a8aa9d47 6700
2019-11-25 20:32:56.593 o.a.s.d.worker Thread-18 [INFO] Terminating messaging context
2019-11-25 20:32:56.593 o.a.s.d.worker Thread-18 [INFO] Shutting down executors
2019-11-25 20:32:56.594 o.a.s.d.executor Thread-18 [INFO] Shutting down executor __metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink:[2 2]
2019-11-25 20:32:56.595 o.a.s.util Thread-4-disruptor-executor[2 2]-send-queue [INFO] Async loop interrupted!
2019-11-25 20:32:56.595 o.a.s.util Thread-5-__metricsorg.apache.hadoop.metrics2.sink.storm.StormTimelineMetricsSink-executor[2 2] [INFO] Async loop interrupted!
2019-11-25 20:32:56.596 o.a.h.m.s.s.StormTimelineMetricsSink Thread-18 [INFO] Stopping Storm Metrics Sink
```


- work.log 日志设置
/usr/hdp/2.6.3.0-235/storm/log4j2/work.xml

- work.clj
./storm-core/src/clj/org/apache/storm/daemon/worker.clj:    (log-message "Started with log levels: " @original-log-levels)
./storm-core/src/clj/org/apache/storm/daemon/worker.clj:    (log-message "Worker " worker-id " for storm " storm-id " on " assignment-id ":" port " has finished loading")



- executor.clj

./storm-core/src/clj/org/apache/storm/daemon/executor.clj:        (log-message "Preparing bolt " component-id ":" (keys task-datas))

### Understanding the Internal Message Buffers of Storm

When you are optimizing the performance of your Storm topologies it helps to understand how Storm’s internal message queues are configured and put to use. In this short article I will explain and illustrate how Storm version 0.8/0.9 implements the intra-worker communication that happens within a worker process and its associated executor threads.

https://www.michael-noll.com/blog/2013/06/21/understanding-storm-internal-message-buffers/

### Understanding the Parallelism of a Storm Topology
http://storm.apache.org/releases/current/Understanding-the-parallelism-of-a-Storm-topology.html


### kafkaSpout  and parserBolt executor
2019-11-25 20:32:25.889 o.a.s.d.executor Thread-13-parserBolt-executor[5 5] [INFO] Preparing bolt parserBolt:(5)
2019-11-25 20:32:25.892 o.a.s.d.executor Thread-15-kafkaSpout-executor[4 4] [INFO] Opening spout kafkaSpout:(4)


### KafkaSpout   storm-kafka-client
- D:\Project\DataSource\apache-storm-1.1.0\external\storm-kafka-client\src\main\java\org\apache\storm\kafka\spout\KafkaSpout.java
2019-11-25 20:32:26.428 o.a.s.k.s.KafkaSpout Thread-15-kafkaSpout-executor[4 4] [INFO] Kafka Spout opened with the following configuration: KafkaSpoutConfig{kafkaProps={key.deserializer=class 




### Spout组件的编写

https://www.cnblogs.com/WardSea/p/7366163.html

实现接口 backtype.storm.topology.IRichSpout;
或者继承backtype.storm.topology.base.BaseRichSpout;
```JAVA
@Override
public void open(Map conf, TopologyContext context, SpoutOutputCollector collector) {
// TODO Auto-generated method stub

}
open 方法，是spout的组件初始化方法，而且Spout实例创建后首先被调用，只调用一次


@Override
public void close() {
// 对于资源的释放关闭，可以在该方法中实现
}

 

@Override
public void nextTuple() {
// 实现如何从数据源上获取数据的逻辑
// 以及向后面的组件bolt发射数据
}

nextTuple 循环调用


@Override
public void ack(Object msgId) {
}
```
Topology启用了消息可靠性保障机制，当某个Tuple在Topology上处理成功后，调用ack方法执行一些消息处理成功后该干的事情

```
@Override
public void fail(Object msgId) {
// Topology启用了消息可靠性保障机制，某个Tuple在后面处理失败，该干什么

// 比如重试，重试达到最大可重试（比如三次）就丢弃
}


@Override
public void declareOutputFields(OutputFieldsDeclarer declarer) {
// 声明向后面组件发射的Tuple keys依次是什么

}

 

@Override
public Map<String, Object> getComponentConfiguration() {
// 设置该组件Spout一些专用的参数
return null;
}

kafkaSpout 向后发射的Tuple {"str":"msg"}

 

注意点：
Topology中使用的一些类，最好都要实现序列化接口 java.io.Serializable

3、Bolt组件
实现backtype.storm.topology.IRichBolt
或者继承backtype.storm.topology.base.BaseRichBolt

 

@Override
public void prepare(Map stormConf, TopologyContext context, OutputCollector collector) {
//类似于spout中open方法

}

 

SpoutOutputCollector spout组件中tuple的发射器

OutputCollector bolt组件中tuple发射器

 

@Override
public void execute(Tuple input) {
// TODO Auto-generated method stub

}
execute 类似于Spout的nextTuple方法


@Override
public void cleanup() {
// TODO Auto-generated method stub

}
类似于spout中close方法

 

@Override
public void declareOutputFields(OutputFieldsDeclarer declarer) {
// 声明向后面组件发射的Tuple keys依次是什么

}

 

@Override
public Map<String, Object> getComponentConfiguration() {
// 设置该组件Spout一些专用的参数
return null;
}

4、数据流分组 方式
shuffleGrouping 随机分配
fieldsGrouping 根据key分组进行分配
globalGrouping 全局分组 只会将tuple往后面组件中固定一个上发送

 

5、消息可靠性保障机制

启用消息可靠性保障机制：ack、fail


 

 

Spout端：

1）发射器发射tuple时，需要指定一个msgID
collector.emit(new Values(sentence),mssageId );

2）使用缓存所发射的tuple，Map key=msgID,value = Values

private Map<Object,Values> tuples;

3）ack方法
// 确认发射成功，将tuple从缓存中移除
tuples.remove(msgId);


4）fail方法
重试
// 重试
Values values = tuples.get(msgId);

// 重新发射
collector.emit(values,msgId );


Bolt端：
1）如果bolt端继续往后面组件发射，需要锚定前面的tuple
// 启用消息可靠性保障机制，需要锚定接收到tuple
collector.emit(input,new Values(word));

2）处理完tuple后
// 确认处理结束
collector.ack(input);

try{
}catch{
// 处理失败
collector.fail(input);
}
```


### Kafka Spout 
 - open
   - kafkaSpoutConfig

在open里，有2个异步定时器，加载配置

       if (!consumerAutoCommitMode) {     // If it is auto commit, no need to commit offsets manually
            commitTimer = new Timer(TIMER_DELAY_MS, kafkaSpoutConfig.getOffsetsCommitPeriodMs(), TimeUnit.MILLISECONDS);
        }
        refreshSubscriptionTimer = new Timer(TIMER_DELAY_MS, kafkaSpoutConfig.getPartitionRefreshPeriodMs(), TimeUnit.MILLISECONDS);


#### Activating spout
executor.clj 

- kafkaSpout.java
```Java
    @Override
    public void activate() {
        try {
            subscribeKafkaConsumer();
        } catch (InterruptException e) {
            throwKafkaConsumerInterruptedException();
        }
    }
```
## spout的生命周期

1、在定义Topology实例过程中，定义好Spout实例和Bolt实例
2、在提交Topology实例给Nimbus的过程中，会调用TopologyBuilder实例的createTopology()方法，以获取定义的Topology实例。在运行createTopology()方法的过程中，会去调用Spout和Bolt实例上的declareOutputFields()方法和getComponentConfiguration()方法，declareOutputFields()方法配置Spout和Bolt实例的输出，getComponentConfiguration()方法输出特定于Spout和Bolt实例的配置参数值对。Storm会将以上过程中得到的实例，输出配置和配置参数值对等数据序列化，然后传递给Nimbus。
3、在Worker Node上运行的thread，从Nimbus上复制序列化后得到的字节码文件，从中反序列化得到Spout和Bolt实例，实例的输出配置和实例的配置参数值对等数据，在thread中Spout和Bolt实例的declareOutputFields()和getComponentConfiguration()不会再运行。
4、在thread中，反序列化得到一个Spout实例后，它会先运行Spout实例的open()方法，在这个方法调用中，需要传入一个SpoutOutputCollector实例，后面使用该SpoutOutputCollector实例输出Tuple
5、然后Spout实例处于deactivated模式，过段时间会变成activated模式，此时会调用Spout实例的activate()方法
6、接下来在该thread中按配置数量建立task集合,在每个task中循环调用线程持有Spout实例的nextTuple()，ack()和fail()方法。任务处理成功，调用ack()；任务处理失败，调用fail()
7、在运行过程中，如果发送一个失效命令给thread，那么thread所持有的Spout实例会变成处于deactivated模式，并且会调用Spout实例的deactivate()方法
8、在关闭一个thread时，thread所持有的Spout实例会调用close()方法
不过如果是强制关闭，这个close()方法有可能不会被调用到



---

Spout的最顶层抽象是ISpout接口。

open方法是初始化动作。允许你在该spout初始化时做一些动作，传入了上下文，方便取上下文的一些数据。
close方法在该spout关闭前执行，但是并不能得到保证其一定被执行。spout是作为task运行在worker内，在cluster模式下，supervisor会直接kill -9 woker的进程，这样它就无法执行了。而在本地模式下，只要不是kill -9, 如果是发送停止命令，是可以保证close的执行的。

activate和deactivate ：一个spout可以被暂时激活和关闭，这两个方法分别在对应的时刻被调用。


nextTuple 用来发射数据。
ack(Object)传入的Object其实是一个id，唯一表示一个tuple。该方法是这个id所对应的tuple被成功处理后执行。
fail(Object)同ack，只不过是tuple处理失败时执行。
　　我们的RandomSpout 由于继承了BaseRichSpout，所以不用实现close、activate、deactivate、ack、fail和getComponentConfiguration方法，只关心最基本核心的部分。
结论：
　　通常情况下（Shell和事务型的除外），实现一个Spout，可以直接实现接口IRichSpout，如果不想写多余的代码，可以直接继承BaseRichSpout。
 
附注：Storm可靠的与不可靠的消息 （分析+实例）
 





## Reblance

再均衡监昕器

消费者在退出和进行分区再均衡之前，会做一些清理工作。

你可以在消费者失去对一个分区的所有权之前提交最后一个已处理记录的偏移量。

在为消费者分配新分区或移除旧分区时，可以通过消费者API执行一些应用程序代码，在调用subscribe方法时传进去一个

ConsumerRebalanceListener实例就可以了，ConsumerRebalanceListener有两个需要实现的方法。
```JAVA
consumer.subscribe(Collections.singleton("x"),new ConsumerRebalanceListener() {
		@Override
		public void onPartitionsAssigned( Collection<TopicPartition> partitions) {
			//在获得新分区后 do- nothing
		}

		@Override
		public void onPartitionsRevoked( Collection<TopicPartition> partitions ) {
			//即将失去分区所有权时提交偏移量
			consumer.commitSync(currentOffsets);
		}
	});
```





## Kafka 
.\clients\src\main\java\org\apache\kafka\clients\consumer\KafkaConsumer.java
.\clients\src\main\java\org\apache\kafka\clients\consumer\internals\Fetcher.java

KafkaConsumer->ConsumerCoordinator
KafkaConsumer->Fetcher

Fetcher::parseFetchedData
2019-11-25 20:32:26.708 o.a.k.c.c.i.Fetcher Thread-15-kafkaSpout-executor[4 4] [INFO] Fetch offset 3498 is out of range for partition squid-0, resetting offset


###

D:\Project\DataSource\apache-storm-1.1.0\external\storm-kafka-client\src\main\java\org\apache\storm\kafka\spout\internal\OffsetManager.java

https://github.com/apache/storm/blob/1.1.x-branch/external/storm-kafka-client/src/main/java/org/apache/storm/kafka/spout/internal/OffsetManager.java

```
            } else {
                throw new IllegalStateException("The offset [" + currOffset + "] is below the current nextCommitOffset "
                    + "[" + nextCommitOffset + "] for [" + tp + "]."
                    + " This should not be possible, and likely indicates a bug in the spout's acking or emit logic.");
            }
```


https://mvnrepository.com/artifact/org.apache.storm/storm-core?repo=hortonworks-releases





https://www.programcreek.com/java-api-examples/index.php?api=storm.kafka.KafkaSpout






### Cannot create cache; missing or invalid configuration
./metron-stellar/stellar-common/src/main/java/org/apache/metron/stellar/common/CachingStellarProcessor.java:      LOG.error("Cannot create cache; missing or invalid configuration; {} = {}", MAX_CACHE_SIZE_PARAM, maxSize);

### ParserBolt-> CachingStellarProcessor.createCache


./metron-platform/metron-parsing/metron-parsing-storm/src/main/java/org/apache/metron/parsers/bolt/ParserBolt.java:import org.apache.metron.stellar.common.CachingStellarProcessor;
./metron-platform/metron-parsing/metron-parsing-storm/src/main/java/org/apache/metron/parsers/bolt/ParserBolt.java:    Cache<CachingStellarProcessor.Key, Object> cache = CachingStellarProcessor.createCache(cacheConfig);

### prepare
prepare->initializeStellar


### ParserTopologyBuilder
./metron-platform/metron-parsing/metron-parsing-storm/src/main/java/org/apache/metron/parsers/topology/ParserTopologyCLI.java:    return ParserTopologyBuilder.build(




### Bolt接口各个方法的执行顺序
在storm-user中看到的一个关于Storm Bolt内部实现的执行顺序的提问, 觉得对理解Bolt内部实现有帮助, 记录一下. 

prepare方法在worker初始化task的时候调用. 

execute方法在每次有tuple进来的时候被调用 

cleanup实际上仅用于本地模式(local mode), 在集群模式(cluster mode)下该方法很难保证每次被正确执行. 

declearOutputFields方法仅在有新的topology提交到服务器, 用来决定输出内容流的格式(相当于定义spout/bolt之间传输stream的name:value格式), 在topology执行的过程中并不会被调用.

### 打开Kafka调试日志

https://stackoverflow.com/questions/35636739/kafka-consumer-marking-the-coordinator-2147483647-dead

logging.level.org.apache.kafka=TRACE

## outtopic的传递

ParserTopologyBuilder.build
ParserTopologyBuilder.createParserBolt
ParserTopologyBuilder.createWriterConfigs

ParserBolt
ParserBolt(writerConfigs)
WriterHandler.writer



use hdfsbolt to write data to hdfs

http://vishnuviswanath.com/realtime-storm-kafka2.html


http://www.treselle.com/blog/hive-streaming-with-kafka-and-storm-with-atlas/

https://www.tutorialspoint.com/apache_storm/apache_storm_core_concepts.htm

http://www.malinga.me/reading-and-understanding-the-storm-ui-storm-ui-explained/
