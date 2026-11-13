local __instance

---@class BattleDataManager
BattleDataManager = class("BattleDataManager")

function BattleDataManager:initialize()
    self.BattleData = BattleData()

    ---@type BattleStateBase
    self.BattleState = nil
    self.BattleTime = 0
    self.DefaultBattleSpeed=1
    self.IsDoubleSpeed=false
end

---@return BattleDataManager
function BattleDataManager:Get()
    if __instance == nil then
        __instance = BattleDataManager()
    end
    return __instance
end

---@param result table<number,CsBattleResultData>@ 索引从0开始，c#的数组
---@return CsBattleResultData
function BattleDataManager:AnalyzeResult(result)
    local battleResult = nil
    local isWin = 1
    if self.BattleData and self.BattleData.LuaRoomData then
        for i = 0, result.Length - 1 do
            if result[i].pid == self.BattleData.LuaRoomData.DefaultSelectPlayerID then
                battleResult = result[i]
                break
            end
        end
        isWin = (battleResult.time == 0 or battleResult.error ~= BattleFailError.None or battleResult.completeRank ~= 1) and 0 or 1

        self:SetIsBattleWin(isWin == 1)
        return battleResult, isWin
    end
end
function BattleDataManager:GetSelfError(result)
    local isWin = 1
    local battleResult = nil
    for i = 0, result.Length - 1 do
        if self.BattleData.LuaRoomData then
            if result[i].pid == self.BattleData.LuaRoomData.DefaultSelectPlayerID then
                battleResult = result[i]
                break
            end
        end
    end
    if battleResult then
        isWin = (battleResult.time <= 0 or battleResult.error ~= BattleFailError.None ) and 0 or 1
    end
    return isWin
end

function BattleDataManager:SetIsBattleWin(isBattleWin)
    self.BattleData:SetIsBattleWin(isBattleWin)
end
function BattleDataManager:GetIsBattleWin()
    return self.BattleData:GetIsBattleWin()
end
function BattleDataManager:GetSelfCarId()
    return self.BattleData:GetSelfCarId()
end
function BattleDataManager:SetIsCupShow(value)
    self.isCupShow=value
end
function BattleDataManager:GetIsCupShow()
    return self.isCupShow
end
function BattleDataManager:SetRaceStyleType(value)
    self.RaceStyleType=value
end
function BattleDataManager:GetRaceStyleTypeType()
    return self.RaceStyleType
end

function BattleDataManager:SetRoomData(msg, battletype, isreplay)
    if isreplay == nil then
        isreplay = false
    end
    local state, data = BattleDataHelper.CreateBattleData(battletype)
    self.BattleState = state
    self.BattleData = data
    self.BattleData:SetData(msg, battletype, isreplay)
    self.CurBattleMag=msg
    self.CurBattleBattleType=battletype
end

function BattleDataManager:SetBattleResultData(data)
    self.BattleData:SetResultData(data)
end

function BattleDataManager:ClearData()
    self.BattleData:ClearData(self.BattleData.BattleType)
end
function BattleDataManager:GetFrameCount()
   local lock=  monoRaceManager.lockstepManager
    if lock then
        return monoRaceManager.lockstepManager.frameCount
    end
    return 0
end
function BattleDataManager:GetTotalTime()
   return  monoRaceManager.lockstepManager._room._roomData.totalTime
end
function BattleDataManager:GetTotalRaceTime()
   return monoRaceManager.lockstepManager._room._roomData.totalRaceTime
end
function BattleDataManager:GetEngineControllerFrameCount()
    local lock=  monoRaceManager.lockstepManager
    if lock then
        if lock._room then
            if lock._room:GetSelfEntity() and lock._room:GetSelfEntity().EngineController then
                local dData = lock._room:GetSelfEntity().DData
                return dData.CompleteFrameCount.Value
            end
        end
    end
    return 0
end

function BattleDataManager:OpenBattleView()
    BattleDataManager:Get().BattleStartTime=CommonHelper:GetNowTime()
    local type = self:GetTrackType()
    if type == TrackType.Free then
        UIManager:Get():OpenView("BattleNewOutdoorView", CanvasType.MainCanvas, "BattleNewOutdoorView")
    else
        UIManager:Get():OpenView("BattleNewSystemView", CanvasType.MainCanvas, "BattleNewSystemView")
    end
    BattleDataManager:Get():EnableShellAnim()
