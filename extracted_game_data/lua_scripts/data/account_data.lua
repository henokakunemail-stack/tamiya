---@class ServerInfo
ServerInfo = class("ServerInfo")

function ServerInfo:initialize()
    self.ServerIp =""--服务器id
    self.ServerName =1--服务器名称
    self.ServerRid = 0--服务器上rid
    self.IpAdd=1  --录服务器地址
    self.ServerPort=1 --服务器端口
    self.recommend=1--0不1推荐
    self.State=1 --运行状态0停止1正常2测试状态
end

---@param msg SC_svrList
function ServerInfo:InitServerInfo(msg,lastserver)
    self.ServerID = msg.svrcode
    self.ServerName = msg.svrname
    self.ServerRid = msg.rid
    self.IpAdd = msg.ipadd
    self.ServerPort = msg.svrport
    self.recommend = msg.recommend
    if msg.svrcode==lastserver then
        self.recommend=1
    else

    end

    self.State = tonumber(msg.runstat)
    self.isNew=msg.rid<=0


end


function ServerInfo:GetIp()
    return self.IpAdd
end

function ServerInfo:GetName()
    if self.ServerName==nil then
        return "ServerName"
    end
    return self.ServerName
end
function ServerInfo:SetName(name)
     self.ServerName=name
end

function ServerInfo:GetPort()
    return self.ServerPort
end
function ServerInfo:GetRid()
    return self.ServerRid
end

function ServerInfo:GetStatus()
    return self.State
end
function ServerInfo:GetRecommend()
    return self.recommend
end
function ServerInfo:GetServerId()
    return self.ServerID
end






function ServerInfo:GetIsNew()
    return self.isNew
end

function ServerInfo:SetServerId(serverId)
    self.ServerID = serverId
end

---@return ServerType
function ServerInfo:GetServerType()
    return self.serverType
end

function ServerInfo:GetGroupId()
    return self.groupId
end







---@class AccountData
AccountData =class("AccountData")
function AccountData:initialize()
    self.UID = 0
    self.Token = nil
    self.RoleId=0
    self.RoleName=nil
    self.ServerIp=nil
    self.ServerPort=nil
    self.isNew=true
end


---@param msg SC_AuthuserMess
function AccountData:OnInit_LoginMsg(msg)
    self.Token = msg.authtoken
    self.lastServer=msg.lastsvr
    self.UID=msg.uid
    self:OnInit_ServerInfoMsg(msg.svrs,msg.lastsvr)
end

function AccountData:SetIsNew(value)
    self.isNew=value
end

---@param msg  SC_svrList[]
function AccountData:OnInit_ServerInfoMsg(msg,lastsvr)
    self.ServerList = {}
    self.ServerDic = {}
    for i = 1, #msg do
        local serverInfo = ServerInfo()
        serverInfo:InitServerInfo(msg[i],lastsvr)
        table.insert(self.ServerList, serverInfo)
    end
end

---@param serverInfo ServerInfo
function AccountData:SetRecommendServer(serverInfo)
    self.recommendServer = serverInfo
end

---@return ServerInfo
function AccountData:GetRecommendServer()
    return self.recommendServer
end

function AccountData:ClearAccountDda()
    self.UID = nil
    self.Token = nil
    self.RoleId=nil
    self.RoleName=nil
    self.ServerIp=nil
    self.ServerPort=nil
    self.isNew=true
    ---@type table<number,ServerInfo>>@ key是serverId
    self.ServerDic = {}
    ---@type table<ServerType,table<number,number>>@ 第二个表的key是索引 value 是 serverId
    self.ServerIndexIdList = {}
end


