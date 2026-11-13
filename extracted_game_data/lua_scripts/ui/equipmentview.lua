



local __SelectTog = -1

---@class EquipmentView : ViewBase
EquipmentView = class("EquipmentView", ViewBase)

function EquipmentView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "EquipmentViewAction")

    ---@type table<number , table< number, ArticleCell>>
    self.BagList = {}

    ---@type table<string , table< number, ArticleCell>>
    self.ShowList = {}

    ---@type table<number , string>
    self.SortList = {}

    self.typeToggle = {}
end

function EquipmentView:Awake()
    print("---   KnapsackView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.gameObject, typeof(TitleScrollView))


    self.TogView = UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow", self.gameObject, typeof(InfinityScrollView))
end

function EquipmentView:OnOpen()
    LightGroupManager:Get():BuildLight()
    self:SetData()
end

function EquipmentView:OnClose()
    --LuaButtonManager:Get():ReleasePool(UIModuleID.Bag)
    CommonHelper:ReleasePool(UIModuleID.Equipment)
end
function EquipmentView:OnAutoClose()
    CommonHelper:ReleasePool(UIModuleID.Equipment)
end

function EquipmentView:ReOpen()
    LightGroupManager:Get():BuildLight()
end

function EquipmentView:SetData()

    self:SetTitle()

    self:SetToggleView()

    self:AutoSelectType()

end


function EquipmentView:SetTitle()
    local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
    local title = ClientDataManager:GetTemplateString(cfg.GetDataByType1(KnapsackType.Equipment))
    CommonHelper:SetText("TitleCompoentGreen/title1",self.gameObject, title)
end

function EquipmentView:SetShowList(type)
    self.ShowList = {}
    self.SortList = {}
    if type == -1 then return end

    local list = KnapsackDataManager:Get():GetEquipmentsByType(type)

    for i = 1, #list do
        local temp = list[i]:GetPartConfig()
        ---@type parttype_config
        local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
        local title = ClientDataManager:GetTemplateString(cfg.GetDataByType3(KnapsackType.Equipment, type, temp.type1))

        if self.ShowList[title] == nil then
            self.ShowList[title] = {}
        end
        table.insert(self.ShowList[title], list[i])

        local key = type * 1000 + temp.type1
        self.SortList[key] = title
    end

    self:SortShowList()
end

function EquipmentView:SortShowList()
    for k,v in pairs(self.ShowList) do

        table.sort(v,function (a, b)
            local cfgA = a:GetPartConfig()
            local cfgB = b:GetPartConfig()
            if a:GetCarId() > 0 and b:GetCarId() == 0 then
                return true
            end
            if b:GetCarId() > 0 and a:GetCarId() == 0 then
                return false
            end
            if cfgA.quality > cfgB.quality then
                return true
            end
            if cfgA.quality < cfgB.quality then
                return false
            end
            if a:GetPartStrongLv() > b:GetPartStrongLv() then
                return true
            end
            if a:GetPartStrongLv() < b:GetPartStrongLv() then
                return false
            end
            if cfgA.id > cfgB.id then
                return true
            end
            if cfgA.id < cfgB.id then
                return false
            end
            return false
        end)
    end
end

function EquipmentView:SetScrollView()
    local templist = {}
    for k,v in pairs(self.SortList) do
        table.insert(templist, k)
    end
    table.sort(templist)


    local data = {}
    for i = 1, #templist do
        local title = self.SortList[templist[i]]
        local list = self.ShowList[title]
        table.insert(data, title)
        table.insert(data, #list)
    end

    CommonHelper:InitTitleScrollView(self.ScrollView, data, 4,function(title, itemObj, dataIndex, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.EquipmentView_UpdateScrollView, {title, dataIndex, itemObj})
    end)

end

function EquipmentView:UpdateScrollView(title, dataIndex, itemObj)
    if dataIndex == -1 then
        CommonHelper:SetText("titlename",itemObj,title)
        return
    end

    local partdata = self.ShowList[title][dataIndex + 1]
    local partcfg = partdata:GetPartConfig()
    local param = Param_PartGroup()
    param.partId = partcfg.C_ID
    param.star = partdata:GetStar()
    param.moduleId = UIModuleID.Equipment
    param.quality =partdata:GetPartQuality()
    CommonHelper:SetPartGroup(itemObj, param)

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        --CommonHelper:ShowBagArticleInfo(hbtn.intData)
    end, partdata:GetCellID())

end

function EquipmentView:OnClickTog_Type(idx)

    __SelectTog = idx

    CommonHelper:RefreshCurItems(self.TogView)

    self:SetShowList(self.typeToggle[idx + 1])

    self:SetScrollView()
end

function EquipmentView:SetToggleView()
    ---@type parttype_config
    local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
    local list = cfg.GetListType2(KnapsackType.Equipment)

    self.typeToggle = {}
    for k,v in pairs(list) do
        table.insert(self.typeToggle, v)
    end

    CommonHelper:InitScroll_OneRow(self.TogView, #self.typeToggle, function (dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.EquipmentView_UpdateTog, {dataIndex, itemObj, scroll})
    end, nil ,true)
end

function EquipmentView:UpdateToggleView(dataIndex, itemObj, scroll)
    local data = self.typeToggle[dataIndex + 1]

    ---@type parttype_config
    local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
    local title = ClientDataManager:GetTemplateString(cfg.GetDataByType2(KnapsackType.Equipment, data))

    CommonHelper:SetText("typename", itemObj, title )

    local icon = CommonHelper:GetComponentSetImage("icon1", itemObj, cfg.GetBagIcon(KnapsackType.Equipment, data), UIModuleID.Equipment)
    CommonHelper:ImageSetNativeSize(icon)
    icon = CommonHelper:GetComponentSetImage("icon2", itemObj, cfg.GetBagIcon(KnapsackType.Equipment, data), UIModuleID.Equipment)
    CommonHelper:ImageSetNativeSize(icon)

    local tog = CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.EquipmentView_ClickTog, hbtn.intData)
    end, dataIndex)

    CommonHelper:SetToggleState(tog,dataIndex == __SelectTog)
end

function EquipmentView:AutoSelectType()
    self:OnClickTog_Type(0)
end



