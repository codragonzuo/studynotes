

## SPI机制
剖析一下Dubbo是如何使用SPI机制的，在接口中使用@SPI("值")使用默认的实现类，如果我们不想使用默认的实现类是如何处理的。

##1、获取指定实现类
在ExtensionLoader中获取默认实现类或者通过实现类名称来获取实现类。

Protocol refprotocol = ExtensionLoader.getExtensionLoader(Protocol.class).getDefaultExtension();

Protocol refprotocol = ExtensionLoader.getExtensionLoader(Protocol.class).getExtension("dubbo");

这样获取的都是实现类DubboProtocol，在之前一篇博客中我们已经了解到，实现类的对应关系是配置在文件中的，从ExtensionLoader会解析文件将数据添加到一个Map中，这样可以直接通过“dubbo”来获取到实现类DubboProtocol。这种实现还是比较简单，但有一个问题就是需要在代码中写死使用哪个实现类，这个就和SPI的初衷有所差别了，因此Dubbo提供了一个另外一个注解@@Adaptive。

##2、获取适配器类
Dubbo通过注解@Adaptive作为标记实现了一个适配器类，并且这个类是动态生成的，因此在Dubbo的源码中是看不到代码的，但是我们还是可以看到其实现方式的。Dubbo提供一个动态的适配器类的原因就是可以通过配置文件来动态的使用想要的接口实现类，并且不用改变任何接口的代码，简单来说其也是通过代理来实现的。
