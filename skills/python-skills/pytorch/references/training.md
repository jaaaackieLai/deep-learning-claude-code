# Training Models in PyTorch

This reference covers training loops, optimization, and debugging techniques.

## Basic Training Loop

### Standard Training Pattern

```python
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader

# Setup
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = MyModel().to(device)
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Training function
def train_epoch(model, dataloader, criterion, optimizer, device):
    model.train()  # Set to training mode
    running_loss = 0.0
    correct = 0
    total = 0
    
    for batch_idx, (data, target) in enumerate(dataloader):
        # Move data to device
        data, target = data.to(device), target.to(device)
        
        # Zero gradients
        optimizer.zero_grad()
        
        # Forward pass
        output = model(data)
        loss = criterion(output, target)
        
        # Backward pass
        loss.backward()
        
        # Update weights
        optimizer.step()
        
        # Statistics
        running_loss += loss.item()
        _, predicted = output.max(1)
        total += target.size(0)
        correct += predicted.eq(target).sum().item()
    
    epoch_loss = running_loss / len(dataloader)
    epoch_acc = correct / total
    return epoch_loss, epoch_acc

# Evaluation function
def evaluate(model, dataloader, criterion, device):
    model.eval()  # Set to evaluation mode
    running_loss = 0.0
    correct = 0
    total = 0
    
    with torch.no_grad():  # Disable gradient computation
        for data, target in dataloader:
            data, target = data.to(device), target.to(device)
            
            output = model(data)
            loss = criterion(output, target)
            
            running_loss += loss.item()
            _, predicted = output.max(1)
            total += target.size(0)
            correct += predicted.eq(target).sum().item()
    
    epoch_loss = running_loss / len(dataloader)
    epoch_acc = correct / total
    return epoch_loss, epoch_acc

# Training loop
num_epochs = 10
for epoch in range(num_epochs):
    train_loss, train_acc = train_epoch(model, train_loader, criterion, optimizer, device)
    val_loss, val_acc = evaluate(model, val_loader, criterion, device)
    
    print(f'Epoch {epoch+1}/{num_epochs}')
    print(f'Train Loss: {train_loss:.4f}, Train Acc: {train_acc:.4f}')
    print(f'Val Loss: {val_loss:.4f}, Val Acc: {val_acc:.4f}')
```

## Optimizers

### Common Optimizers

```python
# Stochastic Gradient Descent
optimizer = optim.SGD(model.parameters(), lr=0.01, momentum=0.9, weight_decay=1e-4)

# Adam (adaptive learning rate)
optimizer = optim.Adam(model.parameters(), lr=0.001, betas=(0.9, 0.999), weight_decay=1e-4)

# AdamW (Adam with weight decay fix)
optimizer = optim.AdamW(model.parameters(), lr=0.001, weight_decay=0.01)

# RMSprop
optimizer = optim.RMSprop(model.parameters(), lr=0.01, alpha=0.99)

# Adagrad
optimizer = optim.Adagrad(model.parameters(), lr=0.01)

# Adadelta
optimizer = optim.Adadelta(model.parameters(), lr=1.0, rho=0.9)
```

### Different Learning Rates for Different Layers

```python
# Method 1: Parameter groups
optimizer = optim.SGD([
    {'params': model.backbone.parameters(), 'lr': 1e-4},
    {'params': model.classifier.parameters(), 'lr': 1e-3}
], lr=1e-3, momentum=0.9)

# Method 2: Separate optimizers
optimizer_backbone = optim.Adam(model.backbone.parameters(), lr=1e-4)
optimizer_classifier = optim.Adam(model.classifier.parameters(), lr=1e-3)

# Update both
optimizer_backbone.step()
optimizer_classifier.step()
```

### Optimizer State Management

```python
# Zero gradients
optimizer.zero_grad()

# Access optimizer state
print(optimizer.state_dict())

# Get learning rate
for param_group in optimizer.param_groups:
    print(f"Learning rate: {param_group['lr']}")

# Change learning rate
for param_group in optimizer.param_groups:
    param_group['lr'] = 0.001
```

## Learning Rate Scheduling

### Built-in Schedulers

