---@class BattleDataRaceNewbie : BattleData
BattleDataRaceNewbie = class("BattleDataRaceNewbie", BattleData)

function BattleDataRaceNewbie:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceNewbie:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)

    local data = RoomInitDataHelper:CreateNewbie(msg,msg.idx)
    BattleData.SetRoomData(self, data)

end

function BattleDataRaceNewbie:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end