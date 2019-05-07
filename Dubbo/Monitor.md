# Monitor

所有的rpc方法调用都会经过MonitorFilter进行拦截，

MonitorFilter.invoke()

对于配置了监控的服务，会收集一些方法的基本统计信息。

MonitorFilter.collect()


DubboMonitor对收集到的数据进行简单统计，诸如成功次数，失败次数，调用时间等，统计完后存储数据到本地。

DubboMonitor.collect()


DubboMonitor有异步线程定时(默认每分钟)将收集到数据发送到远端监控服务。

```JAVA
 public DubboMonitor(Invoker<MonitorService> monitorInvoker, MonitorService monitorService) {
        this.monitorInvoker = monitorInvoker;
        this.monitorService = monitorService;
        this.monitorInterval = (long)monitorInvoker.getUrl().getPositiveParameter("interval", 60000);
        this.sendFuture = this.scheduledExecutorService.scheduleWithFixedDelay(new Runnable() {
            public void run() {
                try {
                    DubboMonitor.this.send();
                } catch (Throwable var2) {
                    DubboMonitor.logger.error("Unexpected error occur at send statistic, cause: " + var2.getMessage(), var2);
                }

            }
        }, this.monitorInterval, this.monitorInterval, TimeUnit.MILLISECONDS);
    }
```


调用远端的MonitorService.collect方法，然后将本地缓存数据置置零。

dubbo监控的主流开源项目，都是实现了MonitorService接口来实现监控，区别无非就是数据存储，报表统计逻辑的差异，基本原理都大同小异。




https://juejin.im/post/5b9f9d9df265da0a867c2a9f
