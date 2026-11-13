import os
import io
import json
import zipfile
from collections import defaultdict
import UnityPy
from UnityPy.export.AudioClipConverter import get_resource_data

APK_PATH = r"D:\Henok\Projects\Game\Mini4WD_16.0_APKPure(1)\resource.apk"
SAMPLE_OUT_DIR = r"D:\Henok\Projects\Game\sample_audio_extraction"

COMPRESSION_FORMATS = {
    0: "PCM",
    1: "Vorbis",
    2: "ADPCM",
    3: "MP3",
    4: "VAG",
    5: "HEVAG",
    6: "XMA",
    7: "AAC",
    8: "GCADPCM",
    9: "ATRAC9",
}

def detect_magic(data: bytes) -> str:
    if not data or len(data) < 4:
        return "EMPTY"
    if data[:4] == b"FSB5":
        return "FSB5"
    if data[:4] == b"FSB4":
        return "FSB4"
    if data[:4] == b"RIFF":
        return "WAV (RIFF)"
    if data[:4] == b"OggS":
        return "OGG (OggS)"
    if data[:3] == b"ID3" or data[:2] == b"\xff\xfb":
        return "MP3"
    return f"UNKNOWN ({data[:4].hex()})"

def categorize(path: str, clip_name: str) -> str:
    path_low = path.lower()
    clip_low = clip_name.lower()

    if "/bgm" in path_low or clip_low.startswith("bgm_"):
        return "BGM"
    if "engine" in path_low or "motor" in path_low or "car_10" in clip_low or "high_torque" in clip_low or "idaten" in clip_low:
        if "click" in clip_low or "cat_ui" in clip_low:
            return "UI Click"
        if "sfx" in clip_low or "curve" in clip_low or "landdown" in clip_low or "spectator" in clip_low:
            return "SFX"
        return "Engine Sound"
    if "ui" in path_low or "click" in clip_low or "audie_ui" in clip_low or "audio_ui" in clip_low or "btn" in clip_low:
        return "UI Click"
    if "voice" in path_low or "kr_area" in path_low or "hero" in clip_low:
        return "Voice"
    if "sfx" in clip_low:
        return "SFX"
    return "SFX / Misc"

