# Shell Performance Specification

## ADDED Requirements

### Requirement: Lazy Loading Framework
The shell SHALL defer initialization of heavy tools until first use to minimize startup time.

#### Scenario: Mise Lazy Load
- **GIVEN** mise is installed on the system
- **WHEN** shell starts without using mise
- **THEN** `eval "$(mise activate zsh)"` is NOT executed
- **AND** startup completes without mise overhead
- **WHEN** user runs `mise --version` for first time
- **THEN** mise initializes transparently
- **AND** command executes successfully
- **AND** subsequent mise commands work normally

#### Scenario: Rbenv Lazy Load
- **GIVEN** rbenv is installed
- **WHEN** shell starts without using rbenv/ruby
- **THEN** `eval "$(rbenv init -)"` is NOT executed
- **WHEN** user runs `rbenv --version` or `ruby --version`
- **THEN** rbenv initializes automatically
- **AND** ruby commands work correctly

#### Scenario: NVM Lazy Load
- **GIVEN** NVM is installed at `$NVM_DIR/nvm.sh`
- **WHEN** shell starts without using node/npm
- **THEN** nvm.sh is NOT sourced
- **WHEN** user runs `node`, `npm`, or `nvm`
- **THEN** NVM loads automatically
- **AND** all node tools work correctly

####Scenario: SDKMAN Lazy Load
- **GIVEN** SDKMAN is installed at `$SDKMAN_DIR`
- **WHEN** shell starts without using sdk
- **THEN** sdkman-init.sh is NOT sourced
- **WHEN** user runs `sdk version`
- **THEN** SDKMAN loads automatically
- **AND** sdk commands work correctly

#### Scenario: Lazy Load Transparency
- **GIVEN** user has previously used shell without lazy loading
- **WHEN** lazy loading is enabled
- **THEN** all commands still work identically
- **AND** no change in user experience
- **AND** only startup time improves

### Requirement: Startup Time Benchmarking
The system SHALL provide tools to measure and track shell startup performance.

#### Scenario: Quick Benchmark
- **GIVEN** user runs `zsh-benchmark` without flags
- **WHEN** benchmark executes
- **THEN** 10 shell startup iterations run
- **AND** average, min, max times are displayed
- **AND** performance rating shown (Excellent/Good/Acceptable/Slow)

#### Scenario: Detailed Profiling
- **GIVEN** user runs `zsh-benchmark --detailed`
- **WHEN** profiling executes
- **THEN** zprof module loads
- **AND** detailed function-by-function timing shown
- **AND** top time-consuming operations identified

#### Scenario: Performance Rating
- **GIVEN** benchmark completes with average time
- **WHEN** average < 200ms
- **THEN** rating is "Excellent [YES]"
- **WHEN** average 200-500ms
- **THEN** rating is "Good [OK]"
- **WHEN** average 500-1000ms
- **THEN** rating is "Acceptable [WARNING]"
- **WHEN** average > 1000ms
- **THEN** rating is "Slow [NO] - optimization needed!"

### Requirement: Compilation and Caching
The system SHALL compile zsh files to bytecode for faster loading.

#### Scenario: Compile All Configs
- **GIVEN** user runs `zsh-compile`
- **WHEN** compilation executes
- **THEN** all .zsh files in ~/.config/zsh/ are compiled
- **AND** .zwc bytecode files created
- **AND** .zcompdump is compiled
- **AND** all functions in .zsh_functions/ compiled
- **AND** success message shown for each file

#### Scenario: Compiled Files Load Faster
- **GIVEN** .zwc bytecode files exist
- **WHEN** shell starts
- **THEN** zsh loads .zwc instead of source files
- **AND** startup time reduced by 100-200ms
- **AND** functionality remains identical

#### Scenario: Recompilation After Changes
- **GIVEN** user modifies .zshrc
- **WHEN** user runs `zsh-compile` again
- **THEN** .zwc file is regenerated
- **AND** new changes take effect

### Requirement: Completion Optimization
The system SHALL initialize completions efficiently without redundancy.

#### Scenario: Single Compinit Call
- **GIVEN** optimized .zshrc loads
- **WHEN** shell startup completes
- **THEN** `compinit` is called exactly once
- **AND** no redundant initialization occurs

#### Scenario: Completion Caching
- **GIVEN** completion dump is less than 24 hours old
- **WHEN** shell starts
- **THEN** `compinit -C` used (skip security check)
- **AND** startup time reduced by 50-100ms

#### Scenario: Completion Dump Compiled
- **GIVEN** `zsh-compile` has run
- **WHEN** `.zcompdump.zwc` exists
- **THEN** compiled completions load faster
- **AND** tab completion still works correctly

### Requirement: History Optimization
The system SHALL manage history efficiently to reduce startup overhead.

