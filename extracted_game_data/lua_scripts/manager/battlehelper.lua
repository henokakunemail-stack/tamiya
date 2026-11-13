---@class BattleHelper
BattleHelper = class("BattleHelper")

local battleUIParams = {}
function BattleHelper:initialize()

end

function BattleHelper.UpdateProgress(num1, num2, num3, num4, num5)
    --print("---   99999999    UpdateProgress",num1,num2,num3,num4,num5)
    UINotify:Get():SendNotification(UINotifyEvent.BattleView_SetRank, { num1, num2, num3 })
end

function BattleHelper.BattleEnd(win, time)
    print("---    BattleHelper.BattleEnd", win, time)
    local type = BattleDataManager:Get():GetBattleType()


end

----战斗结算数据，所有的结算，最终都是c#调用这个方法之后，设置完结算数据，然后通知服务器，发送结算消息
----设置结算数据，在得到服务器返回战斗结束的消息之后，设置结算状态，打开结算界面
function BattleHelper.BattleEndPVP(result)
    print("---    BattleHelper.BattleEndPVP", result.results.Length)
    local loop = result.results.Length - 1
    for i = 0, loop do
        log("---   BattleHelper.BattleEndPVP", result.results[i].pid, result.results[i].rank, result.results[i].time, result.results[i].error, result.results[i].trackidx)
    end
    BattleDataManager:Get():SetStateBattleFinish(result.results)
end

function BattleHelper.GetBattleData()
    print("---   BattleHelper.GetBattleData()")
    return BattleDataManager:Get():GetCSharpRoomData()
end
function BattleHelper.GetLocalData()
    print("---   BattleHelper.GetLocalData()")
    return BattleDataManager:Get():GetCSharpRoomData()
end
function BattleHelper.GetHangUpData()
    print("---   99999999    GetHangUpData")
    --return BattleDataManager:Get():GetHangUpData()
end

function BattleHelper.HideCars()
    BattleDataManager:Get():HideCars()
end
function BattleHelper.ShowCars()
    BattleDataManager:Get():ShowCars()
end

function BattleHelper.OpenBattleView()
    print("---   BattleHelper.OpenBattleView()")
    BattleDataManager:Get():OpenBattleView()
end

function BattleHelper.UpdateBattleInfo(lap, minuteTime, secondTime, millisecond, velocity, battery, rank, playLifeValue, energy, energyCount)
    print("更新战斗信息，在c#中更新，不在lua中更新，这个方法已经废弃了")
end

---@param curRank @当前排名
---@param rankIndex  @当前排名条的位置
---@param toRank  @改变后的排名，通常改变后的排名和排名条的位置是对应的，但是有可能出现，排名一致的情况，也就是torank 一样
function BattleHelper.UpdateBattleRank(carId, curRank, rankIndex, toRank)
    local carData = BattleDyDataManager:Get():GetCarDataById(carId)
    if carData ~= -1 then
        if rankIndex ~= carData:GetCarRankIndex() or curRank ~= toRank then
            BattleDyDataManager:Get():SetCarRankById(carId, toRank, rankIndex)
            BattleDyDataManager:Get():UpdateBattleRankByTrackType({ carId, curRank, rankIndex, toRank })
            --logError("更新排名---------------")
        end
    else
        logError("没有找到该车----carId:" .. tostring(carId))
    end
end

function BattleHelper.SetSkillUI(carId)
    UINotify:Get():SendNotification(UINotifyEvent.BattleFlashView_SetSkillUI, carId)
end

function BattleHelper.InitSkillCardData(indexIds, skillIds)
    BattleDyDataManager:Get():InitCarSkillData(indexIds, skillIds)
end

function BattleHelper.PlaySkillCallback(cardCellIndex, cdTime)
    local curCarData = BattleDyDataManager:Get():GetSelfCarData()
    if curCarData == nil then
        return
    end
    curCarData:SetSkillCdByIndex(cardCellIndex, cdTime)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewOutdoorView_UpdateSkillCardDataCd, { cardCellIndex + 1, cdTime })
end
function BattleHelper.SkillCardCDFinish(cardCellIndex)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewOutdoorView_SkillCardCdFinish, cardCellIndex + 1)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_SkillCardCdFinish, cardCellIndex + 1)
end

function BattleHelper.BattleCarComplete(carId, finishTime, rank, battleFailError)
    --BattleDyDataManager:Get():OnFinishedBattleByTrackType({ carId, finishTime, rank, battleFailError })

    BattleHelper.ClearGas(carId)
end

function BattleHelper.ClearGas(entityId )
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
                        if car.entityId == entityId then
                            car:CostGas(10000)
                            print("结束清空气量")
                        end
                    end
                end
            end
        end
    end
end

function BattleHelper.BattleCarCompleteShowEnd(carId, finishTime, rank, battleFailError)
    cs_coroutine.start(function()
        coroutine.yield()
        BattleDyDataManager:Get():OnFinishedBattleByTrackType({ carId, finishTime, rank, battleFailError })
    end)
end


function BattleHelper.BattleCountDown(countDownTime)
    UINotify:Get():SendNotification(UINotifyEvent.BattleStartView_BattleCountDown, countDownTime)
end
function BattleHelper.BattleShowRaceState(time)
    UINotify:Get():SendNotification(UINotifyEvent.BattleStartView_ShowRaceState, time)
end

function BattleHelper.OpenBattleCountDownView()
    UIManager:Get():OpenView("BattleStartView", CanvasType.MainCanvas, "BattleStartView")
