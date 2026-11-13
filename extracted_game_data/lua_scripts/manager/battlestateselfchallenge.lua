


---@class BattleStateSelfChallenge:BattleStateBase
BattleStateSelfChallenge = class("BattleStateSelfChallenge", BattleStateBase)

function BattleStateSelfChallenge:initialize()

end

function BattleStateSelfChallenge:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateSelfChallenge:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateSelfChallenge:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateSelfChallenge:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)

    local  ChapterData=SelfChallengeDataManager:Get():GetChapterData()
    local data={}
    data.rank=result[0].completeRank
    data.time=result[0].time
    data.error=result[0].error
    SelfChallengeSubsystem:Get():SendFinishSelfChallenge(ChapterData.id,SelfChallengeDataManager:Get().LevelId,data)
    if BattleDataManager:Get():IsReplay() then
       -- BattleDataManager:Get():SetStateBattleResult()
    else

    end
end

function BattleStateSelfChallenge:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateSelfChallenge:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end