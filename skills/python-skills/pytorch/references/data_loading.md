# Data Loading in PyTorch

This reference covers Dataset, DataLoader, and data preprocessing techniques.

## Dataset and DataLoader

### Built-in Datasets

```python
from torchvision import datasets, transforms

# MNIST
train_dataset = datasets.MNIST(
    root='./data',
    train=True,
    download=True,
    transform=transforms.ToTensor()
)

# CIFAR-10
train_dataset = datasets.CIFAR10(
    root='./data',
    train=True,
    download=True,
    transform=transforms.ToTensor()
)

# ImageNet
train_dataset = datasets.ImageNet(
    root='./data/imagenet',
    split='train',
    transform=transforms.ToTensor()
)

# Fashion-MNIST
train_dataset = datasets.FashionMNIST(root='./data', train=True, download=True)

# COCO
train_dataset = datasets.CocoDetection(root='./data/coco', annFile='annotations.json')
```

### Custom Dataset

```python
from torch.utils.data import Dataset, DataLoader
import torch

class CustomDataset(Dataset):
    def __init__(self, data, labels, transform=None):
        """
        Args:
            data: List or array of data samples
            labels: List or array of labels
            transform: Optional transform to be applied on a sample
        """
        self.data = data
        self.labels = labels
        self.transform = transform
    
    def __len__(self):
        """Return the total number of samples"""
        return len(self.data)
    
    def __getitem__(self, idx):
        """Get a sample at given index"""
        sample = self.data[idx]
        label = self.labels[idx]
        
        if self.transform:
            sample = self.transform(sample)
        
        return sample, label

# Usage
dataset = CustomDataset(data, labels, transform=transforms.ToTensor())
```

### Image Dataset from Folder

```python
from PIL import Image
import os

class ImageFolderDataset(Dataset):
    def __init__(self, root_dir, transform=None):
        """
        Args:
            root_dir: Directory with subdirectories for each class
            transform: Optional transform
        Structure:
            root_dir/
                class1/
                    img1.jpg
                    img2.jpg
                class2/
                    img3.jpg
        """
        self.root_dir = root_dir
        self.transform = transform
        self.classes = sorted(os.listdir(root_dir))
        self.class_to_idx = {cls: idx for idx, cls in enumerate(self.classes)}
        
        self.images = []
        self.labels = []
        
        for class_name in self.classes:
            class_dir = os.path.join(root_dir, class_name)
            if os.path.isdir(class_dir):
                for img_name in os.listdir(class_dir):
                    img_path = os.path.join(class_dir, img_name)
                    self.images.append(img_path)
                    self.labels.append(self.class_to_idx[class_name])
    
    def __len__(self):
        return len(self.images)
    
    def __getitem__(self, idx):
        img_path = self.images[idx]
        label = self.labels[idx]
        
        image = Image.open(img_path).convert('RGB')
        
        if self.transform:
            image = self.transform(image)
        
        return image, label

# Or use built-in ImageFolder
from torchvision.datasets import ImageFolder
dataset = ImageFolder(root='./data', transform=transforms.ToTensor())
```

### Text Dataset

```python
class TextDataset(Dataset):
    def __init__(self, texts, labels, tokenizer, max_length=512):
        self.texts = texts
        self.labels = labels
        self.tokenizer = tokenizer
        self.max_length = max_length
    
    def __len__(self):
        return len(self.texts)
    
    def __getitem__(self, idx):
        text = self.texts[idx]
        label = self.labels[idx]
        
        # Tokenize
        encoding = self.tokenizer(
            text,
            max_length=self.max_length,
            padding='max_length',
            truncation=True,
            return_tensors='pt'
        )
        
        return {
            'input_ids': encoding['input_ids'].squeeze(),
            'attention_mask': encoding['attention_mask'].squeeze(),
            'label': torch.tensor(label)
        }
```

### CSV Dataset

