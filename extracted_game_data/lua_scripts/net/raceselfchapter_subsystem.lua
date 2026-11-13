---@class RaceSelfChapterSubsystem
RaceSelfChapterSubsystem = class("RaceSelfChapterSubsystem")

function RaceSelfChapterSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_ACTIVE_CHAPTER_S2C_RES,self,self.RecGetAllSelfChapter)
    NetResponseEventManager:Get():AddListener(MsgID.GET_ONE_ACTIVE_CHAPTER_S2C_RES,self,self.RecGetSelfChapterDetail)
    NetResponseEventManager:Get():AddListener(MsgID.BEGIN_ACTIVE_CHAPTER_S2C_RES,self,self.RecSelfChapterBeginRace)
    NetResponseEventManager:Get():AddListener(MsgID.FINISH_ACTIVE_CHAPTER_S2C_RES,self,self.RecSelfChapterFinishRace)
    NetResponseEventManager:Get():AddListener(MsgID.ACTIVE_CHAPTER_STAR_REWARD_S2C_RES,self,self.RecGetSelfChapterStarRewardDetail)
    NetResponseEventManager:Get():AddListener(MsgID.ACTIVE_CHAPTER_GET_REWARD_S2C_RES,self,self.RecGetSelfChapterReward)
end
local GetAllSelfChapterFunc=nil
local _isAuto=false
function RaceSelfChapterSubsystem:SendMsg_GetAllSelfChapter(isAuto,backfunc)
    GetAllSelfChapterFunc=backfunc
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_ACTIVE_CHAPTER_C2S_REQ, body)
    _isAuto=isAuto
end
function RaceSelfChapterSubsystem:RecGetAllSelfChapter(data)
    ---@type SC_UserChapter[]
    local msg = assert(Dll_PB.decode("UserChapter", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfChapterDataManager:Get():SetAllInfo(msg)
    UIManager:Get():OpenView("RaceSelfChapterView", CanvasType.MainCanvas, "RaceSelfChapterView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterViewSetData)
    if _isAuto then
        local index= PlayerPrefsHelper:GetValue_SelfChapterId()
        local data= RaceSelfChapterDataManager:Get():GetRaceByID(index)
        if data  then
            UIManager:Get():OpenView("RaceSelfChapterListView", CanvasType.MainCanvas, "RaceSelfChapterListView")
            UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterListView_SetLevelList,index)
        end
        if GetAllSelfChapterFunc then
            GetAllSelfChapterFunc()
            GetAllSelfChapterFunc=nil
        end
    else
        if GetAllSelfChapterFunc then
            GetAllSelfChapterFunc()
            GetAllSelfChapterFunc=nil
        end
    end
end




function RaceSelfChapterSubsystem:SendMsg_SelfChapterBeginRace(levelid, idx)
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),levelid, idx})
    NetManager:Get():Send(MsgID.BEGIN_ACTIVE_CHAPTER_C2S_REQ, body)
end
function RaceSelfChapterSubsystem:RecSelfChapterBeginRace(data)
    ---@type SC_BeginPve
    local msg = assert(Dll_PB.decode("BeginPve", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfChapterDataManager:Get():SetBattleCar(msg.carids)
    RaceSelfChapterDataManager:Get():RecBattleData(msg)
end

function RaceSelfChapterSubsystem:SendMsg_SelfChapterFinishRace(levelid ,rank, time, error,completeRank,duration)
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),levelid,RaceSelfChapterDataManager:Get():GetBattleCar() ,time,rank, error,completeRank,duration})
    NetManager:Get():Send(MsgID.FINISH_ACTIVE_CHAPTER_C2S_REQ, body)
end
function RaceSelfChapterSubsystem:RecSelfChapterFinishRace(data)
    ---@type SC_FinishPve
    local msg = assert(Dll_PB.decode("FinishPve", data))
    print(ProtoMsgHelp.block(msg))
    local isUP=false
    if msg.level~=0 then
        PlayerDataManager:Get():SetPlayerEXP(msg.exp)
        isUP=  PlayerDataManager:Get():SetPlayerLV(msg.level)
    end
    if msg.addLev>1 and isUP then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.levelupdown)
        CommonHelper:CheckPlayerLevelUp(msg.addLev)
    end
    if msg.curdown  then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.curdown)
    end
    RaceSelfChapterDataManager:Get():UpdateCurTaskState(msg)
    --if msg.curdown~=nil then
        local battleResultData = BattleDataManager:Get():GetBattleResultData()
        battleResultData:SetOtherResultData(msg,msg.curdown)
    --end
    BattleDataManager:Get():SetStateBattleResult()

    PlayerDataManager:Get():SetPlayerStaminaAndStaminaTime(msg.stamina, msg.staminaTime)
