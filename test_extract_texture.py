import io
import UnityPy

path = r'D:\Henok\Projects\Game\extracted_raw\assets\assetpack\Android\bundles\ui3dicon\ui_3dicon_5100.ab'
with open(path, 'rb') as f:
    raw = f.read()

u_idx = raw.find(b'UnityFS')
env = UnityPy.load(io.BytesIO(raw[u_idx:]))
for obj in env.objects:
    if obj.type.name in ('Texture2D', 'Sprite'):
        img = obj.read()
        print("Image name:", img.m_Name)
        pil_img = img.image
        print("Image size:", pil_img.size)
        pil_img.save(r'D:\Henok\Projects\Game\test_icon_5100.png')
        print("Saved icon successfully!")
        break
