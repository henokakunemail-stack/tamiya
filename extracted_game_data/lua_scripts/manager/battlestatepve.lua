---@class BattleStatePVE:BattleStateBase
BattleStatePVE = class("BattleStatePVE", BattleStateBase)

function BattleStatePVE:initialize()

end

function BattleStatePVE:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStatePVE:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end

function BattleStatePVE:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

---@param result @是c#传过来的数组，在battle helper脚本里面有方法 BattleEndPVP
function BattleStatePVE:SetStateBattleFinish(result)
   -- if self.State == BattleState.Fighting then
        BattleStateBase.SetStateBattleFinish(self)
        local battleResult, isWin = BattleDataManager:Get():AnalyzeResult(result)
        isWin=BattleDataManager:Get():GetSelfError(result)
        if BattleDataManager:Get():IsPlayAgain() or BattleDataManager:Get():IsReplay() then
            BattleDataManager:Get():SetBattleResultData(result)
            BattleDataManager:Get():SetStateBattleResult()
        else
            BattleDataManager:Get():SetBattleResultData(result)
            if BattleDataManager:Get():GetLevelId()==10010009 and battleResult.error>BattleFailError.None and battleResult.error<=BattleFailError.BatteryDown then
                CommonTipsHelper:Get():ShowCenterTips("請記得裝配鳳尾")
            end
            local startTime=PlayerPrefsHelper:GetValue_SelfCountDownBtnUpTime()
            local recordValue = PlayerPrefsHelper:GetValue_ReplayInputInfos()..self:AppendBattleResult()
            if CommonHelper:IsNullOrEmpty(recordValue) then
                 recordValue="0"
            end
            if battleResult then
                print("init battle car id 2",BattleDataManager:Get():GetSelfCarId())
                PVEChapterDataManager:Get():AddBattleResult(BattleDataManager:Get():GetLevelId(),BattleDataManager:Get():GetSelfCarId() ,isWin,battleResult.time, battleResult.error, BattleDataManager:Get():GetBattleResultData(),startTime,recordValue)
            else
                PVEChapterDataManager:Get().Queue:Clear()
                PVEChapterDataManager:Get():BattleFinish()
            end
        end
    --end
end

function BattleStatePVE:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    --UIManager:Get():CloseView()--关闭战斗中UI

    UIManager:Get():OpenView("BattleResultView", CanvasType.MainCanvas, "BattleResultView")
end

function BattleStatePVE:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end