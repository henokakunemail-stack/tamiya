import zipfile
import io
import os
import re
import json
from collections import defaultdict
import UnityPy

apk_path = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"

with zipfile.ZipFile(apk_path, "r") as z:
    all_files = z.namelist()

    # Track mesh bundles
    mesh_bundles = [f for f in all_files if "bundles/segment_prefab" in f and "/mesh" in f and f.endswith(".ab")]
    prefab_bundles = [f for f in all_files if "bundles/segment_prefab" in f and "/prefab" in f and f.endswith(".ab")]
    mat_bundles = [f for f in all_files if "bundles/segment_prefab" in f and "mat" in f and f.endswith(".ab")]
    track_textures = [f for f in all_files if ("minitrack/texture" in f or "track_tiezhi" in f) and f.endswith(".ab")]
    scene_track_meshes = [f for f in all_files if "scn_track" in f and "/mesh" in f and f.endswith(".ab")]
    scene_track_tex = [f for f in all_files if "scn_track" in f and "/texture" in f and f.endswith(".ab")]
    track_tables = [f for f in all_files if "bundles/table/track/mini_track" in f and f.endswith(".ab")]

    # Analyze piece patterns
    pieces_by_lane = {"3-lane": {}, "5-lane": {}}

    for f in mesh_bundles:
        fname = os.path.basename(f)
        lane = "3-lane" if ("/three/" in f or "_3_" in fname) else "5-lane"

        # Strip suffix
        clean_name = fname.replace(".ab", "")
        # e.g. curve180_cant_left_mini_3_mesh_01 -> base: curve180_cant_left
        m = re.match(r"^(.*?)(?:_mini_[35]_mesh)?(?:_\d+)?$", clean_name)
        base = m.group(1) if m else clean_name

        if base not in pieces_by_lane[lane]:
            pieces_by_lane[lane][base] = []
        pieces_by_lane[lane][base].append(fname)

    # Output detailed stats
    summary = {
        "apk_path": apk_path,
        "counts": {
            "track_segment_meshes_3lane": len([f for f in mesh_bundles if "/three/" in f]),
            "track_segment_meshes_5lane": len([f for f in mesh_bundles if "/five/" in f]),
            "track_segment_prefabs_3lane": len([f for f in prefab_bundles if "/three/" in f]),
            "track_segment_prefabs_5lane": len([f for f in prefab_bundles if "/five/" in f]),
            "track_material_bundles": len(mat_bundles),
            "track_core_texture_bundles": len(track_textures),
            "scene_track_mesh_bundles": len(scene_track_meshes),
            "scene_track_texture_bundles": len(scene_track_tex),
            "track_circuit_tables": len(track_tables)
        },
        "pieces_3lane_unique": len(pieces_by_lane["3-lane"]),
        "pieces_5lane_unique": len(pieces_by_lane["5-lane"]),
        "pieces_3lane_list": sorted(list(pieces_by_lane["3-lane"].keys())),
        "pieces_5lane_list": sorted(list(pieces_by_lane["5-lane"].keys()))
    }

    # Verify a comprehensive set of mesh files (one per major type)
    test_samples = [
        "assets/assetpack/Android/bundles/segment_prefab/three/newsegment/mesh/straight_mini_3_mesh_01.ab",
        "assets/assetpack/Android/bundles/segment_prefab/three/newsegment/mesh/curve90_left_mini_3_mesh.ab",
        "assets/assetpack/Android/bundles/segment_prefab/three/newsegment/mesh/bank_up_20_mini_3_mesh.ab",
        "assets/assetpack/Android/bundles/segment_prefab/three/newsegment/mesh/abslope_mini_3_mesh.ab",
        "assets/assetpack/Android/bundles/segment_prefab/three/newsegment/mesh/catapult_platform_20_mini_3_mesh.ab",
        "assets/assetpack/Android/bundles/segment_prefab/three/newsegment/mesh/lanechanger_10_mini_3_mesh.ab",
        "assets/assetpack/Android/bundles/segment_prefab/three/newsegment/mesh/wave_bigleft_mini_3_mesh.ab",
        "assets/assetpack/Android/bundles/segment_prefab/five/newsegment/mesh/burningchanger_30_left_mini_5_mesh.ab",
        "assets/assetpack/Android/bundles/segment_prefab/five/newsegment/mesh/dragon_back_mini_5_mesh.ab",
        "assets/assetpack/Android/bundles/segment_prefab/five/newsegment/mesh/alpur_mini_5_mesh.ab"
    ]

    verified_meshes = []
    for s in test_samples:
        if s not in z.namelist():
            # Find closest
            prefix = s.rsplit("_", 2)[0]
            cand = [f for f in mesh_bundles if os.path.basename(f).startswith(os.path.basename(prefix))]
            s = cand[0] if cand else None
        if not s:
            continue

        raw = z.read(s)
        u_idx = raw.find(b"UnityFS")
        env = UnityPy.load(io.BytesIO(raw[u_idx:]))
        sub_meshes = []
        for obj in env.objects:
            if obj.type.name == "Mesh":
                m = obj.read()
                obj_text = m.export()
                verts = sum(1 for line in obj_text.splitlines() if line.startswith("v ")) if obj_text else 0
                faces = sum(1 for line in obj_text.splitlines() if line.startswith("f ")) if obj_text else 0
                sub_meshes.append({"mesh_name": m.m_Name, "vertices": verts, "faces": faces})
        verified_meshes.append({
            "bundle": os.path.basename(s),
            "meshes": sub_meshes
        })

    summary["verified_samples"] = verified_meshes

    out_json = r"D:\Henok\Projects\Game\track_scan_summary.json"
    with open(out_json, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2)

print(f"Summary written to {out_json}")
print(f"Total 3-lane unique piece designs: {summary['pieces_3lane_unique']}")
print(f"Total 5-lane unique piece designs: {summary['pieces_5lane_unique']}")
print(f"Sample verified meshes count: {len(verified_meshes)}")
