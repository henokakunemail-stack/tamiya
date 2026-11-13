---@class Page_CommonFestivalExchangeView
Page_CommonFestivalExchangeView = class("Page_CommonFestivalExchangeView")

function Page_CommonFestivalExchangeView:initialize(parentPref)
    self.TogGroup = {}

    self.parentPref = parentPref
    self.ExchangeShopSVC = UIUtil.GetTypeChildWightByParent("ExchangeShopSVC", self.parentPref, typeof(MoreRowScrollView))
end

function Page_CommonFestivalExchangeView:RefreshExchangeInfo(msg)
    ---@type SC_ActShopInfo
    ---@type SC_buyActShop
    ---@type SC_ShopItem
    local allShopData = msg.shoplist
    self:SortAllShopData(allShopData)

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        local _GroupData = allShopData[dataIndex + 1]

        CommonHelper:SetText("###residueText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalHaveNum), (_GroupData.limitnum - _GroupData.curnum)))
        CommonHelper:SetText("###text", itemObj, CommonHelper:GetTempStr_Default(_GroupData.price))

        local _itemType, _itemData = CommonHelper:GetPropTypeById(tonumber(_GroupData.propsid))

        local obj = UIUtil.GetChild("ItemCom_118", itemObj)
        local param = Param_ItemArticleParam()
        CommonHelper:SetItemComGroup(obj, UIModuleID.CommonFestival, _itemData.C_ID, param, function(btnData)
            --if _itemData.propstype == KnapsackType.RandomBox then
            --    UIManager:Get():OpenPopup("OptionalGiftView", CanvasType.FrontCanvas, "OptionalGiftView",true)
            --    UINotify:Get():SendNotification(UINotifyEvent.OptionalGiftViewSetData, _itemData.C_ID)
            --else
                CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.CommonFestival, false)

            --end
        end, _itemData.C_ID)

        local _goodsType, _goodsData = CommonHelper:GetPropTypeById(tonumber(_GroupData.coinid))
        local _goodsIconImg = _goodsType == PropType.Part and _goodsData.icon or _goodsData.icon .. ".png"

        CommonHelper:GetComponentSetUITexture("###exchangeIcon", itemObj, _goodsIconImg, UIModuleID.CommonFestival)

        CommonHelper:HButtonSetCallback("BtnExchange", itemObj, function(data)
            if (_GroupData.limitnum - _GroupData.curnum) < 1 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalNoExchangeNum))
            elseif (msg.exchnum / _GroupData.price) < 1 then
                CommonTipsHelper:ShowCenterTips(string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LackArticle), CommonHelper:GetTempStr_Default(_goodsData.name)))


            else
                UIManager:Get():OpenPopup("CommonFestivalTipsView", CanvasType.FrontCanvas, "CommonFestivalTipsView", true)
                UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshTips, { msg.shopid, _GroupData, msg.exchnum })
            end
        end)
    end

    CommonHelper:InitMoreRowScrollView(self.ExchangeShopSVC, #allShopData, 4, UpdateFunc, true,
            function()
            end, false)

    local _coinType, _coinData = CommonHelper:GetPropTypeById(tonumber(msg.exchid))
    local _coinImg = _coinType == PropType.Part and _coinData.icon or _coinData.icon .. ".png"

    CommonHelper:GetComponentSetUITexture("haveExchangeIcon", self.parentPref, _coinImg, UIModuleID.CommonFestival)
    CommonHelper:SetText("###exchangeNum", self.parentPref, CommonHelper:GetTempStr_Default(msg.exchnum))
    CommonHelper:SetText("###IntroduceText", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalExchange))

    local t_beginTime, t_endTime = CommonFestivalDataManager:Get():GetActTime(msg.shopid)

    local _beginTime = CommonHelper:ConvertIntToDataTime(t_beginTime * 1000)
    local _endTime = CommonHelper:ConvertIntToDataTime(t_endTime * 1000)
    CommonHelper:SetText("###time", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
                    _beginTime.Month, _beginTime.Day, _beginTime.Hour, _beginTime.Minute,
                    _endTime.Month, _endTime.Day, _endTime.Hour, _endTime.Minute))
end

function Page_CommonFestivalExchangeView:SortAllShopData(shopData)
    table.sort(shopData, function(a, b)
        return a.grid < b.grid
    end)
end

function Page_CommonFestivalExchangeView:GetDataTime(_time)
    local _timeStr = ""

    local month = tonumber(os.date("%m", _time))
    local day = tonumber(os.date("%d", _time))
    local hour = tonumber(os.date("%H", _time))
    local minute = tonumber(os.date("%M", _time))

    _timeStr = month .. "." .. day .. " " .. hour .. ":" .. minute

    return _timeStr
end

