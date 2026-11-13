---@class PveChapterRewardViewAction:ViewBaseAction
PveChapterRewardViewAction = class("PveChapterRewardViewAction",ViewBaseAction)

function PveChapterRewardViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PveChapterRewardViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PVEChapterRewardView_SetData, self.SetData)
end

---@return PveChapterRewardView
function PveChapterRewardViewAction:View()
    return self.view
end
function PveChapterRewardViewAction:SetData(data)
     self:View():SetData(data[1],data[2])
end


return PveChapterRewardViewAction()