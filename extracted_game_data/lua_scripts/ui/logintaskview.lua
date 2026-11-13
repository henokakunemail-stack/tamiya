---@class LoginTaskView : ViewBase
LoginTaskView = class("LoginTaskView", ViewBase)

function LoginTaskView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "LoginTaskViewAction")
end

function LoginTaskView:Awake()
    self:CacheData()
end

function LoginTaskView:CacheData()
    self.togTab = {}
    self.pageTab = {}
    self:InitData()

    self.pageLogin = Page_LoginTaskSignView(self.pageTab[1].gameObject)
    self.pageTask = Page_LoginNoviceTaskView()
    self.pageTask:SetRoot(self.pageTab[2].gameObject)

    self.selectIdx = nil

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function()
        UIManager:Get():HidePersistentView("LoginTaskView")
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"LoginTaskView",false})
    end)
end

function LoginTaskView:OnOpen()
    CommonHelper:SetHButtonClick(self.togTab[2], PlayerDataManager:Get():GetSevenDayTask(), true)
    CommonHelper:SetHButtonClick(self.togTab[1], PlayerDataManager:Get():GetSevenSign(), true)
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_Login)
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_Sign)
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_NoviceTask)
end
function LoginTaskView:OnClose()
    self.selectIdx = nil
    CommonHelper:ReleasePool(UIModuleID.TaskLogin)
    PopupManager:Get():FirstPopupOnClose()
end
function LoginTaskView:OnBackKey()
    UIManager:Get():HidePersistentView("LoginTaskView")
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"LoginTaskView",false})
end

function LoginTaskView:AutoClose()
    self.selectIdx = nil
    CommonHelper:ReleasePool(UIModuleID.TaskLogin)
end
function LoginTaskView:InitData()
    for i = 1, 2 do
        local tog = CommonHelper:HButtonSetCallback("Tog" .. i, self.gameObject, function()
            if i==2 then
                TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.Day7)
            end
            if i==1 then
                LoginTaskSubSystem:Get():SendMsg_GetSignInInfo()
            end
        end)

        local CG = self:GetChildWightByParent("Page" .. i, self.gameObject, typeof(CanvasGroup))
        table.insert(self.togTab, tog)
        table.insert(self.pageTab, CG)
    end
end

function LoginTaskView:InitTaskLoginInfo(msg)
    LoginTaskDataManager:Get():SetBtnFlag(1)
    self:OnTogClick(1)
    if self.pageLogin ~= nil then
        self.pageLogin:InitTaskLoginInfo(msg)
    end
end
function LoginTaskView:RefreshTaskLoginInfo(msg)
    if self.pageLogin ~= nil then
        self.pageLogin:RefreshTaskLoginInfo(msg)
    end
end

function LoginTaskView:SetNoviceData()
    LoginTaskDataManager:Get():SetBtnFlag(2)
    self:OnTogClick(2)
    if self.pageTask ~= nil then
        self.pageTask:SetData()
    end
end

function LoginTaskView:RefreshCurNoviceView()
    if self.pageTask ~= nil then
        self.pageTask:RefreshCurView()
    end
end

function LoginTaskView:OnTogClick(idx)
    if self.selectIdx ~= idx then
        for i = 1, #self.togTab do
            CommonHelper:SetToggleState(self.togTab[i], i == idx)

            UIUtil.ShowCanvasGroup(self.pageTab[i], i == idx)
        end
        self.selectIdx = idx
    end
end



