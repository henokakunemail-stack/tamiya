




local __instance
---@class RaceRankManager
RaceRankManager = class("RaceRankManager")
function RaceRankManager:initialize()
    ---@type RaceRankData
    self.RankData = RaceRankData()
end
---@return RaceRankManager
function RaceRankManager:Get()
    if __instance == nil then
        __instance = RaceRankManager()
    end
    return __instance
end

function RaceRankManager:SetRoomId(id)
    self.RoomId=id
end
function RaceRankManager:GetRoomId()
    return self.RoomId
end
function RaceRankManager:SetProtectType(value)
    self.ProtectType=value
end
function RaceRankManager:SetRaceStyleType(value)
    self.RaceStyleType=value
    if self.RaceStyleType==1 then
        self:SetProtectType(RaceProtectType.Normal)
    end
    if self.RaceStyleType==2 then
        self:SetProtectType(RaceProtectType.Normal)
    end
    if self.RaceStyleType==3 then
        self:SetProtectType(RaceProtectType.Protect)
    end
    if self.RaceStyleType==4 then
        self:SetProtectType(RaceProtectType.Protect)
    end
end

function RaceRankManager:GetProtectType()
    return self.ProtectType
end
function RaceRankManager:GetRaceStyleType()
    if self.RaceStyleType==1 then
        return RaceProtectType.Normal,RaceStyleType.Normal
    end
    if self.RaceStyleType==2 then
        return RaceProtectType.Normal,RaceStyleType.Relay
    end
    if self.RaceStyleType==3 then
        return RaceProtectType.Protect,RaceStyleType.Normal
    end
    if self.RaceStyleType==4 then
        return RaceProtectType.Protect,RaceStyleType.Relay
    end
    return RaceProtectType.Normal,RaceStyleType.Normal
end

function RaceRankManager:SetRaceType(value)
    self.RaceType=value
end
function RaceRankManager:GetRaceType()
    return self.RaceType
end



function RaceRankManager:SetMatchAgree(value)
    self.RankData.IsAgreeJoin = value
end
function RaceRankManager:GetRoomTrackData()
    if self.RankData then return self.RankData.TrackData end
end
function RaceRankManager:GetSceneIDs()
    local result={}

end
function RaceRankManager:GetScenes()
    if self.RankData then return self.RankData.SceneID end
end


function RaceRankManager:GetRoomData()
    return self.RankData.RoomData
end
function RaceRankManager:GetSessionList()
    return self.RankData.SessionList
end
function RaceRankManager:GetTrackList(type)
    if type==RaceProtectType.Normal then
        return self.RankData.NormalTrackList
    end
    if type==RaceProtectType.Protect then
        return self.RankData.RLTrackList
    end
end


---@return dictseason_config_cell
function RaceRankManager:GetSessionCfg()
    if self.RankData and self.RankData.SessionCfg then
        return self.RankData.SessionCfg
    end
    return ""
end
function RaceRankManager:GetSessionId()
    if self.RankData and self.RankData.SessionCfg then
        return self.RankData.SessionCfg.C_ID
    end
    return ""
end

function RaceRankManager:GetBeginTime()
    return self.RankData.BeginTime
end
function RaceRankManager:GetEndTime()
    return self.RankData.EndTime
end
function RaceRankManager:GetScore()
    if self.RankData then
        return self.RankData.Score
    end
    return 0
end
function RaceRankManager:GetRank()
    return self.RankData.RankIdx
end
---@return RaceRankMoreTrackRankData[]
function RaceRankManager:GetFastRank(trackId)
    if trackId then
        return self.RankData.FirstRacers[trackId]
    else
        return self.RankData.FastPlayerData
    end


end

function RaceRankManager:GetSelfRank(trackId)
    return self.RankData.TrackTimes[trackId]
end
function RaceRankManager:GetFastRLRank()
    return self.RankData.FastRlPlayerData
end


function RaceRankManager:SetAddScore(value)
    self.AddScore=value
end
function RaceRankManager:GetAddScore()
    return self.AddScore
end
function RaceRankManager:IsCloseSeason()
    return self.RankData.IsCloseSeason
