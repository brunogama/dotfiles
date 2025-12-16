<objective>
Implement a smart video frame deduplication feature that removes repetitive frames to reduce file size. The feature should compare each frame to the frame from 3 seconds earlier, and if they are similar (above a configurable threshold), remove the current frame. This will significantly reduce file size for videos with static or repetitive content (e.g., screen recordings, security camera footage, time-lapse videos with minimal changes).

This feature should integrate seamlessly with the existing video processing workflow and use FFmpeg's frame comparison capabilities for efficient processing.
</objective>

<context>
This is a dotfiles repository with shell utilities in `bin/core/`. There's an existing `compress-video` script at `bin/core/compress-video` that handles video compression using FFmpeg. The codebase follows strict shell scripting standards:
- Must pass `shellcheck` with no errors
- Use `set -euo pipefail` for safety
- Quote all variables: `"$var"` not `$var`
- Prefer `[[` over `[` for conditionals
- Follow project conventions from `@/CLAUDE.md`

The existing `compress-video` script:
- Uses FFmpeg for video processing
- Has comprehensive argument parsing and validation
- Supports quality, resolution, and frame rate options
- Provides detailed output with file size comparisons

The new feature should either:
1. Be integrated as an optional flag in `compress-video` (e.g., `--dedupe-frames` or `--remove-repetitive`), OR
2. Be a separate script that can work standalone or be called by `compress-video`

FFmpeg provides frame comparison via filters like `select` with `scene` detection, or by extracting frames and comparing them. For efficiency, we should use FFmpeg's built-in frame comparison capabilities rather than extracting frames to disk.
</context>

<requirements>
1. **Frame Comparison Logic**:
   - Compare each frame to the frame from exactly 3 seconds earlier (not the immediately previous frame)
   - Use a configurable similarity threshold (default: 0.95 or 95% similarity)
   - If similarity exceeds threshold, mark the current frame for removal
   - Preserve audio synchronization when frames are removed

2. **Implementation Approach**:
   - Use FFmpeg's `select` filter with `scene` detection or `psnr` comparison
   - Alternatively, use `select='gt(scene,THRESHOLD)'` to keep only frames with significant changes
   - The 3-second lookback requires calculating frame numbers based on video FPS
   - Handle edge cases: videos shorter than 3 seconds, variable frame rates, etc.

3. **Integration Options** (choose the most appropriate):
   - **Option A**: Add `--dedupe-frames [THRESHOLD]` flag to `compress-video` script
   - **Option B**: Create new script `bin/core/dedupe-video-frames` that can be used standalone
   - **Option C**: Both - new script that can also be called by `compress-video` when flag is set

4. **Command-Line Interface**:
   - Input file (required)
   - Output file (optional, auto-generated if not specified)
   - Similarity threshold (optional, default 0.95)
   - Time window (optional, default 3 seconds, but make it configurable)
   - Help/usage information

5. **Output and Feedback**:
   - Display how many frames were removed
   - Show file size reduction
   - Provide processing progress for long videos
   - Handle errors gracefully with clear messages

6. **Technical Requirements**:
   - Must work with all common video formats (mp4, mov, avi, mkv, etc.)
   - Preserve video quality (no re-encoding unless necessary)
   - Maintain audio sync
   - Handle videos with or without audio tracks
   - Work efficiently on large video files
</requirements>

<implementation>
1. **Frame Comparison Method**:
   - Use FFmpeg's `select` filter with scene detection: `select='gt(scene,THRESHOLD)'`
   - For 3-second lookback, use a two-pass approach:
     - First pass: Extract frame timestamps and calculate differences
     - Second pass: Use `select` filter to keep only frames that differ significantly from 3 seconds ago
   - Alternative: Use `select='if(gt(scene,0.01),lt(scene,prev_selected(scene)+0.01))'` with custom logic
   - Most practical: Extract frames at 3-second intervals, compare using `psnr` or `ssim`, then use `select` to remove similar frames

2. **Recommended Approach**:
   - Use FFmpeg's `select` filter with a custom expression that compares current frame to frame N frames ago (where N = fps * 3)
   - Expression: `select='gt(scene,0.01)*not(eq(n,prev_selected(n)+N))'` where N is calculated from FPS
   - Or simpler: Use `select='gt(scene,THRESHOLD)'` which keeps frames with scene changes, then post-process to remove frames that are too similar to 3 seconds ago

3. **Script Structure**:
   - Follow existing `compress-video` script patterns
   - Use same error handling, validation, and output formatting
   - Add dependency checks for FFmpeg/FFprobe
   - Implement proper argument parsing with long and short options

4. **Performance Considerations**:
   - For very long videos, consider two-pass processing
   - Cache frame comparison results to avoid redundant calculations
   - Use appropriate FFmpeg presets for encoding if re-encoding is needed

5. **Edge Cases**:
   - Videos shorter than 3 seconds: Skip deduplication or compare to first frame
   - Variable frame rate videos: Use timestamp-based comparison instead of frame-number-based
   - Videos with no scene changes: Provide clear feedback that no frames were removed
   - Very high similarity threshold: Warn user if threshold might be too strict
</implementation>

<output>
Create or modify the following files:

- `bin/core/dedupe-video-frames` - New standalone script for frame deduplication (if creating separate script)
- OR modify `bin/core/compress-video` - Add deduplication feature as optional flag

The script should:
- Be executable (`chmod +x`)
- Follow shell scripting best practices (shellcheck compliant)
- Include comprehensive usage/help text
- Have proper error handling and validation
- Provide clear output showing frames removed and file size reduction

If creating a separate script, it should integrate well with the existing `compress-video` workflow and follow the same code style and patterns.
</output>

<verification>
Before declaring complete, verify:

1. **Functionality**:
   - Test with a video that has repetitive frames (e.g., screen recording with static content)
   - Verify frames are actually removed (check frame count before/after)
   - Confirm file size reduction
   - Ensure video still plays correctly and audio is synchronized

2. **Code Quality**:
   - Run `shellcheck bin/core/dedupe-video-frames` (or modified `compress-video`) - must pass with zero errors
   - Verify all variables are quoted
   - Check that `set -euo pipefail` is used
   - Confirm proper error messages for invalid inputs

3. **Edge Cases**:
   - Test with video shorter than 3 seconds
   - Test with video that has no repetitive frames
   - Test with video without audio track
   - Test with various video formats (mp4, mov, mkv)

4. **Documentation**:
   - Usage examples in help text
   - Clear parameter descriptions
   - Examples showing expected file size reductions
</verification>

<success_criteria>
- Script successfully removes repetitive frames when similarity threshold is met after 3-second lookback
- File size is reduced for videos with repetitive content
- Video quality is preserved (no visible degradation)
- Audio remains synchronized after frame removal
- Script passes shellcheck with zero errors
- Help text is clear and comprehensive
- Error handling works for invalid inputs and edge cases
- Script follows project coding standards and conventions
</success_criteria>

