---@class BattleDataPVE : BattleData
BattleDataPVE = class("BattleDataPVE", BattleData)

function BattleDataPVE:initialize()
    BattleData.initialize(self)
end


function BattleDataPVE:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)

    local data = RoomInitDataHelper:CreatePVE(msg,msg.idx)
    BattleData.SetRoomData(self, data)

end

function BattleDataPVE:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end