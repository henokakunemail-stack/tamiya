


---@class BattleDataRaceAssemble:BattleData
BattleDataRaceAssemble = class("BattleDataRaceAssemble", BattleData)

function BattleDataRaceAssemble:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceAssemble:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
        data = RoomInitDataHelper:CreateRaceSelfLevelHistory(msg)
    else
        data = RoomInitDataHelper:CreateRaceSelfLevel(msg)
    end

    BattleData.SetRoomData(self, data)
end

function BattleDataRaceAssemble:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end