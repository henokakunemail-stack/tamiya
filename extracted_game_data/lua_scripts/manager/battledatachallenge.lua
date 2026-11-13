


---@class BattleDataChallenge:BattleData
BattleDataChallenge = class("BattleDataChallenge", BattleData)

function BattleDataChallenge:initialize()
    BattleData.initialize(self)
end



function BattleDataChallenge:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)
    local data =nil
    if BattleDataManager:Get():IsReplay() then
     data = RoomInitDataHelper:CreateChallengeReplay(msg,1)
    else
     data  = RoomInitDataHelper:CreateChallenge(msg,1)
    end
    BattleData.SetRoomData(self, data)
end

function BattleDataChallenge:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end