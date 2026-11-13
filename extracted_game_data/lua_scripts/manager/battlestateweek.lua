


---@class BattleStateWeek:BattleStateBase
BattleStateWeek = class("BattleStateWeek", BattleStateBase)

function BattleStateWeek:initialize()

end

function BattleStateWeek:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateWeek:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end

function BattleStateWeek:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateWeek:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    BattleDataManager:Get():SetBattleResultData(result)
    BattleDataManager:Get():SetStateBattleResult()
end

function BattleStateWeek:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
    --UIManager:Get():OpenView("RaceSelfSubResultView",CanvasType.MainCanvas,"RaceSelfSubResultView")
end

function BattleStateWeek:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end