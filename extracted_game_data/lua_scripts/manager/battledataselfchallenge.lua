


---@class BattleDataSelfChallenge:BattleData
BattleDataSelfChallenge = class("BattleDataSelfChallenge", BattleData)

function BattleDataSelfChallenge:initialize()
    BattleData.initialize(self)
end


function BattleDataSelfChallenge:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)

    local data
    if BattleDataManager:Get():IsReplay() then
        --data = RoomInitDataHelper:CreateRankReplay(msg)
    else
        data = RoomInitDataHelper:CreateSelfChallenge(msg)
    end
    BattleData.SetRoomData(self, data)
end

function BattleDataSelfChallenge:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end