---@class RaceAssembleSubsystem
RaceAssembleSubsystem = class("RaceAssembleSubsystem")

function RaceAssembleSubsystem:initialize(...)

    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_INFO_S2C_RES, self, self.RecvMsg_RaceAssembleInfo)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_REFORM_S2C_RES, self, self.RecvMsg_RaceAssembleReform)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_BATTLE_BEGIN_S2C_RES, self, self.RecvMsg_BeginBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_BATTLE_FINISH_S2C_RES, self, self.RecvMsg_FinishBattle)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_RECORD_S2C_RES, self, self.RecvMsg_Record)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_RANK_LIST_S2C_RES, self, self.RecvMsg_RankList)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_JOIN_S2C_RES, self, self.RecvMsg_Join)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_FAIR_AGREE_S2C_RES, self, self.RecvMsg_FairAgree)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_REFORM_DEL_S2C_RES, self, self.RecvMsg_RaceAssembleReformDel)


end

function RaceAssembleSubsystem:SendMsg_RaceAssembleInfo()
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_INFO_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_RaceAssembleInfo(data)
    ---@type SC_UserFairInfo
    local msg = assert(Dll_PB.decode("UserFairInfo", data))
    print(ProtoMsgHelp.block(msg))
    RaceAssembleManager:Get():Init(msg)
    if  RaceAssembleManager:Get():GetRaceFinishTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())>0 then
        UIManager:Get():OpenView("RaceAssembleEnterView",CanvasType.MainCanvas,"RaceAssembleEnterView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceAssembleSetData)
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceAssembleEnd))
    end

end
function RaceAssembleSubsystem:SendMsg_RaceAssembleReformDel(partid, idx,type)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),partid, idx,type})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_REFORM_DEL_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_RaceAssembleReformDel(data)
    ---@type SC_RefromPart
    local msg = assert(Dll_PB.decode("RefromPart", data))
    print(ProtoMsgHelp.block(msg))
    RaceAssembleManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    RaceAssembleManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
    RaceAssembleAddManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    RaceAssembleAddManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
    NewPlayerCarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    NewPlayerCarDataManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
    UINotify:Get():SendNotification(UINotifyEvent.AssembleGarageView_Assemble)
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.DelReformPosSuccess))
end

function RaceAssembleSubsystem:SendMsg_RaceAssembleReform(pos,bagid,entityid,type)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),pos,bagid,entityid,type})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_REFORM_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_RaceAssembleReform(data)
    ---@type SC_RefromPart
    local msg = assert(Dll_PB.decode("RefromPart", data))
    print(ProtoMsgHelp.block(msg))
    RaceAssembleManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    RaceAssembleManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
    RaceAssembleAddManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    RaceAssembleAddManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
    NewPlayerCarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    NewPlayerCarDataManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
    UINotify:Get():SendNotification(UINotifyEvent.AssembleGarageView_Assemble)
    CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.RaceAssembleReformSelectSuccess))
end
function RaceAssembleSubsystem:SendMsg_BeginBattle(id,carid)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),id,carid})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_BATTLE_BEGIN_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_BeginBattle(data)
    ---@type SC_RetBeginBattle
    local msg = assert(Dll_PB.decode("RetBeginBattle", data))
    print(ProtoMsgHelp.block(msg))
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceAssemble)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceAssemble)
end
function RaceAssembleSubsystem:SendMsg_FinishBattle(battleid, time, rank, error)
    local localTime=0
    if BattleDataManager:Get().BattleTime then
        localTime=BattleDataManager:Get().BattleTime
    end
    local GetFrameCount=BattleDataManager:Get():GetFrameCount()
    local GetEngineControllerFrameCount=BattleDataManager:Get():GetEngineControllerFrameCount()
    local text="GetFrameCount:"..tostring(GetFrameCount).."GetEngineControllerFrameCount:"..tostring(GetEngineControllerFrameCount)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), battleid, time, rank, error ,localTime,text})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_BATTLE_FINISH_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_FinishBattle(data)
    ---@type SC_UserFairInfo
    local msg = assert(Dll_PB.decode("RetFinishBattle", data))
    print(ProtoMsgHelp.block(msg))
    BattleDataManager:Get():SetStateBattleResult()
end
function RaceAssembleSubsystem:SendMsg_Record(matchId,createtime,playerid)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),matchId,createtime,playerid})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_RECORD_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_Record(data)
    ---@type SC_UserFairInfo
    local msg = assert(Dll_PB.decode("RetBattleRecord", data))
    print(ProtoMsgHelp.block(msg))
    BattleDataManager:Get():SetRoomData(msg, RaceModel.RaceAssemble, true)
    local scenename = BattleDataManager:Get():GetSceneName()
    local trackdata = BattleDataManager:Get():GetTrackData()
    SceneManager:Get():LoadingBattleScene(scenename, trackdata, RaceModel.RaceAssemble)
end
function RaceAssembleSubsystem:SendMsg_RankList(matchid)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),matchid})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_RANK_LIST_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_RankList(data)
    ---@type SC_RetJoinBattle
    local msg = assert(Dll_PB.decode("RetBattleRank", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():OpenPopup("RaceAssembleRankingListView", CanvasType.MainCanvas, "RaceAssembleRankingListView")
    msg.ranktype = RankingListType.RaceAssemble
    local data = RankingListData()
    data:SetData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.RaceAssembleRankingListView_SetData, data)
end
function RaceAssembleSubsystem:SendMsg_Join()
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_JOIN_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_Join(data)
    ---@type SC_UserFairInfo
    local msg = assert(Dll_PB.decode("UserFairInfo", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceAssembleJoinSuccess))
    RaceAssembleManager:Get():Init(msg)
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.consumelist)
    UINotify:Get():SendNotification(UINotifyEvent.RaceAssembleSetData)
end
function RaceAssembleSubsystem:SendMsg_FairAgree(matchid,playerid)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),matchid,playerid})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_FAIR_AGREE_C2S_REQ, reqBytes)
end

function RaceAssembleSubsystem:RecvMsg_FairAgree(data)
    ---@type SC_UserFairInfo
    local msg = assert(Dll_PB.decode("UserFairInfo", data))
    print(ProtoMsgHelp.block(msg))
end

local __subsystem = RaceAssembleSubsystem()
function RaceAssembleSubsystem:Get()
    return __subsystem
end
return __subsystem

