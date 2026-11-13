---@class ExaminationSubsystem
ExaminationSubsystem = class("ExaminationSubsystem")

function ExaminationSubsystem:initialize(...)
    -- 660, --返回题库
    NetResponseEventManager:Get():AddListener(MsgID.RET_QUESTION, self, self.RecMsg_Question)
    -- 662, --返回答题
    NetResponseEventManager:Get():AddListener(MsgID.RET_ANSWER, self, self.RecMsg_Answer)

end

--659, --请求题库
function ExaminationSubsystem:SendMsg_Question()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.REQ_QUESTION, data)
end

--660, --返回题库
function ExaminationSubsystem:RecMsg_Question(data)
    ---@type SC_UserQuestList
    local msg = assert(Dll_PB.decode("UserQuestList", data))
    print(ProtoMsgHelp.block(msg))

    WelfareBoxDataManager:Get():SetExaminationMsgData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideoOpenPage, WelfareFuncType.examination)
    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideo_PageRunAction, { WelfareFuncType.examination, "InitDetailsData" })

end

--661, --请求答题
function ExaminationSubsystem:SendMsg_Answer(NumId)
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), NumId })
    NetManager:Get():Send(MsgID.REQ_ANSWER, data)
end

--662, --返回答题
function ExaminationSubsystem:RecMsg_Answer(data)
    ---@type SC_UserAnswer
    local msg = assert(Dll_PB.decode("UserAnswer", data))
    print(ProtoMsgHelp.block(msg))

    if msg.downlist ~=nil  then
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true)
    end
    RedPointManager:Get():UpdateValue(RedPointID.S_Examination, false)
    --UINotify:Get():SendNotification(UINotifyEvent.ExaminationView_RefreshDetails, msg)

    WelfareBoxDataManager:Get():SetExaminationMsgData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideo_PageRunAction, { WelfareFuncType.examination, "InitDetailsData" })

end

function ExaminationSubsystem:Clear()

end

local __subsystem = ExaminationSubsystem()

function ExaminationSubsystem:Get()
    return __subsystem
end

return __subsystem

