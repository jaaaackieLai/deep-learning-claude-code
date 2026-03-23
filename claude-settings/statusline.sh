#!/usr/bin/env bash
# Claude Code Status Line — pure bash + jq, no Python dependency
# Displays: [Model] dir | Context bar | 5h bar reset | 7d bar reset

set -euo pipefail

RST="\033[0m"
RED="\033[31m"
YEL="\033[33m"
GRN="\033[32m"
BLU="\033[94m"
LRED="\033[91m"
BOLD_RED="\033[31;1m"
DIM="\033[90m"

input=$(cat)

# -- helpers ------------------------------------------------------------------

color_by_pct() {
  local pct_int=${1:-0}
  if   (( pct_int >= 90 )); then printf '%b' "$RED"
  elif (( pct_int >= 75 )); then printf '%b' "$LRED"
  elif (( pct_int >= 50 )); then printf '%b' "$YEL"
  else                           printf '%b' "$GRN"
  fi
}

progress_bar() {
  local pct=${1:-0} segs=8
  local filled=$(( pct * segs / 100 ))
  (( filled > segs )) && filled=$segs
  local empty=$(( segs - filled ))
  local out=""
  (( filled > 0 )) && out+=$(printf '%.0s█' $(seq 1 "$filled"))
  (( empty > 0 ))  && out+=$(printf '%.0s▁' $(seq 1 "$empty"))
  printf '%s' "$out"
}

seconds_until() {
  local reset_epoch=${1:-0} style=${2:-short}
  local now
  now=$(date +%s)
  local diff=$(( reset_epoch - now ))
  (( diff < 0 )) && diff=0
  if [ "$style" = "days" ] && (( diff >= 86400 )); then
    printf '%dd%dh' $(( diff / 86400 )) $(( (diff % 86400) / 3600 ))
  elif (( diff >= 3600 )); then
    printf '%dh%02dm' $(( diff / 3600 )) $(( (diff % 3600) / 60 ))
  elif (( diff >= 60 )); then
    printf '%dm' $(( diff / 60 ))
  else
    printf '%ds' "$diff"
  fi
}

jq_raw() { echo "$input" | jq -r "$1 // empty"; }
jq_num() { echo "$input" | jq -r "$1 // 0"; }

# -- extract fields -----------------------------------------------------------

model=$(jq_raw '.model.display_name')
cur_dir=$(jq_raw '.workspace.current_dir')
proj_dir=$(jq_raw '.workspace.project_dir')

ctx_pct=$(jq_num '.context_window.used_percentage')
ctx_int=$(printf '%.0f' "$ctx_pct" 2>/dev/null || echo 0)

rl5_pct=$(jq_raw '.rate_limits.five_hour.used_percentage')
rl5_reset=$(jq_raw '.rate_limits.five_hour.resets_at')
rl7_pct=$(jq_raw '.rate_limits.seven_day.used_percentage')
rl7_reset=$(jq_raw '.rate_limits.seven_day.resets_at')

rl5_int=$(printf '%.0f' "${rl5_pct:-0}" 2>/dev/null || echo 0)
rl7_int=$(printf '%.0f' "${rl7_pct:-0}" 2>/dev/null || echo 0)

# -- model + directory --------------------------------------------------------

model_color=$(color_by_pct "$ctx_int")
[ -z "$model" ] && model="Claude"

dir_display=""
if [ -n "$cur_dir" ] && [ -n "$proj_dir" ]; then
  case "$cur_dir" in
    "$proj_dir"*) dir_display="${cur_dir#"$proj_dir"}"
                  dir_display="${dir_display#/}"
                  [ -z "$dir_display" ] && dir_display=$(basename "$proj_dir") ;;
    *)            dir_display=$(basename "$cur_dir") ;;
  esac
elif [ -n "$proj_dir" ]; then
  dir_display=$(basename "$proj_dir")
elif [ -n "$cur_dir" ]; then
  dir_display=$(basename "$cur_dir")
else
  dir_display="?"
fi

# -- context bar --------------------------------------------------------------

ctx_color=$(color_by_pct "$ctx_int")
ctx_bar=$(progress_bar "$ctx_int")
ctx_alert=""
(( ctx_int >= 95 )) && ctx_alert=" CRIT"
(( ctx_int >= 90 && ctx_int < 95 )) && ctx_alert=" HIGH"

# -- rate limits --------------------------------------------------------------

format_rate() {
  local label=$1 pct_int=$2 reset_raw=$3 time_style=${4:-short}
  local c
  c=$(color_by_pct "$pct_int")
  local bar
  bar=$(progress_bar "$pct_int")
  local reset_str=""
  if [ -n "$reset_raw" ] && [ "$reset_raw" != "0" ]; then
    reset_str=" $(seconds_until "$reset_raw" "$time_style")"
  fi
  printf '%s %b%s%b %d%%%s' "$label" "$c" "$bar" "$RST" "$pct_int" "$reset_str"
}

rl5_str=$(format_rate "5h" "$rl5_int" "$rl5_reset")
rl7_str=$(format_rate "7d" "$rl7_int" "$rl7_reset" "days")

# -- assemble -----------------------------------------------------------------

sep="${DIM}|${RST}"

out="${model_color}[${model}]${RST}"
out+=" ${YEL}${dir_display}${RST}"
out+=" ${sep} Context ${ctx_color}${ctx_bar}${RST} ${ctx_int}%${ctx_alert}"
out+=" ${sep} ${rl5_str}"
out+=" ${sep} ${rl7_str}"

printf '%b\n' "$out"
