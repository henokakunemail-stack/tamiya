


---@class BattleDataRank:BattleData
BattleDataRank = class("BattleDataRank", BattleData)

function BattleDataRank:initialize()
    BattleData.initialize(self)
end


function BattleDataRank:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)

    local data
    if BattleDataManager:Get():IsReplay() then
        data = RoomInitDataHelper:CreateRankHistory(msg)
    else
        if RaceRankManager:Get():GetRaceType()==RaceRankRaceType.Test then
            data = RoomInitDataHelper:CreateRankTest(msg)
        else
            data = RoomInitDataHelper:CreateRank(msg)
        end
    end
    BattleData.SetRoomData(self, data)
end

function BattleDataRank:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end