end

function BattleDataManager:GetRoomData()
    return self.BattleData.LuaRoomData
end

---@return RaceModel
function BattleDataManager:GetBattleType()
    return self.BattleData.BattleType
end

---@return RaceModel
function BattleDataManager:IsNewShowHead()
    --local battleType = self.BattleData.BattleType
    --local isNewShowHead = battleType==RaceModel.Battle or battleType==RaceModel.RaceReplay_Pve or battleType==RaceModel.Challenge or battleType==RaceModel.RaceCarGod or battleType ==RaceModel.RaceRank or battleType ==RaceModel.RaceSelfLevel
    return true -- isNewShowHead
end

function BattleDataManager:IsGuideFirstOneLevel()
    if self.BattleData and  self.BattleData.BattleType==RaceModel.Battle and CommonHelper:CheckPlayerIsNewGuide()  then
        if self.BattleData.LuaRoomData.LevelId==10010001 then
            return true
        end
    end
    return false
end
function BattleDataManager:IsNewGuideFirstOneLevel()
    if self.BattleData and  self.BattleData.BattleType==RaceModel.NewBieChapter and CommonHelper:CheckPlayerIsNewGuide()  then
        if self.BattleData.LuaRoomData.LevelId==10000001 then
            return true
        end
    end
    return false
end

function BattleDataManager:IsReplay()
    return self.BattleData.IsReplay
end

function BattleDataManager:IsPlayAgain()
    return self.BattleData.IsPlayAgain
end

function BattleDataManager:GetBattleResultData()
    return self.BattleData.ResultData
end
function BattleDataManager:GetDefaultPlayerBattleResultData()
    local PlayerData=nil
    for i = 1, 5 do
        local isActive = self:GetBattleResultData().PlayerList[i] ~= nil
        if isActive then
            if self:GetBattleResultData().PlayerList[i]:GetPid() == self:GetDefaultPlayerId() then
                PlayerData=self:GetBattleResultData().PlayerList[i]
                break
            end
        end
    end
    return PlayerData
end
function BattleDataManager:GetDefaultPlayerIndex()
    local DefaultPlayerIndex=-1
    for i = 1, 5 do
        local isActive = self:GetBattleResultData().PlayerList[i] ~= nil
        if isActive then
            if self:GetBattleResultData().PlayerList[i]:GetPid() == self:GetDefaultPlayerId() then
                DefaultPlayerIndex=i
                break
            end
        end
    end
    return DefaultPlayerIndex
end

---@return PlayerSampleInfoData
function BattleDataManager:GetFirstPlaySampleData()
    local playerSampleInfoData=nil
    local carDyData = BattleDyDataManager:Get():GetCarDataByRank(1)
    if carDyData then
        playerSampleInfoData=carDyData:GetSampleInfo()
    end
    return playerSampleInfoData
end

function BattleDataManager:LoadCars(type)
    self.BattleData:LoadCars(type)
end

function BattleDataManager:CSharpAddCarGameobject()
    self.BattleData:CSharpAddCarGameobject()
end

---@return BattleState
function BattleDataManager:IsFighting()
    if self.BattleState then
        return self.BattleState.State ~= BattleState.None
    end
    return false
end
---@return BattleState
function BattleDataManager:GetBattleState()
    return self.BattleState.State
end

function BattleDataManager:GetRoomPlayerNum()
    if self.BattleData.LuaRoomData then
        return self.BattleData.LuaRoomData:GetPlayerCount()
    end
    return 0
end

function BattleDataManager:IsLoadCarFinish()
    return self.BattleData:IsLoadCarFinish()
end

function BattleDataManager:GetProgress()
    return self.BattleData:GetProgress()
end

function BattleDataManager:HideCars()
    self.BattleData:HideCars()
end

function BattleDataManager:ShowCars()
    self.BattleData:ShowCars()
end
function BattleDataManager:EnableShellAnim()
    self.BattleData:EnableShellAnim()
end

function BattleDataManager:GetCSharpRoomData()
    return CSharpRoomInitData:CreateRoomInitData(self.BattleData.LuaRoomData)
end

