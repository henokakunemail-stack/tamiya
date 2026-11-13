---@class ChapterSubsystem
ChapterSubsystem = class("ChapterSubsystem")

function ChapterSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_ALL_CHAPTER_S2C_RES, self, self.RecvMsg_GetChapterList)
    NetResponseEventManager:Get():AddListener(MsgID.GET_CHAPTER_INFO_S2C_RES, self, self.RecvMsg_GetChapterDetail)
    NetResponseEventManager:Get():AddListener(MsgID.GET_LEVEL_INFO_S2C_RES, self, self.RecMsg_RankInfo)
    NetResponseEventManager:Get():AddListener(MsgID.GET_CHAPTER_REWARD_S2C_RES, self, self.RecvMsg_GetChapterBox)
    NetResponseEventManager:Get():AddListener(MsgID.GET_CHAPTER_ALL_REWARD_S2C_RES, self, self.RecvMsg_GetChapterBox)
    NetResponseEventManager:Get():AddListener(MsgID.CHAPTER_BATTLE_BEGIN_S2C_RES, self, self.RecvMsg_BattleBegin)
    NetResponseEventManager:Get():AddListener(MsgID.CHAPTER_BATTLE_FINISH_S2C_RES, self, self.RecvMsg_BattleFinish)
    NetResponseEventManager:Get():AddListener(MsgID.SWAP_CHAPTER_S2C_RES, self, self.RecvMsg_Swap)
    NetResponseEventManager:Get():AddListener(MsgID.GET_CHAPTER_RANK_LIST_S2C_RES, self, self.RecvMsg_ChapterRankList)
end

-------------------------------------------------------------获取章节列表
local GetChapterList = nil
local _param = nil
function ChapterSubsystem:SendMsg_GetChapterList(func, param)
    GetChapterList = func
    _param = param
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_ALL_CHAPTER_C2S_REQ, data, true)
end
function ChapterSubsystem:RecvMsg_GetChapterList(data)
    ---@type SC_UserChapter
    local msg = assert(Dll_PB.decode("UserChapter", data))
    print(ProtoMsgHelp.block(msg))

    PVEChapterDataManager:Get():UpdateMsgChapterList(msg.chapters)

    UIManager:Get():OpenView("PveChapterView", CanvasType.MainCanvas, "PveChapterView")
    if GetChapterList then
        GetChapterList()
        GetChapterList = nil
    end
end
-------------------------------------------------------------

local GetChapterDetailFun = nil
-------------------------------------------------------------获取章节详细信息
function ChapterSubsystem:SendMsg_GetChapterDetail(id, func)
    GetChapterDetailFun = func
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id })
    NetManager:Get():Send(MsgID.GET_CHAPTER_INFO_C2S_REQ, data, true)
end
function ChapterSubsystem:RecvMsg_GetChapterDetail(data)
    ---@type SC_UserCopy
    local msg = assert(Dll_PB.decode("UserCopy", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:CloseGuideScreenEffectUIMask()
    PVEChapterDataManager:Get():UpdateMsgLevelList(msg)

    UIManager:Get():OpenView("PveChapterListView", CanvasType.MainCanvas, "PveChapterListView")
    UINotify:Get():SendNotification(UINotifyEvent.PveChapterListView_SetLevelList, msg.chapterid)
    if GetChapterDetailFun then
        GetChapterDetailFun()
        GetChapterDetailFun = nil
    end
end
-------------------------------------------------------------
----------------------------------------------------------------获取关卡排位信息
local _SendPlayerId = nil
local _RecordType = nil
function ChapterSubsystem:SendMsg_GetChapterRank(id, playerId, type, serverID)
    _SendPlayerId = playerId
    _RecordType = type
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id, playerId, serverID or PlayerDataManager:Get():GetPlayerServerID() })
    NetManager:Get():Send(MsgID.GET_LEVEL_INFO_C2S_REQ, data)
