#!/usr/bin/env bash
# File system helper functions for bats integration tests

# Assert symlink exists
assert_symlink_exists() {
    local link_path="$1"

    [[ -L "$link_path" ]] || {
        echo "Symlink does not exist: $link_path" >&2
        return 1
    }
}

# Assert symlink points to target
assert_symlink_to() {
    local link_path="$1"
    local expected_target="$2"

    assert_symlink_exists "$link_path"

    local actual_target
    actual_target="$(readlink "$link_path")"

    [[ "$actual_target" == "$expected_target" ]] || {
        echo "Symlink points to wrong target" >&2
        echo "  Expected: $expected_target" >&2
        echo "  Actual:   $actual_target" >&2
        return 1
    }
}

# Assert symlink is broken
assert_broken_symlink() {
    local link_path="$1"

    assert_symlink_exists "$link_path"

    if [[ -e "$link_path" ]]; then
        echo "Symlink is not broken, points to existing file: $link_path" >&2
        return 1
    fi
}

# Create symlink
create_symlink() {
    local target="$1"
    local link_path="$2"

    ln -sf "$target" "$link_path"
}

# Remove symlink
remove_symlink() {
    local link_path="$1"

    if [[ -L "$link_path" ]]; then
        rm "$link_path"
    fi
}

# Assert file is executable
assert_executable() {
    local file_path="$1"

    [[ -x "$file_path" ]] || {
        echo "File is not executable: $file_path" >&2
        return 1
    }
}

# Assert file is not executable
assert_not_executable() {
    local file_path="$1"

    if [[ -x "$file_path" ]]; then
        echo "File is executable, expected not executable: $file_path" >&2
        return 1
    fi
}

# Make file executable
make_executable() {
    local file_path="$1"
    chmod +x "$file_path"
}

# Assert file permissions
assert_permissions() {
    local file_path="$1"
    local expected_perms="$2"

    local actual_perms
    if [[ "$(uname)" == "Darwin" ]]; then
        actual_perms="$(stat -f "%OLp" "$file_path")"
    else
        actual_perms="$(stat -c "%a" "$file_path")"
    fi

    [[ "$actual_perms" == "$expected_perms" ]] || {
        echo "File has wrong permissions" >&2
        echo "  Expected: $expected_perms" >&2
        echo "  Actual:   $actual_perms" >&2
        return 1
    }
}

# Assert file size
assert_file_size() {
    local file_path="$1"
    local expected_size="$2"

    local actual_size
    if [[ "$(uname)" == "Darwin" ]]; then
        actual_size="$(stat -f "%z" "$file_path")"
    else
        actual_size="$(stat -c "%s" "$file_path")"
    fi

    [[ "$actual_size" == "$expected_size" ]] || {
        echo "File has wrong size" >&2
        echo "  Expected: $expected_size bytes" >&2
        echo "  Actual:   $actual_size bytes" >&2
        return 1
    }
}

# Assert file is empty
assert_file_empty() {
    local file_path="$1"

    [[ ! -s "$file_path" ]] || {
        echo "File is not empty: $file_path" >&2
        echo "Size: $(wc -c < "$file_path") bytes" >&2
        return 1
    }
}

# Assert file is not empty
assert_file_not_empty() {
    local file_path="$1"

    [[ -s "$file_path" ]] || {
        echo "File is empty: $file_path" >&2
        return 1
    }
}

# Assert file contains line
assert_file_contains_line() {
    local file_path="$1"
    local expected_line="$2"

    grep -Fxq "$expected_line" "$file_path" || {
        echo "File does not contain line: $expected_line" >&2
        echo "File contents:" >&2
        cat "$file_path" >&2
        return 1
    }
}

# Assert file does not contain text
assert_file_not_contains() {
    local file_path="$1"
    local text="$2"

    if grep -q "$text" "$file_path"; then
        echo "File contains text that should not be present: $text" >&2
        echo "File contents:" >&2
        cat "$file_path" >&2
        return 1
    fi
}

# Count lines in file
count_lines() {
    local file_path="$1"
    wc -l < "$file_path" | tr -d ' '
}

# Assert line count
assert_line_count() {
    local file_path="$1"
    local expected_count="$2"

    local actual_count
    actual_count="$(count_lines "$file_path")"

    [[ "$actual_count" == "$expected_count" ]] || {
        echo "File has wrong line count" >&2
        echo "  Expected: $expected_count lines" >&2
        echo "  Actual:   $actual_count lines" >&2
        return 1
    }
}

# Create file with content
create_file_with_content() {
    local file_path="$1"
    local content="$2"

    mkdir -p "$(dirname "$file_path")"
    echo "$content" > "$file_path"
}

# Append to file
append_to_file() {
    local file_path="$1"
    local content="$2"

    echo "$content" >> "$file_path"
}

# Assert directory is empty
assert_directory_empty() {
    local dir_path="$1"

    local count
    count="$(find "$dir_path" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')"

    [[ "$count" == "0" ]] || {
        echo "Directory is not empty: $dir_path" >&2
        echo "Contents:" >&2
        ls -la "$dir_path" >&2
        return 1
    }
}

# Assert directory contains n items
assert_directory_item_count() {
    local dir_path="$1"
    local expected_count="$2"

    local actual_count
    actual_count="$(find "$dir_path" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')"

    [[ "$actual_count" == "$expected_count" ]] || {
        echo "Directory has wrong item count" >&2
        echo "  Expected: $expected_count items" >&2
        echo "  Actual:   $actual_count items" >&2
        return 1
    }
}

# Assert directory contains file
assert_directory_contains() {
    local dir_path="$1"
    local item_name="$2"

    [[ -e "$dir_path/$item_name" ]] || {
        echo "Directory does not contain item: $item_name" >&2
        echo "Directory contents:" >&2
        ls -la "$dir_path" >&2
        return 1
    }
}

# Copy directory contents
copy_directory() {
    local source="$1"
    local dest="$2"

    mkdir -p "$dest"
    cp -r "$source"/* "$dest/"
}

# Create nested directory structure
create_directory_tree() {
    local base_dir="$1"
    shift
    local paths=("$@")

    for path in "${paths[@]}"; do
        mkdir -p "$base_dir/$path"
    done
}

# Assert path is absolute
assert_absolute_path() {
    local path="$1"

    [[ "$path" == /* ]] || {
        echo "Path is not absolute: $path" >&2
        return 1
    }
}

# Assert path is relative
assert_relative_path() {
    local path="$1"

    [[ "$path" != /* ]] || {
        echo "Path is not relative: $path" >&2
        return 1
    }
}

# Get file modification time
get_mtime() {
    local file_path="$1"

    if [[ "$(uname)" == "Darwin" ]]; then
        stat -f "%m" "$file_path"
    else
        stat -c "%Y" "$file_path"
    fi
}

# Assert file was modified recently (within seconds)
assert_recently_modified() {
    local file_path="$1"
    local within_seconds="${2:-10}"

    local mtime
    mtime="$(get_mtime "$file_path")"

    local now
    now="$(date +%s)"

    local age=$((now - mtime))

    [[ $age -le $within_seconds ]] || {
        echo "File was not modified recently" >&2
        echo "  Modified: $age seconds ago" >&2
        echo "  Expected: within $within_seconds seconds" >&2
        return 1
    }
}
