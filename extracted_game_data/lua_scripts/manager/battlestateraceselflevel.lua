


---@class BattleStateRaceSelfLevel:BattleStateBase
BattleStateRaceSelfLevel = class("BattleStateRaceSelfLevel", BattleStateBase)

function BattleStateRaceSelfLevel:initialize()

end

function BattleStateRaceSelfLevel:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceSelfLevel:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceSelfLevel:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceSelfLevel:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        ---@type SC_RetBeginBattle
        local  levelData=ChallengeMatchManager:Get():GetRetJoinBattleData()
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
            ChallengeMatchSubsystem:Get():SendMsg_FinishBattle(levelData.battleid,data.time,data.rank,data.error)
            BattleDataManager:Get():SetBattleResultData(result)
        else
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceSelfLevel",result)
            BattleDataManager:Get():SetBattleResultData(result)
            BattleDataManager:Get():SetStateBattleResult()
        end


    end
end

function BattleStateRaceSelfLevel:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceSelfLevel:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end