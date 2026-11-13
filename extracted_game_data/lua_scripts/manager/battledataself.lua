


---@class BattleDataSelf:BattleData
BattleDataSelf = class("BattleDataSelf", BattleData)

function BattleDataSelf:initialize()
    BattleData.initialize(self)
end


function BattleDataSelf:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)

    local data
    if BattleDataManager:Get():IsReplay() then
        data = RoomInitDataHelper:CreateRaceSelfReplay(msg)
    else
        data = RoomInitDataHelper:CreateRaceSelf(msg)
    end

    BattleData.SetRoomData(self, data)
end

function BattleDataSelf:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)

end