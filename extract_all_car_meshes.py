import os
import io
import UnityPy

src_root = r"D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\originalassets\cars\parts\car_mesh"
dest_root = r"D:\Henok\Projects\Game\extracted_game_data\3d_models\car_parts"
os.makedirs(dest_root, exist_ok=True)

exported = 0
for root, dirs, files in os.walk(src_root):
    for fname in files:
        if not fname.endswith(".ab"):
            continue
        rel = os.path.relpath(root, src_root)
        target_dir = os.path.join(dest_root, rel)
        os.makedirs(target_dir, exist_ok=True)

        fpath = os.path.join(root, fname)
        try:
            with open(fpath, "rb") as f:
                raw = f.read()
            u_idx = raw.find(b"UnityFS")
            if u_idx == -1:
                continue
            env = UnityPy.load(io.BytesIO(raw[u_idx:]))
            for obj in env.objects:
                if obj.type.name == "Mesh":
                    m = obj.read()
                    mesh_name = m.m_Name
                    obj_content = m.export()
                    if obj_content:
                        out_file = os.path.join(target_dir, f"{mesh_name}.obj")
                        with open(out_file, "w", encoding="utf-8", errors="ignore") as out_f:
                            out_f.write(obj_content)
                        exported += 1
        except Exception as e:
            pass

print(f"[DONE] Extracted {exported} 3D Mesh (.obj) files for car parts!")
