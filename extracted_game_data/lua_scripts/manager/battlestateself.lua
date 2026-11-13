


---@class BattleStateSelf:BattleStateBase
BattleStateSelf = class("BattleStateSelf", BattleStateBase)

function BattleStateSelf:initialize()

end

function BattleStateSelf:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateSelf:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end

function BattleStateSelf:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateSelf:SetStateBattleFinish()
    BattleStateBase.SetStateBattleFinish(self)

    BattleDataManager:Get():SetStateBattleResult()
end

function BattleStateSelf:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
    --UIManager:Get():OpenView("RaceSelfSubResultView",CanvasType.MainCanvas,"RaceSelfSubResultView")
end

function BattleStateSelf:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end