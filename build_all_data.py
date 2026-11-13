import os
import json

base_dir = r"D:\Henok\Projects\Game\extracted_game_data"
out_dir = r"D:\Henok\Projects\Game\mini4wd_standalone\data"
os.makedirs(out_dir, exist_ok=True)

# 1. Load dicttempletstringparts.tsv
translations = {}
with open(os.path.join(base_dir, "tsv_tables", "dicttempletstringparts.tsv"), "r", encoding="utf-8", errors="ignore") as f:
    for line in f:
        parts = line.strip().split("\t")
        if len(parts) >= 6:
            cid = parts[0]
            en = parts[3]
            ind = parts[5]
            translations[cid] = {"en": en, "ind": ind if ind else en}

print(f"Loaded {len(translations)} translations from dicttempletstringparts.tsv")

# Helper to read TSV
def load_tsv_rows(path):
    rows = []
    if not os.path.exists(path):
        return rows
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        lines = [l.strip().split("\t") for l in f if l.strip()]
    if len(lines) < 3:
        return rows
    headers = lines[2]
    for l in lines[3:]:
        row = {}
        for idx, h in enumerate(headers):
            if idx < len(l):
                row[h] = l[idx]
        rows.append(row)
    return rows

# 2. Build Cars
partcells = load_tsv_rows(os.path.join(base_dir, "tsv_tables", "dictpartcell.tsv"))
cars = []
for cell in partcells:
    cid = cell.get("C_ID")
    en_key = cell.get("carNameEn", "")
    t = translations.get(en_key, {})
    name_en = t.get("en", en_key)
    name_id = t.get("ind", name_en)

    # Clean up name if empty or default
    if not name_en or name_en.startswith("carNameEn_"):
        # fallback to carNameid
        name_key = cell.get("carNameid", "")
        t2 = translations.get(name_key, {})
        name_en = t2.get("en", "Mini 4WD " + cid)
        name_id = t2.get("ind", name_en)

    cars.append({
        "id": cid,
        "name_en": name_en,
        "name_id": name_id,
        "icon": cell.get("carNameIcon", ""),
        "shell_id": cell.get("attr", ""),
        "holder": cell.get("holder", "")
    })

with open(os.path.join(out_dir, "cars.json"), "w", encoding="utf-8") as f:
    json.dump(cars, f, ensure_ascii=False, indent=2)
print(f"Saved {len(cars)} cars to cars.json (e.g. {cars[0]['name_en']}, {cars[1]['name_en']}, {cars[2]['name_en']})")

# 3. Build Parts
parts_raw = load_tsv_rows(os.path.join(base_dir, "tsv_tables", "dictparts.tsv"))
partbase_raw = load_tsv_rows(os.path.join(base_dir, "tsv_tables", "dictpartbase.tsv"))
partbase_map = {p.get("C_ID"): p for p in partbase_raw}

# Slot type mapping based on installid
# 100: Chassis, 111/112: Battery, 200: Shell, 311: Motor, 312: Gear, 411/412: Wheels, 611/621: Damper/Weights, 711/721/731: Rollers
slot_names = {
    "100": "Chassis",
    "111": "Battery",
    "112": "Battery",
    "200": "Body Shell",
    "311": "Motor",
    "312": "Gear",
    "411": "Front Wheel",
    "412": "Rear Wheel",
    "511": "Front Axle",
    "512": "Rear Axle",
    "611": "Front Damper",
    "621": "Side Damper",
    "622": "Rear Damper",
    "711": "Front Roller",
    "721": "Side Roller",
    "731": "Rear Roller",
    "811": "Rear Stay",
    "911": "Accessory",
}

