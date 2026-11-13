"""
Mini 4WD Offline Mock TCP Server (Option A - Fully Verified AES-128-ECB Protocol)
Handles TCP handshake, LoginServer (9001), and GameServer (8001) for Flash Racer / 爆走兄弟 Let's & Go!!
"""

import socket
import struct
import threading
import os
import sys
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import google.protobuf.descriptor_pb2 as desc_pb2
from google.protobuf import descriptor_pool, message_factory

AES_KEY = b"a0ec7d6cdce59de7"

# 1. Initialize Protobuf Pool from extracted descriptors
print("[MockServer] Loading Protobuf descriptors...", flush=True)
pool = descriptor_pool.DescriptorPool()
net_dir = os.path.join(os.path.dirname(__file__), "extracted_lua_net")

file_protos = {}
for fname in os.listdir(net_dir):
    if not fname.endswith(".lua"):
        continue
    fpath = os.path.join(net_dir, fname)
    with open(fpath, "rb") as f:
        data = f.read()
    try:
        fds = desc_pb2.FileDescriptorSet()
        fds.ParseFromString(data)
        for fp in fds.file:
            file_protos[fp.name] = fp
    except Exception:
        pass

unadded = dict(file_protos)
passes = 0
while unadded and passes < 10:
    passes += 1
    progress = False
    for name, fp in list(unadded.items()):
        try:
            pool.Add(fp)
            del unadded[name]
            progress = True
        except Exception:
            pass
    if not progress:
        break

print(f"[MockServer] Loaded {len(file_protos) - len(unadded)} Protobuf descriptors.", flush=True)

factory = message_factory.MessageFactory(pool)
AuthuserMess = factory.GetPrototype(pool.FindMessageTypeByName("AuthuserMess"))
svrList = factory.GetPrototype(pool.FindMessageTypeByName("svrList"))
LoginSuccess = factory.GetPrototype(pool.FindMessageTypeByName("LoginSuccess"))
UserInfoPacket = factory.GetPrototype(pool.FindMessageTypeByName("UserInfoPacket"))
UserProp = factory.GetPrototype(pool.FindMessageTypeByName("UserProp"))
LoginProp = factory.GetPrototype(pool.FindMessageTypeByName("LoginProp"))
UserCar = factory.GetPrototype(pool.FindMessageTypeByName("UserCar"))
UserCarDetail = factory.GetPrototype(pool.FindMessageTypeByName("UserCarDetail"))
UserPart = factory.GetPrototype(pool.FindMessageTypeByName("UserPart"))

# Message IDs
MSG_GET_SERVER_LIST_REQ = 90
MSG_GET_SERVER_LIST_RES = 91
MSG_ENTER_SERVER_REQ = 93
MSG_ENTER_SERVER_RES = 94
MSG_HEARTBEAT_REQ = 95
MSG_HEARTBEAT_RES = 96
MSG_ENTER_SERVER_PART_REQ = 100
MSG_ENTER_SERVER_PART_RES = 101

def pack_packet(msg_id, payload_bytes, msg_idx=0, use_aes=True):
    """
    TNet + Horizon Framing:
    [4 bytes LE length] [AES-128-ECB PKCS7 encrypted: [4B MsgIdx][2B MsgID][payload]]
    """
    inner = struct.pack("<IH", msg_idx, msg_id) + payload_bytes
    if use_aes:
        padded = pad(inner, 16)
        cipher = AES.new(AES_KEY, AES.MODE_ECB)
        enc = cipher.encrypt(padded)
        return struct.pack("<I", len(enc)) + enc
    else:
        total_len = len(inner)
        return struct.pack("<I", total_len) + inner