end
function ChapterSubsystem:RecMsg_RankInfo(data)
    ---@type SC_FastCopyInfo
    local msg = assert(Dll_PB.decode("FastCopyInfo", data))
    print(ProtoMsgHelp.block(msg))
    if _SendPlayerId == 0 then
        local temp = PVEChapterDataManager:Get():GetLevelDataByLevelId(msg.copyid)
        local temp2 = NewBieChapterDataManager:Get():GetLevelDataByLevelId(msg.copyid)
        if temp then
            PVEChapterDataManager:Get():UpdateMsgRankInfo(msg)
            PVEChapterDataManager:Get():SetCurLevelData(temp)
            if #temp:GetBattleInfo() > 1 then
                UINotify:Get():SendNotification(UINotifyEvent.PVEChapterListView_SetViewInfo, { "PveChapterLevelInfoView", true })
                UIManager:Get():OpenPopup("PveChapterLevelInfoView", CanvasType.MainCanvas, "PveChapterLevelInfoView")
                UINotify:Get():SendNotification(UINotifyEvent.PVEChapterLevelInfoView_SetData)
            else
                SkipModuleHelper:Get():ToSelectCarView(RaceModel.Battle, temp)
            end
        end
        if temp2 then
            NewBieChapterDataManager:Get():UpdateMsgRankInfo(msg)
            NewBieChapterDataManager:Get():SetCurLevelData(temp2)
            if #temp2:GetBattleInfo() > 1 then
                UINotify:Get():SendNotification(UINotifyEvent.PVEChapterListView_SetViewInfo, { "PveChapterLevelInfoView", true })
                UIManager:Get():OpenPopup("PveChapterLevelInfoView", CanvasType.MainCanvas, "PveChapterLevelInfoView")
                UINotify:Get():SendNotification(UINotifyEvent.PVEChapterLevelInfoView_SetData)
            else
                UIManager:Get():OpenView("NewPlayerSelectCarView", CanvasType.MainCanvas, "NewPlayerSelectCarView")
                UINotify:Get():SendNotification(UINotifyEvent.NewPlayerSelectCarViewSetData, { RaceModel.NewBieChapter, temp2 })
            end
        end

    else
        RankListTestVerifyDataManager:Get():SetLookVersion(msg.ver)
        ---@type PVEChapterRankData
        local temp = PVEChapterRankData(msg)
        if #temp.CarList <= 0 then
            RankListTestVerifyDataManager:Get().Recording = false
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecordDataNot))
            return
        end
        if _RecordType == RankingListType.PveChapter then
            PVEChapterDataManager:Get():BeginHistoryBattle(msg.copyid, temp)
        end
        if _RecordType == RankingListType.SpecialTraining then
            PlayerPrefsHelper:SetValue_SelfCountDownBtnUpTime(temp.StarTimes[1])
            if temp.Stops == nil or CommonHelper:IsNullOrEmpty(temp.Stops[1]) then
                PlayerPrefsHelper:SetValue_ReplayInputInfos("")
            else
                PlayerPrefsHelper:SetValue_ReplayInputInfos(temp.Stops[1])
            end
            SpecialTrainingDataManager:Get():RaceBattleDataHistory(msg.copyid, temp)
        end
        if _RecordType == RankingListType.RaceCarGod then
            RaceCarGodDataManager:Get():BeginHistoryBattle(msg.copyid, temp)
        end
    end


end
-------------------------------------------------------------



-------------------------------------------------------------领取章节宝箱
function ChapterSubsystem:SendMsg_GetChapterBox(chapterid, idx)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), chapterid, idx })
    NetManager:Get():Send(MsgID.GET_CHAPTER_REWARD_C2S_REQ, data)
end
function ChapterSubsystem:RecvMsg_GetChapterBox(data)
    ---@type SC_ChapterAward
    local msg = assert(Dll_PB.decode("ChapterAward", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown)
    PVEChapterDataManager:Get():UpdateMsgChapterBoxState(msg)
    UINotify:Get():SendNotification(UINotifyEvent.PVEChapterListView_UpdateBox)
end
-------------------------------------------------------------
----------------------------------------------------------------领取章节宝箱
function ChapterSubsystem:SendMsg_GetChapterAllBox(chapterid)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), chapterid })
    NetManager:Get():Send(MsgID.GET_CHAPTER_ALL_REWARD_C2S_REQ, data)
end
-------------------------------------------------------------
function ChapterSubsystem:SendMsg_BattleBegin(levelid, idx)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), levelid, idx })
    NetManager:Get():Send(MsgID.CHAPTER_BATTLE_BEGIN_C2S_REQ, data)
end

function ChapterSubsystem:RecvMsg_BattleBegin(data)
    ---@type SC_BeginPve
    local msg = assert(Dll_PB.decode("BeginPve", data))
    local copy = PVEChapterDataManager:Get():GetLevelDataByLevelId(msg.copyid)
    if copy then
        PVEChapterDataManager:Get():BeginBattle(msg)
        return
    end
    copy = NewBieChapterDataManager:Get():GetLevelDataByLevelId(msg.copyid)
    if copy then
        NewBieChapterDataManager:Get():BeginBattle(msg)
    end
end
local _OpenType = nil
function ChapterSubsystem:SendMsg_ChapterRankList(levelid, type)
    _OpenType = type
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), levelid })
    NetManager:Get():Send(MsgID.GET_CHAPTER_RANK_LIST_C2S_REQ, data)
end

function ChapterSubsystem:RecvMsg_ChapterRankList(data)
    ---@type SC_BeginPve
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))
    msg.ranktype = _OpenType
    RankingListDataManager:Get():Init(msg)
    UIManager:Get():ShowPersistentView("PveChapterRankListView", CanvasType.FrontCanvas, "PveChapterRankListView")
