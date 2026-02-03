# Computer Vision with PyTorch

This reference covers common computer vision tasks and architectures.

## Image Classification

### Basic CNN Architecture

```python
import torch.nn as nn
import torch.nn.functional as F

class SimpleCNN(nn.Module):
    def __init__(self, num_classes=10):
        super(SimpleCNN, self).__init__()
        self.conv1 = nn.Conv2d(3, 32, 3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, 3, padding=1)
        self.conv3 = nn.Conv2d(64, 128, 3, padding=1)
        self.pool = nn.MaxPool2d(2, 2)
        self.fc1 = nn.Linear(128 * 4 * 4, 512)
        self.fc2 = nn.Linear(512, num_classes)
        self.dropout = nn.Dropout(0.5)
    
    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))  # 32x32 -> 16x16
        x = self.pool(F.relu(self.conv2(x)))  # 16x16 -> 8x8
        x = self.pool(F.relu(self.conv3(x)))  # 8x8 -> 4x4
        x = x.view(-1, 128 * 4 * 4)
        x = F.relu(self.fc1(x))
        x = self.dropout(x)
        x = self.fc2(x)
        return x
```

### Using Pretrained Models

```python
import torchvision.models as models

# ResNet
model = models.resnet50(pretrained=True)
model = models.resnet18(pretrained=True)
model = models.resnet101(pretrained=True)

# VGG
model = models.vgg16(pretrained=True)
model = models.vgg19(pretrained=True)

# EfficientNet
model = models.efficientnet_b0(pretrained=True)
model = models.efficientnet_b7(pretrained=True)

# Vision Transformer
model = models.vit_b_16(pretrained=True)

# MobileNet
model = models.mobilenet_v2(pretrained=True)
model = models.mobilenet_v3_large(pretrained=True)

# DenseNet
model = models.densenet121(pretrained=True)

# Inception
model = models.inception_v3(pretrained=True)
```

### Transfer Learning

```python
import torch.nn as nn
import torchvision.models as models

# Load pretrained model
model = models.resnet50(pretrained=True)

# Freeze all layers
for param in model.parameters():
    param.requires_grad = False

# Replace final layer
num_features = model.fc.in_features
model.fc = nn.Linear(num_features, num_classes)

# Only train the new layer
optimizer = torch.optim.Adam(model.fc.parameters(), lr=0.001)

# Alternative: Fine-tune last few layers
for param in model.layer4.parameters():
    param.requires_grad = True

optimizer = torch.optim.Adam([
    {'params': model.layer4.parameters(), 'lr': 1e-4},
    {'params': model.fc.parameters(), 'lr': 1e-3}
])
```

### Feature Extraction

```python
# Extract features from pretrained model
model = models.resnet50(pretrained=True)
model.fc = nn.Identity()  # Remove classification head
model.eval()

with torch.no_grad():
    features = model(images)  # Shape: (batch_size, 2048)

# Use features for other tasks
```

## Object Detection

### Using Pre-trained Detectors

```python
import torchvision.models.detection as detection

# Faster R-CNN
model = detection.fasterrcnn_resnet50_fpn(pretrained=True)

# RetinaNet
model = detection.retinanet_resnet50_fpn(pretrained=True)

# FCOS
model = detection.fcos_resnet50_fpn(pretrained=True)

# SSD
model = detection.ssd300_vgg16(pretrained=True)

# Inference
model.eval()
with torch.no_grad():
    predictions = model(images)
    # predictions: list of dicts with 'boxes', 'labels', 'scores'

# Process predictions
for pred in predictions:
    boxes = pred['boxes']      # (N, 4) in [x1, y1, x2, y2]
    labels = pred['labels']    # (N,) class indices
    scores = pred['scores']    # (N,) confidence scores
```

### Custom Detection Head

```python
class CustomDetector(nn.Module):
    def __init__(self, backbone, num_classes):
        super().__init__()
        self.backbone = backbone
        # Add detection head
        self.box_head = nn.Linear(2048, 4)  # Bounding box regression
        self.class_head = nn.Linear(2048, num_classes)  # Classification
    
    def forward(self, x):
        features = self.backbone(x)
        boxes = self.box_head(features)
        class_logits = self.class_head(features)
        return boxes, class_logits
```

## Semantic Segmentation

### FCN (Fully Convolutional Network)

```python
import torchvision.models.segmentation as segmentation

# DeepLab v3
model = segmentation.deeplabv3_resnet50(pretrained=True)
model = segmentation.deeplabv3_resnet101(pretrained=True)

# FCN
model = segmentation.fcn_resnet50(pretrained=True)

# Inference
model.eval()
with torch.no_grad():
    output = model(images)['out']  # Shape: (batch, num_classes, H, W)
    predictions = output.argmax(dim=1)  # Class prediction per pixel
```