def unpack_packets(buffer):
    """
    Parses incoming packet stream with auto-detection of AES vs plain.
    """
    packets = []
    while len(buffer) >= 4:
        total_len = struct.unpack("<I", buffer[:4])[0]
        if total_len > 1000000 or total_len == 0:
            # Desynchronized stream
            buffer = buffer[1:]
            continue
        if len(buffer) < 4 + total_len:
            break
        packet_data = buffer[4:4 + total_len]
        buffer = buffer[4 + total_len:]

        # Try AES decryption first
        decrypted = None
        use_aes = True
        try:
            cipher = AES.new(AES_KEY, AES.MODE_ECB)
            decrypted = unpad(cipher.decrypt(packet_data), 16)
        except Exception:
            # Fallback to plain
            decrypted = packet_data
            use_aes = False

        if decrypted and len(decrypted) >= 6:
            msg_idx, msg_id = struct.unpack("<IH", decrypted[:6])
            payload = decrypted[6:]
            packets.append((msg_id, msg_idx, payload, use_aes))
        elif decrypted and len(decrypted) >= 4:
            msg_id, msg_idx = struct.unpack("<HH", decrypted[:4])
            payload = decrypted[4:]
            packets.append((msg_id, msg_idx, payload, use_aes))

    return packets, buffer

def handle_login_client(conn, addr):
    print(f"[LoginServer:9001] Client connected from {addr}", flush=True)
    buf = b""
    try:
        while True:
            chunk = conn.recv(4096)
            if not chunk:
                break
            buf += chunk

            # Check if this is an HTTP request
            if buf.startswith(b"GET ") or buf.startswith(b"POST "):
                if b"\r\n\r\n" in buf:
                    header, body = buf.split(b"\r\n\r\n", 1)
                    first_line = header.split(b"\r\n")[0].decode(errors='ignore')
                    print(f"[LoginServer:9001] Received HTTP: {first_line}", flush=True)

                    http_res = (
                        b"HTTP/1.1 200 OK\r\n"
                        b"Content-Type: application/json\r\n"
                        b"Content-Length: 2\r\n"
                        b"Connection: close\r\n\r\n"
                        b"{}"
                    )
                    conn.sendall(http_res)
                    break
                continue

            packets, buf = unpack_packets(buf)
            for msg_id, msg_idx, payload, use_aes in packets:
                print(f"[LoginServer:9001] Received MsgID: {msg_id} (idx={msg_idx}, len={len(payload)}, aes={use_aes})", flush=True)
                if msg_id == MSG_GET_SERVER_LIST_REQ:
                    res = AuthuserMess()
                    res.uid = "10001"
                    res.rid = 10001
                    res.lastsvr = 1
                    res.authtoken = "offline_local_token"

                    s = res.svrs.add()
                    s.svrcode = 1
                    s.svrname = "Offline Grand Prix Server"
                    s.rid = 10001
                    s.ipadd = "127.0.0.1"
                    s.svrport = 8001
                    s.recommend = 1
                    s.runstat = "1"
                    s.domain = ""

                    body = res.SerializeToString()
                    pkt = pack_packet(MSG_GET_SERVER_LIST_RES, body, msg_idx, use_aes=use_aes)
                    conn.sendall(pkt)
                    print(f"[LoginServer:9001] Sent S2C_SERVER_LIST (91) with 127.0.0.1:8001 to {addr}", flush=True)
    except Exception as e:
        print(f"[LoginServer:9001] Connection exception: {e}", flush=True)
    finally:
        conn.close()
        print(f"[LoginServer:9001] Client disconnected: {addr}", flush=True)

