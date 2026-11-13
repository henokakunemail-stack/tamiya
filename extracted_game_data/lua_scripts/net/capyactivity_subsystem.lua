---@class CapyActivitySubsystem
CapyActivitySubsystem = class("CapyActivitySubsystem")

function CapyActivitySubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.CAPY_ACTIVE_S2C_RES, self, self.RecMsg_CapyActivity)

    NetResponseEventManager:Get():AddListener(MsgID.CAPY_ACTIVE_AWARD_S2C_RES, self, self.RecMsg_CapyActityReward)
end

--请求卡皮活动
function CapyActivitySubsystem:SendMsg_CapyActivity(actID)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), actID})

    NetManager:Get():Send(MsgID.CAPY_ACTIVE_C2S_REQ, msgData)
end

--返回卡皮活动

function CapyActivitySubsystem:RecMsg_CapyActivity(data)
    local msg = assert(Dll_PB.decode("UserActiveInfo", data))
    print(ProtoMsgHelp.block(msg))
    StrengthActivityManager:Get():SetActivityRechargeInfo(msg)
    if StrengthActivityManager:Get().CurActivityType==CapyActivityType.Strength then
        if not UIManager:Get():IsPopViewShow("StrengthSprintActView")  then
            UIManager:Get():OpenPopup("StrengthSprintActView", CanvasType.MainCanvas, "StrengthSprintActView")
        else
            UINotify:Get():SendNotification(UINotifyEvent.StrengthSprint_OpenActivity)
        end
    end if StrengthActivityManager:Get().CurActivityType==CapyActivityType.Recruit then
        UIManager:Get():OpenPopup("RecruitSprintActView", CanvasType.MainCanvas, "RecruitSprintActView")
    end

end

--请求卡皮活动奖励
function CapyActivitySubsystem:SendMsg_CapyActivityReward(type,actID)
    local msgData = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),type, actID})
    NetManager:Get():Send(MsgID.CAPY_ACTIVE_AWARD_C2S_REQ, msgData)
end

--返回卡皮活动奖励
function CapyActivitySubsystem:RecMsg_CapyActityReward(data)
    ---@type SC_UserActiveInfo
    local msg = assert(Dll_PB.decode("UserActiveInfo", data))
    print(ProtoMsgHelp.block(msg))
    StrengthActivityManager:Get():UpdateRecruitRewardData(msg)
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downProp[1], true)
    UINotify:Get():SendNotification(UINotifyEvent.RecruitSprint_Refresh)
end

local __subsystem = CapyActivitySubsystem()
function CapyActivitySubsystem:Get()
    return __subsystem
end
return __subsystem