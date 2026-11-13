
---@class GameBindViewAction:ViewBaseAction
GameBindViewAction = class("GameBindViewAction",ViewBaseAction)

function GameBindViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function GameBindViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.Game4WDBind_SetData, self.SetData)

end

---@return GameBindView
function GameBindViewAction:View()
    return self.view
end
function GameBindViewAction:SetData(data)
   self:View():SetData(data[1],data[2])
end



return GameBindViewAction()