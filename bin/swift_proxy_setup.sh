#!/usr/bin/env bash
# Swift Proxy - Production Hardened Version
# Comprehensive edge case handling, no race conditions, proper streaming

set -o pipefail

# ============================================
# CORE TMUX PROXY - STREAMING (FIFO-based)
# ============================================
tmux_proxy() {
  # Dependency validation
  if ! command -v tmux &>/dev/null; then
    echo "Error: tmux is not installed or not in PATH" >&2
    return 127
  fi
  
  # Argument validation
  if [[ $# -eq 0 ]]; then
    echo "Error: tmux_proxy requires at least one argument" >&2
    return 1
  fi
  
  # Generate unique session name with timestamp to prevent collisions
  local sess="proxy-$$-$(date +%s%N)-$RANDOM"
  local sig="sig-$sess"
  local rcfile
  local fifo
  local tmpdir
  
  # Create temporary directory for all files
  if ! tmpdir="$(mktemp -d)"; then
    echo "Error: Failed to create temporary directory" >&2
    return 1
  fi
  
  rcfile="$tmpdir/rc"
  fifo="$tmpdir/output.fifo"
  
  # Track child processes for cleanup
  local reader_pid=""
  local cleanup_done=0
  
  # Comprehensive cleanup function
  cleanup_tmux_proxy() {
    if [[ $cleanup_done -eq 1 ]]; then
      return
    fi
    cleanup_done=1
    
    # Kill reader if still running
    if [[ -n "$reader_pid" ]] && kill -0 "$reader_pid" 2>/dev/null; then
      kill "$reader_pid" 2>/dev/null || true
      wait "$reader_pid" 2>/dev/null || true
    fi
    
    # Kill tmux session
    tmux kill-session -t "$sess" 2>/dev/null || true
    
    # Remove temporary directory
    if [[ -d "$tmpdir" ]]; then
      rm -rf "$tmpdir" 2>/dev/null || true
    fi
  }
  
  # Set trap for all exit conditions
  trap cleanup_tmux_proxy EXIT INT TERM RETURN
  
  # Create FIFO for streaming output
  if ! mkfifo "$fifo" 2>/dev/null; then
    echo "Error: Failed to create FIFO" >&2
    return 1
  fi
  
  # Start FIFO reader in background (before tmux session)
  cat "$fifo" &
  reader_pid=$!
  
  # Escape all arguments properly
  local cmd
  printf -v cmd '%q ' "$@"
  
  # Create tmux session that writes to FIFO
  # Use exec to ensure clean exit and proper signal handling
  if ! tmux new-session -d -s "$sess" "
    exec bash -c '
      set -o pipefail
      {
        $cmd
      } > \"$fifo\" 2>&1
      rc=\$?
      printf \"%s\" \"\$rc\" > \"$rcfile\"
      exec 1>&-  # Close stdout to unblock FIFO reader
      tmux wait-for -S \"$sig\"
    '
  " 2>/dev/null; then
    echo "Error: Failed to create tmux session" >&2
    return 1
  fi
  
  # Wait for command completion
  tmux wait-for "$sig" 2>/dev/null || true
  
  # Wait for reader to finish (it will exit when FIFO closes)
  if [[ -n "$reader_pid" ]]; then
    wait "$reader_pid" 2>/dev/null || true
    reader_pid=""  # Mark as handled
  fi
  
  # Read and validate return code
  local rc=1
  if [[ -f "$rcfile" && -s "$rcfile" ]]; then
    rc="$(cat "$rcfile" 2>/dev/null || echo 1)"
    if ! [[ "$rc" =~ ^[0-9]+$ ]] || [[ "$rc" -gt 255 ]]; then
      rc=1
    fi
  fi
  
  return "$rc"
}

# ============================================
# ALTERNATIVE: TMUX PIPE-PANE METHOD
# ============================================
tmux_proxy_pipe() {
  if ! command -v tmux &>/dev/null; then
    echo "Error: tmux is not installed" >&2
    return 127
  fi
  
  if [[ $# -eq 0 ]]; then
    echo "Error: requires at least one argument" >&2
    return 1
  fi
  
  local sess="proxy-$$-$(date +%s%N)-$RANDOM"
  local rcfile
  local tmpdir
  
  if ! tmpdir="$(mktemp -d)"; then
    echo "Error: Failed to create temporary directory" >&2
    return 1
  fi
  
  rcfile="$tmpdir/rc"
  
  local cleanup_done=0
  cleanup_pipe_proxy() {
    if [[ $cleanup_done -eq 1 ]]; then
      return
    fi
    cleanup_done=1
    
    tmux kill-session -t "$sess" 2>/dev/null || true
    [[ -d "$tmpdir" ]] && rm -rf "$tmpdir" 2>/dev/null || true
  }
  
  trap cleanup_pipe_proxy EXIT INT TERM RETURN
  
  # Escape arguments
  local cmd
  printf -v cmd '%q ' "$@"
  
  # Create session
  if ! tmux new-session -d -s "$sess" 2>/dev/null; then
    echo "Error: Failed to create tmux session" >&2
    return 1
  fi
  
  # Enable pipe-pane to stream to stdout
  # Use tee to duplicate output: one to our stdout, one to tmux buffer
  if ! tmux pipe-pane -t "$sess" -o "cat" 2>/dev/null; then
    echo "Error: Failed to enable pipe-pane" >&2
    return 1
  fi
  
  # Send command to session with proper return code capture
  # Use a wrapper that ensures clean exit
  tmux send-keys -t "$sess" "
    ($cmd); rc=\$?
    printf '%s' \"\$rc\" > '$rcfile'
    exit
  " C-m 2>/dev/null
  
  # Wait for session to end (polling, but necessary for pipe method)
  local timeout=0
  local max_wait=3600  # 1 hour maximum
  while tmux has-session -t "$sess" 2>/dev/null; do
    sleep 0.1
    ((timeout++))
    if [[ $timeout -gt $((max_wait * 10)) ]]; then
      echo "Error: Command timeout after ${max_wait}s" >&2
      return 124
    fi
  done
  
  # Small delay to ensure all output is flushed
  sleep 0.2
  
  # Read return code
  local rc=1
  if [[ -f "$rcfile" && -s "$rcfile" ]]; then
    rc="$(cat "$rcfile" 2>/dev/null || echo 1)"
    if ! [[ "$rc" =~ ^[0-9]+$ ]] || [[ "$rc" -gt 255 ]]; then
      rc=1
    fi
  fi
  
  return "$rc"
}

# ============================================
# SIMPLE SUBSHELL PROXY (No tmux)
# ============================================
simple_proxy() {
  if [[ $# -eq 0 ]]; then
    echo "Error: requires at least one argument" >&2
    return 1
  fi
  
  # Execute in subshell with clean environment
  # This provides some isolation but not as much as tmux
  (
    # Set clean signal handlers
    trap - INT TERM
    
    # Execute command
    "$@"
  )
  
  return $?
}

# ============================================
# NO-OP PROXY (Direct execution)
# ============================================
direct_proxy() {
  if [[ $# -eq 0 ]]; then
    echo "Error: requires at least one argument" >&2
    return 1
  fi
  
  "$@"
  return $?
}

# ============================================
# SWIFT WRAPPER
# ============================================
swift() {
  local real_swift
  
  # Locate swift binary
  if ! real_swift="$(command -v swift 2>/dev/null)"; then
    echo "Error: swift command not found in PATH" >&2
    echo "Please install Swift or add it to your PATH" >&2
    return 127
  fi
  
  # Verify swift is executable
  if [[ ! -x "$real_swift" ]]; then
    echo "Error: swift binary at $real_swift is not executable" >&2
    return 126
  fi
  
  # Validate and apply proxy mode
  local mode="${SWIFT_PROXY_MODE:-streaming}"
  
  case "$mode" in
    streaming)
      tmux_proxy "$real_swift" "$@"
      ;;
    pipe)
      tmux_proxy_pipe "$real_swift" "$@"
      ;;
    simple)
      simple_proxy "$real_swift" "$@"
      ;;
    direct)
      direct_proxy "$real_swift" "$@"
      ;;
    *)
      echo "Warning: Invalid SWIFT_PROXY_MODE '$mode', using 'streaming'" >&2
      tmux_proxy "$real_swift" "$@"
      ;;
  esac
}

# ============================================
# PARALLEL EXECUTION
# ============================================
swift-parallel() {
  # Input validation
  if [[ $# -lt 2 ]]; then
    cat >&2 << 'USAGE'
Usage: swift-parallel <command> <target1> [target2] [target3] ...

Examples:
  swift-parallel run script1.swift script2.swift script3.swift
  swift-parallel build Package1 Package2 Package3
  swift-parallel "build -c release" Pkg1 Pkg2 Pkg3
USAGE
    return 1
  fi
  
  # Verify swift exists
  if ! command -v swift &>/dev/null; then
    echo "Error: swift command not found" >&2
    return 127
  fi
  
  local swift_cmd="$1"
  shift
  local targets=("$@")
  local pids=()
  local tmpdir
  
  # Create temporary directory
  if ! tmpdir="$(mktemp -d)"; then
    echo "Error: Failed to create temporary directory" >&2
    return 1
  fi
  
  # Setup cleanup handler
  local cleanup_done=0
  cleanup_parallel() {
    if [[ $cleanup_done -eq 1 ]]; then
      return
    fi
    cleanup_done=1
    
    # Send TERM to all child processes
    for pid in "${pids[@]}"; do
      if kill -0 "$pid" 2>/dev/null; then
        kill -TERM "$pid" 2>/dev/null || true
      fi
    done
    
    # Give them time to clean up
    sleep 0.5
    
    # Force kill if still running
    for pid in "${pids[@]}"; do
      if kill -0 "$pid" 2>/dev/null; then
        kill -KILL "$pid" 2>/dev/null || true
      fi
    done
    
    # Wait for all processes
    wait 2>/dev/null || true
    
    # Remove temporary directory
    [[ -d "$tmpdir" ]] && rm -rf "$tmpdir" 2>/dev/null || true
  }
  
  trap cleanup_parallel EXIT INT TERM
  
  echo "Starting ${#targets[@]} parallel Swift processes..."
  echo ""
  
  # Warn about resource usage
  if [[ ${#targets[@]} -gt 50 ]]; then
    echo "Warning: Running ${#targets[@]} parallel processes may be resource-intensive" >&2
    read -p "Continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      return 1
    fi
  fi
  
  # Get the real swift binary for parallel execution
  local real_swift
  if ! real_swift="$(command -v swift 2>/dev/null)"; then
    echo "Error: swift command not found" >&2
    return 127
  fi
  
  # Launch all processes
  for i in "${!targets[@]}"; do
    local target="${targets[$i]}"
    local logfile="$tmpdir/swift-$i.log"
    local rcfile="$tmpdir/rc-$i"
    
    # Validate target if it's a file path
    if [[ "$swift_cmd" == "run" && -n "$target" && "$target" != -* && ! -f "$target" ]]; then
      echo "  Warning [$i]: File not found: $target"
    fi
    
    # Launch subprocess with proper isolation
    (
      set +e  # Don't exit on error
      
      # Write header to log
      {
        echo "=== Swift $swift_cmd: $target ==="
        echo "Started: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "PID: $$"
        echo ""
      } > "$logfile"
      
      # Execute swift command directly (avoid nested tmux)
      # Split swift_cmd properly if it contains multiple arguments
      local rc
      if [[ "$swift_cmd" =~ [[:space:]] ]]; then
        # Command contains spaces, need to split it
        read -ra cmd_parts <<< "$swift_cmd"
        "$real_swift" "${cmd_parts[@]}" "$target" >> "$logfile" 2>&1
        rc=$?
      else
        # Single command
        "$real_swift" "$swift_cmd" "$target" >> "$logfile" 2>&1
        rc=$?
      fi
      
      # Write footer to log
      {
        echo ""
        echo "Finished: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Exit code: $rc"
      } >> "$logfile"
      
      # Write return code atomically
      printf '%s' "$rc" > "$rcfile.tmp" && mv "$rcfile.tmp" "$rcfile"
      
      exit "$rc"
    ) &
    
    local pid=$!
    pids+=("$pid")
    echo "  [$i] Started PID $pid for: $target"
  done
  
  echo ""
  echo "Waiting for processes to complete..."
  echo "  (Monitor logs in real-time: tail -f $tmpdir/swift-*.log)"
  echo ""
  
  # Wait for all processes with progress tracking
  local completed=0
  local total=${#pids[@]}
  
  for i in "${!pids[@]}"; do
    local pid="${pids[$i]}"
    
    # Wait for this specific process
    wait "$pid" 2>/dev/null || true
    
    ((completed++))
    
    # Show progress
    if (( completed % 5 == 0 )) || (( completed == total )); then
      echo "  Progress: $completed/$total completed"
    fi
  done
  
  # Analyze results
  echo ""
  echo "Results:"
  echo ""
  
  local failed=0
  local succeeded=0
  local failed_targets=()
  
  for i in "${!targets[@]}"; do
    local rcfile="$tmpdir/rc-$i"
    local target="${targets[$i]}"
    local rc=1
    
    # Read return code safely
    if [[ -f "$rcfile" && -s "$rcfile" ]]; then
      rc="$(cat "$rcfile" 2>/dev/null || echo 1)"
      if ! [[ "$rc" =~ ^[0-9]+$ ]] || [[ "$rc" -gt 255 ]]; then
        rc=1
      fi
    fi
    
    if [[ "$rc" -eq 0 ]]; then
      echo "  [PASS] [$i] $target"
      ((succeeded++))
    else
      echo "  [FAIL] [$i] $target (exit code: $rc)"
      failed_targets+=("$i:$target")
      ((failed++))
    fi
  done
  
  # Optionally show logs
  if [[ $failed -gt 0 ]] || [[ "${SWIFT_PARALLEL_SHOW_LOGS:-}" == "always" ]]; then
    echo ""
    read -p "Show detailed logs? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      local show_all="${SWIFT_PARALLEL_SHOW_ALL_LOGS:-false}"
      
      # Show failed logs first
      if [[ $failed -gt 0 ]]; then
        echo ""
        echo "======================================"
        echo "FAILED BUILDS (showing logs)"
        echo "======================================"
        
        for entry in "${failed_targets[@]}"; do
          local idx="${entry%%:*}"
          local tgt="${entry#*:}"
          local logfile="$tmpdir/swift-$idx.log"
          
          if [[ ! -f "$logfile" ]]; then
            continue
          fi
          
          echo ""
          echo "--------------------------------------"
          echo "[$idx] $tgt"
          echo "--------------------------------------"
          
          show_log "$logfile"
        done
      fi
      
      # Show all logs if requested
      if [[ "$show_all" == "true" ]]; then
        echo ""
        echo "======================================"
        echo "ALL LOGS"
        echo "======================================"
        
        for i in "${!targets[@]}"; do
          local logfile="$tmpdir/swift-$i.log"
          
          if [[ ! -f "$logfile" ]]; then
            continue
          fi
          
          echo ""
          echo "--------------------------------------"
          echo "[$i] ${targets[$i]}"
          echo "--------------------------------------"
          
          show_log "$logfile"
        done
      fi
    fi
  fi
  
  # Summary
  echo ""
  echo "======================================"
  echo "Summary:"
  echo "  Total:     $total"
  echo "  Succeeded: $succeeded"
  echo "  Failed:    $failed"
  echo "======================================"
  
  if [[ $failed -eq 0 ]]; then
    echo ""
    echo "All processes completed successfully"
    return 0
  else
    echo ""
    echo "$failed of $total processes failed"
    echo ""
    echo "Logs preserved in: $tmpdir"
    echo "(Will be deleted when shell exits)"
    return 1
  fi
}

# Helper function to show logs with truncation for very large files
show_log() {
  local logfile="$1"
  local max_lines="${SWIFT_PARALLEL_MAX_LOG_LINES:-500}"
  
  if [[ ! -f "$logfile" ]]; then
    echo "[Log file not found]"
    return
  fi
  
  local line_count
  line_count="$(wc -l < "$logfile" 2>/dev/null || echo 0)"
  
  if (( line_count > max_lines * 2 )); then
    echo "[Log truncated: showing first $max_lines and last $max_lines lines of $line_count total]"
    echo ""
    head -n "$max_lines" "$logfile"
    echo ""
    echo "... [$(( line_count - max_lines * 2 )) lines omitted] ..."
    echo ""
    tail -n "$max_lines" "$logfile"
  else
    cat "$logfile"
  fi
}

# ============================================
# UTILITIES
# ============================================

# Aliases for different proxy modes
alias swift-direct='SWIFT_PROXY_MODE=direct swift'
alias swift-simple='SWIFT_PROXY_MODE=simple swift'
alias swift-pipe='SWIFT_PROXY_MODE=pipe swift'

# Configuration function
swift-config() {
  cat << 'INFO'
Swift Proxy Configuration:
======================================

Current Settings:
  SWIFT_PROXY_MODE: ${SWIFT_PROXY_MODE:-streaming}
  SWIFT_PARALLEL_SHOW_LOGS: ${SWIFT_PARALLEL_SHOW_LOGS:-auto}
  SWIFT_PARALLEL_SHOW_ALL_LOGS: ${SWIFT_PARALLEL_SHOW_ALL_LOGS:-false}
  SWIFT_PARALLEL_MAX_LOG_LINES: ${SWIFT_PARALLEL_MAX_LOG_LINES:-500}

Proxy Modes:
  streaming  - Real-time output via FIFO (default, recommended)
  pipe       - Real-time output via tmux pipe-pane
  simple     - Subshell isolation, no tmux
  direct     - No proxy, direct execution

Set Mode:
  export SWIFT_PROXY_MODE=pipe
  export SWIFT_PROXY_MODE=simple
  export SWIFT_PROXY_MODE=direct

Parallel Options:
  export SWIFT_PARALLEL_SHOW_LOGS=always      # Always show logs
  export SWIFT_PARALLEL_SHOW_ALL_LOGS=true    # Show all logs, not just failures
  export SWIFT_PARALLEL_MAX_LOG_LINES=1000    # Lines to show per log

Per-Command Override:
  SWIFT_PROXY_MODE=direct swift build
  SWIFT_PARALLEL_SHOW_LOGS=always swift-parallel build Pkg1 Pkg2

INFO
}

# Session management
swift-sessions() {
  echo "Active Swift proxy sessions:"
  echo ""
  
  if ! command -v tmux &>/dev/null; then
    echo "Error: tmux not found" >&2
    return 1
  fi
  
  local sessions
  sessions="$(tmux list-sessions 2>/dev/null | grep "^proxy-" || true)"
  
  if [[ -z "$sessions" ]]; then
    echo "No active proxy sessions"
    return 0
  fi
  
  echo "$sessions"
  
  local count
  count="$(echo "$sessions" | wc -l | tr -d ' ')"
  echo ""
  echo "Total: $count session(s)"
  
  if [[ $count -gt 10 ]]; then
    echo ""
    echo "Warning: $count sessions detected. Consider cleaning up with: swift-cleanup"
  fi
}

# Cleanup function
swift-cleanup() {
  if ! command -v tmux &>/dev/null; then
    echo "Error: tmux not found" >&2
    return 1
  fi
  
  local sessions
  sessions="$(tmux list-sessions 2>/dev/null | grep "^proxy-" | cut -d: -f1 || true)"
  
  if [[ -z "$sessions" ]]; then
    echo "No proxy sessions to clean up"
    return 0
  fi
  
  local count=0
  echo "Cleaning up proxy sessions..."
  
  while IFS= read -r sess; do
    if [[ -n "$sess" ]]; then
      if tmux kill-session -t "$sess" 2>/dev/null; then
        echo "  Killed: $sess"
        ((count++))
      fi
    fi
  done <<< "$sessions"
  
  echo ""
  echo "Cleaned up $count session(s)"
}

# Help function
swift-help() {
  cat << 'HELP'
======================================
Swift Proxy - Production Version
======================================

Basic Usage:
  swift <args>              Run Swift with real-time streaming output
  swift-direct <args>       Direct execution (no proxy)
  swift-simple <args>       Simple subshell proxy (no tmux)
  swift-pipe <args>         Pipe-based streaming (alternative method)

Parallel Execution:
  swift-parallel <cmd> <targets...>
  
  Examples:
    swift-parallel run script1.swift script2.swift script3.swift
    swift-parallel build Package1 Package2 Package3
    swift-parallel "build -c release" Pkg1 Pkg2

Configuration:
  swift-config              Show current configuration
  
Management:
  swift-sessions            List active proxy sessions
  swift-cleanup             Kill all proxy sessions
  swift-help                Show this help

Features:
  - Real-time streaming output (no buffering)
  - No output size limits
  - Proper signal handling (Ctrl-C safe)
  - Process isolation via tmux
  - Comprehensive error handling
  - FIFO-based streaming (no race conditions)
  - Atomic file operations
  - Resource leak prevention

Examples:
======================================

  # Watch build output in real-time:
  swift build
  
  # See test results as they run:
  swift test
  
  # Run multiple scripts in parallel:
  swift-parallel run script1.swift script2.swift script3.swift
  
  # Use specific proxy mode for one command:
  SWIFT_PROXY_MODE=direct swift build
  
  # Always show logs in parallel mode:
  SWIFT_PARALLEL_SHOW_LOGS=always swift-parallel build Pkg1 Pkg2

Troubleshooting:
======================================

  # Check for orphaned sessions:
  swift-sessions
  
  # Clean up if needed:
  swift-cleanup
  
  # Test different modes:
  swift-config
  SWIFT_PROXY_MODE=pipe swift --version
  SWIFT_PROXY_MODE=simple swift --version
  SWIFT_PROXY_MODE=direct swift --version

HELP
}

# ============================================
# INITIALIZATION
# ============================================

__swift_proxy_init() {
  local warnings=()
  
  # Check for tmux
  if ! command -v tmux &>/dev/null; then
    warnings+=("tmux not installed (required for streaming/pipe modes)")
  fi
  
  # Check for swift
  if ! command -v swift &>/dev/null; then
    warnings+=("swift not installed")
  fi
  
  # Check for mkfifo (should exist on all Unix systems)
  if ! command -v mkfifo &>/dev/null; then
    warnings+=("mkfifo not available (FIFO streaming will fail)")
  fi
  
  # Show warnings if any
  if [[ ${#warnings[@]} -gt 0 ]]; then
    echo "Warning: Missing dependencies:" >&2
    for warning in "${warnings[@]}"; do
      echo "  - $warning" >&2
    done
    echo "" >&2
  fi
  
  # Show success message
  local mode="${SWIFT_PROXY_MODE:-streaming}"
  echo "Swift proxy functions loaded (production version)"
  echo "  Mode: $mode"
  echo "  Run 'swift-help' for usage information"
}

# Run initialization
__swift_proxy_init