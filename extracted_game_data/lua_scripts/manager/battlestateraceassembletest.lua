---@class BattleStateRaceAssembleTest:BattleStateBase
BattleStateRaceAssembleTest = class("BattleStateRaceAssembleTest", BattleStateBase)

function BattleStateRaceAssembleTest:initialize()

end

function BattleStateRaceAssembleTest:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceAssembleTest:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end
function BattleStateRaceAssembleTest:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end


function BattleStateRaceAssembleTest:SetStateBattleFinish(result)
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
    BattleDataManager:Get():SetStateBattleResult()
end

function BattleStateRaceAssembleTest:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceAssembleTest:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end