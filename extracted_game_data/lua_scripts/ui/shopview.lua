local __SelectGoods = nil
---@class ShopView : ViewBase
ShopView = class("ShopView", ViewBase)
---@type ShopData
local _CurShop = nil
---@type table<number,dictshop_config_cell>
local _ShopTypeList = nil
local _SelectSubType = nil
function ShopView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ShopViewAction")
end

function ShopView:Awake()
    self.Top = UIUtil.GetChild("Top", self.gameObject)
    self.Center = UIUtil.GetChild("Center", self.gameObject)
    self.Bottom = UIUtil.GetChild("Bottom", self.gameObject)

    self.ScrollView = UIUtil.GetTypeChildWightByParent("GoodsView", self.Center, typeof(MoreRowScrollView))
    self.ShopTypeView = UIUtil.GetTypeChildWightByParent("ShopTypeView", self.Center, typeof(MoreRowScrollView))
    self.ShopSubTypeView = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_SubType", self.gameObject, typeof(MoreRowScrollView))
    self.ShopMoneys = UIUtil.GetTypeChildWightByParent("MoreRowScrollView_Moneys", self.gameObject, typeof(MoreRowScrollView))

    self.RechargeScrollView = UIUtil.GetTypeChildWightByParent("RechargeView", self.Center, typeof(CustomScrollView))

    CommonHelper:HButtonSetCallback("PurchaseTestBtn", self.Bottom, function(hbtn)
        print("购买60钻石。。。。")
        --SDKManager:Get():CreateOrder("ma122na.zs6")
        --ShopSubsystem:Get():SendMsg_Purchase_Quick_Pre("ma122na.zs6")
        local roleName = PlayerDataManager:Get():GetPlayerName() or ""
        local roleLv = PlayerDataManager:Get():GetPlayerLV() or ""
        local serverName = "NormalServer"
        UnifySDKHelper:Purchase_CreateOrder("ma122na.zs30", "", "", "300钻石", "170", "USD", roleName, tostring(roleLv), serverName)

    end)
    CommonHelper:HButtonSetCallback("PurchaseTest1Btn", self.Bottom, function(hbtn)
        print("购买60钻石。。。。")
        --SDKManager:Get():CreateOrder("ma122na.zs6")

        local roleName = PlayerDataManager:Get():GetPlayerName() or ""
        local roleLv = PlayerDataManager:Get():GetPlayerLV() or ""
        local serverName = "NormalServer"
        UnifySDKHelper:Purchase_CreateOrder("ma122na.zs6", "", "", "60钻石", "33", "USD", roleName, tostring(roleLv), serverName)

    end)
    CommonHelper:HButtonSetCallback("BtnBack", self.Top, function(hbtn)
        UIManager:Get():CloseView()
    end)
    CommonHelper:HButtonSetCallback("BtnHome", self.gameObject, function(hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(false)
    end)

    self.BtnProb = CommonHelper:HButtonSetCallback("BtnProb", self.Center, function(hbtn)
        CommonHelper:ShowHelpView(_CurShop.PropId, nil, HelpStyleType.BlueStyle)
    end)
    CommonHelper:HButtonSetCallback("BtnShopingCar", self.gameObject, function(hbtn)
        UIManager:Get():OpenPopup("ShoppingCarView", CanvasType.MainCanvas, "ShoppingCarView")
    end)

    self.RefreshBtn = CommonHelper:HButtonSetCallback("BtnRefresh", self.gameObject, function(data)
        -- _CurShop.LastRNum>0 and
        if PlayerDataManager:Get():GetCurrency(_CurShop.MoneyType) >= _CurShop.RefreshMoneyNum and _CurShop.LastRNum > 0 then
            local boxfunc = function()
                local text = ""
                if _CurShop.RefreshMoneyNum == 0 then
                    text = ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopRefreshTips0)
                else
                    text = CommonHelper:GetTempStr_Default(TemplateStringID.ShopRefreshTips1, _CurShop.RefreshMoneyNum, CommonHelper:GetTempStr_Default(CommonHelper:GetTableDataByID(ConfigNames.article_config, _CurShop.MoneyType).name))
                end
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Pink, string.format(text, _CurShop.RefreshMoneyNum), ClientDataManager:Get():GetTemplateString(TemplateStringID.Refresh), ClientDataManager:Get():GetTemplateString(TemplateStringID.OK), ClientDataManager:Get():GetTemplateString(TemplateStringID.Cancel), true)
                if ret == MessageBoxHelp.BtnType.OK then
                    UINotify:Get():SendNotification(UINotifyEvent.ShopViewAutoRefresh, 1)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
        else
            if _CurShop.LastRNum <= 0 then
                CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopRefreshCountNoEnough))
                return
            end
            if PlayerDataManager:Get():GetCurrency(_CurShop.MoneyType) < _CurShop.RefreshMoneyNum then
                CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopRefreshMoneyNoEnough))
            end
        end
    end)

