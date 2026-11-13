


---@class BattleStateClubTrain:BattleStateBase
BattleStateClubTrain = class("BattleStateClubTrain", BattleStateBase)

function BattleStateClubTrain:initialize()

end

function BattleStateClubTrain:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateClubTrain:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end

function BattleStateClubTrain:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
end

function BattleStateClubTrain:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    BattleDataManager:Get():SetBattleResultData(result)
    BattleDataManager:Get():SetStateBattleResult()
end

function BattleStateClubTrain:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)

    UIManager:Get():OpenView("ClubTrainResultView",CanvasType.MainCanvas,"ClubTrainResultView")
end

function BattleStateClubTrain:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
    ClubTrainDataManager:Get():ClearData()
end