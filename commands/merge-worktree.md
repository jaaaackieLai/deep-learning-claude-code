Merge the current worktree branch into main and clean up.

No arguments required. This command auto-detects the current worktree context.

## Pre-flight checks

1. Confirm we are inside a git worktree (not the main working tree):
   ```
   git worktree list
   ```
   Identify the current directory's branch and the main worktree path. If we are already on main, STOP and report "Not in a worktree — nothing to merge."

2. Check for uncommitted changes:
   ```
   git status --short
   ```
   If there are uncommitted changes, run `/commit` to classify and commit them.
   After `/commit` completes, re-run `git status` to confirm the working tree is clean.

3. Collect the branch name and commits that will be merged:
   ```
   git log main..HEAD --oneline
   ```
   Show this list to the user and ask for confirmation before proceeding.

## Merge

4. Switch to the main worktree and merge:
   ```
   cd <main_worktree_path>
   git merge <worktree_branch> --no-ff -m "Merge branch '<worktree_branch>': <one-line summary of changes>"
   ```
   The merge commit message should summarize the branch's changes (read the commit log from step 3).

5. Verify the merge succeeded:
   ```
   git log --oneline -3
   ```

## Cleanup

6. Remove the worktree and delete the branch:
   ```
   git worktree remove <worktree_path>
   git branch -d <worktree_branch>
   ```

7. Report final status:
   - Show `git log --oneline -5` from main
   - Confirm worktree and branch are removed
   - Print the main worktree path so the user knows where to cd

## Error handling

- If the merge has conflicts, do NOT force-resolve. Report the conflicting files and STOP.
- If `git worktree remove` fails because of untracked files, report them and ask the user whether to force-remove.
