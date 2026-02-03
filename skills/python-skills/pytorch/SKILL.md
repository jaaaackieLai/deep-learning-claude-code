---
name: pytorch
description: Comprehensive guide for working with PyTorch, the open-source machine learning framework. Use this skill when working with PyTorch for deep learning tasks including: (1) Building neural networks and models, (2) Working with tensors and GPU computation, (3) Training and optimizing models, (4) Implementing custom layers or loss functions, (5) Data loading and preprocessing, (6) Model deployment and inference, (7) Using autograd for automatic differentiation, (8) Implementing computer vision, NLP, or reinforcement learning projects, (9) Debugging PyTorch code or performance issues, (10) Converting models to/from other frameworks (ONNX, TensorFlow), or any other PyTorch-related development tasks.
---

# PyTorch Development Skill

This skill provides comprehensive guidance for developing with PyTorch, a leading open-source machine learning framework for Python.

## Overview

PyTorch is an optimized tensor library for deep learning using GPUs and CPUs. It provides:
- Dynamic computational graphs (define-by-run)
- Strong GPU acceleration  
- Automatic differentiation (autograd)
- Rich ecosystem of tools and libraries
- Native Python integration

## Quick Start

### Installation

```bash
# CPU only
pip install torch torchvision torchaudio

# CUDA 12.1
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Check installation
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
```

### Basic Example

```python
import torch
import torch.nn as nn
import torch.optim as optim

# Create a simple model
model = nn.Sequential(
    nn.Linear(784, 128),
    nn.ReLU(),
    nn.Linear(128, 10)
)

# Define loss and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Training step
def train_step(data, target):
    optimizer.zero_grad()
    output = model(data)
    loss = criterion(output, target)
    loss.backward()
    optimizer.step()
    return loss.item()
```

## Core Workflows

### 1. Building Models

For detailed guidance on creating neural networks:
- **Basic architectures**: See [references/neural_networks.md](references/neural_networks.md)
- **Custom layers and modules**: See [references/neural_networks.md#custom-modules](references/neural_networks.md)
- **Pre-built models**: See [references/computer_vision.md](references/computer_vision.md) or [references/nlp.md](references/nlp.md)

### 2. Working with Data

For data loading and preprocessing:
- **Dataset and DataLoader**: See [references/data_loading.md](references/data_loading.md)
- **Transforms and augmentation**: See [references/data_loading.md#transforms](references/data_loading.md)
- **Custom datasets**: See [references/data_loading.md#custom-datasets](references/data_loading.md)

### 3. Training Models

For training loops and optimization:
- **Standard training pattern**: See [references/training.md](references/training.md)
- **Optimizers and schedulers**: See [references/training.md#optimizers](references/training.md)
- **Mixed precision training**: See [references/training.md#mixed-precision](references/training.md)
- **Gradient accumulation**: See [references/training.md#gradient-accumulation](references/training.md)

### 4. Understanding Tensors and Autograd

For fundamental PyTorch concepts:
- **Tensor operations**: See [references/basics.md#tensors](references/basics.md)
- **GPU usage**: See [references/basics.md#gpu-operations](references/basics.md)
- **Automatic differentiation**: See [references/basics.md#autograd](references/basics.md)

### 5. Deploying Models

For production deployment:
- **Model saving/loading**: See [references/deployment.md#saving-loading](references/deployment.md)
- **TorchScript**: See [references/deployment.md#torchscript](references/deployment.md)
- **ONNX export**: See [references/deployment.md#onnx](references/deployment.md)
- **TorchServe**: See [references/deployment.md#torchserve](references/deployment.md)

## Domain-Specific Guides

### Computer Vision
For CV tasks (image classification, object detection, segmentation):
- See [references/computer_vision.md](references/computer_vision.md)
- Includes: CNNs, transfer learning, data augmentation, common architectures

### Natural Language Processing
For NLP tasks (text classification, sequence modeling, transformers):
- See [references/nlp.md](references/nlp.md)
- Includes: RNNs, LSTMs, attention, embeddings, tokenization

## Advanced Topics

For advanced features and optimization:
- **Distributed training**: See [references/advanced_topics.md#distributed-training](references/advanced_topics.md)
- **Custom CUDA extensions**: See [references/advanced_topics.md#custom-extensions](references/advanced_topics.md)
- **Model quantization**: See [references/advanced_topics.md#quantization](references/advanced_topics.md)
- **Memory optimization**: See [references/advanced_topics.md#memory-optimization](references/advanced_topics.md)

## Common Patterns

### Transfer Learning
```python
import torchvision.models as models

# Load pretrained model
model = models.resnet50(pretrained=True)

# Freeze base layers
for param in model.parameters():
    param.requires_grad = False

# Replace classifier
model.fc = nn.Linear(model.fc.in_features, num_classes)

# Train only the new layer
optimizer = optim.Adam(model.fc.parameters(), lr=0.001)
```

### GPU Usage
```python
# Check and set device
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Move model and data to device
model = model.to(device)
data = data.to(device)

# Clear GPU cache if needed
torch.cuda.empty_cache()
```

### Reproducibility
```python
import random
import numpy as np

def set_seed(seed=42):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False

set_seed(42)
```

## Debugging and Best Practices

### Check Tensor Properties
```python
print(f"Shape: {tensor.shape}")
print(f"Device: {tensor.device}")
print(f"Dtype: {tensor.dtype}")
print(f"Requires grad: {tensor.requires_grad}")
```

### Common Issues

**Out of Memory (OOM)**
- Reduce batch size
- Use gradient accumulation
- Enable mixed precision training
- See [references/training.md#memory-management](references/training.md)

**Slow Training**
- Use DataLoader with multiple workers
- Enable pin_memory for GPU
- Profile code to identify bottlenecks
- See [references/training.md#performance](references/training.md)

**NaN Loss/Gradients**
- Check learning rate (might be too high)
- Use gradient clipping
- Check for division by zero
- See [references/training.md#debugging](references/training.md)

## Performance Tips

1. **Use DataLoader efficiently**: `num_workers=4`, `pin_memory=True`
2. **Disable gradients for inference**: Use `torch.no_grad()` or `model.eval()`
3. **Use in-place operations**: `tensor.add_(y)`, `tensor.relu_()`
4. **Batch operations**: Vectorize instead of loops
5. **Profile your code**: Use `torch.profiler` to find bottlenecks

## Reference Files

All reference files are in the `references/` directory:

- **[basics.md](references/basics.md)** - Tensors, autograd, GPU operations
- **[neural_networks.md](references/neural_networks.md)** - Building models, layers, custom modules
- **[training.md](references/training.md)** - Training loops, optimization, debugging
- **[data_loading.md](references/data_loading.md)** - Datasets, DataLoaders, transforms
- **[computer_vision.md](references/computer_vision.md)** - CV tasks and architectures
- **[nlp.md](references/nlp.md)** - NLP tasks and architectures
- **[deployment.md](references/deployment.md)** - Production deployment strategies
- **[advanced_topics.md](references/advanced_topics.md)** - Distributed training, quantization, custom ops

## External Resources

- [Official PyTorch Documentation](https://pytorch.org/docs/)
- [PyTorch Tutorials](https://pytorch.org/tutorials/)
- [PyTorch Examples Repository](https://github.com/pytorch/examples)
- [PyTorch Forums](https://discuss.pytorch.org/)
