---@class BattleStateChallenge:BattleStateBase
BattleStateChallenge = class("BattleStateChallenge", BattleStateBase)

function BattleStateChallenge:initialize()

end

function BattleStateChallenge:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateChallenge:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end

function BattleStateChallenge:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateChallenge:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)

    local time = 0
    local rank = 0
    local error = 0
    local loop = result.Length - 1
    for i = 0, loop do
        if result[i].pid == PlayerDataManager:Get():GetPlayerRID() then
            rank = result[i].completeRank
            time = result[i].time
            error = result[i].error
            break
        end
    end

    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
        local startTime=PlayerPrefsHelper:GetValue_SelfCountDownBtnUpTime()
        local recordValue = PlayerPrefsHelper:GetValue_ReplayInputInfos()..self:AppendBattleResult()
        local car=  SpecialTrainingDataManager:Get():GetCurSelectCarData()
        local times=tostring(time)
        local startTimes=tostring(startTime)
        local recordValues=tostring(recordValue)
        if car then
            local  cars=stringSplitToNumber(car,":")
            for i = 2, #cars do
                times=times..":0"
                startTimes=startTimes..":0"
                recordValues=recordValues..":0"
            end
        end
        ChallengeSubsystem:Get():SendFinishChallenge(rank,time,error,times,startTimes,recordValues)
    end
end

function BattleStateChallenge:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")

end

function BattleStateChallenge:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end