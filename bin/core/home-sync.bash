#!/usr/bin/env bash

# Home Environment & Credentials Sync Service
# Syncs dotfiles, credentials, and environment settings across machines

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to auto-detect dotfiles directory
detect_dotfiles_dir() {
    # Determine dotfiles root from script location
    # Resolve symlinks first, then go up two levels from bin/core/
    local script_real="$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || realpath "${BASH_SOURCE[0]}" 2>/dev/null || echo "${BASH_SOURCE[0]}")"
    local script_path="$(cd "$(dirname "$script_real")/../.." && pwd)"

    if [[ -d "$script_path/.git" ]]; then
        echo "$script_path"
        return 0
    fi

    log "ERROR" "Could not find dotfiles git repository at: $script_path"
    log "INFO" "This script should be located at <dotfiles>/bin/core/home-sync"
    return 1
}

# Function to check if directory is a git repository
is_git_repo() {
    local dir="${1:-$(pwd)}"
    (cd "$dir" && git rev-parse --git-dir >/dev/null 2>&1)
}

# Configuration
DOTFILES_DIR="${DOTFILES_DIR:-$(detect_dotfiles_dir || echo "$HOME/.config")}"
CONFIG_FILE="$HOME/.config/home-sync/config.yml"
LOG_DIR="$HOME/.config/home-sync/logs"
LOCK_FILE="/tmp/home-sync.lock"

# Default configuration
DEFAULT_SYNC_INTERVAL=3600  # 1 hour
DEFAULT_BACKUP_RETENTION=30 # 30 days

# Function to log messages
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        "INFO")  echo -e "${BLUE}[INFO]${NC} $message" ;;
        "SUCCESS") echo -e "${GREEN}[SUCCESS]${NC} $message" ;;
        "WARN")  echo -e "${YELLOW}[WARN]${NC} $message" ;;
        "ERROR") echo -e "${RED}[ERROR]${NC} $message" ;;
    esac

    # Also log to file if log directory exists
    if [[ -d "$LOG_DIR" ]]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_DIR/sync.log"
    fi
}

# Function to display usage
usage() {
    cat << EOF
Home Environment & Credentials Sync Service

Usage: $0 [COMMAND] [OPTIONS]

COMMANDS:
    sync, s         Perform full sync (dotfiles + credentials)
    dotfiles, d     Sync only dotfiles
    credentials, c  Sync only credentials
    push, p         Push local changes to remote
    pull, l         Pull remote changes
    status, st      Show sync status
    daemon          Run as background daemon
    stop-daemon     Stop background daemon
    config          Show/edit configuration
    logs            Show sync logs
    setup           Initial setup and configuration
    help, h         Show this help message

OPTIONS:
    --dry-run       Show what would be synced without doing it
    --force         Force sync even if conflicts exist
    --quiet, -q     Suppress output (except errors)
    --verbose, -v   Verbose output

EXAMPLES:
    $0 sync         # Full sync (dotfiles + credentials)
    $0 push         # Push local changes
    $0 pull         # Pull remote changes
    $0 daemon       # Run as background service
    $0 setup        # Initial configuration

CONFIGURATION:
    Edit: $CONFIG_FILE
    Logs: $LOG_DIR/

EOF
}

# Function to check prerequisites
check_prerequisites() {
    local missing_deps=()

    # Check required commands
    for cmd in git stow; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    # Check for credential management scripts
    for script in store-api-key dump-api-keys credmatch; do
        if ! command -v "$script" &> /dev/null; then
            missing_deps+=("$script")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log "ERROR" "Missing dependencies: ${missing_deps[*]}"
        log "INFO" "Please install missing dependencies and ensure dotfiles are properly set up"
        return 1
    fi

    return 0
}

