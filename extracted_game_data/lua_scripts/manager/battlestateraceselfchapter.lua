


---@class BattleStateRaceSelfChapter:BattleStateBase
BattleStateRaceSelfChapter = class("BattleStateRaceSelfChapter", BattleStateBase)

function BattleStateSelfChallenge:initialize()

end

function BattleStateRaceSelfChapter:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceSelfChapter:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceSelfChapter:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateRaceSelfChapter:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)

    local  ChapterData=RaceSelfChapterDataManager:Get():GetCurLevel()
    local battleResult=nil
    local NpcFestTime=0
    for i = 0, result.Length - 1 do
        if result[i].pid ==BattleDataManager:Get():GetDefaultPlayerId() then
            battleResult = result[i]
        else
            if result[i].time>0 then
                if NpcFestTime==0 then
                    NpcFestTime=result[i].time
                end
                if NpcFestTime>result[i].time then
                    NpcFestTime=result[i].time
                end
            end
        end
    end
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetStateBattleResult()
    else
        if battleResult then
            local data={}
            data.pid=battleResult.pid
            data.rank=battleResult.completeRank>=1 and 1 or 0
            data.time=battleResult.time
            data.error=battleResult.error
            data.trackNum=battleResult.trackidx
            local duration=NpcFestTime-data.time
            RaceSelfChapterSubsystem:Get():SendMsg_SelfChapterFinishRace(ChapterData.C_ID,data.rank,data.time,data.error,battleResult.completeRank,NpcFestTime)
        end
        BattleDataManager:Get():SetBattleResultData(result)
        if battleResult==nil then
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceSelfChapter",result)
            BattleDataManager:Get():SetStateBattleResult()
        end
    end
end

function BattleStateRaceSelfChapter:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceSelfChapter:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end