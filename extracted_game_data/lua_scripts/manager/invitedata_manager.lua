---@class InviteDataManager
InviteDataManager = class("InviteDataManager")

function InviteDataManager:initialize()
    self.RaceRoomInviteMsg = {}--房间赛邀请队列

    self.ClubJoinInviteMsg = {}--俱乐部加入邀请队列

    self.isInRecruit = false

    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

function InviteDataManager:Get()
    if self._instance == nil then
        self._instance = InviteDataManager()
    end
    return self._instance
end

function InviteDataManager:SetIsInRecruit(isInRecruit)
    self.isInRecruit = isInRecruit
end

function InviteDataManager:GetIsInRecruit()
    return self.isInRecruit
end


----当前情况是否可以弹出邀请界面
function InviteDataManager:GetIsCanPop()
    local isCanPop = false
    local IsViewShow = not UIManager:Get():IsViewShow("RaceRankRoomView") and not UIManager:Get():IsPersistentViewShow("RaceRankJoinView")
    local IsOther = not BattleDataManager:Get():IsFighting() and not RaceRoomManager:Get():IsInRoom()
    isCanPop = not self.isInRecruit and IsViewShow and IsOther
    return isCanPop
end

---@param msg ChatData
---@param chatInviteType ChatInviteType
function InviteDataManager:AddInviteMsgByType(msg, chatInviteType)
    if chatInviteType == ChatInviteType.RaceRoom then
        table.insert(self.RaceRoomInviteMsg, msg)
    elseif chatInviteType == ChatInviteType.ClubJoin then
        table.insert(self.ClubJoinInviteMsg, msg)
    end
end

---@param chatInviteType ChatInviteType
function InviteDataManager:GetInviteMsgByType(chatInviteType)
    if chatInviteType == ChatInviteType.RaceRoom then
        return self.RaceRoomInviteMsg
    elseif chatInviteType == ChatInviteType.ClubJoin then
        return self.ClubJoinInviteMsg
    end
    return {}
end

---@return ChatData
---@param chatInviteType ChatInviteType
function InviteDataManager:GetInviteMsgByIdxType(chatInviteType, index)

    local msgTab = self:GetInviteMsgByType(chatInviteType)

    index = index or #msgTab

    if msgTab[index] ~= nil then
        return msgTab[index]
    else
        logError("没有该索引的邀请")
    end

end

---@param chatInviteType ChatInviteType
function InviteDataManager:RemoveInviteMsgByIdxType(chatInviteType, index)
    local msgTab = self:GetInviteMsgByType(chatInviteType)

    index = index or #msgTab

    if index > 0 then
        table.remove(msgTab, index)
    end
end

function InviteDataManager:Clear()
    self.RaceRoomInviteMsg = {}

    self.ClubJoinInviteMsg = {}
end
