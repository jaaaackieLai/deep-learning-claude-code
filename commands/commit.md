Analyze all uncommitted changes and create small, focused commits grouped by functionality.

No arguments required. Operates on the current working tree.

## Step 1: Survey all changes

Run these commands in parallel to gather the full picture:

```
git status
git diff
git diff --cached
git log --oneline -10
```

For each untracked file, read its content to understand its purpose.

## Step 2: Classify changes into commit groups

Group every changed and untracked file by functionality. Each group becomes one commit.

Grouping rules:
- **docs**: documentation changes (*.md in docs/, TODOs/, etc.)
- **feat/fix/refactor**: code changes in source files
- **test**: test file changes
- **chore**: scripts, configs, CI, tooling (.claude/, scripts/*.sh, etc.)
- **style**: formatting-only changes with no behavior change

Further split within a category if files serve different purposes (e.g., two unrelated docs get separate commits). Prefer many small commits over few large ones.

Follow the Tidy First principle: if a file contains both structural and behavioral changes, note this — but do NOT split a single file's diff across commits unless the hunks are clearly independent.

## Step 3: Present the plan

Show the user a numbered table:

```
| # | Type     | Files                        | Message draft                          |
|---|----------|------------------------------|----------------------------------------|
| 1 | docs     | docs/Framework.md            | docs: update Framework for blind mode  |
| 2 | chore    | scripts/tune_freqshape.sh    | chore: expand grid search parameters   |
| ...                                                                                  |
```

Then proceed to execute immediately — do NOT ask for confirmation.

## Step 4: Execute commits

For each approved group, in order:

1. `git add <specific files>` — never use `git add -A` or `git add .`
2. `git commit` with conventional format message and Co-Authored-By trailer
3. `git status` to verify

Commit message format:
```
<type>: <concise description>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

Use HEREDOC for the commit message to preserve formatting.

## Step 5: Final report

After all commits, run `git log --oneline -<N>` (where N = number of new commits + 3) and show the result.

## Error handling

- If a pre-commit hook fails, fix the issue and create a NEW commit (never --amend).
- If a file appears to contain secrets (.env, API keys, tokens), WARN the user and skip it.
- If the working tree is already clean, report "Nothing to commit" and stop.