```python
import pandas as pd

class CSVDataset(Dataset):
    def __init__(self, csv_file, transform=None):
        self.data = pd.read_csv(csv_file)
        self.transform = transform
    
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        # Assuming last column is label
        features = self.data.iloc[idx, :-1].values.astype('float32')
        label = self.data.iloc[idx, -1]
        
        sample = torch.from_numpy(features)
        
        if self.transform:
            sample = self.transform(sample)
        
        return sample, label
```

## DataLoader

### Basic DataLoader

```python
from torch.utils.data import DataLoader

dataloader = DataLoader(
    dataset,
    batch_size=32,
    shuffle=True,          # Shuffle data
    num_workers=4,         # Number of subprocesses for data loading
    pin_memory=True,       # Copy tensors to CUDA pinned memory
    drop_last=False        # Drop last incomplete batch
)

# Iterate through batches
for batch_idx, (data, target) in enumerate(dataloader):
    # Training code
    pass
```

### DataLoader Parameters

```python
dataloader = DataLoader(
    dataset,
    batch_size=32,              # Samples per batch
    shuffle=True,                # Shuffle at every epoch
    sampler=None,                # Custom sampling strategy
    batch_sampler=None,          # Batch sampling strategy
    num_workers=4,               # Multi-process data loading
    collate_fn=None,             # How to collate samples into batch
    pin_memory=True,             # Pin memory for faster GPU transfer
    drop_last=False,             # Drop last incomplete batch
    timeout=0,                   # Timeout for collecting batch
    worker_init_fn=None,         # Init function for each worker
    persistent_workers=False,    # Keep workers alive between epochs
    prefetch_factor=2           # Number of batches to prefetch per worker
)
```

### Custom Collate Function

```python
def custom_collate_fn(batch):
    """
    Custom function to collate samples into batch
    Useful for variable-length sequences
    """
    # Separate data and labels
    data = [item[0] for item in batch]
    labels = [item[1] for item in batch]
    
    # Pad sequences to same length
    from torch.nn.utils.rnn import pad_sequence
    data = pad_sequence(data, batch_first=True, padding_value=0)
    labels = torch.tensor(labels)
    
    return data, labels

# Use custom collate function
dataloader = DataLoader(
    dataset,
    batch_size=32,
    collate_fn=custom_collate_fn
)
```

## Data Transforms

### Basic Transforms

```python
from torchvision import transforms

# Single transform
transform = transforms.ToTensor()

# Compose multiple transforms
transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                       std=[0.229, 0.224, 0.225])
])
```

### Common Vision Transforms

```python
# Resizing
transforms.Resize(256)                    # Resize shorter edge to 256
transforms.Resize((224, 224))             # Resize to exact size

# Cropping
transforms.CenterCrop(224)                # Crop center 224x224
transforms.RandomCrop(224)                # Random crop 224x224
transforms.RandomResizedCrop(224)         # Random crop and resize
transforms.FiveCrop(224)                  # Crop 4 corners + center

# Flipping and Rotation
transforms.RandomHorizontalFlip(p=0.5)    # Flip with probability 0.5
transforms.RandomVerticalFlip(p=0.5)
transforms.RandomRotation(degrees=30)     # Rotate ±30 degrees

# Color
transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2, hue=0.1)
transforms.Grayscale(num_output_channels=3)
transforms.RandomGrayscale(p=0.1)

# Conversion
transforms.ToTensor()                     # Convert PIL Image to tensor [0, 1]
transforms.ToPILImage()                   # Convert tensor to PIL Image

# Normalization
transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
```

### Data Augmentation

```python
# Training augmentation
train_transform = transforms.Compose([
    transforms.RandomResizedCrop(224),
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(15),
    transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                       std=[0.229, 0.224, 0.225])
])

# Validation/Test (no augmentation)
val_transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                       std=[0.229, 0.224, 0.225])
])

# Apply to datasets
train_dataset = MyDataset(transform=train_transform)
val_dataset = MyDataset(transform=val_transform)
```

