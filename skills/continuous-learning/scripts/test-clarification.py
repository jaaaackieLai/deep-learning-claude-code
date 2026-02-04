#!/usr/bin/env python3
"""
Test script for clarification detection system

Creates mock observation data to test the correction detection pipeline:
1. Generate realistic observation sequences with correction patterns
2. Run the detection logic
3. Trigger analysis
4. Verify output
"""

import json
import subprocess
import sys
import tempfile
from datetime import datetime, timedelta
from pathlib import Path

# Test configuration
TEST_DIR = Path(tempfile.mkdtemp(prefix="continuous-learning-test-"))
OBSERVATIONS_FILE = TEST_DIR / "observations.jsonl"
CLARIFICATIONS_DIR = TEST_DIR / "clarifications"
CLARIFICATIONS_DIR.mkdir(parents=True, exist_ok=True)

print(f"Test directory: {TEST_DIR}")
print("=" * 60)

# ─────────────────────────────────────────────
# Test Scenarios
# ─────────────────────────────────────────────

def generate_timestamp(offset_seconds=0):
    """Generate ISO timestamp with offset from now"""
    return (datetime.now() + timedelta(seconds=offset_seconds)).isoformat() + "Z"

# Scenario 1: Rapid re-edit (user corrects approach)
scenario_1_rapid_edit = [
    {
        "timestamp": generate_timestamp(0),
        "event": "tool_start",
        "tool": "Read",
        "session": "test-session-1",
        "input": '{"file_path": "/test/app.py"}'
    },
    {
        "timestamp": generate_timestamp(1),
        "event": "tool_complete",
        "tool": "Read",
        "session": "test-session-1",
        "output": "def hello(): pass"
    },
    {
        "timestamp": generate_timestamp(2),
        "event": "tool_start",
        "tool": "Edit",
        "session": "test-session-1",
        "input": '{"file_path": "/test/app.py", "old_string": "def hello(): pass", "new_string": "def hello():\\n    return \\"world\\""}'
    },
    {
        "timestamp": generate_timestamp(3),
        "event": "tool_complete",
        "tool": "Edit",
        "session": "test-session-1",
        "output": "File updated successfully"
    },
    # User correction: "No, I meant greeting, not hello"
    {
        "timestamp": generate_timestamp(5),
        "event": "tool_start",
        "tool": "Edit",
        "session": "test-session-1",
        "input": '{"file_path": "/test/app.py", "old_string": "def hello():", "new_string": "def greeting():"}'
    },
    {
        "timestamp": generate_timestamp(6),
        "event": "tool_complete",
        "tool": "Edit",
        "session": "test-session-1",
        "output": "File updated successfully"
    },
    # Another correction: "Actually, add a parameter"
    {
        "timestamp": generate_timestamp(8),
        "event": "tool_start",
        "tool": "Edit",
        "session": "test-session-1",
        "input": '{"file_path": "/test/app.py", "old_string": "def greeting():", "new_string": "def greeting(name):"}'
    },
    {
        "timestamp": generate_timestamp(9),
        "event": "tool_complete",
        "tool": "Edit",
        "session": "test-session-1",
        "output": "File updated successfully"
    }
]

# Scenario 2: Error then success (misunderstood requirement)
scenario_2_error_recovery = [
    {
        "timestamp": generate_timestamp(10),
        "event": "tool_start",
        "tool": "Bash",
        "session": "test-session-2",
        "input": "npm test"
    },
    {
        "timestamp": generate_timestamp(11),
        "event": "tool_complete",
        "tool": "Bash",
        "session": "test-session-2",
        "output": "Error: Test suite failed. TypeError: Cannot read property 'foo' of undefined"
    },
    # User clarifies: "You need to mock the API first"
    {
        "timestamp": generate_timestamp(13),
        "event": "tool_start",
        "tool": "Edit",
        "session": "test-session-2",
        "input": '{"file_path": "/test/test.js", "old_string": "import api", "new_string": "import mockApi as api"}'
    },
    {
        "timestamp": generate_timestamp(14),
        "event": "tool_complete",
        "tool": "Edit",
        "session": "test-session-2",
        "output": "File updated successfully"
    },
    {
        "timestamp": generate_timestamp(15),
        "event": "tool_start",
        "tool": "Bash",
        "session": "test-session-2",
        "input": "npm test"
    },
    {
        "timestamp": generate_timestamp(16),
        "event": "tool_complete",
        "tool": "Bash",
        "session": "test-session-2",
        "output": "All tests passed! 15 tests, 0 failures"
    }
]

# Scenario 3: Repeated tool usage (iterative refinement)
scenario_3_repeated_tool = [
    {
        "timestamp": generate_timestamp(20),
        "event": "tool_start",
        "tool": "Write",
        "session": "test-session-3",
        "input": '{"file_path": "/test/config.json"}'
    },
    {
        "timestamp": generate_timestamp(21),
        "event": "tool_complete",
        "tool": "Write",
        "session": "test-session-3",
        "output": "File created"
    },
    {
        "timestamp": generate_timestamp(23),
        "event": "tool_start",
        "tool": "Write",
        "session": "test-session-3",
        "input": '{"file_path": "/test/config.json"}'
    },
    {
        "timestamp": generate_timestamp(24),
        "event": "tool_complete",
        "tool": "Write",
        "session": "test-session-3",
        "output": "File updated"
    },
    {
        "timestamp": generate_timestamp(26),
        "event": "tool_start",
        "tool": "Write",
        "session": "test-session-3",
        "input": '{"file_path": "/test/config.json"}'
    },
    {
        "timestamp": generate_timestamp(27),
        "event": "tool_complete",
        "tool": "Write",
        "session": "test-session-3",
        "output": "File updated"
    }
]

