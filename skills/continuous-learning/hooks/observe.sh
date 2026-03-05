#!/bin/bash
# Continuous Learning - Observation Hook
#
# Captures tool use events for pattern analysis.
# Claude Code passes hook data via stdin as JSON.
#
# Hook config (in ~/.claude/settings.json):
#
# If installed as a plugin, use ${CLAUDE_PLUGIN_ROOT}:
# {
#   "hooks": {
#     "PreToolUse": [{
#       "matcher": "*",
#       "hooks": [{ "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/observe.sh pre" }]
#     }],
#     "PostToolUse": [{
#       "matcher": "*",
#       "hooks": [{ "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/observe.sh post" }]
#     }]
#   }
# }
#
# If installed manually to ~/.claude/skills:
# {
#   "hooks": {
#     "PreToolUse": [{
#       "matcher": "*",
#       "hooks": [{ "type": "command", "command": "~/.claude/skills/continuous-learning/hooks/observe.sh pre" }]
#     }],
#     "PostToolUse": [{
#       "matcher": "*",
#       "hooks": [{ "type": "command", "command": "~/.claude/skills/continuous-learning/hooks/observe.sh post" }]
#     }]
#   }
# }

set -e

CONFIG_DIR="${HOME}/.claude/homunculus"
OBSERVATIONS_FILE="${CONFIG_DIR}/observations.jsonl"
MAX_FILE_SIZE_MB=10
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ensure directory exists
mkdir -p "$CONFIG_DIR"

# Skip if disabled
if [ -f "$CONFIG_DIR/disabled" ]; then
  exit 0
fi

# Read JSON from stdin (Claude Code hook format)
INPUT_JSON=$(cat)

# Exit if no input
if [ -z "$INPUT_JSON" ]; then
  exit 0
fi

# Archive if observations file too large
if [ -f "$OBSERVATIONS_FILE" ]; then
  file_size_mb=$(du -m "$OBSERVATIONS_FILE" 2>/dev/null | cut -f1)
  if [ "${file_size_mb:-0}" -ge "$MAX_FILE_SIZE_MB" ]; then
    archive_dir="${CONFIG_DIR}/observations.archive"
    mkdir -p "$archive_dir"
    mv "$OBSERVATIONS_FILE" "$archive_dir/observations-$(date +%Y%m%d-%H%M%S).jsonl"
  fi
fi

