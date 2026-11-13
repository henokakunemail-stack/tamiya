---@class PlayerLevelUpDataManager
PlayerLevelUpDataManager = class("PlayerLevelUpDataManager")

function PlayerLevelUpDataManager:initialize()
    self.isUpgrade = false--是否升级了

    self.msg = {
        oldLv = 0,
        oldExp = 0,
        oldExp = 0,
    }--这里面存的是升级之前的数据


    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

---@return PlayerLevelUpDataManager
function PlayerLevelUpDataManager:Get()
    if self._instance == nil then
        self._instance = PlayerLevelUpDataManager()
    end
    return self._instance
end

function PlayerLevelUpDataManager:SetIsUpgrade(isUpgrade)
    self.isUpgrade = isUpgrade
end
function PlayerLevelUpDataManager:GetIsUpgrade()
    return self.isUpgrade
end

function PlayerLevelUpDataManager:SetOldData(oldLv, oldExp, oldStamina)
    self.msg.oldLv = oldLv
    self.msg.oldExp = oldExp
    self.msg.oldStamina = oldStamina
end

function PlayerLevelUpDataManager:GetOldData()
    return self.msg
end

function PlayerLevelUpDataManager:Clear()
    self.msg = {}
end



