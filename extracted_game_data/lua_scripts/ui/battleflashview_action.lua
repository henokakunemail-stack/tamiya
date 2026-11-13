---@class BattleFlashViewAction:ViewBaseAction
BattleFlashViewAction = class("BattleFlashViewAction",ViewBaseAction)

function BattleFlashViewAction:initialize()
    ViewBaseAction.initialize(self)
end

function BattleFlashViewAction:OnRegisterEvents()
 self:AddNotificationEvent(UINotifyEvent.BattleFlashView_SetSkillUI,self.SetSkillUI)
end

---@return BattleFlashView
function BattleFlashViewAction:View()
    return self.view
end
function BattleFlashViewAction:SetSkillUI(carId)
    self:View():SetSkillUI(carId)
end


return BattleFlashViewAction()