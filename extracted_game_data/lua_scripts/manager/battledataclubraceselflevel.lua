


---@class BattleDataClubRaceSelfLevel:BattleData
BattleDataClubRaceSelfLevel = class("BattleDataClubRaceSelfLevel", BattleData)

function BattleDataClubRaceSelfLevel:initialize()
    BattleData.initialize(self)
end



function BattleDataClubRaceSelfLevel:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)

    local data
    if BattleDataManager:Get():IsReplay() then
        --data = RoomInitDataHelper:CreateRankReplay(msg)
    else
        data = RoomInitDataHelper:CreateClubRaceSelfLevel(msg)
    end
    BattleData.SetRoomData(self, data)
end

function BattleDataClubRaceSelfLevel:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end