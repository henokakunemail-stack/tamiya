


---@class BattleDataClubRaceSelfChapter:BattleData
BattleDataClubRaceSelfChapter = class("BattleDataClubRaceSelfChapter", BattleData)

function BattleDataClubRaceSelfChapter:initialize()
    BattleData.initialize(self)
end



function BattleDataClubRaceSelfChapter:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)

    local data
    if BattleDataManager:Get():IsReplay() then
        --data = RoomInitDataHelper:CreateRankReplay(msg)
    else
        data = RoomInitDataHelper:CreateClubRaceSelfChapter(msg)
    end
    BattleData.SetRoomData(self, data)
end

function BattleDataClubRaceSelfChapter:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end