---
name: pytorch-lightning
description: Use when building, training, or deploying neural networks with PyTorch Lightning, organizing PyTorch code into LightningModules, configuring multi-GPU/TPU training, implementing data pipelines, working with callbacks and logging, or using distributed training strategies (DDP, FSDP, DeepSpeed)
---

# PyTorch Lightning

Deep learning framework that organizes PyTorch code to eliminate boilerplate while maintaining full flexibility.

## When to Use

- Building, training, or deploying neural networks
- Organizing PyTorch code professionally
- Multi-GPU/TPU training
- Implementing data pipelines with LightningDataModules
- Working with callbacks, logging, and distributed training (DDP, FSDP, DeepSpeed)

## Quick Workflow

```python
import lightning as L
import torch.nn.functional as F

# 1. Define model
class MyModel(L.LightningModule):
    def __init__(self):
        super().__init__()
        self.save_hyperparameters()
        self.model = YourNetwork()

    def training_step(self, batch, batch_idx):
        x, y = batch
        loss = F.cross_entropy(self.model(x), y)
        self.log("train_loss", loss)
        return loss

    def configure_optimizers(self):
        return torch.optim.Adam(self.parameters())

# 2. Prepare data
train_loader = DataLoader(train_dataset, batch_size=32)

# 3. Train
trainer = L.Trainer(max_epochs=10, accelerator="gpu", devices=2)
trainer.fit(model, train_loader)
```

## Core Components

### 1. LightningModule
Organize PyTorch models into logical sections:
1. Initialization (`__init__`, `setup`)
2. Training loop (`training_step`)
3. Validation loop (`validation_step`)
4. Test loop (`test_step`)
5. Prediction (`predict_step`)
6. Optimizer configuration (`configure_optimizers`)

**Template:** `scripts/template_lightning_module.py`
**Reference:** `references/lightning_module.md`

### 2. Trainer
Automate training workflow, device management, and callbacks.
- Multi-GPU/TPU support (DDP, FSDP, DeepSpeed)
- Automatic mixed precision
- Gradient accumulation and clipping
- Checkpointing and early stopping

**Setup:** `scripts/quick_trainer_setup.py`
**Reference:** `references/trainer.md`

### 3. LightningDataModule
Encapsulate data processing:
1. `prepare_data()` - Download/process (single-process)
2. `setup()` - Create datasets (per-GPU)
3. `train_dataloader()`, `val_dataloader()`, `test_dataloader()`

**Template:** `scripts/template_datamodule.py`
**Reference:** `references/data_module.md`

### 4. Callbacks
Add custom functionality at training hooks:
- ModelCheckpoint - Save best/latest models
- EarlyStopping - Stop when metrics plateau
- LearningRateMonitor - Track LR changes
- BatchSizeFinder - Auto-determine optimal batch size

**Reference:** `references/callbacks.md`

### 5. Logging
Integrate with experiment tracking platforms:
- TensorBoard (default)
- Weights & Biases (WandbLogger)
- MLflow (MLFlowLogger)
- Neptune, Comet, CSV

**Reference:** `references/logging.md`

### 6. Distributed Training
Choose strategy based on model size:
- **DDP** - Models <500M parameters
- **FSDP** - Models 500M+ parameters (recommended)
- **DeepSpeed** - Cutting-edge features

**Reference:** `references/distributed_training.md`

## Best Practices

- **Device agnostic** - Use `self.device` instead of `.cuda()`
- **Save hyperparameters** - Use `self.save_hyperparameters()` in `__init__`
- **Log metrics** - Use `self.log()` for automatic aggregation
- **Reproducibility** - Use `seed_everything()` and `Trainer(deterministic=True)`
- **Debugging** - Use `Trainer(fast_dev_run=True)` to test with 1 batch

**Reference:** `references/best_practices.md`

## Scripts

- **`template_lightning_module.py`** - Complete LightningModule boilerplate
- **`template_datamodule.py`** - Complete LightningDataModule boilerplate
- **`quick_trainer_setup.py`** - Common Trainer configurations

## References

- **`lightning_module.md`** - Methods, hooks, properties
- **`trainer.md`** - Trainer configuration and parameters
- **`data_module.md`** - LightningDataModule patterns
- **`callbacks.md`** - Built-in and custom callbacks
- **`logging.md`** - Logger integrations
- **`distributed_training.md`** - DDP, FSDP, DeepSpeed comparison
- **`best_practices.md`** - Common patterns and pitfalls
