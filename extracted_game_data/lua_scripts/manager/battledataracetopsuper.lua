---@class BattleDataRaceTopSuper:BattleData
BattleDataRaceTopSuper = class("BattleDataRaceTopSuper", BattleData)

function BattleDataRaceTopSuper:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceTopSuper:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
        data = RoomInitDataHelper:CreateRaceTopRecord(msg)
    else
        if RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Test then
            data = RoomInitDataHelper:CreateRaceTopTest(msg)
        end
        if RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.RaceTop then
            data = RoomInitDataHelper:CreateRaceTopRace(msg)
        end
        if RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.RaceB then
            data = RoomInitDataHelper:CreateRaceTopRace(msg)
        end
        if RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Audition then
            data = RoomInitDataHelper:CreateRaceTopRace(msg)
        end
        if RaceTopSuperManager:Get():GetRaceType()==RaceTopRaceType.Record then
            data = RoomInitDataHelper:CreateRaceTopRecord(msg)
        end
    end
    BattleData.SetRoomData(self, data)
end

function BattleDataRaceTopSuper:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end