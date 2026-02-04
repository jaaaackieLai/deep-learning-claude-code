---
description: Enforce test-driven development workflow. Scaffold interfaces, generate tests FIRST, then implement minimal code to pass. Ensure 80%+ coverage.
---

# TDD Command

This command invokes the **tdd-guide** agent to enforce test-driven development methodology.

## What This Command Does

1. **Scaffold Interfaces** - Define types/interfaces first
2. **Generate Tests First** - Write failing tests (RED)
3. **Implement Minimal Code** - Write just enough to pass (GREEN)
4. **Refactor** - Improve code while keeping tests green (REFACTOR)
5. **Verify Coverage** - Ensure 80%+ test coverage

## When to Use

Use `/tdd` when:
- Implementing new features
- Adding new functions/components
- Fixing bugs (write test that reproduces bug first)
- Refactoring existing code
- Building critical business logic

## How It Works

The tdd-guide agent will:

1. **Define interfaces** for inputs/outputs
2. **Write tests that will FAIL** (because code doesn't exist yet)
3. **Run tests** and verify they fail for the right reason
4. **Write minimal implementation** to make tests pass
5. **Run tests** and verify they pass
6. **Refactor** code while keeping tests green
7. **Check coverage** and add more tests if below 80%

## TDD Cycle

```
RED → GREEN → REFACTOR → REPEAT

RED:      Write a failing test
GREEN:    Write minimal code to pass
REFACTOR: Improve code, keep tests passing
REPEAT:   Next feature/scenario
```

## Example Usage

```
User: /tdd I need a function to calculate market liquidity score

Agent (tdd-guide):
# TDD Session: Market Liquidity Score Calculator

## Step 1: Define Interface (SCAFFOLD)

```python
# src/liquidity.py
from dataclasses import dataclass
from datetime import datetime

@dataclass
class MarketData:
    total_volume: float
    bid_ask_spread: float
    active_traders: int
    last_trade_time: datetime

def calculate_liquidity_score(market: MarketData) -> float:
    """Calculate market liquidity score (0-100)."""
    # TODO: Implementation
    raise NotImplementedError('Not implemented')
```

## Step 2: Write Failing Test (RED)

```python
# tests/test_liquidity.py
import pytest
from datetime import datetime, timedelta
from src.liquidity import calculate_liquidity_score, MarketData

def test_high_score_for_liquid_market():
    """Should return high score for liquid market"""
    market = MarketData(
        total_volume=100000,
        bid_ask_spread=0.01,
        active_traders=500,
        last_trade_time=datetime.now()
    )

    score = calculate_liquidity_score(market)

    assert score > 80
    assert score <= 100

def test_low_score_for_illiquid_market():
    """Should return low score for illiquid market"""
    market = MarketData(
        total_volume=100,
        bid_ask_spread=0.5,
        active_traders=2,
        last_trade_time=datetime.now() - timedelta(days=1)
    )

    score = calculate_liquidity_score(market)

    assert score < 30
    assert score >= 0

def test_handle_zero_volume():
    """Should handle edge case: zero volume"""
    market = MarketData(
        total_volume=0,
        bid_ask_spread=0,
        active_traders=0,
        last_trade_time=datetime.now()
    )

    score = calculate_liquidity_score(market)

    assert score == 0
```

## Step 3: Run Tests - Verify FAIL

```bash
pytest tests/test_liquidity.py

FAILED tests/test_liquidity.py::test_high_score_for_liquid_market
  NotImplementedError: Not implemented

1 failed, 0 passed
```

✅ Tests fail as expected. Ready to implement.

## Step 4: Implement Minimal Code (GREEN)

```python
# src/liquidity.py
from datetime import datetime

def calculate_liquidity_score(market: MarketData) -> float:
    """Calculate market liquidity score (0-100)."""
    # Handle zero volume edge case
    if market.total_volume == 0:
        return 0.0

    # Calculate component scores (0-100 scale)
    volume_score = min(market.total_volume / 1000, 100)
    spread_score = max(100 - (market.bid_ask_spread * 1000), 0)
    trader_score = min(market.active_traders / 10, 100)

    # Recent activity bonus
    hours_since_last_trade = (datetime.now() - market.last_trade_time).total_seconds() / 3600
    recency_score = max(100 - (hours_since_last_trade * 10), 0)

    # Weighted average
    score = (
        volume_score * 0.4 +
        spread_score * 0.3 +
        trader_score * 0.2 +
        recency_score * 0.1
    )

    return max(min(score, 100), 0)  # Clamp to 0-100
```

## Step 5: Run Tests - Verify PASS

```bash
pytest tests/test_liquidity.py

PASSED tests/test_liquidity.py::test_high_score_for_liquid_market
PASSED tests/test_liquidity.py::test_low_score_for_illiquid_market
PASSED tests/test_liquidity.py::test_handle_zero_volume

3 passed
```

✅ All tests passing!

## Step 6: Refactor (IMPROVE)

```python
# src/liquidity.py - Refactored with constants and better readability
from dataclasses import dataclass
from datetime import datetime

# Constants
WEIGHTS = {
    'VOLUME': 0.4,
    'SPREAD': 0.3,
    'TRADERS': 0.2,
    'RECENCY': 0.1,
}

SCALE_FACTORS = {
    'VOLUME': 1000,
    'SPREAD': 1000,
    'TRADERS': 10,
    'RECENCY_PENALTY': 10,
}

def clamp(value: float, min_val: float, max_val: float) -> float:
    """Clamp value between min and max."""
    return max(min(value, max_val), min_val)

@dataclass
class MarketData:
    total_volume: float
    bid_ask_spread: float
    active_traders: int
    last_trade_time: datetime

def calculate_liquidity_score(market: MarketData) -> float:
    """Calculate market liquidity score (0-100)."""
    if market.total_volume == 0:
        return 0.0

    volume_score = min(market.total_volume / SCALE_FACTORS['VOLUME'], 100)
    spread_score = clamp(100 - (market.bid_ask_spread * SCALE_FACTORS['SPREAD']), 0, 100)
    trader_score = min(market.active_traders / SCALE_FACTORS['TRADERS'], 100)

    hours_since_last_trade = (datetime.now() - market.last_trade_time).total_seconds() / 3600
    recency_score = clamp(100 - (hours_since_last_trade * SCALE_FACTORS['RECENCY_PENALTY']), 0, 100)

    weighted_score = (
        volume_score * WEIGHTS['VOLUME'] +
        spread_score * WEIGHTS['SPREAD'] +
        trader_score * WEIGHTS['TRADERS'] +
        recency_score * WEIGHTS['RECENCY']
    )

    return clamp(weighted_score, 0, 100)
```

## Step 7: Verify Tests Still Pass

```bash
pytest tests/test_liquidity.py

PASSED tests/test_liquidity.py::test_high_score_for_liquid_market
PASSED tests/test_liquidity.py::test_low_score_for_illiquid_market
PASSED tests/test_liquidity.py::test_handle_zero_volume

3 passed
```

✅ Refactoring complete, tests still passing!

## Step 8: Check Coverage

```bash
pytest --cov=src/liquidity --cov-report=term-missing tests/test_liquidity.py

Name              Stmts   Miss  Cover   Missing
-----------------------------------------------
src/liquidity.py     25      0   100%
-----------------------------------------------
TOTAL                25      0   100%

Coverage: 100% ✅ (Target: 80%)
```

✅ TDD session complete!
```

## TDD Best Practices

**DO:**
- ✅ Write the test FIRST, before any implementation
- ✅ Run tests and verify they FAIL before implementing
- ✅ Write minimal code to make tests pass
- ✅ Refactor only after tests are green
- ✅ Add edge cases and error scenarios
- ✅ Aim for 80%+ coverage (100% for critical code)

**DON'T:**
- ❌ Write implementation before tests
- ❌ Skip running tests after each change
- ❌ Write too much code at once
- ❌ Ignore failing tests
- ❌ Test implementation details (test behavior)
- ❌ Mock everything (prefer integration tests)

## Test Types to Include

**Unit Tests** (Function-level):
- Happy path scenarios
- Edge cases (empty, null, max values)
- Error conditions
- Boundary values

**Integration Tests** (Component-level):
- API endpoints
- Database operations
- External service calls
- React components with hooks

**E2E Tests** (use `/e2e` command):
- Critical user flows
- Multi-step processes
- Full stack integration

## Coverage Requirements

- **80% minimum** for all code
- **100% required** for:
  - Financial calculations
  - Authentication logic
  - Security-critical code
  - Core business logic

## Important Notes

**MANDATORY**: Tests must be written BEFORE implementation. The TDD cycle is:

1. **RED** - Write failing test
2. **GREEN** - Implement to pass
3. **REFACTOR** - Improve code

Never skip the RED phase. Never write code before tests.

## Integration with Other Commands

- Use `/plan` first to understand what to build
- Use `/tdd` to implement with tests
- Use `/code-review` to review implementation
- Use `/test-coverage` to verify coverage

## Related Agents

This command invokes the `tdd-guide` agent located at:
`agents/tdd-guide.md`

The tdd-guide agent integrates with:
- `python-skills/testing` - For pytest and testing best practices
- `python-skills/patterns` - For testable design patterns
