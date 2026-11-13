
local __instance
---@class RaceSuperBattleManager
RaceSuperBattleManager = class("RaceSuperBattleManager")
function RaceSuperBattleManager:initialize()
    ---@type RaceSuperBattleData
    self.RaceData = RaceSuperBattleData()
    self.LookId=0
end
---@return RaceSuperBattleManager
function RaceSuperBattleManager:Get()
    if __instance == nil then
        __instance = RaceSuperBattleManager()
    end
    return __instance
end
---@param data SC_RetKillerInfo
function RaceSuperBattleManager:Init(data)
    ---@type RaceSuperBattleData
    self.RaceData = RaceSuperBattleData()
    self.RaceData:SetData(data)
    if self:GetIsSign() then
        local awards=stringSplitToNumber(data.awards,":")
        TaskDataManager:Get():OnInitSuperBattle(RaceSuperBattleManager:Get():GetData():GetScore(),awards,TaskType.SuperBattle)
        RedPointManager:Get():UpdateValue(RedPointID.RaceSuperBattle,TaskDataManager:Get():GetTaskIsDone(TaskType.SuperBattle))
    end
end
---@param data SC_MatchInfos
function RaceSuperBattleManager:SetShowRecordData(data)
    self.Record={}
    self.LookId=tonumber(data.watchrid)
    if data.matchs then
        for i = 1, #data.matchs do
            local temp=RaceSuperBattleMatchInfo()
            temp:SetData(data.matchs[i])
            table.insert(self.Record,temp)
        end
    end
end
function RaceSuperBattleManager:GetRecord()
    return self.Record
end
function RaceSuperBattleManager:GetLookId()
    return self.LookId
end
function RaceSuperBattleManager:SetLookGroup(value)
     self.LookGroup=value
end
function RaceSuperBattleManager:GetLookGroup()
    return self.LookGroup
end
function RaceSuperBattleManager:SetLookRecordType(value)
     self.LookRecordType=value
end
function RaceSuperBattleManager:GetLookRecordType()
    return self.LookRecordType
end
function RaceSuperBattleManager:SetMyGroup(value)
     self.MyGroup=value
end
function RaceSuperBattleManager:GetMyGroup()
    return self.MyGroup
end
function RaceSuperBattleManager:SetMyGuess(states,values)
     self.MyGuess={}
    for i = 1, #states do
        self.MyGuess[tonumber(states[i])]=tonumber(values[i])
    end
end
function RaceSuperBattleManager:SetGuessByStates(states,value)
    self.MyGuess[states]=value
end

function RaceSuperBattleManager:GetMyGuessByState(state)
    if self.MyGuess[state] then
      return  self.MyGuess[state]
    end
    return 0
end
function RaceSuperBattleManager:IsKnockout8State(state)
    return state>=RaceSuperBattleKnockoutId.Knockout8
end
---@type SC_MatchInfos
function RaceSuperBattleManager:BeginBattle(msg)
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceSuperBattle,true)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceSuperBattle)
end


---@return RaceSuperBattleData
function RaceSuperBattleManager:GetData()
    return self.RaceData
end
function RaceSuperBattleManager:GetCanSign()
    return self.RaceData:GetState()==RaceSuperBattleBattleState.Enter and self.RaceData.Joined==RaceSuperBattleJoinState.NoJoin
end
function RaceSuperBattleManager:GetIsSign()
    return  self.RaceData.Joined==RaceSuperBattleJoinState.Joined
end
function RaceSuperBattleManager:IsEnter(state)
    return  state==RaceSuperBattleBattleState.Enter
end
function RaceSuperBattleManager:IsSignState(state)
    return     state==RaceSuperBattleBattleState.Enter
            or state==RaceSuperBattleBattleState.AuditionMatch
            or state==RaceSuperBattleBattleState.AuditionSelectCar
            or state==RaceSuperBattleBattleState.AuditionDayResult
            or state==RaceSuperBattleBattleState.AuditionResult
            or state==RaceSuperBattleBattleState.PlayoffMatch
            or state==RaceSuperBattleBattleState.PlayoffSelectCar
            or state==RaceSuperBattleBattleState.PlayoffResult
            or state==RaceSuperBattleBattleState.KnockoutMatch
            or state==RaceSuperBattleBattleState.KnockoutBanTrack
            or state==RaceSuperBattleBattleState.KnockoutSelectCar
            or state==RaceSuperBattleBattleState.KnockoutDayResult
            or state==RaceSuperBattleBattleState.RaceResult
end
function RaceSuperBattleManager:IsTrackReviewState(state)
    return     state==RaceSuperBattleBattleState.AuditionReviewTrack
            or state==RaceSuperBattleBattleState.PlayoffReviewTrack
            or state==RaceSuperBattleBattleState.KnockoutReviewTrack
end
function RaceSuperBattleManager:IsMatchState(state)
    return     state==RaceSuperBattleBattleState.AuditionMatch
            or state==RaceSuperBattleBattleState.PlayoffMatch
            or state==RaceSuperBattleBattleState.KnockoutMatch
end
function RaceSuperBattleManager:IsSelectCarState(state)
    return     state == RaceSuperBattleBattleState.AuditionSelectCar
            or state== RaceSuperBattleBattleState.PlayoffSelectCar
            or state== RaceSuperBattleBattleState.KnockoutSelectCar
end
function RaceSuperBattleManager:IsDayResultState(state)
    return     state == RaceSuperBattleBattleState.AuditionDayResult
            or state== RaceSuperBattleBattleState.KnockoutDayResult
            or state== RaceSuperBattleBattleState.AuditionResult
            or state== RaceSuperBattleBattleState.RaceResult
end
function RaceSuperBattleManager:IsPlayoffState(state)
    return     state == RaceSuperBattleBattleState.PlayoffMatch
            or state== RaceSuperBattleBattleState.PlayoffSelectCar
            or state== RaceSuperBattleBattleState.PlayoffReviewTrack
end
function RaceSuperBattleManager:IsPlayoffResultState(state)
    return     state == RaceSuperBattleBattleState.PlayoffResult
end
function RaceSuperBattleManager:IsBanTrackState(state)
   return      state== RaceSuperBattleBattleState.KnockoutBanTrack
end
function RaceSuperBattleManager:IsReachResult(state)
    return     state == RaceSuperBattleBattleState.AuditionDayResult
            or state== RaceSuperBattleBattleState.KnockoutDayResult
            or state== RaceSuperBattleBattleState.AuditionResult
            or state== RaceSuperBattleBattleState.RaceResult
            or state== RaceSuperBattleBattleState.PlayoffResult
end
function RaceSuperBattleManager:IsKnockoutState(state)
    return     state == RaceSuperBattleBattleState.KnockoutBanTrack
            or state== RaceSuperBattleBattleState.KnockoutMatch
            or state== RaceSuperBattleBattleState.KnockoutSelectCar
            or state== RaceSuperBattleBattleState.KnockoutReviewTrack
            or state== RaceSuperBattleBattleState.KnockoutDayResult
            or state== RaceSuperBattleBattleState.RaceResult
end
