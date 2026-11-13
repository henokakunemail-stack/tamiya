---C#调用lua，通用模块

---@class LuaHelper
LuaHelper = class("LuaHelper")

--function MonoHelper.FuncA()
--
--end
function LuaHelper.ChangeRaceRunCameraView(cameraId)
    LuaHelper.IsCameraFollow2_2004_1(cameraId)
    if cameraId == 20041 then
        cameraId = 2004
    end

    CSLuaHelper.ChangeRaceRunCameraView(cameraId)
end

function LuaHelper.ChangeRaceInitCameraView(cameraId)
    LuaHelper.IsCameraFollow2_2004_1(cameraId)
    if cameraId == 20041 then
        cameraId = 2004
    end

    CSLuaHelper.ChangeRaceInitCameraView(cameraId)
end



function LuaHelper.IsCameraFollow2_2004_1(cameraId)
    if cameraId == 20041 then
        local followModel = CSCameraManager.Get().followModel2
        followModel.followLengthRatio = 1.2941
        followModel.followRotationRatio = 1.13
        followModel.forwardOffset = 1.531
        followModel.rotationDamping = 28.9
    else
        local followModel = CSCameraManager.Get().followModel2
        followModel.followLengthRatio = 1
        followModel.followRotationRatio = 1
        followModel.rotationDamping = 20.0
        followModel.forwardOffset = 0
    end
end

function LuaHelper.PlayVoiceAudio(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)
    if PlayerPrefsHelper:GetValue_BattleBgmOffOrOn()==0 then
        return 0
    end

    local clipLength = nil

    if GameProperties.AreaType == AreaType.AreaTypeCN then
        clipLength = RaceHelper:PlayJpVoiceAudio2(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)
    elseif GameProperties.AreaType == AreaType.AreaTypeDNY then
        clipLength = RaceHelper:PlayJpVoiceAudio(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)
    elseif GameProperties.AreaType == AreaType.AreaTypeKR then
        clipLength = RaceHelper:PlayJpVoiceAudio2(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)
    elseif GameProperties.AreaType == AreaType.AreaTypeGAT then
        clipLength = RaceHelper:PlayVoiceAudio(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)
    else
        clipLength = RaceHelper:PlayJpVoiceAudio(voiceType, trackNumber, isSelf, paramInt, floatParam, carShellId)
    end

    return clipLength
end

function LuaHelper.PlayVoiceAudioOld(voiceType, trackNumber, isSelf, paramInt)

    log("voiceType1 = ", voiceType, tostring(trackNumber), paramInt)

    RaceHelper:PlayVoiceAudioOld(voiceType, trackNumber, isSelf, paramInt)
end

---@param carAudioType CarAudioType
function LuaHelper.GetCarBattleAudioName(carAudioType, motorType)
    return RaceHelper.GetCarBattleAudioName(carAudioType, motorType)
end

-------- 战斗日志----------------------------------------------------------------------------------------------------------------
---
------
---@class RaceLogType
RaceLogType = {
    LineLog = 2, --* 直道速度统计，param1:进入直道速度，param2:离开直道速度， param3:平均速度, param4:平均加速度, param5:直线距离
    CurveLog = 3, --* 弯道速度统计，param1:进入弯道速度，param2:离开弯道速度， param3:平均速度, param4:平均加速度, param5:弯道距离
    CurveCollisionLog = 4, --* 弯道碰撞, param1:碰撞速度损失, param2:

    FlyLog = 5, --* 飞行距离 param1:飞行距离，param2:飞行前速度,param3:飞行结束速度
    FlyLandLog = 10, --* 落地碰撞速度损失 param1:损失的速度差, param2:落地的落地姿态，倾角

    UpSlopeLog = 11, --* 上坡速度统计，param1:进入坡道速度，param2:离开坡道速度， param3:平均速度，param4:平均加速度
    DownSlopeLog = 12, --* 下坡速度统计, param1:进入下坡的速度, param2:离开坡道的速度, param3:平均速度，param4:平均加速度
    BrakeInfoLog = 13, --* 刹车信息, 暂无参数

    ---- Buff -------------------
    TriggerBuffLog = 201, --* 触发了哪个buff param1:buffId
    AddBuff = 202, --* 添加了哪个buff param1:buffId

    ---- Lap ---------------------
    OneLapInfoLog = 100, --* 一圈的统计, param1:一圈的最大速度，param2:一圈的平均速度，param3:一圈的耗时, param4:排名

    ---- Complete ----------------
    FailErrorLog = 303, --* 战斗失败信息， param1:玩家赛道号, param2:失败原因
}
function LuaHelper.RaceLogOld(logType, param1, param2, param3, param4, param5)
    local talkInfo = string.format("解说：------%d", logType)

    print("----talkInfo-----", talkInfo)

    ChatDataManager:Get():AddExplainData(talkInfo)

    UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_InitChatList, ChatType.Explain)

    --logError("Race日志 ：", tostring(logType), tostring(param1),tostring(param2),tostring(param3),tostring(param4))
