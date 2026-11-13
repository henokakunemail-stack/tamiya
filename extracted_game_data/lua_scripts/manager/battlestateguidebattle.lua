---@class BattleStateGuideBattle:BattleStateBase
BattleStateGuideBattle = class("BattleStateGuideBattle", BattleStateBase)

function BattleStateGuideBattle:initialize()

end

function BattleStateGuideBattle:SetStateLoading()
    BattleStateBase.SetStateLoading(self)
end

function BattleStateGuideBattle:SetStateLoadFinish()
    BattleStateBase.SetStateLoadFinish(self)

    BattleDataManager:Get():SetStateFighting()
end
function BattleStateGuideBattle:SetStateFighting()
    BattleStateBase.SetStateFighting(self)
    monoRaceManager:SetTimeScale(PlayerPrefsHelper:GetValue_GuideBattleSpeed())
    monoRaceManager:EnableSlowMotion(false)
end


function BattleStateGuideBattle:SetStateBattleFinish(result)
    BattleStateBase.SetStateBattleFinish(self)
    print("假战斗结束1")
    BattleDataManager:Get():SetBattleResultData(result)
    BattleDataManager:Get():SetStateBattleResult()
end

function BattleStateGuideBattle:SetStateBattleResult()
    BattleStateBase.SetStateBattleResult(self)
    print("假战斗结束2")
    local result= BattleDataManager:Get():GetBattleResultData()
    PveLevelTestBattleDataManager:Get():WriteTime(result.PlayerList)
    cs_coroutine.start(function()
        coroutine.yield()
        if PveLevelTestBattleDataManager:Get().LevelDataQueue.Size>0 then
            BattleDataManager:Get():SetStateBattleExit()
            PveLevelTestBattleDataManager:Get():PopLevelData()
        else
            SceneManager:Get():LoadingMainCity(LoadingMainCityType.GuideBattleDone)
            BattleDataManager:Get():SetStateBattleExit()
        end
    end)
end

function BattleStateGuideBattle:SetStateBattleExit()
    BattleStateBase.SetStateBattleExit(self)
end