function BattleDataManager:GetTrackType()
    if self.BattleData.LuaRoomData then
        return self.BattleData.LuaRoomData.TrackType
    end
    return TrackType.Free
end

function BattleDataManager:GetLevelId()
    if self.BattleData.LuaRoomData then
        return self.BattleData.LuaRoomData.LevelId
    end
    return -1
end

function BattleDataManager:GetRound()
    if self.BattleData.LuaRoomData then
        return self.BattleData.LuaRoomData.Round
    end
    return -1

end

function BattleDataManager:GetSceneName()
    if self.BattleData.LuaRoomData then
        return self.BattleData.LuaRoomData.SceneName
    end
    return ""
end
---@return RaceTrackData
function BattleDataManager:GetTrackData()
    if self.BattleData.LuaRoomData then
        return self.BattleData.LuaRoomData.TrackData
    end
    return nil
end

---@return Lua_PlayerInitData
function BattleDataManager:GetPlayerData(playerid)
    local result = nil
    local roomdata = self:GetRoomData()
    if roomdata then
        for i = 1, #roomdata.TeamList do
            local team = roomdata.TeamList[i]
            if team then
                for m = 1, #team.PlayerList do
                    local player = team.PlayerList[m]
                    if player and player.PlayerID == playerid then
                        result = player
                        break
                    end
                end
            end
        end
    end
    return result
end

function BattleDataManager:SetStateLoading()
    self.BattleState:SetStateLoading()
end

function BattleDataManager:SetStateLoadFinish()
    self.BattleState:SetStateLoadFinish()
end

function BattleDataManager:SetStateFighting(time)
    self.BattleState:SetStateFighting(time)
end

---@param result table<number,CsBattleResultData>@ 索引从0开始，c#的数组
function BattleDataManager:SetStateBattleFinish(result)
    self.BattleState:SetStateBattleFinish(result)
    RankListTestVerifyDataManager:Get():OnRecordDone(result)
end

----根据每个状态不同设置不同的结算数据，这个暂时先这么写，如果结算数据都一样的话，可以简化成一份
function BattleDataManager:SetStateBattleResult()
    self.BattleState:SetStateBattleResult()
end

function BattleDataManager:SetStateBattleExit()
    if self.BattleState then
        self.BattleState:SetStateBattleExit()
    end
end
function BattleDataManager:SetRePlayOption()
    local teamList= self.BattleData.LuaRoomData.TeamList
    for i = 1, #teamList do
        for j = 1, #teamList[i].PlayerList do
            if teamList[i].PlayerList[j].PlayerID==self.BattleData.LuaRoomData.DefaultSelectPlayerID then
                if  CommonHelper:IsNullOrEmpty(self.BattleData.LuaRoomData.TeamList[i].PlayerList[j].operate) then
                    self.BattleData.LuaRoomData.TeamList[i].PlayerList[j].operate=PlayerPrefsHelper:GetValue_ReplayInputInfos()
                end
                return
            end
        end
    end
end
function BattleDataManager:OnRaceTrotUpdateAccelBtnState(value)
    if self.BattleData.BattleType==RaceModel.RaceTrot and not value then
        self.BattleState:testStopCrash()
    end
end

function BattleDataManager:PlayAgain()
    self.BattleData:SetPlayAgain(true)
    monoRaceManager:ClearData()
    if self.BattleData.BattleType~=RaceModel.RaceSuperBattle then
        self:SetRePlayOption()
    end
    self.BattleState.State = BattleState.Fighting
    monoRaceManager:OnInit(1, true)
    monoRaceManager:StartRacing()
    self:OnRaceTrotUpdateAccelBtnState(false)
end
function BattleDataManager:OnContinueFight()
    self.BattleState:OnContinueFight()
end

function BattleDataManager:LogoutToLoginView()
    if self:IsFighting() then
        BattleDataManager:Get():SetStateBattleExit()
    end
end
---观看的是谁的回放
function BattleDataManager:GetDefaultPlayerId()
    if self.BattleData.LuaRoomData.DefaultSelectPlayerID then
        return self.BattleData.LuaRoomData.DefaultSelectPlayerID
    end
    return PlayerDataManager:Get():GetPlayerRID()
end
function BattleDataManager:OnFirstPlayDone()
    self.BattleState:OnFirstPlayDone()
end

