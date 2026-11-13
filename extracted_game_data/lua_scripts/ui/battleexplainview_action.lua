


---@class BattleExplainViewAction
BattleExplainViewAction = class("BattleExplainViewAction",ViewBaseAction)

function BattleExplainViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleExplainViewAction:OnRegisterEvents()
    self:AddNotificationEvent(UINotifyEvent.BattleExplainView_ShowTips, self.ShowTips)
end
---@return BattleExplainView
function BattleExplainViewAction:View()
    return self.view
end

function BattleExplainViewAction:ShowTips(param)
    local isShow = UIManager:Get():IsPersistentViewShow("BattleExplainView")
    if isShow == false then
        UIManager:Get():ShowPersistentView("BattleExplainView", CanvasType.TopCanvas, "BattleExplainView")
    end
    self:View():ShowTips(param)
end



return BattleExplainViewAction()