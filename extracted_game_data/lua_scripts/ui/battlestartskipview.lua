---@class BattleStartSkipView : ViewBase
BattleStartSkipView = class("BattleStartSkipView", ViewBase)

function BattleStartSkipView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "BattleStartSkipViewAction")
end

function BattleStartSkipView:Awake()
    self. BtnSkip = CommonHelper:HButtonSetCallback("BtnSkip", self.gameObject, function()
        MonoHelper:BattleSkipStartCamera()
    end)
end

function BattleStartSkipView:OnOpen()
    --BattleDataManager:Get():SetIsCupShow(CupAnimHelper:ShowCupAnimByRaceModel(BattleDataManager:Get():GetBattleType()))
end
function BattleStartSkipView:OnClose()
    CupAnimHelper:Release()
end
function BattleStartSkipView:OnAutoClose()
    CupAnimHelper:Release()
end

function BattleStartSkipView:OnBackKey()

end