def handle_game_client(conn, addr):
    print(f"[GameServer:8001] Client connected from {addr}", flush=True)
    buf = b""
    try:
        while True:
            chunk = conn.recv(4096)
            if not chunk:
                break
            buf += chunk
            packets, buf = unpack_packets(buf)
            for msg_id, msg_idx, payload, use_aes in packets:
                print(f"[GameServer:8001] Received MsgID: {msg_id} (idx={msg_idx}, len={len(payload)}, aes={use_aes})", flush=True)

                if msg_id == MSG_ENTER_SERVER_REQ:
                    # Reply with LoginSuccess (Player Profile + Currency)
                    res = LoginSuccess()
                    res.rid = 10001
                    res.errorCode = ""
                    res.serverTime = 1700000000

                    # Player Info
                    u = res.userinfo
                    u.rid = 10001
                    u.uid = "10001"
                    u.serverid = 1
                    u.rolename = "TamiyaLegend"
                    u.headicon = 1001
                    u.iconframe = 1
                    u.curlevel = 50
                    u.stamina = 999
                    u.sign = "Let's & Go Offline Champion"

                    # Currencies (Gold & Diamonds)
                    gold = res.myProps.add()
                    gold.rid = 10001
                    gold.propid = 100001
                    gold.propnum = 9999999

                    diamond = res.myProps.add()
                    diamond.rid = 10001
                    diamond.propid = 100002
                    diamond.propnum = 999999

                    body = res.SerializeToString()
                    pkt = pack_packet(MSG_ENTER_SERVER_RES, body, msg_idx, use_aes=use_aes)
                    conn.sendall(pkt)
                    print(f"[GameServer:8001] Sent S2C_LOGIN_SUCCESS (Lobby Unlock) to {addr}", flush=True)

                elif msg_id == MSG_ENTER_SERVER_PART_REQ:
                    # Reply with LoginProp (Unlocked Cars & Garage Inventory)
                    prop = LoginProp()
                    prop.rid = 10001
                    prop.carShellNum = 50

                    # Starter Flagship Cars (Cyclone Magnum & Hurricane Sonic)
                    car1 = prop.myCars.add()
                    car1.rid = 10001
                    car1.planseq = 1
                    car1.unlockflag = 1
                    car1.carplanname = "Cyclone Magnum Special"
                    car1.ifuse = 1

                    car2 = prop.myCars.add()
                    car2.rid = 10001
                    car2.planseq = 2
                    car2.unlockflag = 1
                    car2.carplanname = "Hurricane Sonic Special"
                    car2.ifuse = 0

                    body = prop.SerializeToString()
                    pkt = pack_packet(MSG_ENTER_SERVER_PART_RES, body, msg_idx, use_aes=use_aes)
                    conn.sendall(pkt)
                    print(f"[GameServer:8001] Sent S2C_LOGIN_PROP (Garage & Parts Inventory) to {addr}", flush=True)

                elif msg_id == MSG_HEARTBEAT_REQ:
                    # Echo back heartbeat response
                    pkt = pack_packet(MSG_HEARTBEAT_RES, b"", msg_idx, use_aes=use_aes)
                    conn.sendall(pkt)
                    print(f"[GameServer:8001] Replied to Heartbeat ({msg_id})", flush=True)
    except Exception as e:
        print(f"[GameServer:8001] Connection exception: {e}", flush=True)
    finally:
        conn.close()
        print(f"[GameServer:8001] Client disconnected: {addr}", flush=True)

def start_server(port, handler, name):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(("0.0.0.0", port))
    s.listen(10)
    print(f"[{name}] Listening on 0.0.0.0:{port}...", flush=True)
    while True:
        try:
            conn, addr = s.accept()
            threading.Thread(target=handler, args=(conn, addr), daemon=True).start()
        except Exception as e:
            print(f"[{name}] Accept error: {e}", flush=True)

if __name__ == "__main__":
    t_login = threading.Thread(target=start_server, args=(9001, handle_login_client, "LoginServer"), daemon=True)
    t_game = threading.Thread(target=start_server, args=(8001, handle_game_client, "GameServer"), daemon=True)
    t_login.start()
    t_game.start()
    print("=" * 60, flush=True)
    print("Mini 4WD Offline Mock Server is RUNNING (AES-128-ECB ENABLED)!", flush=True)
    print("LoginServer Port: 9001 (matches White_Ip in PlayerPrefs)", flush=True)
    print("GameServer Port : 8001", flush=True)
    print("=" * 60, flush=True)
    try:
        t_login.join()
    except KeyboardInterrupt:
        print("\nShutting down mock server.", flush=True)
