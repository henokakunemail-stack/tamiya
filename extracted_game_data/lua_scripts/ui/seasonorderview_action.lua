---@class SeasonOrderViewAction:ViewBaseAction
SeasonOrderViewAction = class("SeasonOrderViewAction", ViewBaseAction)

function SeasonOrderViewAction:initialize()
    ViewBaseAction.initialize(self)
end
---@return SeasonOrderView
function SeasonOrderViewAction:View()
    return self.view
end

function SeasonOrderViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.SeasonOrderView_SetData,self.SetData)
    self:AddNotificationEvent(UINotifyEvent.SeasonOrderView_BuyFinish,self.SetBuyFinish)
    self:AddNotificationEvent(UINotifyEvent.SeasonOrderView_SetLuaViewInfo, self.SetLuaViewInfo)
end


function SeasonOrderViewAction:SetData(data)
    if self:View() then
       self:View():SetData(data[1],data[2])
    end
end
function SeasonOrderViewAction:SetBuyFinish()
    if self:View() then
        self:View():BuyFinish()
    end
end
function SeasonOrderViewAction:SetLuaViewInfo(data)
    if self:View() then
        self:View():SetLuaViewInfo(data[1],data[2])
    end
end

return SeasonOrderViewAction()