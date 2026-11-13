


---@class BattleStateClubRaceSelfLevel:BattleStateBase
BattleStateClubRaceSelfLevel = class("BattleStateClubRaceSelfLevel", BattleStateBase)

function BattleStateClubRaceSelfLevel:initialize()

end

function BattleStateClubRaceSelfLevel:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateClubRaceSelfLevel:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateClubRaceSelfLevel:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateClubRaceSelfLevel:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)

    local  levelData=ClubRaceSelfLevelDataManager:Get():GetLevelData()
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
    ClubRaceSelfLevelSubsystem:Get():SendMsg_SelfLevelFinishRace(levelData.id,data)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        -- BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
    end
end

function BattleStateClubRaceSelfLevel:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateClubRaceSelfLevel:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end