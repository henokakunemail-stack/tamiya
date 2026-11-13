



--{{{ 战斗服匹配数据
---@class MatchData
MatchData = class("MatchData")
function MatchData:initialize()
    ---@type SerE_PVPType
    self.Type = -1
    self.IP = -1
    self.Port = -1
    self.Session = ""
end
function MatchData:InitData(ip, port, type, session)
    self.IP = ip
    self.Port = port
    self.Type = type
    self.Session = session
end
--}}}