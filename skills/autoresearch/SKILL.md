---
name: autoresearch
description: "Run autonomous deep learning experiments in a loop: modify code, train with fixed time budget, evaluate against a single metric, keep or discard, repeat indefinitely. Use when setting up overnight autonomous research, running hyperparameter sweeps, architecture search, or any iterative experiment loop on a single GPU. Triggers include 'run autoresearch', 'autonomous experiments', 'experiment loop', or 'overnight training'."
---

# Autoresearch

Autonomous deep learning experimentation. An AI agent modifies training code, runs fixed-budget experiments, evaluates results against a single metric, and keeps or discards changes -- looping indefinitely until manually stopped.

Inspired by [karpathy/autoresearch](https://github.com/karpathy/autoresearch): the human writes the program (instructions), the agent writes the code.

## When to Use

- Overnight autonomous hyperparameter/architecture search
- Iterating on model design with a fixed compute budget
- Any deep learning experiment loop where one metric determines success
- When the user wants to sleep while the agent runs experiments

## Prerequisites

Before invoking this skill, ensure:

1. **A training script exists** that the agent will modify. It should:
   - Run on a single GPU
   - Complete within a fixed time budget (default: 5 minutes wall clock)
   - Print a clear summary with the target metric at the end
   - Be self-contained (single file preferred)

2. **An evaluation metric is defined** -- a single scalar, lower-is-better or higher-is-better, printed by the training script. Must be comparable across experiments regardless of what the agent changes (architecture, batch size, etc.).

3. **Data preparation is done** -- any one-time setup (data download, tokenizer training) is already completed.

4. **Dependencies are installed** -- the environment is ready to `uv run` or `python` the training script.

## Core Design Principles

### Single File to Modify

The agent edits exactly one file. This keeps scope manageable and diffs reviewable. Everything else (data loading, evaluation, constants) is read-only.

### Fixed Time Budget

Every experiment runs for the same wall-clock duration regardless of what the agent changes. This makes experiments directly comparable -- a larger model that trains slower is fairly compared against a smaller model that trains faster within the same budget.

### Single Metric

One number decides keep or discard. No multi-objective balancing. The metric must be independent of implementation details (e.g., bits-per-byte instead of cross-entropy loss, so vocab size changes are fairly compared).

### Simplicity Criterion

All else being equal, simpler is better:
- A small improvement that adds ugly complexity? Probably not worth it.
- A small improvement from deleting code? Definitely keep.
- Equal performance but much simpler code? Keep.
- VRAM is a soft constraint: some increase is acceptable for meaningful metric gains, but it should not blow up dramatically.

### Never Stop

Once the loop begins, the agent runs **indefinitely** until manually interrupted. No asking "should I continue?" -- the user might be asleep. If the agent runs out of ideas, it should think harder: re-read the code, try combining near-misses, try radical changes, reverse previous assumptions.

---

## Setup Phase

Work with the user to configure the experiment:

### Step 1: Agree on Scope

Identify:
- **Target file**: The single file the agent will modify (e.g., `train.py`)
- **Read-only files**: Files the agent must NOT modify (e.g., `prepare.py`, `evaluate.py`)
- **Run command**: How to execute an experiment (e.g., `uv run train.py`)
- **Metric name**: The scalar to optimize (e.g., `val_bpb`, `val_accuracy`)
- **Metric direction**: Lower is better, or higher is better
- **Time budget**: Fixed wall-clock training time per experiment (default: 300s)

### Step 2: Create Experiment Branch

```bash
# Propose a tag based on today's date
git checkout -b autoresearch/<tag>
```

The branch must not already exist. Each experiment session gets a fresh branch.

### Step 3: Read In-Scope Files

Read ALL files the agent will work with for full context:
- The target file (will be modified)
- All read-only files (for understanding constraints, APIs, constants)
- README or documentation (for repository context)

### Step 4: Verify Environment

- Check that data/dependencies exist
- Verify the training script runs without errors
- Confirm the metric is printed in the expected format

### Step 5: Initialize Results Log

Create `results.tsv` with a header row:

```
commit	val_bpb	memory_gb	status	description
```

Columns (tab-separated, NOT comma-separated):
1. `commit` -- git short hash (7 chars)
2. Metric value (e.g., `val_bpb`) -- use `0.000000` for crashes
3. `memory_gb` -- peak VRAM in GB, rounded to .1f -- use `0.0` for crashes
4. `status` -- `keep`, `discard`, or `crash`
5. `description` -- short text of what this experiment tried

Do NOT commit `results.tsv` -- leave it untracked by git.

### Step 6: Run Baseline

The very first experiment is always the baseline: run the training script as-is, record the result. This establishes the reference point for all future comparisons.

### Step 7: Confirm and Go

Confirm setup with the user, then begin the experiment loop.

---

## The Experiment Loop

See [references/experiment-protocol.md](./references/experiment-protocol.md) for the complete protocol.

**Summary:**

```
LOOP FOREVER:
  1. Check git state (current branch/commit)
  2. Modify the target file with an experimental idea
  3. git commit the change
  4. Run the experiment (redirect output to run.log)
  5. Extract the metric from run.log
  6. Log results to results.tsv
  7. If improved: KEEP (advance the branch)
  8. If equal or worse: DISCARD (git reset to previous commit)
  9. Repeat
```

Each iteration takes ~5 minutes (the time budget) plus a few seconds for startup/eval overhead. Expect ~12 experiments/hour, ~100 overnight.

---

## Analysis

After the session, use the analysis notebook template to visualize results. See [references/analysis-template.md](./references/analysis-template.md).

Key analyses:
- **Progress plot**: val_bpb over experiment number, with kept experiments highlighted and running minimum line
- **Outcome distribution**: keep/discard/crash counts and rates
- **Top hits**: Kept experiments ranked by improvement delta
- **Summary statistics**: baseline vs best, total improvement percentage

---

## Strategy Tips for the Agent

### Idea Generation

- Start with low-hanging fruit: learning rate, batch size, model depth/width
- Try optimizer hyperparameters: betas, weight decay, warmup/cooldown schedules
- Explore architecture: attention patterns, activation functions, normalization
- Try removing things -- simpler models that match performance are wins
- Combine near-misses: if two ideas each almost worked, try them together
- Re-read the code periodically for angles you missed

### Risk Management

- Make one change at a time to isolate effects
- After a crash, diagnose before moving on -- is it a typo or a fundamental problem?
- If stuck after several failures, revert to the last known good state
- Keep changes small and incremental; radical changes are more likely to crash

### What NOT to Do

- Do NOT modify read-only files
- Do NOT install new packages or add dependencies
- Do NOT modify the evaluation harness
- Do NOT pause to ask the human if you should continue
- Do NOT commit results.tsv

## Reference Files

| File | Purpose |
|------|---------|
| [experiment-protocol.md](./references/experiment-protocol.md) | Detailed experiment loop with crash handling and decision rules |
| [analysis-template.md](./references/analysis-template.md) | Jupyter notebook template for post-session analysis |
