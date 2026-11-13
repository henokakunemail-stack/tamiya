


---@class RedPointSubsystem
RedPointSubsystem = class("RedPointSubsystem")

function RedPointSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.RED_TIPS_S2C_NOTIFY , self, self.RecvMsg_RedPoint)
end

-------------------------------------------------------------
function RedPointSubsystem:RecvMsg_RedPoint(data)
    log("---   得到红点数据")
    ---@type SC_RedInfo
    local msg = assert(Dll_PB.decode("RedInfo", data))
    log(ProtoMsgHelp.block(msg))
    for i = 1, #msg.redid do
        RecruitDataManager:Get():RecRedPointId(msg.redid[i],"Check")
    end
    RedPointManager:Get():UpdateServer(msg)
end
-------------------------------------------------------------



local __subsystem = RedPointSubsystem()
function RedPointSubsystem:Get() return __subsystem end
return __subsystem