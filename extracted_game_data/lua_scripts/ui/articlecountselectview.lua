local __AddNum = 0
local __AddMax = 0
local __Min = 0
local __CallBack = nil
local __CallCancel = nil
local _ModuleId = nil

---@type PVELevelData
local __LevelData = nil

---@class ArticleCountSelectView : ViewBase
ArticleCountSelectView = class("ArticleCountSelectView", ViewBase)

function ArticleCountSelectView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ArticleCountSelectViewAction")
end
function ArticleCountSelectView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(hbtn)
        if __CallCancel then
            __CallCancel()
        end
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("BtnCloseMask", self.gameObject, function(hbtn)
        if __CallCancel then
            __CallCancel()
        end
        UIManager:Get():ClosePopup()
    end)

    CommonHelper:HButtonSetCallback("BtnSure", self.gameObject, function(hbtn)
        self:OnEnsureBtnClick()
    end)

    CommonHelper:HButtonSetCallback("BtnEditorRemove", self.gameObject, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleCountSelectView_ClickNum, -1)
    end)

    CommonHelper:HButtonSetCallback("BtnEditorAdd", self.gameObject, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleCountSelectView_ClickNum, 1)
    end)

    CommonHelper:HButtonSetCallback("BtnEditorMax", self.gameObject, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleCountSelectView_ClickNum, __AddMax)
    end)
    CommonHelper:HButtonSetCallback("BtnEditorMin", self.gameObject, function(hbtn)
        UINotify:Get():SendNotification(UINotifyEvent.ArticleCountSelectView_ClickNum, -__AddMax)
    end)

    self.Input = UIUtil.GetTypeChildWightInputPath("UseNumInput", self.gameObject, typeof(InputField))
    self.Input.onValueChanged:AddListener(function(str)
        if CommonHelper:IsNullOrEmpty(str) then
            return
        end
        local result = tonumber(str)
        if result then
            if   result > __Min and result < __AddMax then
                __AddNum = result
            else
                if result <= __Min then
                    __AddNum =__Min
                end
                if result >= __AddMax then
                    __AddNum =__AddMax
                end
            end
            self:SetCost()
        end
    end)
end

function ArticleCountSelectView:OnEnsureBtnClick()
    if __CallBack then
        __CallBack(__AddNum)
    end
    UIManager:Get():ClosePopup()
end

function ArticleCountSelectView:OnClose()

end
---@param article ArticleCell
function ArticleCountSelectView:SetData(moduleId,article,max,min,default,func,funccancel)
    __AddNum = 0
    __AddMax = (max==nil or max>article:GetCount()) and article:GetCount() or max
    __Min= min or 0
    __CallBack=func
    __CallCancel=funccancel
    _ModuleId=moduleId
    local articleCfg = article:GetArticleConfig()
    CommonHelper:SetText("###articledesctext", self.gameObject, CommonHelper:GetTempStr_Default(articleCfg.description))
    CommonHelper:SetText("###playerHoldNum", self.gameObject, article:GetCount())
    CommonHelper:SetText("###articlename", self.gameObject, CommonHelper:GetPartOrArticleName(article:GetID()))
    local ArticleItem=self:GetChild("ArticleItem")
    CommonHelper:SetItemArticleGroup(ArticleItem, _ModuleId, article:GetID(), nil, function(id)
        CommonHelper:ShowPartInfoByCfgId(id, _ModuleId)
    end,article:GetID())
    self:OnClickBtn_Num(default or  0)
end

function ArticleCountSelectView:SetCost()
    CommonHelper:SetInputFieldTextByGo(self.Input, string.format("%d", __AddNum))

end

function ArticleCountSelectView:OnClickBtn_Num(num)
    __AddNum = __AddNum + num

    __AddNum = __AddNum < __Min and __Min or __AddNum
    __AddNum = __AddNum > __AddMax and __AddMax or __AddNum

    self:SetCost()
end

function ArticleCountSelectView:OnClose()

end

