# Code Guide Best Practices

This document provides guidance on how to create effective code guides for paper implementations.

## Principles

1. **Focus on Practical Usage**: Show how to actually use the code, not just what it does
2. **Concrete Examples**: Provide runnable code snippets and commands
3. **Progressive Complexity**: Start simple, then show advanced usage
4. **Troubleshooting**: Include common issues and solutions

## Structure

A good code guide should have:

### 1. Setup Section
Clear, step-by-step installation and environment setup:

```markdown
## Setup

### Requirements
- Python 3.8+
- CUDA 11.0+ (for GPU support)
- 16GB RAM minimum

### Installation
\```bash
# Create conda environment
conda create -n paper-env python=3.8
conda activate paper-env

# Install dependencies
pip install -r requirements.txt

# Install the package
pip install -e .
\```

### Verify Installation
\```bash
python -c "import model; print(model.__version__)"
\```
```

### 2. Core Components Section
Explain the main building blocks:

```markdown
## Core Components

### Model Architecture

**File**: `src/model/transformer.py:45-120`

The main model class implementing the paper's Transformer architecture.

**Key Methods**:
- `__init__(config)`: Initialize model with config
- `forward(src, tgt)`: Forward pass for sequence-to-sequence
- `encode(src)`: Encode source sequence
- `decode(tgt, memory)`: Decode target sequence

**Example**:
\```python
from model.transformer import Transformer
from model.config import TransformerConfig

# Initialize model
config = TransformerConfig(
    d_model=512,
    nhead=8,
    num_encoder_layers=6,
    num_decoder_layers=6
)
model = Transformer(config)

# Forward pass
output = model(src_tokens, tgt_tokens)
\```
```

### 3. Usage Patterns Section
Show common workflows:

```markdown
## Usage Patterns

### Pattern 1: Training from Scratch

\```bash
# Prepare data
python scripts/preprocess_data.py \
  --input data/raw/ \
  --output data/processed/

# Train model
python train.py \
  --config configs/base.yaml \
  --data data/processed/ \
  --output checkpoints/
\```

### Pattern 2: Fine-tuning Pretrained Model

\```python
from model import Transformer

# Load pretrained weights
model = Transformer.from_pretrained('path/to/checkpoint.pth')

# Freeze encoder layers
for param in model.encoder.parameters():
    param.requires_grad = False

# Fine-tune on your data
# ... training loop ...
\```

### Pattern 3: Inference

\```python
import torch
from model import Transformer
from tokenizer import Tokenizer

# Load model and tokenizer
model = Transformer.from_pretrained('checkpoints/best.pth')
tokenizer = Tokenizer.from_file('vocab.json')
model.eval()

# Prepare input
text = "Hello world"
tokens = tokenizer.encode(text)
input_ids = torch.tensor([tokens])

# Generate
with torch.no_grad():
    output = model.generate(input_ids, max_length=50)

# Decode output
result = tokenizer.decode(output[0])
print(result)
\```
```

### 4. Configuration Section
Document important configuration options:

```markdown
## Configuration

### Key Parameters

The model is configured via YAML files in `configs/`:

\```yaml
# configs/base.yaml
model:
  d_model: 512        # Model dimension
  nhead: 8            # Number of attention heads
  num_layers: 6       # Number of transformer layers
  dim_feedforward: 2048  # FFN dimension
  dropout: 0.1        # Dropout rate

training:
  batch_size: 64
  learning_rate: 0.0001
  num_epochs: 100
  warmup_steps: 4000

data:
  max_seq_length: 512
  vocab_size: 32000
\```

### Customization

Create custom config by extending base:

\```yaml
# configs/my_config.yaml
_base_: base.yaml

model:
  d_model: 768        # Larger model
  num_layers: 12

training:
  batch_size: 32      # Smaller batch for larger model
\```
```

### 5. Common Workflows
End-to-end examples:

```markdown
## Complete Workflows

### Workflow 1: Train Translation Model

\```bash
# Step 1: Download and prepare data
wget https://example.com/parallel_corpus.tar.gz
tar -xzf parallel_corpus.tar.gz

# Step 2: Preprocess
python scripts/build_vocab.py \
  --source data/train.en \
  --target data/train.de \
  --output vocab/

python scripts/preprocess.py \
  --source data/train.en \
  --target data/train.de \
  --vocab vocab/ \
  --output data/processed/

# Step 3: Train
python train.py \
  --config configs/translation.yaml \
  --data data/processed/ \
  --output checkpoints/translation/

# Step 4: Evaluate
python evaluate.py \
  --checkpoint checkpoints/translation/best.pth \
  --test-source data/test.en \
  --test-target data/test.de
\```

**Expected Output**:
```
BLEU Score: 28.4
Training time: ~24 hours on 8x V100 GPUs
```

### Workflow 2: Use Pretrained Model

\```python
# Download pretrained model
from model.hub import download_pretrained

model_path = download_pretrained('transformer-base-en-de')

# Load and use
from model import Transformer

model = Transformer.from_pretrained(model_path)
model.eval()

# Translate
translation = model.translate(
    "Hello, how are you?",
    src_lang="en",
    tgt_lang="de"
)
print(translation)  # "Hallo, wie geht es dir?"
\```
```

