---@class RaceRankSubsystem
RaceRankSubsystem = class("RaceRankSubsystem")

function RaceRankSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_RANK_INFO_S2C_RES, self, self.RecvMsg_SessionInfo)
    NetResponseEventManager:Get():AddListener(MsgID.ENTER_RANK_MATCHING_S2C_RES, self, self.RecvMsg_Match)
    NetResponseEventManager:Get():AddListener(MsgID.CANCEL_RANK_MATCHING_S2C_RES, self, self.RecvMsg_MatchCancel)
    NetResponseEventManager:Get():AddListener(MsgID.RANK_MATCHING_SUCCESS_S2C_RES, self, self.RecvMsg_MatchSucceed)
    NetResponseEventManager:Get():AddListener(MsgID.ACCEPT_RANK_MATCHING_S2C_RES, self, self.RecvMsg_PlayerJoinRoomState)
    NetResponseEventManager:Get():AddListener(MsgID.RANK_BATTLE_BEGIN_S2C_RES, self, self.RecvMsg_BattleBegin)
    NetResponseEventManager:Get():AddListener(MsgID.RANK_BATTLE_FINISH_S2C_RES, self, self.RecvMsg_BattleFinish)
end



--{{{天梯_请求赛季数据
local _CallFunc=nil
function RaceRankSubsystem:SendMsg_SessionInfo(func,showTips)
    if showTips==nil then showTips=true end
    _CallFunc=func
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.GET_RANK_INFO_C2S_REQ, data,false,showTips)
end
function RaceRankSubsystem:RecvMsg_SessionInfo(data)
    ---@type SC_ReqSeasonInfo
    local msg = assert(Dll_PB.decode("ReqSeasonInfo", data))
    print(ProtoMsgHelp.block(msg))
    PlayerDataManager:Get():SetRankScore(msg.score)
    RaceRankManager:Get():SetSessionData(msg)
    if _CallFunc then
        _CallFunc()
        return
    end
    if RaceRankManager:Get():GetSessionCfg() == nil then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceRankSessionCfgNil))
    else
        --if UIManager:Get():IsViewShow("RaceRankTrackView")==false then
        --    UIManager:Get():OpenView("RaceRankTrackView", CanvasType.MainCanvas, "RaceRankTrackView")
        --end
        --UINotify:Get():SendNotification(UINotifyEvent.RaceRankSelectTrack_SetData)
        if UIManager:Get():IsViewShow("RaceRankView")==false then
            UIManager:Get():OpenView("RaceRankView", CanvasType.MainCanvas, "RaceRankView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.RaceRankView_SetData)
    end
    RedPointManager:Get():UpdateValue(RedPointID.S_RaceRank,false)
end
--}}}
--{{{天梯_开始匹配
function RaceRankSubsystem:SendMsg_Match(caridx,isTest,type,position,trackId)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),caridx,isTest,type,position})
   -- local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),caridx,trackId,isTest,type,position})
    NetManager:Get():Send(MsgID.ENTER_RANK_MATCHING_C2S_REQ, data)
end
function RaceRankSubsystem:RecvMsg_Match()
    log("---   天梯_开始匹配,无异常")
    UIManager:Get():ShowPersistentView("RaceRankMatchingView", CanvasType.FrontTipCanvas, "RaceRankMatchingView", false, true)
