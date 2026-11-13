---@class BattleStateRaceCarGod:BattleStateBase
BattleStateRaceCarGod = class("BattleStateRaceCarGod", BattleStateBase)

function BattleStateRaceCarGod:initialize()

end

function BattleStateRaceCarGod:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceCarGod:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceCarGod:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceCarGod:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    --if self.State == BattleState.Fighting then
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
            RaceCarGodDataManager:Get():AddBattleResult(BattleDataManager:Get():GetLevelId(),BattleDataManager:Get():GetSelfCarId() ,isWin,battleResult.time, battleResult.error, BattleDataManager:Get():GetBattleResultData(),startTime,recordValue)
            if battleResult==nil then
                BattleStateBase.TrackBattleResultErrorLog(self,"RaceCarGod",result)
                BattleDataManager:Get():SetStateBattleResult()
            end
        end
    --end
end

function BattleStateRaceCarGod:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceCarGod:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end