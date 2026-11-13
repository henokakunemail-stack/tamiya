import io
import UnityPy

path = r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\bundles\segment_prefab\five\newsegment\mesh\curve90_left_mini_5_mesh.ab'
with open(path, 'rb') as f:
    raw = f.read()

u_idx = raw.find(b'UnityFS')
env = UnityPy.load(io.BytesIO(raw[u_idx:]))
for obj in env.objects:
    t = obj.type.name
    print("Object:", t)
    if t == 'Mesh':
        m = obj.read()
        print("Mesh name:", m.m_Name)
        print("Submeshes:", len(m.m_SubMeshes))
        print("Vertices count:", len(getattr(m, 'm_Vertices', [])))
        print("Export options in UnityPy:", [x for x in dir(m) if 'export' in x.lower() or 'obj' in x.lower()])
