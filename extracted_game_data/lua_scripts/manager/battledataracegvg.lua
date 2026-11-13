---@class BattleDataRaceGVG:BattleData
BattleDataRaceGVG = class("BattleDataRaceGVG", BattleData)

function BattleDataRaceGVG:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceGVG:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
        -- data = RoomInitDataHelper:CreateRaceSelfLevelHistory(msg)
    else
        data = RoomInitDataHelper:CreateRaceGVG(msg)
    end

    BattleData.SetRoomData(self, data)
end

function BattleDataRaceGVG:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end