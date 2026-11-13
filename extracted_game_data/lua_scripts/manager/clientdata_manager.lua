---@class ClientDataManager
ClientDataManager = class("ClientDataManager")

---@return ClientDataManager
function ClientDataManager:Get()
    ---@type
    if self._instance == nil then
        self._instance = ClientDataManager()
    end
    return self._instance
end

function ClientDataManager:initialize()
    self.AccountData = AccountData
    self.MsgCount=0
    self.MsgTime=0
    --CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

function ClientDataManager:SetLoginMsg(data)
    self.AccountData:OnInit_LoginMsg(data)
end
---@param msg SC_MenuInfo[]
function ClientDataManager:SetMenuList(msg)

end
function ClientDataManager:GetUID()
    return self.AccountData.UID
end
function ClientDataManager:GetLastServer()
    return self.AccountData.lastServer
end
function ClientDataManager:SetPId(value)
    self.AccountData.RoleId=value
end
function ClientDataManager:GetPID()
    if self.AccountData==nil then
        return 0
    end
    return self.AccountData.RoleId
end
function ClientDataManager:GetToken()
    return self.AccountData.Token
end
function ClientDataManager:GetSessioncode()
    return self.AccountData.Sessioncode
end
function ClientDataManager:GetIsNew()
    return self.AccountData.isNew
end
function ClientDataManager:SetIsNew(value)
    self.AccountData:SetIsNew(value)
end
---@return ServerInfo[]
function ClientDataManager:GetServerList()
    return self.AccountData.ServerList
end

---@return ServerInfo
function ClientDataManager:GetRecommendServer()
    local result=nil
    for i = 1, #self.AccountData.ServerList do
        if self.AccountData.ServerList[i]:GetRecommend()==1 then
            result=self.AccountData.ServerList[i]
        end
    end
    return result
end
---@return ServerInfo
function ClientDataManager:GetFirstServer()

    return self.AccountData.ServerList[1]

end
---@return  ServerInfo
function ClientDataManager:GetServerInfoByServerId(serverId)
    local result=nil
    for i = 1, #self.AccountData.ServerList do
        if self.AccountData.ServerList[i]:GetServerId()==serverId then
            result=self.AccountData.ServerList[i]
        end
    end
    return result
end















---@param serverInfo ServerInfo
function ClientDataManager:SetRecommendServer(serverInfo)
    self.AccountData:SetRecommendServer(serverInfo)
end
---@param serverType ServerType
---@return table<number,number>
function ClientDataManager:GetServerListByType(serverType)
    if self.AccountData.ServerIndexIdList[serverType] then
        return self.AccountData.ServerIndexIdList[serverType]
    else
        logError("该类型的服务器不存在   " .. tostring(serverType))
        return {}
    end
end













---@param data  SC_svrList[]
function ClientDataManager:SetServerListMsg(data)
    self.AccountData:OnInit_ServerInfoMsg(data)
end





---@param serverType ServerType
---@return  ServerInfo
function ClientDataManager:GetServerInfoByIndex(serverType, serverIndex)
    if self.AccountData.ServerIndexIdList[serverType] then
        local serverId = self.AccountData.ServerIndexIdList[serverType][serverIndex]
        return self:GetServerInfoByServerId(serverId)
    else
        logError("该serverType服务器不存在   ", serverType, serverIndex)
        return -1
    end
end

------------------------------------------------------------------------配置表
-- 登陆之前的时候加载的配置表
function ClientDataManager:InitLoginConfig()
    --CfgManager:Get():LoadLoginCfg_PB()
end
function ClientDataManager:InitAppStartConfig()
    CfgManager:Get():LoadAppStartCfg_PB()
end

-- 登陆之后第一次Loading主城的时候加载的场景
function ClientDataManager:InitConfig()
    --CfgManager:Get():LoadCfg_PB()
end

function ClientDataManager:SetGameState(gamestate)
    self.gameState = gamestate
end
function ClientDataManager:GetGameState()
    return self.gameState
end
function ClientDataManager:SetServerStartTime(serverStartTime)
    self.serverStartTime = serverStartTime

end
function ClientDataManager:GetServerStartTime()
    return self.serverStartTime
end

function ClientDataManager:GetDataTable(name)
    return CfgManager:Get():GetConfig(name)