end

function ShopView:OnOpen()
    self:ViewFixScreen()
end

function ShopView:ReOpen()

end

function ShopView:OnClose()
    TimerManager:Get():StopTimer(self.refreshTimeId)
    CommonHelper:ReleasePool(UIModuleID.Shop)
end

function ShopView:SetScrollView(data, isRefresh)
    self.goodList = data
    ShopDataManager:Get().CurShopGoodList = self.goodList
    local funcUpdateItem = function(dataIndex, itemObj, scroll)
        UINotify:Get():SendNotification(UINotifyEvent.ShopView_UpdateScrollView, { dataIndex, itemObj, scroll })
    end
    cs_coroutine.start(function()
        coroutine.yield()
        CommonHelper:InitMoreRowScrollView(self.ScrollView, #self.goodList, 6, funcUpdateItem, true, nil, isRefresh)
    end)
    self:CheckNewBieGuide()
end

function ShopView:UpdateScrollView(dataIndex, itemObj, scroll)
    ---@type GoodsData
    local data = self.goodList[dataIndex + 1]
    if data == nil then
        return
    end
    local param = Param_ShopGoodsGroup()
    param.goodType = data.goodsType
    param.articleId = data.id
    param.grid = data.grid
    param.moduleId = UIModuleID.Shop
    param.count = 1
    param.price = data.price
    param.currencytype = data.moneyType
    param.num = data.num
    param.disCount = data.discount
    param.maxNum = data.maxNum
    param.limit = data.Condition
    param.limitValue = data.ConditionValue
    param.limitCurValue = _CurShop.GuideLevel
    param.flag = data.flag
    CommonHelper:SetShopGoodsGroup(itemObj, param)

    CommonHelper:HButtonSetCallback("GoodsItemBtn", itemObj, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ShopView_ClickItem, hbtn.intData)
    end, dataIndex)
    CommonHelper:HButtonSetCallback("BtnAddCar", itemObj, function(hbtn)
        self:AddShoppingCar(hbtn.intData)
    end, dataIndex)

end
function ShopView:ShopViewOpen()
    self:SetData(self.shopid)

end

