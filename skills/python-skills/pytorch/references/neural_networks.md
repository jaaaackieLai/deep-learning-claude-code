# Neural Networks in PyTorch

This reference covers building neural networks using PyTorch's `torch.nn` module.

## nn.Module Basics

All neural network modules inherit from `nn.Module`.

### Basic Module Structure

```python
import torch
import torch.nn as nn
import torch.nn.functional as F

class SimpleNet(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(SimpleNet, self).__init__()
        
        # Define layers
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.fc2 = nn.Linear(hidden_size, output_size)
        self.dropout = nn.Dropout(0.5)
    
    def forward(self, x):
        # Define forward pass
        x = F.relu(self.fc1(x))
        x = self.dropout(x)
        x = self.fc2(x)
        return x

# Create model
model = SimpleNet(784, 256, 10)

# Forward pass
input_data = torch.randn(32, 784)  # Batch of 32 samples
output = model(input_data)  # Shape: (32, 10)
```

### Module Properties

```python
# Get all parameters
for name, param in model.named_parameters():
    print(f"{name}: {param.shape}")

# Count parameters
total_params = sum(p.numel() for p in model.parameters())
trainable_params = sum(p.numel() for p in model.parameters() if p.requires_grad)

# Module children
for name, module in model.named_children():
    print(f"{name}: {module}")

# All modules (including nested)
for name, module in model.named_modules():
    print(f"{name}: {module}")

# Move model to device
model = model.to(device)

# Set to training/evaluation mode
model.train()  # Enable dropout, batchnorm training mode
model.eval()   # Disable dropout, batchnorm eval mode
```

## Common Layers

### Linear (Fully Connected)

```python
# Fully connected layer
fc = nn.Linear(in_features=100, out_features=50, bias=True)

# Usage
x = torch.randn(32, 100)  # Batch size 32
out = fc(x)  # Shape: (32, 50)

# Access weights and bias
print(fc.weight.shape)  # (50, 100)
print(fc.bias.shape)    # (50,)
```

### Convolutional Layers

```python
# 2D Convolution
conv2d = nn.Conv2d(
    in_channels=3,      # RGB input
    out_channels=64,    # Number of filters
    kernel_size=3,      # 3x3 kernel
    stride=1,
    padding=1,          # Keep spatial dimensions
    bias=True
)

# Usage
x = torch.randn(32, 3, 224, 224)  # Batch, Channels, Height, Width
out = conv2d(x)  # Shape: (32, 64, 224, 224)

# 1D Convolution (for sequences)
conv1d = nn.Conv1d(
    in_channels=100,
    out_channels=256,
    kernel_size=5,
    padding=2
)

# 3D Convolution (for videos)
conv3d = nn.Conv3d(
    in_channels=3,
    out_channels=64,
    kernel_size=3,
    padding=1
)

# Transposed Convolution (for upsampling)
conv_transpose = nn.ConvTranspose2d(
    in_channels=64,
    out_channels=3,
    kernel_size=4,
    stride=2,
    padding=1
)
```

### Pooling Layers

```python
# Max Pooling
maxpool2d = nn.MaxPool2d(kernel_size=2, stride=2)
x = torch.randn(32, 64, 224, 224)
out = maxpool2d(x)  # Shape: (32, 64, 112, 112)

# Average Pooling
avgpool2d = nn.AvgPool2d(kernel_size=2, stride=2)

# Adaptive Pooling (output size is fixed)
adaptive_avgpool = nn.AdaptiveAvgPool2d((1, 1))  # Output: (32, 64, 1, 1)
adaptive_maxpool = nn.AdaptiveMaxPool2d((7, 7))  # Output: (32, 64, 7, 7)

# Global Average Pooling
gap = nn.AdaptiveAvgPool2d(1)
out = gap(x)  # Shape: (32, 64, 1, 1)
out = out.view(out.size(0), -1)  # Shape: (32, 64)
```

### Normalization Layers

