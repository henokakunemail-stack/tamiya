---@class RaceCarGodSubsystem
RaceCarGodSubsystem = class("RaceCarGodSubsystem")

function RaceCarGodSubsystem:initialize(...)

    ---781, --返回车神传说
    NetResponseEventManager:Get():AddListener(MsgID.RET_GOD_INFO_S2C_RES, self, self.RecvMsg_GodInfo)
    ---783, --返回某个车神传说
    NetResponseEventManager:Get():AddListener(MsgID.RET_ONE_GOD_INFO_S2C_RES, self, self.RecvMsg_OneGodInfo)
    ---785, --返回车神比赛开始
    NetResponseEventManager:Get():AddListener(MsgID.RET_GOD_START_S2C_RES, self, self.RecvMsg_GodStart)
    ---787, --返回车神比赛结束
    NetResponseEventManager:Get():AddListener(MsgID.RET_GOD_FINISH_S2C_RES, self, self.RecvMsg_GodFinish)

end

--local GetGodInfoCallBack = nil
---780 , 请求车神传说
function RaceCarGodSubsystem:SendMsg_GodInfo(callback)
    --GetGodInfoCallBack = callback
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), callback })
    NetManager:Get():Send(MsgID.REQ_GOD_INFO_C2S_REQ, p_data)
end

---781 , 返回车神传说
function RaceCarGodSubsystem:RecvMsg_GodInfo(data)
    -----@type SC_FinishPve
    --local msg = assert(Dll_PB.decode("FinishPve", data))
    --print(ProtoMsgHelp.block(msg))
    --
    --if #msg.ranks == 0 then
    --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FunctionNoWait))
    --    if GetGodInfoCallBack then
    --        GetGodInfoCallBack()
    --        GetGodInfoCallBack = nil
    --    end
    --    return
    --end
    --
    --RaceCarGodDataManager:Get():InitGodInfoData(msg)
    --
    --if not UIManager:Get():IsViewShow("RaceCarGodView") then
    --    UIManager:Get():OpenView("RaceCarGodView", CanvasType.MainCanvas, "RaceCarGodView")
    --end
    --if GetGodInfoCallBack then
    --    GetGodInfoCallBack()
    --    GetGodInfoCallBack = nil
    --end
    ----UINotify:Get():SendNotification(UINotifyEvent.RaceCarGod_InitCarGod)

    -----------------------------------
    ---@type SC_RetRank
    local msg = assert(Dll_PB.decode("RetRank", data))
    print(ProtoMsgHelp.block(msg))

    RaceCarGodDataManager:Get():SetNewOneGodRankInfo(msg)

    local copyID = RaceCarGodDataManager:Get():GetNewOneGodRankCopyID()

    if not UIManager:Get():IsViewShow("RaceCarGodInfoView") then
        UIManager:Get():OpenView("RaceCarGodInfoView", CanvasType.MainCanvas, "RaceCarGodInfoView")
    end

    UINotify:Get():SendNotification(UINotifyEvent.RaceGVG_SetSeasonData, copyID)
end
local GetGodInfoCallBack = nil
---782 , 请求某个车神传说 p2=seasonid
function RaceCarGodSubsystem:SendMsg_OneGodInfo(callback)
    GetGodInfoCallBack = callback
    --章节类型表,类型是5
    local seasonID = 3001
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), seasonID })
    NetManager:Get():Send(MsgID.REQ_ONE_GOD_INFO_C2S_REQ, p_data)
end

---783 , 返回某个车神传说
function RaceCarGodSubsystem:RecvMsg_OneGodInfo(data)
    ---@type SC_UserCopy
    local msg = assert(Dll_PB.decode("UserCopy", data))
    print(ProtoMsgHelp.block(msg))

    --RaceCarGodDataManager:Get():InitOneGodInfoData(msg)

    --if not UIManager:Get():IsViewShow("RaceCarGodInfoView") then
    --    UIManager:Get():OpenView("RaceCarGodInfoView", CanvasType.MainCanvas, "RaceCarGodInfoView")
    --end

    -----------------

    RaceCarGodDataManager:Get():InitPVEGodInfoData(msg)

    if not UIManager:Get():IsViewShow("RaceCarGodView") then
        UIManager:Get():OpenView("RaceCarGodView", CanvasType.MainCanvas, "RaceCarGodView")
    end
    if GetGodInfoCallBack then
        GetGodInfoCallBack()
        GetGodInfoCallBack = nil
    end
end

---784 , 请求车神比赛开始 P2=seasonid P3=carid
function RaceCarGodSubsystem:SendMsg_GodStart(seasonID, carID)
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), seasonID, carID })
    NetManager:Get():Send(MsgID.REQ_GOD_START_C2S_REQ, p_data)
end

---785 , 返回车神比赛开始
function RaceCarGodSubsystem:RecvMsg_GodStart(data)
    ---@type SC_BeginGodPve
    local msg = assert(Dll_PB.decode("BeginPve", data))
    print(ProtoMsgHelp.block(msg))
    RaceCarGodDataManager:Get():BeginBattle(msg)

end

---786 , 请求车神比赛结束 P2=speed p3=failreason p4=seasonid p5=result p6=framecount
function RaceCarGodSubsystem:SendMsg_GodFinish(levelid,carIdx ,rank, time, error,starttime,rankres,recordValue)
    local localTime=0
    if BattleDataManager:Get().BattleTime then
        localTime=BattleDataManager:Get().BattleTime
    end
    local GetFrameCount=BattleDataManager:Get():GetFrameCount()
    local GetEngineControllerFrameCount=BattleDataManager:Get():GetEngineControllerFrameCount()
    local text="GetFrameCount:"..tostring(GetFrameCount).."GetEngineControllerFrameCount:"..tostring(GetEngineControllerFrameCount)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),levelid,carIdx,time,rank,error,starttime,text,rankres,recordValue})
    NetManager:Get():Send(MsgID.REQ_GOD_FINISH_C2S_REQ, data)
end

---787 , 返回车神比赛结束
function RaceCarGodSubsystem:RecvMsg_GodFinish(data)
    ---@type SC_FinishPve
    local msg = assert(Dll_PB.decode("FinishPve", data))
    print(ProtoMsgHelp.block(msg))

    if msg.curdown ~= nil then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.curdown)
    end

    --RaceCarGodDataManager:Get():SetOneGodFinishAwardData(msg)
    BattleDataRaceCarGod:SetFinishCarGodData(msg)
    BattleDataManager:Get():SetStateBattleResult()

end

local __subsystem = RaceCarGodSubsystem()
function RaceCarGodSubsystem:Get()
    return __subsystem
end
return __subsystem