function ShopView:SetData(shopid, isRefresh)
    _CurShop = ShopDataManager:Get():GetCurShop()
    _ShopTypeList = {}
    for i, v in pairs(ShopDataManager:Get().ShopType) do
        if v.C_ID == ShopID.Guild then
            if PlayerDataManager:Get():GetGuildId() > 0 then
                table.insert(_ShopTypeList, v)
            end
        elseif v.C_ID == ShopID.RaceFifa then
            if RaceActManager:Get():GetRaceInfo(RaceActId.RaceUEFA) then
                table.insert(_ShopTypeList, v)
            end
        elseif v.C_ID == ShopID.StrengthSprint then

        else
            table.insert(_ShopTypeList, v)
        end
    end
    self.shopid = shopid
    UIUtil.ShowCanvasGroupByName("GoodsView", self.gameObject, true)
    CommonHelper:SetHButtonClick(self.BtnProb, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnProb) and _CurShop.PropId ~= 0, true)
    self:SetShopSubType(isRefresh)
    local shopData = self:GetShopDataByShopId(self.shopid)
    CommonHelper:InitMoreRowScrollView(self.ShopTypeView, #_ShopTypeList, 1, function(index, item, scroll)
        CommonHelper:SetText("tweenhover/###text", item, ClientDataManager:Get():GetTemplateString(_ShopTypeList[index + 1].shopname))
        CommonHelper:SetText("tweennormal/###text", item, ClientDataManager:Get():GetTemplateString(_ShopTypeList[index + 1].shopname))
        local Tog = CommonHelper:HButtonSetCallback("Toggle", item, function(data)
            if self.shopid == _ShopTypeList[index + 1].C_ID then
                return
            end
            if _ShopTypeList[index + 1].C_ID == ShopID.Recharge then
                if self.Page_RechargeView == nil then
                    self.Page_RechargeView = Page_RechargeView()
                    local root = self:GetChild("Page_RechargeView")
                    self.Page_RechargeView:SetData(root)
                end
                self.Page_RechargeView:SetView()
                self:SetData(ShopID.Recharge)
            else
                ShopSubsystem:Get():SendMsg_ShopInfo(_ShopTypeList[index + 1].C_ID)
            end

        end, index)
        CommonHelper:SetToggleState(Tog, self.shopid == _ShopTypeList[index + 1].C_ID)
    end, false, nil, false)
    if _CurShop.MoneyType > 0 then
        CommonHelper:SetGameObjectActive("TweenTemp_Refresh", self.gameObject, true)
        self:SetRefreshTimeText(_CurShop.ShopId ~= ShopID.PartExchange)
    else
        CommonHelper:SetGameObjectActive("TweenTemp_Refresh", self.gameObject, true)
        self:SetRefreshTimeText()
    end


    --end
    --  CommonHelper:SetGameObjectActive("Refresh",self.Top, self.shopid~=ShopID.GiftBag)
    CommonHelper:SetText("###shopNameTittle", self.Top, ClientDataManager:Get():GetTemplateString(shopData.shopname))

end
function ShopView:GetShopDataByShopId(shopid)
    for i = 1, #_ShopTypeList do
        if shopid == _ShopTypeList[i].C_ID then
            return _ShopTypeList[i]
        end
    end
    return nil
