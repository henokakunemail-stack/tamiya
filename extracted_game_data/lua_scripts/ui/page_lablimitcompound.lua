---@class Page_LabLimitCompound:Page_LabViewBase
Page_LabLimitCompound = class("Page_LabLimitCompound", Page_LabViewBase)
local _SelectType = -1
function Page_LabLimitCompound:Awake()
    Page_LabViewBase:Awake()
    self.PartsScrollView = self:GetChildWight("LeftCompoundSVC", typeof(MoreRowScrollView))
    self.CostPartScrollView = self:GetChildWight("CenterPartSVC", typeof(MoreRowScrollView))
    self.CostArticleScrollView = self:GetChildWight("CenterPropSVC", typeof(MoreRowScrollView))
    self.TypeScroll = self:GetChildWight("TypeScroll", typeof(MoreRowScrollView))
    self.PartAttrView = self:GetChild("RightShow")
    self.PartInfoView = self:GetChild("DownShow")
    self.CenterLockObj = UIUtil.GetChild("CenterLock", self.gameObject)
    CommonHelper:HButtonSetCallback("BtnComLock", self.CenterLockObj.gameObject, function(data)
        LabSubsystem:Get():SendMsg_ReqUnlockPic(self.CurCompoundPart.ComposeId)
    end)
    CommonHelper:HButtonSetCallback("BtnCompound", self.gameObject, function(data)
        local labDataMgr = LabDataManager:Get()
        local partData = labDataMgr:GetLimitCostPartData()
        if not partData then
            return
        end
        for _, v in ipairs(partData) do
            if v[3] == 0 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LabMainLimitNotAll))
                return
            end
        end
        local indices = {}
        for _, v in ipairs(partData) do
            indices[#indices + 1] = tostring(v[3])
        end
        local partStr = table.concat(indices, ":")
        local playerDataMgr = PlayerDataManager:Get()
        if not playerDataMgr:CheckCurrencyEnough(CurrencyType.Gold, self.CurCompoundPart.composegold) then
            return
        end
        for _, costItem in ipairs(self.CurCompoundPart.CostArticle) do
            if not playerDataMgr:CheckCurrencyEnough(costItem.id, costItem.num) then
                return
            end
        end
        local toggleType = labDataMgr:GetLabToggleType()
        if toggleType == LabToggleType.LimitCompose then
            LabSubsystem:Get():SendMsg_ReqComposeSpecial(self.CurCompoundPart.ComposeId, partStr)
        elseif toggleType == LabToggleType.GTCompose then
            LabSubsystem:Get():SendMsg_ReqComposeNew(self.CurCompoundPart.ComposeId, partStr)
        end
    end)
end
function Page_LabLimitCompound:OnOpen()
    local tagTable = LabDataManager:Get():GetComposeTypes()
    self:SetPartTypeScrollView(self.TypeScroll, tagTable, true, true, function(type)
        _SelectType = type
        ---@type LabComposeData[]
        self.CurPartList = LabDataManager:Get():GetComposeListByType(_SelectType)
        ---@type LabComposeData
        self.CurCompoundPart = self.CurPartList[1]
        self:SetCurPartData()
        self:SetPartList(_SelectType)
    end)
end
function Page_LabLimitCompound:SetPartList()
    CommonHelper:InitMoreRowScrollView(self.PartsScrollView, #self.CurPartList, 1, function(index, itemObj, scroll)
        ---@type LabComposeData
        local data = self.CurPartList[index + 1]
        CommonHelper:SetText("###compart", itemObj, CommonHelper:GetTempStr_Default(data.PartCfg.partname))
        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(hBtn)
            if self.CurPartList[hBtn.intData + 1].ComposeId ~= self.CurCompoundPart.ComposeId then
                self.CurCompoundPart = self.CurPartList[hBtn.intData + 1]
                self:SetCurPartData()
                CommonHelper:MoreRowView_RefreshCurList(self.PartsScrollView, false)
            end
        end, index)
        CommonHelper:SetGameObjectActive("lightbg", itemObj, data.ComposeId == self.CurCompoundPart.ComposeId)
        CommonHelper:SetTextColorByName("###compart", itemObj, data.ComposeId == self.CurCompoundPart.ComposeId and "FFFFFF" or "826F6F")
    end)
end
function Page_LabLimitCompound:SetCurPartData()
    LabDataManager:Get():InitLimitCostPartDataByID(self.CurCompoundPart.ComposeId)
    self:SetLockInfo()
    self:SetCostArticle()
    self:SetCostPart()
    self:SetArticleViewById(self.PartAttrView, self.CurCompoundPart.TargetId)
    self:SetArticleInfoViewByLabComposeData(self.PartInfoView, self.CurCompoundPart)
