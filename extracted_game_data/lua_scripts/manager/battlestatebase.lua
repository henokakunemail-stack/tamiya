


---@class BattleStateBase
BattleStateBase = class("BattleStateBase")

function BattleStateBase:initialize()
    self.State = BattleState.None
end

function BattleStateBase:SetStateLoading()
    self.State = BattleState.Loading
end

function BattleStateBase:SetStateLoadFinish()
    self.State = BattleState.LoadFinish
    UIManager:Get():OpenView("BattleStartSkipView", CanvasType.MainCanvas, "BattleStartSkipView")

end

function BattleStateBase:SetStateFighting(time)
    log("racelog_SetStateFighting")
    self.State = BattleState.Fighting
    if time == nil then time = -1 end
    CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsReverseMove = false
    CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableSegmentWarnLight = PlayerPrefsHelper:GetValue_GameTrackCheck()==1
    if BattleDataManager:Get():GetBattleType()==RaceModel.Battle then
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsUseTurnOnSwitch = false
    else
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsUseTurnOnSwitch = false
    end
    if CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsUseTurnOnSwitch == false then
        CS.LuaHelper.Get():SetNormalSpeed(15)
    end
    --CS. Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableBackHitCrash=true
    --if GameProperties.AreaType==AreaType.AreaTypeCN and BattleDataManager:Get():GetBattleType()==RaceModel.RaceRank then
    --    CS. Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableBackHitCrash=false
    --end
    if BattleDataManager:Get():GetBattleType()==RaceModel.Battle   and PVEChapterDataManager:Get():GetCurLevelData().id<=10020005  then
        if CommonHelper:CheckPlayerIsNewGuide() then
            CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableLandDownTurnOver = false
        else
            CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableCurveTurnOver = true
            CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableLandDownTurnOver = false
            CSLuaHelper.Get():SetGuideCrashState(false)

        end
    else
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableCurveTurnOver = true
        CS.Horizon.Game.LogicLayer.RaceGlobalSetting.IsEnableLandDownTurnOver = true
        CSLuaHelper.Get():SetGuideCrashState(false)
    end
    CSCameraManager.Get():DisableCustomTrackCamera()
    CommonHelper:CloseLoading()
    monoRaceManager:OnInit(1,BattleDataManager:Get():IsReplay())
    monoRaceManager:StartRacing(time)
    self:OnStartRace()
end

function BattleStateBase:JumpRacing(time)
    monoRaceManager:JumpRacing(time * 0.001)
end

function BattleStateBase:SetStateBattleFinish(result)
    self.State = BattleState.BattleFinish
    self:OnFinishRace()
end

function BattleStateBase:SetStateBattleResult()
    self.State = BattleState.BattleResult
end

function BattleStateBase:SetStateBattleExit()
    self.State = BattleState.None
    RankListTestVerifyDataManager:Get():CloseRecord(BattleDataManager:Get():GetBattleType())
    RaceBulider:Get():Clear()
    BattleDataManager:Get():ClearData()
    BattleDyDataManager:Get():ClearBattleDyData()
end

function BattleStateBase:OnStartRace()
    log("racelog_OnStartRace")
   local data = self:GetAttrJsonData()
   local roomData = self:GetRoomJsonData()
    self:TrackBattleInfoEvent(data, roomData, "race_start")
    GameProperties.m_IsFight = true;
end
function BattleStateBase:OnFinishRace()
    log("racelog_OnFinishRace")
    local data = self:GetAttrJsonData()
    local roomData = self:GetRoomJsonData()
    BattleDataManager:Get():EnableDoubleSpeed(false,false,false)
    self:TrackBattleInfoEvent(data, roomData, "race_finish")
    self:TrackBattleFailInfoEvent()
    self:TrackBattleRoomInitData()
    GameProperties.m_IsFight = false;
end


