import os
import io
import UnityPy

audio_dir = r"D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\bundles\audio"
out_dir = r"D:\Henok\Projects\Game\extracted_game_data\audio"
os.makedirs(out_dir, exist_ok=True)

extracted_count = 0
for root, dirs, files in os.walk(audio_dir):
    for fname in files:
        if not fname.endswith(".ab"):
            continue
        fpath = os.path.join(root, fname)
        rel_sub = os.path.relpath(root, audio_dir)
        target_dir = os.path.join(out_dir, rel_sub) if rel_sub != "." else out_dir
        os.makedirs(target_dir, exist_ok=True)
        try:
            with open(fpath, "rb") as f:
                raw = f.read()
            u_idx = raw.find(b"UnityFS")
            if u_idx == -1:
                continue
            env = UnityPy.load(io.BytesIO(raw[u_idx:]))
            for obj in env.objects:
                if obj.type.name == "AudioClip":
                    clip = obj.read()
                    samples = getattr(clip, "samples", {})
                    for s_name, s_bytes in samples.items():
                        out_path = os.path.join(target_dir, s_name)
                        with open(out_path, "wb") as out_f:
                            out_f.write(s_bytes)
                        extracted_count += 1
        except Exception as e:
            pass

print(f"[DONE] Extracted {extracted_count} audio files (.wav/.ogg)")
