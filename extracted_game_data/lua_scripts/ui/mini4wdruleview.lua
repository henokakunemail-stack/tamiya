---@class Mini4wdRuleView : ViewBase
Mini4wdRuleView = class("Mini4wdRuleView", ViewBase)

function Mini4wdRuleView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "Mini4wdRuleViewAction")
end
local _OpenType=-1
local _CallBack=nil
function Mini4wdRuleView:Awake()
    CommonHelper:HButtonSetCallback("BtnOK",self.gameObject,function (hbtn)
        UIManager:Get():HidePersistentView("Mini4wdRuleView")
        PlayerPrefsHelper:SetValue_Mini4wdRuleViewOpen(_OpenType,1)
        if _CallBack then
            _CallBack(true)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function(hbtn)
        UIManager:Get():HidePersistentView("Mini4wdRuleView")
        if _CallBack then
            _CallBack(false)
        end
    end)
    CommonHelper:HButtonSetCallback("BtnHome",self.gameObject,function (hbtn)
        SkipModuleHelper:Get():BackToMainMenuView(true,function()
            if _CallBack then
                _CallBack(false)
            end
        end)
    end)


end

function Mini4wdRuleView:OnOpen()

end


function Mini4wdRuleView:OnClose()

end

function Mini4wdRuleView:SetData(type,func)
    _OpenType=type
    _CallBack=func
end

