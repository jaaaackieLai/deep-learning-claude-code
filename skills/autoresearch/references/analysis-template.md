# Analysis Template

Jupyter notebook template for analyzing autoresearch experiment results after a session completes.

## Notebook Structure

Create `analysis.ipynb` in the experiment directory with the following cells:

### Cell 1: Load Data

```python
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Load the TSV (tab-separated, 5 columns: commit, <metric>, memory_gb, status, description)
df = pd.read_csv("results.tsv", sep="\t")
# Adjust column name to match your metric
METRIC = "val_bpb"  # Change this to your metric name
LOWER_IS_BETTER = True  # Set False if higher is better

df[METRIC] = pd.to_numeric(df[METRIC], errors="coerce")
df["memory_gb"] = pd.to_numeric(df["memory_gb"], errors="coerce")
df["status"] = df["status"].str.strip().str.upper()

print(f"Total experiments: {len(df)}")
print(f"Columns: {list(df.columns)}")
df.head(10)
```

### Cell 2: Outcome Distribution

```python
counts = df["status"].value_counts()
print("Experiment outcomes:")
print(counts.to_string())

n_keep = counts.get("KEEP", 0)
n_discard = counts.get("DISCARD", 0)
n_crash = counts.get("CRASH", 0)
n_decided = n_keep + n_discard
if n_decided > 0:
    print(f"\nKeep rate: {n_keep}/{n_decided} = {n_keep / n_decided:.1%}")
```

### Cell 3: Kept Experiments

```python
kept = df[df["status"] == "KEEP"].copy()
print(f"KEPT experiments ({len(kept)} total):\n")
for i, row in kept.iterrows():
    metric_val = row[METRIC]
    desc = row["description"]
    print(f"  #{i:3d}  {METRIC}={metric_val:.6f}  mem={row['memory_gb']:.1f}GB  {desc}")
```

### Cell 4: Progress Plot

```python
fig, ax = plt.subplots(figsize=(16, 8))

# Filter out crashes for plotting
valid = df[df["status"] != "CRASH"].copy()
valid = valid.reset_index(drop=True)

baseline = valid.loc[0, METRIC]

# Determine plot bounds based on metric direction
if LOWER_IS_BETTER:
    below = valid[valid[METRIC] <= baseline + 0.0005]
else:
    below = valid[valid[METRIC] >= baseline - 0.0005]

# Discarded as faint dots
disc = below[below["status"] == "DISCARD"]
ax.scatter(disc.index, disc[METRIC],
           c="#cccccc", s=12, alpha=0.5, zorder=2, label="Discarded")

# Kept as prominent green dots
kept_v = below[below["status"] == "KEEP"]
ax.scatter(kept_v.index, kept_v[METRIC],
           c="#2ecc71", s=50, zorder=4, label="Kept", edgecolors="black", linewidths=0.5)

# Running best line
kept_mask = valid["status"] == "KEEP"
kept_idx = valid.index[kept_mask]
kept_metric = valid.loc[kept_mask, METRIC]
running_best = kept_metric.cummin() if LOWER_IS_BETTER else kept_metric.cummax()
ax.step(kept_idx, running_best, where="post", color="#27ae60",
        linewidth=2, alpha=0.7, zorder=3, label="Running best")

# Label each kept experiment
for idx, val in zip(kept_idx, kept_metric):
    desc = str(valid.loc[idx, "description"]).strip()
    if len(desc) > 45:
        desc = desc[:42] + "..."
    ax.annotate(desc, (idx, val),
                textcoords="offset points",
                xytext=(6, 6), fontsize=8.0,
                color="#1a7a3a", alpha=0.9,
                rotation=30, ha="left", va="bottom")

n_total = len(df)
n_kept = len(df[df["status"] == "KEEP"])
ax.set_xlabel("Experiment #", fontsize=12)
ax.set_ylabel(f"{METRIC} ({'lower' if LOWER_IS_BETTER else 'higher'} is better)", fontsize=12)
ax.set_title(f"Autoresearch Progress: {n_total} Experiments, {n_kept} Kept", fontsize=14)
ax.legend(loc="upper right", fontsize=9)
ax.grid(True, alpha=0.2)

# Y-axis bounds
best = kept_metric.min() if LOWER_IS_BETTER else kept_metric.max()
margin = abs(baseline - best) * 0.15
if LOWER_IS_BETTER:
    ax.set_ylim(best - margin, baseline + margin)
else:
    ax.set_ylim(baseline - margin, best + margin)

plt.tight_layout()
plt.savefig("progress.png", dpi=150, bbox_inches="tight")
plt.show()
print("Saved to progress.png")
```

### Cell 5: Summary Statistics

```python
kept = df[df["status"] == "KEEP"].copy()
baseline = df.iloc[0][METRIC]
if LOWER_IS_BETTER:
    best = kept[METRIC].min()
    best_row = kept.loc[kept[METRIC].idxmin()]
    improvement = baseline - best
else:
    best = kept[METRIC].max()
    best_row = kept.loc[kept[METRIC].idxmax()]
    improvement = best - baseline

print(f"Baseline {METRIC}:  {baseline:.6f}")
print(f"Best {METRIC}:      {best:.6f}")
print(f"Total improvement: {improvement:.6f} ({improvement / baseline * 100:.2f}%)")
print(f"Best experiment:   {best_row['description']}")
```

### Cell 6: Top Hits by Improvement Delta

```python
kept = df[df["status"] == "KEEP"].copy()
kept["prev"] = kept[METRIC].shift(1)
if LOWER_IS_BETTER:
    kept["delta"] = kept["prev"] - kept[METRIC]
else:
    kept["delta"] = kept[METRIC] - kept["prev"]

hits = kept.iloc[1:].copy()
hits = hits.sort_values("delta", ascending=False)

print(f"{'Rank':>4}  {'Delta':>8}  {METRIC:>10}  Description")
print("-" * 80)
for rank, (_, row) in enumerate(hits.iterrows(), 1):
    print(f"{rank:4d}  {row['delta']:+.6f}  {row[METRIC]:.6f}  {row['description']}")

print(f"\n{'':>4}  {hits['delta'].sum():+.6f}  {'':>10}  TOTAL improvement over baseline")
```
