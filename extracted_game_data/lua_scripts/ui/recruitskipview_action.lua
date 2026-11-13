---@class RecruitSkipViewAction:ViewBaseAction
RecruitSkipViewAction = class("RecruitSkipViewAction", ViewBaseAction)

function RecruitSkipViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RecruitSkipViewAction:OnRegisterEvents()

end
---@return RecruitSkipView
function RecruitSkipViewAction:View()
    return self.view
end


return RecruitSkipViewAction()