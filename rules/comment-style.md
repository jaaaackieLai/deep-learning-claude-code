# Code Comment Rules

## The Golden Rule
Comment **why**, not **what**. Code shows what happens; comments explain why it happens.

---

## Comment Types

### ✅ Function Comment
Describe purpose, params, return value, and side effects. Place before the function.
```python
def seek_greatest(iterator):
    """
    Find the greatest key in the subtree at the current iterator node.

    Args:
        iterator: RaxIterator positioned at the subtree root.
    Returns:
        The greatest key as bytes, or None if the subtree is empty.
    """
```

### ✅ Design Comment
Place at top of file. Explain the approach and why it was chosen over alternatives.
```python
# DESIGN: One thread + one queue per job type.
# Threads block until a job arrives, then process sequentially.
# Chosen over a shared queue to avoid lock contention on the hot path.
```

### ✅ Why Comment
Explain non-obvious decisions, invariants, or ordering constraints.
```python
# Increment BEFORE processing — if we time out mid-loop,
# the next call resumes from the next DB, not this one.
# This distributes expiry work evenly across all databases.
current_db += 1
```

### ✅ Teacher Comment
Teach the domain concept (math, algorithm, protocol) needed to understand the code.
```python
# A square's corners can be found parametrically on a circle:
#   x = sin(k),  y = cos(k)
# Starting at k = PI/4 and stepping by PI/2 gives four corners.
# To rotate the square, offset the start angle by `rotation_angle`.
def draw_rotated_square(cx, cy, size, rotation_angle):
```

### ✅ Checklist Comment
Warn that modifying this code requires changes elsewhere.
```python
# If you add a new type here, also update get_type_name().
class ObjectType(Enum):
    STRING = 1
    LIST   = 2
```

### ✅ Guide Comment
Divide long functions into named logical sections to reduce cognitive load.
```python
def disconnect_client(client):
    # Free query buffer
    client.query_buf = None

    # Unsubscribe from all pub/sub channels
    pubsub_unsubscribe_all(client)

    # Release blocking-op state
    if client.is_blocked:
        unblock_client(client)
```

---

## Anti-Patterns

### ❌ Trivial Comment — delete it
```python
# BAD
count += 1  # Increment count by one.

# GOOD
count += 1
```

### ❌ Backup Comment — use git instead
```python
# BAD
# for item in old_list:
#     old_logic(item)
new_logic(items)

# GOOD
new_logic(items)
```

### ⚠️ Debt Comment — only with a ticket reference
```python
# BAD
# TODO: optimize this later

# GOOD
# TODO(#1234): compact macro nodes when deleted_ratio > 0.5
```

---

## Quick Checklist
- [ ] Non-trivial functions have a docstring (purpose, args, returns, side effects)
- [ ] Complex modules have a design comment at the top
- [ ] Surprising or non-obvious code has a why comment
- [ ] No comments that just restate what the code does
- [ ] No commented-out code — delete it
- [ ] Every TODO references an issue tracker ticket
- [ ] Comments are updated when the code changes