# ─────────────────────────────────────────────
# Test Execution
# ─────────────────────────────────────────────

def write_observations(observations):
    """Write observations to test file"""
    with open(OBSERVATIONS_FILE, 'w') as f:
        for obs in observations:
            f.write(json.dumps(obs) + '\n')

def run_analysis():
    """Run the analyze-correction.py script"""
    script_path = Path(__file__).parent / "analyze-correction.py"

    # Set environment to use test directory
    import os

    # Create .claude/homunculus structure in test dir
    test_home = TEST_DIR.parent
    homunculus_dir = test_home / ".claude" / "homunculus"
    homunculus_dir.mkdir(parents=True, exist_ok=True)
    (homunculus_dir / "clarifications").mkdir(parents=True, exist_ok=True)

    # Copy observations to expected location
    expected_obs = homunculus_dir / "observations.jsonl"
    import shutil
    if OBSERVATIONS_FILE != expected_obs:
        shutil.copy(OBSERVATIONS_FILE, expected_obs)

    # Run analysis with modified HOME
    result = subprocess.run(
        [sys.executable, str(script_path), "--last-turns", "5"],
        capture_output=True,
        text=True,
        cwd=script_path.parent,
        env={**os.environ, 'HOME': str(test_home)}
    )

    # Copy clarifications back to TEST_DIR for checking
    clarif_dir = homunculus_dir / "clarifications"
    for cf in clarif_dir.glob("*.yaml"):
        shutil.copy(cf, CLARIFICATIONS_DIR)

    return result

def check_clarifications():
    """Check if clarification files were created"""
    clarifications = list(CLARIFICATIONS_DIR.glob("*.yaml"))
    return clarifications

# ─────────────────────────────────────────────
# Run Tests
# ─────────────────────────────────────────────

print("\n## Test 1: Rapid Re-edit Pattern")
print("-" * 60)
write_observations(scenario_1_rapid_edit)
print(f"✓ Created {len(scenario_1_rapid_edit)} observation events")
print("  Pattern: Read → Edit → Edit → Edit (same file)")
print("  Expected: Detection of 'rapid_re_edit' pattern")

result = run_analysis()
print(f"\nAnalysis output:")
print(result.stdout)
if result.stderr:
    print(f"Warnings/Errors:\n{result.stderr}")

clarifications = check_clarifications()
print(f"\n✓ Generated {len(clarifications)} clarification files")
for cf in clarifications:
    print(f"  - {cf.name}")
    content = cf.read_text()
    # Extract hint from YAML
    if "## Hint" in content:
        hint_start = content.index("## Hint") + len("## Hint")
        hint_section = content[hint_start:].split("##")[0].strip()
        print(f"    Hint: {hint_section[:100]}...")

print("\n" + "=" * 60)

print("\n## Test 2: Error Recovery Pattern")
print("-" * 60)
# Clear previous test
OBSERVATIONS_FILE.unlink()
for cf in CLARIFICATIONS_DIR.glob("*.yaml"):
    cf.unlink()

write_observations(scenario_2_error_recovery)
print(f"✓ Created {len(scenario_2_error_recovery)} observation events")
print("  Pattern: Bash(error) → Edit → Bash(success)")
print("  Expected: Detection of 'error_then_success' pattern")

result = run_analysis()
print(f"\nAnalysis output:")
print(result.stdout)
if result.stderr:
    print(f"Warnings/Errors:\n{result.stderr}")

clarifications = check_clarifications()
print(f"\n✓ Generated {len(clarifications)} clarification files")
for cf in clarifications:
    print(f"  - {cf.name}")

print("\n" + "=" * 60)

print("\n## Test 3: Repeated Tool Usage")
print("-" * 60)
# Clear previous test
OBSERVATIONS_FILE.unlink()
for cf in CLARIFICATIONS_DIR.glob("*.yaml"):
    cf.unlink()

write_observations(scenario_3_repeated_tool)
print(f"✓ Created {len(scenario_3_repeated_tool)} observation events")
print("  Pattern: Write → Write → Write (same file)")
print("  Expected: Detection of 'repeated_tool' pattern")

result = run_analysis()
print(f"\nAnalysis output:")
print(result.stdout)
if result.stderr:
    print(f"Warnings/Errors:\n{result.stderr}")

clarifications = check_clarifications()
print(f"\n✓ Generated {len(clarifications)} clarification files")
for cf in clarifications:
    print(f"  - {cf.name}")

print("\n" + "=" * 60)

# Summary
print("\n## Test Summary")
print("-" * 60)
print(f"Test directory: {TEST_DIR}")
print(f"All test scenarios completed.")
print(f"\nTo inspect results:")
print(f"  ls {CLARIFICATIONS_DIR}")
print(f"  cat {CLARIFICATIONS_DIR}/*.yaml")
print(f"\nTo clean up:")
print(f"  rm -rf {TEST_DIR}")
