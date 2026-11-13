import os
import UnityPy

lua_dir = r"D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\lua"
out_dir = r"D:\Henok\Projects\Game\extracted_assets\lua"
os.makedirs(out_dir, exist_ok=True)

for fname in os.listdir(lua_dir):
    if not fname.endswith(".ab"):
        continue
    fpath = os.path.join(lua_dir, fname)
    env = UnityPy.load(fpath)
    print(f"File: {fname}, objects count: {len(env.objects)}")
    for obj in env.objects:
        if obj.type.name == "TextAsset":
            data = obj.read()
            name = data.name
            script_bytes = data.script
            if isinstance(script_bytes, str):
                script_bytes = script_bytes.encode('utf-8', errors='ignore')
            first_bytes = script_bytes[:16] if script_bytes else b""
            print(f"  TextAsset: {name}, size={len(script_bytes)}, header={first_bytes}")
            break
