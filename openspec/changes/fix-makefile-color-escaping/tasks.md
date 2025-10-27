# Implementation Tasks

## 1. Analyze Current Color Usage
- [x] 1.1 Review current color definitions (BLUE, GREEN, YELLOW, RED, NC)
- [x] 1.2 Count occurrences of color usage: `grep -c "$(GREEN)" Makefile`
- [x] 1.3 Identify all targets using colors
- [x] 1.4 Document current escaping pattern (`\033`)

## 2. Choose Fix Strategy
- [ ] 2.1 Test `echo -e` approach on macOS
- [ ] 2.2 Test `printf` approach on macOS
- [ ] 2.3 Test shell-expanded approach: `$(shell printf ...)`
- [ ] 2.4 Choose most compatible solution
- [ ] 2.5 Document chosen approach

## 3. Update Color Definitions
- [ ] 3.1 Update BLUE definition with chosen approach
- [ ] 3.2 Update GREEN definition
- [ ] 3.3 Update YELLOW definition
- [ ] 3.4 Update RED definition
- [ ] 3.5 Keep NC (no color) definition

## 4. Update Echo Commands (if using printf)
- [ ] 4.1 Replace `@echo "$(COLOR)...$(NC)"` with `@printf "$(COLOR)...$(NC)\n"`
- [ ] 4.2 Update help target
- [ ] 4.3 Update install target
- [ ] 4.4 Update backup target
- [ ] 4.5 Update link targets (link-zsh, link-git, etc.)
- [ ] 4.6 Update setup-prezto target
- [ ] 4.7 Update install-scripts target
- [ ] 4.8 Update uninstall target
- [ ] 4.9 Update test target
- [ ] 4.10 Update clean target
- [ ] 4.11 Update dump-macos target
- [ ] 4.12 Keep plain `@echo` for non-colored lines

## 5. Test Color Output
- [ ] 5.1 Run `make help` - verify colors render
- [ ] 5.2 Run `make test` - verify colors render
- [ ] 5.3 Check all color codes display correctly:
  - Blue for headers
  - Green for success/commands
  - Yellow for warnings
  - Red for errors
- [ ] 5.4 Verify no literal escape codes visible

## 6. Test on Different Shells
- [ ] 6.1 Test with zsh (default macOS)
- [ ] 6.2 Test with bash
- [ ] 6.3 Verify consistent behavior

## 7. Update CHANGELOG.md
- [ ] 7.1 Add entry under [Unreleased] → ### Fixed
- [ ] 7.2 Describe color rendering fix
- [ ] 7.3 Note improved Makefile output

## 8. Test All Makefile Targets
- [ ] 8.1 Test `make help`
- [ ] 8.2 Test `make test` (dry-run)
- [ ] 8.3 Test `make backup`
- [ ] 8.4 Test `make check-prezto`
- [ ] 8.5 Verify all targets work correctly
- [ ] 8.6 Verify no functionality broken

## 9. Documentation
- [ ] 9.1 No documentation changes needed (internal fix)
- [ ] 9.2 Verify CHANGELOG.md entry is clear

## 10. Validation
- [ ] 10.1 Run `make help` and verify colors
- [ ] 10.2 Screenshot before/after (optional)
- [ ] 10.3 Verify checkmake passes (when implemented)
- [ ] 10.4 No visible escape codes in output
