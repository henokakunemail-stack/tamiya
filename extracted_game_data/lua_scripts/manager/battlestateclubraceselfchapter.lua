


---@class BattleStateClubRaceSelfChapter:BattleStateBase
BattleStateClubRaceSelfChapter = class("BattleStateClubRaceSelfChapter", BattleStateBase)

function BattleStateSelfChallenge:initialize()

end

function BattleStateClubRaceSelfChapter:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateClubRaceSelfChapter:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateClubRaceSelfChapter:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateClubRaceSelfChapter:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)

    local  ChapterData=ClubRaceSelfChapterDataManager:Get():GetChapterData()
    local battleResult=nil
    for i = 0, result.Length - 1 do
        if result[i].pid == PlayerDataManager:Get():GetPlayerUID() then
            battleResult = result[i]
            break
        end
    end
    local data={}
    data.pid=battleResult.pid
    data.rank=battleResult.completeRank
    data.time=battleResult.time
    data.error=battleResult.error
    data.trackNum=battleResult.trackidx
    ClubRaceSelfChapterSubsystem:Get():SendMsg_SelfChapterFinishRace(ChapterData.id,data)
    if BattleDataManager:Get():IsReplay() then
        --BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
    end
end

function BattleStateClubRaceSelfChapter:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateClubRaceSelfChapter:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end