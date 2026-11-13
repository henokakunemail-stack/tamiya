import os
import google.protobuf.descriptor_pb2 as desc_pb2
from google.protobuf import descriptor_pool, message_factory

pool = descriptor_pool.DescriptorPool()
net_dir = r"D:\Henok\Projects\Game\extracted_lua_net"

file_protos = {}
for fname in os.listdir(net_dir):
    if not fname.endswith(".lua"):
        continue
    with open(os.path.join(net_dir, fname), "rb") as f:
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

factory = message_factory.MessageFactory(pool)
AuthuserMess = factory.GetPrototype(pool.FindMessageTypeByName("AuthuserMess"))
LoginSuccess = factory.GetPrototype(pool.FindMessageTypeByName("LoginSuccess"))
LoginProp = factory.GetPrototype(pool.FindMessageTypeByName("LoginProp"))

# 1. Server List (91)
auth = AuthuserMess()
auth.uid = "10001"
auth.rid = 10001
auth.lastsvr = 1
auth.authtoken = "offline_token"
s = auth.svrs.add()
s.svrcode = 1
s.svrname = "Offline Local Server"
s.rid = 10001
s.ipadd = "127.0.0.1"
s.svrport = 8001
s.recommend = 1
s.runstat = "1"
auth_hex = auth.SerializeToString().hex()
print(f"AUTH_HEX = '{auth_hex}'")

# 2. Login Success (94)
suc = LoginSuccess()
suc.rid = 10001
suc.errorCode = ""
suc.serverTime = 1700000000
u = suc.userinfo
u.rid = 10001
u.uid = "10001"
u.serverid = 1
u.rolename = "LetsGoMaster"
u.headicon = 1001
u.iconframe = 1
u.curlevel = 50
u.stamina = 120
u.sign = "Mini 4WD Offline Champion"

gold = suc.myProps.add()
gold.rid = 10001
gold.propid = 100001
gold.propnum = 9999999

diamond = suc.myProps.add()
diamond.rid = 10001
diamond.propid = 100002
diamond.propnum = 999999

suc_hex = suc.SerializeToString().hex()
print(f"LOGIN_SUCCESS_HEX = '{suc_hex}'")

# 3. Login Prop (101)
prop = LoginProp()
prop.rid = 10001
prop.carShellNum = 50
car1 = prop.myCars.add()
car1.rid = 10001
car1.planseq = 1
car1.unlockflag = 1
car1.carplanname = "Cyclone Magnum"
car1.ifuse = 1

car2 = prop.myCars.add()
car2.rid = 10001
car2.planseq = 2
car2.unlockflag = 1
car2.carplanname = "Hurricane Sonic"
car2.ifuse = 0

prop_hex = prop.SerializeToString().hex()
print(f"LOGIN_PROP_HEX = '{prop_hex}'")
