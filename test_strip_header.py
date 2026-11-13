import io
import UnityPy

with open(r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\lua\app_lua.ab', 'rb') as f:
    raw = f.read()

idx = raw.find(b'UnityFS')
print("UnityFS offset:", idx)
payload = raw[idx:]

env = UnityPy.load(io.BytesIO(payload))
print("Objects count:", len(env.objects))
for obj in env.objects:
    print("Type:", obj.type.name)
    if obj.type.name == "TextAsset":
        data = obj.read()
        print("Name:", data.name)
        content = data.script
        if isinstance(content, str):
            content = content.encode('utf-8', errors='ignore')
        print("Length:", len(content))
        print("First 32 bytes:", content[:32])
        break
