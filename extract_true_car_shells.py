import zipfile
import io
import os
import UnityPy

apk_path = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"
out_dir = r"D:\Henok\Projects\Game\mini4wd_standalone\models"
os.makedirs(out_dir, exist_ok=True)

targets = {
    "mesh_shell_cyclone_magnum_01.ab": "cyclone_magnum.obj",
    "mesh_shell_hurricane_sonic_01.ab": "hurricane_sonic.obj",
    "mesh_shell_beat_magnum_01.ab": "beat_magnum.obj",
    "mesh_shell_victory_magnum_01.ab": "victory_magnum.obj",
    "mesh_shell_vanguard_sonic_01.ab": "vanguard_sonic.obj",
    "mesh_shell_buster_sonic_01.ab": "buster_sonic.obj",
    "mesh_shell_beak_spider_01.ab": "beak_spider.obj",
    "mesh_shell_fighter_magnum_01.ab": "fighter_magnum.obj",
}

print("Extracting full high-poly car shells...")
with zipfile.ZipFile(apk_path, "r") as z:
    all_names = z.namelist()
    for bundle_key, out_filename in targets.items():
        candidates = [n for n in all_names if n.endswith(bundle_key) and "car_mesh/shell" in n]
        if not candidates:
            candidates = [n for n in all_names if n.endswith(bundle_key)]
        if not candidates:
            print(f"Not found: {bundle_key}")
            continue

        best_mesh = None
        best_size = 0
        best_wing = None
        best_wing_size = 0

        for cand_path in candidates:
            data = z.read(cand_path)
            if len(data) > 22 and data[22:29] == b"UnityFS":
                data = data[22:]
            env = UnityPy.load(io.BytesIO(data))
            for obj in env.objects:
                if obj.type.name == "Mesh":
                    m = obj.read()
                    exp = m.export()
                    if "wing" in m.m_Name.lower():
                        if len(exp) > best_wing_size:
                            best_wing = (m.m_Name, exp)
                            best_wing_size = len(exp)
                    else:
                        if len(exp) > best_size:
                            best_mesh = (m.m_Name, exp)
                            best_size = len(exp)

        if best_mesh:
            out_path = os.path.join(out_dir, out_filename)
            with open(out_path, "w", encoding="utf-8") as f:
                f.write(best_mesh[1])
            print(f"Exported {out_filename} ({best_mesh[0]}, {best_size:,} bytes)")

            if best_wing:
                wing_name = out_filename.replace(".obj", "_wings.obj")
                with open(os.path.join(out_dir, wing_name), "w", encoding="utf-8") as f:
                    f.write(best_wing[1])
                print(f"  + Wings: {wing_name} ({best_wing[0]}, {best_wing_size:,} bytes)")

print("Done extracting authentic car shells!")
