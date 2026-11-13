---@class BattleDataRaceXcp:BattleData
BattleDataRaceXcp = class("BattleDataRaceXcp", BattleData)

function BattleDataRaceXcp:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceXcp:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
        -- data = RoomInitDataHelper:CreateRaceSelfLevelHistory(msg)
    else
        if RaceXCupManager:Get():GetRaceType()==RaceJcpRaceType.Test then
            data = RoomInitDataHelper:CreateRaceJcpTest(msg)
        end
        if RaceXCupManager:Get():GetRaceType()==RaceJcpRaceType.Battle then
            data = RoomInitDataHelper:CreateRaceJcp(msg)
        end
        if RaceXCupManager:Get():GetRaceType()==RaceJcpRaceType.Record then
            data = RoomInitDataHelper:CreateRaceJcpRecord(msg,RaceXCupManager:Get():GetLookId())
        end
        BattleData.SetRoomData(self, data)
    end

end

function BattleDataRaceXcp:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end