### Advanced Augmentation

```python
# Random erasing
transforms.RandomErasing(p=0.5, scale=(0.02, 0.33))

# Affine transformations
transforms.RandomAffine(
    degrees=30,
    translate=(0.1, 0.1),
    scale=(0.8, 1.2),
    shear=10
)

# Perspective transformation
transforms.RandomPerspective(distortion_scale=0.5, p=0.5)

# AutoAugment (learned augmentation policy)
transforms.AutoAugment()
transforms.RandAugment()

# MixUp and CutMix (apply during training, not in transform)
```

### Custom Transform

```python
class CustomTransform:
    def __init__(self, param):
        self.param = param
    
    def __call__(self, img):
        # Apply transformation
        # img can be PIL Image or tensor
        # Return transformed img
        return img

# Use in Compose
transform = transforms.Compose([
    CustomTransform(param=0.5),
    transforms.ToTensor()
])
```

## Data Sampling

### Random Sampler

```python
from torch.utils.data import RandomSampler

sampler = RandomSampler(dataset, replacement=False)
dataloader = DataLoader(dataset, batch_size=32, sampler=sampler)
```

### Sequential Sampler

```python
from torch.utils.data import SequentialSampler

sampler = SequentialSampler(dataset)
dataloader = DataLoader(dataset, batch_size=32, sampler=sampler)
```

### Subset Sampler

```python
from torch.utils.data import SubsetRandomSampler

# Create train/val split
indices = list(range(len(dataset)))
split = int(0.8 * len(dataset))

train_indices = indices[:split]
val_indices = indices[split:]

train_sampler = SubsetRandomSampler(train_indices)
val_sampler = SubsetRandomSampler(val_indices)

train_loader = DataLoader(dataset, batch_size=32, sampler=train_sampler)
val_loader = DataLoader(dataset, batch_size=32, sampler=val_sampler)
```

### Weighted Random Sampler

```python
from torch.utils.data import WeightedRandomSampler

# For imbalanced datasets
class_counts = [1000, 500, 200]  # Samples per class
weights = 1.0 / torch.tensor(class_counts, dtype=torch.float)

# Assign weight to each sample based on its class
sample_weights = [weights[label] for label in labels]

sampler = WeightedRandomSampler(
    weights=sample_weights,
    num_samples=len(sample_weights),
    replacement=True
)

dataloader = DataLoader(dataset, batch_size=32, sampler=sampler)
```

### Distributed Sampler

```python
from torch.utils.data.distributed import DistributedSampler

# For distributed training
sampler = DistributedSampler(
    dataset,
    num_replicas=world_size,
    rank=rank,
    shuffle=True
)

dataloader = DataLoader(
    dataset,
    batch_size=32,
    sampler=sampler,
    num_workers=4
)

# Update sampler for each epoch
for epoch in range(num_epochs):
    sampler.set_epoch(epoch)
    for data, target in dataloader:
        # Training code
        pass
```

## Data Splitting

### Train/Val/Test Split

```python
from torch.utils.data import random_split

# Split dataset
train_size = int(0.7 * len(dataset))
val_size = int(0.15 * len(dataset))
test_size = len(dataset) - train_size - val_size

train_dataset, val_dataset, test_dataset = random_split(
    dataset,
    [train_size, val_size, test_size]
)

# Create dataloaders
train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
val_loader = DataLoader(val_dataset, batch_size=32, shuffle=False)
test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False)
```

### K-Fold Cross Validation

```python
from sklearn.model_selection import KFold

kfold = KFold(n_splits=5, shuffle=True, random_state=42)

for fold, (train_idx, val_idx) in enumerate(kfold.split(dataset)):
    train_sampler = SubsetRandomSampler(train_idx)
    val_sampler = SubsetRandomSampler(val_idx)
    
    train_loader = DataLoader(dataset, batch_size=32, sampler=train_sampler)
    val_loader = DataLoader(dataset, batch_size=32, sampler=val_sampler)
    
    # Train model for this fold
    print(f"Fold {fold + 1}")
    train(model, train_loader, val_loader)
```

