


---@class BattleDataWeek:BattleData
BattleDataWeek = class("BattleDataWeek", BattleData)

function BattleDataWeek:initialize()
    BattleData.initialize(self)
end


function BattleDataWeek:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)

    local data
    if BattleDataManager:Get():IsReplay() then
        data = RoomInitDataHelper:CreateRaceWeekReplay(msg)
    else
        data = RoomInitDataHelper:CreateRaceWeek(msg)
    end

    BattleData.SetRoomData(self, data)
end

function BattleDataWeek:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)

end