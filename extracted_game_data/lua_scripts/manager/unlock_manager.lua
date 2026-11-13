---@class UnlockDataManager
UnlockDataManager = class("UnlockDataManager")

---@return UnlockDataManager
function UnlockDataManager:Get()
    if self._instance == nil then
        self._instance = UnlockDataManager()
    end
    return self._instance
end

function UnlockDataManager:initialize()
    ---@type table<number,table<UnlockID,UnlockID>>@第一个number是等级，第二个表都是解锁的功能ID
    self.levelUpDic = {}--这个是配置表，每一个等级，解锁了多少个功能

    ---@type table<UnlockID,UnlockID>
    self.unlockIdDic = {}--这个是解锁的等级表，key和value都是功能ID

    ---@type table<UnlockID,number> 为了让其他玩家使用
    self.unlockIdToLevelDic = {}--key是解锁id和value解锁的等级

    ---@type table<UnlockID,function>
    self.funcEvent = {}--注册刷新UI的方法

    self.lastLv = nil--升级前的等级

    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

function UnlockDataManager:InitData()
    ---@type escalate_config
    local escalate =nil
    if ClientDataManager:Get().IsConfig2 then
        escalate=ClientDataManager:Get():GetDataTable(ConfigNames.escalate2_config)
    else
        escalate=ClientDataManager:Get():GetDataTable(ConfigNames.escalate_config)
    end


    escalate = escalate.GetConfigData()

    local playerLv = PlayerDataManager:Get():GetPlayerLV()
    ---@param cell escalate_config_cell
    for levelId, cell in pairs(escalate) do
        if cell.unlock ~= tostring(-1) then
            local strTable = stringSplit(cell.unlock, ',')
            local unlockTable = {}
            for i = 1, #strTable do
                local key = tonumber(strTable[i])
                unlockTable[key] = key

                if playerLv >= cell.C_ID then
                    self:AddUnlockId(key)
                end
                self.unlockIdToLevelDic[key]=cell.C_ID
            end
            self.levelUpDic[cell.C_ID] = unlockTable
        end
    end

    self.lastLv = playerLv
end

----把已经解锁的功能添加进来
function UnlockDataManager:AddUnlockId(id)
    self.unlockIdDic[id] = id
end

---获得配置表中该等级下可以解锁的功能
function UnlockDataManager:GetUnlockByLevelID(levelId)
    return self.levelUpDic[levelId]
end

---获得将要解锁的功能
function UnlockDataManager:GetNextUnlockByLevelID(currentLv)
    local lvT = {}
    for lv, unlockTable in pairs(self.levelUpDic) do
        table.insert(lvT, lv)
    end
    table.sort(lvT)

    for idx, lv in pairs(lvT) do
        if lv > currentLv then
            return lv, self.levelUpDic[lv]
        end
    end

    return nil
end

---@param unlockID UnlockID
function UnlockDataManager:RegisterInitEvent(func)
    table.insert(self.funcEvent, func)
end

function UnlockDataManager:UpdateLockUIData()
    for i = 1, #self.funcEvent do
        if self.funcEvent[i] then
            self.funcEvent[i]()
        end
    end
end

---是否解锁了,true 代表解锁了 false 代表没解锁
---@param funcId UnlockID
function UnlockDataManager:IsUnLock(funcId,level)
    return self.unlockIdDic[funcId] ~= nil
end

---是否解锁了,true 代表解锁了 false 代表没解锁
---@param funcId UnlockID
---@param level number
function UnlockDataManager:IsUnLockByLevel(funcId, level)
    local unlocklevel = self.unlockIdToLevelDic[funcId]
    return level < unlocklevel
end

function UnlockDataManager:UpdateLockData()
    local curLv = PlayerDataManager:Get():GetPlayerLV()
    if self.lastLv ~= nil and self.lastLv <= curLv then
        for i = self.lastLv + 1, curLv do
            local unlockTable = self:GetUnlockByLevelID(i)--这是解锁的表

            if unlockTable ~= nil then
                for funcIdKey, funcIdKeyValue in pairs(unlockTable) do
                    UnlockDataManager:Get():AddUnlockId(funcIdKeyValue)
                end
            end
        end
        self.lastLv = curLv
    else
        print("---------当前解锁有问题---------")
    end
end

function UnlockDataManager:Clear()
    self.unlockIdDic = {}
    self.levelUpDic = {}
    self.lastLv = nil
end




