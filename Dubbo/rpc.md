
# Dubbo RPC的几个模块
 - Protocol
 - Filter
 - listener
 - model
 - proxy
 - service
 - support
 
![](https://cdncontribute.geeksforgeeks.org/wp-content/uploads/operating-system-remote-call-procedure-working.png)

#RPC

RPC（Remote Procedure Call）—远程过程调用，它是一种通过网络从远程计算机程序上请求服务，而不需要了解底层网络技术的协议。RPC协议假定某些传输协议的存在，如TCP或UDP，为通信程序之间携带信息数据。在OSI网络通信模型中，RPC跨越了传输层和应用层。RPC使得开发包括网络分布式多程序在内的应用程序更加容易。


具体调用过程：

1. 服务消费者（client客户端）通过调用本地服务的方式调用需要消费的服务；
2. 客户端存根（client stub）接收到调用请求后负责将方法、入参等信息序列化（组装）成能够进行网络传输的消息体；
3. 客户端存根（client stub）找到远程的服务地址，并且将消息通过网络发送给服务端；
4. 服务端存根（server stub）收到消息后进行解码（反序列化操作）；
5. 服务端存根（server stub）根据解码结果调用本地的服务进行相关处理；
6. 本地服务执行具体业务逻辑并将处理结果返回给服务端存根（server stub）；
7. 服务端存根（server stub）将返回结果重新打包成消息（序列化）并通过网络发送至消费方；
8. 客户端存根（client stub）接收到消息，并进行解码（反序列化）；
9. 服务消费方得到最终结果；

RPC是系统间的一种通信方式，系统间常用的通信方式还有http,webservice，rpc等，一般来讲rpc比http和webservice性能高一些，常见的RPC框架有：Thrift，Finagle，Hessian , dubbo，grpc，json-rpc , CORBA、Java RMI、Web Services、RESTful Web Services等。

主要包含两个大方面： 
1、A系统与B系统之间的连接传输（如：socket连接） 
2、序列化与反序列化

