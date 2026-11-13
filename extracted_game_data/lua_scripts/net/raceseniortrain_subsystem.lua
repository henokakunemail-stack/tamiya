---@class RaceSeniorTrainSubsystem
RaceSeniorTrainSubsystem = class("RaceSeniorTrainSubsystem")

function RaceSeniorTrainSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_ALL_SENIOR_TRAIN_S2C_RES, self, self.RecvMsg_GetChapterList)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SENIOR_TRAIN_INFO_S2C_RES, self, self.RecvMsg_GetChapterDetail)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SENIOR_TRAIN_LEVEL_INFO_S2C_RES, self, self.RecMsg_RankInfo)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SENIOR_TRAIN_REWARD_S2C_RES, self, self.RecvMsg_GetChapterBox)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SENIOR_TRAIN_ALL_REWARD_S2C_RES, self, self.RecvMsg_GetChapterBox)
    NetResponseEventManager:Get():AddListener(MsgID.SENIOR_TRAIN_BATTLE_BEGIN_S2C_RES, self, self.RecvMsg_BattleBegin)
    NetResponseEventManager:Get():AddListener(MsgID.SENIOR_TRAIN_BATTLE_FINISH_S2C_RES, self, self.RecvMsg_BattleFinish)
    NetResponseEventManager:Get():AddListener(MsgID.SWAP_SENIOR_TRAIN_S2C_RES, self, self.RecvMsg_Swap)
end

-------------------------------------------------------------获取章节列表
local GetChapterListCallBack = nil
function RaceSeniorTrainSubsystem:SendMsg_GetChapterList(func)
    GetChapterListCallBack = func
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_ALL_SENIOR_TRAIN_C2S_REQ, data)
end
function RaceSeniorTrainSubsystem:RecvMsg_GetChapterList(data)
    ---@type SC_UserChapter
    local msg = assert(Dll_PB.decode("UserChapter", data))
    print(ProtoMsgHelp.block(msg))

    RaceSeniorTrainManager:Get():UpdateMsgChapterList(msg.chapters)

    UIManager:Get():OpenView("RaceSeniorTrainView", CanvasType.MainCanvas, "RaceSeniorTrainView")
    if GetChapterListCallBack then
        GetChapterListCallBack()
        GetChapterListCallBack = nil
    end
end
-------------------------------------------------------------
local GetChapterDetailCallBack = nil

-------------------------------------------------------------获取章节详细信息
function RaceSeniorTrainSubsystem:SendMsg_GetChapterDetail(id, func)
    GetChapterDetailCallBack = func
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id })
    NetManager:Get():Send(MsgID.GET_SENIOR_TRAIN_INFO_C2S_REQ, data)
end
function RaceSeniorTrainSubsystem:RecvMsg_GetChapterDetail(data)
    ---@type SC_UserCopy
    local msg = assert(Dll_PB.decode("UserCopy", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:CloseGuideScreenEffectUIMask()
    RaceSeniorTrainManager:Get():UpdateMsgLevelList(msg)

    UIManager:Get():OpenView("RaceSeniorTrainListView", CanvasType.MainCanvas, "RaceSeniorTrainListView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceSeniorTrain_SetLevelList, msg.chapterid)
    if GetChapterDetailCallBack then
        GetChapterDetailCallBack()
        GetChapterDetailCallBack = nil
    end
end
-------------------------------------------------------------
----------------------------------------------------------------获取关卡排位信息
function RaceSeniorTrainSubsystem:SendMsg_GetChapterRank(id)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id })
    NetManager:Get():Send(MsgID.GET_SENIOR_TRAIN_LEVEL_INFO_C2S_REQ, data)
end
function RaceSeniorTrainSubsystem:RecMsg_RankInfo(data)
    ---@type SC_FastCopyInfo
    local msg = assert(Dll_PB.decode("FastCopyInfo", data))
    print(ProtoMsgHelp.block(msg))
    RaceSeniorTrainManager:Get():UpdateMsgRankInfo(msg)
    local temp = RaceSeniorTrainManager:Get():GetLevelDataByLevelId(msg.copyid)
    RaceSeniorTrainManager:Get():SetCurLevelData(temp)
    PlayerPrefsHelper:SetValue_SelfCountDownBtnUpTime(msg.powerstart)
    if msg.stop == "0" or CommonHelper:IsNullOrEmpty(msg.stop) then
        PlayerPrefsHelper:SetValue_ReplayInputInfos("")
    else
        PlayerPrefsHelper:SetValue_ReplayInputInfos(msg.stop)
    end
    SkipModuleHelper:Get():ToSelectCarView(RaceModel.RaceSeniorTrain, temp)
end
-------------------------------------------------------------



-------------------------------------------------------------领取章节宝箱
function RaceSeniorTrainSubsystem:SendMsg_GetChapterBox(chapterid, idx)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), chapterid, idx })
    NetManager:Get():Send(MsgID.GET_SENIOR_TRAIN_REWARD_C2S_REQ, data)
end
function RaceSeniorTrainSubsystem:RecvMsg_GetChapterBox(data)
    ---@type SC_ChapterAward
    local msg = assert(Dll_PB.decode("ChapterAward", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown)
    RaceSeniorTrainManager:Get():UpdateMsgChapterBoxState(msg)
    UINotify:Get():SendNotification(UINotifyEvent.RaceSeniorTrain_UpdateBox)
end
-------------------------------------------------------------
----------------------------------------------------------------领取章节宝箱
function RaceSeniorTrainSubsystem:SendMsg_GetChapterAllBox(chapterid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), chapterid })
    NetManager:Get():Send(MsgID.GET_SENIOR_TRAIN_ALL_REWARD_C2S_REQ, data)