end
---@return RaceTrackData
function RaceRankManager:GetTrackData()
    return self.RankData.TrackData
end
function RaceRankManager:GetSelectPositionNum()
    return self.RankData.SelectPositionNum
end
function RaceRankManager:GetSelectPositionMaxNum()
    return self.RankData.SelectPositionMaxNum
end

function RaceRankManager:GetScene(idx)
    return self.RankData.SessionCfg.NewSceneList[idx]
end
---@return table<number, RaceRankScoreRewardData>
function RaceRankManager:GetScoreRewardList()
    return self.RankData.ScoreRewardList
end
function RaceRankManager:GetFightTime()
    return self.RankData.FightTime
end
function RaceRankManager:GetReadyEndTime()
    return self.RankData.ReadyEndTime
end
function RaceRankManager:GetRoomState()
    if self.RankData.RoomData then return self.RankData.RoomData.State end
end
---@return RaceRankPlayerData
function RaceRankManager:GetPlayerByPid(pid)
    if self.RankData.RoomData then return self.RankData.RoomData:GetPlayerById(pid) end
end

function RaceRankManager:IsMatching()
    local result = UIManager:Get():IsPersistentViewShow("RaceRankMatchingView")
    if result then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRankMatching))
    end
    return result
end


---@param msg SC_ReqSeasonInfo
function RaceRankManager:SetSessionData(msg)
    self.RankData:SetData(msg)
end

function RaceRankManager:UpdateRewardState(idx, state)
    self.RankData:UpdateScoreRewardState(idx, state)
end

function RaceRankManager:SetSpeedRank(msg)
    self.RankData:SetSpeedRank(msg)
end
---@return table<number, RaceRankSpeedRankData>
function RaceRankManager:GetSpeedRank(trackid)
    return self.RankData:GetSpeedRank(trackid)
end
---@return RaceRankSpeedRankData
function RaceRankManager:GetSelfSpeedRank(trackid)
    return self.RankData:GetSelfSpeedRank(trackid)
end

---@return number
function RaceRankManager:GetCurRaceRankTime()
    if self.RankData then
        return self.RankData.CurNum
    end
    return 0
end
function RaceRankManager:GetCurRaceRankRlTime()
    if self.RankData then
        return self.RankData.CurRlNum
    end
    return 0
end

---@return number
function RaceRankManager:GetMaxRaceRankTime()
    if self.RankData then
        return self.RankData.MaxNum
    end
    return 0
end
---@return number
function RaceRankManager:GetCurRaceRankTestTime()
    return self.RankData.CurTestNum
end
---@return number
function RaceRankManager:GetMaxTestRaceRankTime()
    return self.RankData.MaxTestNum
end



function RaceRankManager:SetRoomData(msg,state)
    self.RankData:SetRoomData(msg,state)
end

function RaceRankManager:ClearRoomData()
    self.RankData:ClearRoomData()
end
function RaceRankManager:CheckBattle(value)
    self.refight=value
end

function RaceRankManager:SetPlayerCarData(pid, msg)
    self.RankData.RoomData:SetCarData(pid, msg)
end

function RaceRankManager:SetPlayerReady(pid, state)
    self.RankData.RoomData:SetPlayerReady(pid, state)
end

function RaceRankManager:SetSelfCarId(caridx)
    self.RankData.RoomData:SetSelfCarId(caridx)
end

function RaceRankManager:GetDefaultMatchCarIdx()
    local result = -1
    local list = CarDataManager:Get():GetCarList()
    for i = 1, #list do
        local data = list[i]
        if CarDataManager:Get():CheckCarCompleteness(data:GetID(), false) then
            result = data:GetID()
            break
        end
    end
    if result == -1 then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NoCarContRank))
    end
    return result
end
function RaceRankManager:SetFightTime(time)
    if self.RankData.RoomData.State == SerE_RaceRankState.Fight then
        self.RankData:SetFightTime(time)
    end
end
function RaceRankManager:SetReadyEndTime(time)
    if self.RankData.RoomData.State == SerE_RaceRankState.Ready then
        self.RankData:SetReadyEndTime(time)
    end
end
function RaceRankManager:UpdateRoomState(state)
    self.RankData.RoomData.State = state