end
function BattleHelper.CloseBattleCountDownView()
    UIManager:Get():CloseView()
end

function BattleHelper.OpenBattleRaceInfoView()
    -- UIManager:Get():OpenView("BattleRaceInfoView",CanvasType.MainCanvas,"BattleRaceInfoView")
end
function BattleHelper.CloseBattleRaceInfoView()
    --  UIManager:Get():CloseView()
end

function BattleHelper.BundleNullError(bundleName, assetName)
    logError("RaceError : BundleNullError....", bundleName, assetName)
    LoginFuncHelper:OnAssetException(bundleName,assetName)

end

function BattleHelper.RaceThrowException(exceptionStr, roomSerializeStr)
    logError("RaceError : lua....", exceptionStr, roomSerializeStr)

    local trackData = BattleDataManager:Get():GetTrackData()
    if trackData ~= nil then
        local roomDataCopy = monoRaceManager.roomDataCopy
        if roomDataCopy ~= nil then
            local trackTable={
                exceptionStr = exceptionStr,
                levelId = trackData:GetId(),
                levelResName = trackData.resName,
                roomSerializeStr = BattleHelper.GetRoomInitLog()
            }

            QuickTa:Get():TrackEvent(TrackEventNames.RaceThrowException,trackTable)
        end
    end

end

function BattleHelper.GetRoomInitLog()
    local roomDataCopy = monoRaceManager.roomDataCopy
    if roomDataCopy ~= nil then
        local copy = roomDataCopy:Clone()
        if copy == nil then
            return {}
        end
        local data = {}
        data.rLevelId = copy.rLevelId
        data.sceneName = copy.sceneName
        data.resName = copy.resName
        data.round = copy.round
        data.raceType = copy.raceType
        data.raceStyleType = copy.raceStyleType
        data.trackType = copy.trackType
        data.track_id = copy.track_id
        data.randSeed = copy.randSeed
        data.racemodel = copy.racemodel
        data.selfPlayerId = copy.selfPlayerId
        data.map_id = copy.map_id
        data.protectType = copy.protectType
        data.isCustomTrack = copy.isCustomTrack
        data.isReplay = copy.isReplay
        data.replayInputInfos = copy.replayInputInfos
        data.teamsData = {}
        if copy.teamsData == nil then
            return {}
        end
        local teamCount = copy.teamsData.Count
        for i = 0,teamCount-1,1 do
            local team = copy.teamsData[i]
            local newTeam = {}
            table.insert( data.teamsData, newTeam)
            newTeam.team_id = team.team_id
            newTeam.playsData = {}
            local playerCount = team.playsData.Count
            for j=0, playerCount -1, 1 do
                local player = {}
                if team.playsData == nil then
                    return {}
                end
                local playerCopy = team.playsData[j]
                table.insert(newTeam.playsData, player)
                player.player_type = playerCopy.player_type
                player.player_id = playerCopy.player_id
                player.player_name = playerCopy.player_name
                player.track_number = playerCopy.track_number
                player.carsData = {}

                if playerCopy.carsData == nil then
                    return {}
                end
                if playerCopy.carsData == nil then
                    return {}
                end

                local carCount = playerCopy.carsData.Count
                for n=0, carCount-1, 1 do
                    local carData = {}

                    local carDataCopy = playerCopy.carsData[n]

                    carData.track_number = carDataCopy.track_number
                    carData.car_id = carDataCopy.car_id
                    carData.car_config_id = carDataCopy.car_config_id
                    carData.motorType = carDataCopy.motorType
                    carData.clickInterval = carDataCopy.clickInterval
                    carData.car_hero_id = carDataCopy.car_hero_id
                    carData.car_shellid = carDataCopy.car_shellid
                    carData.stickerId = carDataCopy.stickerId
                    carData.beanCount = carDataCopy.beanCount
                    carData.gasCount = carDataCopy.gasCount
                    carData.playerLevel = carDataCopy.playerLevel
                    carData.buttonUpTime = carDataCopy.buttonUpTime
                    carData.isCopyEntity = carDataCopy.isCopyEntity
                    carData.isCopyShow = carDataCopy.isCopyShow
                    carData.selfRandSeed = carDataCopy.selfRandSeed
                    carData.replayInputInfos = carDataCopy.replayInputInfos
                    carData.enableAIType = carDataCopy.enableAIType
                    carData.attrRawDatas = {}
                    local attrsCount = carDataCopy.attrRawDatas.Length
                    for k=0, attrsCount-1, 1 do
                        table.insert(carData.attrRawDatas, carDataCopy.attrRawDatas[k])
                    end
                    carData.skillids = {}
                    local skillCount = carDataCopy.skillids.Length
                    for k=0, skillCount-1, 1 do
                        table.insert(carData.skillids, carDataCopy.skillids[k])
                    end

                    carData.buffIds = {}
                    local buffCount = carDataCopy.buffIds.Length
                    for k=0, buffCount-1, 1 do
                        table.insert(carData.buffIds, carDataCopy.buffIds[k])
                    end

                    table.insert(player.carsData, carData)
                end
            end
        end
        return data
    end

    return { }
end

function BattleHelper.OnSceneTrigger(triggerId)
    logError("OnSceneTrigger : lua....", triggerId)
end

function BattleHelper.ConsumeType(consumeType)
    logError("BattleHelper : ConsumeType....", consumeType)
end

