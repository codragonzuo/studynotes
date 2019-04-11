

聚类分析是把相似的对象通过静态分类的方法分层不同组别或者更多的子集。

1.原型聚类：典型的做法是K-means，首先设定k个类别，随机的在总体样本中选择k个样本作为聚类中心，然后遍历所有样本点，把所有样本点分类到k个类中（以最短距离为标准），然后更新k个样本的样本中心，再重新划分所有的样本点。停止条件可以设定为样本的变化幅度不大的情况，或者两次的损失函数变化不大的情况。

优点：简单、时间复杂度、空间复杂度低

缺点：随机初始化的中心点对结果影响很大；

2.层次聚类：就是对所有数据点中最为相似的样本点进行组合，然后更新样本中心（就是用一个样本中心代替这两个样本点），然后反复迭代，直到所有的样本点都结合之后，结束。

优点：层次聚类最主要的优点是集群不再需要假设为类球形。另外其也可以扩展到大数据集。

缺点：有点像 K 均值聚类，该算法需要设定集群的数量（即在算法完成后需要保留的层次）。

3.密度聚类：典型如DBSCAN，需要设定半径Eps，和指定数目MinPts，所有的样本点以半径Eps画圆，然后所有样本点被覆盖的圆的数目多于指定数目MinPts时，被认为是核心点，在半径Eps内点的数量少于MinPts，但是落在核心点的领域内，被认为是边界点，既不是核心点也不是边界点，那就是噪点。区分出所有的点之后，删除噪点，然后把所有连通的核心点连接成簇。优点：优点：DBSCAN 不需要假设集群为球状，并且它的性能是可扩展的。此外，它不需要每个点都被分配到一个集群中，这降低了集群的异常数据。

缺点：用户必须要调整【Eps】和【MinPts】这两个定义了集群密度的超参数。DBSCAN 对这些超参数非常敏感。


4.网络聚类：将d维数据空间的每一维平均分成等长的区间段，就是把数据划分成一些网格单元，如果一个网格单元所包含的样本数量大于某个阈值，则定义为高密度区，否则定义为低密度区。如果一个低密度区的周围都是低密度区，那这点区域被认定为是噪点，然后连接相邻的高密度单元。优点是能够处理大规模数据，可伸缩性好，算法结果不受输入顺序影响，结果简单方便理解。缺点是：参数不好设置，对噪点不好处理，效果不一定好。当d较大时，数量过大，计算量过于庞大。


It is basically a type of unsupervised learning method . An unsupervised learning method is a method in which we draw references from datasets consisting of input data without labeled responses. Generally, it is used as a process to find meaningful structure, explanatory underlying processes, generative features, and groupings inherent in a set of examples.

**Clustering** is the task of dividing the population or data points into a number of groups such that data points in the same groups are more similar to other data points in the same group and dissimilar to the data points in other groups. It is basically a collection of objects on the basis of similarity and dissimilarity between them.

Clustering Methods :

1. Density-Based Methods : 

These methods consider the clusters as the dense region having some similarity and different from the lower dense region of the space. These methods have good accuracy and ability to merge two clusters.Example DBSCAN (Density-Based Spatial Clustering of Applications with Noise) , OPTICS (Ordering Points to Identify Clustering Structure) etc.

2. Hierarchical Based Methods 

:The clusters formed in this method forms a tree type structure based on the hierarchy. New clusters are formed using the previously formed one. It is divided into two category

-> Agglomerative (bottom up approach)

-> Divisive (top down approach) .

examples CURE (Clustering Using Representatives), BIRCH (Balanced Iterative Reducing Clustering and using Hierarchies) etc.

3. Partitioning Methods : 

These methods partition the objects into k clusters and each partition forms one cluster. This method is used to optimize an objective criterion similarity function such as when the distance is a major parameter example K-means, CLARANS (Clustering Large Applications based upon randomized Search) etc.

4. Grid-based Methods : 

In this method the data space are formulated into a finite number of cells that form a grid-like structure. All the clustering operation done on these grids are fast and independent of the number of data objects example STING (Statistical Information Grid), wave cluster, CLIQUE (CLustering In Quest) etc.

Clustering Algorithms :

K-means clustering algorithm – It is the simplest unsupervised learning algorithm that solves clustering problem.K-means algorithm partition n observations into k clusters where each observation belongs to the cluster with the nearest mean serving as a prototype of the cluster .


 在Spark2.0版本中（不是基于RDD API的MLlib），共有四种聚类方法： 

（1）K-means 

（2）Latent Dirichlet allocation (LDA) 

（3）Bisecting k-means（二分k均值算法） 

（4）Gaussian Mixture Model (GMM)。 

基于RDD API的MLLib中，共有六种聚类方法： 

（1）K-means 

（2）Gaussian mixture 

（3）Power iteration clustering (PIC) 

（4）Latent Dirichlet allocation (LDA)** 

（5）Bisecting k-means 

（6）Streaming k-means 
