import io
import os
import UnityPy

path = r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\bundles\table\table.ab'
with open(path, 'rb') as f:
    raw = f.read()

u_idx = raw.find(b'UnityFS')
print("UnityFS offset:", u_idx)
env = UnityPy.load(io.BytesIO(raw[u_idx:]))
print(f"Total objects in table.ab: {len(env.objects)}")
text_assets = [obj for obj in env.objects if obj.type.name == 'TextAsset']
print(f"Total TextAssets: {len(text_assets)}")

for obj in text_assets[:5]:
    reader = obj.reader
    reader.Position = obj.byte_start
    raw_obj = reader.read_bytes(obj.byte_size)
    mem = io.BytesIO(raw_obj)
    import struct
    name_len = struct.unpack('<I', mem.read(4))[0]
    name_bytes = mem.read(name_len)
    name = name_bytes.decode('utf-8', errors='ignore')
    if name_len % 4 != 0:
        mem.read(4 - (name_len % 4))
    script_len = struct.unpack('<I', mem.read(4))[0]
    script_bytes = mem.read(script_len)
    print(f"  Name: {name}, len: {script_len}, first 50 chars: {script_bytes[:50]}")
