# Mini 4WD / 爆走兄弟 Let's & Go!! Offline Project

Project rekonstruksi, reverse engineering, ekstraksi aset 3D, dan patch offline untuk game mobile *Mini 4WD* (`Flash Racer` / `爆走兄弟 Let's & Go!!` / `com.zhizigame.gp.kr`).

---

## 📁 Struktur Repository

- **`mock_game_server.py`**: Localhost Mock TCP Server dengan enkripsi AES-128-ECB (key: `a0ec7d6cdce59de7`) untuk LoginServer (port 9001) dan GameServer (port 8001).
- **`patch_bundles.py`**: Script otomatisasi patch Unity AssetBundle (`net_lua.ab` dan `manager_lua.ab`) untuk bypass auth, unlock starter car (Cyclone Magnum & Hurricane Sonic), currency, dan unblock transisi loading screen.
- **`mini4wd_standalone/`**: Aplikasi web 3D Three.js standalone yang dapat dijalankan secara offline di browser (Garasi 3D, tuning mobil, trek balap, dan engine fisika).
- **`frida_offline_hook.js`**: Hook Frida IL2CPP in-memory interceptor untuk bypass socket jaringan game di level binary Android (`libil2cpp.so`).
- **`device_net_lua_final.ab` & `device_manager_lua_final.ab`**: AssetBundle Lua yang sudah dipatch dan siap di-push langsung ke Android.
- **`extracted_game_data/`**: Hasil ekstraksi lengkap aset game:
  - `3d_models/`: Model 3D mobil (.obj) dan part lintasan balap.
  - `audio/`: Efek suara, mesin tamiya, UI, dan BGM.
  - `lua_scripts/`: Seluruh source code client Lua yang sudah didekripsi (XOR 0x12).
  - `track_configs/`: Konfigurasi lintasan sirkuit balap.
  - `tsv_tables/`: Database stat item, part, chassis, gear, motor, dan battery.
- **`extracted_lua_net/`**: Protobuf descriptor dan skrip jaringan TNet.
- **`sample_audio_extraction/`**: Sampel audio hasil dekompresi FMOD FSBank.

---

## 🚀 Cara Menjalankan di Rumah

### 1. Menjalankan Standalone 3D Web App (PC / Laptop)
Tidak membutuhkan device Android:
```bash
cd mini4wd_standalone
python run_server.py
```
Buka browser di `http://localhost:8080` untuk melihat garasi 3D dan simulasi trek.

---

### 2. Menjalankan di Device Android (Offline Game Client)

#### A. Pasang Bundle Patch ke HP:
Pastikan USB Debugging aktif di HP:
```bash
adb push device_net_lua_final.ab /sdcard/Android/data/com.zhizigame.gp.kr/files/Res/Android/lua/net_lua.ab
adb push device_manager_lua_final.ab /sdcard/Android/data/com.zhizigame.gp.kr/files/Res/Android/lua/manager_lua.ab
```

#### B. Setup Port Forward & Mock Server:
```bash
# Forward port dari HP ke Laptop
adb reverse tcp:9001 tcp:9001
adb reverse tcp:8001 tcp:8001

# Jalankan Mock Server
python mock_game_server.py
```

#### C. Buka Game:
```bash
adb shell am force-stop com.zhizigame.gp.kr
adb shell monkey -p com.zhizigame.gp.kr -c android.intent.category.LAUNCHER 1
```

Game akan otomatis login offline, bypass pengecekan server, dan memuat aset garasi 3D.
