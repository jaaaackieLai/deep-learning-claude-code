# PyTorch Basics

This reference covers fundamental PyTorch concepts: tensors and automatic differentiation.

## Tensors

Tensors are the fundamental data structure in PyTorch, similar to NumPy arrays but with GPU support and gradient tracking.

### Creating Tensors

```python
import torch
import numpy as np

# From Python lists
x = torch.tensor([1, 2, 3])
x = torch.tensor([[1, 2], [3, 4]], dtype=torch.float32)

# Common initializations
zeros = torch.zeros(2, 3)
ones = torch.ones(2, 3)
rand = torch.rand(2, 3)  # Uniform [0, 1)
randn = torch.randn(2, 3)  # Normal distribution N(0, 1)
empty = torch.empty(2, 3)  # Uninitialized
eye = torch.eye(3)  # Identity matrix

# Create with specific values
full = torch.full((2, 3), 3.14)
arange = torch.arange(0, 10, 2)  # [0, 2, 4, 6, 8]
linspace = torch.linspace(0, 1, 5)  # [0.0, 0.25, 0.5, 0.75, 1.0]

# From NumPy
numpy_array = np.array([[1, 2], [3, 4]])
tensor_from_numpy = torch.from_numpy(numpy_array)

# Like another tensor (same shape/dtype)
x = torch.randn(2, 3)
zeros_like = torch.zeros_like(x)
ones_like = torch.ones_like(x)
```

### Data Types

```python
# Common dtypes
torch.float32  # or torch.float (default for floats)
torch.float64  # or torch.double
torch.float16  # or torch.half
torch.int32    # or torch.int
torch.int64    # or torch.long (default for integers)
torch.bool

# Create with specific dtype
x = torch.tensor([1, 2, 3], dtype=torch.float32)

# Convert dtype
x_int = x.to(torch.int32)
x_float = x.float()  # Shortcut for .to(torch.float32)
x_long = x.long()    # Shortcut for .to(torch.int64)
```

### Tensor Properties

```python
x = torch.randn(2, 3, 4)

print(x.shape)          # torch.Size([2, 3, 4])
print(x.size())         # Same as .shape
print(x.dtype)          # torch.float32
print(x.device)         # cpu or cuda:0
print(x.requires_grad)  # False (by default)
print(x.ndim)           # 3 (number of dimensions)
print(x.numel())        # 24 (total number of elements)
```

### Basic Operations

```python
a = torch.randn(2, 3)
b = torch.randn(2, 3)

# Element-wise operations
c = a + b           # Addition
c = a - b           # Subtraction
c = a * b           # Multiplication
c = a / b           # Division
c = a ** 2          # Power
c = torch.sqrt(a)   # Square root
c = torch.exp(a)    # Exponential
c = torch.log(a)    # Natural logarithm

# In-place operations (modify tensor directly)
a.add_(b)   # a = a + b
a.mul_(2)   # a = a * 2
a.sqrt_()   # a = sqrt(a)

# Comparison operations
c = a > b           # Element-wise comparison
c = torch.eq(a, b)  # Element-wise equality
c = a.eq(b)         # Same as above

# Reduction operations
total = a.sum()
mean = a.mean()
max_val = a.max()
min_val = a.min()
std_val = a.std()

# Reduction along specific dimension
sum_dim0 = a.sum(dim=0)     # Sum along dimension 0
mean_dim1 = a.mean(dim=1)   # Mean along dimension 1
max_dim0 = a.max(dim=0)     # Returns (values, indices)
```

### Matrix Operations

```python
a = torch.randn(2, 3)
b = torch.randn(3, 4)

# Matrix multiplication
c = torch.matmul(a, b)  # Shape: (2, 4)
c = a @ b               # Same as matmul

# Batch matrix multiplication
a = torch.randn(10, 2, 3)
b = torch.randn(10, 3, 4)
c = torch.bmm(a, b)  # Shape: (10, 2, 4)

# Dot product (1D tensors)
a = torch.tensor([1, 2, 3])
b = torch.tensor([4, 5, 6])
c = torch.dot(a, b)  # Scalar: 32

# Transpose
a = torch.randn(2, 3)
b = a.t()        # Shape: (3, 2)
b = a.T          # Same as .t()

# Transpose specific dimensions
a = torch.randn(2, 3, 4)
b = a.transpose(0, 1)  # Swap dim 0 and 1: (3, 2, 4)
b = a.permute(2, 0, 1) # Reorder to: (4, 2, 3)
```

### Reshaping and Indexing

