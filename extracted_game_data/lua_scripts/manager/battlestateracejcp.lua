


---@class BattleStateRaceJcp:BattleStateBase
BattleStateRaceJcp = class("BattleStateRaceJcp", BattleStateBase)

function BattleStateRaceJcp:initialize()

end

function BattleStateRaceJcp:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceJcp:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceJcp:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceJcp:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
        if  RaceJcpManager:Get():GetRaceType() == RaceJcpRaceType.Record then
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
            RaceJcpManager:Get():FinishBattle(battleResult.time,battleResult.rank,battleResult.error,Result)
        else
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceJcp",result)
            BattleDataManager:Get():SetStateBattleResult()
        end


    end
end

function BattleStateRaceJcp:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceJcp:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end