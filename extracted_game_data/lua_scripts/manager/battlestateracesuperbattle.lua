---@class BattleStateRaceSuperBattle:BattleStateBase
BattleStateRaceSuperBattle = class("BattleStateRaceSuperBattle", BattleStateBase)

function BattleStateRaceSuperBattle:initialize()

end

function BattleStateRaceSuperBattle:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceSuperBattle:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceSuperBattle:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

---@param result @是c#传过来的数组，在battle helper脚本里面有方法 BattleEndPVP
function BattleStateRaceSuperBattle:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    local battleResult, isWin = BattleDataManager:Get():AnalyzeResult(result)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
        --local startTime=PlayerPrefsHelper:GetValue_SelfCountDownBtnUpTime()
        --RaceSeniorTrainSubsystem:Get():SendMsg_BattleFinish(BattleDataManager:Get():GetLevelId(),BattleDataManager:Get():GetSelfCarId() ,isWin, battleResult.time, battleResult.error,startTime)
    end
end

function BattleStateRaceSuperBattle:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    --UIManager:Get():CloseView()--关闭战斗中UI

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceSuperBattle:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end