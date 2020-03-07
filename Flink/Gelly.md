
## Gelly: Flink Graph API
Gelly is a Graph API for Flink. It contains a set of methods and utilities which aim to simplify the development of graph analysis applications in Flink. In Gelly, graphs can be transformed and modified using high-level functions similar to the ones provided by the batch processing API. Gelly provides methods to create, transform and modify graphs, as well as a library of graph algorithms.

Graph API
- Iterative Graph Processing
- Library Methods
- Graph Algorithms
- Graph Generators
- Bipartite Graphs

https://ci.apache.org/projects/flink/flink-docs-release-1.10/dev/libs/gelly/

###Graph Representation
In Gelly, a Graph is represented by a DataSet of vertices and a DataSet of edges.

The Graph nodes are represented by the Vertex type. A Vertex is defined by a unique ID and a value. Vertex IDs should implement the Comparable interface. Vertices without value can be represented by setting the value type to NullValue.
