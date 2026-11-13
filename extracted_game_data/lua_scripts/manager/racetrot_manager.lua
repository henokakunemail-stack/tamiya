---@class RaceTrotManager
RaceTrotManager =class("RaceTrotManager")
function RaceTrotManager:Get()
    if self._instance==nil then
        self._instance=RaceTrotManager()
    end
    return self._instance
end
function RaceTrotManager:initialize()
    ---@type RaceTrotData
    self.RaceTrot=nil
    ---@type CarBuilderTexture[]
    self.CarBuilderList=nil
end
---@param msg SC_FastMatch
function RaceTrotManager:Init(msg)
    self.RaceTrot=RaceTrotData()
    self.RaceTrot:SetData(msg)
    self:OnInitCar()
end

function RaceTrotManager:OnInitCar()
    if self.RaceTrot.EnemyList then
        self.CarList={}
        for i = 1, #self.RaceTrot.EnemyList do
            local param=CarBuilderTextureParam()
            param.CarReviewData=self.RaceTrot.EnemyList[i].Car
            param.idx=i
            table.insert(self.CarList,param)
        end
        self.CarBuilderList=nil
    end
end

function RaceTrotManager:GetCarList() return self.CarList
end
function RaceTrotManager:SetCarBuilderList(value)
    self.CarBuilderList=value
end
function RaceTrotManager:GetCarBuilderList() return self.CarBuilderList end
function RaceTrotManager:GetCarBuilderByIndex(index) if self.CarBuilderList then return self.CarBuilderList[index] end end

function RaceTrotManager:ClearCarList()
    CarBuilderTextureManager:Get():Clear()
    self.CarList =nil
    self.CarBuilderList=nil
end
function RaceTrotManager:SetCurEnemyId(value)
    self.CurEnemy=value
end
function RaceTrotManager:GetCurEnemyId()
    return self.CurEnemy
end

function RaceTrotManager:GetSeasonId()
    return self.RaceTrot.SeasonId
end
function RaceTrotManager:SetSeasonId(value)
    self.RaceTrot.SeasonId=value
end
function RaceTrotManager:GetTrackWinPercentByIdx(idx)
    if self.RaceTrot.TrackWinPercent[idx] then
        local value1,value2=math.modf(self.RaceTrot.TrackWinPercent[idx]*100)
        return value1
    end
   return 0
end
function RaceTrotManager:SetTrackWinPercent(value)
    if self.RaceTrot then
       self.RaceTrot.TrackWinPercent=value
    end
end
function RaceTrotManager:GetCurLevel()
    return self.RaceTrot.CurFastLve
end
function RaceTrotManager:SetCurLevel(value)
    self.RaceTrot.CurFastLve=value
end
function RaceTrotManager:GetCurScore()
    return self.RaceTrot.CurScore
end
function RaceTrotManager:SetCurScore(value)
    self.RaceTrot.CurScore=value
end

function RaceTrotManager:GetGetScoreTime()
    return self.RaceTrot.GetScoreTime
end
function RaceTrotManager:SetGetScoreTime(value)
     self.RaceTrot.GetScoreTime=value
end
function RaceTrotManager:GetJoinCount()
    return self.RaceTrot.JoinCount
end
function RaceTrotManager:SetJoinCount(value)
     self.RaceTrot.JoinCount=value
end
function RaceTrotManager:GetMaxCount()
    return self.RaceTrot.MaxCount
end
function RaceTrotManager:SetMaxCount(value)
     self.RaceTrot.MaxCount=value
end
function RaceTrotManager:GetBoxId()
    return self.RaceTrot.BoxId
end
function RaceTrotManager:SetBoxId(value)
    self.RaceTrot.BoxId=value
end
function RaceTrotManager:GetBoxScore()
    return self.RaceTrot.BoxScore
end
function RaceTrotManager:GetMaxBoxScore()
    return self.RaceTrot.MaxBoxScore
end
function RaceTrotManager:SetBoxScore(value)
    self.RaceTrot.BoxScore=value
end
function RaceTrotManager:GetStep()
    return self.RaceTrot.Step
end
function RaceTrotManager:SetStep(value)
    self.RaceTrot.Step=value
end
function RaceTrotManager:GetStandByTrackList()
    return self.RaceTrot.StandByTrackList
end
function RaceTrotManager:GetTrackIdByIdx(idx)
    if self.RaceTrot and self.RaceTrot.StandByTrackList then
        self.RaceTrot.StandByTrackList[idx]:GetId()
    end
    return 0
end
function RaceTrotManager:SetStandByTrackList(data)
    self.RaceTrot.StandByTrackList={}
    for i = 1, #data do
        local trackData=CommonHelper:GetRacetrackData(data[i])
        table.insert(self.RaceTrot.StandByTrackList,trackData)
    end
