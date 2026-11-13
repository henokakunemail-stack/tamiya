import io
import UnityPy

path = r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\bundles\prefab\car\auto\chassis\ar\chassis_ar_01.ab'
with open(path, 'rb') as f:
    raw = f.read()

u_idx = raw.find(b'UnityFS')
print("UnityFS offset:", u_idx)
env = UnityPy.load(io.BytesIO(raw[u_idx:]))
for obj in env.objects:
    t = obj.type.name
    if t in ('Mesh', 'Texture2D', 'GameObject'):
        d = obj.read()
        name = getattr(d, 'm_Name', getattr(d, 'name', 'unnamed'))
        print(f"Type: {t}, Name: {name}")
        if t == 'Mesh':
            print("  Mesh export attributes:", [x for x in dir(d) if 'export' in x.lower() or 'dump' in x.lower()])
