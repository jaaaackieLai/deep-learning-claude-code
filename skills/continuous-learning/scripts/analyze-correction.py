#!/usr/bin/env python3
"""
Analyze Correction - Lightweight misunderstanding detector

Analyzes recent observations to detect corrections/misunderstandings
and generates clarification hints. Uses Haiku for cost efficiency.

Usage:
  analyze-correction.py [--last-turns N]

This script is designed to:
1. Read last N observation events from observations.jsonl
2. Detect correction patterns using lightweight heuristics
3. Use Haiku to analyze potential misunderstandings
4. Generate minimal clarification hints (50-100 words)
"""

import argparse
import json
import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Optional

# ─────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────

HOMUNCULUS_DIR = Path.home() / ".claude" / "homunculus"
OBSERVATIONS_FILE = HOMUNCULUS_DIR / "observations.jsonl"
CLARIFICATIONS_DIR = HOMUNCULUS_DIR / "clarifications"
TRIGGER_FILE = CLARIFICATIONS_DIR / ".trigger"
CONFIG_FILE = Path(__file__).parent.parent / "config.json"

# Ensure directories exist
CLARIFICATIONS_DIR.mkdir(parents=True, exist_ok=True)

# ─────────────────────────────────────────────
# Configuration Loading
# ─────────────────────────────────────────────

def load_config() -> dict:
    """Load configuration from config.json"""
    if CONFIG_FILE.exists():
        try:
            return json.loads(CONFIG_FILE.read_text())
        except Exception as e:
            print(f"Warning: Failed to load config: {e}", file=sys.stderr)
    return {}

# ─────────────────────────────────────────────
# Observation Loading
# ─────────────────────────────────────────────

def load_recent_observations(last_n: int = 5) -> list[dict]:
    """Load the last N observation events from observations.jsonl"""
    if not OBSERVATIONS_FILE.exists():
        return []

    observations = []
    try:
        with open(OBSERVATIONS_FILE, 'r') as f:
            lines = f.readlines()
            # Get last N lines
            recent_lines = lines[-last_n * 2:] if len(lines) > last_n * 2 else lines
            for line in recent_lines:
                if line.strip():
                    observations.append(json.loads(line))
    except Exception as e:
        print(f"Error reading observations: {e}", file=sys.stderr)
        return []

    return observations[-last_n * 2:]  # Return last N tool pairs (start + complete)

# ─────────────────────────────────────────────
# Pattern Analysis
# ─────────────────────────────────────────────

def analyze_correction_pattern(observations: list[dict], trigger_data: Optional[dict] = None) -> Optional[dict]:
    """
    Analyze observations to determine if a correction occurred.
    Returns a summary of the correction pattern if detected, None otherwise.
    """
    if len(observations) < 2:
        return None

    correction_type = None
    confidence = 0.5
    evidence = []

    # Check for trigger data
    if trigger_data:
        signals = trigger_data.get('signals', [])
        if signals:
            # Use the highest confidence signal
            best_signal = max(signals, key=lambda s: s.get('confidence', 0))
            correction_type = best_signal.get('type', 'unknown')
            confidence = best_signal.get('confidence', 0.5)
            evidence.append(f"Detected by hook: {correction_type}")

    # Additional analysis from observations
    tool_sequence = [obs.get('tool') for obs in observations]

    # Rapid tool repetition suggests iteration/correction
    if len(set(tool_sequence[-3:])) <= 2 and len(tool_sequence) >= 3:
        evidence.append(f"Rapid tool iteration: {' → '.join(tool_sequence[-3:])}")
        confidence = max(confidence, 0.6)
        if not correction_type:
            correction_type = "iterative_correction"

    # Error recovery pattern
    error_found = False
    for obs in observations:
        output = str(obs.get('output', '')).lower()
        if any(err in output for err in ['error', 'failed', 'exception']):
            error_found = True
            evidence.append(f"Error detected in {obs.get('tool')} output")
            break

    if error_found:
        confidence = max(confidence, 0.7)
        if not correction_type:
            correction_type = "error_recovery"

    if not correction_type and len(evidence) == 0:
        return None

    return {
        'type': correction_type or 'unknown_correction',
        'confidence': confidence,
        'evidence': evidence,
        'tool_sequence': tool_sequence[-5:],
        'observation_count': len(observations)
    }

# ─────────────────────────────────────────────
# AI Analysis (using Anthropic API)
# ─────────────────────────────────────────────

