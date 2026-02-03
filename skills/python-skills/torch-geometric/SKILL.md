---
name: torch-geometric
description: Use when working with Graph Neural Networks (GNNs), node or graph classification, link prediction, molecular property prediction, social network analysis, citation networks, 3D geometric data (point clouds, meshes), heterogeneous graphs, or implementing GCN, GAT, GraphSAGE architectures
---

# PyTorch Geometric (PyG)

Library built on PyTorch for developing and training Graph Neural Networks (GNNs) on graphs and irregular structures.

## When to Use

- Graph-based machine learning (node/graph classification, link prediction)
- Molecular property prediction, drug discovery
- Social network analysis, community detection
- Citation networks, paper classification
- 3D geometric data (point clouds, meshes, molecular structures)
- Heterogeneous graphs (multi-type nodes and edges)
- Large-scale graph learning with neighbor sampling

## Quick Start

```python
import torch
from torch_geometric.data import Data
from torch_geometric.datasets import Planetoid
from torch_geometric.nn import GCNConv
import torch.nn.functional as F

# Load dataset
dataset = Planetoid(root='/tmp/Cora', name='Cora')
data = dataset[0]

# Define model
class GCN(torch.nn.Module):
    def __init__(self, num_features, num_classes):
        super().__init__()
        self.conv1 = GCNConv(num_features, 16)
        self.conv2 = GCNConv(16, num_classes)

    def forward(self, data):
        x, edge_index = data.x, data.edge_index
        x = self.conv1(x, edge_index)
        x = F.relu(x)
        x = F.dropout(x, training=self.training)
        x = self.conv2(x, edge_index)
        return F.log_softmax(x, dim=1)

# Train
model = GCN(dataset.num_features, dataset.num_classes)
optimizer = torch.optim.Adam(model.parameters(), lr=0.01)

model.train()
for epoch in range(200):
    optimizer.zero_grad()
    out = model(data)
    loss = F.nll_loss(out[data.train_mask], data.y[data.train_mask])
    loss.backward()
    optimizer.step()
```

## Core Concepts

### Data Structure
Graphs represented using `Data` class:
- **`data.x`** - Node features `[num_nodes, num_features]`
- **`data.edge_index`** - Connectivity in COO format `[2, num_edges]`
- **`data.edge_attr`** - Edge features (optional)
- **`data.y`** - Target labels
- **`data.pos`** - Node positions (optional)

### Edge Index Format
```python
# (0→1), (1→0), (1→2), (2→1)
edge_index = torch.tensor([[0, 1, 1, 2],
                           [1, 0, 2, 1]], dtype=torch.long)
```

### Mini-Batch Processing
PyG batches graphs by creating block-diagonal adjacency matrices.
```python
from torch_geometric.loader import DataLoader

loader = DataLoader(dataset, batch_size=32, shuffle=True)
for batch in loader:
    # batch.batch maps nodes to source graph
    pass
```

## GNN Layers

### Pre-Built Layers (40+)
- **GCNConv** - Graph Convolutional Network
- **GATConv** - Graph Attention Network
- **SAGEConv** - GraphSAGE
- **GINConv** - Graph Isomorphism Network
- **TransformerConv** - Graph Transformer

**Reference:** `references/layers_reference.md`

### Custom Message Passing
```python
from torch_geometric.nn import MessagePassing

class CustomConv(MessagePassing):
    def __init__(self, in_channels, out_channels):
        super().__init__(aggr='add')  # "add", "mean", or "max"
        self.lin = torch.nn.Linear(in_channels, out_channels)

    def forward(self, x, edge_index):
        x = self.lin(x)
        return self.propagate(edge_index, x=x)

    def message(self, x_j):
        return x_j  # x_j: features of source nodes
```

## Working with Datasets

### Built-in Datasets
```python
# Citation networks
from torch_geometric.datasets import Planetoid
dataset = Planetoid(root='/tmp/Cora', name='Cora')

# Graph classification
from torch_geometric.datasets import TUDataset
dataset = TUDataset(root='/tmp/ENZYMES', name='ENZYMES')

# Molecular datasets
from torch_geometric.datasets import QM9
dataset = QM9(root='/tmp/QM9')
```

**Reference:** `references/datasets_reference.md`

### Custom Datasets
Inherit from `InMemoryDataset` for small datasets or `Dataset` for large ones.

### Loading from CSV
```python
import pandas as pd
nodes_df = pd.read_csv('nodes.csv')
edges_df = pd.read_csv('edges.csv')

x = torch.tensor(nodes_df[['feat1', 'feat2']].values, dtype=torch.float)
edge_index = torch.tensor([edges_df['source'].values,
                           edges_df['target'].values], dtype=torch.long)
data = Data(x=x, edge_index=edge_index)
```

## Training Workflows

### Node Classification
```python
model.train()
for epoch in range(200):
    optimizer.zero_grad()
    out = model(data)
    loss = F.nll_loss(out[data.train_mask], data.y[data.train_mask])
    loss.backward()
    optimizer.step()
```

### Graph Classification
```python
from torch_geometric.nn import global_mean_pool

class GraphClassifier(torch.nn.Module):
    def forward(self, data):
        x, edge_index, batch = data.x, data.edge_index, data.batch
        x = self.conv1(x, edge_index)
        x = F.relu(x)
        x = global_mean_pool(x, batch)  # Aggregate to graph-level
        return F.log_softmax(self.lin(x), dim=1)
```

### Large Graphs with Neighbor Sampling
```python
from torch_geometric.loader import NeighborLoader

train_loader = NeighborLoader(
    data,
    num_neighbors=[25, 10],  # Sample 25 for 1st hop, 10 for 2nd
    batch_size=128,
    input_nodes=data.train_mask,
)
```

## Advanced Features

### Heterogeneous Graphs
```python
from torch_geometric.data import HeteroData
from torch_geometric.nn import to_hetero

data = HeteroData()
data['paper'].x = torch.randn(100, 128)
data['author'].x = torch.randn(200, 64)
data['author', 'writes', 'paper'].edge_index = torch.randint(0, 200, (2, 500))

# Convert homogeneous model
model = to_hetero(model, data.metadata(), aggr='sum')
```

### Transforms
```python
from torch_geometric.transforms import NormalizeFeatures, AddSelfLoops, Compose

transform = Compose([AddSelfLoops(), NormalizeFeatures()])
dataset = Planetoid(root='/tmp/Cora', name='Cora', transform=transform)
```

**Reference:** `references/transforms_reference.md`

## Scripts

- **`visualize_graph.py`** - Visualize graph structure
- **`create_gnn_template.py`** - Generate GNN boilerplate
- **`benchmark_model.py`** - Benchmark on standard datasets

## References

- **`layers_reference.md`** - All 40+ GNN layers
- **`datasets_reference.md`** - Dataset catalog
- **`transforms_reference.md`** - Available transforms
