




local __instance
---@class MatchManager
MatchManager = class("MatchManager")
function MatchManager:initialize()
    ---@type MatchData
    self.MatchData = nil

    self.ConnectFlag = -1

    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end
---@return MatchManager
function MatchManager:Get()
    if __instance == nil then
        __instance = MatchManager()
    end
    return __instance
end
function MatchManager:ClearData()
    self.MatchData = nil
end

function MatchManager:InitData(ip, port, type, session)
    self.MatchData = MatchData()
    self.MatchData:InitData(ip, port, type, session)
end

function MatchManager:SetConnectFlag(flag) self.ConnectFlag = flag end

function MatchManager:GetIP() if self.MatchData then return self.MatchData.IP end end
function MatchManager:GetPort() if self.MatchData then return self.MatchData.Port end end
function MatchManager:GetSession() if self.MatchData then return self.MatchData.Session end end
function MatchManager:GetType() if self.MatchData then return self.MatchData.Type end end
function MatchManager:GetConnectFlag() return self.ConnectFlag end

function MatchManager:MatchDataIsNil() return self.MatchData == nil end
function MatchManager:IsReconnectOnLogin() return self.ConnectFlag == RaceRankReconnectFlag.LoginConnect end