```python
from torch.optim.lr_scheduler import *

# Step decay
scheduler = StepLR(optimizer, step_size=10, gamma=0.1)
# LR multiplied by 0.1 every 10 epochs

# Multi-step decay
scheduler = MultiStepLR(optimizer, milestones=[30, 80], gamma=0.1)
# LR multiplied by 0.1 at epochs 30 and 80

# Exponential decay
scheduler = ExponentialLR(optimizer, gamma=0.95)
# LR multiplied by 0.95 every epoch

# Cosine annealing
scheduler = CosineAnnealingLR(optimizer, T_max=100, eta_min=1e-6)

# Reduce on plateau
scheduler = ReduceLROnPlateau(optimizer, mode='min', factor=0.1, patience=10)

# Cyclic LR
scheduler = CyclicLR(optimizer, base_lr=0.001, max_lr=0.01, step_size_up=2000)

# One cycle policy (popular for training)
scheduler = OneCycleLR(optimizer, max_lr=0.01, total_steps=len(train_loader) * num_epochs)

# Usage in training loop
for epoch in range(num_epochs):
    train_loss = train_epoch(...)
    val_loss = evaluate(...)
    
    # Step scheduler
    scheduler.step()  # For most schedulers
    # scheduler.step(val_loss)  # For ReduceLROnPlateau
```

### Custom Learning Rate Schedule

```python
# Linear warmup then cosine decay
def get_cosine_schedule_with_warmup(optimizer, num_warmup_steps, num_training_steps):
    def lr_lambda(current_step):
        if current_step < num_warmup_steps:
            return float(current_step) / float(max(1, num_warmup_steps))
        progress = float(current_step - num_warmup_steps) / float(max(1, num_training_steps - num_warmup_steps))
        return max(0.0, 0.5 * (1.0 + math.cos(math.pi * progress)))
    
    return optim.lr_scheduler.LambdaLR(optimizer, lr_lambda)

# Manual learning rate adjustment
def adjust_learning_rate(optimizer, epoch):
    if epoch < 30:
        lr = 0.1
    elif epoch < 60:
        lr = 0.01
    else:
        lr = 0.001
    
    for param_group in optimizer.param_groups:
        param_group['lr'] = lr
```

## Advanced Training Techniques

### Mixed Precision Training

```python
from torch.cuda.amp import autocast, GradScaler

scaler = GradScaler()

for data, target in train_loader:
    data, target = data.to(device), target.to(device)
    
    optimizer.zero_grad()
    
    # Forward pass with autocast
    with autocast():
        output = model(data)
        loss = criterion(output, target)
    
    # Backward pass with scaled loss
    scaler.scale(loss).backward()
    
    # Unscale and step
    scaler.step(optimizer)
    scaler.update()
```

### Gradient Accumulation

```python
accumulation_steps = 4

optimizer.zero_grad()
for i, (data, target) in enumerate(train_loader):
    data, target = data.to(device), target.to(device)
    
    # Forward pass
    output = model(data)
    loss = criterion(output, target)
    
    # Normalize loss (as if we had a larger batch)
    loss = loss / accumulation_steps
    
    # Backward pass
    loss.backward()
    
    # Update weights every accumulation_steps
    if (i + 1) % accumulation_steps == 0:
        optimizer.step()
        optimizer.zero_grad()
```

### Gradient Clipping

```python
# Clip by norm (prevent exploding gradients)
max_norm = 1.0
torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm)

# Clip by value
clip_value = 0.5
torch.nn.utils.clip_grad_value_(model.parameters(), clip_value)

# In training loop
for data, target in train_loader:
    optimizer.zero_grad()
    output = model(data)
    loss = criterion(output, target)
    loss.backward()
    
    # Clip gradients
    torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
    
    optimizer.step()
```

### Early Stopping

