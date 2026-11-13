---@class SurveySubsystem
SurveySubsystem = class("SurveySubsystem")

function SurveySubsystem:initialize(...)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_QUESTIONNAIRE_INFO_S2C_RES, self, self.RecvMsg_SurveyInfo)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_QUESTIONNAIRE_REWARD_S2C_RES, self, self.RecvMsg_GetReward)
end

function SurveySubsystem:SendMsg_SurveyInfo()
    NetManager:Get():Send(OldMsgID.GET_QUESTIONNAIRE_INFO_C2S_REQ, "")
end

function SurveySubsystem:RecvMsg_SurveyInfo(data)
    ---@type SC_GetQuestionnaireInfoRes
    local msg = assert(Dll_PB.decode("GetQuestionnaireInfoRes", data))
    print(ProtoMsgHelp.block(msg))
    SurveyDataManager:Get():InitMsgData(msg.questionIds)
    SurveyDataManager:Get():InitData()
    RedPointManager:Get():UpdateValue(RedPointID.Ask)
end

---领取奖励
function SurveySubsystem:SendMsg_GetReward(id)
    local reqData = {
        questionId = id,
    }
    local reqBytes = assert(Dll_PB.encode("GetQuestionnaireRewardReq", reqData))
    NetManager:Get():Send(OldMsgID.GET_QUESTIONNAIRE_REWARD_C2S_REQ, reqBytes)
end

function SurveySubsystem:RecvMsg_GetReward(data)
    ---@type SC_GetQuestionnaireRewardRes
    local msg = assert(Dll_PB.decode("GetQuestionnaireRewardRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        SurveyDataManager:Get():AddMsgData(msg.questionId)
        CommonHelper:ShowGetReward(SurveyDataManager:Get():GetRewardById(msg.questionId), true)
        UINotify:Get():SendNotification(UINotifyEvent.SurveyView_UpdateScrollList)
        RedPointManager:Get():UpdateValue(RedPointID.Ask)
    end
end

local __subsystem = SurveySubsystem()
function SurveySubsystem:Get()
    return __subsystem
end
return __subsystem