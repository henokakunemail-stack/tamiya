---@class BattleStateRaceGVG:BattleStateBase
BattleStateRaceGVG = class("BattleStateRaceGVG", BattleStateBase)

function BattleStateRaceGVG:initialize()

end

function BattleStateRaceGVG:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceGVG:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceGVG:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceGVG:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        local battleResult=nil
        local Result=""
        for i = 0, result.Length - 1 do
            if result[i].pid == PlayerDataManager:Get():GetPlayerRID() then
                battleResult = result[i]
            end
            local str= string.format("%d---%d---%d---%d---%.2f---%.2f---%.2f :",result[i].pid,result[i].rank,result[i].time,result[i].error,result[i].averageSpeed,result[i].maxSpeed,result[i].minSpeed)
            Result=string.format("%s%s",Result,str)
        end
        local GetFrameCount=BattleDataManager:Get():GetFrameCount()
        if battleResult then
            RaceGVGManager:Get():FinishBattle(battleResult.time,battleResult.rank,battleResult.error,Result,GetFrameCount)
            BattleDataManager:Get():SetBattleResultData(result)
        else
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceGVG",result)
            BattleDataManager:Get():SetBattleResultData(result)
            BattleDataManager:Get():SetStateBattleResult()
        end

    end
end

function BattleStateRaceGVG:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceGVG:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end