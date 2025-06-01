#!/usr/bin/env bash

#
# ─── A MINI “PLAYER” CLI FOR playerctl + wpctl ─────────────────────────────────
#
#  • Source this file; it will:
#     1. List all running players (via `playerctl -l`).
#     2. Enter a tiny interactive loop with prompt `player> `.
#     3. Expose built‐in commands like `list`, `select`, `play`, `next`, `shuffle on`, etc.
#     4. Include a `volctl` subcommand to set system volume with wpctl.
#
#  • To use:
#       source /path/to/playerctl_cli.sh
#     (You’ll immediately see “Available players” listed, and your
#      prompt will become `player> `.)
#
#  • Type `help` for a quick reminder of all commands.
#
################################################################################

### ── INTERNAL STATE ──────────────────────────────────────────────────────────

# The name (string) of the currently‐selected player (empty if none)
current_player=""

# When the script is sourced, immediately list all running players:
_list_all_players() {
  # playerctl -l lists each player on its own line
  echo
  echo "Available players:"
  playerctl -l 2>/dev/null | sed 's/^/  • /'
  echo
}

# Call it immediately on source:
_list_all_players

### ── FUNCTION DEFINITIONS ─────────────────────────────────────────────────────

# 1) list: print all players currently running
pc_list() {
  local out
  out=$(playerctl -l 2>/dev/null)
  if [[ -z "$out" ]]; then
    echo "No players found."
  else
    echo "Players:"
    echo "$out" | sed 's/^/  • /'
  fi
}

# 2) select <name>: pick a player (must be exactly one of `playerctl -l`)
pc_select() {
  local players
  IFS=$'\n' read -r -d '' -a players < <(playerctl -l 2>/dev/null && printf '\0')

  if [[ ${#players[@]} -eq 0 ]]; then
    echo "No players found."
    return 1
  fi

  echo "Available players:"
  for i in "${!players[@]}"; do
    printf "  [%d] %s\n" $((i + 1)) "${players[$i]}"
  done

  local index
  read -rp "Enter player number: " index

  if ! [[ "$index" =~ ^[0-9]+$ ]] || ((index < 1 || index > ${#players[@]})); then
    echo "Invalid selection. Must be a number between 1 and ${#players[@]}."
    return 1
  fi

  current_player="${players[$((index - 1))]}"
  echo "Selected player: '$current_player'"
  prompt="player: $current_player> "
}

# 3) play / pause / toggle
pc_toggle() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected. Use: select <player-name>"
    return 1
  fi
  playerctl -p "$current_player" play-pause
}

pc_play() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  playerctl -p "$current_player" play
}

pc_pause() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  playerctl -p "$current_player" pause
}

# 4) status
pc_status() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  local st
  st=$(playerctl -p "$current_player" status 2>/dev/null)
  if [[ -z "$st" ]]; then
    echo "Could not get status for '$current_player'."
    return 1
  else
    echo "$current_player status: $st"
  fi
}

# 5) next / previous
pc_next() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  playerctl -p "$current_player" next
}

pc_prev() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  playerctl -p "$current_player" previous
}

# 6) shuffle <on|off>
pc_shuffle() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  if [[ "$1" != "on" && "$1" != "off" ]]; then
    echo "Usage: shuffle <on|off>"
    return 1
  fi
  playerctl -p "$current_player" shuffle "$1"
}

# 7) loop <off|playlist|track>
pc_loop() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  case "$1" in
  off | playlist | track)
    playerctl -p "$current_player" loop "$1"
    ;;
  *)
    echo "Usage: loop <off|playlist|track>"
    return 1
    ;;
  esac
}

# 8) volume <fraction>
#    Accepts a decimal between 0.0 and 1.0 (e.g. 0.5 for 50%).
pc_volume() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  if [[ -z "$1" ]]; then
    echo "Usage: volume <0.0–1.0>"
    return 1
  fi
  # Basic sanity check: must match a decimal number (e.g. 0, 0.5, 1.0)
  if [[ "$1" =~ ^0(\.[0-9]+)?$ || "$1" == "1" || "$1" == "1.0" ]]; then
    playerctl -p "$current_player" volume "$1"
  else
    echo "Error: volume must be between 0.0 and 1.0"
    return 1
  fi
}

