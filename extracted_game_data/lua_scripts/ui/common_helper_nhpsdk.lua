



--{{{易盾SDK接口
function CommonHelper:NHPSdkSetRoleInfo()
    local id = tostring(PlayerDataManager:Get():GetPlayerUID())
    local name = tostring(PlayerDataManager:Get():GetPlayerName())
    local serverid = tostring(PlayerDataManager:Get():GetPlayerServerID())
    local serverinfo = ClientDataManager:Get():GetServerInfoByServerId(PlayerDataManager:Get():GetPlayerServerID())
    local servername = serverinfo.name
    local version =HVersionManager:GetVersion()
    mono.NHPSdkSetRoleInfo(id, name, serverid, servername, version, version)
end
--}}}