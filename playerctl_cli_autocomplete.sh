#!/usr/bin/env bash

# ─── PLAYERCTL + WPCTL SIMPLE SHELL FUNCTIONS ────────────────────────────────
# This script provides top-level shell functions to control media players
# and system audio using playerctl and wpctl. Autocompletion is supported.
#
# To use:
#     source /path/to/.playerctl_cli.sh
# Then use commands like:
#     list_players
#     select_player
#     play, pause, toggle, next, prev
#     shuffle on|off
#     loop off|playlist|track
#     volume 0.5
#     meta
#     volctl 50%
#     status
#
# Tab completion is available for: loop, shuffle, volctl
#
#─────────────────────────────────────────────────────────────────────────────


# ─── GLOBAL STATE ────────────────────────────────────────────────────────────

current_player=""

# ─── PLAYER FUNCTIONS ────────────────────────────────────────────────────────

list_players() {
  local out
  out=$(playerctl -l 2>/dev/null)
  if [[ -z "$out" ]]; then
    echo "No players found."
  else
    echo "Players:"
    echo "$out" | nl -w2 -s". "
  fi
}

select_player() {
  local players
  IFS=$'\n' read -r -d '' -a players < <(playerctl -l 2>/dev/null && printf '\0')
  if [[ ${#players[@]} -eq 0 ]]; then
    echo "No players found."
    return 1
  fi

  echo "Select a player:"
  for i in "${!players[@]}"; do
    printf "  [%d] %s\n" $((i + 1)) "${players[$i]}"
  done

  local index
  read -rp "Enter player number: " index

  if ! [[ "$index" =~ ^[0-9]+$ ]] || (( index < 1 || index > ${#players[@]} )); then
    echo "Invalid selection."
    return 1
  fi

  current_player="${players[$((index - 1))]}"
  echo "Selected player: '$current_player'"
}

play()   { playerctl -p "$current_player" play; }
pause()  { playerctl -p "$current_player" pause; }
toggle() { playerctl -p "$current_player" play-pause; }
next()   { playerctl -p "$current_player" next; }
prev()   { playerctl -p "$current_player" previous; }
status() { playerctl -p "$current_player" status; }

shuffle() {
  [[ "$1" == "on" || "$1" == "off" ]] || { echo "Usage: shuffle on|off"; return 1; }
  playerctl -p "$current_player" shuffle "$1"
}

loop() {
  case "$1" in
    off|playlist|track)
      playerctl -p "$current_player" loop "$1"
      ;;
    *)
      echo "Usage: loop off|playlist|track"
      return 1
      ;;
  esac
}

volume() {
  if [[ "$1" =~ ^0(\.[0-9]+)?$ || "$1" == "1" || "$1" == "1.0" ]]; then
    playerctl -p "$current_player" volume "$1"
  else
    echo "Usage: volume <0.0–1.0>"
    return 1
  fi
}

meta() {
  playerctl -p "$current_player" metadata --format "  {{artist}} — {{title}} ({{album}})"
}

volctl() {
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1"
}

# ─── AUTOCOMPLETION ──────────────────────────────────────────────────────────

_loop_complete() {
  COMPREPLY=( $(compgen -W "off playlist track" -- "${COMP_WORDS[COMP_CWORD]}") )
}
_shuffle_complete() {
  COMPREPLY=( $(compgen -W "on off" -- "${COMP_WORDS[COMP_CWORD]}") )
}
_volctl_complete() {
  COMPREPLY=( $(compgen -W "0.1 0.25 0.5 0.75 1.0 10% 25% 50% 75% 100%" -- "${COMP_WORDS[COMP_CWORD]}") )
}

complete -F _loop_complete loop
complete -F _shuffle_complete shuffle
complete -F _volctl_complete volctl
