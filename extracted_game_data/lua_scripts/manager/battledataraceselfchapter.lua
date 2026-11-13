


---@class BattleDataRaceSelfChapter:BattleData
BattleDataRaceSelfChapter = class("BattleDataRaceSelfChapter", BattleData)

function BattleDataRaceSelfChapter:initialize()
    BattleData.initialize(self)
end



function BattleDataRaceSelfChapter:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)

    local data
    if BattleDataManager:Get():IsReplay() then
        --data = RoomInitDataHelper:CreateRankReplay(msg)
    else
        data = RoomInitDataHelper:CreateRaceSelfChapter(msg,1)
    end
    BattleData.SetRoomData(self, data)
end

function BattleDataRaceSelfChapter:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end