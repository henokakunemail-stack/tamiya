import os
import subprocess

base_video = r"D:\Henok\Projects\Game\video"
out_base = r"D:\Henok\Projects\Game\video_frames"
os.makedirs(out_base, exist_ok=True)

targets = [
    ("4.mp4", 15, "vid_4"),
    ("videoplayback3.mp4", 20, "vid_playback3"),
    ("videoplayback2.mp4", 25, "vid_playback2"),
    ("5.mp4", 60, "vid_5"),
]

for fname, interval, folder in targets:
    fpath = os.path.join(base_video, fname)
    out_dir = os.path.join(out_base, folder)
    os.makedirs(out_dir, exist_ok=True)
    out_pattern = os.path.join(out_dir, "frame_%04d.jpg")
    cmd = [
        "ffmpeg", "-y", "-i", fpath,
        "-vf", f"fps=1/{interval},scale=960:-1",
        "-q:v", "3",
        out_pattern
    ]
    print(f"Extracting {fname} (every {interval}s)...")
    res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    count = len(os.listdir(out_dir))
    print(f"Done {fname} -> {count} frames in {folder}")

print("All extractions complete.")
