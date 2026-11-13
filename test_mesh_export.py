import io
import UnityPy

path = r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\bundles\segment_prefab\five\newsegment\mesh\curve90_left_mini_5_mesh.ab'
with open(path, 'rb') as f:
    raw = f.read()

u_idx = raw.find(b'UnityFS')
env = UnityPy.load(io.BytesIO(raw[u_idx:]))
for obj in env.objects:
    if obj.type.name == 'Mesh':
        m = obj.read()
        print("Mesh name:", m.m_Name)
        # Check export_() in UnityPy
        if hasattr(m, 'export'):
            print("export() method found!")
            res = m.export()
            print("Export result type:", type(res), "length:", len(res) if res else 0)
        break
