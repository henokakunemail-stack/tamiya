---@class BattleDataRaceTop:BattleData
BattleDataRaceTop = class("BattleDataRaceTop", BattleData)

function BattleDataRaceTop:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceTop:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
        data = RoomInitDataHelper:CreateRaceTopRecord(msg)
    else
        if RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Test then
            data = RoomInitDataHelper:CreateRaceTopTest(msg)
        end
        if RaceTopManager:Get():GetRaceType()==RaceTopRaceType.RaceTop then
            data = RoomInitDataHelper:CreateRaceTopRace(msg)
        end
        if RaceTopManager:Get():GetRaceType()==RaceTopRaceType.RaceB then
            data = RoomInitDataHelper:CreateRaceTopRace(msg)
        end
       if RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Audition then
            data = RoomInitDataHelper:CreateRaceTopRace(msg)
        end
       if RaceTopManager:Get():GetRaceType()==RaceTopRaceType.Record then
            data = RoomInitDataHelper:CreateRaceTopRecord(msg)
        end
    end
    BattleData.SetRoomData(self, data)
end

function BattleDataRaceTop:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end