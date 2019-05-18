
## JVM Architecture
https://www.geeksforgeeks.org/jvm-works-jvm-architecture/amp/

## 工作原理 层次结构GC工作原理
https://segmentfault.com/a/1190000002579346

## Understanding Weak References

From Understanding Weak References, by Ethan Nicholas:

https://web.archive.org/web/20061130103858/http://weblogs.java.net/blog/enicholas/archive/2006/05/understanding_w.html


### https://blog.csdn.net/xlinsist/article/details/57089288

https://blog.csdn.net/xlinsist/article/details/57089288




## Tomcat-正统的类加载器架构

主流的Java Web服务器主要有tomcat,Jetty,WebLogic,WebSphere等,这些服务器都实现了自己定义的加载器(一般都有一个或者多个),因为一个功能齐全的服务器,都需要解决如下问题:

 - 部署在同一个服务器上的两个Web应用程序使用的Java 类库可以实现相互隔离,这是最基本的要求.两个不同应用程序可能会依赖同一个第三方类库的不同版本的,不能要求一个类库在一个服务器中只有一份,服务器应当保证两个应用程序的类库可以互相独立使用
 - 部署在同一个服务器上的两个Web应用程序所使用的Java类库可以互相共享,这个需求也很常见,如果Java类库不能共享使用,虚拟机的方法区很容易出现过度膨胀的风险
 - 服务器需要尽可能保证自身安全不受部署的Web应用程序影响.目前有许多主流的Java Web服务器都使用Java语言开发,因此服务器本身也有类库依赖的问题,一般来说,基于安全的考虑,服务器所使用的类库应该与应用程序使用的类库互相独立
 - 支持JSP的服务器,大部分都需要支持HotSwap功能(热交换功能)

由于上述的种种问题,在部署Web应用的时候如果只使用一个单独的ClassPath是无法满足需求的,所以各种Web服务器都不约而同的提供了多个ClassPath路径供用户存在第三方类库,这些路径一般都以lib,classes命名,被放置到不同路径的类库,具备不同的访问范围

和服务对象.tomcat服务器划分用户类库结构和类加载描述如下:

在tomcat目录结构中,有三组目录/common/*,/server/*,/shared/*可以用来存放类库,另外还有Web应用程序自身的目录/WEB-INF/*一共四组,把Java类库放在这些目录的含义和区别如下:

 - 放置在/common/*目录:这些类库可以被tomcat和所有的web应用程序共同使用
 - 放置在/server/*目录:这些类库可以被tomcat使用,所有的web应用程序都不可见
  放置在/shared/*目录:这些类库可以被所有的web应用程序共同使用,但是对tomcat自己不可见
 - 放置在/WEB-INF/*目录:这些类库仅仅对当前的web应用程序使用,对tomcat和其他的web应用程序都是不可见的
 - 为了支持上述这样的目录结构,并对目录里面的类库进行加载和隔离,Tomcat定义了多个类加载器来实现,这些类加载器都是按照经典的双亲委派模型来实现的,其关系如图所示:



主要的类加载器有CommonClassLoader,CatalinaClassLoader,SharedClassLoader和WebappClassLoader,它们分别加载/common/*,/server/*,/shared/*和/WEB-INF/*目录下的类库,其中WebApp加载器和JSP类加载器实例通常会存在多个

每一个web应用程序对应一个webapp类加载器,每一个JSP文件对应一个JSP类加载器.


通过上述的关系图可以看出CommonClassLoader能加载的类都可以被CatalinaClassLoader和SharedClassLoader使用,而CatalinaClassLoader和SharedClassLoader自己能加载的类则与对方相互隔离.WebAppClassLoader可以使用SharedClassLoader

能加载到的类,但是各个WebAppClassLoader实例之间相互隔离,而JasperLoader的加载范围仅仅是这个JSP编译出的那一个Class,它出现的目的就是为了被丢弃:当服务器检测到JSP文件被修改时,会替换掉目前的JasperClassLoader实例,并通过再建一个

新的JSP类加载器来实现JSP文件的HotSwap功能

![](https://images2018.cnblogs.com/blog/137084/201805/137084-20180526104342525-959933190.png)

Tomcat类加载器架构


参考资料:深入理解Java虚拟机

## OSGI的类加载器架构

![](https://img-blog.csdn.net/20140528145442187)

实现模块级热拔插

两个类加载器互相死锁问题




## JAVA编译器优化

## JAVA运行期优化


## JAVA 内存模型（Java Memory Model，JMM）
为了提高CPU运算并发性，减少IO操作，引入高速缓存Cache作为内存和处理器之间的缓冲，将运算需要的数据复制到缓存中，让运算快速进行，当运算结束后再从缓存同步到内存，这样处理器无需等待缓慢的内存读写。

高速缓存的存储交换引入了新问题：缓存一致性Cache Coherence。多处理器系统，每个处理器都有自己的高速缓存，又共享同一主内存Main Memory。当多个处理器运算任务涉及同一块主内存区域，将可能导致各自的缓冲数据不一致，为此建立了各个处理器访问缓冲的协议，比如MSI/MESI/MOSI/Synapse/Firefly/Dragon等。

内存模型是指在特点的操作协议下，对特定的内存或高速缓存较小读写访问的过程抽象。

### JAVA主内存和工作内存
 - Main Memory
 - Working Memory

![](https://images2015.cnblogs.com/blog/938496/201707/938496-20170709131224868-1098838798.png)

主内存和工作内存间的交互操作

![](https://images.cnblogs.com/cnblogs_com/aigongsi/201204/201204011757235219.jpg)



用于主内存的变量

 - lock
 - unlock
 
用于工作内存变量操作

 - read
 - load
 - use
 - assign
 - store
 - write
 
8种原子操作规则：

 - 1. 不允许read和load、store和write操作之一单独出现（即不允许一个变量从主存读取了但是工作内存不接受，或者从工作内存发起会写了但是主存不接受的情况），以上两个操作必须按顺序执行，但没有保证必须连续执行，也就是说，read与load之间、store与write之间是可插入其他指令的。
 - 2. 不允许一个线程丢弃它的最近的assign操作，即变量在工作内存中改变了之后必须把该变化同步回主内存。
 - 3. 不允许一个线程无原因地（没有发生过任何assign操作）把数据从线程的工作内存同步回主内存中。
 - 4. 一个新的变量只能从主内存中“诞生”，不允许在工作内存中直接使用一个未被初始化（load或assign）的变量，换句话说就是对一个变量实施use和store操作之前，必须先执行过了assign和load操作。
 - 5. 一个变量在同一个时刻只允许一条线程对其执行lock操作，但lock操作可以被同一个条线程重复执行多次，多次执行lock后，只有执行相同次数的unlock操作，变量才会被解锁。
 - 6. 如果对一个变量执行lock操作，将会清空工作内存中此变量的值，在执行引擎使用这个变量前，需要重新执行load或assign操作初始化变量的值。
 - 7. 如果一个变量实现没有被lock操作锁定，则不允许对它执行unlock操作，也不允许去unlock一个被其他线程锁定的变量。
 - 8. 对一个变量执行unlock操作之前，必须先把此变量同步回主内存（执行store和write操作）。

 
