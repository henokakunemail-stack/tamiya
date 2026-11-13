---@class MainRankingListViewAction:ViewBaseAction
MainRankingListViewAction = class("MainRankingListViewAction",ViewBaseAction)

function MainRankingListViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function MainRankingListViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.MainRankingListView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.MainRankingListView_SetCar, self.SetCar)
end

---@return MainRankingListView
function MainRankingListViewAction:View()
    return self.view
end

function MainRankingListViewAction:SetData(type)
    if self:View() then
        self:View():SetData(type)
    end
end
function MainRankingListViewAction:SetCar(msg)
    if self:View() then
        self:View():SetCarData(msg)
    end
end

return MainRankingListViewAction()