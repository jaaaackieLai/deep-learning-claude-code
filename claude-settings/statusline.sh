#!/usr/bin/env bash
# Claude Code Status Line — true color (24-bit RGB) + Nerd Font edition
# Line 1: [Model] dir | Context bar
# Line 2: 5h rate limit | 7d rate limit
# Requires: jq, terminal with true color support, Nerd Font (optional)

set -euo pipefail

RST=$'\033[0m'

# -- color palette (literal escape sequences) ---------------------------------

C_GREEN=$'\033[38;2;62;184;89m'      # #3EB859
C_YELLOW=$'\033[38;2;241;250;140m'   # #F1FA8C
C_ORANGE=$'\033[38;2;255;184;108m'   # #FFB86C
C_RED=$'\033[38;2;255;85;85m'        # #FF5555

C_MODEL=$'\033[1;38;2;189;147;249m'    # #BD93F9 purple
C_DIR=$'\033[1;38;2;137;124;128m'      # #897C80 brown
C_ICON=$'\033[38;2;248;248;242m'     # #F8F8F2 bright white
C_SEP=$'\033[38;2;68;71;90m'         # #44475A separator

BG_MODEL=$'\033[48;2;30;31;40m'      # #1E1F28 minimal badge

# -- Nerd Font icons ----------------------------------------------------------
# Customize these if your font renders them differently

ICO_MODEL=$'\U0001F916'       # 🤖 robot face
ICO_DIR=$'\U0001F4C2'         # 📂 open folder
ICO_CTX=$'\U0001F5C4\uFE0F'   # 🗄️ file cabinet
ICO_5H=$'\U000023F3'          # ⏳ hourglass
ICO_7D=$'\U0001F4C5'          # 📅 calendar

input=$(cat)

# -- helpers ------------------------------------------------------------------

color_ctx_pct() {
  local pct_int=${1:-0}
  if   (( pct_int >= 75 )); then printf '%s' "$C_RED"
  elif (( pct_int >= 60 )); then printf '%s' "$C_ORANGE"
  elif (( pct_int >= 40 )); then printf '%s' "$C_YELLOW"
  else                           printf '%s' "$C_GREEN"
  fi
}

color_rate_pct() {
  local pct_int=${1:-0}
  if   (( pct_int >= 90 )); then printf '%s' "$C_RED"
  elif (( pct_int >= 80 )); then printf '%s' "$C_ORANGE"
  elif (( pct_int >= 50 )); then printf '%s' "$C_YELLOW"
  else                           printf '%s' "$C_GREEN"
  fi
}

gauge_bar() {
  local pct=${1:-0} segs=${2:-10} filled_char=${3:-●} empty_char=${4:-○}
  local filled=$(( pct * segs / 100 ))
  (( filled > segs )) && filled=$segs
  local empty=$(( segs - filled ))
  local out="" i
  for (( i=0; i<filled; i++ )); do out+="$filled_char"; done
  for (( i=0; i<empty; i++ )); do out+="$empty_char"; done
  printf '%s' "$out"
}

seconds_until() {
  local reset_epoch=${1:-0} style=${2:-short}
  local diff=$(( reset_epoch - NOW ))
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

# -- extract all fields in a single jq call -----------------------------------

IFS=$'\x1f' read -r model cur_dir proj_dir ctx_int rl5_int rl5_reset rl7_int rl7_reset < <(
  echo "$input" | jq -r '[
    (.model.display_name // "Claude"),
    (.workspace.current_dir // ""),
    (.workspace.project_dir // ""),
    (.context_window.used_percentage // 0 | round),
    (.rate_limits.five_hour.used_percentage // 0 | round),
    (.rate_limits.five_hour.resets_at // 0),
    (.rate_limits.seven_day.used_percentage // 0 | round),
    (.rate_limits.seven_day.resets_at // 0)
  ] | join("\u001f")'
)

NOW=$(date +%s)

# -- directory ----------------------------------------------------------------

dir_display=""
if [ -n "$cur_dir" ] && [ -n "$proj_dir" ]; then
  case "$cur_dir" in
    "$proj_dir"*) dir_display="${cur_dir#"$proj_dir"}"
                  dir_display="${dir_display#/}"
                  [ -z "$dir_display" ] && dir_display="${proj_dir##*/}" ;;
    *)            dir_display="${cur_dir##*/}" ;;
  esac
elif [ -n "$proj_dir" ]; then
  dir_display="${proj_dir##*/}"
elif [ -n "$cur_dir" ]; then
  dir_display="${cur_dir##*/}"
else
  dir_display="?"
fi

# -- context bar --------------------------------------------------------------

ctx_color=$(color_ctx_pct "$ctx_int")
ctx_bar=$(gauge_bar "$ctx_int" 8 "█" "░")
ctx_alert=""
(( ctx_int >= 75 )) && ctx_alert=" CRIT"
(( ctx_int >= 60 && ctx_int < 75 )) && ctx_alert=" HIGH"

# -- rate limits --------------------------------------------------------------

format_rate() {
  local icon=$1 pct_int=$2 reset_raw=$3 time_style=${4:-short}
  local c bar reset_str="" alert=""
  c=$(color_rate_pct "$pct_int")
  bar=$(gauge_bar "$pct_int")
  if [ -n "$reset_raw" ] && [ "$reset_raw" != "0" ]; then
    reset_str=" $(seconds_until "$reset_raw" "$time_style")"
  fi
  (( pct_int >= 90 )) && alert=" CRIT"
  (( pct_int >= 80 && pct_int < 90 )) && alert=" HIGH"
  printf '%b%s%b %b%s %d%%%b%s%s' "$C_ICON" "$icon" "$RST" "$c" "$bar" "$pct_int" "$RST" "$reset_str" "$alert"
}

rl5_str=$(format_rate "$ICO_5H" "$rl5_int" "$rl5_reset")
rl7_str=$(format_rate "$ICO_7D" "$rl7_int" "$rl7_reset" "days")

# -- assemble -----------------------------------------------------------------

line1="${BG_MODEL}${C_MODEL} ${ICO_MODEL} ${model} ${RST}"
line1+=" ${C_DIR}${ICO_DIR} ${dir_display}${RST}"
line1+=" ${C_ICON}${ICO_CTX}${RST} ${ctx_color}${ctx_bar} ${ctx_int}%${RST}${ctx_alert}"

line2="${RST} ${rl5_str}"
line2+=" ${rl7_str}"

printf '%b\n%b\n' "$line1" "$line2"
