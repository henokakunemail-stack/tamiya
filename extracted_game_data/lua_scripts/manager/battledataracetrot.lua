---@class BattleDataRaceTrot:BattleData
BattleDataRaceTrot = class("BattleDataRaceTrot", BattleData)

function BattleDataRaceTrot:initialize()
    BattleData.initialize(self)
end


function BattleDataRaceTrot:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil,  type, isreplay)
    local data
    if isreplay then
        data = RoomInitDataHelper:CreateRaceSelfLevelHistory(msg)
    else
        data = RoomInitDataHelper:CreateRaceTrot(msg,PlayerDataManager:Get():GetPlayerRID())
    end
    local json= Dll_JSON.encode(msg)
    HistoryDataManager:Get():Save(json,RaceModel.RaceTrot)
    BattleData.SetRoomData(self, data)
end

function BattleDataRaceTrot:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end