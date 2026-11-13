---@class MainMuneAction:ViewBaseAction
MainMenuAction = class("MainMenuAction", ViewBaseAction)

function MainMenuAction:initialize()
    ViewBaseAction.initialize(self)
end

function MainMenuAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.MainMenuView_InitBtnInfo, self.InitBtnInfo)
    self:AddNotificationEvent(UINotifyEvent.MainMenuView_UpdateChatText, self.UpdateChatText)
    self:AddNotificationEvent(UINotifyEvent.MainMenuView_InitMainChatInfo, self.InitMainChatInfo)
    self:AddNotificationEvent(UINotifyEvent.MainMenuView_RefreshFirstBuyRedPoint, self.RefreshFirstBuyRedPoint)
    self:AddNotificationEvent(UINotifyEvent.MainMenuView_RefreshActivityMidBtn, self.RefreshCommonActBtn)
    self:AddNotificationEvent(UINotifyEvent.MainMenuView_RefreshReturnOldPlayerBtn, self.RefreshReturnOldPlayerBtn)
    self:AddNotificationEvent(UINotifyEvent.MainMenuView_SetLuaViewInfo, self.SetLuaViewInfo)
    self:AddNotificationEvent(UINotifyEvent.MainMenuView_RefreshTestGift, self.RefreshTestGiftBtn)
end

---@return MainMenu
function MainMenuAction:View()
    return self.view
end

function MainMenuAction:InitBtnInfo()
    if self:View() then
        self:View():InitBtnInfo()
    end
end

function MainMenuAction:UpdateChatText(userdata)
    if self:View() then
        self:View():UpdateChatText(userdata[1], userdata[2])
    end
end

function MainMenuAction:InitMainChatInfo()
    if self:View() then
        self:View():InitMainChatInfo()
    end
end

function MainMenuAction:RefreshFirstBuyRedPoint()
    if self:View() then
        self:View():RefreshFirstBuyRedPoint()
    end
end

function MainMenuAction:RefreshCommonActBtn()
    if self:View() then
        self:View():RefreshCommonActBtn()
    end
end

function MainMenuAction:RefreshReturnOldPlayerBtn()
    if self:View() then
        self:View():RefreshReturnOldPlayerBtn()
    end
end

function MainMenuAction:SetLuaViewInfo(data)
    if self:View() then
        if data~="Check" then
            self:View():SetLuaViewInfo("Check",true)
        end
        if data~="GuideCheck" then
            self:View():SetLuaViewInfo("GuideCheck",true)
        end
        self:View():SetLuaViewInfo(data[1],data[2])
    end
end


function MainMenuAction:RefreshTestGiftBtn()
    if self:View() then
        self:View():RefreshTestGiftBtn()
    end
end

return MainMenuAction()