```python
class EarlyStopping:
    def __init__(self, patience=7, min_delta=0, mode='min'):
        self.patience = patience
        self.min_delta = min_delta
        self.counter = 0
        self.best_score = None
        self.early_stop = False
        self.mode = mode
    
    def __call__(self, val_loss):
        score = -val_loss if self.mode == 'min' else val_loss
        
        if self.best_score is None:
            self.best_score = score
        elif score < self.best_score + self.min_delta:
            self.counter += 1
            if self.counter >= self.patience:
                self.early_stop = True
        else:
            self.best_score = score
            self.counter = 0

# Usage
early_stopping = EarlyStopping(patience=5)

for epoch in range(num_epochs):
    train_loss = train_epoch(...)
    val_loss = evaluate(...)
    
    early_stopping(val_loss)
    if early_stopping.early_stop:
        print(f"Early stopping at epoch {epoch}")
        break
```

### Model Checkpointing

```python
# Save checkpoint
def save_checkpoint(model, optimizer, epoch, loss, path):
    torch.save({
        'epoch': epoch,
        'model_state_dict': model.state_dict(),
        'optimizer_state_dict': optimizer.state_dict(),
        'loss': loss,
    }, path)

# Load checkpoint
def load_checkpoint(model, optimizer, path):
    checkpoint = torch.load(path)
    model.load_state_dict(checkpoint['model_state_dict'])
    optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
    epoch = checkpoint['epoch']
    loss = checkpoint['loss']
    return epoch, loss

# Save best model
best_val_loss = float('inf')
for epoch in range(num_epochs):
    train_loss = train_epoch(...)
    val_loss = evaluate(...)
    
    if val_loss < best_val_loss:
        best_val_loss = val_loss
        save_checkpoint(model, optimizer, epoch, val_loss, 'best_model.pth')
```

## Memory Management

### Efficient Memory Usage

```python
# Clear unused variables
del large_tensor
torch.cuda.empty_cache()

# Use gradient checkpointing for large models
from torch.utils.checkpoint import checkpoint

class CheckpointedModel(nn.Module):
    def forward(self, x):
        x = checkpoint(self.layer1, x)
        x = checkpoint(self.layer2, x)
        return x

# Reduce precision for inference
model.half()  # Use float16

# Use smaller batch sizes
# Or use gradient accumulation

# Monitor memory
print(f"Allocated: {torch.cuda.memory_allocated() / 1e9:.2f} GB")
print(f"Cached: {torch.cuda.memory_reserved() / 1e9:.2f} GB")
```

### DataLoader Optimization

```python
# Efficient data loading
train_loader = DataLoader(
    dataset,
    batch_size=32,
    shuffle=True,
    num_workers=4,        # Parallel data loading
    pin_memory=True,      # Faster GPU transfer
    persistent_workers=True,  # Keep workers alive
    prefetch_factor=2     # Prefetch batches
)

# Move data asynchronously
for data, target in train_loader:
    data = data.to(device, non_blocking=True)
    target = target.to(device, non_blocking=True)
```

## Debugging

### Check for NaN/Inf

```python
# During training
if torch.isnan(loss):
    print("NaN loss detected!")
    break

# Check gradients
for name, param in model.named_parameters():
    if param.grad is not None:
        if torch.isnan(param.grad).any():
            print(f"NaN gradient in {name}")
        if torch.isinf(param.grad).any():
            print(f"Inf gradient in {name}")
```

### Gradient Flow Visualization

```python
def plot_grad_flow(named_parameters):
    ave_grads = []
    max_grads= []
    layers = []
    
    for n, p in named_parameters:
        if p.requires_grad and p.grad is not None:
            layers.append(n)
            ave_grads.append(p.grad.abs().mean().cpu())
            max_grads.append(p.grad.abs().max().cpu())
    
    plt.figure(figsize=(12, 6))
    plt.bar(np.arange(len(max_grads)), max_grads, alpha=0.5, label="max-gradient")
    plt.bar(np.arange(len(ave_grads)), ave_grads, alpha=0.5, label="mean-gradient")
    plt.hlines(0, 0, len(ave_grads)+1, linewidth=2, color="k")
    plt.xticks(range(0, len(ave_grads), 1), layers, rotation="vertical")
    plt.xlim(left=0, right=len(ave_grads))
    plt.ylim(bottom=-0.001, top=0.02)
    plt.xlabel("Layers")
    plt.ylabel("Gradient")
    plt.title("Gradient Flow")
    plt.legend()
    plt.tight_layout()
    plt.show()

# Use after backward pass
plot_grad_flow(model.named_parameters())
```

