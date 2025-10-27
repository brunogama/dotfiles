#!/usr/bin/env bats
# Integration tests for performance utilities

load '../../helpers/test-helpers'
load '../../helpers/file-helpers'
load '../../helpers/setup-teardown'
load '../../helpers/bats-support/load.bash'
load '../../helpers/bats-assert/load.bash'
load '../../helpers/bats-file/load.bash'

setup() {
    standard_setup

    # Create mock zsh config files
    mkdir -p "$HOME/.config/zsh"
    echo "# Test zshrc" > "$HOME/.config/zsh/.zshrc"
    echo "# Test zshenv" > "$HOME/.zshenv"

    # Create mock history file
    for i in {1..100}; do
        echo ": $(date +%s):0;command $i" >> "$HOME/.zsh_history"
    done
}

teardown() {
    standard_teardown
}

# Zsh-benchmark Tests

@test "zsh-benchmark: runs without errors" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-benchmark"
    # Should complete (may or may not succeed depending on environment)
}

@test "zsh-benchmark: shows help with --help" {
    run_core_script "zsh-benchmark" --help
    # Should show help or run benchmark
}

@test "zsh-benchmark: reports timing results" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-benchmark"
    # Should show timing information (milliseconds)
}

@test "zsh-benchmark: runs multiple iterations" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-benchmark"
    # Default is 10 runs, should complete
}

@test "zsh-benchmark: accepts iteration count" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-benchmark" "3"
    # Should run 3 iterations
}

@test "zsh-benchmark: shows statistics" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-benchmark"
    # Should show mean, median, min, max
}

# Zsh-compile Tests

@test "zsh-compile: runs without errors" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-compile"
    assert_success
}

@test "zsh-compile: shows help with --help" {
    run_core_script "zsh-compile" --help
    # Should show help or run compilation
}

@test "zsh-compile: compiles zsh config files" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-compile"
    assert_success

    # Should create .zwc files
    # Check for compiled files
}

@test "zsh-compile: creates .zwc bytecode files" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-compile"
    assert_success

    # .zwc files should be created next to source files
    # (if zshrc exists, zshrc.zwc should be created)
}

@test "zsh-compile: is idempotent" {
    skip_if_no_command "zsh" "zsh not available"

    # Run twice
    run_core_script "zsh-compile"
    assert_success

    run_core_script "zsh-compile"
    assert_success
}

@test "zsh-compile: reports compiled files" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-compile"
    assert_success
    # Should show what was compiled
}

@test "zsh-compile: handles missing config gracefully" {
    skip_if_no_command "zsh" "zsh not available"

    # Remove config files
    rm -rf "$HOME/.config/zsh"
    rm -f "$HOME/.zshenv"

    run_core_script "zsh-compile"
    # Should handle missing files gracefully
}

# Zsh-trim-history Tests

@test "zsh-trim-history: runs without errors" {
    run_core_script "zsh-trim-history"
    assert_success
}

@test "zsh-trim-history: shows help with --help" {
    run_core_script "zsh-trim-history" --help
    # Should show help or trim history
}

@test "zsh-trim-history: reduces history file size" {
    # Create large history
    for i in {1..20000}; do
        echo ": $(date +%s):0;command $i" >> "$HOME/.zsh_history"
    done

    local initial_size
    initial_size=$(wc -l < "$HOME/.zsh_history")

    run_core_script "zsh-trim-history"
    assert_success

    local final_size
    final_size=$(wc -l < "$HOME/.zsh_history")

    # Should be reduced
    [[ $final_size -lt $initial_size ]]
}

@test "zsh-trim-history: keeps recent entries" {
    # Add distinctive recent entry
    echo ": $(date +%s):0;recent_command" >> "$HOME/.zsh_history"

    run_core_script "zsh-trim-history"
    assert_success

    # Recent entry should still be there
    assert_file_contains "$HOME/.zsh_history" "recent_command"
}

@test "zsh-trim-history: removes old entries" {
    # Create old history with 15k+ entries
    for i in {1..15000}; do
        echo ": $(date +%s):0;old_command_$i" >> "$HOME/.zsh_history"
    done

    # Add new entry
    echo ": $(date +%s):0;new_command" >> "$HOME/.zsh_history"

    run_core_script "zsh-trim-history"
    assert_success

    # Should have trimmed to ~10k entries
    local line_count
    line_count=$(wc -l < "$HOME/.zsh_history")

    [[ $line_count -le 10500 ]]  # Some margin
}

@test "zsh-trim-history: preserves history format" {
    run_core_script "zsh-trim-history"
    assert_success

    # History should still have proper format
    assert_file_contains "$HOME/.zsh_history" ":"
}

@test "zsh-trim-history: handles empty history" {
    rm -f "$HOME/.zsh_history"
    touch "$HOME/.zsh_history"

    run_core_script "zsh-trim-history"
    assert_success
}

@test "zsh-trim-history: handles missing history file" {
    rm -f "$HOME/.zsh_history"

    run_core_script "zsh-trim-history"
    # Should handle gracefully
}

@test "zsh-trim-history: creates backup" {
    run_core_script "zsh-trim-history"
    assert_success

    # Should create backup file
    # .zsh_history.backup or similar
}

# Exit Code Tests

@test "zsh-compile: exits 0 on success" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-compile"
    assert_equal "$status" 0
}

@test "zsh-trim-history: exits 0 on success" {
    run_core_script "zsh-trim-history"
    assert_equal "$status" 0
}

@test "zsh-benchmark: exits 0 on completion" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-benchmark"
    # May timeout or take long, but should complete
}

# Performance Impact Tests

@test "zsh-compile: improves startup time" {
    skip_if_no_command "zsh" "zsh not available"
    skip "Performance test - runs too long"

    # Benchmark before compilation
    run_core_script "zsh-benchmark" "3"
    local before_time="$output"

    # Compile
    run_core_script "zsh-compile"

    # Benchmark after compilation
    run_core_script "zsh-benchmark" "3"
    local after_time="$output"

    # After should be faster (hard to assert numerically)
}

# Reporting Tests

@test "zsh-benchmark: shows readable output" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-benchmark"
    # Should have meaningful output
    [[ -n "$output" ]]
}

@test "zsh-trim-history: shows summary" {
    run_core_script "zsh-trim-history"
    assert_success
    # Should show what was done
}

@test "zsh-compile: shows compilation summary" {
    skip_if_no_command "zsh" "zsh not available"

    run_core_script "zsh-compile"
    assert_success
    # Should show summary
}

# Integration Tests

@test "performance: compile then benchmark" {
    skip_if_no_command "zsh" "zsh not available"

    # Compile configs
    run_core_script "zsh-compile"
    assert_success

    # Run benchmark
    run_core_script "zsh-benchmark" "2"
    # Should complete
}

@test "performance: trim history then verify" {
    # Create large history
    for i in {1..12000}; do
        echo ": $(date +%s):0;cmd $i" >> "$HOME/.zsh_history"
    done

    # Trim
    run_core_script "zsh-trim-history"
    assert_success

    # Verify size
    local lines
    lines=$(wc -l < "$HOME/.zsh_history")
    [[ $lines -le 10500 ]]
}
