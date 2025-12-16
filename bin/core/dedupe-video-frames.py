#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "ffmpeg-python>=0.2.0",
#     "numpy>=1.24.0",
#     "Pillow>=10.0.0",
#     "scipy>=1.11.0",
# ]
# ///
"""
Smart Video Frame Deduplication Script
Removes repetitive frames by comparing each frame to the frame from N seconds earlier.
If frames are similar above a configurable threshold, the current frame is removed.
This significantly reduces file size for videos with static or repetitive content.

Usage:
    dedupe-video-frames.py -i input_file [options]

Options:
    -i, --input FILE          Input video file (required)
    -o, --output FILE         Output video file (optional, auto-generated if not specified)
    -t, --threshold NUM       Similarity threshold 0.0-1.0, higher = more similar (default: 0.95)
    -w, --window SECONDS      Time window in seconds for comparison (default: 3)
    -p, --preset PRESET       Encoding preset (default: medium)
    -j, --jobs NUM           Number of parallel jobs (default: auto-detect CPU cores)
    -s, --sample-rate NUM    Analyze every Nth frame (default: 1). Use 2-5 for long videos
    --chunk-mode             Process video in chunks to reduce memory usage
    --chunk-duration SEC     Duration of each chunk in seconds (default: 60.0)
    --phash                  Use perceptual hash comparison (fastest method)
    -h, --help               Show this help message
"""
import argparse
import multiprocessing as mp
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import List, Optional, Tuple, Dict

try:
    import ffmpeg
    import numpy as np
    from PIL import Image
    from scipy.fftpack import dct
except ImportError as e:
    print(f"Error: Missing required dependency: {e}", file=sys.stderr)
    print("Please ensure all dependencies are installed via UV.", file=sys.stderr)
    sys.exit(1)

# Default values
DEFAULT_THRESHOLD = 0.95
DEFAULT_LOOKBACK = 3
DEFAULT_PRESET = "medium"
DEFAULT_SAMPLE_RATE = 1
DEFAULT_CHUNK_DURATION = 60.0
FFMPEG_PATH = "/opt/homebrew/bin/ffmpeg"
FFPROBE_PATH = "/opt/homebrew/bin/ffprobe"

def get_video_info(video_path: Path) -> dict:
    """Extract video information using ffprobe.
    
    Args:
        video_path: Path to video file
        
    Returns:
        Dictionary with fps, duration, frame_count, width, height
    """
    try:
        probe = ffmpeg.probe(str(video_path))
        video_stream = next(
            (s for s in probe["streams"] if s["codec_type"] == "video"), None
        )
        
        if not video_stream:
            raise ValueError("No video stream found")
        
        # Get FPS
        fps_str = video_stream.get("r_frame_rate", "30/1")
        if "/" in fps_str:
            num, den = map(int, fps_str.split("/"))
            fps = num / den if den > 0 else 30.0
        else:
            fps = float(fps_str)
        
        # Get duration
        duration = float(probe["format"].get("duration", 0))
        
        # Get dimensions
        width = int(video_stream.get("width", 0))
        height = int(video_stream.get("height", 0))
        
        # Estimate frame count
        frame_count = int(fps * duration) if duration > 0 else 0
        
        return {
            "fps": fps,
            "duration": duration,
            "frame_count": frame_count,
            "width": width,
            "height": height,
        }
    except Exception as e:
        print(f"Error extracting video info: {e}", file=sys.stderr)
        sys.exit(1)

