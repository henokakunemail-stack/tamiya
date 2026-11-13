import zipfile
import io
import json
from collections import defaultdict
import UnityPy

apk_path = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"

print("Opening APK...")
with zipfile.ZipFile(apk_path, "r") as z:
    all_files = z.namelist()

    # 1. Segment bundles (3-lane and 5-lane)
    segment_mesh_files = [f for f in all_files if "bundles/segment_prefab" in f and f.endswith(".ab")]
    print(f"Total segment_prefab .ab files: {len(segment_mesh_files)}")

    # Group segment bundles by subfolder
    segment_groups = defaultdict(list)
    for f in segment_mesh_files:
        # e.g. bundles/segment_prefab/three/newsegment/mesh/xxx.ab
        parts = f.split("bundles/segment_prefab/")[1].split("/")
        lane_type = parts[0] # three, five, etc.
        kind = parts[-2] if len(parts) > 1 else "root"
        segment_groups[f"{lane_type}/{kind}"].append(f)

    print("\nSegment prefab breakdown:")
    for k, v in sorted(segment_groups.items()):
        print(f"  {k}: {len(v)} files")

    # 2. Scene track bundles (scn_track_zhishi, etc.)
    scene_track_files = [f for f in all_files if "scn_track" in f and f.endswith(".ab")]
    print(f"\nTotal scn_track files: {len(scene_track_files)}")
    scene_groups = defaultdict(list)
    for f in scene_track_files:
        parts = f.split("scn_track_zhishi/")[1].split("/") if "scn_track_zhishi/" in f else f.split("/")
        scene_groups[parts[0]].append(f)
    for k, v in sorted(scene_groups.items()):
        print(f"  scn_track subfolder '{k}': {len(v)} files")

    # 3. Analyze sample mesh bundles in 3-lane and 5-lane
    def sample_inspect_bundles(file_list, category_name, max_samples=15):
        print(f"\n--- Inspecting {category_name} (sample {max_samples} of {len(file_list)}) ---")
        mesh_stats = []
        for fpath in file_list[:max_samples]:
            raw = z.read(fpath)
            u_idx = raw.find(b"UnityFS")
            if u_idx == -1:
                print(f"  [NO UnityFS] {fpath}")
                continue
            env = UnityPy.load(io.BytesIO(raw[u_idx:]))
            obj_types = defaultdict(int)
            meshes = []
            textures = []
            for obj in env.objects:
                t = obj.type.name
                obj_types[t] += 1
                if t == "Mesh":
                    try:
                        m = obj.read()
                        meshes.append((m.m_Name, len(getattr(m, "m_Vertices", [])), len(getattr(m, "m_SubMeshes", []))))
                    except Exception as e:
                        meshes.append(("error", 0, 0))
                elif t in ("Texture2D", "Sprite"):
                    try:
                        tex = obj.read()
                        textures.append((tex.m_Name, getattr(tex, "m_Width", 0), getattr(tex, "m_Height", 0)))
                    except:
                        pass
            fname = fpath.split("/")[-1]
            print(f"  File: {fname} | Objects: {dict(obj_types)}")
            if meshes:
                for mname, vcnt, scnt in meshes:
                    print(f"    -> Mesh: '{mname}' (verts: {vcnt}, submeshes: {scnt})")
            if textures:
                for tname, w, h in textures:
                    print(f"    -> Tex: '{tname}' ({w}x{h})")

    # Sample three-lane meshes
    three_meshes = [f for f in segment_groups.get("three/mesh", [])]
    sample_inspect_bundles(three_meshes, "3-Lane Track Meshes (three/mesh)", 10)

    # Sample five-lane meshes
    five_meshes = [f for f in segment_groups.get("five/mesh", [])]
    sample_inspect_bundles(five_meshes, "5-Lane Track Meshes (five/mesh)", 10)

    # Sample prefabs
    three_prefabs = [f for f in segment_groups.get("three/prefab", [])]
    sample_inspect_bundles(three_prefabs, "3-Lane Prefabs (three/prefab)", 5)

    # Sample scene track meshes
    scene_meshes = [f for f in scene_track_files if "/mesh" in f]
    sample_inspect_bundles(scene_meshes, "Scene Track Meshes", 5)

    # Sample scene track textures
    scene_textures = [f for f in scene_track_files if "/texture" in f]
    sample_inspect_bundles(scene_textures, "Scene Track Textures", 5)
