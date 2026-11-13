

local __instance
---@class RaceWeekManager
RaceWeekManager = class("RaceWeekManager")
function RaceWeekManager:initialize()
    ---@type table<number, RaceWeekData>
    self.RaceList = {}
end
---@return RaceWeekManager
function RaceWeekManager:Get()
    if __instance == nil then
        __instance = RaceWeekManager()
    end
    return __instance
end

---@param msg table<number,SC_ChampionshipsInfo>
function RaceWeekManager:SetMsgData(msg)
    self.RaceList = {}
    for i = 1, #msg do
        local tempmsg = msg[i]
        local data = RaceWeekData()
        data:SetBaseData(tempmsg.uniqueId, tempmsg.isJoin, tempmsg.joinNum)
        self.RaceList[tempmsg.uniqueId] = data
    end
end

---@param msg SC_GetChampionshipsDetailRes
function RaceWeekManager:SetRaceDetailInfo(msg)
    local data = self.RaceList[msg.id]
    if data then data:SetDetailData(msg) end
    return data
end

function RaceWeekManager:TryOpenRaceInfo(id)
    UIManager:Get():OpenView("RaceWeekDetailView",CanvasType.MainCanvas,"RaceWeekDetailView")
    RaceWeekSubsystem:Get():SendMsg_RaceDetail(id)
end

function RaceWeekManager:GetRaceList()
    return self.RaceList
end