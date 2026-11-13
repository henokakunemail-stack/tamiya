import os
import io
import struct
import json
import UnityPy

base_dir = r"D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android"
out_dir = r"D:\Henok\Projects\Game\extracted_game_data"

tables_out = os.path.join(out_dir, "tsv_tables")
tracks_out = os.path.join(out_dir, "track_configs")
os.makedirs(tables_out, exist_ok=True)
os.makedirs(tracks_out, exist_ok=True)

# 1. Extract all TSV tables from bundles/table
table_dir = os.path.join(base_dir, "bundles", "table")
extracted_tables = 0

for root, dirs, files in os.walk(table_dir):
    for fname in files:
        if not fname.endswith(".ab"):
            continue
        fpath = os.path.join(root, fname)
        try:
            with open(fpath, "rb") as f:
                raw = f.read()
            u_idx = raw.find(b"UnityFS")
            if u_idx == -1:
                continue
            env = UnityPy.load(io.BytesIO(raw[u_idx:]))
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

                # Check target folder (track vs table)
                if "track" in root:
                    target_file = os.path.join(tracks_out, f"{name}.tsv")
                else:
                    target_file = os.path.join(tables_out, f"{name}.tsv")

                with open(target_file, "wb") as out_f:
                    out_f.write(script_bytes)
                extracted_tables += 1
        except Exception as e:
            print(f"Error reading {fpath}: {e}")

print(f"[DONE] Extracted {extracted_tables} TSV database tables and track configs!")