end
local CurShopSubTypeCurreyOrGoodsType = -1
local subtypes = nil
local CurMoneysTypes = nil
function ShopView:SetShopSubType(isRefresh)
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.shop_config, self.shopid)
    CommonHelper:SetGameObjectActive("MoreRowScrollView_SubType", self.gameObject, cfg.tabtype ~= "0")
    CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, false)
    if cfg.tabtype ~= "0" then
        local subTypeTypes = stringSplit(cfg.tabtype, "|")
        subtypes = {}
        CurShopSubTypeCurreyOrGoodsType = tonumber(subTypeTypes[1])
        local tables = stringSplit(subTypeTypes[2], ":")
        for i = 1, #tables do
            if tables[i] == "-1" then
                subtypes[i] = -1
            else
                subtypes[i] = stringSplitToNumber(tables[i], ',')
            end
        end

        local subnames = stringSplit(cfg.tabdes, ":")
        if isRefresh then
            _SelectSubType = 1
            CurMoneysTypes = subtypes[_SelectSubType]
        end

        CommonHelper:InitMoreRowScrollView(self.ShopSubTypeView, #subnames, 1, function(index, itemObj, scroll)
            CommonHelper:SetText("normal/###text", itemObj, CommonHelper:GetTempStr_Default(subnames[index + 1]))
            CommonHelper:SetText("hover/###text", itemObj, CommonHelper:GetTempStr_Default(subnames[index + 1]))
            local Tog = CommonHelper:HButtonSetCallback("Toggle", itemObj, function(data)
                _SelectSubType = data.intData
                CurMoneysTypes = subtypes[_SelectSubType]
                self:SetSubTypeTable(true)
                CommonHelper:MoreRowView_RefreshCurList(self.ShopSubTypeView, false)
                if CurShopSubTypeCurreyOrGoodsType == 1 then
                    CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                        CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                        CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
                    end)
                end
            end, index + 1)
            CommonHelper:SetToggleState(Tog, _SelectSubType == index + 1)
        end)
        CommonHelper:SetHButtonClick(self.RefreshBtn, false)
        if CurShopSubTypeCurreyOrGoodsType == 1 then
            CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, true)
            CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
            end)
        end
        self:SetSubTypeTable(isRefresh)
    else
        if _CurShop.ShopId == ShopID.Guild then
            CommonHelper:SetHButtonClick(self.RefreshBtn, false)
            CurMoneysTypes = { CurrencyType.Privilege }
            CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
            end)
            CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, true)
            self:SetScrollView(_CurShop.goods, isRefresh)
        elseif _CurShop.ShopId == ShopID.RaceFifa then
            CommonHelper:SetHButtonClick(self.RefreshBtn, false)
            CurMoneysTypes = { CurrencyType.RaceFifa }
            CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
            end)
            CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, true)
            self:SetScrollView(_CurShop.goods, isRefresh)
        elseif _CurShop.ShopId == ShopID.RaceSport then
            CommonHelper:SetHButtonClick(self.RefreshBtn, false)
            CurMoneysTypes = { CurrencyType.RaceSport }
            CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
            end)
            CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, true)
            self:SetScrollView(_CurShop.goods, isRefresh)
        elseif _CurShop.ShopId == ShopID.PartExchange then
            CommonHelper:SetHButtonClick(self.RefreshBtn, false)
            CurMoneysTypes = { CurrencyType.PartExchangeStaon, CurrencyType.PartExchangeStaon2 }
            CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
            end)
            CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, true)
            self:SetScrollView(_CurShop.goods, isRefresh)
        elseif _CurShop.ShopId == ShopID.RankShop then
            CommonHelper:SetHButtonClick(self.RefreshBtn, false)
            CurMoneysTypes = { CurrencyType.RankShopCoin }
            CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
            end)
            CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, true)
            self:SetScrollView(_CurShop.goods, isRefresh)
        elseif _CurShop.ShopId == ShopID.AdShop then
            CommonHelper:SetHButtonClick(self.RefreshBtn, false)
            CurMoneysTypes = { CurrencyType.RaceAd }
            CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
            end)
            CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, true)
            self:SetScrollView(_CurShop.goods, isRefresh)
        elseif _CurShop.ShopId == ShopID.GTRace then
            CommonHelper:SetHButtonClick(self.RefreshBtn, false)
            CurMoneysTypes = { CurrencyType.GTShopCoin }
            CommonHelper:InitMoreRowScrollView(self.ShopMoneys, #CurMoneysTypes, 1, function(index, itemObj, scroll)
                CommonHelper:GetComponentSetImage("shopcurrencyimg", itemObj, CommonHelper:GetCurrencyTypeImage(CurMoneysTypes[index + 1]), UIModuleID.Shop)
                CommonHelper:SetText("###shopcurrencynumber", itemObj, tostring(KnapsackDataManager:Get():GetArticleCountByCfgid(CurMoneysTypes[index + 1])))
            end)
            CommonHelper:SetGameObjectActive("MoreRowScrollView_Moneys", self.gameObject, true)
            self:SetScrollView(_CurShop.goods, isRefresh)
        else
            CommonHelper:SetHButtonClick(self.RefreshBtn, true)
            self:SetScrollView(_CurShop.goods, isRefresh)
        end

    end
end
function ShopView:SetSubTypeTable(isRefresh)
    local data = {}
    for i = 1, #_CurShop.goods do
        local flag = false

        if CurShopSubTypeCurreyOrGoodsType == 1 then
            for j = 1, #subtypes[_SelectSubType] do
                if _CurShop.goods[i].moneyType == subtypes[_SelectSubType][j] then
                    flag = true
                    break
                end
            end
        elseif CurShopSubTypeCurreyOrGoodsType == 2 then
            local propType, cfg = CommonHelper:GetPropTypeById(_CurShop.goods[i].id)
            if subtypes[_SelectSubType] ~= -1 then
                if propType == subtypes[_SelectSubType][1] then
                    if propType == PropType.Part then
                        ---@type dictpartbase_config_cell
                        local baseCfg = CommonHelper:GetPartBaseCfg(_CurShop.goods[i].id)
                        for j = 2, #subtypes[_SelectSubType] do
                            if baseCfg.parttype == subtypes[_SelectSubType][j] then
                                flag = true
                                break
                            end
                        end
                    elseif propType == PropType.Article then
                        for j = 2, #subtypes[_SelectSubType] do
                            if cfg.propstype == subtypes[_SelectSubType][j] then
                                flag = true
                                break
                            end
                        end
                    end
                end
            else
                flag = true
                local propType, cfg = CommonHelper:GetPropTypeById(_CurShop.goods[i].id)
                for m = 2, #subtypes do
                    if propType == PropType.Part then
                        for j = 2, #subtypes[m] do
                            ---@type dictpartbase_config_cell
                            local baseCfg = CommonHelper:GetPartBaseCfg(_CurShop.goods[i].id)
                            if baseCfg.parttype == subtypes[m][j] then
                                flag = false
                                break
                            end
                        end
                    elseif propType == PropType.Article then
                        for j = 2, #subtypes[m] do
                            if cfg.propstype == subtypes[m][j] then
                                flag = false
                                break
                            end
                        end
                    end
                end
            end
        end

        if flag then
            table.insert(data, _CurShop.goods[i])
        end
    end
    self:SetScrollView(data, isRefresh)