end





function RaceRankManager:ReEnterBattle()
    local result = self.refight==1
    if result then
        RaceRankSubsystem:Get():SendMsg_ReFight()
    end
    return result
end

function RaceRankManager:QuickReconnect()
    local result = MatchManager:Get():MatchDataIsNil() and MatchManager:Get():GetType() == SerE_PVPType.RaceRank
    if not result then
        if not MatchManager:Get():MatchDataIsNil() then
            log("---   同步战斗服快速重连成功，重连天梯")
            MatchManager:Get():SetConnectFlag(RaceRankReconnectFlag.QuickReconnect)
            NetManager:Get():ConnectSyncBattleServer()
        end
    end
    return result
end

---@param msg SC_EnterRoomRes
function RaceRankManager:RecvRoomInfoMsgInitData(msg)
    RaceRankManager:Get():SetRoomData(msg.rankRoomInfo,msg.state)
    RaceRankManager:Get():SetFightTime(msg.tTime)
    RaceRankManager:Get():SetReadyEndTime(msg.tTime)
end
local LastType=0
---@param msg SC_RetPVPStart
---@param history RaceHistoryData
function RaceRankManager:LoadBattleScene(msg, history)
    --if msg and history then
    --    logError("---   跨服pvp，数据异常，LoadBattleScene   ",msg, history)
    --    return
    --end

    if msg then
        BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceRank,history)
    end
    if history then
        -- BattleDataManager:Get():SetBattleResultData(history)
    end
    if CommonSubsystem:Get().IsLoadRankData then
        local result= CSharpRoomInitData:CreateRoomInitData(BattleDataManager:Get().BattleData.LuaRoomData)
        --CS.Horizon.Game.LogicLayer.RaceGlobalSetting.isServerLogic = true
        CS.Horizon.Game.ShowLayer.QuickRaceManager.Get():OnInit(1, true)
        CS.Horizon.Game.ShowLayer.QuickRaceManager.Get():StartRacing()
        local result=CS.Horizon.Game.ShowLayer.QuickRaceManager.Get():QuickExecuteGame()


        if self.RecordData==nil then
            self.RecordData={}
        end
        local roomDataStr = result:ToString()
        local serverName=PlayerDataManager:Get():GetPlayerServerID()
        if RankingListDataManager:Get().CurValue[4]==RaceProtectType.Normal then
            serverName=serverName.."_挑战"
        else
            serverName=serverName.."_保护"
        end
        local DataIsFalse="正常"
        for i = 0, result.results.Length-1 do
            if result.results[i].pid==RankingListDataManager:Get().CurValue[1] then
                if result.results[i].error~=BattleFailError.None or result.results[i].time~=RankingListDataManager:Get().CurValue[2] then
                    DataIsFalse="作弊".."_"..result.results[i].error.."_"..result.results[i].time
                end
                break
            end
        end
        CS.MonoHelper.AppendToRankListFileExist(serverName,roomDataStr.."\n")
        CS.MonoHelper.AppendToRankListFileExist(serverName,RankingListDataManager:Get().CurValue[1].."_"..RankingListDataManager:Get().CurValue[2].."_"..RankingListDataManager:Get().CurValue[5].."_"..RankListTestVerifyDataManager:Get().LookVersion.."_"..DataIsFalse.."\n")
        CS.MonoHelper.AppendToRankListFileExist(serverName,"-------------------------------------------\n")
        table.insert(self.RecordData,result)
        if RankingListDataManager:Get().Rids:GetSize()>0 then
            RankingListDataManager:Get().CurValue=RankingListDataManager:Get().Rids:DeQueueFront()
            cs_coroutine.start(function()
                coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
                LastType=RankingListDataManager:Get().CurValue[4]
                CommonSubsystem:SendMsg_RePlayBattle(RankingListDataManager:Get().CurValue[1],RankingListDataManager:Get().CurValue[3],RankingListDataManager:Get().CurValue[4])
            end)
        else
            if LastType==RaceProtectType.Normal then
                if RankListTestVerifyDataManager:Get():GetIsVerify() then
                    RankListTestVerifyDataManager:Get():LoginRlSpeedRankData()
                end
            end
            if LastType==RaceProtectType.Protect then
                if RankListTestVerifyDataManager:Get():GetIsVerify() then
                    RankListTestVerifyDataManager:Get():Done()
                end
            end

        end
    else
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingRealTimePVPScene(scenename, trackdata, RaceModel.RaceRank)
    end

