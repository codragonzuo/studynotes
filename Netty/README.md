
# Netty

http://seeallhearall.blogspot.com/2012/05/netty-tutorial-part-1-introduction-to.html?m=1



![](http://1.bp.blogspot.com/-5FuFYkbda_4/T7WMNYLZZ6I/AAAAAAAAB7E/KFPYzusYwgw/s1600/SendingDate.png)


![](https://itimetraveler.github.io/gallery/java-common/nio-selector-model.png)

## Java NIO：Buffer、Channel 和 Selector

http://www.importnew.com/28007.html

![](https://javadoop.com/blogimages/nio/6.png)

![](https://javadoop.com/blogimages/nio/5.png)

![](https://javadoop.com/blogimages/nio/4.png)

![](https://javadoop.com/blogimages/nio/3.png)

![](https://javadoop.com/blogimages/nio/2.png)

![](https://javadoop.com/blogimages/nio/1.png)


https://javadoop.com


## FileChannel 高速拷贝文件的秘密

总结:
写入前，底层调用 mmap()，利用 OS 层的内存映射和硬件层的 DMA 技术，直接将文件映射到内存空间，减少拷贝次数，便于快速访问；
写入时，底层为 writev 系统调用，能利用 buffer；

https://blog.rinc.xyz/posts/160922_nio/


