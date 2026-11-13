---@class BuyDirectView :ViewBase
BuyDirectView = class("BuyDirectView", ViewBase)

function BuyDirectView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BuyDirectViewAction")

end

---@type ArticleCell
local _Data = nil
local __AddNum = -1
local costNum = 0
function BuyDirectView:Awake()
    self.PropCompoent = self:GetChild("ItemCom_202")

    CommonHelper:HButtonSetCallback("BtnEditorRemove", self.gameObject, function(data)
        __AddNum = __AddNum - 1
        if __AddNum <= 1 then
            __AddNum = 1
        end
        self:SetUseNum()
    end)

    CommonHelper:HButtonSetCallback("BtnEditorAdd", self.gameObject, function(data)
        __AddNum = __AddNum + 1
        if #(UserDirectManager:Get():GetDataByID(_Data.propid,_Data.coinid).pay) > 1 then
            if __AddNum >= #(UserDirectManager:Get():GetDataByID(_Data.propid,_Data.coinid).pay) then
                __AddNum = #(UserDirectManager:Get():GetDataByID(_Data.propid,_Data.coinid).pay)
            end
        else
            if __AddNum >= self.MaxCount then
                __AddNum = self.MaxCount
            end
        end

        self:UseTip()

        self:SetUseNum()
    end)

    CommonHelper:HButtonSetCallback("BtnEditorMax", self.gameObject, function(data)
        if #(UserDirectManager:Get():GetDataByID(_Data.propid,_Data.coinid).pay) > 1 then
            __AddNum = #(UserDirectManager:Get():GetDataByID(_Data.propid,_Data.coinid).pay)
        else
            __AddNum = self.MaxCount
        end

        self:UseTip()
        self:SetUseNum()
    end)
    CommonHelper:HButtonSetCallback("BtnEditorMin", self.gameObject, function(data)
        __AddNum=1
        self:UseTip()
        self:SetUseNum()
    end)

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    self.BtnUse = CommonHelper:HButtonSetCallback("BtnUse", self.gameObject, function(hbtn)
        if _Data and __AddNum ~= 0 then
            --KnapsackSubsystem:Get():SendMsg_UseArticle(_Data:GetID(), __AddNum)
            print("__AddNum   __AddNum  ", _Data.propid, __AddNum, _Data.coinid)
            if PlayerDataManager:Get():CheckCurrencyEnough(_Data.coinid,costNum) then
                CommonSubsystem:Get():SendMsg_BuyDirect(_Data.propid, __AddNum, _Data.coinid)
            end
        end
    end)

end

function BuyDirectView:OnOpen()

end

function BuyDirectView:OnClose()

    CommonHelper:ReleasePool(UIModuleID.BuyDirect)
end

function BuyDirectView:SetData(propid, maxcount, typeid)
    self.MaxCount = maxcount
    self.typeID = typeid
    ---@type dictdirect_config
    ---@type dictdirect_config_cell
    local dictdirect_config = ClientDataManager:Get():GetDataTable("dictdirect_config")
    _Data = dictdirect_config.GetById(self.typeID)

    __AddNum = 1

    local count = KnapsackDataManager:Get():GetArticleCountByCfgid(propid)
    CommonHelper:SetText("###playerHoldNum", self.gameObject, count)

    local param = Param_ItemArticleParam()
    CommonHelper:SetItemComGroup(self.PropCompoent,UIModuleID.BuyDirect,propid, param)

    self.propType, self.cfg = CommonHelper:GetPropTypeById(propid)
    local des = ""
    local name = ""

    if self.propType == PropType.Part then
        des = self.cfg.desc
        name = self.cfg.partname
    elseif self.propType == PropType.Article then
        des = self.cfg.description
        name = self.cfg.name
    end

    CommonHelper:SetText("###goodsdesctext", self.gameObject, CommonHelper:GetTempStr_Default(des))
    CommonHelper:SetText("###goodsname", self.gameObject, CommonHelper:GetTempStr_Default(name))
    self:SetUseNum()
end

function BuyDirectView:SetUseNum()

    local directData = UserDirectManager:Get():GetDataByID(_Data.propid,_Data.coinid)
    costNum = 0
    if #directData.pay > 1 then
        if __AddNum >= ((#directData.pay) - (directData.curnum)) then
            __AddNum = ((#directData.pay) - (directData.curnum))
        end

        for i = 1, __AddNum do
            costNum = costNum + directData.pay[directData.curnum + i]
        end
    else
        costNum = costNum + directData.pay[1] * __AddNum
    end

    CommonHelper:SetInputFieldText("UseNumInput", self.gameObject, __AddNum)
    local image = CommonHelper:GetComponentSetImage("currySprite", self.gameObject, CommonHelper:GetCurrencyTypeImage(_Data.coinid), UIModuleID.BuyDirect)

    CommonHelper:SetText("###paymoney", self.gameObject, costNum)

end

function BuyDirectView:UseTip()
    if __AddNum > 1 and self.propType == PropType.Article then
        if self.cfg.type == KnapsackType.Type4 and self.cfg.school == KnapsackConsumeSubType.ComposeTicket then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.Shop_Compose_UserOnce))
            __AddNum = 1
        end
    end
end

function BuyDirectView:Refresh()
    UIManager:Get():ClosePopup()
end



