---@class EmailSubsystem
EmailSubsystem = class("EmailSubsystem")

function EmailSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.READ_MAIL_S2C_RES, self, self.RecvMsg_ReadEmail)
    NetResponseEventManager:Get():AddListener(MsgID.NEW_MAIL_S2C_RES, self, self.RecvMsg_GetAllEmail)
    NetResponseEventManager:Get():AddListener(MsgID.GET_MAIL_S2C_RES, self, self.RecvMsg_GetEmailItem)
    NetResponseEventManager:Get():AddListener(MsgID.DELETE_MAIL_S2C_RES, self, self.RecvMsg_DeleteEmail)
end

-------------------------------------------------------------获取邮件列表
function EmailSubsystem:RecvMsg_GetAllEmail(data)
    ---@type SC_UserMail
    local msg = assert(Dll_PB.decode("UserMail", data))
    print(ProtoMsgHelp.block(msg))
    EmailDataManager:Get():AddEmailListData(msg.mails)
    if UIManager:Get():IsViewShow("EmailView") then
        UINotify:Get():SendNotification(UINotifyEvent.EmailListView_InitEmailList)
    end
    RedPointManager:Get():UpdateValue(RedPointID.Email)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ComeNewMail))
end


-------------------------------------------------------------读取
function EmailSubsystem:SendMsg_ReadEmail(id)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.READ_MAIL_C2S_REQ, reqBytes)
end
function EmailSubsystem:RecvMsg_ReadEmail(data)
    ---@type SC_MailOpened
    local msg = assert(Dll_PB.decode("MailOpened", data))
    print(ProtoMsgHelp.block(msg))
    EmailDataManager:Get():UpdateOneEmailState(msg.mailid, msg.ifuse)
    RedPointManager:Get():UpdateValue(RedPointID.Email)
    UINotify:Get():SendNotification(UINotifyEvent.EmailListView_RefreshEmail)
    UINotify:Get():SendNotification(UINotifyEvent.EmailListView_UpdateEmailView,msg.mailid)
end
-------------------------------------------------------------


-------------------------------------------------------------提取附件
function EmailSubsystem:SendMsg_GetEmailItem(id)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.GET_MAIL_C2S_REQ, reqBytes)
end
function EmailSubsystem:RecvMsg_GetEmailItem(data)
    ---@type SC_MailDown
    local msg = assert(Dll_PB.decode("MailDown", data))
    print(ProtoMsgHelp.block(msg))
    ---@type EmailUpdateData
    EmailDataManager:Get():UpdateDataIsUse(msg.mailid)
    RedPointManager:Get():UpdateValue(RedPointID.Email)
    UINotify:Get():SendNotification(UINotifyEvent.EmailListView_RefreshEmail)
    UINotify:Get():SendNotification(UINotifyEvent.EmailListView_UpdateEmailView,msg.mailid[1])
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1])
    if #msg.mailCharge>0 and #msg.mailCharge[1].myActFirst > 0 then
        ---首次充值奖励写这里
        UserFirstGiftManager:Get():SetUserFirstGiftData(msg.mailCharge[1].myActFirst)
    end
end


-------------------------------------------------------------一键领取
function EmailSubsystem: SendMsg_GetEmailItemOneKey()
    NetManager:Get():Send(MsgID.DELETE_MAIL_C2S_REQ, "")
end
function EmailSubsystem:RecvMsg_GetEmailItemOneKey(data)
    local msg = assert(Dll_PB.decode("OnekeyExtractMailItemRes", data))
    print(ProtoMsgHelp.block(msg))
    ---@type EmailUpdateData
    msg.mailState=EmailState.Read
    EmailDataManager:Get():UpdateAllEmail(msg)
    EmailDataManager:Get().CanGetEmail=0
    if msg.numbers~=nil then
        if msg.numbers.numbers~=nil then
            PlayerDataManager:Get():SetCurrencyList(msg.numbers.numbers)
        end
    end
end

-------------------------------------------------------------删除
function EmailSubsystem:SendMsg_DeleteEmail(id)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.DELETE_MAIL_C2S_REQ, reqBytes)
end
function EmailSubsystem:RecvMsg_DeleteEmail(data)
    local msg = assert(Dll_PB.decode("MailDeled", data))
    print(ProtoMsgHelp.block(msg))
    EmailDataManager:Get():DeleteEmail(msg.mailid)
    RedPointManager:Get():UpdateValue(RedPointID.Email)
    UINotify:Get():SendNotification(UINotifyEvent.EmailListView_InitEmailList)
    UINotify:Get():SendNotification(UINotifyEvent.EmailListView_DeleteEmail)
end


local __subsystem = EmailSubsystem()
function EmailSubsystem:Get()
    return __subsystem
end
return __subsystem