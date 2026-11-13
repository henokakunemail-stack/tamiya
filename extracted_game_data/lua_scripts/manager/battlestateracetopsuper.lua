


---@class BattleStateRaceTopSuper:BattleStateBase
BattleStateRaceTopSuper = class("BattleStateRaceTopSuper", BattleStateBase)

function BattleStateRaceTopSuper:initialize()

end

function BattleStateRaceTopSuper:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceTopSuper:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceTopSuper:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceTopSuper:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
        if  RaceTopSuperManager:Get():GetRaceType() == RaceTopRaceType.Record then
            BattleDataManager:Get():SetStateBattleResult()
            return
        end

        local battleResult=nil
        local Result=""
        for i = 0, result.Length - 1 do
            if result[i].pid == BattleDataManager:Get():GetDefaultPlayerId() then
                battleResult = result[i]
            end
            local str= string.format("%d---%d---%d---%d---%.2f---%.2f---%.2f :",result[i].pid,result[i].rank,result[i].time,result[i].error,result[i].averageSpeed,result[i].maxSpeed,result[i].minSpeed)
            Result=string.format("%s%s",Result,str)
        end
        if battleResult then
            local startTime=PlayerPrefsHelper:GetValue_SelfCountDownBtnUpTime()
            local recordValue = PlayerPrefsHelper:GetValue_ReplayInputInfos()..self:AppendBattleResult()
            RaceTopSuperManager:Get():FinishBattle(battleResult.time,battleResult.rank,battleResult.error,Result,startTime,recordValue)
        else
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceTop",result)
            BattleDataManager:Get():SetStateBattleResult()
        end
    end
end

function BattleStateRaceTopSuper:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceTopSuper:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end