```python
# Batch Normalization
batchnorm1d = nn.BatchNorm1d(num_features=256)
batchnorm2d = nn.BatchNorm2d(num_features=64)
batchnorm3d = nn.BatchNorm3d(num_features=64)

# Layer Normalization
layernorm = nn.LayerNorm(normalized_shape=256)

# Instance Normalization
instancenorm = nn.InstanceNorm2d(num_features=64)

# Group Normalization
groupnorm = nn.GroupNorm(num_groups=32, num_channels=64)

# Usage
x = torch.randn(32, 64, 224, 224)
out = batchnorm2d(x)  # Normalize across batch dimension
```

### Activation Functions

```python
# As modules
relu = nn.ReLU()
leaky_relu = nn.LeakyReLU(negative_slope=0.01)
sigmoid = nn.Sigmoid()
tanh = nn.Tanh()
softmax = nn.Softmax(dim=1)
log_softmax = nn.LogSoftmax(dim=1)
gelu = nn.GELU()
silu = nn.SiLU()  # Swish

# As functions (no parameters to learn)
x = torch.randn(32, 10)
out = F.relu(x)
out = F.leaky_relu(x, negative_slope=0.01)
out = F.sigmoid(x)
out = F.softmax(x, dim=1)
out = F.gelu(x)
```

### Dropout

```python
# Dropout
dropout = nn.Dropout(p=0.5)  # Drop 50% during training
x = torch.randn(32, 256)
out = dropout(x)

# 2D Dropout (for convolutional layers)
dropout2d = nn.Dropout2d(p=0.5)
x = torch.randn(32, 64, 224, 224)
out = dropout2d(x)

# Note: Dropout behaves differently in train vs eval mode
model.train()  # Dropout active
model.eval()   # Dropout inactive
```

### Recurrent Layers

```python
# LSTM
lstm = nn.LSTM(
    input_size=100,
    hidden_size=256,
    num_layers=2,
    batch_first=True,  # Input: (batch, seq, feature)
    dropout=0.5,       # Dropout between layers
    bidirectional=False
)

# Usage
x = torch.randn(32, 10, 100)  # Batch=32, Seq=10, Features=100
output, (hidden, cell) = lstm(x)
# output: (32, 10, 256)
# hidden: (2, 32, 256)  # num_layers * num_directions
# cell: (2, 32, 256)

# GRU
gru = nn.GRU(
    input_size=100,
    hidden_size=256,
    num_layers=2,
    batch_first=True,
    bidirectional=True  # 2x hidden_size output
)

# Bidirectional output size is 2 * hidden_size
output, hidden = gru(x)
# output: (32, 10, 512)  # 2 * 256
# hidden: (4, 32, 256)   # 2 * num_layers

# Simple RNN
rnn = nn.RNN(input_size=100, hidden_size=256, num_layers=2, batch_first=True)
```

### Embedding

```python
# Embedding layer
embedding = nn.Embedding(
    num_embeddings=10000,  # Vocabulary size
    embedding_dim=300      # Embedding dimension
)

# Usage
indices = torch.LongTensor([[1, 2, 3], [4, 5, 6]])  # Batch of sequences
embedded = embedding(indices)  # Shape: (2, 3, 300)

# Load pretrained embeddings
pretrained_weights = torch.randn(10000, 300)
embedding = nn.Embedding.from_pretrained(pretrained_weights, freeze=False)
```

## Sequential Models

### nn.Sequential

For simple sequential architectures:

```python
# Define model
model = nn.Sequential(
    nn.Linear(784, 256),
    nn.ReLU(),
    nn.Dropout(0.5),
    nn.Linear(256, 128),
    nn.ReLU(),
    nn.Linear(128, 10)
)

# Forward pass
x = torch.randn(32, 784)
output = model(x)

# Access layers by index
first_layer = model[0]  # nn.Linear(784, 256)

# Named sequential (better for debugging)
model = nn.Sequential(OrderedDict([
    ('fc1', nn.Linear(784, 256)),
    ('relu1', nn.ReLU()),
    ('dropout', nn.Dropout(0.5)),
    ('fc2', nn.Linear(256, 128)),
    ('relu2', nn.ReLU()),
    ('fc3', nn.Linear(128, 10))
]))

# Access by name
first_layer = model.fc1
```

### nn.ModuleList

For list of modules (useful when number varies):

```python
class MyModule(nn.Module):
    def __init__(self, num_layers):
        super().__init__()
        self.layers = nn.ModuleList([
            nn.Linear(256, 256) for _ in range(num_layers)
        ])
    
    def forward(self, x):
        for layer in self.layers:
            x = F.relu(layer(x))
        return x
```