end
------------------------------------------------------------------------

function ClientDataManager:TranslateTargetLand()
    if self.LanguageType == LanguageType.CHS then
        return "zh-CN"
    end
    if self.LanguageType == LanguageType.CHT then
        return "zh-TW"
    end
    if self.LanguageType == LanguageType.EN then
        return "en"
    end
    if self.LanguageType == LanguageType.THAI then
        return "th-TH"
    end
    if self.LanguageType == LanguageType.IDA then
        return "id-ID"
    end
    if self.LanguageType == LanguageType.PT_BR then
        return "pt-BR"
    end
    if self.LanguageType == LanguageType.KR then
        return "kr"
    end
    if self.LanguageType == LanguageType.JP then
        return "jp"
    end
    return "en"
end
local stringTables={
    ConfigNames.templetstring_config,
    ConfigNames.templetstringattr_config,
    ConfigNames.templetstringparts_config,
    ConfigNames.templetstringstory_config,
    ConfigNames.tempstringuistatic_config,
    ConfigNames.templetstringattrfeature_config,
    ConfigNames.tempstringerrcode_config
}
local stringTables2={
    ConfigNames.templetstring_config,
    ConfigNames.tempstringerrcode_config,
    ConfigNames.templetstringattr_config,
    ConfigNames.templetstringparts_config,
    ConfigNames.templetstringstory_config,
    ConfigNames.templetstringattrfeature_config,

}
function ClientDataManager:ReLoadString(func)
    cs_coroutine.start(function()
        for k, v in pairs(stringTables) do
            local table = ClientDataManager:Get():GetDataTable(v)
            coroutine.yield()
            table.ReLoad()
        end
        func()
    end)

end
------------------------------------------------------------------------获取配置字符串
function ClientDataManager:GetTemplateString(id, isReturnKey)

    if self.LanguageType == nil then
        self.LanguageType = LanguageSwitchManager.Get():GetCurLanguage()
    end

    if isReturnKey == nil then
        isReturnKey = true
    end
    if id == nil then
        return "tempstrID = nil"
    end
    if id == "" then
        return "tempstrID = empty"
    end
    for k, v in pairs(stringTables2) do
        local cfgdata = CommonHelper:GetTableDataByID(v, id)
        if cfgdata then
            if GameProperties.CfgIsLuaTable then
                return cfgdata
            end
            if GameProperties.AssetBundleMode then
                return cfgdata.text
            end
            if self.LanguageType == LanguageType.CHS then
                return cfgdata.chs
            end
            if self.LanguageType == LanguageType.CHT then
                return cfgdata.cht
            end
            if self.LanguageType == LanguageType.EN then
                return cfgdata.en
            end
            if self.LanguageType == LanguageType.THAI then
                return cfgdata.tai
            end
            if self.LanguageType == LanguageType.IDA then
                return cfgdata.ind
            end
            if self.LanguageType == LanguageType.PT_BR then
                return cfgdata.pt_BR
            end
            if self.LanguageType == LanguageType.KR then
                return cfgdata.kr
            end
            if self.LanguageType == LanguageType.JP then
                return cfgdata.jp
            end
            return cfgdata.chs
        end
    end
    if isReturnKey then
        --return "<color=#ff0000>"..id.."</color>"
        return id
    else
        return ""
    end


end
------------------------------------------------------------------------


--{{{重登陆，清理数据
function ClientDataManager:Logout()
    CacheClearTrigger:Get():Logout()
end
--}}}


--{{{重登陆，清理资源
function ClientDataManager:LogoutClearRes()
    CarCacheManager:Get():ClearData()
    TeamCacheManager:Get():ClearData()
    PersonalHomeDataManager:Get():ClearData()
end
--}}}

--{{{重登陆时检测版本更新，清理lua侧对c#的引用
function ClientDataManager:LogoutClearAssets()
    MeshCacheMgr:Get():ReleaseAllMesh()
    PrefabCacheMgr:Get():ReleaseAllMesh()
    UINotify:Get():ReleaseXLuaRelevance()
    TimerManager:Get():ReleaseXLuaRelevance()
end
--}}}


function ClientDataManager:ClearAccountData()
    self.AccountData:ClearAccountDda()
end





