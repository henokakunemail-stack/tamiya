---@class StrengthActivityManager
StrengthActivityManager = class("StrengthActivityManager")
function StrengthActivityManager:initialize()
    ---@type StrengthActivityData[]
    self.CurActivityDataList ={}
    ---@type StrengthActivityData
    self.CurActivityData =nil
    ---@type ShopData
    self.CurShopData =nil
    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end

function StrengthActivityManager:Get()
    if self._instance == nil then
        self._instance = StrengthActivityManager()
    end
    return self._instance
end
---@param capyActs table<number,SC_UserActive>
function StrengthActivityManager:SetCurActivityData(capyActs)
    if(#capyActs == 0) then
        return
    end
    for k, v in pairs(capyActs) do
        if v and v.endtime then
            table.insert(self.CurActivityDataList,StrengthActivityData(v))
        end
    end
    table.sort(self.CurActivityDataList,function(a, b)
        return a.ActType<b.ActType
    end)
end
--检测按钮是否显示
function StrengthActivityManager:CheckBtnIsShow(type)
    local canShow = false
    for i, v in pairs(self.CurActivityDataList) do
        if type==v.ActType and (CommonHelper:GetNowTime()>v.BTime and CommonHelper:GetNowTime()<v.ETime) then
            canShow=true
            break
        end
    end
    return canShow
end
---@type StrengthActivityData
function StrengthActivityManager:GetFirstAct()
    for i, v in pairs(self.CurActivityDataList) do
        if (CommonHelper:GetNowTime()>v.BTime and CommonHelper:GetNowTime()<v.ETime) then
            return v
        end
    end
end
local _OpenType=nil
function StrengthActivityManager:OpenActivity(type,subType)
    _OpenType=type
    for i, v in pairs(self.CurActivityDataList) do
        if type==v.ActType and (CommonHelper:GetNowTime()>v.BTime and CommonHelper:GetNowTime()<v.ETime) then
            v:Open(subType)
            break
        end
    end
end




---@param msg SC_ShopInfo
function StrengthActivityManager:SetStrengthShopData(msg)
    self.CurActivityData =self:GetActivityDataByType(CapyActivityType.Strength)
    self.CurShopData=ShopData()
    self.CurShopData:SetData(msg)
    self.CurActivityType=CapyActivityType.Strength
    self.CurActivitySubType=StrengthActivityType.Shop

end
---@param data SC_UserActiveInfo
function StrengthActivityManager:SetActivityRechargeInfo(data)
    for k, v in pairs(data.ua) do
        if v.acttype==_OpenType then
            self.CurActivityData = StrengthActivityData(v)
            break
        end
    end
    self.CurActivityType=self.CurActivityData.ActType
    if self.CurActivityType==CapyActivityType.Strength then
        self.CurActivitySubType=StrengthActivityType.Gift
    else
        self.CurActivitySubType=StrengthActivityType.None
    end
end

---@return StrengthActivityData[]
function StrengthActivityManager:GetOpenActivityList()
    local result={}
    for i, v in pairs(self.CurActivityDataList) do
        if (CommonHelper:GetNowTime()>v.BTime and CommonHelper:GetNowTime()<v.ETime) then
            table.insert(result,v)
        end
    end
    return result
end
---@type StrengthActivityData
function StrengthActivityManager:GetActivityDataByType(type)
    for i, v in pairs(self.CurActivityDataList) do
        if type==v.ActType then
            return v
        end
    end
    return nil
end
---@param msg SC_buyShop
function StrengthActivityManager:UpdateShopGood(msg)
    if  self.CurShopData==nil or self.CurShopData.goods == nil or msg.shopid~=self.CurShopData.ShopId then
        print("---   error:数据异常，没有商店数据，id = ", msg.shopId)
        return
    end
    if msg.curItem==nil then return end
    for i = 1, #self.CurShopData.goods do
        if self.CurShopData.goods[i].grid == msg.curItem.grid then
            self.CurShopData.goods[i]:UpdateBuyNum(msg.curItem.curnum)
            break
        end
    end
end



function StrengthActivityManager:RefreshStrengthActivityData(data)
    self.CurActivityData:Update(data)
    UINotify:Get():SendNotification(UINotifyEvent.StrengthSprint_RefreshData)
end
---@param SC_UserActiveInfo
function StrengthActivityManager:UpdateRecruitRewardData(data)
    for k, v in pairs(data.ua) do
        if v.acttype==self.CurActivityData.ActType then
            self.CurActivityData:Update(v)
        end
    end

end

function StrengthActivityManager:ClearData()
    self.CurActivityDataList={}
end