### Anomaly Detection

```python
# Enable anomaly detection (slower but catches errors)
torch.autograd.set_detect_anomaly(True)

# Use in specific section
with torch.autograd.set_detect_anomaly(True):
    output = model(input)
    loss = criterion(output, target)
    loss.backward()
```

### Profiling

```python
from torch.profiler import profile, ProfilerActivity

with profile(
    activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA],
    record_shapes=True
) as prof:
    for data, target in train_loader:
        output = model(data.to(device))
        loss = criterion(output, target.to(device))
        loss.backward()
        optimizer.step()

# Print results
print(prof.key_averages().table(sort_by="cuda_time_total", row_limit=10))

# Export for Chrome trace viewer
prof.export_chrome_trace("trace.json")
```

## Metrics and Logging

### Computing Metrics

```python
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

def compute_metrics(predictions, targets):
    predictions = predictions.cpu().numpy()
    targets = targets.cpu().numpy()
    
    accuracy = accuracy_score(targets, predictions)
    precision = precision_score(targets, predictions, average='weighted')
    recall = recall_score(targets, predictions, average='weighted')
    f1 = f1_score(targets, predictions, average='weighted')
    
    return {
        'accuracy': accuracy,
        'precision': precision,
        'recall': recall,
        'f1': f1
    }
```

### TensorBoard Logging

```python
from torch.utils.tensorboard import SummaryWriter

writer = SummaryWriter('runs/experiment_1')

for epoch in range(num_epochs):
    train_loss = train_epoch(...)
    val_loss = evaluate(...)
    
    # Log scalars
    writer.add_scalar('Loss/train', train_loss, epoch)
    writer.add_scalar('Loss/val', val_loss, epoch)
    
    # Log learning rate
    writer.add_scalar('Learning_rate', optimizer.param_groups[0]['lr'], epoch)
    
    # Log histograms
    for name, param in model.named_parameters():
        writer.add_histogram(name, param, epoch)
        if param.grad is not None:
            writer.add_histogram(f'{name}.grad', param.grad, epoch)

writer.close()

# View: tensorboard --logdir=runs
```

### Progress Bars

```python
from tqdm import tqdm

# Training with progress bar
pbar = tqdm(train_loader, desc=f'Epoch {epoch+1}/{num_epochs}')
for data, target in pbar:
    # Training code...
    
    # Update progress bar
    pbar.set_postfix({'loss': loss.item()})
```

## Performance Optimization

### Efficient Training Tips

1. **Use appropriate batch size**: Larger batches = better GPU utilization
2. **Enable cudnn.benchmark**: `torch.backends.cudnn.benchmark = True`
3. **Use DataLoader efficiently**: Set `num_workers` and `pin_memory`
4. **Mixed precision training**: Faster and uses less memory
5. **Gradient accumulation**: Simulate larger batches
6. **Profile your code**: Find bottlenecks

### Benchmark Settings

```python
# Enable cudnn autotuner (first epoch may be slow)
torch.backends.cudnn.benchmark = True

# Disable debugging features in production
torch.autograd.set_detect_anomaly(False)
torch.backends.cudnn.deterministic = False
```

### Compilation (PyTorch 2.0+)

```python
# Compile model for faster execution
compiled_model = torch.compile(model)

# Use as normal
output = compiled_model(input)
```

## Common Training Issues

### Issue: Loss not decreasing
**Solutions:**
- Check learning rate (too high or too low)
- Verify data preprocessing and labels
- Check model architecture
- Try different optimizer
- Add/adjust regularization

### Issue: Overfitting
**Solutions:**
- Add dropout
- Increase weight decay
- Use data augmentation
- Reduce model complexity
- Get more training data
- Use early stopping

### Issue: Underfitting
**Solutions:**
- Increase model capacity
- Train longer
- Reduce regularization
- Check for bugs in model

### Issue: Exploding gradients
**Solutions:**
- Use gradient clipping
- Reduce learning rate
- Use batch normalization
- Check model initialization

### Issue: Vanishing gradients
**Solutions:**
- Use ReLU/LeakyReLU instead of sigmoid/tanh
- Use batch normalization
- Use residual connections
- Check model initialization (He/Xavier)
