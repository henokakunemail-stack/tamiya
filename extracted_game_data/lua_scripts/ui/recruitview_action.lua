---@class RecruitViewAction:ViewBaseAction
RecruitViewAction = class("RecruitViewAction", ViewBaseAction)

function RecruitViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function RecruitViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.RecruitView_InitViewInfo, self.InitViewInfo)
    self:AddNotificationEvent(UINotifyEvent.RecruitView_SetData, self.SetData)
    self:AddNotificationEvent(UINotifyEvent.RecruitView_PlayAni, self.PlayAni)
    self:AddNotificationEvent(UINotifyEvent.RecruitView_SkipAni, self.SkipAni)

    self:AddNotificationEvent(UINotifyEvent.RecruitView_InitBtn, self.InitBtn)
    self:AddNotificationEvent(UINotifyEvent.RecruitView_StartCountTime, self.StartCountTime)
    self:AddNotificationEvent(UINotifyEvent.RecruitView_UpdateRecruitList, self.InitRecruitTypeList)
    self:AddNotificationEvent(UINotifyEvent.RecruitView_OnRecruitClick, self.OnRecruitClick)
end

---@return RecruitView
function RecruitViewAction:View()
    return self.view
end

function RecruitViewAction:InitViewInfo()
    if self:View() then
        self:View():InitViewInfo()
    end
end
function RecruitViewAction:SetData(reset)
    if self:View() then
        self:View():SetData(reset)
    end
end

function RecruitViewAction:SkipAni()
    if self:View() then
        self:View():SkipAni()
    end
end

function RecruitViewAction:PlayAni(msg)
    if self:View() then
        self:View():PlayAni(msg)
    end
end

function RecruitViewAction:InitBtn(isDelay)
    if self:View() then
        self:View():InitBtn(isDelay)
    end
end

function RecruitViewAction:StartCountTime(recruitData)
    if self:View() then
        self:View():StartCountTime(recruitData)
    end
end

function RecruitViewAction:InitRecruitTypeList()
    if self:View() then
        self:View():InitRecruitTypeList(false)
    end
end
function RecruitViewAction:OnRecruitClick(count)
    if self:View() then
        self:View():OnRecruitBtnClick(count)
    end
end

return RecruitViewAction()