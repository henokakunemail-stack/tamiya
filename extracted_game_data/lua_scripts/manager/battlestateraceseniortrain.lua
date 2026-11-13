---@class BattleStateRaceSeniorTrain:BattleStateBase
BattleStateRaceSeniorTrain = class("BattleStateRaceSeniorTrain", BattleStateBase)

function BattleStateRaceSeniorTrain:initialize()

end

function BattleStateRaceSeniorTrain:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceSeniorTrain:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceSeniorTrain:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

---@param result @是c#传过来的数组，在battle helper脚本里面有方法 BattleEndPVP
function BattleStateRaceSeniorTrain:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    local battleResult, isWin = BattleDataManager:Get():AnalyzeResult(result)
    isWin=BattleDataManager:Get():GetSelfError(result)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
        local startTime=PlayerPrefsHelper:GetValue_SelfCountDownBtnUpTime()
        local recordValue = PlayerPrefsHelper:GetValue_ReplayInputInfos()..self:AppendBattleResult()
        if CommonHelper:IsNullOrEmpty(recordValue) then
            recordValue="0"
        end
        RaceSeniorTrainSubsystem:Get():SendMsg_BattleFinish(BattleDataManager:Get():GetLevelId(),BattleDataManager:Get():GetSelfCarId() ,isWin, battleResult.time, battleResult.error,startTime,battleResult.rank,recordValue)
    end
end

function BattleStateRaceSeniorTrain:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    --UIManager:Get():CloseView()--关闭战斗中UI

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceSeniorTrain:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end