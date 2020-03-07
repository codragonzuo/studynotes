

## NETWORK DIAGRAM

https://www.data-to-viz.com/graph/network.html

definition - mistake - related - code

Definition
Network diagrams (also called Graphs) show interconnections between a set of entities. Each entity is represented by a Node (or vertice). Connections between nodes are represented through links (or edges).

Here is an example showing the co-authors network of Vincent Ranwez, a researcher who’s my previous supervisor. Basically, people having published at least one research paper with him are represented by a node. If two people have been listed on the same publication at least once, they are connected by a link.


Four types of input
Four main types of network diagram exist, according to the features of data inputs. Here is a short description.


- Undirected and Unweighted
Tom, Cherelle and Melanie live in the same house. They are connected but no direction and no weight.
![](https://www.data-to-viz.com/graph/network_files/figure-html/unnamed-chunk-2-1.png)

- Undirected and Weighted
In the previous co-authors network, people are connected if they published a scientific paper together. The weight is the number of time it happend.
![](https://www.data-to-viz.com/graph/network_files/figure-html/unnamed-chunk-3-1.png)



- Directed and Unweighted
Tom follows Shirley on twitter, but the opposite is not necessarily true. The connection is unweighted: just connected or not.
![](https://www.data-to-viz.com/graph/network_files/figure-html/unnamed-chunk-4-1.png)



- Directed and Weighted
People migrate from a country to another: the weight is the number of people, the direction is the destination.
![](https://www.data-to-viz.com/graph/network_files/figure-html/unnamed-chunk-5-1.png)

### Variation

Many customizations are available for network diagrams. Here are a few features you can work on to improve your graphic:

Adding information to the node: you can add more insight to the graphic by customizing the color, the shape or the size of each node according to other variables.

Different layout algorythm: finding the most optimal position for each node is a tricky exercise that highly impacts the output. Several algorithms have been developped, and choosing the right one for your data is a crucial step. See this page for a list of the most common algorithm. Here is an example illustrating the differences between three options:



- Fruchterman-Reingold
Probably the most widely used algorithm, using a force-directed method.
![](https://www.data-to-viz.com/graph/network_files/figure-html/unnamed-chunk-6-1.png)

- DrL
A force-directed graph layout toolbox focused on real-world large-scale graphs
![](https://www.data-to-viz.com/graph/network_files/figure-html/unnamed-chunk-7-1.png)

- Randomly
This is what happens if node positions is set up randomly
![](https://www.data-to-viz.com/graph/network_files/figure-html/unnamed-chunk-8-1.png)