#### Scenario: Reduced History Size
- **GIVEN** history settings updated in .zpreztorc
- **WHEN** histsize set to 10,000 (was 100,000)
- **THEN** history file loads faster on startup
- **AND** 10,000 recent commands still available
- **AND** startup time reduced by 50-100ms

#### Scenario: History Trimming
- **GIVEN** history file exceeds 10,000 entries
- **WHEN** user runs `zsh-trim-history`
- **THEN** backup created at .zsh_history.backup
- **AND** only last 10,000 entries kept
- **AND** file size reduced
- **AND** success message shown

#### Scenario: History Still Searchable
- **GIVEN** history optimized to 10,000 entries
- **WHEN** user presses Ctrl+R for history search
- **THEN** recent commands are searchable
- **AND** history substring search works
- **AND** no functional change

### Requirement: Interactive Shell Detection
The system SHALL only run UI operations in interactive shells.

#### Scenario: Echo Only in Interactive
- **GIVEN** personal/work config has echo statements
- **WHEN** shell is non-interactive (script)
- **THEN** no echo statements execute
- **AND** no output pollution

- **WHEN** shell is interactive (terminal)
- **THEN** echo statements show
- **AND** user sees environment information

#### Scenario: Env Loading Conditional
- **GIVEN** shell starts in non-interactive mode
- **WHEN** running command via `zsh -c "command"`
- **THEN** personal/work configs may not load
- **OR** load silently without output
- **AND** startup is very fast (< 50ms)

### Requirement: Background Operations
The system SHALL defer non-essential operations to background processes.

#### Scenario: FZF Background Load
- **GIVEN** shell is interactive
- **WHEN** .zshrc sources fzf
- **THEN** fzf loads in background process (`&!`)
- **AND** shell becomes interactive immediately
- **AND** fzf keybindings available within 100ms

#### Scenario: Script Update Background
- **GIVEN** scripts need updating
- **WHEN** shell starts
- **THEN** update check runs in background
- **AND** shell is immediately usable
- **AND** update completes without blocking

#### Scenario: Background Jobs Don't Block
- **GIVEN** background job spawned during startup
- **WHEN** user starts typing command
- **THEN** no lag or delay occurs
- **AND** background job continues independently

### Requirement: Deferred Auto-Install
The system SHALL move expensive auto-install operations out of shell startup.

#### Scenario: Daily Update Check
- **GIVEN** scripts auto-update enabled
- **WHEN** shell starts
- **THEN** check if update ran today (cache file)
- **IF** not run today
- **THEN** spawn background update
- **AND** cache for 24 hours
- **AND** startup is not blocked

#### Scenario: Manual Script Update
- **GIVEN** user runs `update-dotfiles-scripts`
- **WHEN** command executes
- **THEN** scripts sync from dotfiles repo
- **AND** make install-scripts runs
- **AND** cache timestamp updated
- **AND** next shell start skips update

#### Scenario: No Blocking File Operations
- **GIVEN** optimized personal/work configs
- **WHEN** shell starts
- **THEN** no `find` commands execute
- **AND** no `stat` operations on scripts
- **AND** no expensive timestamp comparisons
- **AND** startup completes quickly

## MODIFIED Requirements

### Requirement: Tool Initialization (Modified for Lazy Loading)
Tools like mise, rbenv, nvm, SDKMAN SHALL initialize on demand rather than startup.

#### Scenario: Tool Available After First Use
- **GIVEN** user starts shell
- **WHEN** user runs tool command (e.g., `mise use`)
- **THEN** tool initializes transparently
- **AND** command succeeds
- **AND** tool remains initialized for session

#### Scenario: Tool Environment Variables
- **GIVEN** tool lazy-loaded on first use
- **WHEN** tool initializes
- **THEN** PATH updated correctly
- **AND** environment variables set
- **AND** subsequent commands work without re-initialization

### Requirement: Performance Targets (Measurable)
Shell startup SHALL complete within defined time thresholds.

#### Scenario: Cold Start Performance
- **GIVEN** fresh terminal opened (no recent shell)
- **WHEN** startup completes
- **THEN** time < 500ms
- **AND** performance rated "Good" or better

#### Scenario: Warm Start Performance
- **GIVEN** terminal opened recently (caches warm)
- **WHEN** startup completes
- **THEN** time < 250ms
- **AND** performance rated "Excellent"

#### Scenario: Non-Interactive Performance
- **GIVEN** command executed with `zsh -c "command"`
- **WHEN** startup completes
- **THEN** time < 50ms
- **AND** minimal overhead

#### Scenario: 70% Improvement Target
- **GIVEN** baseline startup time measured
- **WHEN** all optimizations applied
- **THEN** startup time reduced by at least 70%
- **AND** measurable via `zsh-benchmark`

## Testing Requirements

### Requirement: Functional Regression Tests
All existing functionality SHALL work identically after optimizations.