end
function RaceTrotManager:GetSelectTrack()
    return self.RaceTrot.SelectedTrack
end

function RaceTrotManager:SetSelectTrack(value)
    self.RaceTrot.SelectedTrack=value
end

function RaceTrotManager:SetSelectEnemyByIndex(idx)
    if self.RaceTrot.StandByTrackList and self.RaceTrot.StandByTrackList[idx] then
        self.RaceTrot.SelectedFighter=self.RaceTrot.StandByTrackList[idx]
    end
end


function RaceTrotManager:GetEnemyList()
    return self.RaceTrot.EnemyList
end
function RaceTrotManager:GetGetEnemyDataByIdx(idx)
    if self.RaceTrot and self.RaceTrot.EnemyList then
        return self.RaceTrot.EnemyList[idx]
    end
    return nil
end
function RaceTrotManager:GetGetEnemyWatchedById(id)
    local result =false
    if self.RaceTrot and self.RaceTrot.WatchLoc then
        for k, v in pairs(self.RaceTrot.WatchLoc) do
            if v==id then
                result=true
                break
            end
        end
    end
    return result
end
function RaceTrotManager:SetGetEnemyWatchedByIdx(idx,Watched)
    if self.RaceTrot and self.RaceTrot.WatchLoc then
        self.RaceTrot.WatchLoc[idx]=Watched
    end
end
function RaceTrotManager:SetGetEnemyWatched(value)
        self.RaceTrot.WatchLoc=value
end
function RaceTrotManager:SetGetEnemyDataByIdxWatched(idx,Watched)
    if self.RaceTrot and self.RaceTrot.EnemyList then
        self.RaceTrot.EnemyList[idx].Watched=Watched
    end
end
function RaceTrotManager:SetEnemyList(data)
    self.RaceTrot.EnemyList={}
    for i = 1, #data do
        local temp=RaceTrotEnemyData()
        temp:SetData(data[i])
        table.insert(self.RaceTrot.EnemyList,temp)
    end
    self:OnInitCar()
end
function RaceTrotManager:GetSelectEnemy()
    return self.RaceTrot.SelectedFighter
end
function RaceTrotManager:SetSelectEnemy(data)
    if data.selectedFighter then
        ---@type RaceTrotEnemyData
        self.RaceTrot.SelectedFighter=RaceTrotEnemyData()
        self.RaceTrot.SelectedFighter:SetData(data.selectedFighter)
    end
end

function RaceTrotManager:SetSelectEnemyByIndex(idx)
    if self.RaceTrot.EnemyList and self.RaceTrot.EnemyList[idx] then
        self.RaceTrot.SelectedFighter=self.RaceTrot.EnemyList[idx]
    end
end


function RaceTrotManager:GetWinSum()
    return self.RaceTrot.WinSum
end
function RaceTrotManager:SetWinSum(value)
    self.RaceTrot.WinSum=value
end
function RaceTrotManager:GetActSum()
    return self.RaceTrot.ActNum
end
function RaceTrotManager:SetActSum(value)
    self.RaceTrot.ActNum=value
end

function RaceTrotManager:GetContinueWinSum()
    return self.RaceTrot.ContinueWinSum
end
function RaceTrotManager:GetSourceBoxPoint()
    return self.RaceTrot.SourceBoxPoint
end
function RaceTrotManager:SetContinueWinSum(value)
    self.RaceTrot.ContinueWinSum=value
end

function RaceTrotManager:GetUpMatch(msg)
    return self.RaceTrot.UpMatch
end
function RaceTrotManager:SetUpMatch(value)
    self.RaceTrot.UpMatch=value
end

function RaceTrotManager:GetMatchWin()
    return self.RaceTrot.MatchWin
end
function RaceTrotManager:SetMatchWin(value)
    self.RaceTrot.MatchWin=value
end

function RaceTrotManager:GetFreshTrack()
    return self.RaceTrot.FreshTrack
end
function RaceTrotManager:SetFreshTrack(value)
    self.RaceTrot.FreshTrack=value
end
function RaceTrotManager:GetEnemyCarId()
    return self.EnemyCarId
end
function RaceTrotManager:SetEnemyCarId(value)
    self.EnemyCarId=value
end

function RaceTrotManager:RecycleFighter()
    if self.EnemyCarId then
        CarBuilderManager:Get():Recycle(self.EnemyCarId)
        self.EnemyCarId=nil
    end
end

function RaceTrotManager:GetFreshFighter()
    return self.RaceTrot.FreshFighter
end
function RaceTrotManager:SetFreshFighter(value)
    self.RaceTrot.FreshFighter=value
end

function RaceTrotManager:GetError()
    return self.BattleError
end

function RaceTrotManager:SetError(error)
    self.BattleError=error