# Single Python script: parse input, write observation, detect corrections
CORRECTION_OUTPUT=$(echo "$INPUT_JSON" | python3 -c "
import json
import sys
from pathlib import Path
from datetime import datetime, timezone

config_dir = Path.home() / '.claude' / 'homunculus'
obs_file = config_dir / 'observations.jsonl'
clarifications_dir = config_dir / 'clarifications'
clarifications_dir.mkdir(parents=True, exist_ok=True)
script_dir = Path('${SCRIPT_DIR}')

# --- Phase 1: Parse input and write observation ---
try:
    data = json.load(sys.stdin)
except Exception as e:
    # Log parse error and exit
    timestamp = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
    with open(obs_file, 'a') as f:
        f.write(json.dumps({'timestamp': timestamp, 'event': 'parse_error', 'error': str(e)}) + '\n')
    sys.exit(0)

hook_type = data.get('hook_type', 'unknown')
tool_name = data.get('tool_name', data.get('tool', 'unknown'))
tool_input = data.get('tool_input', data.get('input', {}))
tool_output = data.get('tool_output', data.get('output', ''))
session_id = data.get('session_id', 'unknown')

# Truncate large inputs/outputs
if isinstance(tool_input, dict):
    tool_input_str = json.dumps(tool_input)[:5000]
else:
    tool_input_str = str(tool_input)[:5000]

if isinstance(tool_output, dict):
    tool_output_str = json.dumps(tool_output)[:5000]
else:
    tool_output_str = str(tool_output)[:5000]

event = 'tool_start' if 'Pre' in hook_type else 'tool_complete'
timestamp = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')

observation = {
    'timestamp': timestamp,
    'event': event,
    'tool': tool_name,
    'session': session_id
}
if event == 'tool_start' and tool_input_str:
    observation['input'] = tool_input_str
if event == 'tool_complete' and tool_output_str:
    observation['output'] = tool_output_str

with open(obs_file, 'a') as f:
    f.write(json.dumps(observation) + '\n')

# --- Phase 2: Detect correction patterns ---
config_file = script_dir / 'config.json'
if config_file.exists():
    try:
        config = json.loads(config_file.read_text())
        if not config.get('clarifications', {}).get('enabled', True):
            sys.exit(0)
    except Exception:
        pass

if not obs_file.exists():
    sys.exit(0)

observations = []
with open(obs_file, 'r') as f:
    lines = f.readlines()
    for line in lines[-10:]:
        line = line.strip()
        if line:
            try:
                observations.append(json.loads(line))
            except Exception:
                pass

if len(observations) < 2:
    sys.exit(0)

correction_signals = []

# Pattern 1: Rapid re-edit of same file
edit_events = [(i, obs) for i, obs in enumerate(observations)
               if obs.get('tool') == 'Edit' and obs.get('event') == 'tool_start']
if len(edit_events) >= 2:
    for i in range(len(edit_events) - 1):
        idx1, obs1 = edit_events[i]
        idx2, obs2 = edit_events[i + 1]
        input1 = obs1.get('input', '')
        input2 = obs2.get('input', '')
        if input1 and input2 and 'file_path' in str(input1) and 'file_path' in str(input2):
            correction_signals.append({
                'type': 'rapid_re_edit',
                'confidence': 0.6,
                'observations': [idx1, idx2]
            })

# Pattern 2: Error followed by success on same tool
for i in range(len(observations) - 1):
    if observations[i].get('event') == 'tool_complete':
        output = str(observations[i].get('output', '')).lower()
        if any(err in output for err in ['error', 'failed', 'exception', 'invalid']):
            if i + 1 < len(observations) and observations[i + 1].get('event') == 'tool_complete':
                next_output = str(observations[i + 1].get('output', '')).lower()
                if not any(err in next_output for err in ['error', 'failed']):
                    correction_signals.append({
                        'type': 'error_then_success',
                        'confidence': 0.7,
                        'observations': [i, i + 1]
                    })

# Pattern 3: Same tool used 3+ times in short sequence
tool_sequence = [obs.get('tool') for obs in observations[-5:]]
for tool in set(tool_sequence):
    count = tool_sequence.count(tool)
    if count >= 3 and tool in ['Edit', 'Write', 'Bash']:
        correction_signals.append({
            'type': 'repeated_tool',
            'confidence': 0.5,
            'tool': tool,
            'count': count
        })

if correction_signals:
    trigger_file = clarifications_dir / '.trigger'
    with open(trigger_file, 'w') as f:
        json.dump({
            'timestamp': observations[-1].get('timestamp'),
            'session': observations[-1].get('session'),
            'signals': correction_signals
        }, f)
    print('CORRECTION_DETECTED')
" 2>/dev/null || true)

if [ "$CORRECTION_OUTPUT" = "CORRECTION_DETECTED" ]; then
  # Trigger lightweight analysis in background
  if [ -f "$SCRIPT_DIR/scripts/analyze-correction.py" ]; then
    python3 "$SCRIPT_DIR/scripts/analyze-correction.py" --last-turns 5 &
  fi
fi

# Signal observer if running
OBSERVER_PID_FILE="${CONFIG_DIR}/.observer.pid"
if [ -f "$OBSERVER_PID_FILE" ]; then
  observer_pid=$(cat "$OBSERVER_PID_FILE")
  if kill -0 "$observer_pid" 2>/dev/null; then
    kill -USR1 "$observer_pid" 2>/dev/null || true
  fi
fi

exit 0