# 9) meta: show metadata (artist, title, album, etc.)
pc_meta() {
  if [[ -z "$current_player" ]]; then
    echo "No player selected."
    return 1
  fi
  playerctl -p "$current_player" metadata --format "  {{artist}} — {{title}} ({{album}})"
}

# 10) volctl <percent>
#     Set system‐wide volume via wpctl (e.g. “volctl 50%” or “volctl 0.8”).
pc_volctl() {
  if [[ -z "$1" ]]; then
    echo "Usage: volctl <value>"
    echo "  e.g.: volctl 50%   or   volctl 0.8"
    return 1
  fi
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1"
}

# 11) help: print a short usage guide
pc_help() {
  cat <<EOF

Available commands within the “player” shell:

  list
      • Show all running players (same as: playerctl -l)

  select <player-name>
      • Pick which player you want to control.
      • Prompt will change to: player: <player-name> >

  play | pause | toggle
      • Start/Pause/Toggle playback for the selected player.

  status
      • Show “Playing” or “Paused” (from playerctl status).

  next    • Skip to next track.
  prev    • Skip to previous track.

  shuffle <on|off>
      • Turn shuffle mode on or off.

  loop <off|playlist|track>
      • Set loop mode.

  volume <0.0–1.0>
      • Set player volume (0.0 = 0%, 1.0 = 100%).

  meta
      • Print the current metadata (artist — title (album)).

  volctl <value>
      • Set system volume via wpctl. Examples:
            volctl 50%
            volctl 0.8

  help
      • Show this help text.

  exit   or  quit
      • Leave the “player” shell and return to your normal prompt.

EOF
}

### ── THE INTERACTIVE LOOP ─────────────────────────────────────────────────────

player() {
  local prompt="player> "

  while true; do
    # Read a command + (optional) arguments
    # We use “read -r” so backslashes aren’t interpreted
    IFS=" " read -r cmd arg1 arg2 <<<"$(printf "%s" "" && read -e -p "$prompt" line && printf "%s\n" "$line")"

    # Split “line” into the first two words: cmd and arg1.
    # (This handles a single optional argument—for “shuffle on”, “loop track”, etc.)
    case "$cmd" in
    list)
      pc_list
      ;;
    select)
      pc_select
      ;;
    play)
      pc_play
      ;;
    pause)
      pc_pause
      ;;
    toggle)
      pc_toggle
      ;;
    status)
      pc_status
      ;;
    next)
      pc_next
      ;;
    prev)
      pc_prev
      ;;
    shuffle)
      pc_shuffle "$arg1"
      ;;
    loop)
      pc_loop "$arg1"
      ;;
    volume)
      pc_volume "$arg1"
      ;;
    meta)
      pc_meta
      ;;
    volctl)
      pc_volctl "$arg1"
      ;;
    help)
      pc_help
      ;;
    exit | quit)
      echo "Exiting player shell."
      break
      ;;
    "")
      # If user just hit Enter, do nothing
      ;;
    *)
      echo "Unknown command: '$cmd'.  Type ‘help’ for a list."
      ;;
    esac
  done
}

# Adding an autocomplete functionality
_player_autocomplete() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD - 1]}"

  # All top-level commands
  opts="list select play pause toggle status next prev shuffle loop volume meta volctl help exit quit"

  case "$prev" in
  shuffle)
    COMPREPLY=($(compgen -W "on off" -- "$cur"))
    return 0
    ;;
  loop)
    COMPREPLY=($(compgen -W "off playlist track" -- "$cur"))
    return 0
    ;;
  volctl)
    COMPREPLY=($(compgen -W "0.1 0.25 0.5 0.75 1.0 10% 25% 50% 75% 100%" -- "$cur"))
    return 0
    ;;
  *)
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
    return 0
    ;;
  esac
}

# Enable autocomplete only for the `player` function
complete -F _player_autocomplete player

# Finally, as soon as this file is sourced, hand off to the “player” function:
player

################################################################################
# EOF
