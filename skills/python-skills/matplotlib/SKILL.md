---
name: matplotlib
description: Use when creating static plots, charts, or visualizations (line, scatter, bar, histogram, heatmap, contour), customizing plot appearance, creating multi-panel figures, exporting to PNG/PDF/SVG, building interactive plots or animations, working with 3D visualizations, or need fine-grained control over plot elements
---

# Matplotlib

Matplotlib is Python's foundational visualization library for creating static, animated, and interactive plots.

## When to Use

- Creating plots or charts (line, scatter, bar, histogram, heatmap, contour, etc.)
- Scientific or statistical visualizations
- Customizing plot appearance (colors, styles, labels, legends)
- Multi-panel figures with subplots
- Exporting visualizations (PNG, PDF, SVG)
- 3D visualizations
- Fine-grained control over every plot element

## Quick Start

```python
import matplotlib.pyplot as plt
import numpy as np

# Object-Oriented Interface (RECOMMENDED)
fig, ax = plt.subplots(figsize=(10, 6))

x = np.linspace(0, 2*np.pi, 100)
ax.plot(x, np.sin(x), label='sin(x)')
ax.plot(x, np.cos(x), label='cos(x)')

ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_title('Trigonometric Functions')
ax.legend()
ax.grid(True, alpha=0.3)

plt.savefig('plot.png', dpi=300, bbox_inches='tight')
plt.show()
```

## Core Concepts

**Two Interfaces:**
1. **pyplot** (MATLAB-style) - Quick interactive plots
2. **Object-Oriented** (recommended) - Explicit control, better for complex figures

**Hierarchy:**
- **Figure** - Top-level container
- **Axes** - Actual plotting area (not "Axis")
- **Axis** - X and Y axes with ticks/labels

## Essential Workflows

### Multiple Subplots
```python
fig, axes = plt.subplots(2, 2, figsize=(12, 10))
axes[0, 0].plot(x, y1)
axes[0, 1].scatter(x, y2)
axes[1, 0].bar(categories, values)
axes[1, 1].hist(data, bins=30)
```

### Plot Types
- **Line plots** - Time series, trends
- **Scatter plots** - Relationships, correlations
- **Bar charts** - Categorical comparisons
- **Histograms** - Distributions
- **Heatmaps** - Matrix data, correlations
- **Contour plots** - 3D data on 2D plane

**Comprehensive examples:** `references/plot_types.md`

### Styling
```python
# Use style sheets
plt.style.use('seaborn-v0_8-darkgrid')

# Customize with rcParams
plt.rcParams['font.size'] = 12
plt.rcParams['axes.labelsize'] = 14
```

**Styling guide:** `references/styling_guide.md`

### Saving Figures
```python
# High-resolution PNG (300 dpi for publications)
plt.savefig('figure.png', dpi=300, bbox_inches='tight', facecolor='white')

# Vector formats (scalable)
plt.savefig('figure.pdf', bbox_inches='tight')
plt.savefig('figure.svg', bbox_inches='tight')
```

## Quick Reference

| Task | Method |
|------|--------|
| Create figure | `fig, ax = plt.subplots()` |
| Line plot | `ax.plot(x, y)` |
| Scatter plot | `ax.scatter(x, y)` |
| Bar chart | `ax.bar(categories, values)` |
| Histogram | `ax.hist(data, bins=30)` |
| Labels | `ax.set_xlabel()`, `ax.set_ylabel()`, `ax.set_title()` |
| Legend | `ax.legend()` |
| Grid | `ax.grid(True)` |
| Save | `plt.savefig('file.png', dpi=300)` |

## Best Practices

1. **Use OO interface** - `fig, ax = plt.subplots()` for all production code
2. **Set figsize at creation** - `figsize=(10, 6)`
3. **Use constrained_layout** - `constrained_layout=True` to prevent overlaps
4. **Choose colorblind-friendly colormaps** - viridis, cividis
5. **Appropriate DPI** - 72 for screen, 150 for web, 300 for print

## Scripts

- **`scripts/plot_template.py`** - Template for creating visualizations
- **`scripts/style_configurator.py`** - Interactive style configuration

## References

- **`references/plot_types.md`** - Complete plot type catalog
- **`references/styling_guide.md`** - Styling and colormaps
- **`references/api_reference.md`** - Core classes and methods
- **`references/common_issues.md`** - Troubleshooting guide