end
---@param msg SC_BeginFastPvp
function RaceTrotManager:BeginBattle(msg)
    self:RecycleFighter()
    if msg then
        self:SetBattleCarData(msg.racelist)
        KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.consumelist)
        BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceTrot)
        local scenename = BattleDataManager:Get():GetSceneName()
        local trackdata = BattleDataManager:Get():GetTrackData()
        SceneManager:Get():LoadingRealTimePVPScene(scenename, trackdata, RaceModel.RaceTrot)
    end

end
function RaceTrotManager:CheckBattle(value)
    self.refight=value
end

function RaceTrotManager:ReEnterBattle()
    local result = self.refight==4
    if result then
       RaceTrotSubsystem:Get():SendMsg_ReEnterBattle()
    end
    return result
end

---@param msg SC_FinishFastPvp
function RaceTrotManager:FinishBattle(msg)
    local isUp=false
    local isShowRank=self:GetUpMatch(msg.match)>-1
    self:SetSelectEnemyTeachEvent(self.RaceTrot)
    if msg.match then
        local UpScore=msg.match.curpoint-self:GetCurScore()
        if self:GetUpMatch()>-1 and msg.match.upmatch==-1 then
            isShowRank=false
            isUp=true
        end
        self:Init(msg.match)
        if self:GetError()>BattleFailError.None or isShowRank then
            CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown,false,function()
                BattleDataManager:Get():SetStateBattleResult()
            end)
        else
            UIManager:Get():OpenPopup("RaceTrotRankShowView",CanvasType.MainCanvas,"RaceTrotRankShowView")
            UINotify:Get():SendNotification(UINotifyEvent.RankTrotRankShow_SetData,{isUp,UpScore,function()
                CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown,false,function()
                    BattleDataManager:Get():SetStateBattleResult()
                end)
            end})
        end
        self:Teach_Event(msg.match)
    else
        BattleDataManager:Get():SetStateBattleResult()
    end

end
function RaceTrotManager:SetSelectEnemyTeachEvent(data)
    ---@type RaceTrotData
    self.TeachData=data
end
---@param data table<number,SC_FighterInfo>
function RaceTrotManager:SetBattleCarData(data)
    if data then
        self.BattleCarSelf=nil
        self.BattleEnemyCar=nil
        for i = 1, #data do
            local Car=CarReviewData()
            if data[i].rid<NpcMaxId then
                if data[i].car then
                    Car:SetDataByMsg(data[i].car)
                else
                    Car:SetDataByNPC(data[i].rid)
                end
            else
                Car:SetDataByMsg(data[i].car)
            end

            if data[i].rid==PlayerDataManager:Get():GetPlayerRID() then
                self.BattleCarSelf=Car
            else
                self.BattleEnemyCar=Car
            end
        end
    end
end

---@param match SC_FastMatch
function RaceTrotManager:Teach_Event(match)
    if match and self.TeachData and self.TeachData.SelectedFighter then
        ---@param playerListData table<number,BattleResultPlayerData>
        local battleList= BattleDataManager:Get():GetBattleResultData():GetPlayerList()
        ---@type BattleResultPlayerData
        local selfData=nil
        ---@type BattleResultPlayerData
        local enemyData=nil
        for i = 1, #battleList do
            if battleList[i]:GetPid()==PlayerDataManager:Get():GetPlayerRID() then
                selfData=battleList[i]
            else
                enemyData=battleList[i]
            end
        end
        BattleDataManager:Get():GetIsBattleWin()
        local selfAttr={}
        for i, v in pairs(self.BattleCarSelf:GetBatterAttr()) do
             selfAttr[tostring(i)]=v
        end
        local otherAttr={}
        if self.BattleEnemyCar:GetBatterAttr() then
            for i, v in pairs( self.BattleEnemyCar:GetBatterAttr()) do
                otherAttr[tostring(i)]=v
            end
        end

        local trackTable=
        {
            battle_type= RaceModel.RaceTrot,
            continue_win =match.continuewin,
            season_id = match.seasonid,
            track_id = BattleDataManager:Get():GetTrackData():GetId(),
            enemy_id=self.TeachData.SelectedFighter.Id,
            difficulty=self.TeachData.SelectedFighter.AddPoint,
            self_attr=selfAttr,
            enemy_attr=otherAttr,
            self_time=selfData:GetTime(),
            enemy_time=enemyData:GetTime(),
            up_match=self.TeachData.UpMatch,
            error=selfData:GetError(),
            win_lose=selfData:GetRank(),
            before_score=self.TeachData.CurScore,
            end_score=match.curpoint,
            box_score=match.boxpoint-self.RaceTrot.BoxScore,
            pve_type = BattleDataManager:Get():GetBattleType(),
        }
        QuickTa:Get():TrackEvent(TrackEventNames.RaceTrotLog,trackTable)
    end
end

