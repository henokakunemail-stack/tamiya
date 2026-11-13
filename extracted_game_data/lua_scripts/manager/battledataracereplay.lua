---@class BattleDataRaceReplay:BattleData
BattleDataRaceReplay = class("BattleDataRaceReplay", BattleData)

function BattleDataRaceReplay:initialize()
    BattleData.initialize(self)
end



function BattleDataRaceReplay:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)


    --if BattleDataManager:Get():IsReplay() then
    --    data = RoomInitDataHelper:CreateRankReplay(msg)
    --else
    local data  = RoomInitDataHelper:CreatePVEReplay(msg,msg.idx)
    --end
    BattleData.SetRoomData(self, data)
end

function BattleDataRaceReplay:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end