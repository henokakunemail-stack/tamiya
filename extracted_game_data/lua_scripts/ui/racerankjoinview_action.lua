


---@class RaceRankJoinViewAction:ViewBaseAction
RaceRankJoinViewAction = class("RaceRankJoinViewAction",ViewBaseAction)

function RaceRankJoinViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RaceRankJoinViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RaceRankJoinView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceRankJoinView_PlayerReady, self.SetPlayerState)
end

---@return RaceRankJoinView
function RaceRankJoinViewAction:View()
    return self.view
end

function RaceRankJoinViewAction:SetData(param)
    if self:View() then
        self:View():SetData(param)
    end
end

function RaceRankJoinViewAction:SetPlayerState(pid)
    if self:View() then
        self:View():SetPlayerState(pid)
    end
end

return RaceRankJoinViewAction()