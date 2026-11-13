---@class LoginTaskSubSystem
LoginTaskSubSystem = class("LoginTaskSubSystem")

function LoginTaskSubSystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_7_SIGN_IN_S2C_RES, self, self.RevMsg_SignInfo)
    NetResponseEventManager:Get():AddListener(MsgID.GET_7_SIGN_IN_REWARD_S2C_RES, self, self.RecMsg_SignReward)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_NOVICE_TASK_REWARD_S2C_RES, self, self.RecMsg_GetNoviceTaskReward)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_NOVICE_TASK_POINT_REWARD_S2C_RES, self, self.RecMsg_GetNoviceTaskPointReward)
    --NetResponseEventManager:Get():AddListener(MsgID.NOVICE_TASK_STATUS_S2C_NOTIFY, self, self.RecMsg_NotifyTaskStatus)
end

----签到
function LoginTaskSubSystem:SendMsg_GetSignInInfo()
    local data =CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.GET_7_SIGN_IN_C2S_REQ, data)
end
function LoginTaskSubSystem:RevMsg_SignInfo(data)
    ---@type SC_UserSign
    local msg = assert(Dll_PB.decode("UserSign", data))
    print(ProtoMsgHelp.block(msg))
    if not UIManager:Get():IsPersistentViewShow("LoginTaskView") then
        UIManager:Get():ShowPersistentView("LoginTaskView", CanvasType.MainCanvas, "LoginTaskView", false)
    end
    UINotify:Get():SendNotification(UINotifyEvent.LoginTaskSignView_InitTaskLoginInfo, msg)
    --LoginTaskDataManager:Get():SetIsCanSign(msg.canSignIn)
    --UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_RefreshFirstBuyRedPoint)
    --
    --if msg.canSignIn or LoginTaskDataManager:Get():GetBtnFlag() then
    --    if not UIManager:Get():IsPopViewShow("LoginTaskView") then
    --        UIManager:Get():OpenPopup("LoginTaskView", CanvasType.MainCanvas, "LoginTaskView", true)
    --        UINotify:Get():SendNotification(UINotifyEvent.LoginTaskSignView_InitTaskLoginInfo, { msg.times, msg.canSignIn })
    --    end
    --end
end

----获得签到的详细信息
function LoginTaskSubSystem:SendMsg_GetSignInfoReward(day)
    local data =CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),day})
    NetManager:Get():Send(MsgID.GET_7_SIGN_IN_REWARD_C2S_REQ, data)
end
function LoginTaskSubSystem:RecMsg_SignReward(data)
    ---@type SC_UserSign
    local msg = assert(Dll_PB.decode("UserSign", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1],true)
    UINotify:Get():SendNotification(UINotifyEvent.LoginTaskSignView_RefreshLoginInfo, msg.daySign)
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_InitBtnInfo)
end


----领取任务奖励
function LoginTaskSubSystem:SendMsg_GetNoviceTaskReward(taskId)

    local reqData = {
        taskId = taskId
    }
    local reqBytes = assert(Dll_PB.encode("GetNoviceTaskRewardReq", reqData))

    NetManager:Get():Send(OldMsgID.GET_NOVICE_TASK_REWARD_C2S_REQ, reqBytes)
end
function LoginTaskSubSystem:RecMsg_GetNoviceTaskReward(data)

    ---@type SC_GetNoviceTaskRewardRes
    local msg = assert(Dll_PB.decode("GetNoviceTaskRewardRes", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetReward(msg.rewards, true)
    if msg.numbers ~= nil then
        if msg.numbers.numbers ~= nil then
            PlayerDataManager:Get():SetCurrencyList(msg.numbers.numbers)
        end
    end
    LoginTaskDataManager:Get():UpdateActive(msg.pointId)
end

----领取任务点宝箱的奖励
function LoginTaskSubSystem:SendMsg_GetNoviceTaskPointReward(pointId)

    local reqData = {
        pointId = pointId
    }
    local reqBytes = assert(Dll_PB.encode("GetNoviceTaskPointRewardReq", reqData))

    NetManager:Get():Send(OldMsgID.GET_NOVICE_TASK_POINT_REWARD_C2S_REQ, reqBytes)
end
function LoginTaskSubSystem:RecMsg_GetNoviceTaskPointReward(data)

    ---@type SC_GetNoviceTaskPointRewardRes
    local msg = assert(Dll_PB.decode("GetNoviceTaskPointRewardRes", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetReward(msg.rewards, true)
    if msg.numbers ~= nil then
        if msg.numbers.numbers ~= nil then
            PlayerDataManager:Get():SetCurrencyList(msg.numbers.numbers)
        end
    end

    LoginTaskDataManager:Get():UpdateActive(msg.pointId)


end

----当任务发生变化变化时，服务器推送
function LoginTaskSubSystem:RecMsg_NotifyTaskStatus(data)
    ---@type SC_NoviceTaskListRes
    local msg = assert(Dll_PB.decode("NoviceTaskListRes", data))
    print(ProtoMsgHelp.block(msg))
    LoginTaskDataManager:Get():InitNoviceData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_RefreshFirstBuyRedPoint)
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_NoviceTask)
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_Login)
end

local __subsystem = LoginTaskSubSystem()
function LoginTaskSubSystem:Get()
    return __subsystem
end
return __subsystem