end

function ShopView:SetRefreshTimeText(falg)
    CommonHelper:SetHButtonClick(self.RefreshBtn, falg, true)
    self.refreshTime = math.abs(_CurShop.RefreshTime)
    self:SetRefreshTimeTextHour()
    if self.refreshTimeId ~= nil then
        TimerManager:Get():StopTimer(self.refreshTimeId)
    end
    if _CurShop.LastRNum <= 0 then
        CommonHelper:SetText("###refreshcount", self.RefreshBtn.gameObject, ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopRefresh))
    else
        CommonHelper:SetText("###refreshcount", self.RefreshBtn.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.ShopRefreshCount, _CurShop.LastRNum))
    end
    --if _CurShop.LastRNum<=0 then
    --  ---  CommonHelper:SetText("###RefreshHit",self.Top,ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopRefreshTimeDone))
    --    CommonHelper:SetText("###refreshcount",self.Top,ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopRefresh))
    --    CommonHelper:SetText("###RefreshTime",self.Top,"")
    --    return
    --else
    --CommonHelper:SetText("###RefreshTime",self.Center,ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopNextRefreshTimeDone))
    self.refreshTimeId = TimerManager:Get():CreateTimerLoop(1, function(class)
        class:SetRefreshTimeTextHour()
        class.refreshTime = class.refreshTime - 1
        _CurShop.RefreshTime = class.refreshTime
        if class.refreshTime <= 0 then
            UINotify:Get():SendNotification(UINotifyEvent.ShopViewAutoRefresh, 0)
        end
    end, self)
    -- end
end
function ShopView:SetRefreshTimeTextHour()
    local hour = math.modf(self.refreshTime / 60 / 60)
    local minute = math.modf((self.refreshTime - (hour * 60 * 60)) / 60)
    local second = math.fmod(self.refreshTime, 60)
    CommonHelper:SetText("###RefreshTime", self.Center, CommonHelper:GetTempStr_Default(TemplateStringID.ShopRefreshTimeFormat, hour, minute, second))
end
function ShopView:SetRefreshTimeTextDay()
    if self.refreshTimeId ~= nil then
        TimerManager:Get():StopTimer(self.refreshTimeId)
    end
    self.refreshTime = math.abs(_CurShop.RefreshTime)
    CommonHelper:SetHButtonClick(self.RefreshBtn, false, true)
    -- CommonHelper:SetText("RefreshHit",self.Top,ClientDataManager:Get():GetTemplateString(TemplateStringID.ShopNextRefreshTimeDone))
    local day = math.modf(self.refreshTime / 60 / 60 / 24)
    local hour = math.modf(math.fmod(self.refreshTime, 60 * 60 * 24) / 60 / 60)
    CommonHelper:SetText("###RefreshTime", self.Center, CommonHelper:GetTempStr_Default(TemplateStringID.ShopRefreshDayFormat, day, hour))
end

function ShopView:StopTiming(node)
    ShopSubsystem:Get():RefreshShop(_CurShop.ShopId, node)
end
function ShopView:ClickItem(index)
    -- 弹出商品详情面板
    UIManager:Get():ShowPersistentView("GoodsInfoView", CanvasType.MainCanvas, "GoodsInfoView")
    UINotify:Get():SendNotification(UINotifyEvent.SetGoodsInfoView, index)
end

function ShopView:AddShoppingCar(index)
    local data = _CurShop.goodExs2[index + 1]

    ShoppingCarDataManager:Get():AddGoods(self.shopid, data)
end

