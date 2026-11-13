---@class ArticleDisassembleView : ViewBase
ArticleDisassembleView = class("ArticleDisassembleView", ViewBase)

function ArticleDisassembleView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ArticleDisassembleViewAction")
end
---@type ArticleCell
local _Data = nil
local __AddNum = -1
function ArticleDisassembleView:Awake()
    self.PropCompoent = self:GetChild("PropCompoent")
    CommonHelper:HButtonSetCallback("BtnEditorRemove", self.gameObject, function(data)
        __AddNum = __AddNum - 1
        if __AddNum <= 1 then
            __AddNum = 1
        end
        self:SetUseNum()
    end)
    CommonHelper:HButtonSetCallback("BtnEditorAdd", self.gameObject, function(data)
        __AddNum = __AddNum + 1

        if __AddNum >= _Data:GetCount() then
            __AddNum = _Data:GetCount()
        end
        self:UseTip()

        self:SetUseNum()
    end)
    CommonHelper:HButtonSetCallback("BtnEditorMax", self.gameObject, function(data)
        __AddNum = _Data:GetCount()
        self:UseTip()
        self:SetUseNum()
    end)
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
    self.BtnUse = CommonHelper:HButtonSetCallback("BtnUse", self.gameObject, function(hbtn)
        if _Data and __AddNum ~= 0 then
            KnapsackSubsystem:Get():SendMsg_SellGoods(_Data:GetID(),__AddNum)
        end
    end)
end

function ArticleDisassembleView:OnOpen()

end

function ArticleDisassembleView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.CostUse)

end
function ArticleDisassembleView:SetData(date)
    _Data = date
    __AddNum = 1
    local count = _Data:GetCount()
    CommonHelper:SetText("###playerHoldNum", self.gameObject, count)
    local param = Param_PropSquareParam()
    param.id = _Data:GetID()
    param.moduleId = UIModuleID.CostUse
    param.count = -1
    param.showname = true
    CommonHelper:SetPropSquareGroup(self.PropCompoent, param)
    self. propType, self.cfg = CommonHelper:GetPropTypeById(_Data:GetID())
    local des = ""
    if self.propType == PropType.Part then
        des = self.cfg.desc
    elseif self.propType == PropType.Article then
        des = self.cfg.description
    end
    CommonHelper:SetText("###goodsdesctext", self.gameObject, CommonHelper:GetTempStr_Default(des))
    self:SetUseNum()
    CommonHelper:SetInputLimitInputNum(self.buyInput,1,_Data:GetCount(),function(num)
        __AddNum=num
        self:SetUseNum()
    end)
end

function ArticleDisassembleView:SetUseNum()
    self.buyInput= CommonHelper:SetInputFieldText("UseNumInput", self.gameObject, __AddNum)
end

function ArticleDisassembleView:UseTip()
    if __AddNum > 1 and self.propType == PropType.Article then
        if self.cfg.type == KnapsackType.Type4 and self.cfg.school == KnapsackConsumeSubType.ComposeTicket then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.Shop_Compose_UserOnce))
            __AddNum = 1
        end
    end
end

function ArticleDisassembleView:Refresh()
    self:SetData(_Data)
    local count = _Data:GetCount()
    if count<=0 and UIManager:Get():IsPopViewShow("CostUseInfoView") then
        UIManager:Get():ClosePopup()
    end
end



