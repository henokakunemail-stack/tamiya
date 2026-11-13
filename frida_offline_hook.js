/**
 * Frida Offline In-Memory Interceptor for Mini 4WD (Option B)
 * Intercepts Horizon.Net.NetManager methods to provide offline responses without network sockets.
 */

console.log("[*] Attaching Mini 4WD Offline Hook...");

// Pre-serialized protobuf hex strings
const AUTH_HEX = "0a05313030303110a29c011802222f080212144f66666c696e65204c6f63616c2053657276657218a29c0122093132372e302e302e3128827d30023a01312a0d6f66666c696e655f746f6b656e";
const LOGIN_SUCCESS_HEX = "08a29c011a4008a29c01120531303030311802220c4c657473476f4d617374657228d20f3002386448f0016a194d696e6920345744204f66666c696e65204368616d70696f6e220d08a29c0110c29a0c18fed9c409220c08a29c0110c49a0c18fe887a5080c49fd50c";
const LOGIN_PROP_HEX = "08a29c01221a08a29c0110021802220e4379636c6f6e65204d61676e756d3802221908a29c0110041802220f487572726963616e6520536f6e69632864";

function hexToBytes(hex) {
    const bytes = [];
    for (let c = 0; c < hex.length; c += 2) {
        bytes.push(parseInt(hex.substr(c, 2), 16));
    }
    return bytes;
}

Il2Cpp.perform(() => {
    console.log("[*] IL2CPP runtime loaded!");

    // Find Horizon.Net.NetManager
    const NetManager = Il2Cpp.domain.assembly("Assembly-CSharp").image.class("Horizon.Net.NetManager");

    // Hook ConnectLoginServer: bypass socket and simulate instant success
    const ConnectLoginServer = NetManager.method("ConnectLoginServer");
    ConnectLoginServer.implementation = function(ip, port) {
        console.log(`[+] NetManager.ConnectLoginServer(${ip}, ${port}) intercepted! Triggering local success.`);
        const onConnect = NetManager.method("OnLoginServerConnect");
        onConnect.invoke(this, true, false);
    };

    // Hook ConnectGameServer
    const ConnectGameServer = NetManager.method("ConnectGameServer");
    ConnectGameServer.implementation = function(ip, port) {
        console.log(`[+] NetManager.ConnectGameServer(${ip}, ${port}) intercepted! Triggering local success.`);
        const onConnect = NetManager.method("OnGameServerConnect");
        onConnect.invoke(this, true, false);
    };

    // Hook SendLogin: intercept GET_SERVER_LIST_C2S_REQ (90)
    const SendLogin = NetManager.method("SendLogin");
    SendLogin.implementation = function(cmd, protoData, ismsgidx0) {
        console.log(`[+] SendLogin called with cmd: ${cmd}`);
        if (cmd === 90) {
            console.log("[+] Replying to GET_SERVER_LIST (90) with mock AuthuserMess (91)...");
            const raw = hexToBytes(AUTH_HEX);
            const byteArray = Il2Cpp.array(Il2Cpp.corlib.class("System.Byte"), raw);
            const onReceive = NetManager.method("OnLoginServerReceive");
            onReceive.invoke(this, 91, byteArray);
            return;
        }
        return SendLogin.invoke(this, cmd, protoData, ismsgidx0);
    };

    // Hook Send: intercept ENTER_SERVER (93) and ENTER_SERVER_PART (100)
    const Send = NetManager.method("Send");
    Send.implementation = function(cmd, protoData, ismsgidx0) {
        console.log(`[+] Send called with cmd: ${cmd}`);
        if (cmd === 93) {
            console.log("[+] Replying to ENTER_SERVER (93) with mock LoginSuccess (94)...");
            const raw = hexToBytes(LOGIN_SUCCESS_HEX);
            const byteArray = Il2Cpp.array(Il2Cpp.corlib.class("System.Byte"), raw);
            const onReceive = NetManager.method("OnGameServerReceive");
            onReceive.invoke(this, 94, byteArray);
            return;
        }
        if (cmd === 100) {
            console.log("[+] Replying to ENTER_SERVER_PART (100) with mock LoginProp (101)...");
            const raw = hexToBytes(LOGIN_PROP_HEX);
            const byteArray = Il2Cpp.array(Il2Cpp.corlib.class("System.Byte"), raw);
            const onReceive = NetManager.method("OnGameServerReceive");
            onReceive.invoke(this, 101, byteArray);
            return;
        }
        return Send.invoke(this, cmd, protoData, ismsgidx0);
    };

    console.log("[+] All offline hooks successfully installed!");
});
