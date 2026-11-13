import zipfile
import io
import os
import UnityPy

apk_path = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"
out_dir = r"D:\Henok\Projects\Game\mini4wd_standalone\icons"
os.makedirs(out_dir, exist_ok=True)

print("Scanning icon bundles from resource.apk...")
with zipfile.ZipFile(apk_path, "r") as z:
    all_names = z.namelist()
    icon_bundles = [n for n in all_names if "bundles/ui3dicon/" in n and n.endswith(".ab")]
    print(f"Total icon bundles found: {len(icon_bundles)}")

    # Extract all icon bundles
    extracted = 0
    for idx, bname in enumerate(icon_bundles):
        fname = os.path.basename(bname).replace(".ab", ".png")
        out_file = os.path.join(out_dir, fname)
        if os.path.exists(out_file):
            continue
        try:
            data = z.read(bname)
            if len(data) > 22 and data[22:29] == b"UnityFS":
                data = data[22:]
            env = UnityPy.load(io.BytesIO(data))
            for obj in env.objects:
                if obj.type.name in ["Texture2D", "Sprite"]:
                    tex = obj.read()
                    tex.image.save(out_file)
                    extracted += 1
                    break
        except Exception as e:
            pass
        if (idx + 1) % 500 == 0:
            print(f"Processed {idx + 1}/{len(icon_bundles)} icon bundles ({extracted} saved)...")

print(f"Extraction complete! Total icons saved: {len(os.listdir(out_dir))}")
