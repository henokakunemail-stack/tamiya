---@class BattleStateRank:BattleStateBase
BattleStateRank = class("BattleStateRank", BattleStateBase)

function BattleStateRank:initialize()
    self.TimerID = -1
end

function BattleStateRank:SetStateLoading()
    BattleStateBase.SetStateLoading(self)

    if MatchManager:Get():IsReconnectOnLogin() then
        return
    end
    if BattleDataManager:Get():IsReplay() then
        return
    end
    self:StartTimer()
end

function BattleStateRank:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    if BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetStateFighting()
        return
    end

    --if MatchManager:Get():IsReconnectOnLogin() and RaceRankManager:Get():GetRoomState() == SerE_RaceRankState.Fight then
    --    BattleDataManager:Get():SetStateFighting()
    --    return
    --end
    -- RaceRankManager:Get():UpdateRoomState(SerE_RaceRankState.Fight)
    BattleDataManager:Get():SetStateFighting()
    -- RaceRankSubsystem:Get():SendMsg_LoadingProcess(100)
    self:StopTimer()
end

function BattleStateRank:SetStateFighting(time)
    BattleStateBase.SetStateFighting(self, time)
    if MatchManager:Get():IsReconnectOnLogin() and RaceRankManager:Get():GetRoomState() == SerE_RaceRankState.Fight then
        log("---   天梯赛重连，战斗快进", RaceRankManager:Get():GetFightTime())
        local fighttime = RaceRankManager:Get():GetFightTime()
        if fighttime > 0 then
            local time = CommonHelper:SubTime(RaceRankManager:Get():GetFightTime())
            BattleStateBase.JumpRacing(self, time)
        end
    end
end

function BattleStateRank:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)

    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() or RaceRankManager:Get():GetRaceType()==RaceRankRaceType.Test then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        --RaceRankManager:Get():UpdateRoomState(SerE_RaceRankState.Result)
        BattleDataManager:Get():SetBattleResultData(result)
        RaceRankSubsystem:Get():SendMsg_BattleFinish(result,RaceRankManager:Get():GetRoomId(),self:AppendBattleResult())
    end
end

function BattleStateRank:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRank:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end

function BattleStateRank:StartTimer()
    self:StopTimer()
    self.TimerID = TimerManager:Get():CreateTimerLoop(1, function()
        local value = SceneManager:Get():GetLoadingProcess()
        if value then
            local value = math.modf(value * 100)
            if value >= 100 then
                value = 99
                self:StopTimer()
            end
        end
    end)
end

function BattleStateRank:StopTimer()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end