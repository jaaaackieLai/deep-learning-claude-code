---
name: seaborn
description: Use when creating statistical visualizations with pandas DataFrames, exploring distributions and relationships, making categorical comparisons, generating box plots, violin plots, pair plots, heatmaps, or need attractive publication-ready defaults with minimal code
---

# Seaborn Statistical Visualization

Seaborn is a Python visualization library for creating publication-quality statistical graphics with minimal code.

## Design Philosophy

1. **Dataset-oriented** - Work directly with DataFrames and named variables
2. **Semantic mapping** - Automatically translate data to visual properties (colors, sizes, styles)
3. **Statistical awareness** - Built-in aggregation, error estimation, confidence intervals
4. **Aesthetic defaults** - Publication-ready themes out of the box
5. **Matplotlib integration** - Full compatibility when needed

## Quick Start

```python
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

# Load data
df = sns.load_dataset('tips')

# Create visualization
sns.scatterplot(data=df, x='total_bill', y='tip', hue='day')
plt.show()
```

## Core Plotting Functions

### Relational Plots
Explore relationships between variables.
- `scatterplot()`, `lineplot()` - Individual plots
- `relplot()` - Figure-level with faceting

### Distribution Plots
Understand data spread and shape.
- `histplot()`, `kdeplot()`, `ecdfplot()`, `rugplot()`
- `displot()`, `jointplot()`, `pairplot()` - Figure-level

### Categorical Plots
Compare across discrete categories.
- `boxplot()`, `violinplot()`, `stripplot()`, `swarmplot()`
- `barplot()`, `pointplot()`, `countplot()`
- `catplot()` - Figure-level with faceting

### Regression Plots
Visualize linear relationships.
- `regplot()`, `lmplot()`, `residplot()`

### Matrix Plots
Rectangular data visualization.
- `heatmap()`, `clustermap()`

**Comprehensive reference:** `references/function_reference.md`

## Figure-Level vs Axes-Level

### Axes-Level
Plot to single `Axes`, integrate with matplotlib.
```python
fig, axes = plt.subplots(2, 2)
sns.scatterplot(data=df, x='x', y='y', ax=axes[0, 0])
sns.histplot(data=df, x='x', ax=axes[0, 1])
```

### Figure-Level
Manage entire figure, built-in faceting.
```python
sns.relplot(data=df, x='x', y='y', col='category', row='group',
            hue='type', height=3, aspect=1.2)
```

## Data Structure

**Prefer long-form data:**
```python
# Long-form (tidy)
   subject  condition  measurement
0        1    control         10.5
1        1  treatment         12.3
```

**Wide-to-long conversion:**
```python
df_long = df.melt(var_name='condition', value_name='measurement')
```

## Color Palettes

- **Qualitative** (categories): `"deep"`, `"muted"`, `"pastel"`, `"bright"`, `"colorblind"`
- **Sequential** (ordered): `"rocket"`, `"mako"`, `"viridis"`, `"magma"`
- **Diverging** (centered): `"vlag"`, `"icefire"`, `"coolwarm"`

```python
sns.set_palette("colorblind")  # Set globally
sns.heatmap(data, cmap='rocket')  # Per-plot
```

## Theming

```python
# Set theme
sns.set_theme(style='whitegrid', palette='pastel', font='sans-serif')

# Styles: "darkgrid", "whitegrid", "dark", "white", "ticks"
# Contexts: "paper", "notebook", "talk", "poster"
sns.set_context("talk", font_scale=1.2)
```

## Best Practices

1. **Use long-form DataFrames** with meaningful column names
2. **Choose right plot type** based on data types
3. **Use figure-level functions for faceting** (`relplot`, `displot`, `catplot`)
4. **Leverage semantic mappings** (`hue`, `size`, `style`)
5. **Combine with matplotlib** for fine-tuning

```python
ax = sns.scatterplot(data=df, x='x', y='y')
ax.set(xlabel='Custom Label', title='Custom Title')
ax.axhline(y=0, color='r', linestyle='--')
```

## Common Patterns

### Exploratory Data Analysis
```python
# Pairwise relationships
sns.pairplot(data=df, hue='target', corner=True)

# Distribution exploration
sns.displot(data=df, x='variable', hue='group',
            kind='kde', fill=True, col='category')

# Correlation heatmap
corr = df.corr()
sns.heatmap(corr, annot=True, cmap='coolwarm', center=0)
```

### Publication Figures
```python
sns.set_theme(style='ticks', context='paper')
g = sns.catplot(data=df, x='treatment', y='response',
                col='cell_line', kind='box', height=3)
g.set_axis_labels('Treatment', 'Response (μM)')
sns.despine(trim=True)
g.savefig('figure.pdf', dpi=300, bbox_inches='tight')
```

## References

- **`references/function_reference.md`** - All functions with parameters
- **`references/objects_interface.md`** - Modern seaborn.objects API
- **`references/examples.md`** - Common use cases and patterns
