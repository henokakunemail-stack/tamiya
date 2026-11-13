import io
import UnityPy

def patch_net_bundle():
    print("[Patch] Patching net_lua.ab...")
    with open("D:/Henok/Projects/Game/device_net_lua_ready.ab", "rb") as f:
        raw_ab = f.read()
    idx = raw_ab.find(b"UnityFS")
    prefix = raw_ab[:idx]
    env = UnityPy.load(io.BytesIO(raw_ab[idx:]))

    for obj in env.objects:
        if obj.type.name == "TextAsset":
            d = obj.read()
            name = getattr(d, "name", getattr(d, "m_Name", "unknown"))
            if name == "net_manager":
                raw = bytes(d.m_Script.encode("utf-8", errors="surrogateescape")) if isinstance(d.m_Script, str) else bytes(d.m_Script)
                dec = bytes([b ^ 0x12 for b in raw]).decode("utf-8", errors="ignore")

                # Numbers & Currency
                dec = dec.replace('curlevel = "1",', 'curlevel = 50,')
                dec = dec.replace('curexp = "0",', 'curexp = 0,')
                dec = dec.replace('stamina = "100",', 'stamina = 999,')
                dec = dec.replace('serverid = "1",', 'serverid = 1,')
                dec = dec.replace('headicon = "1",', 'headicon = 1001,')
                dec = dec.replace('iconframe = "0",', 'iconframe = 1,')
                dec = dec.replace('rolename = "Rider",', 'rolename = "TamiyaLegend",')
                dec = dec.replace('sign = "",', 'sign = "Mini 4WD Offline Champion",')
                dec = dec.replace('sevenDayTask = "0",', 'sevenDayTask = 99,')
                dec = dec.replace('background = "0",', 'background = 1,')
                dec = dec.replace('curcopyid = "0",', 'curcopyid = 1,')
                dec = dec.replace('loginday = "1",', 'loginday = 1,')
                dec = dec.replace('continueday = "1",', 'continueday = 1,')

                # Props
                old_props = 'myProps = {},'
                new_props = '''myProps = {
            { propid = 100001, propnum = 9999999, rid = 10001 },
            { propid = 100002, propnum = 999999, rid = 10001 },
        },'''
                dec = dec.replace(old_props, new_props, 1)

                # Cars
                old_cars = 'myCars = {},'
                new_cars = '''myCars = {
            { planseq = 1, unlockflag = 1, carplanname = "Cyclone Magnum", ifuse = 1, rid = 10001 },
            { planseq = 2, unlockflag = 1, carplanname = "Hurricane Sonic", ifuse = 0, rid = 10001 },
        },'''
                dec = dec.replace(old_cars, new_cars, 1)

                # Unblock loading transition: Set Normal login type + pass flag=true
                old_call = 'LoginFuncHelper:EnterServerPart(partMsg, false)'
                new_call = 'NetManager:Get():SetGameLoginType(LoginType.Normal)\n        LoginFuncHelper:EnterServerPart(partMsg, true)'
                dec = dec.replace(old_call, new_call, 1)

                fixed_bytes = bytes([b ^ 0x12 for b in dec.encode("utf-8")])
                d.m_Script = fixed_bytes.decode("utf-8", errors="surrogateescape")
                d.save()
                print("  -> net_manager.lua patched successfully!")

    out_io = io.BytesIO()
    out_io.write(prefix)
    out_io.write(env.file.save())
    with open("D:/Henok/Projects/Game/device_net_lua_final.ab", "wb") as f:
        f.write(out_io.getvalue())
    print(f"Saved device_net_lua_final.ab ({len(out_io.getvalue())} bytes)")

def patch_manager_bundle():
    print("[Patch] Patching manager_lua.ab...")
    with open("D:/Henok/Projects/Game/device_manager_lua.ab", "rb") as f:
        raw_ab = f.read()
    idx = raw_ab.find(b"UnityFS")
    prefix = raw_ab[:idx]
    env = UnityPy.load(io.BytesIO(raw_ab[idx:]))

    for obj in env.objects:
        if obj.type.name == "TextAsset":
            d = obj.read()
            name = getattr(d, "name", getattr(d, "m_Name", "unknown"))
            if name == "guide_manager":
                raw = bytes(d.m_Script.encode("utf-8", errors="surrogateescape")) if isinstance(d.m_Script, str) else bytes(d.m_Script)
                dec = bytes([b ^ 0x12 for b in raw]).decode("utf-8", errors="ignore")
                old_str = "if PlayerDataManager:Get():GetPlayerLV() > 8 and groupId < GuideState.GuideNewPlayer then"
                new_str = "local pLv = tonumber(PlayerDataManager:Get():GetPlayerLV()) or 0\n    local pGid = tonumber(groupId) or 0\n    if pLv > 8 and pGid < GuideState.GuideNewPlayer then"
                if old_str in dec:
                    dec = dec.replace(old_str, new_str)
                    d.m_Script = bytes([b ^ 0x12 for b in dec.encode("utf-8")]).decode("utf-8", errors="surrogateescape")
                    d.save()
                    print("  -> guide_manager.lua patched successfully!")
            elif name == "racetrackdata_manager":
                raw = bytes(d.m_Script.encode("utf-8", errors="surrogateescape")) if isinstance(d.m_Script, str) else bytes(d.m_Script)
                dec = bytes([b ^ 0x12 for b in raw]).decode("utf-8", errors="ignore")
                dec = dec.replace("self.trackList = trackList", "self.trackList = trackList or {}")
                dec = dec.replace("#self.trackList", "#(self.trackList or {})")
                d.m_Script = bytes([b ^ 0x12 for b in dec.encode("utf-8")]).decode("utf-8", errors="surrogateescape")
                d.save()
                print("  -> racetrackdata_manager.lua patched successfully!")

    out_io = io.BytesIO()
    out_io.write(prefix)
    out_io.write(env.file.save())
    with open("D:/Henok/Projects/Game/device_manager_lua_final.ab", "wb") as f:
        f.write(out_io.getvalue())
    print(f"Saved device_manager_lua_final.ab ({len(out_io.getvalue())} bytes)")

if __name__ == "__main__":
    patch_net_bundle()
    patch_manager_bundle()