end
function RaceRankManager:GetLastType()
    return LastType
end
function RaceRankManager:ReSend()
    LastType=RankingListDataManager:Get().CurValue[4]
    CommonSubsystem:SendMsg_RePlayBattle(RankingListDataManager:Get().CurValue[1],RankingListDataManager:Get().CurValue[3],RankingListDataManager:Get().CurValue[4])
end



--{{{断线重连
---@param msg SC_EnterRoomRes
function RaceRankManager:ConnectNormal(msg)
    log("---   跨服PVP收到房间数据，无异常")
    UIManager:Get():HidePersistentView("RaceRankJoinView")
    self:RecvRoomInfoMsgInitData(msg)
    UIManager:Get():OpenView("RaceRankRoomView",CanvasType.MainCanvas,"RaceRankRoomView",false, true)
    UINotify:Get():SendNotification(UINotifyEvent.RaceRankRoomView_SetData)
end


--refight = 14;//战斗拉回  0普通副本 1训练赛 2活动章节 3极限挑战 4pvp
function RaceRankManager:ReconnectOnLogin(refight)
    print("ZHANDOU",refight)
    local result=false
    if refight==4 then
        RaceRankSubsystem:Get():SendMsg_Match(0)
        result=true
    end
    return result
end

---@param msg SC_EnterRoomRes
function RaceRankManager:ReconnectOnQuickConnect(msg)
    UIManager:Get():HidePersistentView("RaceRankJoinView")

    local oldstate = RaceRankManager:Get():GetRoomState()
    log("---   十次重连成功，跨服PVP收到房间数据，重连，state = ", msg.state, "oldstate = ",oldstate)

    self:RecvRoomInfoMsgInitData(msg)
    if msg.state == SerE_RaceRankState.Ready then
        UINotify:Get():SendNotification(UINotifyEvent.RaceRankRoomView_RefreshUI)
        return
    end
    if msg.state == SerE_RaceRankState.Loading and oldstate == SerE_RaceRankState.Ready then
        self:LoadBattleScene(msg.fightInfo, nil)
        return
    end
    if msg.state == SerE_RaceRankState.Loading and oldstate == SerE_RaceRankState.Loading then
        local value = SceneManager:Get():GetLoadingProcess()
        local value = math.modf(value * 100)
        RaceRankSubsystem:Get():SendMsg_LoadingProcess(value)
        return
    end
    if msg.state == SerE_RaceRankState.Fight and oldstate == SerE_RaceRankState.Ready then
        self:LoadBattleScene(msg.fightInfo, nil)
        return
    end
    if msg.state == SerE_RaceRankState.Fight and oldstate == SerE_RaceRankState.Loading then
        self:LoadBattleScene(msg.fightInfo, nil)
        return
    end
    if msg.state == SerE_RaceRankState.Fight and oldstate == SerE_RaceRankState.Result then

        return
    end
    if msg.state == SerE_RaceRankState.Result then
        SceneManager:Get():LoadingMainCity()
        return
    end

    logError("---   天梯快速重连，未知情况","oldstate = ",oldstate,"serverstate = ",msg.state)
end
--}}}


function RaceRankManager:AutoReMatch()
    UIManager:Get():HidePersistentView("RaceRankJoinView")

    if self.RankData.IsAgreeJoin then
        RaceRankManager:Get():SetMatchAgree(false)
        local caridx = RaceRankManager:Get():GetDefaultMatchCarIdx()
        if caridx >= 0 then
            UIManager:Get():ShowPersistentView("RaceRankMatchingView",CanvasType.TopCanvas,"RaceRankMatchingView", false, true)
            RaceRankSubsystem:Get():SendMsg_Match(caridx)
        end
    end
end




function RaceRankManager:ClearData()
    self.RankData = nil
    self.RankData = RaceRankData()
end