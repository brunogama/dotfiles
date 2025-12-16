<objective>
Create a video clipping tool that allows users to select a start and end time for a video and export the clipped segment as a new file. The tool should use FFmpeg for video processing and be written in Python with dependencies managed via uv in the script header.

This tool will enable quick video editing workflows for extracting specific segments from longer videos, useful for creating highlights, removing unwanted sections, or preparing clips for sharing.
</objective>

<context>
This is a dotfiles repository with utilities in `bin/core/`. There are existing video processing scripts:
- `bin/core/compress-video` - Bash script for video compression using FFmpeg
- `bin/core/dedupe-video-frames.py` - Python script using uv for frame deduplication

The codebase follows strict standards:
- Python scripts MUST use `uv` for dependency management with inline metadata in the header
- Python scripts MUST adhere to PEP 8 style guide
- Scripts should be executable and follow project conventions from `@/CLAUDE.md`
- Reference existing Python scripts for patterns and structure

The new tool should:
- Be placed in `bin/core/` directory
- Follow the same uv dependency pattern as `dedupe-video-frames.py`
- Use FFmpeg for video processing (likely via `ffmpeg-python` library or subprocess calls)
- Provide a clean, user-friendly command-line interface
- Handle common video formats (mp4, mov, avi, mkv, etc.)
</context>

<requirements>
1. **Core Functionality**:
   - Accept input video file (required)
   - Accept start time in format: `HH:MM:SS` or `MM:SS` or seconds (e.g., `00:01:30`, `1:30`, `90`)
   - Accept end time in same format, OR accept duration instead (e.g., `-d 30` for 30 seconds from start)
   - Export clipped video to output file (auto-generate name if not specified)
   - Preserve video quality (no re-encoding unless necessary, use stream copy when possible)

2. **Time Input Formats**:
   - Support multiple time formats for user convenience:
     - `HH:MM:SS` (e.g., `00:05:30`)
     - `MM:SS` (e.g., `5:30`)
     - Seconds as number (e.g., `330`)
     - Decimal seconds (e.g., `330.5`)
   - Validate that start time < end time
   - Validate that times are within video duration
   - Auto-detect video duration and display it to user

3. **FFmpeg Integration**:
   - Use FFmpeg's `-ss` (start time) and `-t` (duration) or `-to` (end time) flags
   - Prefer stream copy (`-c copy`) to avoid re-encoding when possible
   - Fall back to re-encoding if stream copy isn't possible (e.g., keyframe issues)
   - Handle audio synchronization properly
   - Support videos with or without audio tracks

4. **Command-Line Interface**:
   - Input file: `-i, --input FILE` (required)
   - Output file: `-o, --output FILE` (optional, auto-generated)
   - Start time: `-s, --start TIME` (required)
   - End time: `-e, --end TIME` OR duration: `-d, --duration TIME` (one required)
   - Force re-encode: `--re-encode` (optional flag to force re-encoding instead of stream copy)
   - Show video info: `--info` (optional, show video duration and properties)
   - Help: `-h, --help`

5. **Output and Feedback**:
   - Display video duration when processing starts
   - Show progress during clipping (if possible)
   - Display file size comparison (original vs clipped)
   - Provide clear error messages for invalid inputs
   - Auto-generate output filename: `{input_name}_clip_{start}_{end}.{ext}`

6. **Error Handling**:
   - Validate input file exists and is readable
   - Validate FFmpeg is installed and accessible
   - Check that start/end times are valid and within video duration
   - Handle FFmpeg errors gracefully with informative messages
   - Handle edge cases: start = end, start > end, times beyond video duration

7. **Dependencies**:
   - Use `uv` for dependency management with inline script metadata
   - Required dependencies:
     - `ffmpeg-python>=0.2.0` (for FFmpeg integration) OR use subprocess with ffmpeg binary
     - Consider `click` or `argparse` for CLI (argparse is stdlib, prefer that)
   - Follow the pattern from `dedupe-video-frames.py`:
     ```python
     #!/usr/bin/env -S uv run
     # /// script
     # requires-python = ">=3.11"
     # dependencies = [
     #     "ffmpeg-python>=0.2.0",
     # ]
     # ///
     ```
</requirements>

<implementation>
1. **Script Structure**:
   - Follow the pattern from `bin/core/dedupe-video-frames.py`
   - Use argparse for command-line argument parsing
   - Use subprocess to call FFmpeg binary OR use ffmpeg-python library
   - Include comprehensive docstring with usage examples
   - Implement proper error handling with try/except blocks

