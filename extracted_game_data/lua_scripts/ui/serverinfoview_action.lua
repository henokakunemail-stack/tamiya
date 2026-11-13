
---@class ServerInfoViewAction:ViewBaseAction
ServerInfoViewAction = class("ServerInfoViewAction",ViewBaseAction)

function ServerInfoViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return ServerInfoView
function ServerInfoViewAction:View()
    return self.view
end
function ServerInfoViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.UpdateServerInfo, self.InitServerData)
end

function ServerInfoViewAction:InitServerData(serverInfo)
    print("---   填充当前服务器")
    if self:View() then
        self:View():InitServerData(serverInfo)
    end
end
return ServerInfoViewAction()