def main():
    print(f"Opening APK: {APK_PATH}")
    os.makedirs(SAMPLE_OUT_DIR, exist_ok=True)

    with zipfile.ZipFile(APK_PATH, "r") as z:
        all_entries = z.namelist()
        audio_entries = [e for e in all_entries if "audio" in e.lower() and e.endswith(".ab")]

        print(f"Total audio .ab bundles in APK: {len(audio_entries)}")

        stats = {
            "total_bundles": len(audio_entries),
            "bundles_with_audioclip": 0,
            "total_audioclips": 0,
            "categories": defaultdict(lambda: {"count": 0, "clips": [], "total_size_bytes": 0, "total_duration_sec": 0.0}),
            "raw_formats": defaultdict(int),
            "compression_formats": defaultdict(int),
            "sample_rates": defaultdict(int),
            "channels": defaultdict(int),
        }

        sample_targets = {
            "BGM": ["bgm_battle_01", "bgm_06"],
            "Engine Sound": ["audio_battle_car_101", "high_torque", "4cfd.acb.00001"],
            "SFX": ["audio_sfx_curvecollsion", "audio_sfx_landdown1"],
            "UI Click": ["audio_ui_click_101", "audio_ui_click_battlestart", "cat_ui_flash"],
        }
        extracted_samples = []

        for entry_idx, entry in enumerate(audio_entries):
            try:
                raw_bundle = z.read(entry)
            except Exception as e:
                continue

            u_idx = raw_bundle.find(b"UnityFS")
            if u_idx == -1:
                continue

            try:
                env = UnityPy.load(io.BytesIO(raw_bundle[u_idx:]))
            except Exception as e:
                continue

            bundle_had_audio = False
            for obj in env.objects:
                if obj.type.name != "AudioClip":
                    continue

                try:
                    clip = obj.read()
                except Exception:
                    continue

                bundle_had_audio = True
                stats["total_audioclips"] += 1

                # Extract raw audio data
                raw_audio = b""
                res = getattr(clip, "m_Resource", None)
                if getattr(clip, "m_AudioData", None):
                    raw_audio = bytes(clip.m_AudioData)
                elif res and getattr(clip, "object_reader", None):
                    try:
                        raw_audio = get_resource_data(
                            res.m_Source,
                            clip.object_reader.assets_file,
                            res.m_Offset,
                            res.m_Size
                        )
                    except Exception:
                        pass

                magic = detect_magic(raw_audio)
                comp_id = getattr(clip, "m_CompressionFormat", -1)
                comp_name = COMPRESSION_FORMATS.get(comp_id, f"Unknown ({comp_id})")
                freq = getattr(clip, "m_Frequency", 0)
                chan = getattr(clip, "m_Channels", 0)
                length = getattr(clip, "m_Length", 0.0)

                cat = categorize(entry, clip.m_Name)

                stats["raw_formats"][magic] += 1
                stats["compression_formats"][comp_name] += 1
                stats["sample_rates"][freq] += 1
                stats["channels"][chan] += 1

                cat_info = stats["categories"][cat]
                cat_info["count"] += 1
                cat_info["total_size_bytes"] += len(raw_audio)
                cat_info["total_duration_sec"] += length
                if len(cat_info["clips"]) < 10:
                    cat_info["clips"].append(clip.m_Name)

                # Check if sample should be extracted
                target_names = sample_targets.get(cat, [])
                for t_name in target_names:
                    if t_name in clip.m_Name.lower():
                        sample_key = f"{cat}_{clip.m_Name}"
                        if sample_key not in extracted_samples:
                            extracted_samples.append(sample_key)
                            # Save raw container (FSB)
                            cat_folder = os.path.join(SAMPLE_OUT_DIR, cat.replace(" ", "_").lower())
                            os.makedirs(cat_folder, exist_ok=True)

                            if raw_audio:
                                raw_ext = ".fsb" if magic == "FSB5" else ".bin"
                                raw_path = os.path.join(cat_folder, f"{clip.m_Name}{raw_ext}")
                                with open(raw_path, "wb") as rf:
                                    rf.write(raw_audio)

                            # Save decoded wav
                            try:
                                samples = getattr(clip, "samples", {})
                                for s_name, s_bytes in samples.items():
                                    wav_path = os.path.join(cat_folder, s_name)
                                    with open(wav_path, "wb") as wf:
                                        wf.write(s_bytes)
                                    print(f"  [EXTRACTED SAMPLE] {cat}: {s_name} ({len(s_bytes)} bytes)")
                            except Exception as e:
                                print(f"  [WARN] Failed decoding {clip.m_Name}: {e}")

            if bundle_had_audio:
                stats["bundles_with_audioclip"] += 1

        print("\n=== SCAN RESULTS ===")
        print(f"Total audio bundles: {stats['total_bundles']}")
        print(f"Bundles containing AudioClips: {stats['bundles_with_audioclip']}")
        print(f"Total AudioClips found: {stats['total_audioclips']}")

        print("\n--- Categories Breakdown ---")
        for cat, data in stats["categories"].items():
            print(f"Category: {cat:15} | Count: {data['count']:4} | Total Size: {data['total_size_bytes']/(1024*1024):.2f} MB | Total Duration: {data['total_duration_sec']:.1f}s")
            print(f"  Sample clip names: {', '.join(data['clips'][:5])}")

        print("\n--- Container Formats (Raw Magic) ---")
        for fmt, cnt in stats["raw_formats"].items():
            print(f"  {fmt}: {cnt}")

        print("\n--- Unity Compression Formats ---")
        for fmt, cnt in stats["compression_formats"].items():
            print(f"  {fmt}: {cnt}")

        print("\n--- Sample Rates ---")
        for sr, cnt in sorted(stats["sample_rates"].items()):
            print(f"  {sr} Hz: {cnt}")

        print("\n--- Channels ---")
        for ch, cnt in sorted(stats["channels"].items()):
            print(f"  {ch} channel(s): {cnt}")

        # Save summary JSON
        json_out_path = r"D:\Henok\Projects\Game\audio_scan_summary.json"
        serializable_stats = {
            "total_bundles": stats["total_bundles"],
            "bundles_with_audioclip": stats["bundles_with_audioclip"],
            "total_audioclips": stats["total_audioclips"],
            "categories": {k: {"count": v["count"], "total_size_bytes": v["total_size_bytes"], "total_duration_sec": round(v["total_duration_sec"], 2), "sample_clips": v["clips"]} for k, v in stats["categories"].items()},
            "raw_formats": dict(stats["raw_formats"]),
            "compression_formats": dict(stats["compression_formats"]),
            "sample_rates": dict(stats["sample_rates"]),
            "channels": dict(stats["channels"]),
            "sample_extracted_dir": SAMPLE_OUT_DIR,
        }
        with open(json_out_path, "w", encoding="utf-8") as jf:
            json.dump(serializable_stats, jf, indent=2)
        print(f"\nSaved summary JSON to {json_out_path}")

if __name__ == "__main__":
    main()