function BattleStateBase:OnContinueFight()

    monoRaceManager:Clear()
    BattleDataManager:Get():ClearData()
    BattleDyDataManager:Get():ClearBattleDyData()

    if RaceTrackDataManager:Get().TrackObj then
        GameObject.Destroy(RaceTrackDataManager:Get().TrackObj)
        RaceTrackDataManager:Get().TrackObj=nil
    end
    SelfDefineTrack:Clear()
    local value= PVEChapterDataManager:Get().Queue:DeQueueBack()
    BattleDataManager:Get():SetRoomData(value, RaceModel.Battle)
    self.coroutine = cs_coroutine.start(function(param)

        BattleDataManager:Get():LoadCars(BattleDataManager:Get():GetBattleType())
        if BattleDataManager:Get():GetTrackData() then
            self.raceTrackAsset = CommonHelper:LoadRaceTrack(BattleDataManager:Get():GetTrackData(),false)
        end
        while not BattleDataManager:Get():IsLoadCarFinish() do
            coroutine.yield()
        end
        if self.raceTrackAsset then
            while not self.raceTrackAsset.isDone do
                coroutine.yield()
            end
        end

        if SelfDefineTrack ~= nil then
            while not SelfDefineTrack:isDone() do
                coroutine.yield()
            end
        end
        BattleDataManager:Get():CSharpAddCarGameobject()
        self.State = BattleState.Fighting
        monoRaceManager:OnInit(1, false)
        monoRaceManager:StartRacing()

    end)

end

function BattleStateBase:OnFirstPlayDone()
    local data = self:GetAttrJsonData()
    local roomData = self:GetRoomJsonData()
    self:TrackBattleInfoEvent(data, roomData, "race_firstdone")
end
function BattleStateBase:TrackBattleInfoEvent(AttrData,roomData,stateType)
    local copyid=-1
    local  type=BattleDataManager:Get():GetBattleType()
    if type==RaceModel.Battle then
        copyid=PVEChapterDataManager:Get():GetCurLevelData().id
    end
    if type==RaceModel.RaceRank then
        copyid=RaceRankManager:Get():GetRoomId()
    end
    local trackTable=
    {
        account = PlayerDataManager:Get():GetPlayerUID(),
        role_id = PlayerDataManager:Get():GetPlayerRID(),
        created_time = tostring(CS.ServerTime:Get():ServerTimeNow()),--CS.ServerTime:Get():ServerTimeNow(),
        state_type= stateType,
        attr_data = AttrData,
        room_data = roomData,

        pve_type = BattleDataManager:Get():GetBattleType(),
        copy_id = copyid,
    }


    QuickTa:Get():TrackEvent(TrackEventNames.RaceLog,trackTable)

end

function BattleStateBase:TrackBattleResultErrorLog(name,result)
    local errorTable={}
    errorTable.name=name
    errorTable.resultLength="result.Length"..result.Length
    errorTable.PlayerID="PlayerID"..PlayerDataManager:Get():GetPlayerRID()
    errorTable.DefaultPlayerId="DefaultPlayerId"..BattleDataManager:Get():GetDefaultPlayerId()
    local rids=""
    for i = 0, result.Length - 1 do
        rids=rids.."---"..result[i].pid
    end
    errorTable.Rids="Rids"..rids
    QuickTa:Get():TrackEvent(TrackEventNames.RaceBattleResultErrorLog,errorTable)
end

