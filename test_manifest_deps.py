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
        print("Manifest found! Type:", type(abm))
        asset_bundles = getattr(abm, 'm_AssetBundleNames', [])
        print("Total bundles in manifest:", len(asset_bundles))
        for name in asset_bundles:
            if 'cyclone_magnum_01' in name:
                print("Found in manifest:", name)
                # Check dependencies
                deps = abm.get_asset_bundle_dependencies(name) if hasattr(abm, 'get_asset_bundle_dependencies') else None
                print("Dependencies method:", deps)
        break
