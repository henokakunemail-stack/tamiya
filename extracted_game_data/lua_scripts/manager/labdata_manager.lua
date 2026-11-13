---@class LabComposeData
LabComposeData = class("LabComposeData")
function LabComposeData:initialize(type,composeId, targetId,costArticle, costPart, costCurrency, addExp,breakrand,unlockflag,unlockpic)
    self.ComposeType = type
    self.TargetId = targetId
    self.ComposeId = composeId
    self.PropType, self.Cfg = CommonHelper:GetPropTypeById(targetId)
    if self.PropType == PropType.Article then
        self.ArticleCfg = self.Cfg
    end
    if self.PropType == PropType.Part then
        self.PartCfg = self.Cfg
        self.PartBaseCfg = CommonHelper:GetPartBaseCfg(targetId)
        self.PartAgeCfg = CommonHelper:GetPartAgeCfg(targetId,1)
    end
    ---@type RewardData[]
    self.CostArticle = costArticle
    self.CostPart = costPart
    ---@type RewardData
    self.CostCurrency = costCurrency
    self.AddExp = addExp
    self.BreakRand = breakrand
    self.UnlockFlag = unlockflag
    self.UnlockPic = unlockpic
end
---@class LabDataManager
LabDataManager = class("LabDataManager")

function LabDataManager:Get()
    if self._instance == nil then
        self._instance = LabDataManager()
    end
    return self._instance
end

function LabDataManager:initialize()
    self.CurPageType = LabToggleType.None
    ---@type LabComposeData
    self.ComPartData = {}
    ---@type number[]
    self.resolveSelectProp = {}--分解选择的cellID 索引表
    self.maxResolveLimit = 50
    CacheClearTrigger:Get():RegisterEvent(self, self.Clear)
end

function LabDataManager:InitComposeList(msg)
    self:SetCompositorData(msg)
    self:SetBuilderDataByLV(self.CompositorLv)
end
---@param msg SC_UserSpecialParts
function LabDataManager:InitLimitComData(msg)
    self:InitLimitCostData(msg)
end
function LabDataManager:InitGTComData()
    self:SetComposeNew()
    UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_OpenCurView)
end
function LabDataManager:SetComposeNew()
    ---@type dictcomposenew_config
    local cfg = ClientDataManager:Get():GetDataTable(ConfigNames.dictcomposenew_config)
    self.AllComposeCount = cfg.GetTableCount()
    self.curComposeType = type
    ---@type dictcomposenew_config_cell[]
    local list = cfg.GetComposeList(LabToggleType.GTCompose)
    ---@type LabComposeData[]
    self.ComPartData = {}
    for k, v in pairs(list) do
        local composePart=stringSplitToNumber(v.consumeparts,':')
        local temp= RewardData()
        temp:SetDataIdNum(CurrencyType.Gold, v.composegold)
       local temp= LabComposeData(LabToggleType.GTCompose, v.C_ID, v.propid,
                CommonHelper:SetDataByStrIdAndNum(v.consumeids, v.consumenums), composePart, temp, 0,0,false,0)
        table.insert(self.ComPartData, temp)
    end
end
---@param msg SC_UserSpecialParts
function LabDataManager:InitLimitCostData(msg)
    self.ComPartData = {}
    for i, v in pairs(msg) do
        ---@type dictspecial_config_cell
        local costData = CommonHelper:GetTableDataByID(ConfigNames.dictspecial_config, v.partId)
        local composePart=stringSplitToNumber(costData.consumeparts,':')
        local temp= RewardData()
        temp:SetDataIdNum(CurrencyType.Gold, costData.composegold)
        table.insert(self.ComPartData, LabComposeData(LabToggleType.LimitCompose, v.partId, v.partId,
                CommonHelper:SetDataByStrIdAndNum(costData.consumeids, costData.consumenums), composePart, temp, 0,costData.breakrand,v.unlockflag==0,costData.unlockpic))
    end
end

