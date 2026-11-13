---@class ChallengeMatchData
ChallengeMatchManager = class("ChallengeMatchManager")

function ChallengeMatchManager:initialize()
    self.fightNum = 0
    self.maxFightNum = 0
    ---@type MatchRoomData[]
    self.BattleRooms = {}
    self.RecordsData = {}
    self.RetJoinBattleData = nil
    self.RoomTimeIds = {}

    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

function ChallengeMatchManager:Get()
    if self._instance == nil then
        self._instance = ChallengeMatchManager()
    end
    return self._instance
end

function ChallengeMatchManager:InitBattleRoomData(msg)
    self.BattleRooms = {}
    for i, v in pairs(msg) do
       local matchRoomData = MatchRoomData()
       matchRoomData:InitData(v)
       self.BattleRooms[matchRoomData:GetID()] = matchRoomData
   end
end

function ChallengeMatchManager:SetBattleRoomAgree(msg)
        if self.BattleRooms[msg.battleid] then
            self.BattleRooms[msg.battleid].agree = self.BattleRooms[msg.battleid].agree + 1
        end
end
---@param msg SC_RetJoinBattle
function ChallengeMatchManager:SetBattleRoomPool(msg)
     if self.BattleRooms[msg.records[1].battleid] then
         self.BattleRooms[msg.records[1].battleid].diamondPool = self.BattleRooms[msg.records[1].battleid].diamondPool + msg.addcoin
     end
end

function ChallengeMatchManager:GetBattleRoomData()
    local allData = {}
    for i, v in pairs(self.BattleRooms) do
        table.insert(allData, v)
    end
    return allData
end

function ChallengeMatchManager:GetBattleRoomDataLen()
    local len = 0
    for _, v in pairs(self.BattleRooms) do
        if v ~= nil then
            len = len + 1
        end
    end
    return len
end

function ChallengeMatchManager:InitRecordsData(msg)
    self.RecordsData = {}

    for i, v in pairs(msg) do
        local recordRoomData = RecordRoomData()
        recordRoomData:InitData(v)
        self.RecordsData[recordRoomData:GetID()] = recordRoomData
        if self.BattleRooms[recordRoomData:GetID()] then
            self.BattleRooms[recordRoomData:GetID()]:SetJoin(true)
        end
   end
end
---@param msg  SC_BattleRecord
function ChallengeMatchManager:AddRecordsData(msg)
    local recordRoomData = RecordRoomData()
    recordRoomData:InitData(msg)
    self.RecordsData[msg.battleid] = recordRoomData
    if self.BattleRooms[msg.battleid] then
        self.BattleRooms[msg.battleid]:SetJoin(true)
    end
end

function ChallengeMatchManager:SetRecordsAgree(msg)
    for i, v in pairs(self.RecordsData) do
        if v:GetID() == msg.battleid then
            self.RecordsData[v:GetID()].agree = 1
        end
    end
end

---@type RecordRoomData
function ChallengeMatchManager:GetRecordsData()
    local allData = {}
    for i, v in pairs(self.RecordsData) do
        table.insert(allData, v)
    end
    return allData
end

function ChallengeMatchManager:GetRecordsDataLen()
    local len = 0
    for _, v in pairs(self.RecordsData) do
        if v ~= nil then
            len = len + 1
        end
    end
    return len
end

function ChallengeMatchManager:GetRecordsAgreeStateByID(ID)
    for i, v in pairs(self.RecordsData) do
        if v.agree == 1 and v.battleID == ID then
            return true
        end
    end

    return false
end

function ChallengeMatchManager:GetRecordsNewStateByID(ID)
    for i, v in pairs(self.RecordsData) do
        if v.battleID == ID then
            return false
        end
    end

    return true
end

function ChallengeMatchManager:GetRecordsDataByID(ID)
    for i, v in pairs(self.RecordsData) do
        if v.battleID == ID then
            return v
        end
    end

    return nil
end

function ChallengeMatchManager:GetRecordsData()
    local allData = {}
    for i, v in pairs(self.RecordsData) do
        table.insert(allData, v)
    end
    return allData
end

function ChallengeMatchManager:SetFightNum(msg)
    self.fightNum = msg.fightnum
end

function ChallengeMatchManager:GetFightNum()
    return self.fightNum
