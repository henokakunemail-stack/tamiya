
---@class BattleDataGuideBattle:BattleData
BattleDataGuideBattle = class("BattleDataGuideBattle", BattleData)

function BattleDataGuideBattle:initialize()
    BattleData.initialize(self)
end



function BattleDataGuideBattle:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)

    local data = RoomInitDataHelper:CreateGuideBattle(msg)
    self:SetRoomData(data)
end
function BattleDataGuideBattle:SetRoomData(data)
    self.LuaRoomData = data
    BattleDyDataManager:Get():InitLocalBattleDyCarData()
end

function BattleDataGuideBattle:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end