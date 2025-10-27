#!/usr/bin/env bats

@test "minimal test - addition works" {
    result="$((2 + 2))"
    [ "$result" -eq 4 ]
}

@test "minimal test - echo works" {
    run echo "hello"
    [ "$status" -eq 0 ]
    [ "$output" = "hello" ]
}