function BattleStateBase:TrackBattleFailInfoEvent()
    local result=nil
    local raceManager = monoRaceManager
    if raceManager then
        local lockStepManager =monoRaceManager.lockstepManager
        if lockStepManager then
            local room = lockStepManager._room
            if room then
                local allCars = room._allCars
                if allCars then
                    local carCount =allCars.Count
                    for i = 1, carCount do
                        local car = allCars[i-1]
                        if car.ownPlayer.IsSelf then
                            local carDynamicData = car._carDynamicData
                            if carDynamicData.failErrorType ~= CS.Horizon.Game.LogicLayer.BattleFailError.None then
                                result = {}
                                local gData = car._statisticsData
                                local analysisLog = gData.analysisLog
                                result["uid"] = analysisLog.uid
                                result["levelId"] = analysisLog.levelId
                                result["track"] = analysisLog.track
                                result["reason"] = analysisLog.reason
                                result["sreason"] = analysisLog.sreason
                                result["time"] = analysisLog.time:ToString()
                                result["speed"] = analysisLog.speed:ToString()
                                result["key"] = analysisLog.key:ToString()
                                result["attr1"] = analysisLog.attr1:ToString()
                                result["value1"] = analysisLog.value1
                                result["expect1"] = analysisLog.expect1:ToString()
                                result["attr2"] = analysisLog.attr2:ToString()
                                result["value2"] = analysisLog.value2
                                result["expect2"] = analysisLog.expect2:ToString()
                                local gData = car._statisticsData

                                self:SetFailReasonLog(result)
                                --logError("1111111111111111111111116666666666666666666666")
                                logError("lua失败打点日志", gData.analysisLog:ToString())
                                QuickTa:Get():TrackEvent(TrackEventNames.RaceFailReason,result)
                            end
                        end
                    end
                end
            end
        end
    end

    return result
end

function BattleStateBase:SetFailReasonLog(reasonLog)

end

function BattleStateBase:TrackBattleRoomInitData()
    local copyid=-1
    local  type=BattleDataManager:Get():GetBattleType()
    --if type==RaceModel.Battle then
    --    copyid=PVEChapterDataManager:Get():GetCurLevelData().id
    --end
    if type==RaceModel.RaceRank then
        if BattleDataManager:Get():IsReplay() == true then
            print("room data : replay")
        else
            copyid=RaceRankManager:Get():GetRoomId()

            local raceManager = monoRaceManager
            if raceManager then
                local roomData = raceManager.roomDataCopy

                for i = 1, roomData.teamsData.Count do
                    local team = roomData.teamsData[i-1]
                    for j = 1, team.playsData.Count do
                        local player = team.playsData[j-1]
                        player.player_name = ""
                        for n=1, player.carsData.Count do
                            local carData = player.carsData[n-1]
                            carData.attrData = nil
                        end
                    end
                end
                roomData.trackData = nil
                roomData.miniTrackData = nil
                roomData.miniTrackModel = nil
                roomData.chapterConfig = nil
                --local roomDataStr = Dll_JSON.encode(roomData)
                --local roomDataStr = CS.JsonFx.Json.JsonWriter.Serialize(roomData)
                local roomDataStr = ""
                local result={}
                result.version = CommonHelper.GetClientVersion()
                result.copyid = copyid
                result.result = roomDataStr
                print("room data :",roomDataStr, copyid, result.version)
                --logError("room data :",copyid, roomDataStr, roomData)
                QuickTa:Get():TrackEvent(TrackEventNames.RoomInitDataLog,result)
            end
        end
    end
end