### nn.ModuleDict

For dictionary of modules:

```python
class MyModule(nn.Module):
    def __init__(self):
        super().__init__()
        self.layers = nn.ModuleDict({
            'conv': nn.Conv2d(3, 64, 3),
            'pool': nn.MaxPool2d(2),
            'fc': nn.Linear(64, 10)
        })
    
    def forward(self, x):
        x = self.layers['conv'](x)
        x = self.layers['pool'](x)
        x = x.view(x.size(0), -1)
        x = self.layers['fc'](x)
        return x
```

## Custom Modules

### Simple Custom Layer

```python
class CustomLinear(nn.Module):
    def __init__(self, in_features, out_features):
        super().__init__()
        self.weight = nn.Parameter(torch.randn(out_features, in_features))
        self.bias = nn.Parameter(torch.randn(out_features))
    
    def forward(self, x):
        return F.linear(x, self.weight, self.bias)

# Usage
layer = CustomLinear(100, 50)
x = torch.randn(32, 100)
out = layer(x)  # Shape: (32, 50)
```

### Residual Block

```python
class ResidualBlock(nn.Module):
    def __init__(self, channels):
        super().__init__()
        self.conv1 = nn.Conv2d(channels, channels, 3, padding=1)
        self.bn1 = nn.BatchNorm2d(channels)
        self.conv2 = nn.Conv2d(channels, channels, 3, padding=1)
        self.bn2 = nn.BatchNorm2d(channels)
    
    def forward(self, x):
        residual = x
        out = F.relu(self.bn1(self.conv1(x)))
        out = self.bn2(self.conv2(out))
        out += residual  # Skip connection
        out = F.relu(out)
        return out
```

### Attention Module

```python
class SelfAttention(nn.Module):
    def __init__(self, embed_dim):
        super().__init__()
        self.query = nn.Linear(embed_dim, embed_dim)
        self.key = nn.Linear(embed_dim, embed_dim)
        self.value = nn.Linear(embed_dim, embed_dim)
        self.scale = embed_dim ** 0.5
    
    def forward(self, x):
        # x: (batch, seq_len, embed_dim)
        Q = self.query(x)
        K = self.key(x)
        V = self.value(x)
        
        # Attention scores
        scores = torch.matmul(Q, K.transpose(-2, -1)) / self.scale
        attn_weights = F.softmax(scores, dim=-1)
        
        # Apply attention to values
        out = torch.matmul(attn_weights, V)
        return out
```

## Weight Initialization

```python
def init_weights(m):
    if isinstance(m, nn.Linear):
        # Xavier initialization
        nn.init.xavier_uniform_(m.weight)
        if m.bias is not None:
            nn.init.zeros_(m.bias)
    elif isinstance(m, nn.Conv2d):
        # Kaiming (He) initialization
        nn.init.kaiming_normal_(m.weight, mode='fan_out', nonlinearity='relu')
        if m.bias is not None:
            nn.init.zeros_(m.bias)
    elif isinstance(m, nn.BatchNorm2d):
        nn.init.ones_(m.weight)
        nn.init.zeros_(m.bias)

# Apply to model
model.apply(init_weights)

# Manual initialization
for m in model.modules():
    if isinstance(m, nn.Linear):
        nn.init.normal_(m.weight, mean=0, std=0.01)
        nn.init.constant_(m.bias, 0)
```

### Common Initialization Methods

```python
# Uniform
nn.init.uniform_(tensor, a=0, b=1)

# Normal
nn.init.normal_(tensor, mean=0, std=1)

# Constant
nn.init.constant_(tensor, val=0)

# Ones and Zeros
nn.init.ones_(tensor)
nn.init.zeros_(tensor)

# Xavier (Glorot)
nn.init.xavier_uniform_(tensor, gain=1.0)
nn.init.xavier_normal_(tensor, gain=1.0)

# Kaiming (He)
nn.init.kaiming_uniform_(tensor, a=0, mode='fan_in', nonlinearity='leaky_relu')
nn.init.kaiming_normal_(tensor, a=0, mode='fan_in', nonlinearity='relu')

# Orthogonal
nn.init.orthogonal_(tensor, gain=1)
```

