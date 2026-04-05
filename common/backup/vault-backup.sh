#!/usr/bin/env bash
set -euo pipefail
cd "$HOME"

VAULT="$HOME/vault"
REPOS_DIR="$HOME/dev/personal"
RCLONE_REMOTE="dropbox:vault"
STATE_DIR="$HOME/.local/share/vault-backup"
LOG_FILE="$STATE_DIR/backup.log"
LAST_BORG_FILE="$STATE_DIR/last-borg-success"

mkdir -p "$STATE_DIR"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

cmd_backup_create() {
  if [ ! -d "/Volumes/hdd-seagate" ]; then
    log "HDD not mounted, skipping borgmatic"
    return 1
  fi

  log "Starting borgmatic backup..."
  if borgmatic --verbosity 1 2>>"$LOG_FILE"; then
    log "Borgmatic backup completed successfully"
    date +%s > "$LAST_BORG_FILE"
  else
    log "ERROR: Borgmatic backup failed"
    return 1
  fi
}

cmd_sync_dropbox() {
  if [ ! -d "$VAULT" ]; then
    log "ERROR: Vault directory $VAULT does not exist, refusing to sync"
    return 1
  fi

  # Safety: count files in vault. Refuse to sync if vault looks empty.
  file_count=$(find "$VAULT" -type f -maxdepth 3 2>/dev/null | wc -l)
  if [ "$file_count" -lt 1 ]; then
    log "ERROR: Vault appears empty, refusing to sync to Dropbox"
    return 1
  fi

  log "Starting rclone sync to Dropbox..."
  if rclone sync "$VAULT" "$RCLONE_REMOTE" \
    --max-delete 50 \
    --log-file="$LOG_FILE" \
    --log-level INFO; then
    log "Rclone sync completed successfully"
  else
    log "ERROR: Rclone sync to Dropbox failed (possibly hit --max-delete safety limit)"
    return 1
  fi
}

cmd_mirror_repos() {
  if [ ! -d "$REPOS_DIR" ]; then
    log "No repos directory found at $REPOS_DIR"
    return 0
  fi

  log "Mirroring git repos from $REPOS_DIR..."
  mkdir -p "$VAULT/repos"

  for repo in "$REPOS_DIR"/*/; do
    if [ -d "$repo/.git" ]; then
      name=$(basename "$repo")
      mirror="$VAULT/repos/$name.git"

      if [ -d "$mirror" ]; then
        log "Updating mirror: $name"
        git -C "$mirror" remote update 2>>"$LOG_FILE" || {
          log "WARNING: Failed to update mirror for $name"
        }
      else
        log "Creating mirror: $name"
        git clone --mirror "$repo" "$mirror" 2>>"$LOG_FILE" || {
          log "WARNING: Failed to create mirror for $name"
        }
      fi
    fi
  done

  log "Git mirror sync done"
}

cmd_run_all() {
  if [ ! -d "$VAULT" ]; then
    log "ERROR: Vault directory $VAULT does not exist"
    exit 1
  fi

  cmd_mirror_repos
  cmd_backup_create || log "Borg step skipped or failed, continuing..."
  cmd_sync_dropbox

  log "Full backup run finished"
}

cmd_status() {
  echo "Vault:    $VAULT"
  echo "HDD:      $([ -d /Volumes/hdd-seagate ] && echo 'mounted' || echo 'not mounted')"
  if [ -f "$LAST_BORG_FILE" ]; then
    last_borg=$(cat "$LAST_BORG_FILE")
    now=$(date +%s)
    days_since=$(( (now - last_borg) / 86400 ))
    echo "Last backup: $days_since days ago ($(date -r "$last_borg" '+%Y-%m-%d %H:%M'))"
  else
    echo "Last backup: never"
  fi
  echo "Log:      $LOG_FILE"
}

usage() {
  echo "Usage: vault <command>"
  echo ""
  echo "Commands:"
  echo "  backup create    Create a borg snapshot via borgmatic"
  echo "  sync dropbox     Sync vault to Dropbox via rclone"
  echo "  mirror-repos     Mirror git repos from ~/dev/personal into vault"
  echo "  run-all          Run mirror + backup + sync (what launchd runs)"
  echo "  status           Show backup status"
  echo "  log              Tail the backup log"
}

case "${1:-}" in
  backup)
    case "${2:-}" in
      create) cmd_backup_create ;;
      *) echo "Usage: vault backup create"; exit 1 ;;
    esac
    ;;
  sync)
    case "${2:-}" in
      dropbox) cmd_sync_dropbox ;;
      *) echo "Usage: vault sync dropbox"; exit 1 ;;
    esac
    ;;
  mirror-repos) cmd_mirror_repos ;;
  run-all)      cmd_run_all ;;
  status)       cmd_status ;;
  log)
    if [ -f "$LOG_FILE" ]; then
      tail -f "$LOG_FILE"
    else
      echo "No backups have been run yet. Run 'vault backup create' to create your first backup."
    fi
    ;;
  help|-h|--help) usage ;;
  *)
    usage
    exit 1
    ;;
esac
