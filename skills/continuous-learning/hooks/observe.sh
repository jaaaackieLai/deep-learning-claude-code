#!/bin/bash
# Continuous Learning v2 - Observation Hook
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
#       "hooks": [{ "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/skills/continuous-learning-v2/hooks/observe.sh pre" }]
#     }],
#     "PostToolUse": [{
#       "matcher": "*",
#       "hooks": [{ "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/skills/continuous-learning-v2/hooks/observe.sh post" }]
#     }]
#   }
# }
#
# If installed manually to ~/.claude/skills:
# {
#   "hooks": {
#     "PreToolUse": [{
#       "matcher": "*",
#       "hooks": [{ "type": "command", "command": "~/.claude/skills/continuous-learning-v2/hooks/observe.sh pre" }]
#     }],
#     "PostToolUse": [{
#       "matcher": "*",
#       "hooks": [{ "type": "command", "command": "~/.claude/skills/continuous-learning-v2/hooks/observe.sh post" }]
#     }]
#   }
# }

set -e

CONFIG_DIR="${HOME}/.claude/homunculus"
OBSERVATIONS_FILE="${CONFIG_DIR}/observations.jsonl"
MAX_FILE_SIZE_MB=10

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

# Parse using python (more reliable than jq for complex JSON)
PARSED=$(python3 << EOF
import json
import sys

try:
    data = json.loads('''$INPUT_JSON''')

    # Extract fields - Claude Code hook format
    hook_type = data.get('hook_type', 'unknown')  # PreToolUse or PostToolUse
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

    # Determine event type
    event = 'tool_start' if 'Pre' in hook_type else 'tool_complete'

    print(json.dumps({
        'parsed': True,
        'event': event,
        'tool': tool_name,
        'input': tool_input_str if event == 'tool_start' else None,
        'output': tool_output_str if event == 'tool_complete' else None,
        'session': session_id
    }))
except Exception as e:
    print(json.dumps({'parsed': False, 'error': str(e)}))
EOF
)

# Check if parsing succeeded
PARSED_OK=$(echo "$PARSED" | python3 -c "import json,sys; print(json.load(sys.stdin).get('parsed', False))")

if [ "$PARSED_OK" != "True" ]; then
  # Fallback: log raw input for debugging
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "{\"timestamp\":\"$timestamp\",\"event\":\"parse_error\",\"raw\":$(echo "$INPUT_JSON" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()[:1000]))')}" >> "$OBSERVATIONS_FILE"
  exit 0
fi

# Archive if file too large
if [ -f "$OBSERVATIONS_FILE" ]; then
  file_size_mb=$(du -m "$OBSERVATIONS_FILE" 2>/dev/null | cut -f1)
  if [ "${file_size_mb:-0}" -ge "$MAX_FILE_SIZE_MB" ]; then
    archive_dir="${CONFIG_DIR}/observations.archive"
    mkdir -p "$archive_dir"
    mv "$OBSERVATIONS_FILE" "$archive_dir/observations-$(date +%Y%m%d-%H%M%S).jsonl"
  fi
fi

# Build and write observation
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

python3 << EOF
import json

parsed = json.loads('''$PARSED''')
observation = {
    'timestamp': '$timestamp',
    'event': parsed['event'],
    'tool': parsed['tool'],
    'session': parsed['session']
}

if parsed['input']:
    observation['input'] = parsed['input']
if parsed['output']:
    observation['output'] = parsed['output']

with open('$OBSERVATIONS_FILE', 'a') as f:
    f.write(json.dumps(observation) + '\n')
EOF

# Detect potential corrections (heuristic-based)
# This triggers lightweight analysis when correction patterns are detected
CORRECTION_DETECTED=false

python3 << 'DETECT_EOF'
import json
import sys
from pathlib import Path

config_dir = Path.home() / ".claude" / "homunculus"
obs_file = config_dir / "observations.jsonl"
clarifications_dir = config_dir / "clarifications"
clarifications_dir.mkdir(parents=True, exist_ok=True)

# Check if clarification detection is enabled
config_file = Path(__file__).parent.parent / "config.json"
if config_file.exists():
    config = json.loads(config_file.read_text())
    if not config.get("clarifications", {}).get("enabled", True):
        sys.exit(0)

# Read last 10 observations to detect patterns
if not obs_file.exists():
    sys.exit(0)

observations = []
with open(obs_file, 'r') as f:
    lines = f.readlines()
    observations = [json.loads(line) for line in lines[-10:] if line.strip()]

if len(observations) < 2:
    sys.exit(0)

# Detection patterns for potential corrections
correction_signals = []

# Pattern 1: Rapid re-edit of same file (within 30 seconds)
edit_events = [(i, obs) for i, obs in enumerate(observations)
               if obs.get('tool') == 'Edit' and obs.get('event') == 'tool_start']
