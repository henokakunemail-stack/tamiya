


---@class BattleDataRaceSelfLevel:BattleData
BattleDataRaceSelfLevel = class("BattleDataRaceSelfLevel", BattleData)

function BattleDataRaceSelfLevel:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceSelfLevel:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
        data = RoomInitDataHelper:CreateRaceSelfLevelHistory(msg)
    else
        data = RoomInitDataHelper:CreateRaceSelfLevel(msg)
    end

    BattleData.SetRoomData(self, data)
end

function BattleDataRaceSelfLevel:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end