#### Scenario: All Tools Still Work
- **GIVEN** optimized configuration loaded
- **WHEN** user runs each tool command:
  - `mise --version`
  - `rbenv --version`
  - `node --version`
  - `npm --version`
  - `sdk version`
  - `ruby --version`
- **THEN** each command succeeds
- **AND** returns expected output

#### Scenario: Aliases Still Work
- **GIVEN** optimized .zshrc loaded
- **WHEN** user runs common aliases:
  - `ll` (eza)
  - `cat` (bat)
  - `find` (fd)
  - `grep` (rg)
- **THEN** each alias functions correctly
- **AND** no "command not found" errors

#### Scenario: Completions Still Work
- **GIVEN** optimized completion setup
- **WHEN** user types `git <TAB>`
- **THEN** git subcommands shown
- **WHEN** user types `docker <TAB>`
- **THEN** docker completions shown
- **AND** all completions responsive

#### Scenario: History Search Works
- **GIVEN** history optimized to 10k entries
- **WHEN** user presses Ctrl+R
- **THEN** history search prompt appears
- **AND** recent commands searchable
- **WHEN** user types partial command
- **THEN** matching entries shown

#### Scenario: Environment Switching Works
- **GIVEN** DOTFILES_ENV can be "work" or "personal"
- **WHEN** set to "work"
- **THEN** work-config.zsh loads
- **AND** "WORK" indicator shows
- **WHEN** set to "personal"
- **THEN** personal-config.zsh loads
- **AND** "HOME:PERSONAL" indicator shows

### Requirement: Performance Validation
Improvements SHALL be measurable and reproducible.

#### Scenario: Benchmark Before and After
- **GIVEN** baseline measured before changes
- **WHEN** optimizations applied
- **AND** benchmark run again
- **THEN** new time < baseline time
- **AND** improvement percentage calculated
- **AND** meets 70% target

#### Scenario: No Performance Regression
- **GIVEN** optimizations deployed
- **WHEN** benchmark run multiple times
- **THEN** times remain consistently fast
- **AND** no degradation over time
- **AND** no cache invalidation issues

### Requirement: Error Handling
Optimizations SHALL handle missing tools gracefully.

#### Scenario: Missing Tool No Error
- **GIVEN** mise not installed
- **WHEN** shell starts with lazy loading
- **THEN** no error messages
- **AND** shell functions normally
- **WHEN** user tries `mise --version`
- **THEN** error: "command not found"
- **AND** shell doesn't crash

#### Scenario: Compilation Failure Graceful
- **GIVEN** user runs `zsh-compile`
- **WHEN** file permission denied
- **THEN** error shown for that file
- **AND** compilation continues for other files
- **AND** partial success reported

## Success Metrics

### Requirement: Measurable Performance Gains
The optimization SHALL achieve quantifiable improvements.

#### Scenario: Startup Time Reduction
- **GIVEN** baseline: 1.5s average
- **WHEN** optimizations complete
- **THEN** average < 500ms
- **AND** 70%+ improvement achieved
- **AND** measurable with `zsh-benchmark`

#### Scenario: User Experience Improvement
- **GIVEN** optimized shell in use
- **WHEN** user opens new terminal
- **THEN** prompt appears immediately
- **AND** feels instant
- **AND** no perceived lag

#### Scenario: Tool Availability
- **GIVEN** lazy loading enabled
- **WHEN** user runs any lazily-loaded tool
- **THEN** tool works on first invocation
- **AND** initialization imperceptible (< 100ms)
- **AND** no change in user workflow

## Documentation Requirements

### Requirement: User Documentation
Users SHALL understand what changed and how to use new tools.

#### Scenario: Benchmark Documentation
- **GIVEN** user reads updated docs
- **WHEN** looking for performance info
- **THEN** `zsh-benchmark` usage explained
- **AND** interpretation of results clear
- **AND** examples provided

#### Scenario: Lazy Loading Explanation
- **GIVEN** user reads changelog/docs
- **WHEN** learning about lazy loading
- **THEN** concept explained clearly
- **AND** affected tools listed
- **AND** benefits described
- **AND** no action required from user

#### Scenario: Compilation Instructions
- **GIVEN** user wants to compile configs
- **WHEN** reading docs
- **THEN** `zsh-compile` usage explained
- **AND** when to run it described
- **AND** benefits quantified

### Requirement: Troubleshooting Guide
Users SHALL be able to diagnose and fix performance issues.

#### Scenario: Slow Startup Diagnosis
- **GIVEN** user experiencing slow startup
- **WHEN** following troubleshooting guide
- **THEN** steps to measure with `zsh-benchmark --detailed`
- **AND** interpretation of zprof output
- **AND** common culprits identified
- **AND** solutions provided

#### Scenario: Broken Tool Recovery
- **GIVEN** lazy-loaded tool not working
- **WHEN** following troubleshooting steps
- **THEN** manual initialization command provided
- **AND** temp fix available
- **AND** permanent fix documented
