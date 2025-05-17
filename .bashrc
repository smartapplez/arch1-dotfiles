#
# ~/.bashrc
#
export STARSHIP_CONFIG="/home/Arieldynamic/.config/starship/starship.toml"
eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias v='nvim'

export EDITOR=nvim
PS1='[\u@\h \W]\$ '

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function cpwd() {
  wl-copy $(pwd)
  echo "Copied $(pwd) to Clipboard!"
}

export MANPAGER='nvim +Man!'
export PATH=$PATH:/home/Arieldynamic/.spicetify

# Created by `pipx` on 2025-04-20 15:45:28
export PATH="$PATH:/home/Arieldynamic/.local/bin"
eval "$(zoxide init bash)"
