---@class ClubTrainSettingViewAction:ViewBaseAction
ClubTrainSettingViewAction= class("ClubTrainSettingViewAction",ViewBaseAction)

function ClubTrainSettingViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@retrun ClubTrainSettingView
function ClubTrainSettingViewAction:View()
    return self.view
end

function ClubTrainSettingViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubTrainSettingView_InitScrollView,self.InitScrollView)
end


function ClubTrainSettingViewAction:InitScrollView()
    if self:View() then
        self:View():InitScrollView()
    end
end












return ClubTrainSettingViewAction()