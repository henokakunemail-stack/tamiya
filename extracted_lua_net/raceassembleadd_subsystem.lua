---@class RaceAssembleAddSubsystem
RaceAssembleAddSubsystem = class("RaceAssembleAddSubsystem")

function RaceAssembleAddSubsystem:initialize(...)

    NetResponseEventManager:Get():AddListener(MsgID.RACE_ASSEMBLE_ADD_INFO_S2C_RES, self, self.RecvMsg_RaceAssembleInfo)
end

function RaceAssembleAddSubsystem:SendMsg_RaceAssembleInfo(trackId,sceneId,raceType,racestyle,uiModuleID)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),trackId,sceneId,raceType,racestyle,uiModuleID})
    NetManager:Get():Send(MsgID.RACE_ASSEMBLE_ADD_INFO_C2S_REQ, reqBytes)
end

function RaceAssembleAddSubsystem:RecvMsg_RaceAssembleInfo(data)
    ---@type SC_UserFairInfo
    local msg = assert(Dll_PB.decode("UserFairInfo", data))
    print(ProtoMsgHelp.block(msg))
    RaceAssembleAddManager:Get():Init(msg)
    UIManager:Get():OpenView("RaceTestRunEnterView",CanvasType.MainCanvas,"RaceTestRunEnterView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceTestRunSetData)
end
local __subsystem = RaceAssembleAddSubsystem()
function RaceAssembleAddSubsystem:Get()
    return __subsystem
end
return __subsystem