end
local RaceParamTable={}
function LuaHelper.RaceLogFormat(type, param1,param2,param3,param4,param5)
    if not BattleDyDataManager:Get():GetIsSelfFinished() then
        ---@type racelog_config_cell
        local cfg=CommonHelper:GetTableDataByID(ConfigNames.racelog_config,type)
        if cfg then
            RaceParamTable[1]=param1
            RaceParamTable[2]=param2
            RaceParamTable[3]=param3
            RaceParamTable[4]=param4
            RaceParamTable[5]=param5
            local param=""
            if cfg.param=="-1" then
                param=CommonHelper:GetTempStr_Default(cfg.desc)
            else
                if #cfg.ParamType==1 then
                    param=CommonHelper:GetTempStr_Default(cfg.desc,RaceParamTable[cfg.ParamType[1]])
                elseif #cfg.ParamType==2 then
                    param=CommonHelper:GetTempStr_Default(cfg.desc,RaceParamTable[cfg.ParamType[1]],RaceParamTable[cfg.ParamType[2]])
                elseif #cfg.ParamType==3 then
                    param=CommonHelper:GetTempStr_Default(cfg.desc,RaceParamTable[cfg.ParamType[1]],RaceParamTable[cfg.ParamType[2]],RaceParamTable[cfg.ParamType[3]])
                elseif #cfg.ParamType==4 then
                    param=CommonHelper:GetTempStr_Default(cfg.desc,RaceParamTable[cfg.ParamType[1]],RaceParamTable[cfg.ParamType[2]],RaceParamTable[cfg.ParamType[3]],RaceParamTable[cfg.ParamType[4]])
                elseif #cfg.ParamType==5 then
                    param=CommonHelper:GetTempStr_Default(cfg.desc,RaceParamTable[cfg.ParamType[1]],RaceParamTable[cfg.ParamType[2]],RaceParamTable[cfg.ParamType[3]],RaceParamTable[cfg.ParamType[4]],RaceParamTable[cfg.ParamType[5]])
                end
            end
            if param=="-1" then
                return
            end
            ChatDataManager:Get():AddExplainData(param)
            BattleDyDataManager:Get():AddExplain(CommonHelper:GetTempStr_Default(cfg.smallDesc))
            UINotify:Get():SendNotification(UINotifyEvent.BattleExplainView_ShowTips)
            UINotify:Get():SendNotification(UINotifyEvent.BattleNewSystemView_InitChatList, ChatType.Explain)
        end

    end
end

function LuaHelper.OnGamePlayeLevel()
    CommonHelper:PlayLevelBattle()
end

function LuaHelper.OnGamePlayerLocal()
    CommonHelper:PlayLocalBattle()
end

function LuaHelper.OnARCheckPlane(_pose)
    ARManager:Get():SetHitPose(_pose)
end
function LuaHelper.OnClickGuideOpenSkip(_pose)
  --  UINotify:Get():SendNotification(UINotifyEvent.ClickGuideOpenSkip)
end

function LuaHelper.CustomTrackUpdateItemNum()
    UINotify:Get():SendNotification(UINotifyEvent.CustomTrackUpdate)
end
function LuaHelper.GetPlayerLevel()
  return  PlayerDataManager:Get():GetPlayerLV()
end
function LuaHelper.OnGameStart()
    ClientDataManager:Get():SetGameState(GameState.After_Login)
    UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, false)
end
function LuaHelper.OnMini4WDAutoCreate()
  LoginFuncHelper:NoRacerAutoCreate()
end
function LuaHelper.OnMini4WDSetRoleIcon(head,icon,iconframe)
    if head then
        if icon then
            CommonHelper:GetComponentSetUITexture("icon", head, CommonHelper:GetPlayerIconById(icon), UIModuleID.Mini4wdBind)
        end
        if iconframe then
            CommonHelper:GetComponentSetUITexture("iconframe", head, CommonHelper:GetPlayerIconById(iconframe, nil, HeadIconAttrType.Frame), UIModuleID.Mini4wdBind)
        end
    end
end