```python
# Reshape
x = torch.randn(4, 4)
y = x.view(16)         # Flatten (must be contiguous)
y = x.view(2, 8)       # Reshape
y = x.view(-1)         # Flatten (infer size)
y = x.reshape(2, 8)    # Like view but handles non-contiguous

# Squeeze and unsqueeze
x = torch.randn(1, 3, 1, 4)
y = x.squeeze()        # Remove all dims of size 1: (3, 4)
y = x.squeeze(0)       # Remove specific dim: (3, 1, 4)
y = x.unsqueeze(1)     # Add dim at position: (1, 1, 3, 1, 4)

# Indexing
x = torch.randn(4, 4)
y = x[0, :]         # First row
y = x[:, 0]         # First column
y = x[1:3, 1:3]     # Submatrix
y = x[[0, 2], :]    # Select rows 0 and 2
y = x[:, [1, 3]]    # Select columns 1 and 3

# Boolean indexing
mask = x > 0
y = x[mask]         # Select elements > 0

# Advanced indexing
indices = torch.tensor([0, 2])
y = x[indices]      # Select rows by indices
```

### Concatenation and Stacking

```python
a = torch.randn(2, 3)
b = torch.randn(2, 3)

# Concatenate along existing dimension
c = torch.cat([a, b], dim=0)  # Shape: (4, 3)
c = torch.cat([a, b], dim=1)  # Shape: (2, 6)

# Stack creates new dimension
c = torch.stack([a, b], dim=0)  # Shape: (2, 2, 3)
c = torch.stack([a, b], dim=1)  # Shape: (2, 2, 3)

# Split tensor
a = torch.randn(6, 4)
chunks = torch.chunk(a, 3, dim=0)  # Split into 3 chunks: [(2,4), (2,4), (2,4)]
splits = torch.split(a, 2, dim=0)   # Split with size 2: [(2,4), (2,4), (2,4)]
splits = torch.split(a, [1, 2, 3], dim=0)  # Variable sizes: [(1,4), (2,4), (3,4)]
```

## GPU Operations

PyTorch tensors can leverage GPU acceleration for faster computation.

### Device Management

```python
# Check CUDA availability
print(torch.cuda.is_available())
print(torch.cuda.device_count())
print(torch.cuda.get_device_name(0))

# Create device object
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
device = torch.device("cuda:0")  # Specific GPU
device = torch.device("cpu")

# Current device
current_device = torch.cuda.current_device()
```

### Moving Tensors to GPU

```python
# Create tensor on CPU
x = torch.randn(3, 3)

# Move to GPU
x_gpu = x.to(device)
x_gpu = x.cuda()           # Move to default GPU
x_gpu = x.cuda(0)          # Move to GPU 0

# Create directly on GPU
x_gpu = torch.randn(3, 3, device=device)
x_gpu = torch.randn(3, 3, device='cuda')

# Move back to CPU
x_cpu = x_gpu.to('cpu')
x_cpu = x_gpu.cpu()

# Non-blocking transfer (async)
x_gpu = x.to(device, non_blocking=True)
```

### Memory Management

```python
# Check memory usage
print(torch.cuda.memory_allocated())    # Currently allocated
print(torch.cuda.memory_reserved())     # Reserved by caching allocator
print(torch.cuda.max_memory_allocated()) # Peak usage

# Clear cache
torch.cuda.empty_cache()

# Memory summary
print(torch.cuda.memory_summary())
```

## Autograd (Automatic Differentiation)

PyTorch's autograd package automatically computes gradients for tensor operations.

### Basic Gradient Computation

```python
# Create tensor with gradient tracking
x = torch.tensor([2.0, 3.0], requires_grad=True)

# Forward pass
y = x ** 2
z = y.sum()

# Backward pass (compute gradients)
z.backward()

# Access gradients
print(x.grad)  # dz/dx = [4.0, 6.0]

# Note: gradients accumulate by default
z.backward()
print(x.grad)  # [8.0, 12.0] (doubled)

# Zero gradients before next backward pass
x.grad.zero_()
```

### Gradient Control

```python
# Disable gradient tracking
x = torch.randn(3, 3)
y = torch.randn(3, 3, requires_grad=True)

# Context manager (temporary)
with torch.no_grad():
    z = x + y  # z.requires_grad = False

# Permanently detach
z = y.detach()  # z.requires_grad = False

# Enable/disable for specific tensor
x.requires_grad_(True)   # Enable
x.requires_grad_(False)  # Disable
```

