import os
import io
import struct
import UnityPy

lua_dir = r"D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\lua"
out_dir = r"D:\Henok\Projects\Game\extracted_game_data\lua_scripts"
os.makedirs(out_dir, exist_ok=True)

XOR_KEY = 0x12
total_scripts = 0

for fname in os.listdir(lua_dir):
    if not fname.endswith(".ab"):
        continue
    category = fname.replace("_lua.ab", "")
    cat_dir = os.path.join(out_dir, category)
    os.makedirs(cat_dir, exist_ok=True)

    fpath = os.path.join(lua_dir, fname)
    with open(fpath, "rb") as f:
        raw = f.read()

    idx = raw.find(b"UnityFS")
    if idx == -1:
        print(f"Skipping {fname}: UnityFS not found")
        continue

    env = UnityPy.load(io.BytesIO(raw[idx:]))
    bundle_count = 0
    for obj in env.objects:
        if obj.type.name != "TextAsset":
            continue
        reader = obj.reader
        reader.Position = obj.byte_start
        raw_obj = reader.read_bytes(obj.byte_size)

        mem = io.BytesIO(raw_obj)
        name_len = struct.unpack('<I', mem.read(4))[0]
        name_bytes = mem.read(name_len)
        name = name_bytes.decode('utf-8', errors='ignore')

        if name_len % 4 != 0:
            mem.read(4 - (name_len % 4))

        script_len = struct.unpack('<I', mem.read(4))[0]
        script_bytes = mem.read(script_len)

        decrypted = bytes([b ^ XOR_KEY for b in script_bytes])

        # Save as .lua
        script_name = name if name.endswith(".lua") else f"{name}.lua"
        out_path = os.path.join(cat_dir, script_name)
        with open(out_path, "wb") as out_f:
            out_f.write(decrypted)

        bundle_count += 1
        total_scripts += 1

    print(f"Extracted {bundle_count} Lua scripts from {fname} -> {category}/")

print(f"\n[DONE] Total Lua scripts extracted: {total_scripts}")
