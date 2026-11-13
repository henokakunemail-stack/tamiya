import io
import UnityPy

with open(r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\lua\app_lua.ab', 'rb') as f:
    raw = f.read()

idx = raw.find(b'UnityFS')
env = UnityPy.load(io.BytesIO(raw[idx:]))
for obj in env.objects:
    reader = obj.reader
    reader.Position = obj.byte_start
    raw_obj = reader.read_bytes(obj.byte_size)
    print("raw_obj length:", len(raw_obj))
    # Unity TextAsset binary structure:
    # m_Name: string (int length + aligned bytes)
    # m_Script: string/bytes (int length + raw bytes)
    mem = io.BytesIO(raw_obj)
    import struct
    name_len = struct.unpack('<I', mem.read(4))[0]
    name_bytes = mem.read(name_len)
    # align 4
    if name_len % 4 != 0:
        mem.read(4 - (name_len % 4))
    script_len = struct.unpack('<I', mem.read(4))[0]
    script_bytes = mem.read(script_len)
    print(f"Name: {name_bytes.decode('utf-8', errors='ignore')}")
    print(f"Script bytes len: {len(script_bytes)}, expected: {script_len}")
    dec = bytes([b ^ 0x12 for b in script_bytes])
    print("Decrypted sample:")
    print(dec[:300].decode('utf-8', errors='ignore'))
    break
