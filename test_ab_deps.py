import io
import UnityPy

path = r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\bundles\prefab\car\auto\shell\mesh_shell_cyclone_magnum_01.ab'
with open(path, 'rb') as f:
    raw = f.read()
u_idx = raw.find(b'UnityFS')
env = UnityPy.load(io.BytesIO(raw[u_idx:]))

# Check asset dependencies in AssetBundle object
for obj in env.objects:
    if obj.type.name == 'AssetBundle':
        ab = obj.read()
        print("m_Name:", ab.m_Name)
        print("Preload table:")
        for p in getattr(ab, 'm_PreloadTable', []):
            print(" ", p)
        print("Container:")
        for k, v in getattr(ab, 'm_Container', {}):
            print(f"  {k} -> {v.preload_index}, {v.preload_size}")
        print("Dependencies:", getattr(ab, 'm_Dependencies', []))
        break