end
function ChallengeMatchManager:SetCurRoom(msg)
    self.CurRoom = msg
end
---@return SC_RetBattle
function ChallengeMatchManager:GetCurRoom()
    return self.CurRoom
end
function ChallengeMatchManager:SetMaxFightNum(msg)
    self.maxFightNum = msg.maxfightnum
end

function ChallengeMatchManager:GetMaxFightNum()
    return self.maxFightNum
end

---@type SC_RetBeginBattle
function ChallengeMatchManager:SetRetJoinBattleData(msg)
    self.RetJoinBattleData = msg
end

function ChallengeMatchManager:GetRetJoinBattleData()
    return self.RetJoinBattleData
end

function ChallengeMatchManager:GetRetJoinBattleState()
    if self.RetJoinBattleData ~= nil then
        for i, v in pairs(self.BattleRooms) do
            if v.createID == self.RetJoinBattleData.battleid and v.resultTime < CommonHelper:GetNowTime() then
                return true
            end
        end
    end
    return false
end

function ChallengeMatchManager:InitRoomCDData(msg)
    self.RoomTimeIds = {}
    if msg.resulttime > 0 then
        self:AddItemCDData(msg)
    end
end

function ChallengeMatchManager:AddItemCDData(msg)
    local itemCDData = RoomCDData()
    itemCDData:InitTimeData(msg)

    table.insert(self.RoomTimeIds, itemCDData)
end

function ChallengeMatchManager:SortData()
    local _Data = self:GetBattleRoomData()
    table.sort(_Data, function(a, b)
        if  a.IsSystem > b.IsSystem then
            return true
        end
        if  a.IsSystem < b.IsSystem then
            return false
        end
        if  a.IsSelf > b.IsSelf then
            return true
        end
        if  a.IsSelf < b.IsSelf then
            return false
        end
        if  a.IsJoin > b.IsJoin then
            return true
        end
        if  a.IsJoin < b.IsJoin then
            return false
        end
        if a.agree > b.agree then
            return true
        end
        if a.agree < b.agree then
            return false
        end
        return a.resultTime > b.resultTime
    end)
    return _Data
end

---@class MatchRoomData
MatchRoomData = class("MatchRoomData")

function MatchRoomData:initialize()
    self.awardID = ""
    self.createID = 0
    self.createTime = ""
    self.diamondPool = 0
    self.guildName = ""
    self.overtime = ""
    self.resultTime = 0
    self.roleName = ""
    self.sceneID = ""
    self.rank3 = nil
    self.firstRacer = nil
    self.agree = 0
    self.IsJoin=0
end

---@param msg SC_BattleInfo
function MatchRoomData:InitData(msg)
    self.awardID = msg.awardid
    self.createID = msg.createrid
    self.createTime = msg.createtime
    self.diamondPool = msg.diamondpool
    self.guildName = msg.guildname
    self.overtime = msg.overtime
    self.resultTime = tonumber(msg.resulttime)
    self.roleName = msg.rolename
    self.sceneID = msg.scenceid
    self.rank3 = msg.rank3list
    self.firstRacer = msg.firstracer
    self.agree = msg.agree
    self.IsSystem= msg.trackid~=0 and 1 or 0
    self.IsSelf=msg.createrid==PlayerDataManager:Get():GetPlayerRID() and 1 or 0

end

function MatchRoomData:GetID()
    return self.createID
end
function MatchRoomData:SetJoin(value)
    self.IsJoin=value and 1 or 0
end

---@class RecordRoomData
RecordRoomData = class("RecordRoomData")

function RecordRoomData:initialize()
    self.battleID = 0
    self.curNum = 0
    self.maxNum = 0
    self.agree = 0
end

---@type SC_BattleRecord
function RecordRoomData:InitData(msg)
    self.battleID = msg.battleid
    self.curNum = msg.curnum
    self.maxNum = msg.maxnum
    self.agree = msg.agree
end

function RecordRoomData:GetID()
    return self.battleID
end

function ChallengeMatchManager:ClearData()
    self.fightNum = 0
    self.maxFightNum = 0
    self.BattleRooms = {}
    self.RecordsData = {}
    self.RetJoinBattleData = {}
end

return ChallengeMatchManager()