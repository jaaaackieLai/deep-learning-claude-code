---
name: paper
description: Transform research papers and their code repositories into reusable skills for quick understanding and practical application. Use when users want to package a paper with its implementation code, create a reference guide for a specific paper, or build a skill that captures a paper's problem, solution, and contributions. Triggers include requests like "package this paper as a skill", "create a skill from paper X and its code", or "analyze paper and code to make a reusable reference".
---

# Paper Skill Creator

This skill guides the process of transforming a research paper and its code repository into a structured, reusable skill that enables quick understanding and practical application.

## Purpose

Create a skill that packages:
- Research paper (PDF)
- Implementation code (GitHub repository)
- Structured analysis of problem, solution, and contributions
- Practical usage examples and key concepts

The resulting skill allows users to quickly grasp the paper's essence without re-reading, and apply the methods in their own research.

## Workflow

### Step 1: Gather Inputs

Collect from the user:
1. **Paper location**: Path to the PDF file
2. **Repository URL**: GitHub URL of the implementation code

Both inputs are required. If either is missing, request it from the user.

### Step 2: Clone and Explore Repository

Clone the repository to understand the codebase structure:

```bash
git clone <github-url> ./paper_repos/<paper-name>
```

Then explore the repository structure to identify:
- **Model files**: `model.py`, `network.py`, `architecture.py`, etc.
- **Training files**: `train.py`, `main.py`, `run.py`, etc.
- **Config files**: `config.py`, `settings.py`, YAML configs
- **Data files**: `dataset.py`, `dataloader.py`, `data_utils.py`
- **Notebooks**: Jupyter notebooks with examples or experiments
- **README**: Setup and usage instructions

Use Glob and Read tools to identify these files:

```bash
# Find Python files
ls **/*.py

# Find key files
ls README.md requirements.txt environment.yml
```

### Step 3: Analyze Paper Content

Use the `pdf` skill to read and analyze the paper:

```
/pdf <paper-path>
```

Extract and structure the following information:

1. **Problem Statement**
   - What problem does the paper address?
   - Why is it important?
   - What are the limitations of existing approaches?

2. **Proposed Solution**
   - Core methodology and approach
   - Key innovations or novel contributions
   - Technical details (architecture, algorithm, etc.)

3. **Main Contributions**
   - What new insights or methods does the paper provide?
   - Experimental results and improvements
   - Practical implications

4. **Key Concepts**
   - Important terminology and definitions
   - Mathematical formulations (if applicable)
   - Relationships to prior work

### Step 4: Analyze Code Implementation

Read the key files identified in Step 2 to understand:

1. **Core Implementation**
   - Main model/algorithm implementation
   - Key classes and functions
   - How the paper's method is realized in code

2. **Usage Patterns**
   - How to initialize and use the model
   - Required dependencies and setup
   - Configuration options

3. **Example Workflows**
   - Training scripts and their usage
   - Inference/evaluation examples
   - Data preparation steps

### Step 5: Generate the Skill

Create a new skill using `/skill-creator` with the following structure:

#### Skill Structure

```
<paper-name>/
├── SKILL.md
└── references/
    ├── paper_summary.md      # Problem, solution, contributions
    ├── key_concepts.md       # Important concepts and terminology
    └── code_guide.md         # How to use the implementation
```

#### SKILL.md Template

```yaml
---
name: <paper-name>
description: Guide for understanding and applying <paper-title>. Provides structured summary of the paper's problem, solution, and contributions, along with practical guidance for using the implementation code. Use when users ask about <paper-topic>, want to apply <method-name>, or reference this specific paper.
---

# <Paper Title>

Quick reference for understanding and applying the methods from "<Paper Title>" by <Authors>.

## Paper Summary

**Problem**: [Brief 1-2 sentence summary]

**Solution**: [Brief 1-2 sentence summary]

**Key Contribution**: [Main innovation in 1 sentence]

For detailed analysis, see [references/paper_summary.md](references/paper_summary.md).

## Key Concepts

- **Concept 1**: Brief explanation
- **Concept 2**: Brief explanation
- **Concept 3**: Brief explanation

For in-depth concept explanations, see [references/key_concepts.md](references/key_concepts.md).

## Using the Implementation

**Repository**: <github-url>

**Quick Start**:
```bash
# Clone repository
git clone <github-url>

# Install dependencies
pip install -r requirements.txt

# Basic usage
python train.py --config configs/default.yaml
```

For detailed code guide and usage patterns, see [references/code_guide.md](references/code_guide.md).

## When to Use This Skill

Use this skill when:
- Users ask about the paper's method or approach
- Users want to apply this technique to their research
- Users need to understand the implementation details
- Users reference this paper in conversation
```

#### references/paper_summary.md Template