end
function Page_LabLimitCompound:SetLockInfo()
    CommonHelper:SetGameObjectActive("CenterLock", self.gameObject, self.CurCompoundPart.UnlockFlag)
    CommonHelper:SetGameObjectActive("downroot", self.gameObject,not self.CurCompoundPart.UnlockFlag)
    CommonHelper:SetGameObjectActive("TitleScrollView", self.gameObject,not self.CurCompoundPart.UnlockFlag)
    if self.CurCompoundPart.UnlockFlag then
        if self.CurCompoundPart.UnlockPic == 0 then
            CommonHelper:SetText("###lockText", self.CenterLockObj.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.LabMainNotLimitCom))
            CommonHelper:SetGameObjectActive("ItemCom_lock", self.gameObject, false)
            CommonHelper:SetGameObjectActive("###lockHaveNum", self.gameObject, false)
        else
            local haveNum = PlayerDataManager:Get():GetCurrency(self.CurCompoundPart.UnlockPic)
            CommonHelper:SetText("###lockHaveNum", self.CenterLockObj.gameObject, string.format("(%d/%d)", haveNum, 1))
            CommonHelper:SetText("###lockText", self.CenterLockObj.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.LabMainLockLimitCom))
            local item = UIUtil.GetChild("ItemCom_lock", self.CenterLockObj)
            local param = Param_ItemArticleParam()
            CommonHelper:SetItemComGroup(item, UIModuleID.Lab, self.CurCompoundPart.UnlockPic, param)
            CommonHelper:SetGameObjectActive("ItemCom_lock", self.gameObject, true)
            CommonHelper:SetGameObjectActive("###lockHaveNum", self.gameObject, true)
        end
    end

end
function Page_LabLimitCompound:SetCostArticle()
    CommonHelper:InitMoreRowScrollView(self.CostArticleScrollView, #self.CurCompoundPart.CostArticle, 4, function(index, itemObj, scroll)
        local temp = self.CurCompoundPart.CostArticle[index + 1]
        local item = UIUtil.GetChild("ItemCom_118", itemObj)
        local param = Param_ItemArticleParam()
        CommonHelper:SetItemComGroup(item, self:GetUIModuleID(), temp.id, param, function(btnData)
            CommonHelper:ShowPartInfoByCfgId(btnData, self:GetUIModuleID(), true)
        end, temp.id)
        local haveNum = PlayerDataManager:Get():GetCurrency(temp.id)
        CommonHelper:SetText("###haveCount", itemObj, string.format("%d/%d", haveNum, temp.num))
    end)
end
local _PartData = {}
function Page_LabLimitCompound:SetCostPart()
    _PartData = LabDataManager:Get():GetLimitCostPartData()
    CommonHelper:InitMoreRowScrollView(self.CostPartScrollView, #_PartData, 1, function(index, itemObj, scroll)
        local PartTab = _PartData[index + 1]
        if PartTab[3] == 0 then
            local item = UIUtil.GetChild("ItemPart_138", itemObj)
            local param = Param_ItemPartParam()
            CommonHelper:SetItemPartGroup(item, self:GetUIModuleID(), tonumber(PartTab[2]), ItemPartUIType.Normal, param)
        else
            local data = KnapsackDataManager:Get():GetArticleByCellID(PartTab[3])
            local item = UIUtil.GetChild("ItemPart_138", itemObj)
            local param = Param_ItemPartParam()
            param.star = data:GetStar()
            param.lv = data:GetPartLV()
            param.using = data:GetCarId()
            param.lock = data:GetPartLock()
            param.awaken = data:GetAwaken()
            param.generation = data:GetGeneration()
            param.downType = data:GetPartDownType()
            param.source = data:GetPartSource()
            param.expireTime = data:GetPartExpTime()
            CommonHelper:SetItemPartGroup(item, self:GetUIModuleID(), data:GetID(), ItemPartUIType.Normal, param)
        end

        local textData = CommonHelper:GetTableDataByID(ConfigNames.parts_config, tonumber(PartTab[2]))
        CommonHelper:SetText("###ItemText", itemObj, CommonHelper:GetTempStr_Default(textData.partname))

        CommonHelper:SetGameObjectActive("BtnChoose/Bg", itemObj, PartTab[3] == 0)
        CommonHelper:HButtonSetCallback("BtnChoose", itemObj, function(btnData)
            local filterTable = {}
            local _PartData = LabDataManager:Get():GetLimitCostPartData()
            for i = 1, #_PartData do
                if btnData.intData ~= i then
                    table.insert(filterTable, KnapsackDataManager:Get():GetArticleByCellID(_PartData[i][3]))
                end
            end
            ---@type ArticleCell[]
            local data = KnapsackDataManager:Get():GetPartNoChangeListByCfgid(PartTab[2], filterTable)
            if #data > 0 then
                UIManager:OpenPopup("LabChoosePropView", CanvasType.MainCanvas, "LabChoosePropView", true)
                UINotify:Get():SendNotification(UINotifyEvent.LabChooseProp_SetData, { data, function(id)
                    LabDataManager:Get():SetLimitCostPartDataByID(btnData.intData, id)
                    CommonHelper:MoreRowView_RefreshCurList(self.CostPartScrollView, false)
                end })
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LabMainLimitNotChoose))
            end
        end, index + 1)

    end, true)
end

function Page_LabLimitCompound:OnClose()

end
function Page_LabLimitCompound:SendOpen()
    if LabDataManager:Get():GetLabToggleType() == LabToggleType.LimitCompose then
        LabSubsystem:Get():SendMsg_ReqSpecialPart()
    end
    if LabDataManager:Get():GetLabToggleType() == LabToggleType.GTCompose then
        LabDataManager:Get():InitGTComData()
    end
end
function Page_LabLimitCompound:Refresh()
    self:SetCurPartData()
end