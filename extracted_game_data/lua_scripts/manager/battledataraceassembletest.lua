
---@class BattleDataRaceAssembleTest:BattleData
BattleDataRaceAssembleTest = class("BattleDataRaceAssembleTest", BattleData)

function BattleDataRaceAssembleTest:initialize()
    BattleData.initialize(self)
end



function BattleDataRaceAssembleTest:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)

    local data = RoomInitDataHelper:CreateRaceAssembleTest(msg)
    self:SetRoomData(data)
end
function BattleDataRaceAssembleTest:SetRoomData(data)
    self.LuaRoomData = data
    BattleDyDataManager:Get():InitLocalBattleDyCarData()
end

function BattleDataRaceAssembleTest:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end