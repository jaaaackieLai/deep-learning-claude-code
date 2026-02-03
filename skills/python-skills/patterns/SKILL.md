---
name: python-patterns
description: Use when writing new Python code, reviewing code quality, refactoring for readability, or need guidance on Pythonic idioms, PEP 8 standards, type hints, decorators, context managers, error handling, or performance optimization
---

# Python Development Patterns

Idiomatic Python patterns and best practices for building robust, efficient, and maintainable applications.

## When to Use

- Writing new Python code
- Reviewing Python code quality
- Refactoring for readability and maintainability
- Designing Python packages/modules
- Need guidance on Pythonic idioms and best practices

## Core Principles

1. **Readability Counts** - Code should be obvious and easy to understand
2. **Explicit is Better Than Implicit** - Avoid magic; be clear about what code does
3. **EAFP over LBYL** - Easier to Ask Forgiveness than Permission (use exceptions)

## Quick Start

```python
from typing import Optional
from dataclasses import dataclass

@dataclass
class User:
    """User entity with automatic __init__, __repr__, and __eq__."""
    id: str
    name: str
    email: str
    is_active: bool = True

# EAFP style - Pythonic error handling
def get_value(dictionary: dict, key: str, default=None):
    try:
        return dictionary[key]
    except KeyError:
        return default

# Context manager for resource management
def process_file(path: str) -> str:
    with open(path, 'r') as f:
        return f.read()
```

## Essential Topics

### Type Hints
Modern type annotations for clear interfaces and better tooling support.
**Details:** `references/type_hints.md`

### Error Handling
Specific exceptions, custom hierarchies, and exception chaining.
**Details:** `references/error_handling.md`

### Context Managers
Resource management with `with` statements and custom context managers.
**Details:** `references/context_managers.md`

### Comprehensions and Generators
List comprehensions, generator expressions, and generator functions.
**Details:** `references/comprehensions.md`

### Data Classes
Using `@dataclass` and `NamedTuple` for clean data containers.
**Details:** `references/data_classes.md`

### Decorators
Function and class decorators for cross-cutting concerns.
**Details:** `references/decorators.md`

### Concurrency
Threading, multiprocessing, and async/await patterns.
**Details:** `references/concurrency.md`

### Package Organization
Project structure, imports, and `__init__.py` conventions.
**Details:** `references/package_structure.md`

## Quick Reference

| Idiom | When to Use |
|-------|-------------|
| EAFP (try/except) | Handling expected errors |
| Context managers (`with`) | Resource management |
| List comprehensions | Simple transformations |
| Generators | Lazy evaluation, large datasets |
| Type hints | Function signatures, public APIs |
| Dataclasses | Data containers |
| `__slots__` | Memory optimization |
| f-strings | String formatting (Python 3.6+) |
| `pathlib.Path` | Path operations |

## Tooling Integration

```bash
# Code formatting
black .
isort .

# Linting
ruff check .

# Type checking
mypy .

# Testing with coverage
pytest --cov=mypackage --cov-report=html
```

## Anti-Patterns to Avoid

- Mutable default arguments (`def func(items=[])`)
- Using `type()` instead of `isinstance()`
- Comparing to `None` with `==` instead of `is`
- Bare `except:` clauses
- `from module import *`

**Details:** `references/anti_patterns.md`
