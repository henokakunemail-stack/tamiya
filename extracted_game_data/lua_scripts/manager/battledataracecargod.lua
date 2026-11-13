---@class BattleDataRaceCarGod:BattleData
BattleDataRaceCarGod = class("BattleDataRaceCarGod", BattleData)

function BattleDataRaceCarGod:initialize()
    BattleData.initialize(self)
end

function BattleDataRaceCarGod:SetData(msg, type, isreplay)
    BattleData.SetData(self, nil, type, isreplay)
    local data
    if isreplay then
        data =RoomInitDataHelper:CreateRaceCarGodReplay(msg,msg.idx)
    else
        data = RoomInitDataHelper:CreateRaceCarGod(msg)
    end

    BattleData.SetRoomData(self, data)
end

function BattleDataRaceCarGod:SetResultData(data)
    local temp = BattleResultData()
    temp:SetPlayerListData(data)
    BattleData.SetResultData(self, temp)
end

---@param dropDown SC_SomeDown
function BattleDataRaceCarGod:SetFinishCarGodData(msg)
    self.FinishCarGodData = {
        errcode = msg.errcode,
        items = msg.curdown,
        SeasonID = msg.seasonid,
    }

    if  msg.curdown == nil then
        self.FinishCarGodData.items = { }
    end
end

---@return OtherResultData
function BattleDataRaceCarGod:GetFinishCarGodData()
    return self.FinishCarGodData
end