### U-Net Architecture

```python
class UNet(nn.Module):
    def __init__(self, in_channels=3, num_classes=1):
        super(UNet, self).__init__()
        
        # Encoder
        self.enc1 = self.conv_block(in_channels, 64)
        self.enc2 = self.conv_block(64, 128)
        self.enc3 = self.conv_block(128, 256)
        self.enc4 = self.conv_block(256, 512)
        
        # Bottleneck
        self.bottleneck = self.conv_block(512, 1024)
        
        # Decoder
        self.upconv4 = nn.ConvTranspose2d(1024, 512, 2, stride=2)
        self.dec4 = self.conv_block(1024, 512)
        
        self.upconv3 = nn.ConvTranspose2d(512, 256, 2, stride=2)
        self.dec3 = self.conv_block(512, 256)
        
        self.upconv2 = nn.ConvTranspose2d(256, 128, 2, stride=2)
        self.dec2 = self.conv_block(256, 128)
        
        self.upconv1 = nn.ConvTranspose2d(128, 64, 2, stride=2)
        self.dec1 = self.conv_block(128, 64)
        
        self.out = nn.Conv2d(64, num_classes, 1)
        
        self.pool = nn.MaxPool2d(2, 2)
    
    def conv_block(self, in_ch, out_ch):
        return nn.Sequential(
            nn.Conv2d(in_ch, out_ch, 3, padding=1),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(inplace=True),
            nn.Conv2d(out_ch, out_ch, 3, padding=1),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(inplace=True)
        )
    
    def forward(self, x):
        # Encoder
        enc1 = self.enc1(x)
        enc2 = self.enc2(self.pool(enc1))
        enc3 = self.enc3(self.pool(enc2))
        enc4 = self.enc4(self.pool(enc3))
        
        # Bottleneck
        bottleneck = self.bottleneck(self.pool(enc4))
        
        # Decoder with skip connections
        dec4 = self.upconv4(bottleneck)
        dec4 = torch.cat([dec4, enc4], dim=1)
        dec4 = self.dec4(dec4)
        
        dec3 = self.upconv3(dec4)
        dec3 = torch.cat([dec3, enc3], dim=1)
        dec3 = self.dec3(dec3)
        
        dec2 = self.upconv2(dec3)
        dec2 = torch.cat([dec2, enc2], dim=1)
        dec2 = self.dec2(dec2)
        
        dec1 = self.upconv1(dec2)
        dec1 = torch.cat([dec1, enc1], dim=1)
        dec1 = self.dec1(dec1)
        
        return self.out(dec1)
```

## Image Augmentation

### Torchvision Transforms

```python
from torchvision import transforms

train_transform = transforms.Compose([
    transforms.RandomResizedCrop(224),
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(15),
    transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2, hue=0.1),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

# Advanced augmentation
train_transform = transforms.Compose([
    transforms.RandomResizedCrop(224, scale=(0.8, 1.0)),
    transforms.RandomHorizontalFlip(),
    transforms.RandomApply([transforms.ColorJitter(0.4, 0.4, 0.4, 0.1)], p=0.8),
    transforms.RandomGrayscale(p=0.2),
    transforms.RandomApply([transforms.GaussianBlur(kernel_size=23)], p=0.5),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    transforms.RandomErasing(p=0.5)
])
```

### Albumentations (Advanced)

```python
import albumentations as A
from albumentations.pytorch import ToTensorV2

transform = A.Compose([
    A.RandomResizedCrop(224, 224),
    A.HorizontalFlip(p=0.5),
    A.ShiftScaleRotate(shift_limit=0.1, scale_limit=0.2, rotate_limit=30, p=0.5),
    A.OneOf([
        A.OpticalDistortion(p=1),
        A.GridDistortion(p=1),
        A.ElasticTransform(p=1),
    ], p=0.3),
    A.OneOf([
        A.GaussNoise(p=1),
        A.GaussianBlur(p=1),
        A.MotionBlur(p=1),
    ], p=0.3),
    A.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ToTensorV2()
])

# Usage
augmented = transform(image=image)
image = augmented['image']
```

## Visualization

### Display Images

```python
import matplotlib.pyplot as plt
import torchvision

# Display single image
def show_image(img, title=None):
    img = img.numpy().transpose((1, 2, 0))
    mean = [0.485, 0.456, 0.406]
    std = [0.229, 0.224, 0.225]
    img = std * img + mean
    img = np.clip(img, 0, 1)
    plt.imshow(img)
    if title:
        plt.title(title)
    plt.show()

# Display batch
def show_batch(images, labels=None, predictions=None):
    grid = torchvision.utils.make_grid(images)
    show_image(grid)
```