function LabDataManager:SetBuilderDataByLV(_LV)
    local builderLev = CommonHelper:GetTableDataByID(ConfigNames.dictbuilderlev_config, _LV)
    ---@type LabComposeData[]
    self.ComPartData = {}
    local BuilderData = stringSplitToNumber(builderLev.composeids, ':')
    for i, v in pairs(BuilderData) do
        ---@type dictcompose_config_cell
        local compose = CommonHelper:GetTableDataByID(ConfigNames.dictcompose_config, v)
        local temp= RewardData()
        temp:SetDataIdNum(CurrencyType.Gold, compose.composegold)
        table.insert(self.ComPartData, LabComposeData(LabToggleType.Compose, v, v,
                CommonHelper:SetDataByStrIdAndNum(compose.consumeids, compose.consumenums), nil,temp, compose.addexp,compose.breakrand))
    end
end
---@return LabComposeData[]
function LabDataManager:GetComposeListByType(C_type)
    local result = {}
    if C_type ~= -1 then
        for i, v in pairs(self.ComPartData) do
            if v.PartBaseCfg.parttype == C_type then
                table.insert(result, v)
            end
        end
    else
        for i, v in pairs(self.ComPartData) do
            table.insert(result, v)
        end
    end
    return result
end
function LabDataManager:InitLimitCostPartDataByID(ID)
    self.costPartData = {}
    local _parts = {}
    for i, v in pairs(self.ComPartData) do
        if v.ComposeId == ID then
            _parts = v.CostPart
        end
    end

    for i, v in pairs(_parts) do
        if v > 0 then
            table.insert(self.costPartData, { ID, v, 0, i })
        end
    end
    return self.costPartData
end

function LabDataManager:GetLimitCostPartData()
    return self.costPartData
end
function LabDataManager:InitLimitComDataByID(msg)
    for i, v in pairs(self.ComPartData) do
        if v.ComposeId == msg then
            v.UnlockFlag = false
        end
    end
end

function LabDataManager:GetComposeTypes()
    local result = {}
    local seen = {}  -- 用于去重的哈希集合
    table.insert(result, -1)
    for i, v in pairs(self.ComPartData) do
        local parttype = v.PartBaseCfg.parttype
        if not seen[parttype] then
            seen[parttype] = true
            table.insert(result, parttype)
        end
    end
    return result
end
function LabDataManager:GetComPartData()
    return self.ComPartData
end
---@return LabComposeData
function LabDataManager:GetComPartDataByID(ID)
    for i, v in pairs(self.ComPartData) do
        if v.ComposeId == ID then
            return v
        end
    end
end
function LabDataManager:SetCompositorData(msg)
    self.CompositorLv = msg.curbuilderLev
    self.CompositorExp = msg.curExp
    self.CompositorUpLvExp = msg.uplevExp
end

function LabDataManager:GetCompositorLv()
    return self.CompositorLv
end

function LabDataManager:GetCompositorExp()
    return self.CompositorExp
end

function LabDataManager:GetCompositorUpLvExp()
    return self.CompositorUpLvExp
end

---@param labExpType LabExpType
function LabDataManager:SetLabToggleType(curPageType)
    self.CurPageType = curPageType
end

---@return  LabExpType
function LabDataManager:GetLabToggleType()
    return self.CurPageType
end
function LabDataManager:GetMaxResolveLimit()
    return self.maxResolveLimit
end

function LabDataManager:SetLimitCostPartDataByID(index, chID)
    self.costPartData[index][3] = chID
end

function LabDataManager:SetResolveSelectProp(resolveSelectProp)
    self.resolveSelectProp = resolveSelectProp
end
---@return table<number,number> @分解选择的table<idx,cellId>
function LabDataManager:GetResolveSelectProp()
    return self.resolveSelectProp
end
--}}}
------------------------------------------------------------------------------------------------------
function LabDataManager:Clear()
    self.CurPageType = LabToggleType.None
    self.ComPartData = {}
end


