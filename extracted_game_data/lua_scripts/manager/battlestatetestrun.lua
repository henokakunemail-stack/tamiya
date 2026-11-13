---@class BattleStateTestRun:BattleStateBase
BattleStateTestRun = class("BattleStateTestRun", BattleStateBase)

function BattleStateTestRun:initialize()

end

function BattleStateTestRun:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateTestRun:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end
function BattleStateTestRun:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end


function BattleStateTestRun:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    BattleDataManager:Get():SetBattleResultData(result)
    local time =0
    local loop = result.Length - 1
    for i = 0, loop do
        if result[i].pid == PlayerDataManager:Get():GetPlayerRID() then
            time=result[i].time
            break
        end
    end
    CustomtrackSubsystem:Get():SendMsg_TrackTestRun(BattleDataManager:Get():GetTrackData():GetServerIdx(),time)
    BattleDataManager:Get():SetStateBattleResult()
end

function BattleStateTestRun:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateTestRun:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end