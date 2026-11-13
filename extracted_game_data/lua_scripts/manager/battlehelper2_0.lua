
---@class BattleHelper2_0
BattleHelper2_0 = class("BattleHelper2_0")

local battleUIParams = {}
function BattleHelper2_0.initialize()

end

function BattleHelper2_0.UpdateAccelBeanPoint(beanCount, changeCount,maxCount)
    if changeCount>0 then
        CommonHelper:PlayCollectCurrency("battle_2_boost_normal_dt", nil, nil, nil,maxCount,80,function() end)
    end

    BattleDyDataManager:Get():GetSelfCarData():SetCurShellBean(beanCount)
    BattleDyDataManager:Get():GetSelfCarData():SetMaxShellBean(maxCount)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_SetBeanCount)
end

function BattleHelper2_0.UpdateProtectGas(progress)

end

function BattleHelper2_0.UpdateAccelBtnState(isEnable)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_UpdateAccelerateBtnState, isEnable)
    --BattleDataManager:Get():OnRaceTrotUpdateAccelBtnState(isEnable)
end

function BattleHelper2_0.UpdateProtectBtnState(isEnable)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_UpdateProtectBtnState, isEnable)
end

function BattleHelper2_0.PlayAccelShowHeadFinish(obj)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_PlayBeanEffect, obj)
end

function BattleHelper2_0.ShowScreenSkillView()
    UIManager:Get():ShowPersistentView("FullScreenSkillView", CanvasType.MainCanvas,"FullScreenSkillView")
end

function BattleHelper2_0.HideScreenSkillView()
    UIManager:Get():HidePersistentView("FullScreenSkillView")
end

function BattleHelper2_0.ProtectStageStart(duration)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_ProtectStage, duration)
end


function BattleHelper2_0.UpdateRaceSwitchRelayCar(newEntityId, oldEntityId)
    print("^^^^^^^^^^^^^^^^", newEntityId, oldEntityId)
    BattleDyDataManager:Get():SwitchSelfCarDataByCarId(newEntityId)
    cs_coroutine.start(function()
        coroutine.yield()
        coroutine.yield()
        local cameraData = {}
        local cameraType = PlayerPrefsHelper:GetValue_CameraType()
        local pointIndex = PlayerPrefsHelper:GetValue_PointIndex(cameraType)

        ---@type cameratype_config
        local cameratype_config = ClientDataManager:Get():GetDataTable(ConfigNames.cameratype_config)

        cameratype_config = cameratype_config.GetConfigData()

        ---@param cell cameratype_config_cell
        for id, cell in pairs(cameratype_config) do
            local pointTableStr = stringSplit(cell.slots, ',')
            local pointTable = {}

            for i = 1, #pointTableStr do
                table.insert(pointTable, tonumber(pointTableStr[i]))
            end

            cameraData[cell.C_ID] = pointTable
        end
        --CSLuaHelper.ChangeRaceRunCameraView(cameraData[cameraType][pointIndex])

        LuaHelper.ChangeRaceRunCameraView(cameraData[cameraType][pointIndex])
    end)
end


function BattleHelper2_0.TurnOnSwitch(carTrans, anchorTrans)
    print("TurnOnSwitch________________________-", carTrans.name, anchorTrans.name)
    UIManager:Get():OpenView("BattleStartSwitchView", CanvasType.MainCanvas, "BattleStartSwitchView")

    UINotify:Get():SendNotification(UINotifyEvent.OpenSwitchViewData, { carTrans, anchorTrans} )

    --monoRaceManager:ResumeSwitchOnStatus()
end
function BattleHelper2_0.RecoverOutShow()
    print("Recover-----RecoverOutShow")
end

function BattleHelper2_0.RecoverBackWait()
    print("Recover-----RecoverBackWait")
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_RecoverStart)
end

function BattleHelper2_0.RecoverBackWaitFinish()
    print("Recover-----RecoverBackWaitFinish")
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_RecoverEnd)
end

function BattleHelper2_0.RecoverCountDown(count)

    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_CountDown, count)
    print("Recover-----RecoverCountDown :", count)
end


function BattleHelper2_0.Buff_AddBuff(id, type)
    print("Buff-----Buff_AddBuff :", id)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_BuffUpdate, {type,id,BattleBuffOpType.Add})
end


function BattleHelper2_0.Buff_RemoveBuff(id, type)
    print("Buff-----Buff_RemoveBuff :", id)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_BuffUpdate, {type,id,BattleBuffOpType.Remove})
end


function BattleHelper2_0.Buff_PlayingEnable(id, isPlaying, type,  stackCount)
    print("Buff-----Buff_IsPlaying :",id,isPlaying, stackCount,type)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_BuffUpdate, {type,id,BattleBuffOpType.Update,isPlaying,stackCount})
end


function BattleHelper2_0.Buff_SwitchEntity()

    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_BuffUpdate, {nil,nil,BattleBuffOpType.Clear,nil,nil})
    print("Buff-----Buff_SwitchEntity :")
end

function BattleHelper2_0.SetBuffCostIDType( costTypeId)
    print("Buff-----SetBuffCostIDType :", costTypeId)
    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_SetBattleCostImage, costTypeId)
end

