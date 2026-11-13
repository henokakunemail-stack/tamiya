---@class Page_RechargeDiamondView
Page_RechargeDiamondView = class("Page_RechargeDiamondView", Page_ActivityBase)
function Page_RechargeDiamondView:initialize()

end

function Page_RechargeDiamondView:InitViewInfo(parent, activityType, msg,isreset)
    Page_ActivityBase:InitViewInfo(parent, activityType, msg,isreset)
    self.Root = parent
    self:SetData(msg,isreset)
end

function Page_RechargeDiamondView:SetData(msg,isreset)
    self.scrollView = UIUtil.GetTypeChildWightInputPath("ScrollView", self.Root, typeof(MoreRowScrollView))
    self.Msg = msg
    self:SetView(msg,isreset)
end
function Page_RechargeDiamondView:GetActivityInfoById(id)
    for i = 1, #self.Msg.curActInfo do
        if self.Msg.curActInfo[i].itemid == id then
            return self.Msg.curActInfo[i].firsttime>0
        end
    end
    return 0
end

function Page_RechargeDiamondView:SetView(msg,isreset)
    ---@type table<number,paylist_config_cell>
    local cfg = CommonHelper:GetChargeDataByArea()
    local data = {}
    for k, v in pairs(cfg) do
        if v.chargetype == 0 and v.exnum >0 then
            local temp = {}
            temp.cfg = v
            temp.firstpay = self:GetActivityInfoById(temp.cfg.itemid)
            table.insert(data, temp)
        end
    end
    table.sort(data, function(a, b)
        return a.cfg.itemid < b.cfg.itemid
    end)
    CommonHelper:InitMoreRowScrollView(self.scrollView, #data, 5, function(index, itemObj, scroll)
        local temp = data[index + 1]
        CommonHelper:GetComponentSetUITexture("icon", itemObj, temp.cfg.icon, UIModuleID.Shop)
        CommonHelper:SetText("###Diamond", itemObj, CommonHelper:GetTempStr_Default(temp.cfg.name))
        CommonHelper:SetGameObjectActive("firstdouble", itemObj, not temp.firstpay )
        CommonHelper:SetGameObjectActive("###buygive", itemObj, false)
        local btn = CommonHelper:HButtonSetCallback("BtnPurchase", itemObj, function(btndata)
            CommonHelper:ChargeMoneyByID(temp.cfg.itemid)
        end, index + 1)
        self:SetBtnIsRmbOrToken(btn,temp.cfg)
        CommonHelper:SetText("###priceText", itemObj, data[index + 1].cfg.pricename)
        CommonHelper:SetText("###buygive", itemObj, CommonHelper:GetTempStr_Default(TemplateStringID.RechargeOther, data[index + 1].cfg.otherGiftDiamond))
    end,false,nil,isreset)
end

function Page_RechargeDiamondView:OnClose()

end