def generate_clarification_hint(pattern: dict, observations: list[dict]) -> Optional[str]:
    """
    Use Haiku to generate a concise clarification hint based on the correction pattern.

    This function attempts to call the Anthropic API with Haiku model.
    If the API is not available, it falls back to a rule-based hint.
    """
    try:
        import anthropic

        # Get API key from environment
        api_key = os.environ.get('ANTHROPIC_API_KEY')
        if not api_key:
            print("Warning: ANTHROPIC_API_KEY not set, using fallback", file=sys.stderr)
            return generate_fallback_hint(pattern)

        client = anthropic.Anthropic(api_key=api_key)

        # Prepare context (truncated observations)
        context = []
        for obs in observations[-5:]:
            tool = obs.get('tool', 'unknown')
            event = obs.get('event', 'unknown')
            # Only include minimal info to save tokens
            if event == 'tool_start':
                context.append(f"Tool: {tool}")
            elif event == 'tool_complete':
                output = str(obs.get('output', ''))[:200]  # Truncate output
                if 'error' in output.lower() or 'failed' in output.lower():
                    context.append(f"{tool} → Error")
                else:
                    context.append(f"{tool} → Success")

        context_str = '\n'.join(context)

        # Call Haiku with minimal prompt
        prompt = f"""Analyze this tool usage sequence for potential misunderstanding:

{context_str}

Pattern detected: {pattern['type']} (confidence: {pattern['confidence']:.0%})
Evidence: {'; '.join(pattern['evidence'])}

Generate a concise clarification hint (max 50 words) that describes:
1. What likely went wrong
2. What to clarify next time

Format: "When [trigger], clarify [question] before proceeding."
"""

        response = client.messages.create(
            model="claude-haiku-20250318",
            max_tokens=150,
            messages=[{"role": "user", "content": prompt}]
        )

        hint = response.content[0].text.strip()
        return hint

    except ImportError:
        print("Warning: anthropic package not installed, using fallback", file=sys.stderr)
        return generate_fallback_hint(pattern)
    except Exception as e:
        print(f"Warning: API call failed ({e}), using fallback", file=sys.stderr)
        return generate_fallback_hint(pattern)

def generate_fallback_hint(pattern: dict) -> str:
    """Generate a rule-based hint when API is unavailable"""
    correction_type = pattern['type']

    hints = {
        'rapid_re_edit': 'When editing files multiple times quickly, clarify the expected outcome first to avoid rework.',
        'error_then_success': 'When encountering errors, clarify the root cause before attempting fixes.',
        'repeated_tool': 'When using the same tool repeatedly, consider whether the initial approach needs clarification.',
        'iterative_correction': 'When iterating rapidly on a task, verify understanding of the end goal.',
        'error_recovery': 'When recovering from errors, clarify whether the fix addresses the user\'s actual need.'
    }

    return hints.get(correction_type, 'Consider clarifying requirements when corrections are needed.')

# ─────────────────────────────────────────────
# Clarification Hint Storage
# ─────────────────────────────────────────────

def save_clarification_hint(pattern: dict, hint: str, observations: list[dict]) -> Path:
    """Save the clarification hint to a file"""
    timestamp = datetime.now()
    filename = f"clarification-{timestamp.strftime('%Y%m%d-%H%M%S')}.yaml"
    filepath = CLARIFICATIONS_DIR / filename

    # Get session info
    session_id = observations[-1].get('session', 'unknown') if observations else 'unknown'

    # Generate a short ID
    hint_id = f"{pattern['type']}-{timestamp.strftime('%Y%m%d')}"

    # Determine trigger from pattern
    trigger = "when corrections are needed"
    if pattern['type'] == 'rapid_re_edit':
        trigger = "when editing files multiple times"
    elif pattern['type'] == 'error_then_success':
        trigger = "when encountering and recovering from errors"
    elif pattern['type'] == 'repeated_tool':
        trigger = f"when using {observations[-1].get('tool', 'tools')} repeatedly"

    content = f"""---
id: {hint_id}
trigger: "{trigger}"
confidence: {pattern['confidence']:.2f}
type: disambiguation
source: session-observation
session: {session_id}
created: {timestamp.isoformat()}
---

# Clarification Hint

## Pattern Detected
{pattern['type'].replace('_', ' ').title()}

## Hint
{hint}

## Evidence
{chr(10).join('- ' + e for e in pattern['evidence'])}

## Tool Sequence
{' → '.join(pattern['tool_sequence'])}
"""

    filepath.write_text(content)
    return filepath

# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description='Analyze recent observations for correction patterns'
    )
    parser.add_argument(
        '--last-turns',
        type=int,
        default=5,
        help='Number of recent turns to analyze (default: 5)'
    )
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Analyze but don\'t save results'
    )

    args = parser.parse_args()

    # Load configuration
    config = load_config()
    clarification_config = config.get('clarifications', {})

    if not clarification_config.get('enabled', True):
        print("Clarification detection is disabled in config")
        return 0

    # Load trigger data if available
    trigger_data = None
    if TRIGGER_FILE.exists():
        try:
            trigger_data = json.loads(TRIGGER_FILE.read_text())
            # Clean up trigger file
            TRIGGER_FILE.unlink()
        except Exception as e:
            print(f"Warning: Failed to read trigger file: {e}", file=sys.stderr)

    # Load recent observations
    observations = load_recent_observations(args.last_turns)

    if len(observations) < 2:
        print("Not enough observations to analyze")
        return 0

    print(f"Analyzing {len(observations)} recent observations...")

    # Analyze for correction patterns
    pattern = analyze_correction_pattern(observations, trigger_data)

    if not pattern:
        print("No correction pattern detected")
        return 0

    print(f"Pattern detected: {pattern['type']} (confidence: {pattern['confidence']:.0%})")

    # Generate clarification hint
    hint = generate_clarification_hint(pattern, observations)

    if not hint:
        print("Failed to generate hint")
        return 1

    print(f"Generated hint: {hint[:80]}...")

    if args.dry_run:
        print("\n[DRY RUN] Would save clarification hint:")
        print(hint)
        return 0

    # Save hint
    filepath = save_clarification_hint(pattern, hint, observations)
    print(f"✅ Clarification hint saved to: {filepath}")

    return 0

if __name__ == '__main__':
    sys.exit(main())
