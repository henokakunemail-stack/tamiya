---@class ClubTrainViewAction:ViewBaseAction
ClubTrainViewAction= class("ClubTrainViewAction",ViewBaseAction)

function ClubTrainViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function ClubTrainViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.ClubTrainView_InitTrainViewInfo,self.InitTrainViewInfo)
    self:AddNotificationEvent(UINotifyEvent.ClubTrainView_UpdateRank,self.UpdateRank)
end


---@return ClubTrainView
function ClubTrainViewAction:View()
        return self.view
end

function ClubTrainViewAction:InitTrainViewInfo()
    if self:View() then
        self:View():InitTrainViewInfo()
    end
end

---@param ranks SC_RaceRankInfo
function ClubTrainViewAction:UpdateRank(ranks)
    if self:View() then
        self:View():UpdateRank(ranks)
    end
end

return ClubTrainViewAction()