if len(edit_events) >= 2:
    for i in range(len(edit_events) - 1):
        idx1, obs1 = edit_events[i]
        idx2, obs2 = edit_events[i + 1]
        # Check if editing same file (simple heuristic: file path in input)
        input1 = obs1.get('input', '')
        input2 = obs2.get('input', '')
        if input1 and input2 and any(word in input1 and word in input2 for word in ['file_path']):
            correction_signals.append({
                'type': 'rapid_re_edit',
                'confidence': 0.6,
                'observations': [idx1, idx2]
            })

# Pattern 2: Error followed by success on same tool
for i in range(len(observations) - 1):
    if observations[i].get('event') == 'tool_complete':
        output = observations[i].get('output', '')
        if any(err in str(output).lower() for err in ['error', 'failed', 'exception', 'invalid']):
            # Check if next few tools succeed
            if i + 1 < len(observations) and observations[i + 1].get('event') == 'tool_complete':
                next_output = observations[i + 1].get('output', '')
                if not any(err in str(next_output).lower() for err in ['error', 'failed']):
                    correction_signals.append({
                        'type': 'error_then_success',
                        'confidence': 0.7,
                        'observations': [i, i + 1]
                    })

# Pattern 3: Same tool used 3+ times in short sequence (possible iteration/correction)
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

# If corrections detected, trigger analysis
if correction_signals:
    trigger_file = clarifications_dir / ".trigger"
    with open(trigger_file, 'w') as f:
        json.dump({
            'timestamp': observations[-1].get('timestamp'),
            'session': observations[-1].get('session'),
            'signals': correction_signals
        }, f)
    print("CORRECTION_DETECTED")
DETECT_EOF

if [ $? -eq 0 ]; then
  CORRECTION_OUTPUT=$(python3 << 'DETECT_EOF'
import json
import sys
from pathlib import Path

config_dir = Path.home() / ".claude" / "homunculus"
obs_file = config_dir / "observations.jsonl"
clarifications_dir = config_dir / "clarifications"
clarifications_dir.mkdir(parents=True, exist_ok=True)

# Check if clarification detection is enabled
config_file = Path(__file__).parent.parent / "config.json"
if config_file.exists():
    config = json.loads(config_file.read_text())
    if not config.get("clarifications", {}).get("enabled", True):
        sys.exit(0)

# Read last 10 observations to detect patterns
if not obs_file.exists():
    sys.exit(0)

observations = []
with open(obs_file, 'r') as f:
    lines = f.readlines()
    observations = [json.loads(line) for line in lines[-10:] if line.strip()]

if len(observations) < 2:
    sys.exit(0)

# Detection patterns for potential corrections
correction_signals = []

# Pattern 1: Rapid re-edit of same file (within 30 seconds)
edit_events = [(i, obs) for i, obs in enumerate(observations)
               if obs.get('tool') == 'Edit' and obs.get('event') == 'tool_start']
if len(edit_events) >= 2:
    for i in range(len(edit_events) - 1):
        idx1, obs1 = edit_events[i]
        idx2, obs2 = edit_events[i + 1]
        # Check if editing same file (simple heuristic: file path in input)
        input1 = obs1.get('input', '')
        input2 = obs2.get('input', '')
        if input1 and input2 and any(word in input1 and word in input2 for word in ['file_path']):
            correction_signals.append({
                'type': 'rapid_re_edit',
                'confidence': 0.6,
                'observations': [idx1, idx2]
            })

# Pattern 2: Error followed by success on same tool
for i in range(len(observations) - 1):
    if observations[i].get('event') == 'tool_complete':
        output = observations[i].get('output', '')
        if any(err in str(output).lower() for err in ['error', 'failed', 'exception', 'invalid']):
            # Check if next few tools succeed
            if i + 1 < len(observations) and observations[i + 1].get('event') == 'tool_complete':
                next_output = observations[i + 1].get('output', '')
                if not any(err in str(next_output).lower() for err in ['error', 'failed']):
                    correction_signals.append({
                        'type': 'error_then_success',
                        'confidence': 0.7,
                        'observations': [i, i + 1]
                    })

# Pattern 3: Same tool used 3+ times in short sequence (possible iteration/correction)
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

# If corrections detected, trigger analysis
if correction_signals:
    trigger_file = clarifications_dir / ".trigger"
    with open(trigger_file, 'w') as f:
        json.dump({
            'timestamp': observations[-1].get('timestamp'),
            'session': observations[-1].get('session'),
            'signals': correction_signals
        }, f)
    print("CORRECTION_DETECTED")
DETECT_EOF
)

  if [ "$CORRECTION_OUTPUT" = "CORRECTION_DETECTED" ]; then
    # Trigger lightweight analysis in background
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    if [ -f "$SCRIPT_DIR/scripts/analyze-correction.py" ]; then
      python3 "$SCRIPT_DIR/scripts/analyze-correction.py" --last-turns 5 &
    fi
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
