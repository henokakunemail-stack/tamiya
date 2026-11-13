---@class BattleDataRaceJcp:BattleData
BattleDataRaceJcp = class("BattleDataRaceJcp", BattleData)

function BattleDataRaceJcp:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceJcp:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
       -- data = RoomInitDataHelper:CreateRaceSelfLevelHistory(msg)
    else
        if RaceJcpManager:Get():GetRaceType()==RaceJcpRaceType.Test then
            data = RoomInitDataHelper:CreateRaceJcpTest(msg)
        end
        if RaceJcpManager:Get():GetRaceType()==RaceJcpRaceType.Battle then
            data = RoomInitDataHelper:CreateRaceJcp(msg)
        end
        if RaceJcpManager:Get():GetRaceType()==RaceJcpRaceType.Record then
            data = RoomInitDataHelper:CreateRaceJcpRecord(msg,RaceJcpManager:Get():GetLookId())
        end
        BattleData.SetRoomData(self, data)
    end

end

function BattleDataRaceJcp:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end