## Loss Functions

```python
# Classification
criterion = nn.CrossEntropyLoss()  # Includes softmax
criterion = nn.NLLLoss()            # Negative log likelihood
criterion = nn.BCELoss()            # Binary cross entropy
criterion = nn.BCEWithLogitsLoss()  # BCE with sigmoid

# Regression
criterion = nn.MSELoss()            # Mean squared error
criterion = nn.L1Loss()             # Mean absolute error
criterion = nn.SmoothL1Loss()       # Huber loss

# Other
criterion = nn.KLDivLoss()          # KL divergence
criterion = nn.CosineEmbeddingLoss()
criterion = nn.TripletMarginLoss()

# Usage
output = model(input_data)
target = torch.randint(0, 10, (32,))  # Class indices for CrossEntropyLoss
loss = criterion(output, target)

# Weighted loss
weights = torch.tensor([1.0, 2.0, 3.0, ...])
criterion = nn.CrossEntropyLoss(weight=weights)

# Custom loss
class CustomLoss(nn.Module):
    def __init__(self):
        super().__init__()
    
    def forward(self, predictions, targets):
        loss = ((predictions - targets) ** 2).mean()
        return loss
```

## Model Utilities

### Freezing Layers

```python
# Freeze all parameters
for param in model.parameters():
    param.requires_grad = False

# Freeze specific layers
for param in model.conv_layers.parameters():
    param.requires_grad = False

# Freeze by name
for name, param in model.named_parameters():
    if 'conv' in name:
        param.requires_grad = False

# Check frozen parameters
trainable_params = [p for p in model.parameters() if p.requires_grad]
frozen_params = [p for p in model.parameters() if not p.requires_grad]
```

### Model Surgery

```python
# Replace a layer
model.fc = nn.Linear(model.fc.in_features, num_classes)

# Remove a layer
model.dropout = nn.Identity()  # No-op layer

# Add a layer
model.extra_fc = nn.Linear(256, 128)

# Access nested modules
model.backbone.layer4[0].conv1 = nn.Conv2d(...)
```

### Model Copying

```python
import copy

# Deep copy
model_copy = copy.deepcopy(model)

# Copy state dict
new_model = MyModel()
new_model.load_state_dict(model.state_dict())

# Copy specific layers
new_model.conv1.load_state_dict(model.conv1.state_dict())
```

## Debugging Neural Networks

### Check Layer Outputs

```python
# Hook to capture intermediate outputs
outputs = {}

def hook_fn(name):
    def hook(module, input, output):
        outputs[name] = output
    return hook

# Register hooks
model.conv1.register_forward_hook(hook_fn('conv1'))
model.fc1.register_forward_hook(hook_fn('fc1'))

# Forward pass
output = model(input_data)

# Check intermediate outputs
print(outputs['conv1'].shape)
print(outputs['fc1'].shape)
```

### Gradient Flow

```python
# Check gradients
for name, param in model.named_parameters():
    if param.grad is not None:
        print(f"{name}: grad norm = {param.grad.norm()}")
    else:
        print(f"{name}: no gradient")
```

### Model Summary

```python
def model_summary(model, input_size):
    def register_hook(module):
        def hook(module, input, output):
            class_name = str(module.__class__).split(".")[-1].split("'")[0]
            module_idx = len(summary)
            
            m_key = f"{class_name}-{module_idx + 1}"
            summary[m_key] = {}
            summary[m_key]["input_shape"] = list(input[0].size())
            summary[m_key]["output_shape"] = list(output.size())
            
            params = 0
            if hasattr(module, "weight") and module.weight is not None:
                params += torch.prod(torch.LongTensor(list(module.weight.size())))
            if hasattr(module, "bias") and module.bias is not None:
                params += torch.prod(torch.LongTensor(list(module.bias.size())))
            summary[m_key]["nb_params"] = params
        
        if not isinstance(module, nn.Sequential) and \
           not isinstance(module, nn.ModuleList):
            hooks.append(module.register_forward_hook(hook))
    
    summary = {}
    hooks = []
    
    model.apply(register_hook)
    
    x = torch.zeros(1, *input_size)
    model(x)
    
    for h in hooks:
        h.remove()
    
    return summary
```
