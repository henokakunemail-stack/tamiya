import io
import UnityPy

path = r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\Android'
with open(path, 'rb') as f:
    raw = f.read()

u_idx = raw.find(b'UnityFS')
env = UnityPy.load(io.BytesIO(raw[u_idx:]))
for obj in env.objects:
    if obj.type.name == 'AssetBundleManifest':
        abm = obj.read()
        name_map = dict(abm.AssetBundleNames)
        info_map = dict(abm.AssetBundleInfos)
        # Find cyclone magnum
        for idx, bname in name_map.items():
            if 'mesh_shell_cyclone_magnum_01.ab' in bname:
                print(f"Bundle: {bname} (ID: {idx})")
                info = info_map.get(idx)
                if info:
                    deps = getattr(info, 'dependencies', [])
                    print(f"Dependencies count: {len(deps)}")
                    for d_id in deps:
                        print(f"  Dep: {name_map.get(d_id, d_id)}")
        break
