import os
import io
import UnityPy

base_dir = r"D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android"
out_dir = r"D:\Henok\Projects\Game\extracted_assets"
os.makedirs(out_dir, exist_ok=True)

# Scan all .ab files
ab_files = []
for root, dirs, files in os.walk(base_dir):
    for f in files:
        if f.endswith(".ab") or "." not in f:
            ab_files.append(os.path.join(root, f))

print(f"Total potential asset bundles found: {len(ab_files)}")

# Count asset types across a sample of 200 bundles
type_counts = {}
sample = ab_files[:100]
for idx, path in enumerate(sample):
    try:
        with open(path, "rb") as f:
            raw = f.read(256)
        u_idx = raw.find(b"UnityFS")
        if u_idx == -1:
            continue
        with open(path, "rb") as f:
            full_raw = f.read()
        env = UnityPy.load(io.BytesIO(full_raw[u_idx:]))
        for obj in env.objects:
            t = obj.type.name
            type_counts[t] = type_counts.get(t, 0) + 1
    except Exception as e:
        pass

print("Sample asset types distribution:")
for k, v in sorted(type_counts.items(), key=lambda x: x[1], reverse=True):
    print(f"  {k}: {v}")