2. **Time Parsing**:
   - Create a function to parse time strings into seconds (float)
   - Support formats: `HH:MM:SS`, `MM:SS`, `SS`, `SS.SSS`
   - Handle edge cases: empty strings, invalid formats, negative values
   - Convert all times to seconds for FFmpeg (which accepts seconds or `HH:MM:SS` format)

3. **Video Duration Detection**:
   - Use `ffprobe` to get video duration before processing
   - Display duration to user in readable format
   - Validate start/end times against duration
   - Calculate duration if end time not provided: `duration = end - start`

4. **FFmpeg Command Construction**:
   - Basic command structure:
     ```bash
     ffmpeg -i input.mp4 -ss START_TIME -to END_TIME -c copy output.mp4
     ```
   - If stream copy fails, fall back to:
     ```bash
     ffmpeg -i input.mp4 -ss START_TIME -to END_TIME output.mp4
     ```
   - Use `-avoid_negative_ts make_zero` if needed for timing issues
   - Consider using `-ss` before `-i` for faster seeking (input seeking)

5. **Output Filename Generation**:
   - If output not specified, generate: `{basename}_clip_{start}_{end}.{ext}`
   - Sanitize time values in filename (replace `:` with `-`, handle decimals)
   - Example: `video.mp4` with start `00:01:30` and end `00:02:00` → `video_clip_00-01-30_00-02-00.mp4`

6. **Progress and Feedback**:
   - Use FFmpeg's progress output if available
   - Show file sizes before/after
   - Display processing time
   - Provide clear success message with output file path

7. **Code Quality**:
   - Follow PEP 8 style guide
   - Use type hints where appropriate
   - Add docstrings to all functions
   - Include error messages that help users fix issues
   - Make script executable with proper shebang
</implementation>

<output>
Create the following file:

- `bin/core/clip-video` - Python script for video clipping

The script should:
- Be executable (`chmod +x`)
- Use uv dependency management in header
- Follow Python best practices (PEP 8)
- Include comprehensive usage/help text
- Have proper error handling and validation
- Provide clear output showing processing status and results
- Follow the same patterns and code style as `dedupe-video-frames.py`

Example usage should work like:
```bash
./bin/core/clip-video -i video.mp4 -s 00:01:30 -e 00:02:00
./bin/core/clip-video -i video.mp4 -s 90 -d 30  # 30 seconds starting at 90s
./bin/core/clip-video -i video.mp4 -s 1:30 --info  # Show video info
```
</output>

<verification>
Before declaring complete, verify:

1. **Functionality**:
   - Test with various time formats (`HH:MM:SS`, `MM:SS`, seconds)
   - Verify clipped video has correct start and end times
   - Confirm video plays correctly and audio is synchronized
   - Test with videos that have no audio track
   - Test with different video formats (mp4, mov, mkv)

2. **Edge Cases**:
   - Start time = 0
   - End time = video duration
   - Start time very close to end time (1 second clip)
   - Invalid time formats (should show clear error)
   - Times beyond video duration (should show clear error)
   - Start time > end time (should show clear error)

3. **Code Quality**:
   - Run `python -m py_compile bin/core/clip-video` - should compile without errors
   - Check that script follows PEP 8 (can use `flake8` or similar if available)
   - Verify all functions have docstrings
   - Confirm proper error messages for invalid inputs
   - Test help text is clear and comprehensive

4. **Dependencies**:
   - Verify uv can resolve and install dependencies
   - Test that script runs with `uv run bin/core/clip-video --help`
   - Confirm FFmpeg is detected and accessible

5. **Output**:
   - Verify auto-generated filenames are correct
   - Check that file sizes are displayed
   - Confirm success messages are clear
</verification>

<success_criteria>
- Script successfully clips videos from start time to end time
- Multiple time input formats are supported and parsed correctly
- Video quality is preserved (stream copy used when possible)
- Audio remains synchronized after clipping
- Script handles edge cases gracefully with clear error messages
- Output filename is auto-generated correctly when not specified
- Script follows project coding standards (PEP 8, uv dependencies, executable)
- Help text is clear and includes usage examples
- Video duration is detected and displayed
- All validation checks work correctly (time ranges, file existence, etc.)
</success_criteria>

