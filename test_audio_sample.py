import io
import UnityPy

path = r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\bundles\audio\common\bgm\bgm_06.ab'
with open(path, 'rb') as f:
    raw = f.read()

u_idx = raw.find(b'UnityFS')
print("UnityFS offset:", u_idx)
env = UnityPy.load(io.BytesIO(raw[u_idx:]))
for obj in env.objects:
    print('Object type:', obj.type.name)
    if obj.type.name == 'AudioClip':
        d = obj.read()
        print('AudioClip m_Name:', d.m_Name)
        samples = getattr(d, 'samples', {})
        for s_name, s_bytes in samples.items():
            print(f'Sample: {s_name}, len: {len(s_bytes)}')
