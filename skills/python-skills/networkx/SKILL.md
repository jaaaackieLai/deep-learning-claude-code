---
name: networkx
description: Use when working with network or graph data structures, analyzing relationships between entities, computing graph algorithms (shortest paths, centrality, clustering), detecting communities, generating synthetic networks, visualizing network topologies, or working with social networks, biological networks, transportation systems, or citation networks
---

# NetworkX

NetworkX is a Python package for creating, manipulating, and analyzing complex networks and graphs.

## When to Use

- Creating graphs from data, adding nodes and edges with attributes
- Graph analysis (centrality, shortest paths, communities, clustering)
- Graph algorithms (Dijkstra's, PageRank, minimum spanning trees, maximum flow)
- Generating synthetic networks (random, scale-free, small-world models)
- Reading/writing graphs (edge lists, GraphML, JSON, CSV, adjacency matrices)
- Visualizing networks with matplotlib or interactive libraries
- Network comparison (isomorphism, graph metrics, structural properties)

## Quick Start

```python
import networkx as nx
import matplotlib.pyplot as plt

# Create graph
G = nx.Graph()
G.add_edges_from([(1, 2), (2, 3), (3, 4), (4, 1), (1, 3)])

# Analyze
degree_cent = nx.degree_centrality(G)
communities = nx.community.greedy_modularity_communities(G)

# Visualize
pos = nx.spring_layout(G, seed=42)
nx.draw(G, pos=pos, with_labels=True, node_color='lightblue', node_size=500)
plt.show()
```

## Graph Types

- **Graph** - Undirected graphs
- **DiGraph** - Directed graphs
- **MultiGraph** - Multiple edges between nodes
- **MultiDiGraph** - Directed with multiple edges

## Core Capabilities

### 1. Graph Creation
```python
G = nx.Graph()
G.add_node(1, type='enzyme')
G.add_edge(1, 2, weight=0.8)
```

**Reference:** `references/graph-basics.md`

### 2. Algorithms
```python
# Shortest paths
path = nx.shortest_path(G, source=1, target=5)

# Centrality
pagerank = nx.pagerank(G)
betweenness = nx.betweenness_centrality(G)

# Communities
communities = nx.community.greedy_modularity_communities(G)
```

**Reference:** `references/algorithms.md`

### 3. Graph Generators
```python
# Random networks
G = nx.erdos_renyi_graph(n=100, p=0.1, seed=42)
G = nx.barabasi_albert_graph(n=100, m=3, seed=42)
G = nx.watts_strogatz_graph(n=100, k=6, p=0.1, seed=42)

# Classic graphs
G = nx.complete_graph(n=10)
G = nx.karate_club_graph()
```

**Reference:** `references/generators.md`

### 4. I/O Operations
```python
# File formats
G = nx.read_edgelist('graph.edgelist')
nx.write_graphml(G, 'graph.graphml')

# Pandas integration
G = nx.from_pandas_edgelist(df, 'source', 'target', edge_attr='weight')
df = nx.to_pandas_edgelist(G)

# Matrix formats
A = nx.to_numpy_array(G)
G = nx.from_numpy_array(A)
```

**Reference:** `references/io.md`

### 5. Visualization
```python
pos = nx.spring_layout(G, seed=42)
node_colors = [G.degree(n) for n in G.nodes()]
nx.draw(G, pos=pos, node_color=node_colors, cmap=plt.cm.viridis)
```

**Reference:** `references/visualization.md`

## Common Workflow

1. **Create or load graph** - From data or file
2. **Examine structure** - Node/edge counts, density, connectivity
3. **Analyze** - Compute metrics, find paths, detect communities
4. **Visualize** - Create layouts, customize appearance
5. **Export** - Save graph and metrics

## Quick Reference

### Basic Operations
```python
G.number_of_nodes()
G.number_of_edges()
G.degree(node)
list(G.neighbors(node))
G.has_edge(u, v)
nx.is_connected(G)
```

### Essential Algorithms
```python
nx.shortest_path(G, source, target)
nx.degree_centrality(G)
nx.betweenness_centrality(G)
nx.pagerank(G)
nx.clustering(G)
nx.connected_components(G)
nx.community.greedy_modularity_communities(G)
```

### File I/O
```python
nx.read_edgelist('file.txt')
nx.write_graphml(G, 'file.graphml')
nx.from_pandas_edgelist(df, 'source', 'target')
```

## Best Practices

- Use meaningful node identifiers
- Set random seeds for reproducibility
- Use appropriate data structures for large sparse graphs
- Close figures explicitly with `plt.close(fig)`
- Consider approximate algorithms for very large networks

## References

- **`references/graph-basics.md`** - Graph types, attributes, subgraphs
- **`references/algorithms.md`** - All algorithms (paths, centrality, communities)
- **`references/generators.md`** - Graph generators and network models
- **`references/io.md`** - File formats and data integration
- **`references/visualization.md`** - Layouts, customization, interactive plots
