import zipfile
import re
import io
import json
import UnityPy

apk_path = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"

keywords = ["track", "circuit", "segment", "slope", "bridge", "lane", "road", "curve", "straight", "loop", "rail", "changer"]
pattern = re.compile("|".join(keywords), re.IGNORECASE)

print(f"Scanning {apk_path}...")
with zipfile.ZipFile(apk_path, "r") as z:
    all_files = z.namelist()
    matched_files = [f for f in all_files if pattern.search(f)]

print(f"Total files in APK: {len(all_files)}")
print(f"Matched keyword files: {len(matched_files)}")

# Group by directory / pattern
prefixes = {}
for f in matched_files:
    parts = f.split("/")
    folder = "/".join(parts[:-1])
    prefixes[folder] = prefixes.get(folder, 0) + 1

print("\nDirectory breakdown:")
for k, v in sorted(prefixes.items(), key=lambda x: x[1], reverse=True)[:25]:
    print(f"  {k}: {v}")

# Sample matches
print("\nSample matches:")
for f in matched_files[:30]:
    print(f"  {f}")
