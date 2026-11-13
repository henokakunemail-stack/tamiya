---@class RaceXCupSubsystem
RaceXCupSubsystem = class("RaceXCupSubsystem")

function RaceXCupSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_RACE_XCP_INFO_S2C_RES, self, self.RecvMsg_Info)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_XCP_JOIN_S2C_RES, self, self.RecvMsg_Join)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_XCP_BATTLE_FINISH_S2C_RES, self, self.RecvMsg_Finish)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_XCP_BATTLE_TEST_FINISH_S2C_RES, self, self.RecvMsg_TestFinish)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_XCP_BATTLE_START_S2C_RES, self, self.RecvMsg_Start)
    NetResponseEventManager:Get():AddListener(MsgID.RACE_XCP_RECORD_S2C_RES, self, self.RecvMsg_Replay)

end
local GetRaceJcpCallBack = nil
function RaceXCupSubsystem:SendMsg_Info(backfunc)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_RACE_XCP_INFO_C2S_REQ, data)
end

function RaceXCupSubsystem:RecvMsg_Info(data)
    ---@type SC_RetXcup
    local msg = assert(Dll_PB.decode("RetXcup", data))
    print(ProtoMsgHelp.block(msg))
    if msg then
        RaceXCupManager:Get().XcpData:SetData(msg)
        if RaceXCupManager:Get():GetCurState() == RaceJCPType.None then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.JCPUnOpen))
        else
            UIManager:Get():OpenView("RaceXCPView", CanvasType.MainCanvas, "RaceXCPView")
            UINotify:Get():SendNotification(UINotifyEvent.RaceXCPView_SetData)
        end
    end
    if GetRaceJcpCallBack then
        GetRaceJcpCallBack()
        GetRaceJcpCallBack = nil
    end
end

function RaceXCupSubsystem:SendMsg_Join(car1, car2, car3)
    car1 = car1 == -1 and 0 or car1
    car2 = car2 == -1 and 0 or car2
    car3 = car3 == -1 and 0 or car3
    local str = string.format("%d:%d:%d", car1, car2, car3)  -- 或者直接拼接
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), str })
    NetManager:Get():Send(MsgID.RACE_XCP_JOIN_C2S_REQ, data)
end
function RaceXCupSubsystem:RecvMsg_Join(data)
    ---@type SC_RetXcupJoin
    local msg = assert(Dll_PB.decode("RetXcupJoin", data))
    print(ProtoMsgHelp.block(msg))
    if msg then
        RaceXCupManager:Get().XcpData:SetDataJcupJoin(msg)
        UINotify:Get():SendNotification(UINotifyEvent.RaceXCPView_SetData)
    end
end


function RaceXCupSubsystem:SendMsg_RaceBattleStart(indexs)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), indexs })
    NetManager:Get():Send(MsgID.RACE_XCP_BATTLE_START_C2S_REQ, data)
end
function RaceXCupSubsystem:SendMsg_RaceBattleReFight()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RACE_XCP_REFIGHT_C2S_REQ, data)
end
function RaceXCupSubsystem:SendMsg_Finish(time, rank, error, roomId, sign)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), time, error, rank, roomId, sign })
    NetManager:Get():Send(MsgID.RACE_XCP_BATTLE_FINISH_C2S_REQ, data)
end
function RaceXCupSubsystem:RecvMsg_Finish(data)
    ---@type SC_FinishJcup
    local msg = assert(Dll_PB.decode("FinishJcup", data))
    print(ProtoMsgHelp.block(msg))
    if msg.errCode == nil or CommonHelper:IsNullOrEmpty(msg.errCode) or tonumber(msg.errCode) == 0 then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.curdown, false, function()
            RaceXCupManager:Get():SetStateBattleResult()
        end)
    else
        RaceXCupManager:Get():SetStateBattleResult()
    end
end

function RaceXCupSubsystem:SendMsg_TestFinish(carID, time)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), carID, time })
    NetManager:Get():Send(MsgID.RACE_XCP_BATTLE_TEST_FINISH_C2S_REQ,data)
end

function RaceXCupSubsystem:RecvMsg_TestFinish()

end

function RaceXCupSubsystem:RecvMsg_Start(data)
    ---@type SC_RetStarts
    local msg = assert(Dll_PB.decode("RetStarts", data))
    print(ProtoMsgHelp.block(msg))
    RaceXCupManager:Get():SetRaceType(RaceJcpRaceType.Battle)
    RaceXCupManager:Get():BeginBattle(msg)
end

function RaceXCupSubsystem:SendMsg_Replay(rid, jcpId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), rid, jcpId })
    NetManager:Get():Send(MsgID.RACE_XCP_RECORD_C2S_REQ, data)
end

function RaceXCupSubsystem:RecvMsg_Replay(data)
    ---@type SC_RetRaceRecord
    local msg = assert(Dll_PB.decode("RetRaceRecord", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    RankListTestVerifyDataManager:Get():SetLookVersion(msg.starts.ver)
    cs_coroutine.start(function()
        coroutine.yield()
        RaceXCupManager:Get():SetRaceType(RaceJcpRaceType.Record)
        RaceXCupManager:Get():SetLookId(msg.lookrid)
        RaceXCupManager:Get():BeginBattle(msg.starts, false)
    end)
end

local __subsystem = RaceXCupSubsystem()
function RaceXCupSubsystem:Get()
    return __subsystem
end
return __subsystem