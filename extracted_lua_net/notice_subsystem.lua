---@class NoticeSubsystem
NoticeSubsystem = class("NoticeSubsystem")

function NoticeSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.BROAD_MSG_S2C_NOTICE, self, self.RecvMsg_Notice)
    --NetResponseEventManager:Get():AddListener(MsgID.DINGHAO_S2C_NOTIFY, self, self.RecvMsg_DINGHAO_NOTIFY)
    NetResponseEventManager:Get():AddListener(MsgID.SMALL_SPEAK_S2C_RET, self, self.RecvMsg_SmallSpeak)
end

function NoticeSubsystem:RecvMsg_Notice(data)
    print("---   得到服务器通知数据")
    ---@type SC_TvInfo
    local msg = assert(Dll_PB.decode("TvInfo", data))
    print(ProtoMsgHelp.block(msg))
    NoticeDataManager:Get():AddNoticeMsg(msg)
end

function NoticeSubsystem:RecvMsg_DINGHAO_NOTIFY(data)
    PlayerDataManager:Get():SetPlayerSDKLogoutType(SDKLogoutType.DingHao)

    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, false, function()
        CommonHelper:LoginTipPop(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1009), CommonHelper:GetTempStr_Default(TemplateStringID.OK), function()
            UnifySDKHelper:Account_Login()
        end)
    end, false)
end

function NoticeSubsystem:SendMsg_SmallSpeak(content)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),content})
    NetManager:Get():Send(MsgID.SMALL_SPEAK_C2S_REQ, reqBytes)
end

function NoticeSubsystem:RecvMsg_SmallSpeak(data)
    ---@type SC_UseSpeaker
    local msg = assert(Dll_PB.decode("UseSpeaker", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    KnapsackDataManager:Get():UpdatePropByConsume(msg.props)
    NoticeDataManager:Get():UpdateSmallSpeakTime(msg.speakertime)
    UINotify:Get():SendNotification(UINotifyEvent.BagViewRefresh,true)
end

local __subsystem = NoticeSubsystem()
function NoticeSubsystem:Get()
    return __subsystem
end
return __subsystem