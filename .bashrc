#
# ~/.bashrc
#
export STARSHIP_CONFIG="/home/Arieldynamic/.config/starship/starship.toml"
eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias lla='ls -la --color=auto'
alias la='ls -a --color=auto'
alias grep='grep --color=auto'
alias v='nvim'
alias h='history'
alias syssleep='systemctl sleep'

alias bt='bluetui'
alias pctl='source $HOME/.playerctl_cli.sh'
alias bye='exit'

export EDITOR=nvim
PS1='[\u@\h \W]\$ '

export TERMINAL=ghostty

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
  ls
}

function cpwd() {
  wl-copy $(pwd)
  echo "Copied $(pwd) to Wl-Clipboard!"
}

function cpwdx() {
  pwd | xclip -selection clipboard
  echo "Copied $(pwd) to X Clipboard"
}

function cd() {
  builtin cd "$@" && ls
}

function hg() {
  builtin history | grep "$1"
}

function find_largest_files() {
  du -h -x -s -- * | sort -r -h | head -20
}

function hl() {
  history | less
}

# Installed jq for this function
function weather_report() {

  local response=$(curl --silent 'https://api.openweathermap.org/data/2.5/weather?id=4699066&units=imperial&appid=f7835911942b441743304c8e3a4aa0fc')

  local status=$(echo $response | jq -r '.cod')

  # Check for the 200 response indicating a successful API query.
  case $status in

  200)
    printf "Location: %s %s\n" "$(echo $response | jq '.name') $(echo $response | jq '.sys.country')"
    printf "Forecast: %s\n" "$(echo $response | jq '.weather[].description')"
    printf "Temperature: %.1f°F\n" "$(echo $response | jq '.main.temp')"
    printf "Temp Min: %.1f°F\n" "$(echo $response | jq '.main.temp_min')"
    printf "Temp Max: %.1f°F\n" "$(echo $response | jq '.main.temp_max')"
    printf "Alerts  :" "$(echo $response | jq '.alerts')\n"
    ;;
  401)
    echo "401 error"
    ;;
  *)
    echo "error"
    ;;

  esac

}

# Load OpenWeather env (quietly, only if readable)
if [ -r "$HOME/.config/owx/owx.env" ]; then
  # Avoid leaking secrets if xtrace is on
  case $- in *x*) set +x ;; esac
  set -a # auto-export all vars defined while set
  . "$HOME/.config/owx/owx.env"
  set +a
fi

# --- Add to ~/.bashrc ---------------------------------------------------------
# Requirements: jq, curl
# Configure your location & key (export these in .bashrc or your shell env):
#   export OWM_API_KEY="YOUR_KEY"
#   export OWM_LAT="30.62"      # example
#   export OWM_LON="-96.34"     # example
# Optional:
#   export OWM_UNITS="metric"   # metric | imperial | standard (default)
#   export OWM_LANG="en"