### Feature Map Visualization

```python
def visualize_feature_maps(model, image, layer_name):
    activation = {}
    
    def hook(module, input, output):
        activation[layer_name] = output.detach()
    
    # Register hook
    layer = dict(model.named_modules())[layer_name]
    handle = layer.register_forward_hook(hook)
    
    # Forward pass
    model.eval()
    with torch.no_grad():
        _ = model(image.unsqueeze(0))
    
    # Remove hook
    handle.remove()
    
    # Visualize
    feature_maps = activation[layer_name].squeeze()
    fig, axes = plt.subplots(4, 8, figsize=(16, 8))
    for i, ax in enumerate(axes.flat):
        if i < feature_maps.shape[0]:
            ax.imshow(feature_maps[i].cpu(), cmap='viridis')
        ax.axis('off')
    plt.show()
```

### Grad-CAM

```python
class GradCAM:
    def __init__(self, model, target_layer):
        self.model = model
        self.target_layer = target_layer
        self.gradients = None
        self.activations = None
        
        # Register hooks
        target_layer.register_forward_hook(self.save_activation)
        target_layer.register_full_backward_hook(self.save_gradient)
    
    def save_activation(self, module, input, output):
        self.activations = output.detach()
    
    def save_gradient(self, module, grad_input, grad_output):
        self.gradients = grad_output[0].detach()
    
    def __call__(self, x, class_idx=None):
        # Forward pass
        output = self.model(x)
        
        if class_idx is None:
            class_idx = output.argmax(dim=1)
        
        # Backward pass
        self.model.zero_grad()
        output[0, class_idx].backward()
        
        # Compute weights
        weights = self.gradients.mean(dim=(2, 3), keepdim=True)
        
        # Weighted combination
        cam = (weights * self.activations).sum(dim=1, keepdim=True)
        cam = F.relu(cam)
        
        # Normalize
        cam = cam - cam.min()
        cam = cam / cam.max()
        
        return cam.squeeze().cpu().numpy()
```

## Common CV Tasks

### Image Preprocessing for Models

```python
# Standard ImageNet preprocessing
transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                       std=[0.229, 0.224, 0.225])
])

# For grayscale images
transform = transforms.Compose([
    transforms.Grayscale(num_output_channels=3),  # Convert to 3-channel
    transforms.Resize(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                       std=[0.229, 0.224, 0.225])
])
```

### Batch Prediction

```python
def predict_batch(model, images, device):
    model.eval()
    images = images.to(device)
    
    with torch.no_grad():
        outputs = model(images)
        probabilities = F.softmax(outputs, dim=1)
        predictions = outputs.argmax(dim=1)
    
    return predictions, probabilities
```

### Test-Time Augmentation (TTA)

```python
def predict_with_tta(model, image, num_augmentations=5):
    model.eval()
    predictions = []
    
    # Original image
    with torch.no_grad():
        pred = model(image.unsqueeze(0))
        predictions.append(pred)
    
    # Augmented versions
    for _ in range(num_augmentations):
        aug_image = augment(image)  # Apply random augmentation
        with torch.no_grad():
            pred = model(aug_image.unsqueeze(0))
            predictions.append(pred)
    
    # Average predictions
    avg_prediction = torch.stack(predictions).mean(dim=0)
    return avg_prediction
```

## Loss Functions for CV

```python
# Segmentation losses
class DiceLoss(nn.Module):
    def forward(self, pred, target):
        smooth = 1.0
        pred = torch.sigmoid(pred)
        intersection = (pred * target).sum()
        dice = (2. * intersection + smooth) / (pred.sum() + target.sum() + smooth)
        return 1 - dice

# Focal Loss (for imbalanced datasets)
class FocalLoss(nn.Module):
    def __init__(self, alpha=0.25, gamma=2):
        super().__init__()
        self.alpha = alpha
        self.gamma = gamma
    
    def forward(self, inputs, targets):
        bce_loss = F.binary_cross_entropy_with_logits(inputs, targets, reduction='none')
        pt = torch.exp(-bce_loss)
        focal_loss = self.alpha * (1-pt)**self.gamma * bce_loss
        return focal_loss.mean()

# IoU Loss
class IoULoss(nn.Module):
    def forward(self, pred, target):
        pred = torch.sigmoid(pred)
        intersection = (pred * target).sum()
        union = pred.sum() + target.sum() - intersection
        iou = intersection / (union + 1e-6)
        return 1 - iou
```
