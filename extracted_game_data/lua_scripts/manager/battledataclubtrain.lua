


---@class BattleDataClubTrain : BattleData
BattleDataClubTrain = class("BattleDataClubTrain", BattleData)

function BattleDataClubTrain:initialize()
    BattleData.initialize(self)
end



function BattleDataClubTrain:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)

    local data = RoomInitDataHelper:CreateClubTrain(msg)
    BattleData.SetRoomData(self, data)

end

function BattleDataClubTrain:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end