def extract_frames_batch(
    video_path: Path,
    fps: float,
    duration: float,
    temp_dir: Path,
    start_time: float = 0.0,
    end_time: Optional[float] = None,
) -> List[Path]:
    """Extract all frames at once to temporary directory.
    
    Args:
        video_path: Path to input video
        fps: Video frame rate
        duration: Video duration in seconds
        temp_dir: Temporary directory for frame extraction
        start_time: Start time for extraction (default: 0.0)
        end_time: End time for extraction (default: None - until end)
        
    Returns:
        List of extracted frame paths
    """
    output_pattern = temp_dir / "frame_%06d.jpg"
    
    try:
        print(f"Extracting frames from {start_time:.1f}s to {end_time or duration:.1f}s...")
        
        input_stream = ffmpeg.input(str(video_path), ss=start_time)
        
        if end_time is not None:
            input_stream = ffmpeg.input(str(video_path), ss=start_time, t=end_time - start_time)
        
        (
            input_stream
            .output(
                str(output_pattern),
                format="image2",
                vf=f"fps={fps},scale=320:240",  # Resize during extraction for speed
                qscale=2,  # Lower quality for comparison (faster I/O)
            )
            .overwrite_output()
            .run(cmd=FFMPEG_PATH, quiet=True, capture_stderr=True)
        )
    except ffmpeg.Error as e:
        print(f"Error extracting frames: {e.stderr.decode()}", file=sys.stderr)
        raise
    
    # Return list of extracted frame paths
    frame_paths = sorted(temp_dir.glob("frame_*.jpg"))
    print(f"Extracted {len(frame_paths)} frames")
    return frame_paths

def perceptual_hash(img: Image.Image) -> np.ndarray:
    """Calculate perceptual hash of image using DCT.
    
    Args:
        img: PIL Image
        
    Returns:
        Binary hash array
    """
    # Resize to 32x32 for better hash quality
    img = img.resize((32, 32), Image.Resampling.LANCZOS)
    img = img.convert("L")
    pixels = np.array(img, dtype=np.float32)
    
    # Calculate DCT (discrete cosine transform)
    dct_pixels = dct(dct(pixels.T).T)
    
    # Keep only top-left 8x8 (low frequency components)
    dct_low = dct_pixels[:8, :8]
    
    # Calculate median
    med = np.median(dct_low)
    
    # Create hash: 1 if > median, 0 otherwise
    hash_array = dct_low > med
    
    return hash_array.flatten()

def compare_frames_phash(frame1_path: Path, frame2_path: Path, threshold: float) -> bool:
    """Compare using perceptual hash - fastest method.
    
    Args:
        frame1_path: Path to first frame image
        frame2_path: Path to second frame image
        threshold: Similarity threshold (0.0-1.0)
        
    Returns:
        True if frames are similar above threshold, False otherwise
    """
    try:
        img1 = Image.open(frame1_path)
        img2 = Image.open(frame2_path)
        
        hash1 = perceptual_hash(img1)
        hash2 = perceptual_hash(img2)
        
        # Calculate hamming distance
        hamming_dist = np.sum(hash1 != hash2)
        
        # Convert to similarity (0 distance = 1.0 similarity)
        similarity = 1.0 - (hamming_dist / len(hash1))
        
        return similarity >= threshold
    except Exception as e:
        print(f"Error comparing frames (phash): {e}", file=sys.stderr)
        return False

def compare_frames_correlation(frame1_path: Path, frame2_path: Path, threshold: float) -> bool:
    """Compare two frames using correlation coefficient.
    
    Args:
        frame1_path: Path to first frame image
        frame2_path: Path to second frame image
        threshold: Similarity threshold (0.0-1.0)
        
    Returns:
        True if frames are similar above threshold, False otherwise
    """
    try:
        # Load images in grayscale for faster comparison
        img1 = Image.open(frame1_path).convert("L")
        img2 = Image.open(frame2_path).convert("L")
        
        # Resize to tiny size for fast comparison
        size = (16, 16)
        img1 = img1.resize(size, Image.Resampling.LANCZOS)
        img2 = img2.resize(size, Image.Resampling.LANCZOS)
        
        # Convert to flattened arrays
        arr1 = np.array(img1, dtype=np.float32).flatten()
        arr2 = np.array(img2, dtype=np.float32).flatten()
        
        # Calculate correlation coefficient
        correlation = np.corrcoef(arr1, arr2)[0, 1]
        
        # Handle NaN case (occurs when arrays are constant)
        if np.isnan(correlation):
            return True
        
        return correlation >= threshold
    except Exception as e:
        print(f"Error comparing frames (correlation): {e}", file=sys.stderr)
        return False

