import zipfile
import io
import os
import UnityPy

apk_path = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"
out_dir = r"D:\Henok\Projects\Game\mini4wd_standalone\icons"
os.makedirs(out_dir, exist_ok=True)

categories = {
    "slot_shell": "shell",
    "slot_chassis": "chassis",
    "slot_motor": "motor",
    "slot_gear": "gear",
    "slot_wing": "wing",
    "slot_front_plate": "head",
    "slot_side_stays": "middlewing",
    "slot_rear_plate": "phoenixtail",
    "slot_wheel_front": "hub",
    "slot_wheel_rear": "tyre",
}

print("Extracting assembly slot icons from resource.apk...")
with zipfile.ZipFile(apk_path, "r") as z:
    for slot_key, cat_folder in categories.items():
        # Find bundles in ui3dicon/<cat_folder>/
        matches = [n for n in z.namelist() if f"bundles/ui3dicon/{cat_folder}/" in n and n.endswith(".ab")]
        if not matches:
            print(f"No matches for {cat_folder}")
            continue

        # Extract first 3 icons
        saved = 0
        for bname in matches[:3]:
            try:
                data = z.read(bname)
                if len(data) > 22 and data[22:29] == b"UnityFS":
                    data = data[22:]
                env = UnityPy.load(io.BytesIO(data))
                for obj in env.objects:
                    if obj.type.name in ["Texture2D", "Sprite"]:
                        tex = obj.read()
                        out_name = f"{slot_key}_{saved}.png"
                        out_path = os.path.join(out_dir, out_name)
                        tex.image.save(out_path)
                        print(f"Saved: {out_name} from {bname} ({tex.image.size})")
                        saved += 1
                        break
            except Exception as e:
                pass

print("Assembly slot icons extracted!")
