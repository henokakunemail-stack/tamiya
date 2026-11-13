


---@class BattleStateRaceAssemble:BattleStateBase
BattleStateRaceAssemble = class("BattleStateRaceAssemble", BattleStateBase)

function BattleStateRaceAssemble:initialize()

end

function BattleStateRaceAssemble:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceAssemble:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceAssemble:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceAssemble:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        local battleResult=nil
        for i = 0, result.Length - 1 do
            if result[i].pid == BattleDataManager:Get():GetDefaultPlayerId() then
                battleResult = result[i]
                break
            end
        end
        if battleResult then
            local data={}
            data.pid=battleResult.pid
            data.rank=battleResult.completeRank
            data.time=battleResult.time
            data.error=battleResult.error
            data.trackNum=battleResult.trackidx
            RaceAssembleSubsystem:Get():SendMsg_FinishBattle(RaceAssembleManager:Get():GetMatchId(),data.time,data.rank,data.error)
            BattleDataManager:Get():SetBattleResultData(result)
        else
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceAssemble",result)
            BattleDataManager:Get():SetBattleResultData(result)
            BattleDataManager:Get():SetStateBattleResult()
        end


    end
end

function BattleStateRaceAssemble:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceAssemble:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end