end
-------------------------------------------------------------
function RaceSeniorTrainSubsystem:SendMsg_BattleBegin(levelid, idx)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), levelid, idx })
    NetManager:Get():Send(MsgID.SENIOR_TRAIN_BATTLE_BEGIN_C2S_REQ, data)
end

function RaceSeniorTrainSubsystem:RecvMsg_BattleBegin(data)
    ---@type SC_BeginPve
    local msg = assert(Dll_PB.decode("BeginPve", data))
    print(ProtoMsgHelp.block(msg))
    RaceSeniorTrainManager:Get():BeginBattle(msg)

end

function RaceSeniorTrainSubsystem:SendMsg_BattleFinish(levelid, carIdx, iswin, time, error, starttime, rank, recordValue)
    local localTime = 0
    if BattleDataManager:Get().BattleTime then
        localTime = BattleDataManager:Get().BattleTime
    end
    local GetFrameCount = BattleDataManager:Get():GetFrameCount()
    local GetEngineControllerFrameCount = BattleDataManager:Get():GetEngineControllerFrameCount()
    local text = "GetFrameCount:" .. tostring(GetFrameCount) .. "GetEngineControllerFrameCount:" .. tostring(GetEngineControllerFrameCount)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), levelid, carIdx, time, iswin, error, starttime, localTime, rank, recordValue })
    NetManager:Get():Send(MsgID.SENIOR_TRAIN_BATTLE_FINISH_C2S_REQ, data)
end

---@param
function RaceSeniorTrainSubsystem:RecvMsg_BattleFinish(data)
    print("---   得到战斗结算数据")
    ---@type SC_FinishPve
    local msg = assert(Dll_PB.decode("FinishPve", data))
    print(ProtoMsgHelp.block(msg))
    local pveLevelData = RaceSeniorTrainManager:Get():GetLevelDataByLevelId(msg.copyid)
    local isUp = PlayerDataManager:Get():SetPlayerLV(msg.level)
    if pveLevelData then
        if pveLevelData.levelCfg.copytype == LevelType.Story then
            if msg.curdown then
                CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown)
            end
            RaceSeniorTrainManager:Get():UpdateMsgChapterData(msg.copyid, msg.allStar, msg.unlockcopy, msg.star, msg.num, msg.winsum, msg.curStar)
            UINotify:Get():SendNotification(UINotifyEvent.PVEChapterListView_Refresh)
        else
            if msg.curdown then
                KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.curdown)
            end
            if msg.copyid == 0 then

            else
                PlayerDataManager:Get():SetLevelId(msg.copyid)
                local battleResultData = BattleDataManager:Get():GetBattleResultData()
                battleResultData:SetOtherResultData(msg, msg.curdown)
                PlayerDataManager:Get():SetPlayerEXP(msg.exp)
                RaceSeniorTrainManager:Get():UpdateMsgChapterData(msg.copyid, msg.allStar, msg.unlockcopy, msg.star, msg.num, msg.winsum, msg.curStar)
                RaceSeniorTrainManager:Get():SetIsMoreExp(msg.moreexp == 3)
                PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminaTime)
            end
            BattleDataManager:Get():SetStateBattleResult()
        end
    end
    if msg.addLev > 0 and isUp then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.levelupdown)
        CommonHelper:CheckPlayerLevelUp(msg.addLev)
    end

    QuickTa:Get():TrackEvent(TrackEventNames.PveEnd)
end
-------------------------------------------------------------扫荡
function RaceSeniorTrainSubsystem:SendMsg_Swap(levelid, num)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), levelid, num })
    NetManager:Get():Send(MsgID.SWAP_SENIOR_TRAIN_C2S_REQ, reqBytes)
end
function RaceSeniorTrainSubsystem:RecvMsg_Swap(data)
    ---@type SC_FinishPve
    local msg = assert(Dll_PB.decode("FinishPve", data))
    print(ProtoMsgHelp.block(msg))
    PlayerDataManager:Get():SetPlayerEXP(msg.exp)
    local isUp = PlayerDataManager:Get():SetPlayerLV(msg.level)
    if msg.addLev > 0 and isUp then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.levelupdown)
        CommonHelper:CheckPlayerLevelUp(msg.addLev)
    end
    CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown, true, function()
        local flag = CommonHelper:OpenLevelUpView()
        local guideId = PlayerDataManager:Get():CheckPlayerLevelUpGuide()
        if guideId ~= -1 then
            SkipModuleHelper:Get():ToMainMenuView(true)
        else
            PopupManager:Get():SetIsCheckRallyPopup(true)
            PopupManager:Get():PopRallyPopupView()
        end
    end)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)
    RaceSeniorTrainManager:Get():UpdateMsgChapterCount(msg.copyid, msg.num)
    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SwapSuccess))
    PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminaTime)
    UINotify:Get():SendNotification(UINotifyEvent.SelectTeamView_Refresh)
    UINotify:Get():SendNotification(UINotifyEvent.SelectTeamViewRaceSeniorChapterSetData, msg.copyid)
    UINotify:Get():SendNotification(UINotifyEvent.SwapView_SetData, nil)
    if UIManager:Get():IsViewShow("LabMainView") then
        UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView)
    end
    UINotify:Get():SendNotification(UINotifyEvent.Msg_Assemble)
end
-------------------------------------------------------------


local __subsystem = RaceSeniorTrainSubsystem()
function RaceSeniorTrainSubsystem:Get()
    return __subsystem
end
return __subsystem