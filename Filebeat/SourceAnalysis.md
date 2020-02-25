# Filebeat源码分析


https://www.jianshu.com/p/457e7aebbfb3



在基于elk的日志系统中，filebeat几乎是其中必不可少的一个组件，例外是使用性能较差的logstash file input插件或自己造个功能类似的轮子:)。

在使用和了解filebeat的过程中，笔者对其一些功能上的实现产生了疑问，诸如：

为什么libbeat能如此容易的进行扩展，衍生出多个应用广泛的beat运输程序？

为什么它的性能比logstash好？ （https://logz.io/blog/filebeat-vs-logstash/）

是如何实现‘保证至少发送一次’这个feature的呢？

代码模块是如何划分、如何组织、如何运行的呢？

...

为了找到答案，笔者阅读了filebeat和部分libbeat的源码（read the fucking source code），本文即是对此过程的一次总结。一方面是方便日后回顾，另一方面也希望能解答大家对filebeat的一些疑惑。

本文主要内容包括filebeat基本介绍、源码解析两个部分，主要面向的是：想要了解filebeat实现、想改造或扩展filebeat功能或想参考filebeat开发自定义beats的读者。

filebeat基本介绍

filebeat是一个开源的日志运输程序，属于beats家族中的一员，和其他beats一样都基于libbeat库实现。其中，libbeat是一个提供公共功能的库，功能包括： 配置解析、日志打印、事件处理和发送等。

对于任一种beats来说，主要逻辑都包含两个部分[2]：

收集数据并转换成事件

发送事件到指定的输出

其中第二点已由libbeat实现，因此各个beats实际只需要关心如何收集数据并生成事件后发送给libbeat的Publisher。beats和libeat的交互如下图所示：

