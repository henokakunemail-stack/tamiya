import io
import UnityPy

with open(r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\lua\app_lua.ab', 'rb') as f:
    raw = f.read()

idx = raw.find(b'UnityFS')
payload = raw[idx:]
env = UnityPy.load(io.BytesIO(payload))
for obj in env.objects:
    data = obj.read()
    print("Attrs:", [x for x in dir(data) if not x.startswith('_')])
    print("m_Name:", getattr(data, 'm_Name', None))
    text_content = getattr(data, 'm_Script', None)
    if text_content is not None:
        raw_b = bytes(text_content) if not isinstance(text_content, (bytes, str)) else text_content
        if isinstance(raw_b, str):
            raw_b = raw_b.encode('utf-8', errors='ignore')
        print("m_Script len:", len(raw_b))
        print("First 32 bytes:", raw_b[:32])
    break
