---@class RecruitSkipView : ViewBase
RecruitSkipView = class("RecruitSkipView", ViewBase)

function RecruitSkipView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RecruitSkipViewAction")
end

function RecruitSkipView:Awake()
    self. BtnSkip = CommonHelper:HButtonSetCallback("BtnSkip", self.gameObject, function()
            UINotify:Get():SendNotification(UINotifyEvent.RecruitView_SkipAni)
    end)
end
function RecruitSkipView:OnOpen()
    CommonHelper:SetHButtonClick(self.BtnSkip, not CommonHelper:CheckPlayerIsNewGuide(), true)
end
function RecruitSkipView:OnBackKey()

end




