---@class BattleStateRaceClub3v3:BattleStateBase
BattleStateRaceClub3v3 = class("BattleStateRaceClub3v3", BattleStateBase)

function BattleStateRaceClub3v3:initialize()

end

function BattleStateRaceClub3v3:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceClub3v3:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceClub3v3:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceClub3v3:SetStateBattleFinish(result)
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
        local curBat=RaceClub3V3Manager:Get().BattleCount-RaceClub3V3Manager:Get().Queue:GetSize()
        local lastFlag=RaceClub3V3Manager:Get().Queue:GetSize()==0 and 1  or 0
        print(curBat,lastFlag)
        if battleResult then
            RaceClub3v3Subsystem:Get():SendMsg_FinishBattle(battleResult.time,battleResult.rank,battleResult.error,Result,GetFrameCount,curBat,lastFlag)
            BattleDataManager:Get():SetBattleResultData(result)
        else
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceClub3v3",result)
            BattleDataManager:Get():SetBattleResultData(result)
            BattleDataManager:Get():SetStateBattleResult()
        end
    end
end

function BattleStateRaceClub3v3:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceClub3v3:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end