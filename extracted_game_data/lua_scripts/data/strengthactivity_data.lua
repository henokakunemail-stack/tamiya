---@class StrengthActivityData
StrengthActivityData = class("StrengthActivityData")
---@param data SC_UserActive
function StrengthActivityData:initialize(data)
    self.ActType = data.acttype
    self.ActId = data.actid
    self.Score = data.score
    self.AwardId = data.awardid
    self.ETime = CommonHelper:ConvertIntToDataTime(data.endtime * 1000)
    self.BTime = CommonHelper:ConvertIntToDataTime(data.btime * 1000)
    self.OverTime = CommonHelper:ConvertIntToDataTime(data.endtime * 1000)

    ---@type dictsprintactivity_config_cell
    self.Cfg = CommonHelper:GetTableDataByID(ConfigNames.dictsprintactivity_config, self.ActType)
    if self.Cfg == nil then
        return
    end
    ---@type StrengthActivityGiftData[]
    self.GiftDataDic = {}
    ---@type StrengthActivityGiftData[]
    self.GiftDataList = {}
    if self.ActType == CapyActivityType.Strength then
        local gifts = CommonHelper:GetDictCalcData(CommonCfgKey.StrengthActivityGifts, true)
        local ids = stringSplitToNumber(gifts, ":")
        for i = 1, #ids do
            local temp = StrengthActivityGiftData(ids[i])
            self.GiftDataDic[ids[i]] = temp
            table.insert(self.GiftDataList, temp)
        end
    end
    ---@type StrengthActivityAwardData[]
    self.AwardDic = {}
    ---@type StrengthActivityAwardData[]
    self.AwardList = {}
    if self.ActType == CapyActivityType.Recruit then
        ---@type dictsprintaward_config
        local configData = ClientDataManager:Get():GetDataTable(ConfigNames.dictsprintaward_config)
        local awardList = configData.GetAwardListByActId(self.Cfg.sprintaward)
        for i = 1, #awardList do
            local temp = StrengthActivityAwardData(awardList[i], self.Score)
            self.AwardDic[temp.Cfg.C_ID] = temp
            table.insert(self.AwardList, temp)
        end
    end
    for k, v in pairs(data.myGift) do
        self.GiftDataDic[v.itemId]:Update(v)
    end
    self:UpdateAward(data.awards)
    if self.Cfg.acttips ~= "0" then
        self.Tabs = {}
        self.Tabs = stringSplit(self.Cfg.acttips, ':')
    end
end
function StrengthActivityData:UpdateAward(awards)
    for k, v in pairs(awards) do
        for m, n in pairs(self.AwardDic) do
            if n.Cfg.score == v then
                n:Update()
                break
            end
        end
    end
end
function StrengthActivityData:Open(subType)
    if self.ActType == CapyActivityType.Strength and subType == StrengthActivityType.Shop then
        ShopSubsystem:Get():SendMsg_ShopInfo(ShopID.StrengthSprint)
    else
        CapyActivitySubsystem:Get():SendMsg_CapyActivity(self.ActType)
    end
end
---@param data SC_ActGift
function StrengthActivityData:Update(data)
    if self.ActType == CapyActivityType.Strength then
        self.GiftDataDic[data.itemid].Count = data.buysum
    end
    if self.ActType == CapyActivityType.Recruit then
        self:UpdateAward(data.awards)
    end
end

---@class StrengthActivityGiftData
StrengthActivityGiftData = class("StrengthActivityGiftData")
---@param data SC_ActiveGift
function StrengthActivityGiftData:initialize(id)
    self.GiftId = id
    ---@type act_gift_config_cell
    self.Cfg = CommonHelper:GetTableDataByID(ConfigNames.act_gift_config, id)
    ---@type dictcharge_config_cell
    self.ChargeCfg = CommonHelper:GetChargeCfgByAreaAndItemId(id)
    self.Count = 0
end
function StrengthActivityGiftData:Update(data)
    self.ActId = data.actid
    self.Count = data.buyNum
end
---@class StrengthActivityAwardData
StrengthActivityAwardData = class("StrengthActivityAwardData")
---@param data SC_ActiveGift
function StrengthActivityAwardData:initialize(cfg, score)
    ---@type dictsprintaward_config_cell
    self.Cfg = cfg
    self.State = score >= self.Cfg.score and StrengthActivityAwardState.CanReceive or StrengthActivityAwardState.CanNotReceive
end
function StrengthActivityAwardData:Update()
    self.State = StrengthActivityAwardState.ReceiveCompleted
end