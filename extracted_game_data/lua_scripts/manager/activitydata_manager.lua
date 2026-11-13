---@class ActivityItemData
ActivityItemData = class("ActivityItemData")

function ActivityItemData:initialize()
    self. activityItemId = -1
    self. count = 0
    ---@type ActivityStatus
    self. status = ActivityStatus.NoFinish
    self. time = 0
end
---@param msg SC_PlayerActivityInfo
function ActivityItemData:InitData(msg)
    self. activityItemId = msg.activityItemId
    self. count = msg.count
    self. status = msg.status
    self.time = msg.time
end
function ActivityItemData:GetActivityItemID()
    return self.activityItemId
end
function ActivityItemData:GetActivityCount()
    return self.count
end
---@return ActivityStatus
function ActivityItemData:GetActivityStatus()
    return self.status
end

function ActivityItemData:GetActivityLeftTime()
    return self.times
end

---@class ActivityDataManager
ActivityDataManager = class("ActivityDataManager")
function ActivityDataManager:Get()
    if self._instance == nil then
        self._instance = ActivityDataManager()
    end
    return self._instance
end
function ActivityDataManager:initialize()
    self.mainMenuShowId = {}--主页显示的ID
    ---@type table<number,number>@value 是activityId
    self.activityTab = {}
    self.curSelectAvId = -1
    self.curOrderId = 0
    self.curProductId = 0
    ---@type table<ActivityType,table<number,number>>@第二个表里的key是索引，value是activityItemId
    self.activityItemTab = {}
    ---@type table<number,ActivityItemData>@第的key是activityItemId
    self.activityItemTabDic = {}

    self.isCanGetFirstPurchase = false--是否可以领取首充礼包
end

function ActivityDataManager:Init()
    self.activityTab = {}
    ---@type act_activity_config
    local act_activity_config = ClientDataManager:Get():GetDataTable(ConfigNames.act_activity_config)

    --self.ActivityList = act_activity_config.GetNewConfig()

    self.ActivityList = {}
    for i, v in pairs(act_activity_config.GetNewConfig()) do
        if HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.GrowFund) == false and v.C_ID == 50 then
        elseif HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.GrowFund2) == false and v.C_ID == 51 then
        else
            table.insert(self.ActivityList, v)
        end
    end
    table.sort(self.ActivityList,function(a, b)
        return a.sort<b.sort
    end)

end

function ActivityDataManager:GetActivityList()
    return self.ActivityList
end

function ActivityDataManager:GetIsCanFirstPurchase()
    return self.isCanGetFirstPurchase
end
function ActivityDataManager:SetIsCanFirstPurchase(isCanGetFirstPurchase)
    self.isCanGetFirstPurchase = isCanGetFirstPurchase
end

function ActivityDataManager:SetMainMenuData(mainMenuShowId)
    self.mainMenuShowId = mainMenuShowId
end

---@param activityType ActivityType
function ActivityDataManager:GetMainMenuDataByType(activityType)
    local activityId = self:GetActivityIdByType(activityType)
    return self.mainMenuShowId[activityId]
end

function ActivityDataManager:GetActivityIdByType(activityType)
    ---@type activity_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.activity_config)
    return tab.GetIdByAvType(activityType)
end

function ActivityDataManager:GetActivityDataById(idx)
    for i, v in pairs(self.activityTab) do
        if v.C_ID == idx then
            return v
        end
    end
    return nil
end

function ActivityDataManager:GetActivityByIdx(idx)
    return self.activityTab[idx]
end

function ActivityDataManager:GetActivityCount()
    return #self.activityTab
end

function ActivityDataManager:GetActivityTab()
    return self.activityTab
end

function ActivityDataManager:SetCurSelectAvId(curSelectAvId)
    self.curSelectAvId = curSelectAvId
end

function ActivityDataManager:GetCurSelectAvId()
    return self.curSelectAvId
end

function ActivityDataManager:SetCurOrderInfo(productId, orderId, failedTime)
    self.curProductId = productId
    self.curOrderId = orderId
    self.FailedTime = failedTime
end

function ActivityDataManager:GetCurOrderInfo()
    return self.curProductId, self.curOrderId, self.FailedTime
end

---@param msg SC_PlayerActivityInfoRes
function ActivityDataManager:InitActivityItemData(activityId, msg)
    ---@type activity_config_cell
    local cell = CommonHelper:GetTableDataByID(ConfigNames.activity_config, activityId)
    if self.activityItemTab[cell.activityType] == nil or #self.activityItemTab[cell.activityType] <= 0 then
        self.activityItemTab[cell.activityType] = {}
    end

    for i = 1, #msg.playerActivityInfo do
        local activityItemData = ActivityItemData()
        activityItemData:InitData(msg.playerActivityInfo[i])
        if self:GetActivityItemDataById(activityItemData:GetActivityItemID()) == nil then
            table.insert(self.activityItemTab[cell.activityType], activityItemData:GetActivityItemID())
        end
        self.activityItemTabDic[activityItemData:GetActivityItemID()] = activityItemData
    end
end

---@param msg SC_PlayerActivityInfo
function ActivityDataManager:UpdateActivityItemDataById(activityItemId, msg)
    local activityItemData = self.activityItemTabDic[activityItemId]
    if activityItemData ~= nil then
        activityItemData:InitData(msg)
    end
end

---@param activityType ActivityType
---@return  ActivityItemData
function ActivityDataManager:GetActivityItemDataByIdx(activityType, idx)
    local activityItemId = self.activityItemTab[activityType][idx]
    return self.activityItemTabDic[activityItemId]
end

function ActivityDataManager:GetActivityItemDataById(activityItemId)
    return self.activityItemTabDic[activityItemId]
end

---@param activityType ActivityType
function ActivityDataManager:GetActivityItemCountByType(activityType)
    local activityItemIdTab = self.activityItemTab[activityType]
    if activityItemIdTab ~= nil then
        return #activityItemIdTab
    else
        return 0
    end
end

function ActivityDataManager:IsHaveFirstBuyRedPoint()
    return PlayerPrefsHelper:GetValue_FirstBuy() == 0 or self.isCanGetFirstPurchase == true
end

function ActivityDataManager:Clear()
    self.mainMenuShowId = {}
    self.activityTab = {}
    self.curSelectAvId = -1
    self.curOrderId = 0
    self.curProductId = 0
end




