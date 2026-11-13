---@class BattleDataRaceSuperBattle : BattleData
BattleDataRaceSuperBattle = class("BattleDataRaceSuperBattle", BattleData)

function BattleDataRaceSuperBattle:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceSuperBattle:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)
    local data =nil
    if isreplay then
        data=RoomInitDataHelper:CreateRaceSuperBattle(msg,msg.idx)
    else
        data=RoomInitDataHelper:CreateRaceSuperBattle(msg,msg.idx)
    end

    BattleData.SetRoomData(self, data)

end

function BattleDataRaceSuperBattle:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end