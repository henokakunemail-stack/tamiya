---@class SettingViewAction:ViewBaseAction
SettingViewAction = class("SettingViewAction", ViewBaseAction)
-- Action必加1
function SettingViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return SettingView
function SettingViewAction:View()
    return self.view
end
-- Action必加2
function SettingViewAction:OnRegisterEvents()

end



-- Action必加3
return SettingViewAction()
