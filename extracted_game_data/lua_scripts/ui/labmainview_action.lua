---@class LabMainViewAction:ViewBaseAction
LabMainViewAction = class("LabMainViewAction", ViewBaseAction)

function LabMainViewAction:initialize()
    ViewBaseAction.initialize(self)
end

---@return LabMainView
function LabMainViewAction:View()
    return self.view
end

function LabMainViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.LabMainMenu_InitViewInfo, self.InitViewInfo)
    self:AddNotificationEvent(UINotifyEvent.LabMainMenu_OpenCurView, self.OpenCurView)
    self:AddNotificationEvent(UINotifyEvent.LabMainMenu_RefreshCurView, self.RefreshCurView)
end
function LabMainViewAction:InitViewInfo(type)
    if self:View() then
        self:View():InitViewInfo(type)
    end
end
function LabMainViewAction:OpenCurView()
    if self:View() then
        self:View():OpenCurView()
    end
end

function LabMainViewAction:RefreshCurView()
    if self:View() then
        self:View():RefreshCurView()
    end
end
return LabMainViewAction()