```markdown
# Paper Summary: <Paper Title>

## Problem Statement

### Background
[Detailed context about the problem domain]

### Challenges
[What makes this problem difficult?]

### Limitations of Prior Work
[Why existing methods are insufficient]

## Proposed Solution

### Overview
[High-level description of the approach]

### Key Components
1. **Component 1**: [Detailed explanation]
2. **Component 2**: [Detailed explanation]
3. **Component 3**: [Detailed explanation]

### Technical Details
[Architecture, algorithm, methodology]

### Innovation
[What's novel about this approach?]

## Main Contributions

1. **Contribution 1**: [Description and impact]
2. **Contribution 2**: [Description and impact]
3. **Contribution 3**: [Description and impact]

## Experimental Results

### Datasets
[Which datasets were used]

### Performance
[Key performance metrics and improvements]

### Comparisons
[How it compares to baselines]

## Practical Implications

[How this work advances the field]
[Potential applications]
[Future research directions]
```

#### references/key_concepts.md Template

```markdown
# Key Concepts: <Paper Title>

## Core Terminology

### Concept 1
**Definition**: [Clear definition]

**Context**: [Why it matters in this paper]

**Related Work**: [How it relates to prior concepts]

### Concept 2
[Same structure as above]

## Mathematical Formulations

### Formula 1: [Name]
```
[Mathematical notation]
```

**Explanation**: [What this formula represents]

**Parameters**:
- `param1`: [Description]
- `param2`: [Description]

### Formula 2: [Name]
[Same structure]

## Relationships to Prior Work

[How concepts build on or differ from previous research]
```

#### references/code_guide.md Template

```markdown
# Code Guide: <Paper Title>

**Repository**: <github-url>

## Setup

### Requirements
```bash
# Python version
Python >= X.X

# Install dependencies
pip install -r requirements.txt
# or
conda env create -f environment.yml
```

### Directory Structure
```
repo/
├── model/           # Model implementation
├── data/            # Data processing
├── configs/         # Configuration files
├── scripts/         # Training/evaluation scripts
└── notebooks/       # Example notebooks
```

## Core Components

### Model Implementation

**File**: `path/to/model.py`

**Key Classes**:
```python
class ModelName:
    """Main model implementing the paper's method"""

    def __init__(self, config):
        # Model initialization

    def forward(self, x):
        # Forward pass implementation
```

**Usage**:
```python
from model import ModelName

# Initialize model
model = ModelName(config)

# Use model
output = model(input_data)
```

### Training Pipeline

**File**: `path/to/train.py`

**Usage**:
```bash
# Basic training
python train.py --config configs/default.yaml

# Custom training
python train.py --lr 0.001 --batch-size 32 --epochs 100
```

**Key Parameters**:
- `--lr`: Learning rate (default: X)
- `--batch-size`: Batch size (default: X)
- `--epochs`: Number of epochs (default: X)

### Evaluation/Inference

**File**: `path/to/eval.py`

**Usage**:
```bash
# Evaluate on test set
python eval.py --checkpoint path/to/model.pth --data test_data/

# Run inference
python inference.py --input input.png --output output.png
```

## Example Workflows

### Example 1: Train from Scratch
```bash
# Prepare data
python prepare_data.py --dataset DATASET_NAME

# Train model
python train.py --config configs/scratch.yaml

# Evaluate
python eval.py --checkpoint checkpoints/best.pth
```

### Example 2: Fine-tune Pretrained Model
```bash
# Download pretrained weights
wget <pretrained-url>

# Fine-tune
python train.py --config configs/finetune.yaml --pretrained model.pth
```

### Example 3: Using in Your Own Code
```python
import torch
from model import ModelName

# Load pretrained model
model = ModelName.from_pretrained('path/to/checkpoint')
model.eval()

# Your custom data
data = torch.randn(1, 3, 224, 224)

# Inference
with torch.no_grad():
    output = model(data)
```

## Common Patterns

### Pattern 1: [Name]
[Description and code example]

### Pattern 2: [Name]
[Description and code example]

## Troubleshooting

### Issue 1
**Problem**: [Description]
**Solution**: [How to fix]

### Issue 2
**Problem**: [Description]
**Solution**: [How to fix]
```

### Step 6: Package the Skill

After creating all files, package the skill:

```bash
python /path/to/skill-creator/scripts/package_skill.py <paper-skill-directory>
```

This generates a `.skill` file ready for distribution.

## Best Practices

1. **Conciseness**: Keep SKILL.md brief with links to detailed references
2. **Structure**: Use progressive disclosure - essential info in SKILL.md, details in references
3. **Examples**: Include concrete code examples in references/code_guide.md
4. **Clarity**: Write for someone who hasn't read the paper
5. **Completeness**: Cover both understanding (paper) and application (code)

## Example Usage

User: "Package the ResNet paper and its PyTorch implementation as a skill"

Response workflow:
1. Request paper PDF path and GitHub URL if not provided
2. Clone repository: `git clone https://github.com/pytorch/vision`
3. Read paper with `/pdf` skill
4. Analyze repository structure
5. Extract key information (problem, solution, contributions)
6. Generate skill with paper_summary.md, key_concepts.md, code_guide.md
7. Package skill for distribution
