import zipfile
import io
import os
import re
from collections import defaultdict
import UnityPy

apk_path = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"

print("Starting deep scan of track bundles in resource.apk...")

with zipfile.ZipFile(apk_path, "r") as z:
    all_files = z.namelist()

    # 1. Segment bundles (segment_prefab)
    segment_files = [f for f in all_files if "bundles/segment_prefab" in f]

    # 2. Scene track bundles (scn_track_zhishi)
    scene_track_files = [f for f in all_files if "scn_track" in f]

    # 3. Track tables
    track_table_files = [f for f in all_files if "bundles/table/track" in f]

    # 4. Other track mesh/textures
    other_track_files = [f for f in all_files if ("track" in f.lower() or "circuit" in f.lower())
                         and f not in segment_files and f not in scene_track_files and f not in track_table_files]

    print(f"Segment files count: {len(segment_files)}")
    print(f"Scene track files count: {len(scene_track_files)}")
    print(f"Track table files count: {len(track_table_files)}")
    print(f"Other track/circuit files: {len(other_track_files)}")

    categories = {
        "straight": re.compile(r"straight|line", re.I),
        "curve_standard": re.compile(r"curve(90|45|180)|angle", re.I),
        "curve_banked": re.compile(r"bank", re.I),
        "slope_up_down": re.compile(r"slope|abslope|baslope", re.I),
        "bridge_overpass": re.compile(r"bridge|overpass|catapult|fly", re.I),
        "lane_changer": re.compile(r"change|crossover|cross|chg", re.I),
        "wave_digital": re.compile(r"wave|digital|alpur", re.I),
        "start_finish": re.compile(r"start|finish|goal|gate", re.I),
        "special_obstacle": re.compile(r"loop|jump|tunnel|rock|trap", re.I)
    }

    mesh_stats = {
        "total_mesh_bundles": 0,
        "valid_unityfs": 0,
        "exportable_meshes": 0,
        "lanes": defaultdict(int),
        "types": defaultdict(int)
    }

    sample_pieces = defaultdict(list)
    mesh_bundles = [f for f in segment_files if f.endswith(".ab") and "/mesh" in f]
    mesh_stats["total_mesh_bundles"] = len(mesh_bundles)

    print(f"\nAnalyzing all {len(mesh_bundles)} segment mesh bundles...")

    for idx, fpath in enumerate(mesh_bundles):
        fname = os.path.basename(fpath)

        # Determine lanes
        lane = "unknown"
        if "/three/" in fpath or "_3_" in fname or fname.endswith("_3.ab"):
            lane = "3-lane"
        elif "/five/" in fpath or "_5_" in fname or fname.endswith("_5.ab"):
            lane = "5-lane"
        mesh_stats["lanes"][lane] += 1

        # Determine category
        cat_found = "other"
        for cat_name, rgx in categories.items():
            if rgx.search(fname):
                cat_found = cat_name
                break
        mesh_stats["types"][cat_found] += 1

        # Sample pieces
        if len(sample_pieces[f"{lane}:{cat_found}"]) < 2:
            try:
                raw = z.read(fpath)
                u_idx = raw.find(b"UnityFS")
                if u_idx != -1:
                    mesh_stats["valid_unityfs"] += 1
                    env = UnityPy.load(io.BytesIO(raw[u_idx:]))
                    meshes_in_b = []
                    for obj in env.objects:
                        if obj.type.name == "Mesh":
                            m = obj.read()
                            obj_text = m.export()
                            v_count = sum(1 for line in obj_text.splitlines() if line.startswith("v ")) if obj_text else 0
                            f_count = sum(1 for line in obj_text.splitlines() if line.startswith("f ")) if obj_text else 0
                            meshes_in_b.append({
                                "name": m.m_Name,
                                "verts": v_count,
                                "faces": f_count
                            })
                    sample_pieces[f"{lane}:{cat_found}"].append({
                        "file": fname,
                        "meshes": meshes_in_b
                    })
            except Exception as e:
                print(f"Error inspecting {fname}: {e}")

print("\n--- Segment Bundles Categorization Summary ---")
print("By Lane System:")
for k, v in sorted(mesh_stats["lanes"].items()):
    print(f"  {k}: {v} bundles")

print("\nBy Track Piece Type:")
for k, v in sorted(mesh_stats["types"].items(), key=lambda x: x[1], reverse=True):
    print(f"  {k}: {v} bundles")

print("\n--- Detailed Sample Pieces by Lane & Category ---")
for k, samples in sorted(sample_pieces.items()):
    print(f"\n[{k}]")
    for s in samples:
        m_str = ", ".join([f"{m['name']}(v={m['verts']}, f={m['faces']})" for m in s['meshes']])
        print(f"  - {s['file']}: [{m_str}]")