parts = []
for p in parts_raw:
    pid = p.get("C_ID")
    baseid = p.get("baseid", pid)
    base_info = partbase_map.get(baseid, {})

    install_id = base_info.get("installid", "0")
    # Take first install slot if multiple
    primary_slot = install_id.split("#")[0].split(":")[0] if install_id else "0"
    slot_label = slot_names.get(primary_slot, "Other")

    name_key = p.get("partname", "")
    t = translations.get(name_key, {})
    name_en = t.get("en", name_key)
    name_id = t.get("ind", name_en)

    desc_key = p.get("partdesc", "")
    td = translations.get(desc_key, {})
    desc_en = td.get("en", "")
    desc_id = td.get("ind", desc_en)

    icon = p.get("icon", "")

    # Parameters for physics
    p1 = float(base_info.get("parm1", 0) or 0)
    p2 = float(base_info.get("parm2", 0) or 0)
    p3 = float(base_info.get("parm3", 0) or 0)
    p4 = float(base_info.get("parm4", 0) or 0)
    p5 = float(base_info.get("parm5", 0) or 0)

    # Clean displayable parts
    parts.append({
        "id": pid,
        "base_id": baseid,
        "slot_id": primary_slot,
        "slot_label": slot_label,
        "name_en": name_en,
        "name_id": name_id,
        "desc_en": desc_en,
        "desc_id": desc_id,
        "icon": icon,
        "parm1": p1,
        "parm2": p2,
        "parm3": p3,
        "parm4": p4,
        "parm5": p5,
    })

with open(os.path.join(out_dir, "parts.json"), "w", encoding="utf-8") as f:
    json.dump(parts, f, ensure_ascii=False, indent=2)
print(f"Saved {len(parts)} parts to parts.json")

# 4. Build Anchor Points (partdummy.tsv)
dummy_rows = load_tsv_rows(os.path.join(base_dir, "tsv_tables", "partdummy.tsv"))
anchors = {}
for r in dummy_rows:
    cid = r.get("C_ID")
    groove = r.get("groove")
    gx = float(r.get("gravityx", 0) or 0)
    gy = float(r.get("gravityy", 0) or 0)
    gz = float(r.get("gravityz", 0) or 0)
    if cid not in anchors:
        anchors[cid] = {}
    anchors[cid][groove] = [gx, gy, gz]

with open(os.path.join(out_dir, "anchors.json"), "w", encoding="utf-8") as f:
    json.dump(anchors, f, indent=2)
print(f"Saved anchor points for {len(anchors)} chassis types")

# 5. Build Track Previews from track_configs
track_dir = os.path.join(base_dir, "track_configs")
track_files = os.listdir(track_dir)
sample_tracks = []
popular_keywords = ["0_track_mini", "1001_track_zhishi_mini", "0_301_mini", "0_501_mini", "roomtrack", "racetrack"]
for fname in track_files:
    if any(k in fname for k in popular_keywords) or len(sample_tracks) < 15:
        fpath = os.path.join(track_dir, fname)
        try:
            with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
                tdata = json.load(f)
            t_name = tdata.get("System.String,trackName", fname.replace(".tsv", ""))
            line_type = tdata.get("Horizon.Game.LogicLayer.LineNumber,miniTrackLineType", "Five")
            segments = tdata.get("System.Collections.Generic.List`1[Horizon.Game.LogicLayer.MiniSegmentData],configIds", [])

            seg_list = []
            for s in segments[:100]: # store first 100 segments
                seg_name = s.get("System.String,configName", "")
                res_mesh = s.get("System.String,resName", "")
                next_c = s.get("System.Int32,nextCenterIndex", -1)
                seg_list.append({
                    "name": seg_name,
                    "mesh": res_mesh,
                    "next": next_c
                })

            sample_tracks.append({
                "id": fname.replace(".tsv", ""),
                "name": t_name,
                "lanes": line_type,
                "total_segments": len(segments),
                "segments": seg_list
            })
            if len(sample_tracks) >= 20:
                break
        except Exception as e:
            pass

with open(os.path.join(out_dir, "tracks.json"), "w", encoding="utf-8") as f:
    json.dump(sample_tracks, f, ensure_ascii=False, indent=2)
print(f"Saved {len(sample_tracks)} track layouts to tracks.json")