function BattleDataManager:EnableDoubleSpeed(enable,isCheck,write)
    if self:GetBattleType()==RaceModel.GuideBattle then return end
    if enable==self.IsDoubleSpeed and isCheck then return end
    if enable then
        self.IsDoubleSpeed=true
        MonoHelper:EnableDoubleSpeed(true,write)
    else
        self.IsDoubleSpeed=false
        MonoHelper:EnableDoubleSpeed(false,write)
    end
end

function BattleDataManager:SetDefaultBattleSpeed(Value)
    self.DefaultBattleSpeed=Value
end
function BattleDataManager:GetDefaultBattleSpeed()
    return self.DefaultBattleSpeed
end
function BattleDataManager:SaveBattleData()
    -- 追加本局战斗输入记录
    local appendRecord = self.BattleState:AppendBattleResult()
    local recordValue = PlayerPrefsHelper:GetValue_ReplayInputInfos() .. appendRecord
    local resultData={}
    for k, v in pairs(self:GetBattleResultData().PlayerList) do
        table.insert(resultData,{Pid=v:GetPid(),Rank=v:GetRank(),Name=v:GetName(),PlayerType=v:GetPlayerType(),ClubName=v:GetClubName(),Icon=v:GetIcon(),
                                 IconFrame=v:GetIconFrame(),TrackIdx=v:GetTrackIdx(),Error=v:GetError(),Time=v:GetTime(),RankScore=v:GetRankScore(),CarPlanName=v:GetCarPlanName()})
    end
    ---@type BattleResultPlayerData
    local PlayerData=self:GetDefaultPlayerBattleResultData()
    -- 战斗数据
    local temp = {
        recordValue = recordValue,
        battleData = self.CurBattleMag,
        CurBattleBattleType = self.CurBattleBattleType,
        result=resultData
    }

    local json = Dll_JSON.encode(temp)

    -- 当前时间
    local nowTime = CommonHelper:GetNowTime()

    -- 确保目录存在
    local battleHistoryDirPath = self:GetBattleHistoryDirPath()
    if not CS.System.IO.Directory.Exists(battleHistoryDirPath) then
        CS.System.IO.Directory.CreateDirectory(battleHistoryDirPath)
    end
    -- 战斗数据文件名
    local fileName = string.format(
            "%04d%02d%02d_%02d%02d%02d_%d_%d_%d_%d_%s",
            nowTime.Year,
            nowTime.Month,
            nowTime.Day,
            nowTime.Hour,
            nowTime.Minute,
            nowTime.Second,
            self.CurBattleBattleType,
            PlayerData:GetError(),
            PlayerData:GetTime(),
            PlayerData:GetPid(),
            PlayerData:GetName()
    )

    local battleHistoryDataPath = self:GetBattleHistoryDataPath(fileName)
    local battleHistoryListPath = self:GetBattleHistoryListPath()

    -- 读取历史记录列表
    local battleHistoryList = {}

    if CS.System.IO.File.Exists(battleHistoryListPath) then
        local tempText = CS.System.IO.File.ReadAllText(battleHistoryListPath)

        if tempText ~= nil and tempText ~= "" then
            local decodeResult = Dll_JSON.decode(tempText)
            if decodeResult ~= nil then
                battleHistoryList = decodeResult
            end
        end
    end

    -- 添加本次战斗记录
    table.insert(battleHistoryList, fileName)
    print(battleHistoryDirPath)
    -- 保存历史记录列表
    local listText = Dll_JSON.encode(battleHistoryList)
    CS.System.IO.File.WriteAllText(
            battleHistoryListPath,
            listText
    )

    -- 保存战斗数据
    CS.System.IO.File.WriteAllText(
            battleHistoryDataPath,
            json
    )
end

function BattleDataManager:GetBattleHistoryListPath()
    return self:GetBattleHistoryDirPath() .. "/BattleHistoryList.txt"
end

function BattleDataManager:GetBattleHistoryDataPath(name)
    return string.format(
            self:GetBattleHistoryDirPath() .. "/%s.txt",
            name
    )
end

function BattleDataManager:GetBattleHistoryDirPath()
    return CS.AppPath.PersistentDataPath4Res
            .. CS.AppPath.GetPlatformName()
            .. "/BattleHistory"
end