# Function to load configuration
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log "WARN" "Configuration file not found: $CONFIG_FILE"
        log "INFO" "Run '$0 setup' to create initial configuration"
        return 1
    fi

    # Source configuration (simplified YAML parsing)
    # In a real implementation, you might want to use yq or python
    # For now, we'll use a simple approach
    export SYNC_INTERVAL="${SYNC_INTERVAL:-$DEFAULT_SYNC_INTERVAL}"
    export BACKUP_RETENTION="${BACKUP_RETENTION:-$DEFAULT_BACKUP_RETENTION}"
    export CREDENTIAL_MASTER_PASSWORD="${CREDENTIAL_MASTER_PASSWORD:-}"
    export REMOTE_BACKUP_ENABLED="${REMOTE_BACKUP_ENABLED:-true}"
    export AUTO_PUSH_ENABLED="${AUTO_PUSH_ENABLED:-true}"

    return 0
}

# Function to create lock file
acquire_lock() {
    if [[ -f "$LOCK_FILE" ]]; then
        local pid=$(cat "$LOCK_FILE" 2>/dev/null || echo "")
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            log "ERROR" "Another sync process is running (PID: $pid)"
            return 1
        else
            log "WARN" "Stale lock file found, removing"
            rm -f "$LOCK_FILE"
        fi
    fi

    echo $$ > "$LOCK_FILE"
    return 0
}

# Function to release lock file
release_lock() {
    rm -f "$LOCK_FILE"
}

# Function to sync dotfiles
sync_dotfiles() {
    local dry_run="${1:-false}"
    local force="${2:-false}"

    log "INFO" "Syncing dotfiles..."

    # Validate git repository exists
    if ! is_git_repo "$DOTFILES_DIR"; then
        log "ERROR" "Not a git repository: $DOTFILES_DIR"
        log "INFO" "Initialize with: cd $DOTFILES_DIR && git init"
        return 1
    fi

    cd "$DOTFILES_DIR"

    # Check for uncommitted changes
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
        if [[ "$force" == "true" ]]; then
            log "WARN" "Uncommitted changes found, committing with auto-message"
            git add .
            git commit -m "chore: auto-commit before sync - $(date '+%Y-%m-%d %H:%M:%S')"
        else
            log "ERROR" "Uncommitted changes found. Use --force to auto-commit or commit manually"
            return 1
        fi
    fi

    if [[ "$dry_run" == "true" ]]; then
        log "INFO" "[DRY RUN] Would sync dotfiles repository"
        return 0
    fi

    # Pull latest changes
    log "INFO" "Pulling latest dotfiles changes..."
    if git pull; then
        log "SUCCESS" "Dotfiles updated successfully"
    else
        log "ERROR" "Failed to pull dotfiles changes"
        return 1
    fi

    return 0
}

# Function to sync credentials
sync_credentials() {
    local dry_run="${1:-false}"
    local direction="${2:-pull}"  # pull or push

    log "INFO" "Syncing credentials ($direction)..."

    if [[ -z "$CREDENTIAL_MASTER_PASSWORD" ]]; then
        log "ERROR" "Credential master password not configured"
        log "INFO" "Set CREDENTIAL_MASTER_PASSWORD in $CONFIG_FILE"
        return 1
    fi

    if [[ "$dry_run" == "true" ]]; then
        log "INFO" "[DRY RUN] Would sync credentials via credmatch"
        return 0
    fi

    case "$direction" in
        "pull")
            log "INFO" "Syncing credentials from remote storage..."
            if ws-sync "$CREDENTIAL_MASTER_PASSWORD"; then
                log "SUCCESS" "Credentials synced from remote"
            else
                log "ERROR" "Failed to sync credentials from remote"
                return 1
            fi
            ;;
        "push")
            log "INFO" "Backing up credentials to remote storage..."
            if ws-backup "$CREDENTIAL_MASTER_PASSWORD"; then
                log "SUCCESS" "Credentials backed up to remote"
            else
                log "ERROR" "Failed to backup credentials to remote"
                return 1
            fi
            ;;
        *)
            log "ERROR" "Invalid sync direction: $direction"
            return 1
            ;;
    esac

    return 0
}

# Function to perform full sync
full_sync() {
    local dry_run="${1:-false}"
    local force="${2:-false}"

    log "INFO" "Starting full home environment sync..."

    # Sync dotfiles first
    if ! sync_dotfiles "$dry_run" "$force"; then
        log "ERROR" "Dotfiles sync failed"
        return 1
    fi

    # Then sync credentials
    if ! sync_credentials "$dry_run" "pull"; then
        log "ERROR" "Credential sync failed"
        return 1
    fi

    log "SUCCESS" "Full sync completed successfully"
    return 0
}

