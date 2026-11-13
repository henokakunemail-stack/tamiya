---@class AdRewardSubsystem
AdRewardSubsystem = class("AdRewardSubsystem")

function AdRewardSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.GET_AD_REWARD_LIST_S2C_RES, self, self.RecvMsg_GetAdRewardList)
    NetResponseEventManager:Get():AddListener(MsgID.START_AD_REWARD_S2C_RES, self, self.RecvMsg_StartAdReward)
    NetResponseEventManager:Get():AddListener(MsgID.END_AD_REWARD_S2C_RES, self, self.RecvMsg_EndAdReward)
end
local _CurAdId=0
function AdRewardSubsystem:RecvMsg_GetAdRewardList(data)
    ---@type SC_UserAdList
    local msg = assert(Dll_PB.decode("UserAdList", data))
    print(ProtoMsgHelp.block(msg))
    TaskDataManager:Get():SetOpenModuleType(UIModuleID.MainMenu)
    TaskDataManager:Get():OnInitAd(msg,TaskType.AD)
    if UIManager:Get():IsViewShow("TaskView") == false then
        UIManager:Get():OpenView("TaskView", CanvasType.MainCanvas, "TaskView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.TaskViewSetData, TaskType.AD)
end
function AdRewardSubsystem:SendMsg_GetAdRewardList()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.GET_AD_REWARD_LIST_C2S_REQ, data)
end

function AdRewardSubsystem:RecvMsg_StartAdReward(data)
    ---@type SC_UserShiftInfo
    local msg = assert(Dll_PB.decode("UserAdList", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:PlayScreenEffectWaiting(true)
    CommonHelper:SendAdJustToken(TrackEventNames.PlayAd,AnalysisType.PlayAd)
    AdsManager:ShowSdk(AdType.Task,function(result,type)
        print("AdsManagerShowSdkResult",result,type)
        CommonHelper:PlayScreenEffectWaiting(false)
        if not NetManager:Get():GetGameServerIsConnect() and self:CheckGameState(ClientDataManager:Get():GetGameState()) then
            ClientDataManager:Get():SetGameState(GameState.Reconnecting)
        end
        cs_coroutine.start(function()
            while not NetManager:Get():GetGameServerIsConnect() or not self:CheckGameState(ClientDataManager:Get():GetGameState()) do
                coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
            end
            if result==AdResult.Reward then
                if type==AdType.Task then
                    CommonHelper:SendAdJustToken(TrackEventNames.PlayAdEnd,AnalysisType.PlayAdEnd)
                    AdRewardSubsystem:Get():SendMsg_EndAdReward(_CurAdId)
                end
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.AdsPlayFail))
            end
        end)
    end)
end
function AdRewardSubsystem:CheckGameState(state)
    return state == GameState.Login_GameServer or state == GameState.CrossDay
end
function AdRewardSubsystem:SendMsg_StartAdReward(id)
    _CurAdId=id
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.START_AD_REWARD_C2S_REQ, data)
end

function AdRewardSubsystem:RecvMsg_EndAdReward(data)
    ---@type SC_UserAdList
    local msg = assert(Dll_PB.decode("UserAdList", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.adAward[1],true)
    TaskDataManager:Get():UpdateAdTaskById(msg.myAdInfo)
    UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
end
function AdRewardSubsystem:SendMsg_EndAdReward(id)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.END_AD_REWARD_C2S_REQ, data)
end

local __subsystem = AdRewardSubsystem()
function AdRewardSubsystem:Get()
    return __subsystem
end
return __subsystem