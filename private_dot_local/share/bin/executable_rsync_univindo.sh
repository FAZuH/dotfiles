#!/bin/bash

function check_continue() {
  local answer=$1
  if [ "$answer" = "Y" ]; then
    return 0  # Continue
  else
    echo "Exitting..."
    exit 1  # Exit
  fi
}

if [ "$1" = "from" ]; then
  read -rp "Sync universitas_indonesia folder from cloud to local? (Y/n) " response
  check_continue "$response"
  rclone sync gdrive:/universitas_indonesia /run/media/faz/Ventoy/universitas_indonesia/ -vP
elif [ "$1" = "into" ]; then
  read -rp "Sync universitas_indonesia folder from local to cloud? (Y/n) " response
  check_continue "$response"
  rclone sync /run/media/faz/Ventoy/universitas_indonesia/ gdrive:/universitas_indonesia -vP
else
  echo "Invalid option (use 'from' or 'into')"
  exit 1
fi