# Function to push changes
push_changes() {
    local dry_run="${1:-false}"

    log "INFO" "Pushing local changes..."

    # Validate git repository exists
    if ! is_git_repo "$DOTFILES_DIR"; then
        log "ERROR" "Not a git repository: $DOTFILES_DIR"
        log "INFO" "Initialize with: cd $DOTFILES_DIR && git init"
        return 1
    fi

    cd "$DOTFILES_DIR"

    if [[ "$dry_run" == "true" ]]; then
        log "INFO" "[DRY RUN] Would push dotfiles and backup credentials"
        return 0
    fi

    # Push dotfiles
    if git push; then
        log "SUCCESS" "Dotfiles pushed successfully"
    else
        log "ERROR" "Failed to push dotfiles"
        return 1
    fi

    # Backup credentials
    if ! sync_credentials "$dry_run" "push"; then
        log "ERROR" "Failed to backup credentials"
        return 1
    fi

    log "SUCCESS" "All changes pushed successfully"
    return 0
}

# Function to show status
show_status() {
    log "INFO" "Home Environment Sync Status"
    echo

    # Dotfiles status
    echo "=== Dotfiles Status ==="
    echo "Repository: $DOTFILES_DIR"
    if is_git_repo "$DOTFILES_DIR"; then
        cd "$DOTFILES_DIR"
        git status --short
    else
        echo "Not a git repository"
    fi

    echo
    echo "=== Credentials Status ==="
    if command -v ws-list &> /dev/null; then
        local secret_count=$(ws-list 2>/dev/null | wc -l || echo "0")
        echo "Stored secrets: $secret_count"
    else
        echo "Credential management not available"
    fi

    echo
    echo "=== Service Status ==="
    if [[ -f "$LOCK_FILE" ]]; then
        local pid=$(cat "$LOCK_FILE" 2>/dev/null || echo "")
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            echo "Sync service: Running (PID: $pid)"
        else
            echo "Sync service: Stopped (stale lock file)"
        fi
    else
        echo "Sync service: Stopped"
    fi

    echo
    echo "=== Configuration ==="
    echo "Config file: $CONFIG_FILE"
    echo "Log directory: $LOG_DIR"
    echo "Sync interval: ${SYNC_INTERVAL:-$DEFAULT_SYNC_INTERVAL} seconds"
}

# Function to run as daemon
run_daemon() {
    log "INFO" "Starting home sync daemon..."

    if ! acquire_lock; then
        return 1
    fi

    trap release_lock EXIT

    # Load configuration
    load_config

    local sync_interval="${SYNC_INTERVAL:-$DEFAULT_SYNC_INTERVAL}"

    log "INFO" "Daemon started with sync interval: $sync_interval seconds"

    while true; do
        log "INFO" "Performing scheduled sync..."

        if full_sync "false" "false"; then
            log "SUCCESS" "Scheduled sync completed"
        else
            log "ERROR" "Scheduled sync failed"
        fi

        # Auto-push if enabled
        if [[ "$AUTO_PUSH_ENABLED" == "true" ]]; then
            log "INFO" "Auto-pushing changes..."
            push_changes "false" || log "WARN" "Auto-push failed"
        fi

        log "INFO" "Sleeping for $sync_interval seconds..."
        sleep "$sync_interval"
    done
}

# Function to stop daemon
stop_daemon() {
    if [[ -f "$LOCK_FILE" ]]; then
        local pid=$(cat "$LOCK_FILE" 2>/dev/null || echo "")
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            log "INFO" "Stopping daemon (PID: $pid)..."
            kill "$pid"
            rm -f "$LOCK_FILE"
            log "SUCCESS" "Daemon stopped"
        else
            log "WARN" "Daemon not running (removing stale lock file)"
            rm -f "$LOCK_FILE"
        fi
    else
        log "INFO" "Daemon not running"
    fi
}

# Function to show logs
show_logs() {
    local log_file="$LOG_DIR/sync.log"

    if [[ -f "$log_file" ]]; then
        tail -50 "$log_file"
    else
        log "WARN" "No log file found: $log_file"
    fi
}

