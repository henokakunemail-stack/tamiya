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
        print("Attrs:", [x for x in dir(abm) if not x.startswith('_')])
        print("AssetBundleNames dict/list:", getattr(abm, 'AssetBundleNames', getattr(abm, 'assetBundleNames', None)))
        break
