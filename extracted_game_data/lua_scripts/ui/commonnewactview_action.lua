----@class CommonNewActViewAction
CommonNewActViewAction = class("CommonNewActViewAction", ViewBaseAction)

function CommonNewActViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function CommonNewActViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.CommonAct_RefreshChooseBtn, self.InitChooseData)
    self:AddNotificationEvent(UINotifyEvent.CommonAct_RefreshPage, self.RefreshActPage)
    self:AddNotificationEvent(UINotifyEvent.CommonAct_OpenPage, self.OpenActPage)
    self:AddNotificationEvent(UINotifyEvent.CommonFestival_RefreshLimitTaskTurn, self.LimitTaskTurn)
    self:AddNotificationEvent(UINotifyEvent.CommonAct_PageRunAction, self.PageRunAction)
    self:AddNotificationEvent(UINotifyEvent.CommonAct_RefreshReOpen, self.ReOpen)
end

---@return  CommonNewActView
function CommonNewActViewAction:View()
    return self.view
end

function CommonNewActViewAction:InitChooseData()
    if self:View() then
        self:View():InitChooseData()
    end
end

function CommonNewActViewAction:RefreshActPage(data)
    if self:View() then
        self:View():RefreshActPage(data[1], data[2])
    end
end

function CommonNewActViewAction:OpenActPage(actId)
    if self:View() then
        self:View():OpenActPage(actId)
    end
end

function CommonNewActViewAction:LimitTaskTurn(taskID)
    if self:View() then
        self:View():LimitTaskTurn(taskID)
    end
end

function CommonNewActViewAction:ReOpen()
    if self:View() then
        self:View():ReOpen()
    end
end

---P1: actId(-1:当前打开的活动)  P2:分頁方法名  P3P4P5... 参数
function CommonNewActViewAction:PageRunAction(data)
    if self:View() then
        self:View():PageRunAction(data)
    end
end

return CommonNewActViewAction()