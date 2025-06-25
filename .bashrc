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
  echo "Copied $(pwd) to Clipboard!"
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

  local response=$(curl --silent 'https://api.openweathermap.org/data/2.5/weather?id=5128581&units=imperial&appid=f7835911942b441743304c8e3a4aa0fc')

  local status=$(echo $response | jq -r '.cod')

  # Check for the 200 response indicating a successful API query.
  case $status in

  200)
    printf "Location: %s %s\n" "$(echo $response | jq '.name') $(echo $response | jq '.sys.country')"
    printf "Forecast: %s\n" "$(echo $response | jq '.weather[].description')"
    printf "Temperature: %.1f°F\n" "$(echo $response | jq '.main.temp')"
    printf "Temp Min: %.1f°F\n" "$(echo $response | jq '.main.temp_min')"
    printf "Temp Max: %.1f°F\n" "$(echo $response | jq '.main.temp_max')"
    ;;
  401)
    echo "401 error"
    ;;
  *)
    echo "error"
    ;;

  esac

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

function mkcd() { mkdir -p "$1" && cd "$1"; }

export MANPAGER='nvim +Man!'
export PATH=$PATH:/home/Arieldynamic/.spicetify

# Created by `pipx` on 2025-04-20 15:45:28
export PATH="$PATH:/home/Arieldynamic/.local/bin"
eval "$(zoxide init bash)"