### 6. Troubleshooting Section
Address common issues:

```markdown
## Troubleshooting

### Issue 1: Out of Memory During Training

**Symptoms**:
```
RuntimeError: CUDA out of memory
```

**Solutions**:
1. Reduce batch size in config:
   \```yaml
   training:
     batch_size: 16  # Reduce from 64
   \```

2. Enable gradient accumulation:
   \```yaml
   training:
     gradient_accumulation_steps: 4
   \```

3. Use gradient checkpointing:
   \```python
   model = Transformer(config, use_checkpointing=True)
   \```

### Issue 2: Poor Translation Quality

**Symptoms**: Model generates repetitive or nonsensical text

**Solutions**:
1. Check if model trained long enough (monitor validation loss)
2. Ensure vocabulary includes special tokens
3. Try different decoding strategies:
   \```python
   output = model.generate(
       input_ids,
       num_beams=5,        # Beam search
       temperature=0.8,    # Sampling temperature
       top_k=50,           # Top-k sampling
       repetition_penalty=1.2  # Penalize repetition
   )
   \```

### Issue 3: Slow Training

**Symptoms**: Training takes much longer than expected

**Solutions**:
1. Enable mixed precision training:
   \```python
   from torch.cuda.amp import autocast, GradScaler

   scaler = GradScaler()

   with autocast():
       output = model(input)
       loss = criterion(output, target)
   \```

2. Use DataLoader with multiple workers:
   \```python
   dataloader = DataLoader(
       dataset,
       batch_size=64,
       num_workers=8,     # Parallel data loading
       pin_memory=True    # Faster GPU transfer
   )
   \```

3. Profile to find bottlenecks:
   \```python
   from torch.profiler import profile, record_function

   with profile() as prof:
       model(input)
   print(prof.key_averages().table())
   \```
```

## Tips for Deep Learning Papers

### Document Hardware Requirements
```markdown
## Hardware Requirements

### Minimum
- 1x GPU with 16GB VRAM (e.g., V100, A100)
- 32GB system RAM
- 100GB disk space

### Recommended
- 4x GPUs with 32GB VRAM each
- 128GB system RAM
- 500GB NVMe SSD

### What We Used (for paper results)
- 8x NVIDIA V100 (32GB)
- Training time: ~3 days for base model
```

### Show Data Format
```markdown
## Data Format

### Training Data Structure
\```
data/
├── train/
│   ├── source.txt    # One example per line
│   └── target.txt    # Aligned translations
├── val/
│   ├── source.txt
│   └── target.txt
└── test/
    ├── source.txt
    └── target.txt
\```

### Example Data
\```
# source.txt
Hello world
How are you?

# target.txt
Hallo Welt
Wie geht es dir?
\```
```

### Include Checkpoints and Pretrained Models
```markdown
## Pretrained Models

We provide pretrained checkpoints:

| Model | Dataset | BLEU | Download |
|-------|---------|------|----------|
| Base | WMT14 EN-DE | 27.3 | [link](https://example.com/base.pth) |
| Big | WMT14 EN-DE | 28.4 | [link](https://example.com/big.pth) |

### Loading Pretrained Models
\```python
import torch
from model import Transformer

# Load checkpoint
checkpoint = torch.load('base.pth')
model = Transformer(checkpoint['config'])
model.load_state_dict(checkpoint['model_state_dict'])
\```
```

## Anti-Patterns to Avoid

1. **Don't just list API documentation**: Show how to use it, not just what exists
2. **Don't assume expertise**: Explain deep learning specifics (e.g., what dropout does in this context)
3. **Don't skip error handling**: Show how to handle common errors
4. **Don't ignore reproduction**: Provide exact commands to reproduce paper results
5. **Don't forget dependencies**: List all requirements including CUDA version, etc.

## Quality Checklist

- [ ] Can a user install and run the code following this guide?
- [ ] Are all code snippets tested and working?
- [ ] Are file paths and commands accurate?
- [ ] Are hardware requirements documented?
- [ ] Are common errors addressed?
- [ ] Are paper results reproducible with provided commands?
- [ ] Are all config parameters explained?
- [ ] Are examples concrete (not pseudocode)?