# Function to setup initial configuration
setup_service() {
    log "INFO" "Setting up home sync service..."

    # Create directories
    mkdir -p "$(dirname "$CONFIG_FILE")" "$LOG_DIR"

    # Create configuration file
    cat > "$CONFIG_FILE" << EOF
# Home Environment Sync Configuration
# YAML format (simplified parsing)

# Sync interval in seconds (default: 3600 = 1 hour)
sync_interval: $DEFAULT_SYNC_INTERVAL

# Backup retention in days (default: 30)
backup_retention: $DEFAULT_BACKUP_RETENTION

# Credential master password (set this!)
# credential_master_password: "your-secure-master-password"

# Enable remote backup of credentials
remote_backup_enabled: true

# Auto-push changes after sync
auto_push_enabled: true

# Notification settings
notifications_enabled: true

# Sync filters (what to sync)
sync_dotfiles: true
sync_credentials: true
sync_homebrew: true

# Machine-specific settings
machine_profile: "default"  # default, work, personal, server

EOF

    log "SUCCESS" "Configuration created: $CONFIG_FILE"
    log "INFO" "Please edit the configuration file to set your master password and preferences"

    # Create log rotation script
    cat > "$LOG_DIR/rotate.sh" << 'EOF'
#!/bin/bash
# Log rotation script
LOG_FILE="$HOME/.config/home-sync/logs/sync.log"
if [[ -f "$LOG_FILE" ]] && [[ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt 10485760 ]]; then
    mv "$LOG_FILE" "$LOG_FILE.$(date +%Y%m%d_%H%M%S)"
    touch "$LOG_FILE"
    # Keep only last 10 rotated logs
    ls -t "$LOG_FILE".* | tail -n +11 | xargs rm -f
fi
EOF
    chmod +x "$LOG_DIR/rotate.sh"

    log "SUCCESS" "Home sync service setup completed"
    log "INFO" "Next steps:"
    echo "  1. Edit configuration: $CONFIG_FILE"
    echo "  2. Set your credential master password"
    echo "  3. Test sync: home-sync sync --dry-run"
    echo "  4. Start daemon: home-sync daemon"
}

# Main function
main() {
    local command="${1:-help}"
    local dry_run=false
    local force=false
    local quiet=false
    local verbose=false

    # Parse global options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                dry_run=true
                shift
                ;;
            --force)
                force=true
                shift
                ;;
            --quiet|-q)
                quiet=true
                shift
                ;;
            --verbose|-v)
                verbose=true
                shift
                ;;
            -*)
                log "ERROR" "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                break
                ;;
        esac
    done

    command="${1:-help}"

    # Redirect output if quiet mode
    if [[ "$quiet" == "true" ]]; then
        exec 1>/dev/null
    fi

    # Create log directory
    mkdir -p "$LOG_DIR"

    case "$command" in
        "sync"|"s")
            check_prerequisites && acquire_lock && full_sync "$dry_run" "$force"
            release_lock
            ;;
        "dotfiles"|"d")
            check_prerequisites && acquire_lock && sync_dotfiles "$dry_run" "$force"
            release_lock
            ;;
        "credentials"|"c")
            check_prerequisites && acquire_lock && sync_credentials "$dry_run" "pull"
            release_lock
            ;;
        "push"|"p")
            check_prerequisites && acquire_lock && push_changes "$dry_run"
            release_lock
            ;;
        "pull"|"l")
            check_prerequisites && acquire_lock && full_sync "$dry_run" "$force"
            release_lock
            ;;
        "status"|"st")
            show_status
            ;;
        "daemon")
            check_prerequisites && run_daemon
            ;;
        "stop-daemon")
            stop_daemon
            ;;
        "config")
            if [[ -f "$CONFIG_FILE" ]]; then
                cat "$CONFIG_FILE"
            else
                log "WARN" "Configuration file not found. Run 'home-sync setup' first."
            fi
            ;;
        "logs")
            show_logs
            ;;
        "setup")
            setup_service
            ;;
        "help"|"h"|*)
            usage
            ;;
    esac
}

# Run main function
main "$@"
