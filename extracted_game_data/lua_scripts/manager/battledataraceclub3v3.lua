---@class BattleDataRaceClub3V3:BattleData
BattleDataRaceClub3V3 = class("BattleDataRaceClub3V3", BattleData)

function BattleDataRaceClub3V3:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceClub3V3:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
        -- data = RoomInitDataHelper:CreateRaceSelfLevelHistory(msg)
    else
        data = RoomInitDataHelper:CreateRaceClub3v3(msg)
    end

    BattleData.SetRoomData(self, data)
end

function BattleDataRaceClub3V3:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end