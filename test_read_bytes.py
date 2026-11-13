import io
import UnityPy

with open(r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\lua\app_lua.ab', 'rb') as f:
    raw = f.read()

idx = raw.find(b'UnityFS')
env = UnityPy.load(io.BytesIO(raw[idx:]))
for obj in env.objects:
    reader = obj.get_raw_data()
    d = obj.read()
    print("m_Name:", d.m_Name)
    print("type of m_Script:", type(d.m_Script))
    # Let's inspect object reader byte offset
    print("byte_start:", obj.byte_start, "byte_size:", obj.byte_size)
    reader_bytes = obj.reader.read()
    print("reader length:", len(reader_bytes))
    break