owx() {
  local show="${1:-all}"         # current | hourly | daily | all
  local hours="${OWM_HOURS:-12}" # how many hourly rows to show
  local days="${OWM_DAYS:-7}"    # how many daily rows to show (max 8)
  local units="${OWM_UNITS:-standard}"
  local lang="${OWM_LANG:-en}"

  for v in OWM_API_KEY OWM_LAT OWM_LON; do
    if [ -z "${!v}" ]; then
      echo "Missing \$${v}. Set OWM_API_KEY, OWM_LAT, OWM_LON." >&2
      return 1
    fi
  done

  # Build 'exclude' to save bandwidth (keep alerts unless user asked only alerts someday)
  local exclude="minutely"
  case "$show" in
  current) exclude="$exclude,hourly,daily" ;;
  hourly) exclude="$exclude,current,daily" ;;
  daily) exclude="$exclude,current,hourly" ;;
  all) : ;;
  *)
    echo "Usage: owx [current|hourly|daily|all]"
    return 1
    ;;
  esac

  # Fetch
  local url="https://api.openweathermap.org/data/3.0/onecall"
  local resp
  resp="$(curl -fsS --get "$url" \
    --data-urlencode "lat=${OWM_LAT}" \
    --data-urlencode "lon=${OWM_LON}" \
    --data-urlencode "exclude=${exclude}" \
    --data-urlencode "units=${units}" \
    --data-urlencode "lang=${lang}" \
    --data-urlencode "appid=${OWM_API_KEY}")" || {
    echo "API request failed."
    return 2
  }

  # Pull timezone_offset so times are printed for the LOCATION, not your machine
  local tzoff
  tzoff="$(jq -r '.timezone_offset // 0' <<<"$resp")"

  # helper: print Unix time + tz offset as 24h local-of-location
  _owx_time() {
    # $1 = unix seconds; prints HH:MM (24h)
    local t="$1"
    date -u -d "@$((t + tzoff))" +"%H:%M"
  }

  # ---------- CURRENT ----------
  if [[ "$show" = "current" || "$show" = "all" ]]; then
    if jq -e '.current' >/dev/null 2>&1 <<<"$resp"; then
      echo "=== CURRENT ==="
      jq -r --argjson tz "$tzoff" '
        .current as $c
        | [
          "temp: "        + ($c.temp|tostring),
          "feels_like: "  + ($c.feels_like|tostring),
          "humidity: "    + (($c.humidity//null)|tostring) + " %",
          "clouds: "      + (($c.clouds//null)|tostring) + " %",
          "uvi: "         + (($c.uvi//null)|tostring),
          "visibility: "  + (($c.visibility//null)|tostring) + " m",
          "wind_speed: "  + (($c.wind_speed//null)|tostring),
          "wind_gust: "   + (if $c.wind_gust then ($c.wind_gust|tostring) else "N/A" end),
          "weather: "     + ( ($c.weather[0].main//"") + " - " + ($c.weather[0].description//"") )
        ] | .[]' <<<"$resp"
      echo
    fi
  fi
  # (Fields like temp, feels_like, humidity, clouds, uvi, visibility, wind_speed/gust, weather[] are defined in the docs.) :contentReference[oaicite:3]{index=3} :contentReference[oaicite:4]{index=4}

  # ---------- HOURLY ----------
  if [[ "$show" = "hourly" || "$show" = "all" ]]; then
    if jq -e '.hourly' >/dev/null 2>&1 <<<"$resp"; then
      echo "=== HOURLY (next '"$hours"' h) ==="
      jq -r --argjson tz "$tzoff" --argjson N "$hours" '
        .hourly[:$N][] as $h |
        @sh "\(
          ( ($h.dt|tonumber)+$tz | todateiso8601 ) | split("T")[1][:5]
        )  temp: \($h.temp) | feels_like: \($h.feels_like) | humid: \($h.humidity)% | clouds: \($h.clouds)% | uvi: \($h.uvi)
            | vis: \($h.visibility)m | wind: \($h.wind_speed) (gust: \(($h.wind_gust//"N/A"))) | wx: \($h.weather[0].main) - \($h.weather[0].description)
            | pop: \((($h.pop//0)*100)|round)%"' <<<"$resp" | tr -d \'
      echo
    fi
  fi
  # (hourly has temp/feels_like/…/visibility/wind/POP where pop is 0..1 => 0–100%.) :contentReference[oaicite:5]{index=5}

  # ---------- DAILY ----------
  if [[ "$show" = "daily" || "$show" = "all" ]]; then
    if jq -e '.daily' >/dev/null 2>&1 <<<"$resp"; then
      echo "=== DAILY (next '"$days"' d) ==="
      jq -r --argjson tz "$tzoff" --argjson N "$days" '
        .daily[:$N][] as $d |
        "date: " +
        ( ( ($d.dt|tonumber)+$tz | todateiso8601 )[:10] ) + "\n" +
        "  sunrise: " + ( ( ($d.sunrise|tonumber)+$tz | todateiso8601 ) | split("T")[1][:5] ) + " | sunset: " +
        ( ( ($d.sunset|tonumber)+$tz | todateiso8601 ) | split("T")[1][:5] ) + "\n" +
        "  summary: " + ($d.summary//"") + "\n" +
        "  temp:\n" +
        "    morn: " + ($d.temp.morn|tostring) + "\n" +
        "    day:  " + ($d.temp.day|tostring)  + "\n" +
        "    eve:  " + ($d.temp.eve|tostring)  + "\n" +
        "    night:"+ ($d.temp.night|tostring) + "\n" +
        "    min:  " + ($d.temp.min|tostring)  + "\n" +
        "    max:  " + ($d.temp.max|tostring)  + "\n" +
        "  feels_like:\n" +
        "    morn: " + ($d.feels_like.morn|tostring) + "\n" +
        "    day:  " + ($d.feels_like.day|tostring)  + "\n" +
        "    eve:  " + ($d.feels_like.eve|tostring)  + "\n" +
        "    night:"+ ($d.feels_like.night|tostring) + "\n" +
        "  humid: " + ($d.humidity|tostring) + "% | clouds: " + ($d.clouds|tostring) + "% | uvi(max): " + ($d.uvi|tostring) + "\n" +
        "  wind: " + ($d.wind_speed|tostring) + " (gust: " + ( ($d.wind_gust//"N/A")|tostring ) + ")\n" +
        "  wx: " + ($d.weather[0].main//"") + " - " + ($d.weather[0].description//"") + "\n" +
        "  pop: " + (((($d.pop//0)*100)|round)|tostring) + "%"
      ' <<<"$resp"
      echo
    fi
  fi
  # (daily has sunrise/sunset, summary, temp.*, feels_like.*, uvi, pop, wind, clouds, weather.) :contentReference[oaicite:6]{index=6}

  # ---------- ALERTS (always shown if present) ----------
  if jq -e '.alerts' >/dev/null 2>&1 <<<"$resp"; then
    echo "=== ALERTS ==="
    jq -r --argjson tz "$tzoff" '
      .alerts[] as $a |
      "event: " + ($a.event//"") + "\n" +
      "  start: " + (( ($a.start//0)+$tz | todateiso8601 ) | split("T")[1][:5]) +
      " | end: "   + (( ($a.end//0)+$tz   | todateiso8601 ) | split("T")[1][:5]) + "\n" +
      "  tags: " + ( ($a.tags//[]) | join(", ") ) + "\n" +
      "  description:\n" + ($a.description//"" | gsub("\r";""))
    ' <<<"$resp"
    echo
  fi
  # (alerts provide event, start/end (Unix UTC), description, tags.) :contentReference[oaicite:7]{index=7}
}
# ------------------------------------------------------------------------------

function simple_weather_report() {
  curl wttr.in
}

function git_init() {
  if [ -z "$1" ]; then
    printf "%s\n" "Please provide a directory name."
  else
    mkdir "$1"
    builtin cd "$1"
    pwd
    git init
    touch README.md .gitignore LICENSE
    echo "# $(basename $PWD)" >>README.md
  fi
}

# Toggle Do Not Disturb Mode
dnd() {
  if makoctl mode | grep -Fxq 'do-not-disturb'; then
    makoctl mode -r do-not-disturb
    echo "🔔 Notifications ENABLED"
  else
    makoctl mode -a do-not-disturb
    echo "🔕 Do Not Disturb ENABLED"
  fi
}

# Check Do Not Disturb Status
dndstatus() {
  if makoctl mode | grep -Fxq 'do-not-disturb'; then
    echo "🔕 Do Not Disturb is currently ON"
  else
    echo "🔔 Do Not Disturb is currently OFF"
  fi
}

function mkcd() { mkdir -p "$1" && cd "$1"; }

# Function to set brightness in percentage
set_brightness() {
  if [[ -z "$1" ]]; then
    echo "Usage: set_brightness <percentage>"
    return 1
  fi

  if brightnessctl set "$1%"; then
    echo "Brightness set to $1%"
  else
    echo "Failed to set brightness"
    return 1
  fi
}

# Function to set Hyprsunset color temperature
set_temperature() {
  if [[ -z "$1" ]]; then
    echo "Usage: set_temperature <temperature>"
    return 1
  fi

  if hyprctl hyprsunset temperature "$1"; then
    echo "Temperature set to $1"
  else
    echo "Failed to set temperature"
    return 1
  fi
}

# Toggle Do Not Disturb Mode
dnd() {
  if makoctl mode | grep -Fxq 'do-not-disturb'; then
    makoctl mode -r do-not-disturb
    echo "🔔 Notifications ENABLED"
  else
    makoctl mode -a do-not-disturb
    echo "🔕 Do Not Disturb ENABLED"
  fi
}

# Check Do Not Disturb Status
dndstatus() {
  if makoctl mode | grep -Fxq 'do-not-disturb'; then
    echo "🔕 Do Not Disturb is currently ON"
  else
    echo "🔔 Do Not Disturb is currently OFF"
  fi
}

alias get_temperature='hyprctl hyprsunset temperature'

function cdcp() {
  cd $(wl-paste)
}

function tmux-attach() {
  tmux a -t "$@"
}

function tmux-new-session() {
  tmux new -s "$@"
}

# Function: log_updates
# Description: Runs the 'checkupdates' utility and logs the output
# to a dated file in the user's Documents/upgrade-logs directory.
# Filename format: YYYY-MM-DD-pacman-syu.txt
log_updates() {
  # Get the current date in YYYY-MM-DD format
  local DATE_TAG=$(date +%F)

  # Define the target directory and file path
  local LOG_DIR="$HOME/Documents/upgrade-logs"
  local LOG_FILE="$LOG_DIR/$DATE_TAG-pacman-syu.txt"

  # Ensure the log directory exists. -p flag prevents error if directory already exists.
  echo "Ensuring log directory exists: $LOG_DIR"
  mkdir -p "$LOG_DIR"

  # Run checkupdates and redirect the output to the specified log file.
  # The 2>&1 redirects standard error (2) to standard output (1),
  # ensuring any error messages from checkupdates are also logged.
  echo "Running checkupdates and logging output to: $LOG_FILE"
  checkupdates >>"$LOG_FILE" 2>&1

  # Check the exit status of the last command (checkupdates)
  if [ $? -eq 0 ]; then
    echo "Successfully logged update information."
  else
    echo "Error or Warning during update check. Check $LOG_FILE for details."
  fi
}

log_updates_yay() {
  # Get the current date in YYYY-MM-DD format
  local DATE_TAG=$(date +%F)

  # Define the target directory and file path
  local LOG_DIR="$HOME/Documents/upgrade-logs"
  local LOG_FILE="$LOG_DIR/$DATE_TAG-yay-syu.txt"

  # Ensure the log directory exists. -p flag prevents error if directory already exists.
  echo "Ensuring log directory exists: $LOG_DIR"
  mkdir -p "$LOG_DIR"

  echo "Running yay... Make sure to quit the program before proceeding to properly log via tee."
  yay | tee "$LOG_FILE"

  if [ $? -eq 0 ]; then
    echo "Successfully logged update information."
  else
    echo "Error or Warning during update check. Check $LOG_FILE for details."
  fi
}

function connect_server() {
  $HOME/.config/scripts/server.sh $1 $2
}

export MANPAGER='nvim +Man!'
export PATH=$PATH:/home/Arieldynamic/.spicetify

# Created by `pipx` on 2025-04-20 15:45:28
export PATH="$PATH:/home/Arieldynamic/.local/bin"
eval "$(zoxide init bash)"
