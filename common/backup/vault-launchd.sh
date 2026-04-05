#!/usr/bin/env bash
# Wrapper called by launchd. Runs vault run-all and handles notifications.
set -euo pipefail

AGENIX_DIR="$(getconf DARWIN_USER_TEMP_DIR)/agenix"
export BORG_PASSPHRASE="$(cat "$AGENIX_DIR/borg-passphrase")"
MSMTP_CONFIG="$AGENIX_DIR/msmtp-config"
EMAIL="$(cat "$AGENIX_DIR/email")"
STALE_DAYS=7
LAST_BORG_FILE="$HOME/.local/share/vault-backup/last-borg-success"

notify() {
  local title="$1"
  local message="$2"
  osascript -e "display notification \"$message\" with title \"$title\" sound name \"default\""
  if [ -f "$MSMTP_CONFIG" ]; then
    echo -e "Subject: $title\n\n$message" | msmtp -C "$MSMTP_CONFIG" "$EMAIL"
  fi
}

# Run the backup
if ! vault run-all 2>&1; then
  notify "Vault Backup Failed" "vault run-all exited with an error. Check: vault log"
fi

# Check staleness independently
if [ -f "$LAST_BORG_FILE" ]; then
  last_borg=$(cat "$LAST_BORG_FILE")
  now=$(date +%s)
  days_since=$(( (now - last_borg) / 86400 ))
  if [ "$days_since" -ge "$STALE_DAYS" ]; then
    notify "Vault Backup Warning" "No local backup in $days_since days. Plug in your HDD!"
  fi
else
  notify "Vault Backup Warning" "No local backup has ever completed. Plug in your HDD!"
fi
