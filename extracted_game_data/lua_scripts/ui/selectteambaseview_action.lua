
---@class SelectTeamBaseViewAction:ViewBaseAction
SelectTeamBaseViewAction = class("SelectTeamBaseViewAction",ViewBaseAction)

function SelectTeamBaseViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function SelectTeamBaseViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SelectTeamBaseViewSetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RaceSelfLevelViewSetJoinSuccess, self.RaceSelfLevelJoinSuccess)
    self:AddNotificationEvent(UINotifyEvent.ClubRaceSelfLevelViewSetJoinSuccess, self.ClubRaceSelfLevelJoinSuccess)
    self:AddNotificationEvent(UINotifyEvent.SelectTeamViewPveChapterSetData, self.PveChapterViewRefresh)
    self:AddNotificationEvent(UINotifyEvent.SelectTeamViewRaceSeniorChapterSetData, self.RaceSeniorChapterViewRefresh)
    self:AddNotificationEvent(UINotifyEvent.SelectTeamViewPveChapterSetCommon, self.PveChapterSetCommon)

end

---@return SelectTeamBaseView
function SelectTeamBaseViewAction:View()
    return self.view
end

function SelectTeamBaseViewAction:SetData(data)
    if self:View() then
        self:View():SetData(data[1],data[2])
    end
end

function SelectTeamBaseViewAction:RaceSelfLevelJoinSuccess(result)
    if self:View() then
        self:View():RaceSelfLevelJoinSuccess(result)
    end
end
function SelectTeamBaseViewAction:ClubRaceSelfLevelJoinSuccess(result)
    if self:View() then
        self:View():ClubRaceSelfLevelJoinSuccess(result)
    end
end
function SelectTeamBaseViewAction:PveChapterViewRefresh(id)
    if self:View() then
        self:View():PveChapterViewRefresh(id)
    end
end
function SelectTeamBaseViewAction:RaceSeniorChapterViewRefresh(id)
    if self:View() then
        self:View():RaceSeniorChapterViewRefresh(id)
    end
end


function SelectTeamBaseViewAction:PveChapterSetCommon(id)
    if self:View() then
        self:View():PveChapterSetCommon(id)
    end
end


return SelectTeamBaseViewAction()