end

function RaceSelfChapterSubsystem:SendMsg_GetSelfChapterDetail(id)
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.GET_ONE_ACTIVE_CHAPTER_C2S_REQ, body)
end
function RaceSelfChapterSubsystem:RecGetSelfChapterDetail(data)
    ---@type SC_UserCopy
    local msg = assert(Dll_PB.decode("UserCopy", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfChapterDataManager:Get():SetChapterData(msg)
    UIManager:Get():OpenView("RaceSelfChapterListView", CanvasType.MainCanvas, "RaceSelfChapterListView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterListView_SetLevelList,msg.chapterid)
end

function RaceSelfChapterSubsystem:SendMsg_GetSelfChapterStarRewardDetail(copyid,star)
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),copyid,star})
    NetManager:Get():Send(MsgID.ACTIVE_CHAPTER_STAR_REWARD_C2S_REQ, body)
end
function RaceSelfChapterSubsystem:RecGetSelfChapterStarRewardDetail(data)
    ---@type SC_UserCopy
    local msg = assert(Dll_PB.decode("CopyStarAward", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfChapterDataManager:Get():UpdateCurTaskState(msg)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown,true)
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterTaskView_Refresh)
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterListView_Refresh)
    RedPointManager:Get():UpdateValue(RedPointID.S_RaceSelfChapter,RaceSelfChapterDataManager:Get():GetHasRedPoint())
end

function RaceSelfChapterSubsystem:SendMsg_GetSelfChapterReward(id,star)
    local body = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id,star})
    NetManager:Get():Send(MsgID.ACTIVE_CHAPTER_GET_REWARD_C2S_REQ, body)
end
function RaceSelfChapterSubsystem:RecGetSelfChapterReward(data)
    ---@type SC_UserCopy
    local msg = assert(Dll_PB.decode("ChapterAward", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfChapterDataManager:Get():UpdateCurBoxData(msg)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown,true)
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterTaskView_Refresh)
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterListView_Refresh)
    RedPointManager:Get():UpdateValue(RedPointID.S_RaceSelfChapter,RaceSelfChapterDataManager:Get():GetHasRedPoint())
end



--{{{废弃
--function RaceSelfChapterSubsystem:GetUrl(type)
--    if type == nil then
--        type = ServerType.Battle
--    end
--    local servertype = type
--    local serverdata = ClientDataManager:Get():GetServerInfoByIndex(servertype, 1)
--    local str = string.format("http://%s:%d/battle/battle?", serverdata.ip, serverdata.port)
--    return str
--
--end
--function RaceSelfChapterSubsystem:SendMsg_CreateSelfChapter(id)
--    local reqData = {
--        num = id,
--    }
--    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
--    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
--    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_CREATE_CHAPTER_C2B_REQ, body, self.RecCreateSelfChapter, self)
--end
--
--function RaceSelfChapterSubsystem:RecCreateSelfChapter(data)
--    ---@type SC_SC_CreateChapterRes
--    local msg = assert(Dll_PB.decode("SC_CreateChapterRes", data))
--    print(ProtoMsgHelp.block(msg))
--    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CreateSuccess))
--    --UIManager:Get():CloseView()
--    RaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(false)
--
--    --SdkAd:Get():SdkAdjust_CreateChallengeGame(msg.gameInfo.gameInfo.id)
--end
--
--function RaceSelfChapterSubsystem:SendMsg_GetAllJoinSelfChapter()
--    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_GET_JOIN_CHAPTER_C2B_REQ, "", self.RecGetAllJoinSelfChapter, self)
--end
--function RaceSelfChapterSubsystem:RecGetAllJoinSelfChapter(data)
--    ---@type SC_SC_Chapter_GetGamesRes
--    local msg = assert(Dll_PB.decode("SC_Chapter_GetGamesRes", data))
--    print(ProtoMsgHelp.block(msg))
--    RaceSelfChapterDataManager:Get():SetAllJoinedInfo(msg)
--    if UIManager:Get():IsViewShow("RaceSelfChapterView")==false then
--        UIManager:Get():OpenView("RaceSelfChapterView", CanvasType.MainCanvas, "RaceSelfChapterView")
--    end
--    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfChapterViewSetJoin)
--end
--}}}





local __subsystem = RaceSelfChapterSubsystem()
function RaceSelfChapterSubsystem:Get()
    return __subsystem
end
return __subsystem