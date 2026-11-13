---@class BattleStateRaceReplay:BattleStateBase
BattleStateRaceReplay = class("BattleStateRaceReplay", BattleStateBase)

function BattleStateRaceReplay:initialize()

end

function BattleStateRaceReplay:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateRaceReplay:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end

function BattleStateRaceReplay:SetStateFighting(time)
    --BattleStateBase.SetStateFighting(self)
    if   PVEChapterDataManager:Get():GetCurLevelData().id<=10020005  then
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableCurveTurnOver = true
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableLandDownTurnOver = false
    else
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableCurveTurnOver = true
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableLandDownTurnOver = true
    end
    --CS. Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableBackHitCrash=true
    --if GameProperties.AreaType==AreaType.AreaTypeCN and BattleDataManager:Get():GetBattleType()==RaceModel.RaceRank then
    --    CS. Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableBackHitCrash=false
    --end
    self.State = BattleState.Fighting
    if time == nil then time = -1 end

    CommonHelper:CloseLoading()
    monoRaceManager:OnInit(1, true)
    monoRaceManager:StartRacing(time)
end

---@param result @是c#传过来的数组，在battle helper脚本里面有方法 BattleEndPVP
function BattleStateRaceReplay:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    local battleResult, isWin = BattleDataManager:Get():AnalyzeResult(result)
    if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    else
        BattleDataManager:Get():SetBattleResultData(result)
        BattleDataManager:Get():SetStateBattleResult()
    end
end

function BattleStateRaceReplay:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    --UIManager:Get():CloseView()--关闭战斗中UI

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStateRaceReplay:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end