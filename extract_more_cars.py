import zipfile
import io
import os
import UnityPy

apk_path = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"
out_dir = r"D:\Henok\Projects\Game\mini4wd_standalone\models"
os.makedirs(out_dir, exist_ok=True)

targets = {
    "mesh_shell_beat_magnum_01.ab": "beat_magnum.obj",
    "mesh_hurricane_sonic_92263.ab": "hurricane_sonic.obj",
    "mesh_shell_bergkaiser_01.ab": "bergkaiser.obj",
    "mesh_shell_avante2001_01.ab": "avante_2001.obj",
    "mesh_shell_air_blader_01.ab": "air_blader.obj",
}

with zipfile.ZipFile(apk_path, "r") as z:
    for bundle_name, out_name in targets.items():
        # find in namelist
        matches = [n for n in z.namelist() if n.endswith(bundle_name)]
        if not matches:
            continue
        full_path = matches[0]
        data = z.read(full_path)
        if len(data) > 22 and data[22:29] == b"UnityFS":
            data = data[22:]
        env = UnityPy.load(io.BytesIO(data))
        for obj in env.objects:
            if obj.type.name == "Mesh":
                mesh = obj.read()
                out_path = os.path.join(out_dir, out_name)
                with open(out_path, "w", encoding="utf-8") as f:
                    f.write(mesh.export())
                print(f"Exported {out_name}")
                break
print("Done extracting extra car models.")
