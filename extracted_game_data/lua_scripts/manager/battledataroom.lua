


---@class BattleDataRoom:BattleData
BattleDataRoom = class("BattleDataRoom", BattleData)

function BattleDataRoom:initialize()
    BattleData.initialize(self)
end


function BattleDataRoom:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data =nil
    if RaceRoomManager:Get():GetRaceType()==RaceRoomBattleType.Observer then
        data = RoomInitDataHelper:CreateRoomObServer(msg)
    else
        data = RoomInitDataHelper:CreateRoom(msg)
    end

    --if BattleDataManager:Get():IsReplay() then
    --    data = RoomInitDataHelper:CreateRoomReplay(msg)
    --else
    --
    --end
    BattleData.SetRoomData(self, data)
end

function BattleDataRoom:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end