![](https://upload-images.jianshu.io/upload_images/6030117-32a0a3427f33fc4c)

beats和libeat的交互

具体到filebeat，它能采集数据的类型包括： log文件、标准输入、redis、udp和tcp包、容器日志和syslog，其中最常见的是使用log类型采集文件日志发送到Elasticsearch或Logstash。而后续的源码解析，也主要基于这种使用场景。

基于libbeat实现的filebeat，主要拥有以下几个特性[3]：

在运输日志内容方面它拥有健壮性：正常情况下，filebeat读取并运输日志行，但如果期间程序因某些原因被中断了，它会记住中断前已处理成功的读取位置，在程序再次启动时恢复。

可以解析多种常见的日志格式，简化用户操作： filebeta内置多个模块（module）：auditd、Apache、NGINX、System、MySQL等，它们将常见日志格式的收集、解析和可视化简化成了一个单独命令，模块的实现方式：基于操作系统定义各个模块对应日志的默认路径、使用ingest node的pipeline解析特定的日志格式、结合kibana dashboard可视化解析后特定格式的日志。

支持容器应用的日志收集，并且能通过libbeat的autodiscover特性检测新加入的容器并使用对应的模块（module）或输入

不会使pipeline超过负载：使用backpressure-sensitive 协议感知后端（比如logstash、elasticsesarch等）压力，如果后端忙于处理数据，则降低读日志的速度；一旦阻塞被解决，则恢复。

可以将运输日志到elasticsearch或logstash中，在kibana进行可视化



![](https://upload-images.jianshu.io/upload_images/6030117-ca042bb40b0d1922)

## filebeat模块结构

1. filebeat主要模块

Crawler: 管理所有Input收集数据并发送事件到libbeat的Publisher

Input: 对应可配置的一种输入类型，每种类型都有具体的Input和Harvester实现。配置项

Harvester: 对应一个输入源，是收集数据的实际工作者。配置中，一个具体的Input可以包含多个输入源（Harvester）

module: 简化了一些常见程序日志（比如nginx日志）收集、解析、可视化（kibana dashboard）配置项

fileset: module下具体的一种Input定义（比如nginx包括access和error log），包含：1）输入配置；2）es ingest node pipeline定义；3）事件字段定义；4）示例kibana dashboard

Registrar：用于在事件发送成功后记录文件状态

2. libbeat主要模块

Publisher：

client: 提供Publish接口让filebeat将事件发送到Publisher。在发送到队列之前，内部会先调用processors（包括input 内部的processors和全局processors）进行处理。

processor: 事件处理器，可对事件按照配置中的条件进行各种处理（比如删除事件、保留指定字段等）。配置项

queue: 事件队列，有memqueue（基于内存）和spool（基于磁盘文件）两种实现。配置项

outputs: 事件的输出端，比如ES、Logstash、kafka等。配置项

acker: 事件确认回调，在事件发送成功后进行回调

autodiscover：用于自动发现容器并将其作为输入源

filebeat目录组织
```
├── autodiscover        # 包含filebeat的autodiscover适配器（adapter），当autodiscover发现新容器时创建对应类型的输入
├── beater              # 包含与libbeat库交互相关的文件
├── channel            # 包含filebeat输出到pipeline相关的文件
├── config              # 包含filebeat配置结构和解析函数
├── crawler            # 包含Crawler结构和相关函数
├── fileset            # 包含module和fileset相关的结构
├── harvester          # 包含Harvester接口定义、Reader接口及实现等
├── input              # 包含所有输入类型的实现（比如:log,stdin,syslog）
├── inputsource        # 在syslog输入类型中用于读取tcp或udp syslog
├── module              # 包含各module和fileset配置
├── modules.d          # 包含各module对应的日志路径配置文件，用于修改默认路径
├── processor          # 用于从容器日志的事件字段source中提取容器id
├── prospector          # 包含旧版本的输入结构Prospector，现已被Input取代
├── registrar          # 包含Registrar结构和方法
└── util                # 包含beat事件和文件状态的通用结构Data
└──...
```
除了以上目录注释外，以下将介绍一些个人认为比较重要的文件的详细内容，读者可作为阅读源码时的一个参考。

/beater

包含与libbeat库交互相关的文件：

acker.go: 包含在libbeat设置的ack回调函数，事件成功发送后被调用

channels.go: 包含在ack回调函数中被调用的记录者（logger），包括：

registrarLogger: 将已确认事件写入registrar运行队列

finishedLogger: 统计已确认事件数量

filebeat.go: 包含实现了beater接口的filebeat结构，接口函数包括：

New：创建了filebeat实例

Run：运行filebeat

Stop: 停止filebeat运行

signalwait.go：基于channel实现的等待函数，在filebeat中用于：

等待fileebat结束

等待确认事件被写入registry文件

/channel

filebeat输出（到pipeline）相关的文件

factory.go: 包含OutletFactory，用于创建输出器Outleter对象

interface.go: 定义输出接口Outleter

outlet.go: 实现Outleter，封装了libbeat的pipeline client，其在harvester中被调用用于将事件发送给pipeline

util.go: 定义ack回调的参数结构data，包含beat事件和文件状态

/input

包含Input接口及各种输入类型的Input和Harvester实现

Input：对应配置中的一个Input项，同个Input下可包含多个输入源（比如文件）

Harvester：每个输入源对应一个Harvester，负责实际收集数据、并发送事件到pipeline

/harvester

包含Harvester接口定义、Reader接口及实现等

forwarder.go: Forwarder结构（包含outlet）定义，用于转发事件

harvester.go: Harvester接口定义，具体实现则在/input目录下

registry.go: Registry结构，用于在Input中管理多个Harvester（输入源）的启动和停止

source.go: Source接口定义，表示输入源。目前仅有Pipe一种实现（包含os.File），用在log、stdin和docker输入类型中。btw，这三种输入类型都是用的log input的实现。

/reader目录: Reader接口定义和各种Reader实现

重要数据结构

beats通用事件结构(libbeat/beat/event.go):

type Event struct{
Timestamp time.Time// 收集日志时记录的时间戳，对应es文档中的@timestamp字段
Meta      common.MapStr// meta信息，outpus可选的将其作为事件字段输出。比如输出为es且指定了pipeline时，其pipeline id就被包含在此字段中
Fields    common.MapStr// 默认输出字段定义在field.yml，其他字段可以在通过fields配置项指定
Privateinterface{}// for beats private use
}

Crawler(filebeat/crawler/crawler.go):

// Crawler 负责抓取日志并发送到libbeat 

pipelinetype Crawler struct{
inputs          map[uint64]*input.Runner// 包含所有输入的runner
inputConfigs[]*common.Config
out            
channel.Factory        wg              sync.WaitGroupInputsFactory  cfgfile.RunnerFactoryModulesFactory  cfgfile.RunnerFactorymodulesReloader*cfgfile.ReloaderinputReloader*cfgfile.Reloaderonce            boolbeatVersion    stringbeatDone        chan struct{}}

log类型Input(filebeat/input/log/input.go)

// Input contains the input and its configtype Input struct{cfg*common.Configconfig        configstates*file.Statesharvesters*harvester.Registry// 包含Input所有Harvesteroutlet        channel.Outleter// Input共享的Publisher clientstateOutlet  channel.Outleterdone          chan struct{}numHarvesters atomic.Uint32meta          map[string]string}

log类型Harvester(filebeat/input/log/harvester.go):

type Harvester struct{id    uuid.UUIDconfig configsource harvester.Source// the source being watched// shutdown handlingdone    chan struct{}stopOnce sync.OncestopWg*sync.WaitGroupstopLock sync.Mutex// internal harvester statestate  file.Statestates*file.Stateslog*Log// file reader pipelinereader          reader.ReaderencodingFactory encoding.EncodingFactoryencoding        encoding.Encoding// event/state publishingoutletFactory OutletFactorypublishStatefunc(*util.Data)boolonTerminatefunc()}

Registrar(filebeat/registrar/registrar.go):

type Registrar struct{Channel      chan[]file.Stateout          successLoggerdone        chan struct{}registryFile string// Path to the Registry FilefileMode    os.FileMode// Permissions to apply on the Registry Filewg          sync.WaitGroupstates*file.States// Map with all file paths inside and the corresponding stategcRequired          bool// gcRequired is set if registry state needs to be gc'ed before the next writegcEnabled            bool// gcEnabled indictes the registry contains some state that can be gc'ed in the futureflushTimeout        time.DurationbufferedStateUpdates int}

libbeat Pipeline(libbeat/publisher/pipeline/pipeline.go)

type Pipeline struct{beatInfo beat.Infologger*logp.Loggerqueue  queue.Queueoutput*outputControllerobserver observereventer pipelineEventer// wait close supportwaitCloseMode    WaitCloseModewaitCloseTimeout time.DurationwaitCloser*waitCloser// pipeline ackackMode    pipelineACKModeackActive  atomic.BoolackDone    chan struct{}ackBuilder ackBuilder// pipelineEventsACKeventSema*semaprocessors pipelineProcessors}

作者：生活的探路者
链接：https://www.jianshu.com/p/457e7aebbfb3
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 执行流程

filebeat启动流程

1. 执行root命令

在filebeat/main.go文件中，main函数调用了cmd.RootCmd.Execute()，而RootCmd则是在cmd/root.go中被init函数初始化，其中就注册了filebeat.go:New函数以创建实现了beater接口的filebeat实例

对于任意一个beats来说，都需要有：1) 实现Beater接口的具体Beater（如Filebeat）; 2) 创建该具体Beater的(New)函数[4]。

beater接口定义（beat/beat.go）：

type Beaterinterface{// The main event loop. This method should block until signalled to stop by an// invocation of the Stop() method.Run(b*Beat)error// Stop is invoked to signal that the Run method should finish its execution.// It will be invoked at most once.Stop()}

2. 初始化和运行Filebeat

创建libbeat/cmd/instance/beat.go:Beat结构

执行(*Beat).launch方法

(*Beat).Init()初始化Beat：加载beats公共config

(*Beat).createBeater

registerTemplateLoading: 当输出为es时，注册加载es模板的回调函数

pipeline.Load: 创建Pipeline：包含队列、事件处理器、输出等

setupMetrics: 安装监控

filebeat.New: 解析配置(其中输入配置包括配置文件中的Input和module Input)等

loadDashboards加载kibana dashboard

(*Filebeat).Run: 运行filebeat

3. Filebeat运行

设置加载es pipeline的回调函数

初始化registrar和crawler

设置事件完成的回调函数

启动Registrar、启动Crawler、启动Autodiscover

等待filebeat运行结束

## 日志收集

从收集日志、到发送事件到publisher，其数据流如下图所示：

![](https://upload-images.jianshu.io/upload_images/6030117-aa12f9853cc7a941)

日志收集数据流

Crawler根据Input配置创建并启动具体Input对象

以log类型为例

Log input对象创建时会从registry读取文件状态(主要是offset)，然后为input配置中的文件路径创建harvester并运行

harvester启动时会通过Setup方法创建一系列reader形成读处理链

harvester从registry记录的文件位置开始读取，组装成事件（beat.Event）后发给Publisher reader

## reader

关于log类型的reader处理链，如下图所示：


![](https://upload-images.jianshu.io/upload_images/6030117-040c187af5115611)

reader处理链

opt表示根据配置决定是否创建该reader



Reader包括：

Line: 包含os.File，用于从指定offset开始读取日志行。虽然位于处理链的最内部，但其Next函数中实际的处理逻辑（读文件行）却是最新被执行的。

Encode: 包含Line Reader，将其读取到的行生成Message结构后返回

JSON, DockerJSON: 将json形式的日志内容decode成字段

StripNewLine：去除日志行尾部的空白符

Multiline: 用于读取多行日志

Limit: 限制单行日志字节数

除了Line Reader外，这些reader都实现了Reader接口：

type Readerinterface{Next()(Message,error)}

Reader通过内部包含Reader对象的方式，使Reader形成一个处理链，其实这就是设计模式中的责任链模式。

各Reader的Next方法的通用形式像是这样：Next方法调用内部Reader对象的Next方法获取Message，然后处理后返回。

func(r*SomeReader)Next()(Message,error){message,err:=r.reader.Next()iferr!=nil{returnmessage,err}// do some processing... returnmessage,nil}


## 事件处理和队列

在Crawler收集日志并转换成事件后，其就会通过调用Publisher对应client的Publish接口将事件送到Publisher，后续的处理流程也都将由libbeat完成，事件的流转如下图所示：

![https://upload-images.jianshu.io/upload_images/6030117-c555a5392d6b9147]

事件处理、进入队列及输出过程

事件处理器processor

在harvester调用client.Publish接口时，其内部会使用配置中定义的processors对事件进行处理，然后才将事件发送到Publisher队列。

通过官方文档了解到，processor包含两种：在Input内定义作为局部（Input独享）的processor，其只对该Input产生的事件生效；在顶层配置中定义作为全局processor，其对全部事件生效。

其对应的代码实现方式是： filebeat在使用libbeat pipeline的ConnectWith接口创建client时（factory.go中(*OutletFactory)Create函数），会将Input内部的定义processor作为参数传递给ConnectWith接口。而在ConnectWith实现中，会将参数中的processor和全局processor（在创建pipeline时生成）合并。从这里读者也可以发现，实际上每个Input都独享一个client，其包含一些Input自身的配置定义逻辑。

任一Processor都实现了Processor接口：Run函数包含处理逻辑，String返回Processor名。

type Processorinterface{Run(event*beat.Event)(*beat.Event,error)String()string}

关于支持的processors及其使用，读者可以参考官方文档Filter and enhance the exported data这一小节


队列queue

在事件经过处理器处理后，下一步将被发往Publisher的队列。在client.go在(*client) publish方法中我们可以看到，事件是通过调用c.producer.Publish(pubEvent)被实际发送的，而producer则通过具体Queue的Producer方法生成。

队列对象被包含在pipeline.go:Pipeline结构中，其接口的定义如下：

type Queueinterface{io.CloserBufferConfig()BufferConfigProducer(cfg ProducerConfig)ProducerConsumer()Consumer}

主要的，Producer方法生成Producer对象，用于向队列中push事件；Consumer方法生成Consumer对象，用于从队列中取出事件。Producer和Consumer接口定义如下：

type Producerinterface{Publish(event publisher.Event)boolTryPublish(event publisher.Event)boolCancel()int}type Consumerinterface{Get(sz int)(Batch,error)Close()error}

在配置中没有指定队列配置时，默认使用了memqueue作为队列实现，下面我们来看看memqueue及其对应producer和consumer定义：

Broker结构(memqueue在代码中实际对应的结构名是Broker)：

type Broker struct{done chan struct{}logger loggerbufSize int// buf        brokerBuffer// minEvents  int// idleTimeout time.Duration// api channelsevents    chan pushRequestrequests  chan getRequestpubCancel chan producerCancelRequest// internal channelsacks          chan intscheduledACKs chan chanListeventer queue.Eventer// wait group for worker shutdownwg          sync.WaitGroupwaitOnClose bool}

根据是否需要ack分为forgetfullProducer和ackProducer两种producer：

type forgetfullProducer struct{broker*BrokeropenState openState}type ackProducer struct{broker*Brokercancel    boolseq      uint32state    produceStateopenState openState}

consumer结构:

type consumer struct{broker*Brokerresp  chan getResponsedone  chan struct{}closed atomic.Bool}

三者的运作方式如下图所示：

![](https://upload-images.jianshu.io/upload_images/6030117-268d1e5d18a79a13)

queue、producer、consumer关系

Producer通过Publish或TryPublish事件放入Broker的队列，即结构中的channel对象evetns

Broker的主事件循环EventLoop将（请求）事件从events channel取出，放入自身结构体对象ringBuffer中。

主事件循环有两种类型：1）直接（不带buffer）事件循环结构directEventLoop：收到事件后尽可能快的转发；2）带buffer事件循环结构bufferingEventLoop：当buffer满或刷新超时时转发。具体使用哪一种取决于memqueue配置项flush.min_events，大于1时使用后者，否则使用前者。

eventConsumer调用Consumer的Get方法获取事件：1）首先将获取事件请求（包括请求事件数和用于存放其响应事件的channelresp）放入Broker的请求队列requests中，等待主事件循环EventLoop处理后将事件放入resp；2）获取resp的事件，组装成batch结构后返回

eventConsumer将事件放入output对应队列中

这部分关于事件在队列中各种channel间的流转，笔者认为是比较消耗性能的，但不清楚设计者这样设计的考量是什么。

另外值得思考的是，在多个go routine使用队列交互的场景下，libbeat中都使用了go语言channel作为其底层的队列，它是否可以完全替代加锁队列的使用呢？


事件发送

在队列消费者将事件放入output工作队列后，事件将在pipeline/output.go:netClientWorker的run()方法中被取出，然后使用具体output client将事件发送到指定输出(比如：es、logstash等)。

其中，netClientWorker的数目取决于具体输出client的数目（比如es作为输出时，client数目为host数目），它们共享相同的output工作队列。

此时如果发送失败会发生什么呢？ 在outputs/elasticsearch/client.go:Client的Publish方法可以看到：发送失败会重试失败的事件，直到全部事件都发送成功后才调用ACK确认。

ack机制和registrar记录文件状态

在事件发送成功后， 其ack的数据流如下图所示：

![](https://upload-images.jianshu.io/upload_images/6030117-d49ed2f80a4a4387)

registrar记录文件状态过程

在事件发送成功后，其被放入pipeline_ack.go:pipelineEventsACK的事件队列events中

pipelineEventsACK在worker中将事件取出,调用acker.go:(*eventACKer).ackEvents，将ack（文件状态）放入registrar的队列Channel中。此回调函数在filebeat.go:(*Filebeat)Run方法中通过Publisher.SetACKHandler设置。

在Registrar的Run()方法中取出队列中的文件状态，刷新registry文件

通过ack机制和registrar模块，filebeat实现了对已发送成功事件对应文件状态的记录，这使它即使在程序crash后重启的情况下也能从之前的文件位置恢复并继续处理，保证了日志数据（事件）被至少发送一次。

总结

至此，本篇文章关于filebeat源码解析的内容已经结束。

从整体看，filebeat的代码没有包含复杂的算法逻辑或底层实现，但其整体代码结构还是比较清晰的，即使对于不需要参考filebeat特性实现去开发自定义beats的读者来说，仍属于值得一读的源码。