---@return table<number, Lua_PartData>
function BattleStateBase:GetAttrJsonData()
    local result={}
    --result.parts={}
    result.attrs={}

    local raceManager = monoRaceManager
    if raceManager then

        local lockStepManager =monoRaceManager.lockstepManager
        if lockStepManager then
            local room = lockStepManager._room
            if room then
                local allCars = room._allCars

                if allCars then
                    local carCount =allCars.Count

                    --for n=1, 3 do
                        --for i = 1, carCount do
                        for i = 1, carCount do
                            local car = allCars[i-1]

                            result["car_attrs_"..tostring(i)] = {}
                            local attrLog = result["car_attrs_"..tostring(i)]

                              if car then
                                  local carStaticData = car._carStaticData
                                  local carDynamicData = car._carDynamicData
                                  local statisticsData =car._statisticsData
                                  if carStaticData then
                                      attrLog["sData"] = {}
                                      local sDataLog =  attrLog["sData"]
                                      sDataLog["playerId"] = car.ownPlayer.playerId
                                      sDataLog["1"] = carStaticData.carTorqueData.MaxRPM:ToString()
                                      sDataLog["2"] = carStaticData.carTorqueData.MaxTorque:ToString()
                                      sDataLog["3"] = carStaticData.SafeStability:ToString()
                                      sDataLog["4"] = carStaticData.Durability:ToString()
                                      sDataLog["5"] = carStaticData.Mass:ToString()
                                      sDataLog["6"] = carStaticData.SafeAirDownPressure:ToString()
                                      sDataLog["7"] = carStaticData.AirDragFactor:ToString()
                                      --sDataLog["8"] = carStaticData.EnergySaving:ToString()
                                      sDataLog["9"] = carStaticData.SafeTransmissionEfficiency:ToString()
                                      sDataLog["10"] = carStaticData.TireElasticity:ToString()
                                      sDataLog["11"] = carStaticData.Damping:ToString()
                                      sDataLog["12"] = carStaticData.StaticWheelFrictionAttr:ToString()
                                      sDataLog["13"] = carStaticData.RollingWheelFrictionAttr:ToString()
                                      sDataLog["14"] = carStaticData.SafelossRPM:ToString()
                                      sDataLog["15"] = carStaticData.SafeLossTorque:ToString()
                                      sDataLog["16"] = carStaticData.GuideFrictionAttr:ToString()
                                      sDataLog["17"] = carStaticData.GuideRestitution:ToString()
                                      --sDataLog["18"] = carStaticData.BrakingForceAttr:ToString()
                                      sDataLog["19"] = carStaticData.GearRadio:ToString()
                                      sDataLog["20"] = carStaticData.BackWheelRadius:ToString()
                                      sDataLog["21"] = carStaticData.TireRestitution:ToString()
                                      --sDataLog["22"] = carStaticData.GuideDiameter:ToString()
                                      --sDataLog["23"] = carStaticData.energyCost:ToString()

                                      --sDataLog["1_MaxRPM_2"] = carStaticData.MaxRPM_2:ToString()
                                      --sDataLog["2_MaxTorque2"] = carStaticData.MaxTorque2:ToString()
                                      --sDataLog["3_Stability"] = carStaticData.Stability:ToString()
                                      --sDataLog["4_Durability"] = carStaticData.Durability:ToString()
                                      --sDataLog["6_AirDownPressure"] = carStaticData.AirDownPressure:ToString()
                                  end
                                  attrLog["dData"] = {}
                                  local dDataLog =  attrLog["dData"]
                                  if carDynamicData then

                                      dDataLog["speed"] = carDynamicData.speed:ToString()
                                      dDataLog["position"] = carDynamicData.position:ToString()
                                      dDataLog["LapCount"] = carDynamicData.LapCount
                                      dDataLog["oneLapLength"] = carDynamicData.oneLapLength:ToString()
                                      dDataLog["currentLength"] = carDynamicData.currentLength:ToString()
                                      dDataLog["rank"] = carDynamicData.rank
                                      dDataLog["totalTime"] = carDynamicData.totalTime:ToString()
                                      dDataLog["LapCount"] = carDynamicData.LapCount
                                      dDataLog["endTime"] = carDynamicData.CompleteTime:ToString()
                                      dDataLog["endRank"] = carDynamicData.completeRank
                                      dDataLog["maxSpeed"] = carDynamicData.maxRecordSpeed:ToString()
                                      dDataLog["minSpeed"] = carDynamicData.minRecordSpeed:ToString()
                                      dDataLog["failErrorType"] = carDynamicData.failErrorType:ToString()
                                      dDataLog["lineCount"] = carDynamicData.passedLineCount:ToString()
                                      dDataLog["segCount"] = carDynamicData.passedSegmentCount:ToString()
                                      dDataLog["rankIndex"] = carDynamicData.rankIndex:ToString()
                                      dDataLog["CompleteLength"]=carDynamicData.CompleteLength:ToString()
                                      dDataLog["endFrameCount"]=carDynamicData.CompleteFrameCount:ToString()
                                      dDataLog["completeTime2"]=carDynamicData.FrameCompleteTime:ToString()

                                  end

                                  if statisticsData then
                                      if carDynamicData.CompleteTime then
                                          dDataLog["averageSpeed"] = (carDynamicData.totalTargetLength/carDynamicData.CompleteTime):ToString()
                                      end
                                  end
                              end
                            --[[
                                 if car then
                                     local carStaticData = car._carStaticData
                                     local carDynamicData = car._carDynamicData
                                     local statisticsData =car._statisticsData
                                     if carStaticData then
                                         attrLog["sData"] = {}
                                         local sDataLog =  attrLog["sData"]
                                         sDataLog["playerId"] = car.ownPlayer.playerId
                                         sDataLog["1_maxRPM"] = carStaticData.carTorqueData.maxRPM:ToString()
                                         sDataLog["2_maxTorque"] = carStaticData.carTorqueData.maxTorque:ToString()
                                         sDataLog["3_Stability"] = carStaticData.Stability:ToString()
                                         sDataLog["4_Durability"] = carStaticData.Durability:ToString()
                                         sDataLog["5_Mass"] = carStaticData.Mass:ToString()
                                         sDataLog["6_AirDownPressure"] = carStaticData.AirDownPressure:ToString()
                                         sDataLog["7_AirDragFactor"] = carStaticData.AirDragFactor:ToString()
                                         sDataLog["8_EnergySaving"] = carStaticData.EnergySaving:ToString()
                                         sDataLog["9_TransmissionEfficiency"] = carStaticData.TransmissionEfficiency:ToString()
                                         sDataLog["10_TireElasticity"] = carStaticData.TireElasticity:ToString()
                                         sDataLog["11_Damping"] = carStaticData.Damping:ToString()
                                         sDataLog["12_StaticWheelFrictionAttr"] = carStaticData.StaticWheelFrictionAttr:ToString()
                                         sDataLog["13_RollingWheelFrictionAttr"] = carStaticData.RollingWheelFrictionAttr:ToString()
                                         sDataLog["14_LossRPM"] = carStaticData.LossRPM:ToString()
                                         sDataLog["15_LossTorque"] = carStaticData.LossTorque:ToString()
                                         sDataLog["16_GuideFrictionAttr"] = carStaticData.GuideFrictionAttr:ToString()
                                         sDataLog["17_GuideRestitution"] = carStaticData.GuideRestitution:ToString()
                                         sDataLog["18_BrakingForceAttr"] = carStaticData.BrakingForceAttr:ToString()
                                         sDataLog["19_GearRadio"] = carStaticData.GearRadio:ToString()
                                         sDataLog["20_BackWheelRadius"] = carStaticData.BackWheelRadius:ToString()
                                         sDataLog["21_TireRestitution"] = carStaticData.TireRestitution:ToString()
                                         sDataLog["22_GuideDiameter"] = carStaticData.GuideDiameter:ToString()
                                         sDataLog["23_energyCost"] = carStaticData.energyCost:ToString()
                                         sDataLog["32_GuideLeanAngle"] = carStaticData.GuideLeanAngle:ToString()
                                         sDataLog["35_WheelDistance"] = carStaticData.WheelDistance:ToString()
                                         sDataLog["36_carWidth"] = carStaticData.carWidth:ToString()

                                         sDataLog["37_gravityCenter"] = carStaticData.gravityCenter:ToString()

                                         sDataLog["1_MaxRPM_2"] = carStaticData.MaxRPM_2:ToString()
                                         sDataLog["2_MaxTorque2"] = carStaticData.MaxTorque2:ToString()
                                         sDataLog["3_Stability"] = carStaticData.Stability:ToString()
                                         sDataLog["4_Durability"] = carStaticData.Durability:ToString()
                                         sDataLog["6_AirDownPressure"] = carStaticData.AirDownPressure:ToString()
                                     end
                                     attrLog["dData"] = {}
                                     local dDataLog =  attrLog["dData"]
                                     if carDynamicData then

                                         dDataLog["speed"] = carDynamicData.speed:ToString()
                                         dDataLog["position"] = carDynamicData.position:ToString()
                                         dDataLog["LapCount"] = carDynamicData.LapCount
                                         dDataLog["oneLapLength"] = carDynamicData.oneLapLength:ToString()
                                         dDataLog["currentLength"] = carDynamicData.currentLength:ToString()
                                         dDataLog["totalTargetLength"] = carDynamicData.totalTargetLength:ToString()
                                         dDataLog["rank"] = carDynamicData.rank
                                         dDataLog["totalTime"] = carDynamicData.totalTime:ToString()
                                         dDataLog["LapCount"] = carDynamicData.LapCount
                                         dDataLog["completeTime"] = carDynamicData.completeTime:ToString()
                                         dDataLog["completeRank"] = carDynamicData.completeRank
                                         dDataLog["maxRecordSpeed"] = carDynamicData.maxRecordSpeed:ToString()
                                         dDataLog["minRecordSpeed"] = carDynamicData.minRecordSpeed:ToString()
                                         dDataLog["energy"] = carDynamicData.energy:ToString()
                                         dDataLog["currentBattery"] = carDynamicData.currentBattery:ToString()

                                     end

                                     if statisticsData then
                                         dDataLog["passCurveCount"] = statisticsData.passCurveCount
                                         dDataLog["averageSpeed"] = (carDynamicData.oneLapLength/carDynamicData.totalTime):ToString()
                                     end
                                 end --]]
                     --   end
                    end
                end
            end
        end
    end

    return result
