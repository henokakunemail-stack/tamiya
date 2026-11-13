
---@class BattleDataTestRun:BattleData
BattleDataTestRun = class("BattleDataTestRun", BattleData)

function BattleDataTestRun:initialize()
    BattleData.initialize(self)
end



function BattleDataTestRun:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)

    local data = RoomInitDataHelper:CreateCustomTrackBattle(msg)
    self:SetRoomData(data)
end
function BattleDataTestRun:SetRoomData(data)
    self.LuaRoomData = data
    BattleDyDataManager:Get():InitLocalBattleDyCarData()
end

function BattleDataTestRun:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end