
local __SelectTog = -1

---@class KnapsackView : ViewBase
KnapsackView = class("KnapsackView", ViewBase)

function KnapsackView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "KnapsackViewAction")

    print("---   KnapsackView 初始化完成")

    self.BagType = 0

    ---@type table<number , table< number, ArticleCell>>
    self.BagList = {}

    ---@type table<string , table< number, ArticleCell>>
    self.ShowList = {}

    ---@type table<number , string>
    self.SortList = {}

    self.typeToggle = {}
end

function KnapsackView:Awake()
    print("---   KnapsackView awake")

    CommonHelper:HButtonSetCallback("BtnBack",self.gameObject,function (hbtn)
        UIManager:Get():CloseView()
    end)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("TitleScrollView", self.gameObject, typeof(TitleScrollView))




    self.TogView = UIUtil.GetTypeChildWightByParent("ScrollHorizontalOneRow", self.gameObject, typeof(InfinityScrollView))
end

function KnapsackView:OnOpen()

end

function KnapsackView:OnClose()
    --LuaButtonManager:Get():ReleasePool(UIModuleID.Bag)
    CommonHelper:ReleasePool(UIModuleID.Bag)
end
function KnapsackView:OnAutoClose()
    CommonHelper:ReleasePool(UIModuleID.Bag)
end

function KnapsackView:SetData(type)
    self.BagType = type

    self:SetBagList()

    self:SetTitle()

    self:SetToggleView()

    self:AutoSelectType()

end

function KnapsackView:SetTitle()
    local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
    local title = ClientDataManager:GetTemplateString(cfg.GetDataByType1(self.BagType))
    CommonHelper:SetText("TitleCompoentGreen/title1",self.gameObject, title)
end


function KnapsackView:SetBagList()
    self.BagList = {}
    local list = KnapsackDataManager:Get():GetArticleListByType(self.BagType)
    for i = 1, #list do
        local temp = list[i]:GetArticleConfig()
        if self.BagList[temp.school] == nil then
            self.BagList[temp.school] = {}
        end

        table.insert(self.BagList[temp.school], list[i])

        --print("----------  ",temp.school, list[i])
    end

end

function KnapsackView:SetShowList(type)
    self.ShowList = {}
    self.SortList = {}
    if type == -1 then return end

    local list = self.BagList[type]
    if list == nil then return end

    for i = 1, #list do
        --print("000  ",type,list[i])
        local temp = list[i]:GetArticleConfig()
        ---@type parttype_config
        local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
        local title = ClientDataManager:GetTemplateString(cfg.GetDataByType3(self.BagType, type, temp.floor))

        if self.ShowList[title] == nil then
            self.ShowList[title] = {}
        end
        table.insert(self.ShowList[title], list[i])

        local key = type * 1000 + temp.floor
        self.SortList[key] = title
    end

    self:SortShowList()
end

function KnapsackView:SortShowList()
    for k,v in pairs(self.ShowList) do

        table.sort(v,function (a, b)
            local cfgA = a:GetArticleConfig()
            local cfgB = b:GetArticleConfig()
            if cfgA.quality > cfgB.quality then
                return true
            end
            if cfgA.quality < cfgB.quality then
                return false
            end
            if cfgA.id > cfgB.id then
                return true
            end
            if cfgA.id < cfgB.id then
                return false
            end
            if a:GetCount() > b:GetCount() then
                return true
            end
            if a:GetCount() < b:GetCount() then
                return false
            end
            return false
        end)
    end
end



function KnapsackView:SetScrollView()

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
        UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_UpdateScrollView, {title, dataIndex, itemObj})
    end)

end

function KnapsackView:UpdateScrollView(title, dataIndex, itemObj)
    if dataIndex == -1 then
        CommonHelper:SetText("titlename",itemObj,title)
        return
    end

    local data = self.ShowList[title][dataIndex + 1]
    if data == nil then return end

    local param = Param_ArticleGroup()
    param.articleId = data:GetArticleID()
    param.moduleId = UIModuleID.Bag
    param.count = tostring(data:GetCount())
    CommonHelper:SetArticleGroup(itemObj, param)

    CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        --CommonHelper:ShowBagArticleInfo(hbtn.intData)
    end, data:GetCellID())

end




function KnapsackView:OnClickTog_Type(idx, isrefresh)

    if not isrefresh then
        if __SelectTog == idx then return end
    end

    __SelectTog = idx

    CommonHelper:RefreshCurItems(self.TogView)

    self:SetShowList(self.typeToggle[idx + 1])

    self:SetScrollView()
end


function KnapsackView:AutoSelectType()
    self:OnClickTog_Type(0, true)
end



function KnapsackView:SetToggleView()
    ---@type parttype_config
    local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
    local list = cfg.GetListType2(self.BagType)

    self.typeToggle = {}
    for k,v in pairs(list) do
        table.insert(self.typeToggle, v)
    end

    CommonHelper:InitScroll_OneRow(self.TogView, #self.typeToggle, function (dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_UpdateTogView, {dataIndex, itemObj, scroll})
    end, nil ,true)
end
function KnapsackView:UpdateToggleView(dataIndex, itemObj, scroll)
    local data = self.typeToggle[dataIndex + 1]

    ---@type parttype_config
    local cfg = ClientDataManager:GetDataTable(ConfigNames.parttype_config)
    local title = ClientDataManager:GetTemplateString(cfg.GetDataByType2(self.BagType, data))

    CommonHelper:SetText("typename", itemObj, title )

    local icon = CommonHelper:GetComponentSetImage("icon1", itemObj, cfg.GetBagIcon(self.BagType, data), UIModuleID.Bag)
    CommonHelper:ImageSetNativeSize(icon)
    icon = CommonHelper:GetComponentSetImage("icon2", itemObj, cfg.GetBagIcon(self.BagType, data), UIModuleID.Bag)
    CommonHelper:ImageSetNativeSize(icon)

    local tog = CommonHelper:HButtonSetCallback("ItemBtn",itemObj,function (hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.KnapsackView_ClickTog, hbtn.intData)
    end, dataIndex)

    CommonHelper:SetToggleState(tog,dataIndex == __SelectTog)
end
function KnapsackView:RefreshData()
    --CommonHelper:TitleScrollView_RefreshCurList(self.ScrollView, false)
    self:SetBagList()

    self:OnClickTog_Type(__SelectTog, true)
end