end
function BattleStateBase:AppendBattleResult()

    local raceManager = monoRaceManager
    if raceManager then
        local lockStepManager =monoRaceManager.lockstepManager
        if lockStepManager then
            local room = lockStepManager._room
            if room then
                local allCars = room._allCars

                if allCars then
                    local carCount =allCars.Count

                    --for n=1, 3 do
                    --for i = 1, carCount do
                    for i = 1, carCount do
                        local car = allCars[i-1]
                        if car.IsSelf then
                            local carDynamicData = car._carDynamicData
                            local num0 = carDynamicData.FrameCompleteTime:AsInt()
                            local num1 = carDynamicData.passedLineCount.Value
                            local num2 = carDynamicData.passedSegmentCount.Value
                            local num3 = carDynamicData.currentLength:AsInt()
                            local num4 = carDynamicData.totalTime:AsInt()
                            local num5 =carDynamicData.CompleteLength.Value:AsInt()
                            local num6 = carDynamicData.CompleteFrameCount.Value
                            local num7 = carDynamicData.maxRecordSpeed:AsInt()
                            local num8 = carDynamicData.minRecordSpeed:AsInt()
                            local num9 = carDynamicData.totalTargetLength:AsInt()
                            local num10 = 0
                            local num11 = ""

                            if car.RoomInitData ~= nil and car.RoomInitData.miniTrackModel ~= nil then
                                if car.RoomInitData.miniTrackModel ~= nil then
                                    num10 = car.RoomInitData.miniTrackModel.segmentModels.Count *11 + 1289
                                    num11 = car.RoomInitData.resName
                                end
                            end


                            local result = string.format("-1,0,-1,%d#%d#%d#%d#%d#%d#%d#%d#%d#%d#%d#%s",num0,num1,num2,num3,num4,num5,num6,num7,num8,num9,num10,num11)
                            return result
                        end
                    end
                end
            end
        end
    end
    return ""
end
function BattleStateBase:GetRoomJsonData()
    local result={}
    --result.parts={}
    result.attrs={}

    local raceManager = monoRaceManager
    if raceManager then
        local lockStepManager = raceManager.lockstepManager
        if lockStepManager then
            local room = lockStepManager._room
            if room then
                local roomData = room.roomDData
                result.attrs["totalTime"] = roomData.totalTime:ToString()
                result.attrs["totalRaceTime"] = roomData.TotalRaceTime:ToString()
                result.attrs["isAllComplete"] = roomData.isAllComplete
                result.attrs["frameCount"] = room.frameCount
            end

            result.attrs["LockstepManager.frameCount"] = lockStepManager.frameCount
        end

    end

    return result
end




