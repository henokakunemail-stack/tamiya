---@class PveChapterLevelInfoViewAction:ViewBaseAction
PveChapterLevelInfoViewAction = class("PveChapterLevelInfoViewAction",ViewBaseAction)

function PveChapterLevelInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function PveChapterLevelInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.PVEChapterLevelInfoView_SetData, self.SetData)
end

---@return PveChapterLevelInfoView
function PveChapterLevelInfoViewAction:View()
    return self.view
end
function PveChapterLevelInfoViewAction:SetData(data)
    self:View():SetData()
end


return PveChapterLevelInfoViewAction()