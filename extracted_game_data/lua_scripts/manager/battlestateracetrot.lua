


---@class BattleStateRaceTrot:BattleStateBase
BattleStateRaceTrot = class("BattleStateRaceTrot", BattleStateBase)

function BattleStateRaceTrot:initialize()

end

function BattleStateRaceTrot:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceTrot:SetStateLoadFinish()

    BattleStateBase.SetStateLoadFinish(self)
    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceTrot:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
    self:testStopCrash()
end
function BattleStateRaceTrot:testStopCrash()
    local raceManager = monoRaceManager
    if raceManager then
        local lockStepManager =monoRaceManager.lockstepManager
        if lockStepManager then
            local room = lockStepManager._room
            if room then
                local allCars = room._allCars

                if allCars then
                    local carCount =allCars.Count

                    --for n=1, 3 do
                    --for i = 1, carCount do
                    for i = 1, carCount do
                        local car = allCars[i-1]
                        if not car.IsSelf then
                            local carStaticData = car._carStaticData
                            carStaticData.initProtectGas = CS.Lockstep.Math.Fix64(false, 500000)
                        end
                    end
                end
            end
        end
    end
end

function BattleStateRaceTrot:SetStateBattleFinish(result)
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
            data.backHitCrashOtherCount=battleResult.backHitCrashOtherCount
            RaceTrotManager:Get():SetError(data.error)
           -- RaceTrotSubsystem:Get():SendMsg_FinishBattle(data.time,data.rank,data.error,data.backHitCrashOtherCount,0)
            RaceTrotSubsystem:Get():SendMsg_FinishBattle(data.time,data.rank,data.error,0,0)
        end
        BattleDataManager:Get():SetBattleResultData(result)
        if battleResult==nil then
            BattleStateBase.TrackBattleResultErrorLog(self,"RaceTrot",result)
            BattleDataManager:Get():SetStateBattleResult()
        end
    end
end

function BattleStateRaceTrot:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceTrot:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end