def compare_frame_worker(args: Tuple[int, Path, Path, float, bool]) -> Tuple[int, bool]:
    """Worker function for parallel frame comparison.
    
    Args:
        args: Tuple of (frame_idx, current_frame_path, compare_frame_path, threshold, use_phash)
        
    Returns:
        Tuple of (frame_idx, keep_frame)
    """
    frame_idx, current_frame_path, compare_frame_path, threshold, use_phash = args
    
    if use_phash:
        is_similar = compare_frames_phash(current_frame_path, compare_frame_path, threshold)
    else:
        is_similar = compare_frames_correlation(current_frame_path, compare_frame_path, threshold)
    
    keep_frame = not is_similar
    
    return (frame_idx, keep_frame)

def determine_frames_to_keep(
    frame_paths: List[Path],
    fps: float,
    window: float,
    threshold: float,
    num_jobs: int,
    use_phash: bool = False,
    sample_rate: int = 1,
) -> List[int]:
    """Determine which frames to keep by comparing to frames from window seconds earlier.
    
    Args:
        frame_paths: List of extracted frame paths
        fps: Video frame rate
        window: Lookback window in seconds
        threshold: Similarity threshold
        num_jobs: Number of parallel jobs
        use_phash: Use perceptual hash comparison
        sample_rate: Analyze every Nth frame
        
    Returns:
        List of frame indices to keep
    """
    frame_offset = int(fps * window)
    total_frames = len(frame_paths)
    
    # Auto-adjust sample rate for very long videos
    if total_frames > 10000 and sample_rate == 1:
        sample_rate = max(2, total_frames // 5000)  # Limit to ~5000 samples
        print(f"Auto-adjusting sample rate to 1/{sample_rate} for performance")
    
    frames_to_keep = [0]  # Always keep first frame
    
    method = "perceptual hash" if use_phash else "correlation"
    print(f"Analyzing {total_frames} frames (sampling every {sample_rate} frame(s)) with {num_jobs} parallel workers...")
    print(f"Using {method} comparison method")
    print(f"Comparing each frame to frame from {window}s earlier ({frame_offset} frames)...")
    
    # Build list of comparison tasks (only sampled frames)
    comparison_tasks = []
    sampled_indices = set()
    
    for frame_idx in range(1, total_frames, sample_rate):
        compare_frame_idx = max(0, frame_idx - frame_offset)
        # Adjust compare_frame_idx to nearest sampled frame
        if sample_rate > 1:
            compare_frame_idx = (compare_frame_idx // sample_rate) * sample_rate
        
        current_frame_path = frame_paths[frame_idx]
        compare_frame_path = frame_paths[compare_frame_idx]
        
        comparison_tasks.append((frame_idx, current_frame_path, compare_frame_path, threshold, use_phash))
        sampled_indices.add(frame_idx)
    
    # Process comparisons in parallel
    results = {}
    chunk_size = max(10, len(comparison_tasks) // (num_jobs * 4))
    
    with mp.Pool(processes=num_jobs) as pool:
        for i, result in enumerate(pool.imap(compare_frame_worker, comparison_tasks, chunksize=chunk_size)):
            frame_idx, keep_frame = result
            results[frame_idx] = keep_frame
            if (i + 1) % 100 == 0:
                kept_so_far = sum(1 for v in results.values() if v) + 1  # +1 for frame 0
                print(f"Processed {i + 1}/{len(comparison_tasks)} sampled frames ({kept_so_far} kept)...", end="\r")
    
    print()
    
    # Collect sampled frames to keep
    for frame_idx, keep_frame in results.items():
        if keep_frame:
            frames_to_keep.append(frame_idx)
    
    # Interpolate results for non-sampled frames if sample_rate > 1
    if sample_rate > 1:
        interpolated_frames = []
        for frame_idx in range(1, total_frames):
            if frame_idx not in sampled_indices:
                # Find nearest sampled frames
                prev_sample = (frame_idx // sample_rate) * sample_rate
                next_sample = min(prev_sample + sample_rate, total_frames - 1)
                
                # Keep if either neighbor is kept
                prev_kept = prev_sample in results and results[prev_sample]
                next_kept = next_sample in results and results.get(next_sample, False)
                
                if prev_kept or next_kept:
                    interpolated_frames.append(frame_idx)
        
        frames_to_keep.extend(interpolated_frames)
        frames_to_keep.sort()
    
    print(f"Keeping {len(frames_to_keep)} out of {total_frames} frames ({len(frames_to_keep)/total_frames*100:.1f}%)")
    return frames_to_keep

def create_output_video_pts(
    video_path: Path,
    output_path: Path,
    frames_to_keep: List[int],
    fps: float,
    preset: str,
    has_audio: bool,
) -> None:
    """Create output video using frame extraction and concat (for large frame lists).
    
    This method extracts individual frames and concatenates them, avoiding
    the command-line length limitations of the select filter.
    
    Args:
        video_path: Path to input video
        output_path: Path to output video
        frames_to_keep: List of frame indices to keep
        fps: Video frame rate
        preset: FFmpeg encoding preset
        has_audio: Whether input has audio
    """
    print(f"Using PTS-based frame extraction for {len(frames_to_keep)} frames...")
    
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        
        # Extract selected frames as images
        print(f"Extracting {len(frames_to_keep)} selected frames...")
        frame_files = []
        
        # Extract frames with progress updates
        total_frames = len(frames_to_keep)
        for i, frame_idx in enumerate(frames_to_keep):
            timestamp = frame_idx / fps
            output_frame = temp_path / f"frame_{i:08d}.jpg"
            
            try:
                (
                    ffmpeg.input(str(video_path), ss=timestamp)
                    .output(str(output_frame), vframes=1, qscale=2)
                    .overwrite_output()
                    .run(cmd=FFMPEG_PATH, quiet=True, capture_stderr=True)
                )
                frame_files.append(output_frame)
                
                # Progress indicator every 100 frames
                if (i + 1) % 100 == 0 or (i + 1) == total_frames:
                    print(f"  Extracted {i + 1}/{total_frames} frames...", end="\r")
                    
            except ffmpeg.Error as e:
                print(f"\n  Warning: Failed to extract frame {frame_idx}: {e}", file=sys.stderr)
                continue
        
        print(f"\n  Successfully extracted {len(frame_files)} frames")
        
        if len(frame_files) == 0:
            raise ValueError("Failed to extract any frames")
        
        # Create concat file for ffmpeg
        concat_file = temp_path / "concat.txt"
        with open(concat_file, "w") as f:
            for frame_file in frame_files:
                # Each frame should display for 1/fps seconds
                f.write(f"file '{frame_file}'\n")
                f.write(f"duration {1/fps}\n")
            # Last frame needs to be listed again without duration
            f.write(f"file '{frame_files[-1]}'\n")
        
        # Create video from frames
        print("Creating video from selected frames...")
        
        if has_audio:
            # Calculate audio speed adjustment
            probe = ffmpeg.probe(str(video_path))
            duration = float(probe["format"].get("duration", 0))
            original_frame_count = int(fps * duration)
            speed_factor = len(frames_to_keep) / original_frame_count if original_frame_count > 0 else 1.0
            
            print(f"  Audio speed adjustment: {speed_factor:.3f}x")
            
            # Create video without audio first
            temp_video = temp_path / "video_only.mp4"
            try:
                (
                    ffmpeg.input(str(concat_file), format="concat", safe=0, r=fps)
                    .output(
                        str(temp_video),
                        vcodec="libx264",
                        preset=preset,
                        crf=18,
                        pix_fmt="yuv420p",
                    )
                    .overwrite_output()
                    .run(cmd=FFMPEG_PATH, quiet=True, capture_stderr=True)
                )
            except ffmpeg.Error as e:
                print(f"Error creating video: {e.stderr.decode()}", file=sys.stderr)
                raise
            
            # Add adjusted audio
            print("Adding audio track...")
            video_input = ffmpeg.input(str(temp_video))
            audio_input = ffmpeg.input(str(video_path))
            
            # Adjust audio speed - handle extreme speed changes
            audio_stream = audio_input.audio
            remaining_speed = speed_factor
            
            # Apply atempo filters (each can do 0.5x to 2.0x)
            while remaining_speed < 0.5:
                audio_stream = audio_stream.filter("atempo", 0.5)
                remaining_speed /= 0.5
            while remaining_speed > 2.0:
                audio_stream = audio_stream.filter("atempo", 2.0)
                remaining_speed /= 2.0
            if 0.5 <= remaining_speed <= 2.0 and abs(remaining_speed - 1.0) > 0.01:
                audio_stream = audio_stream.filter("atempo", remaining_speed)
            
            # Combine video and audio
            try:
                (
                    ffmpeg.output(
                        video_input.video,
                        audio_stream,
                        str(output_path),
                        vcodec="copy",
                        acodec="aac",
                        audio_bitrate="192k",
                        movflags="+faststart",
                        shortest=None,
                    )
                    .overwrite_output()
                    .run(cmd=FFMPEG_PATH, quiet=True, capture_stderr=True)
                )
            except ffmpeg.Error as e:
                print(f"Error adding audio: {e.stderr.decode()}", file=sys.stderr)
                raise
        else:
            # No audio, just create video
            try:
                (
                    ffmpeg.input(str(concat_file), format="concat", safe=0, r=fps)
                    .output(
                        str(output_path),
                        vcodec="libx264",
                        preset=preset,
                        crf=18,
                        pix_fmt="yuv420p",
                        movflags="+faststart",
                    )
                    .overwrite_output()
                    .run(cmd=FFMPEG_PATH, quiet=True, capture_stderr=True)
                )
            except ffmpeg.Error as e:
                print(f"Error creating video: {e.stderr.decode()}", file=sys.stderr)
                raise
        
        print("Video encoding complete")


def create_output_video(
    video_path: Path,
    output_path: Path,
    frames_to_keep: List[int],
    fps: float,
    preset: str,
) -> None:
    """Create output video with only selected frames.
    
    Args:
        video_path: Path to input video
        output_path: Path to output video
        frames_to_keep: List of frame indices to keep
        fps: Video frame rate
        preset: FFmpeg encoding preset
    """
    # Get audio stream info
    probe = ffmpeg.probe(str(video_path))
    has_audio = any(s["codec_type"] == "audio" for s in probe["streams"])
    
    # ALWAYS use PTS-based approach if there are more than 100 frames
    # The select filter has severe command-line length limitations
    if len(frames_to_keep) > 100:
        create_output_video_pts(video_path, output_path, frames_to_keep, fps, preset, has_audio)
        return
    
    # Only use select filter for very small frame counts
    print(f"Using select filter for {len(frames_to_keep)} frames...")
    
    try:
        # Build select filter expression
        select_parts = [f"eq(n\\,{idx})" for idx in frames_to_keep]
        select_expr = "+".join(select_parts)
        
        # Build FFmpeg command
        input_video = ffmpeg.input(str(video_path))
        
        # Video filter: select frames and adjust timestamps
        video_stream = input_video.video.filter(
            "select", select_expr
        ).filter("setpts", "N/FRAME_RATE/TB")
        
        # Audio handling
        if has_audio:
            original_frame_count = None
            for stream in probe["streams"]:
                if stream["codec_type"] == "video":
                    original_frame_count = stream.get("nb_frames")
                    break
            
            if not original_frame_count:
                duration = float(probe["format"].get("duration", 0))
                original_frame_count = int(fps * duration)
            else:
                original_frame_count = int(original_frame_count)
            
            if original_frame_count > 0:
                speed_factor = len(frames_to_keep) / original_frame_count
                audio_stream = input_video.audio
                remaining_speed = speed_factor
                
                while remaining_speed < 0.5:
                    audio_stream = audio_stream.filter("atempo", 0.5)
                    remaining_speed /= 0.5
                while remaining_speed > 2.0:
                    audio_stream = audio_stream.filter("atempo", 2.0)
                    remaining_speed /= 2.0
                if 0.5 <= remaining_speed <= 2.0 and abs(remaining_speed - 1.0) > 0.01:
                    audio_stream = audio_stream.filter("atempo", remaining_speed)
            else:
                audio_stream = input_video.audio
            
            output = ffmpeg.output(
                video_stream,
                audio_stream,
                str(output_path),
                vcodec="libx264",
                preset=preset,
                crf=18,
                movflags="+faststart",
            )
        else:
            output = ffmpeg.output(
                video_stream,
                str(output_path),
                vcodec="libx264",
                preset=preset,
                crf=18,
                movflags="+faststart",
            )
        
        # Run FFmpeg
        print("Encoding output video...")
        ffmpeg.run(output, cmd=FFMPEG_PATH, overwrite_output=True, quiet=True)
        
    except ffmpeg.Error as e:
        error_msg = e.stderr.decode() if e.stderr else str(e)
        print(f"Error creating output video: {error_msg}", file=sys.stderr)
        # Fall back to PTS method
        print("Falling back to PTS-based method...")
        create_output_video_pts(video_path, output_path, frames_to_keep, fps, preset, has_audio)

def process_video_in_chunks(
    video_path: Path,
    output_path: Path,
    video_info: dict,
    window: float,
    threshold: float,
    num_jobs: int,
    chunk_duration: float,
    use_phash: bool,
    sample_rate: int,
    preset: str,
) -> None:
    """Process video in chunks to reduce memory and disk usage.
    
    Args:
        video_path: Path to input video
        output_path: Path to output video
        video_info: Video information dictionary
        window: Lookback window in seconds
        threshold: Similarity threshold
        num_jobs: Number of parallel jobs
        chunk_duration: Duration of each chunk in seconds
        use_phash: Use perceptual hash comparison
        sample_rate: Analyze every Nth frame
        preset: FFmpeg encoding preset
    """
    fps = video_info["fps"]
    duration = video_info["duration"]
    
    all_frames_to_keep = [0]  # Always keep first frame
    
    num_chunks = int(np.ceil(duration / chunk_duration))
    print(f"Processing video in {num_chunks} chunks of {chunk_duration}s each...")
    
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        
        for chunk_idx in range(num_chunks):
            # Add overlap for proper comparison at chunk boundaries
            start_time = max(0, chunk_idx * chunk_duration - (window if chunk_idx > 0 else 0))
            end_time = min(duration, (chunk_idx + 1) * chunk_duration)
            
            print(f"\n--- Processing chunk {chunk_idx + 1}/{num_chunks} ({start_time:.1f}s - {end_time:.1f}s) ---")
            
            # Extract frames for this chunk
            try:
                chunk_frames = extract_frames_batch(
                    video_path,
                    fps,
                    duration,
                    temp_path,
                    start_time,
                    end_time,
                )
            except Exception as e:
                print(f"Error extracting chunk frames: {e}", file=sys.stderr)
                continue
            
            if len(chunk_frames) == 0:
                print(f"Warning: No frames extracted for chunk {chunk_idx + 1}")
                continue
            
            # Determine frames to keep in this chunk
            chunk_frames_to_keep = determine_frames_to_keep(
                chunk_frames,
                fps,
                window,
                threshold,
                num_jobs,
                use_phash,
                sample_rate,
            )
            
            # Adjust indices to global frame numbers
            start_frame = int(start_time * fps)
            overlap_frames = int(window * fps) if chunk_idx > 0 else 0
            
            for local_idx in chunk_frames_to_keep:
                # Skip overlap region for non-first chunks
                if chunk_idx > 0 and local_idx < overlap_frames:
                    continue
                
                global_idx = start_frame + local_idx
                # Avoid duplicates from overlapping chunks
                if global_idx not in all_frames_to_keep:
                    all_frames_to_keep.append(global_idx)
            
            # Clean up chunk frames
            for frame_path in chunk_frames:
                try:
                    frame_path.unlink()
                except:
                    pass
            
            print(f"Chunk {chunk_idx + 1} complete: {len(chunk_frames_to_keep)}/{len(chunk_frames)} frames kept")
    
    # Sort final frame list
    all_frames_to_keep.sort()
    
    print(f"\nTotal frames to keep across all chunks: {len(all_frames_to_keep)}")
    
    # Create output video
    create_output_video(
        video_path,
        output_path,
        all_frames_to_keep,
        fps,
        preset,
    )

def generate_output_filename(input_file: Path, threshold: float, window: float) -> Path:
    """Generate output filename based on input and parameters.
    
    Args:
        input_file: Input video file path
        threshold: Similarity threshold
        window: Comparison window in seconds
        
    Returns:
        Output file path
    """
    stem = input_file.stem
    return input_file.parent / f"{stem}_deduped_t{threshold}_w{window}s.mp4"

def main() -> None:
    """Main function."""
    parser = argparse.ArgumentParser(
        description="Remove repetitive frames from video by comparing to frames from N seconds earlier",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Standard usage for short videos (< 10 minutes)
  %(prog)s -i video.mp4 -t 0.95 -w 3
  
  # Long videos (10-30 minutes) - use sampling
  %(prog)s -i video.mp4 -t 0.95 -w 3 -s 2
  
  # Very long videos (> 30 minutes) - use chunk mode
  %(prog)s -i video.mp4 -t 0.95 -w 3 --chunk-mode --chunk-duration 30
  
  # Maximum speed with perceptual hash
  %(prog)s -i video.mp4 -t 0.95 -w 3 --phash -s 3
  
  # Extreme optimization for 2+ hour videos
  %(prog)s -i video.mp4 -t 0.95 -w 3 --chunk-mode --chunk-duration 30 --phash -s 2 -j 8
        """,
    )
    parser.add_argument(
        "-i", "--input", required=True, type=Path, help="Input video file (required)"
    )
    parser.add_argument(
        "-o", "--output", type=Path, help="Output video file (optional, auto-generated if not specified)"
    )
    parser.add_argument(
        "-t",
        "--threshold",
        type=float,
        default=DEFAULT_THRESHOLD,
        help=f"Similarity threshold 0.0-1.0, higher = more similar (default: {DEFAULT_THRESHOLD})",
    )
    parser.add_argument(
        "-w",
        "--window",
        type=float,
        default=DEFAULT_LOOKBACK,
        help=f"Time window in seconds for comparison (default: {DEFAULT_LOOKBACK})",
    )
    parser.add_argument(
        "-p",
        "--preset",
        type=str,
        default=DEFAULT_PRESET,
        choices=["ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow"],
        help=f"Encoding preset (default: {DEFAULT_PRESET})",
    )
    parser.add_argument(
        "-j",
        "--jobs",
        type=int,
        default=mp.cpu_count(),
        help=f"Number of parallel jobs (default: {mp.cpu_count()} - auto-detected CPU cores)",
    )
    parser.add_argument(
        "-s",
        "--sample-rate",
        type=int,
        default=DEFAULT_SAMPLE_RATE,
        help=f"Analyze every Nth frame (default: {DEFAULT_SAMPLE_RATE}). Use 2-5 for long videos",
    )
    parser.add_argument(
        "--chunk-mode",
        action="store_true",
        help="Process video in chunks to reduce memory usage (recommended for videos > 30 min)",
    )
    parser.add_argument(
        "--chunk-duration",
        type=float,
        default=DEFAULT_CHUNK_DURATION,
        help=f"Duration of each chunk in seconds when using chunk mode (default: {DEFAULT_CHUNK_DURATION})",
    )
    parser.add_argument(
        "--phash",
        action="store_true",
        help="Use perceptual hash comparison (fastest method, slightly less accurate)",
    )
    
    args = parser.parse_args()
    
    # Validate input file
    if not args.input.exists():
        print(f"Error: Input file '{args.input}' does not exist!", file=sys.stderr)
        sys.exit(1)
    
    # Validate threshold
    if not 0.0 <= args.threshold <= 1.0:
        print("Error: Threshold must be between 0.0 and 1.0", file=sys.stderr)
        sys.exit(1)
    
    # Validate window
    if args.window <= 0:
        print("Error: Window must be greater than 0", file=sys.stderr)
        sys.exit(1)
    
    # Validate jobs
    if args.jobs < 1:
        print("Error: Number of jobs must be at least 1", file=sys.stderr)
        sys.exit(1)
    
    # Validate sample rate
    if args.sample_rate < 1:
        print("Error: Sample rate must be at least 1", file=sys.stderr)
        sys.exit(1)
    
    # Generate output filename if not provided
    if not args.output:
        args.output = generate_output_filename(args.input, args.threshold, args.window)
    
    # Get video information
    print("Analyzing input video...")
    video_info = get_video_info(args.input)
    
    print(f"Input FPS: {video_info['fps']:.2f}")
    print(f"Input duration: {video_info['duration']:.2f}s ({video_info['duration']/60:.1f} minutes)")
    print(f"Estimated frames: {video_info['frame_count']}")
    print(f"Resolution: {video_info['width']}x{video_info['height']}")
    
    # Suggest optimizations for long videos
    if video_info['duration'] > 1800 and not args.chunk_mode:  # > 30 minutes
        print("\n⚠️  Warning: Video is longer than 30 minutes.")
        print("   Consider using --chunk-mode for better memory management.")
    
    if video_info['frame_count'] > 10000 and args.sample_rate == 1:
        suggested_rate = max(2, video_info['frame_count'] // 5000)
        print(f"\n💡 Tip: Consider using -s {suggested_rate} to speed up processing.")
    
    # Check if video is shorter than window
    if video_info["duration"] <= args.window:
        print(f"\n⚠️  Warning: Video duration ({video_info['duration']:.2f}s) <= comparison window ({args.window}s)")
        print("   Will compare to first frame instead.")
    
    print(f"\nConfiguration:")
    print(f"  Threshold: {args.threshold}")
    print(f"  Window: {args.window}s")
    print(f"  Sample rate: 1/{args.sample_rate}")
    print(f"  Parallel jobs: {args.jobs}")
    print(f"  Comparison method: {'Perceptual Hash' if args.phash else 'Correlation'}")
    print(f"  Processing mode: {'Chunk' if args.chunk_mode else 'Full'}")
    
    if args.chunk_mode:
        print(f"  Chunk duration: {args.chunk_duration}s")
        print("\nProcessing video in chunk mode...")
        process_video_in_chunks(
            args.input,
            args.output,
            video_info,
            args.window,
            args.threshold,
            args.jobs,
            args.chunk_duration,
            args.phash,
            args.sample_rate,
            args.preset,
        )
    else:
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            
            # Extract all frames
            frame_paths = extract_frames_batch(
                args.input,
                video_info["fps"],
                video_info["duration"],
                temp_path,
            )
            
            if len(frame_paths) == 0:
                print("Error: No frames extracted from video", file=sys.stderr)
                sys.exit(1)
            
            # Determine frames to keep
            frames_to_keep = determine_frames_to_keep(
                frame_paths,
                video_info["fps"],
                args.window,
                args.threshold,
                args.jobs,
                args.phash,
                args.sample_rate,
            )
            
            if len(frames_to_keep) == len(frame_paths):
                print("\nNo frames to remove. All frames are different enough.")
                return
            
            # Create output video
            print(f"\nCreating output video with {len(frames_to_keep)} frames...")
            create_output_video(
                args.input,
                args.output,
                frames_to_keep,
                video_info["fps"],
                args.preset,
            )
    
    # Get output video info
    try:
        output_info = get_video_info(args.output)
        
        # Display results
        print("\n" + "="*50)
        print("  DEDUPLICATION COMPLETE")
        print("="*50)
        
        original_frames = video_info["frame_count"]
        if args.chunk_mode:
            # Estimate from output
            final_frames = output_info["frame_count"]
        else:
            final_frames = len(frames_to_keep)
        
        frames_removed = original_frames - final_frames
        reduction_pct = (frames_removed / original_frames * 100) if original_frames > 0 else 0
        
        print(f"Original frames:    {original_frames:,}")
        print(f"Output frames:      {final_frames:,}")
        print(f"Frames removed:     {frames_removed:,} ({reduction_pct:.1f}% reduction)")
        print(f"Original duration:  {video_info['duration']:.2f}s")
        print(f"Output duration:    {output_info['duration']:.2f}s")
        print(f"Output file:        {args.output}")
        
        # File size comparison
        input_size = args.input.stat().st_size / (1024 * 1024)  # MB
        output_size = args.output.stat().st_size / (1024 * 1024)  # MB
        size_reduction = ((input_size - output_size) / input_size * 100) if input_size > 0 else 0
        
        print(f"\nInput file size:    {input_size:.2f} MB")
        print(f"Output file size:   {output_size:.2f} MB")
        print(f"Size reduction:     {size_reduction:.1f}%")
        print("="*50)
        
    except Exception as e:
        print(f"\nOutput video created: {args.output}")
        print(f"(Could not retrieve detailed stats: {e})")

if __name__ == "__main__":
    main()