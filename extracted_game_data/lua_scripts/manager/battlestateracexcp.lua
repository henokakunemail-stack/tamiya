


---@class BattleStateRaceXcp:BattleStateBase
BattleStateRaceXcp = class("BattleStateRaceXcp", BattleStateBase)

function BattleStateRaceXcp:initialize()

end

function BattleStateRaceXcp:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceXcp:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceXcp:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceXcp:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
        if  RaceXCupManager:Get():GetRaceType() == RaceJcpRaceType.Record then
            BattleDataManager:Get():SetStateBattleResult()
            return
        end

        local battleResult=nil
        local Result=""
        for i = 0, result.Length - 1 do
            if result[i].pid == PlayerDataManager:Get():GetPlayerRID() then
                battleResult = result[i]
            end
            local str= string.format("%d---%d---%d---%d---%.2f---%.2f---%.2f :",result[i].pid,result[i].rank,result[i].time,result[i].error,result[i].averageSpeed,result[i].maxSpeed,result[i].minSpeed)
            Result=string.format("%s%s",Result,str)
        end
        if battleResult then
            RaceXCupManager:Get():FinishBattle(battleResult.time,battleResult.rank,battleResult.error,Result)
        else
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceXcp",result)
            BattleDataManager:Get():SetStateBattleResult()
        end


    end
end

function BattleStateRaceXcp:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceXcp:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end