end

function ChapterSubsystem:SendMsg_BattleFinish(levelid, carIdx, rank, time, error, starttime, rankres, recordValue)
    local localTime = 0
    if BattleDataManager:Get().BattleTime then
        localTime = BattleDataManager:Get().BattleTime
    end
    print("init battle car id 3", carIdx)
    local GetFrameCount = BattleDataManager:Get():GetFrameCount()
    local GetEngineControllerFrameCount = BattleDataManager:Get():GetEngineControllerFrameCount()
    local text = "GetFrameCount:" .. tostring(GetFrameCount) .. "GetEngineControllerFrameCount:" .. tostring(GetEngineControllerFrameCount)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), levelid, carIdx, time, rank, error, starttime, text, rankres, recordValue })
    NetManager:Get():Send(MsgID.CHAPTER_BATTLE_FINISH_C2S_REQ, data)
end

---@param
function ChapterSubsystem:RecvMsg_BattleFinish(data)
    print("---   得到战斗结算数据")
    ---@type SC_FinishPve
    local msg = assert(Dll_PB.decode("FinishPve", data))
    print(ProtoMsgHelp.block(msg))
    local newChapterData = NewBieChapterDataManager:Get():GetLevelDataByLevelId(msg.copyid)
    if newChapterData then
        BattleDataManager:Get():SetStateBattleResult()
        return
    end
    local pveLevelData = PVEChapterDataManager:Get():GetLevelDataByLevelId(msg.copyid)
    local isUP = PlayerDataManager:Get():SetPlayerLV(msg.level)
    if pveLevelData then
        if pveLevelData.levelCfg.copytype == LevelType.Story then
            if msg.curdown then
                CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown)
            end
            PVEChapterDataManager:Get():UpdateMsgChapterData(msg.copyid, msg.allStar, msg.unlockcopy, msg.star, msg.num, msg.winsum, msg.curStar)
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
                PVEChapterDataManager:Get():UpdateMsgChapterData(msg.copyid, msg.allStar, msg.unlockcopy, msg.star, msg.num, msg.winsum, msg.curStar)
                PVEChapterDataManager:Get():SetIsMoreExp(msg.moreexp == 3)
                PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminaTime)
                BattleDataManager:Get():SetStateBattleResult()
            end
        end
    end
    if msg.addLev > 0 and isUP then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.levelupdown)
        CommonHelper:CheckPlayerLevelUp(msg.addLev)

    end
    if not CommonHelper:IsNullOrEmpty(msg.errcode) then
        BattleDataManager:Get():SetStateBattleResult()
        MsgErrorManager:Get():TouchEvt(tonumber(msg.errcode))
    end
    PopUpGiftDataManager:Get():UpdateDataList(msg.buyItems)
    if PopUpGiftDataManager:Get():IsDelayPopUpShow() then
        PopupManager:Get():AddRallyPopup(function()
            PopUpGiftDataManager:Get():DelayPopUpShow()
        end)
    end
    QuickTa:Get():TrackEvent(TrackEventNames.PveEnd)
end
-------------------------------------------------------------扫荡
function ChapterSubsystem:SendMsg_Swap(levelid, num)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), levelid, num })
    NetManager:Get():Send(MsgID.SWAP_CHAPTER_C2S_REQ, reqBytes)
end
function ChapterSubsystem:RecvMsg_Swap(data)
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
        if flag then
            UIManager:Get():ClosePopup()
            local guideId = PlayerDataManager:Get():CheckPlayerLevelUpGuide()
            if guideId ~= -1 then
                SkipModuleHelper:Get():ToMainMenuView(true)
            else
                PopupManager:Get():SetIsCheckRallyPopup(true)
                PopupManager:Get():PopRallyPopupView()
            end
        end
    end)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)
    PVEChapterDataManager:Get():UpdateMsgChapterCount(msg.copyid, msg.num)
    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SwapSuccess))
    PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminaTime)
    UINotify:Get():SendNotification(UINotifyEvent.SelectTeamView_Refresh)
    UINotify:Get():SendNotification(UINotifyEvent.SelectTeamViewPveChapterSetData, msg.copyid)
    UINotify:Get():SendNotification(UINotifyEvent.SwapView_SetData, nil)
    if UIManager:Get():IsViewShow("LabMainView") then
        UINotify:Get():SendNotification(UINotifyEvent.LabMainMenu_RefreshCurView)
    end
    UINotify:Get():SendNotification(UINotifyEvent.Msg_Assemble, false)
    PopUpGiftDataManager:Get():UpdateDataList(msg.buyItems)
end
-------------------------------------------------------------


local __subsystem = ChapterSubsystem()
function ChapterSubsystem:Get()
    return __subsystem
end
return __subsystem