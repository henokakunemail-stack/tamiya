import os
import json

base_dir = r"D:\Henok\Projects\Game\extracted_game_data"
out_dir = r"D:\Henok\Projects\Game\mini4wd_standalone\data"
os.makedirs(out_dir, exist_ok=True)

# 1. Load Indonesian & English localized names
id_names = {}
en_names = {}

def load_tsv(path):
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

# Load dicttempletstringparts
def load_string_map(path, col_idx=0):
    res = {}
    if not os.path.exists(path):
        return res
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        lines = [l.strip().split("\t") for l in f if l.strip()]
    if len(lines) < 3:
        return res
    # First line type, second line 0, third line column header
    # But wait, dicttempletstringparts_ind has single col or multi col
    return lines

print("Loading localized strings...")
# Let's inspect dicttempletstringparts_ind.tsv format
with open(os.path.join(base_dir, "tsv_tables", "dicttempletstringparts_key.tsv"), "r", encoding="utf-8", errors="ignore") as f:
    keys = [l.strip() for l in f if l.strip()][3:]

with open(os.path.join(base_dir, "tsv_tables", "dicttempletstringparts_ind.tsv"), "r", encoding="utf-8", errors="ignore") as f:
    ind_vals = [l.strip() for l in f if l.strip()][3:]

with open(os.path.join(base_dir, "tsv_tables", "dicttempletstringparts_en.tsv"), "r", encoding="utf-8", errors="ignore") as f:
    en_vals = [l.strip() for l in f if l.strip()][3:]

for i, k in enumerate(keys):
    if i < len(ind_vals):
        id_names[k] = ind_vals[i]
    if i < len(en_vals):
        en_names[k] = en_vals[i]

print(f"Loaded {len(id_names)} localized names (ID & EN)")

# 2. Load dictpartcell (Cars)
partcells = load_tsv(os.path.join(base_dir, "tsv_tables", "dictpartcell.tsv"))
print(f"Loaded {len(partcells)} car definitions")

cars = []
for cell in partcells:
    cid = cell.get("C_ID")
    car_name_key = cell.get("carNameid", "")
    en_name = en_names.get(car_name_key, cell.get("carNameEn", "Unknown Car"))
    id_name = id_names.get(car_name_key, en_name)
    icon = cell.get("carNameIcon", "")
    shell_id = cell.get("attr", "")
    cars.append({
        "id": cid,
        "name_en": en_name,
        "name_id": id_name,
        "icon": icon,
        "shell_id": shell_id,
        "holder": cell.get("holder", ""),
        "animation": cell.get("aniEnter", "")
    })

with open(os.path.join(out_dir, "cars.json"), "w", encoding="utf-8") as f:
    json.dump(cars, f, ensure_ascii=False, indent=2)

print(f"Saved {len(cars)} cars to cars.json")
