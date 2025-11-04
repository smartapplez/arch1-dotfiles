#!/bin/bash

# Preset servers
declare -A servers=(
  [0]="computerguy21@olympus.ece.tamu.edu"
  [1]="computerguy21@linux.cse.tamu.edu"
  [2]="computerguy21@grace.hprc.tamu.edu"
)

# Help function
usage() {
  echo "Usage:"
  echo "  $0 ssh <label>     - SSH into preset server"
  echo "  $0 sftp <label>    - SFTP into preset server"
  echo "  $0 list            - List all presets"
  exit 1
}

# Check arguments
if [[ $# -lt 1 ]]; then
  usage
fi

case "$1" in
list)
  echo "=== Preset Servers ==="
  for label in "${!servers[@]}"; do
    echo "[$label]  ${servers[$label]}"
  done | sort
  ;;

ssh | sftp)
  if [[ -z "$2" ]]; then
    echo "Error: Missing label argument"
    usage
  fi
  if [[ -z "${servers[$2]}" ]]; then
    echo "Error: Invalid label '$2'"
    exit 1
  fi
  if [[ "$1" == "ssh" && "$2" == "0" ]]; then
    #Automatically do X11 formwarding when connecting to olympus server
    echo "Connecting via $1 to ${servers[$2]} with X11 forwarding..."
    $1 -Y "${servers[$2]}"
  else
    echo "Connecting via $1 to ${servers[$2]}..."
    $1 "${servers[$2]}"
  fi
  ;;

*)
  echo "Error: Invalid command '$1'"
  usage
  ;;
esac