end
--}}}
--{{{天梯_取消匹配
function RaceRankSubsystem:SendMsg_MatchCancel()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.CANCEL_RANK_MATCHING_C2S_REQ, data)
end
function RaceRankSubsystem:RecvMsg_MatchCancel()
    log("---   天梯_取消匹配,无异常")
    CommonHelper:PlayScreenEffectWaiting(false)
    UIManager:Get():HidePersistentView("RaceRankJoinView")
    UIManager:Get():HidePersistentView("RaceJCPJoinView")
end
--}}}
--{{{天梯_申请加入房间
function RaceRankSubsystem:SendMsg_JoinRoom()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.ACCEPT_RANK_MATCHING_C2S_REQ, data)
end
--}}}
--{{{天梯_匹配完成
function RaceRankSubsystem:RecvMsg_MatchSucceed(data)
    ---@type SC_RetPVPMatchSucc
    local msg = assert(Dll_PB.decode("RetPVPMatchSucc", data))
    print(ProtoMsgHelp.block(msg))

    UIManager:Get():HidePersistentView("RaceRankMatchingView")
    UIManager:Get():ShowPersistentView("RaceRankJoinView", CanvasType.FrontTipCanvas, "RaceRankJoinView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceRankJoinView_SetData, msg)
end
--}}}
--{{{天梯_请求选定
function RaceRankSubsystem:SendMsg_Ready()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():SendSyncBattleServer(MsgID.ACCEPT_RANK_MATCHING_C2S_REQ, data)
end
--}}}
--{{{天梯_玩家确定加入房间，收到状态
function RaceRankSubsystem:RecvMsg_PlayerJoinRoomState(data)
    ---@type SC_RetPVPAccept
    local msg = assert(Dll_PB.decode("RetPVPAccept", data))
    print(ProtoMsgHelp.block(msg))
    UINotify:Get():SendNotification(UINotifyEvent.RaceRankJoinView_PlayerReady, msg.accetprid)
end
--}}}
--{{{天梯_玩家确定加入房间，收到状态
function RaceRankSubsystem:RecvMsg_BattleBegin(data)
    ---@type SC_RetPVPStart
    local msg = assert(Dll_PB.decode("RetPVPStart", data))
    print(ProtoMsgHelp.block(msg))
    log("收到玩家进入房间")
    if UIManager:Get():IsPersistentViewShow("RaceRankMatchingView") then
        UIManager:Get():HidePersistentView("RaceRankMatchingView")
    end
    if UIManager:Get():IsPersistentViewShow("RaceRankJoinView") then
        UIManager:Get():HidePersistentView("RaceRankJoinView")
    end
    KnapsackDataManager:Get():UpdatePropByConsume(msg.consume)
    CommonHelper:PlayScreenEffectWaiting(false)
    RaceRankManager:Get():SetRoomId(msg.roomid)
    --RaceRankManager:Get():SetRaceStyleType(msg.newracetype)
    RaceRankManager:Get():SetProtectType(msg.protect)
    RaceRankManager:Get():SetRaceType(RaceRankRaceType.Battle)
    RaceRankManager:Get():LoadBattleScene(msg,false)
    -- UINotify:Get():SendNotification(UINotifyEvent.RaceRankJoinView_PlayerReady, msg.rid)
end
--}}}
--{{{天梯_通知服务器战斗结束
function RaceRankSubsystem:SendMsg_BattleFinish(value,roomid,appendRecord)
    local flag = 0
    local data = {}
    local loop = value.Length - 1
    for i = 0, loop do
        if value[i].pid == PlayerDataManager:Get():GetPlayerRID() then
            data.rank=value[i].completeRank
            data.time=value[i].time
            data.error=value[i].error
            break
        end
    end
    local batleResult=""
    for i = 0, loop do
        local result= string.format("%d---%d---%d---%d:",value[i].pid,value[i].completeRank,value[i].time,value[i].error)
        batleResult=string.format("%s%s",batleResult,result)
    end
    local localTime=0
    if BattleDataManager:Get().BattleTime then
        localTime=BattleDataManager:Get().BattleTime
    end
    local GetFrameCount=BattleDataManager:Get():GetFrameCount()
    local GetEngineControllerFrameCount=BattleDataManager:Get():GetEngineControllerFrameCount()
    local text="GetFrameCount:"..tostring(GetFrameCount).."GetEngineControllerFrameCount:"..tostring(GetEngineControllerFrameCount)
    local recordValue = PlayerPrefsHelper:GetValue_ReplayInputInfos()..appendRecord
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),data.time,data.error,data.rank,roomid,batleResult,localTime,text,recordValue})
    NetManager:Get():Send(MsgID.RANK_BATTLE_FINISH_C2S_REQ, reqBytes)
end
--}}}

--{{{天梯_服务器验证战斗结束是否异常，没有异常就显示结算并清空天梯房间数据
function RaceRankSubsystem:RecvMsg_BattleFinish(data)
    ---@type SC_FinishPvp
    local msg = assert(Dll_PB.decode("FinishPvp", data))
    print(ProtoMsgHelp.block(msg))
    RaceRankManager:Get():SetAddScore(msg.score- PlayerDataManager:Get():GetRankScore())
    PlayerDataManager:Get():SetRankScore(msg.score)
    BattleDataManager:Get():SetStateBattleResult()
    if msg.curdown and not CommonHelper:CheckPlayerIsNewGuide() then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown)
    end
    --SdkAd:Get():SdkAdjust_RaceRank()
end
--}}}
--{{{天梯_断线重连
function RaceRankSubsystem:SendMsg_ReFight()
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RANK_RE_BATTLE_S2C_RES, reqBytes)
end
--}}}




local __subsystem = RaceRankSubsystem()
function RaceRankSubsystem:Get()
    return __subsystem
end
return __subsystem