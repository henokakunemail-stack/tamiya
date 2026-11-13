---@class BattleStateRoom:BattleStateBase
BattleStateRoom = class("BattleStateRoom", BattleStateBase)

function BattleStateRoom:initialize()

end

function BattleStateRoom:SetStateLoading()
    BattleStateBase.SetStateLoading(self)

    if MatchManager:Get():IsReconnectOnLogin() then
        return
    end

   -- self:StartTimer()
end

function BattleStateRoom:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    --if MatchManager:Get():IsReconnectOnLogin() and RaceRoomManager:Get():GetRoomState() == SerE_RaceRoomState.Fight then
    --    BattleDataManager:Get():SetStateFighting()
    --    return
    --end
    BattleDataManager:Get():SetStateFighting()
   -- RaceRoomSubsystem:Get():SendMsg_LoadingProgress(100)
   -- self:StopTimer()
end

function BattleStateRoom:SetStateFighting(time)
    BattleStateBase.SetStateFighting(self, time)

    if MatchManager:Get():IsReconnectOnLogin() and RaceRoomManager:Get():GetRoomState() == SerE_RaceRoomState.Fight then
        log("---   房间赛重连，战斗快进", RaceRoomManager:Get():GetFightTime())
        local fighttime = RaceRoomManager:Get():GetFightTime()
        if fighttime > 0 then
            local time = CommonHelper:SubTime(RaceRoomManager:Get():GetFightTime())
            BattleStateBase.JumpRacing(self, time)
        end
    end

end

function BattleStateRoom:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    BattleDataManager:Get():SetBattleResultData(result)
    BattleDataManager:Get():SetStateBattleResult()
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
       -- BattleDataManager:Get():SetStateBattleResult()
    else
        if RaceRoomManager:Get():IsLeader() then
            RaceRoomSubsystem:Get():SendMsg_BattleFinish(result)
        end
    end
end

function BattleStateRoom:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    RaceRoomManager:Get():SetFightTime(0)
    RaceRoomManager:Get():UpdateRoomState(SerE_RaceRoomState.Result)

    UIManager:Get():CloseView()--关闭战斗中UI

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRoom:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)

    RaceRoomManager:Get():UpdateRoomState(SerE_RaceRoomState.Wait)
end

function BattleStateRoom:StartTimer()
    self:StopTimer()
    self.TimerID = TimerManager:Get():CreateTimerLoop(1, function()
        local value = SceneManager:Get():GetLoadingProcess()
        local value = math.modf(value * 100)
        if value >= 100 then
            value = 99
            RaceRoomSubsystem:Get():SendMsg_LoadingProgress(value)
            self:StopTimer()
        end
    end)
end

function BattleStateRoom:StopTimer()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end