## Data Caching and Preprocessing

### Caching Dataset in Memory

```python
class CachedDataset(Dataset):
    def __init__(self, dataset):
        self.dataset = dataset
        self.cache = {}
    
    def __len__(self):
        return len(self.dataset)
    
    def __getitem__(self, idx):
        if idx not in self.cache:
            self.cache[idx] = self.dataset[idx]
        return self.cache[idx]

# Usage
cached_dataset = CachedDataset(original_dataset)
```

### Lazy Loading

```python
class LazyDataset(Dataset):
    def __init__(self, file_paths, labels):
        self.file_paths = file_paths
        self.labels = labels
    
    def __len__(self):
        return len(self.file_paths)
    
    def __getitem__(self, idx):
        # Load data only when needed
        img = Image.open(self.file_paths[idx])
        label = self.labels[idx]
        return img, label
```

## Multi-Modal Data

### Image + Text Dataset

```python
class MultiModalDataset(Dataset):
    def __init__(self, images, texts, labels, img_transform=None, tokenizer=None):
        self.images = images
        self.texts = texts
        self.labels = labels
        self.img_transform = img_transform
        self.tokenizer = tokenizer
    
    def __len__(self):
        return len(self.images)
    
    def __getitem__(self, idx):
        # Load image
        image = Image.open(self.images[idx])
        if self.img_transform:
            image = self.img_transform(image)
        
        # Process text
        text = self.texts[idx]
        if self.tokenizer:
            text = self.tokenizer(text, padding='max_length', truncation=True, return_tensors='pt')
        
        label = self.labels[idx]
        
        return {
            'image': image,
            'text': text,
            'label': label
        }
```

## Performance Optimization

### Efficient Data Loading

```python
# Use multiple workers
dataloader = DataLoader(
    dataset,
    batch_size=32,
    num_workers=4,           # Parallel loading
    pin_memory=True,         # Faster GPU transfer
    persistent_workers=True  # Keep workers alive
)

# Prefetch data
from torch.utils.data import DataLoader
dataloader = DataLoader(
    dataset,
    batch_size=32,
    prefetch_factor=2  # Prefetch 2 batches per worker
)
```

### Memory-Mapped Files

```python
import numpy as np

class MemMapDataset(Dataset):
    def __init__(self, data_path, shape, dtype=np.float32):
        self.data = np.memmap(
            data_path,
            dtype=dtype,
            mode='r',
            shape=shape
        )
    
    def __len__(self):
        return self.data.shape[0]
    
    def __getitem__(self, idx):
        return torch.from_numpy(self.data[idx])
```

### Data on GPU

```python
# For small datasets that fit in GPU memory
class GPUDataset(Dataset):
    def __init__(self, data, labels, device):
        self.data = data.to(device)
        self.labels = labels.to(device)
    
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        return self.data[idx], self.labels[idx]

# Use with pin_memory=False and num_workers=0
gpu_dataset = GPUDataset(data, labels, device='cuda')
dataloader = DataLoader(gpu_dataset, batch_size=32, pin_memory=False, num_workers=0)
```

## Common Issues

### Issue: Slow data loading
**Solutions:**
- Increase `num_workers`
- Use `pin_memory=True`
- Use `persistent_workers=True`
- Optimize transforms (vectorize operations)
- Use memory-mapped files for large datasets

### Issue: Out of memory with DataLoader
**Solutions:**
- Reduce `num_workers`
- Reduce `batch_size`
- Reduce `prefetch_factor`
- Don't cache entire dataset in memory

### Issue: Multiprocessing errors
**Solutions:**
- Set `num_workers=0` to debug
- Use `if __name__ == '__main__':`
- Check for serialization issues in Dataset
- Use simpler transforms
