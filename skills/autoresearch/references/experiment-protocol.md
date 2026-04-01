# Experiment Protocol

Detailed rules for the autonomous experiment loop. The agent follows this protocol without human intervention.

## Loop Structure

```
LOOP FOREVER:
  1. Observe    -- check git state
  2. Hypothesize -- form an experimental idea
  3. Implement  -- modify the target file
  4. Commit     -- git commit the change
  5. Execute    -- run the experiment
  6. Evaluate   -- extract and interpret results
  7. Decide     -- keep, discard, or handle crash
  8. Log        -- record in results.tsv
  9. Repeat
```

## Step-by-Step

### 1. Observe

Check the current git state:

```bash
git log --oneline -5
git status
```

Confirm you are on the experiment branch and the working tree is clean.

### 2. Hypothesize

Form a clear, testable hypothesis:
- "Increasing learning rate from 0.02 to 0.04 will improve convergence within the time budget"
- "Replacing ReLU^2 with SwiGLU may improve expressiveness"
- "Reducing model depth from 12 to 8 and increasing width may be more efficient"

One change per experiment. Isolate variables.

### 3. Implement

Edit the target file to implement the hypothesis. Keep changes minimal and clean.

### 4. Commit

```bash
git add <target-file>
git commit -m "<short description of the change>"
```

Commit BEFORE running so the change is tracked regardless of outcome.

### 5. Execute

Run the experiment with output redirected:

```bash
uv run <training-script> > run.log 2>&1
```

Redirect everything -- do NOT use `tee` or let output flood the agent's context window. The training script runs for the fixed time budget and prints a summary at the end.

**Timeout**: If a run exceeds 2x the time budget (e.g., 10 minutes for a 5-minute budget), kill it and treat as a failure.

### 6. Evaluate

Extract the metric from the log:

```bash
grep "^<metric_name>:" run.log
grep "^peak_vram_mb:" run.log
```

If `grep` returns empty, the run crashed. Read the stack trace:

```bash
tail -n 50 run.log
```

### 7. Decide

#### KEEP -- metric improved (lower for lower-is-better, higher for higher-is-better)

The experiment is a success. The branch advances. This commit becomes the new baseline for future comparisons.

Apply the simplicity criterion:
- Tiny improvement + significant complexity added = consider discarding
- Any improvement from removing code = always keep
- Equal metric + simpler code = keep

#### DISCARD -- metric is equal or worse

Reset to the previous commit:

```bash
git reset --hard HEAD~1
```

The change is discarded. Try a different idea.

#### CRASH -- the run failed

Diagnose the failure:

1. **Trivial fix** (typo, missing import, shape mismatch): Fix it, amend the commit, re-run.
2. **OOM**: The idea requires too much memory. Discard unless you can reduce memory (smaller batch size, gradient checkpointing, etc.).
3. **Fundamental problem** (the approach itself is broken): Log as crash, discard, move on.

If you cannot get a crashed experiment to work after 2-3 fix attempts, give up on that idea.

### 8. Log

Append to `results.tsv`:

```
<commit-hash>	<metric-value>	<memory-gb>	<status>	<description>
```

Example entries:

```
a1b2c3d	0.997900	44.0	keep	baseline
b2c3d4e	0.993200	44.2	keep	increase LR to 0.04
c3d4e5f	1.005000	44.0	discard	switch to GeLU activation
d4e5f6g	0.000000	0.0	crash	double model width (OOM)
```

Do NOT commit `results.tsv`.

---

## Decision Flowchart

```
Experiment complete
    |
    +-- Did it crash?
    |     |
    |     +-- YES: Can you fix it in 2-3 attempts?
    |     |         |
    |     |         +-- YES: Fix, re-run
    |     |         +-- NO:  Log crash, git reset, move on
    |     |
    |     +-- NO: Did the metric improve?
    |               |
    |               +-- YES: Does it pass the simplicity criterion?
    |               |         |
    |               |         +-- YES: KEEP
    |               |         +-- NO:  DISCARD (marginal gain, too much complexity)
    |               |
    |               +-- NO:  Is the code simpler with equal metric?
    |                         |
    |                         +-- YES: KEEP (simplification win)
    |                         +-- NO:  DISCARD
```

---

## Stuck Recovery

If you run out of ideas or hit a plateau:

1. **Re-read all in-scope files** from scratch. Fresh eyes catch missed opportunities.
2. **Review results.tsv** to find patterns: what kinds of changes helped? What didn't?
3. **Combine near-misses**: If experiment A almost helped and experiment B almost helped, try A+B together.
4. **Try the opposite**: If small models didn't help, try bigger. If higher LR didn't help, try lower.
5. **Explore radical changes**: Different architecture entirely, different optimizer, different training strategy.
6. **Remove things**: Simplification experiments often surprise with equal or better results.

Never stop. The user expects you to run until interrupted.

---

## Context Management

The agent's context window is finite. To manage it:

- Always redirect experiment output to `run.log` instead of printing to stdout
- Extract only the relevant metrics with `grep`, not full logs
- Use `tail -n 50 run.log` for crash diagnosis, not the full log
- Periodically summarize progress mentally: "best so far is X, last 5 experiments tried Y"
