
---@class GameStartViewAction
GameStartViewAction = class("GameStartViewAction",ViewBaseAction)

function GameStartViewAction:initialize()
    ViewBaseAction.initialize(self)

    print("game start action .....................")
end


---@return GameStartView
function GameStartViewAction:View()
    return self.view
end

function GameStartViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.GameStartView_UpdateServerInfo, self.InitServerData)
    self:AddNotificationEvent(UINotifyEvent.GameStartView_InitServerInfo, self.InitServerInfo)
    self:AddNotificationEvent(UINotifyEvent.GameStartView_ServerMaintain, self.ServerMaintain)
    self:AddNotificationEvent(UINotifyEvent.GameStartView_InitBtnInfo, self.InitBtnInfo)
    self:AddNotificationEvent(UINotifyEvent.GameStartView_InitCG, self.InitCG)
    self:AddNotificationEvent(UINotifyEvent.GameStartView_CloseLoginPanelCG, self.CloseLoginPanelCG)
    self:AddNotificationEvent(UINotifyEvent.GameStartView_InitServer, self.InitServerOneInfo)
    self:AddNotificationEvent(UINotifyEvent.GameStartView_ReOpenServerInfo, self.ReOpenServerInfo)


end



function GameStartViewAction:InitServerInfo()
    if self:View() then
        self:View():InitServerInfo()
    end
end

function GameStartViewAction:ServerMaintain(data)
    if self:View() then
        self:View():ServerMaintain(data)
   end
end

function GameStartViewAction:InitServerData(serverInfo)
    if self:View() then
        print("---   填充当前服务器")
        self:View():InitServerData(serverInfo)
    end
end
function GameStartViewAction:InitBtnInfo(isEnable)
   if self:View() then
        self:View():InitBtnInfo(isEnable)
    end
end

function GameStartViewAction:InitCG(isHaveLogin)
    cs_coroutine.start(function()
        if UIManager:Get():IsViewShow("GameStartView")==false then
            coroutine.yield()
            UIManager:Get():OpenView("GameStartView", CanvasType.FrontCanvas, "GameStartView", false, true)
        end
        if self:View() then
            self:View():InitCG(isHaveLogin)
        end
    end)
end
function GameStartViewAction:InitServerOneInfo(serverInfo)
    if self:View() then
    self:View():InitServerOneInfo(serverInfo)
   end
end
function GameStartViewAction:ReOpenServerInfo()
    if self:View() then
    self:View():ReOpenServerInfo()
   end
end

function GameStartViewAction:CloseLoginPanelCG(isHaveLogin)
    cs_coroutine.start(function()
        if UIManager:Get():IsViewShow("GameStartView")==false then
            coroutine.yield()
            UIManager:Get():OpenView("GameStartView", CanvasType.FrontCanvas, "GameStartView", false, true)
        end
        if self:View() then
            self:View():CloseLoginPanelCG(isHaveLogin)
        end
    end)
end

function GameStartViewAction:InitServer(serverData)
    if self:View() then
    self:View():InitServerOneInfo(serverData)
    end
end



function GameStartViewAction:ShowAnnouncementInfo()

end
return GameStartViewAction()