### Gradient for Non-Scalar Output

```python
x = torch.tensor([1.0, 2.0, 3.0], requires_grad=True)
y = x ** 2  # y is a vector, not scalar

# Need to provide gradient argument
grad_output = torch.tensor([1.0, 1.0, 1.0])
y.backward(gradient=grad_output)
print(x.grad)  # [2.0, 4.0, 6.0]

# For scalar output, no gradient argument needed
z = y.sum()
x.grad.zero_()
z.backward()
print(x.grad)  # [2.0, 4.0, 6.0]
```

### Computational Graph

```python
# PyTorch builds a dynamic computational graph
x = torch.tensor([2.0], requires_grad=True)
y = x + 2        # y = x + 2
z = y * y * 3    # z = 3(x + 2)^2
out = z.mean()   # out = 3(x + 2)^2

# The graph is built during forward pass
# and destroyed after backward pass
out.backward()
print(x.grad)

# Graph is destroyed after backward
# Calling backward again will raise error
# out.backward()  # RuntimeError

# To retain graph for multiple backwards
out.backward(retain_graph=True)
out.backward()  # Now works
```

### Excluding Operations from Gradient

```python
x = torch.tensor([1.0, 2.0, 3.0], requires_grad=True)

# Detach from graph
y = x.detach()
z = y ** 2  # This operation not tracked

# Using no_grad
with torch.no_grad():
    z = x ** 2  # Not tracked

# Using torch.no_grad() as decorator
@torch.no_grad()
def inference(model, x):
    return model(x)
```

### Custom Autograd Functions

For operations that need custom gradient computation:

```python
class MyReLU(torch.autograd.Function):
    @staticmethod
    def forward(ctx, input):
        # Save for backward
        ctx.save_for_backward(input)
        return input.clamp(min=0)
    
    @staticmethod
    def backward(ctx, grad_output):
        input, = ctx.saved_tensors
        grad_input = grad_output.clone()
        grad_input[input < 0] = 0
        return grad_input

# Use the function
x = torch.randn(3, 3, requires_grad=True)
y = MyReLU.apply(x)
y.sum().backward()
```

### Gradient Checking

```python
# Check for NaN or Inf
x = torch.tensor([1.0, 2.0], requires_grad=True)
y = x ** 2
y.sum().backward()

if torch.isnan(x.grad).any():
    print("NaN gradient detected")

if torch.isinf(x.grad).any():
    print("Inf gradient detected")

# Enable anomaly detection (slower but useful for debugging)
with torch.autograd.set_detect_anomaly(True):
    y = x ** 2
    y.sum().backward()
```

### Gradient Accumulation

```python
# Gradients accumulate by default
x = torch.tensor([1.0, 2.0], requires_grad=True)

for i in range(3):
    y = (x ** 2).sum()
    y.backward()
    print(x.grad)  # Gradients keep accumulating

# Always zero gradients before backward if you don't want accumulation
x.grad.zero_()
y.backward()
```

## Converting Between PyTorch and NumPy

```python
# NumPy to PyTorch
numpy_array = np.array([[1, 2], [3, 4]])
tensor = torch.from_numpy(numpy_array)

# PyTorch to NumPy (shares memory if on CPU)
numpy_array = tensor.numpy()

# For GPU tensors, move to CPU first
tensor_gpu = tensor.cuda()
numpy_array = tensor_gpu.cpu().numpy()

# Warning: Changing one will change the other (shared memory)
tensor = torch.from_numpy(numpy_array)
tensor[0, 0] = 100
print(numpy_array[0, 0])  # Also 100!

# To avoid sharing memory, use .clone()
tensor = torch.from_numpy(numpy_array).clone()
```

## Performance Tips

### Use Appropriate Data Types

```python
# float32 is usually enough (float64 is slower and uses more memory)
x = torch.randn(1000, 1000, dtype=torch.float32)

# Use half precision for inference (if supported)
x = x.half()  # torch.float16
```

### Vectorize Operations

```python
# Bad: Python loop
result = []
for i in range(len(x)):
    result.append(x[i] ** 2)
result = torch.stack(result)

# Good: Vectorized
result = x ** 2
```

### In-place Operations

```python
# Creates new tensor
x = x + 1

# In-place (saves memory)
x.add_(1)
```

### Contiguous Tensors

```python
# Some operations require contiguous tensors
x = torch.randn(3, 4).t()
print(x.is_contiguous())  # False

# Make contiguous
x = x.contiguous()
print(x.is_contiguous())  # True
```
