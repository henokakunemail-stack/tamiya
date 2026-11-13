---@class ErrorSubsystem
ErrorSubsystem = class("ErrorSubsystem")

function ErrorSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.ERROR_RES, self, self.RecvMsg_Error)
end
function ErrorSubsystem:Get()
    if self._instance == nil then
        self._instance = ErrorSubsystem()
    end
    return self._instance
end
-----------------------------------------------------------MsgError
function ErrorSubsystem:RecvMsg_Error(data)
    ---@type SC_ErrorMess
    local msg = assert(Dll_PB.decode("ErrorMess", data))
    print(ProtoMsgHelp.block(msg))
    MsgErrorManager:Get():TouchEvt(tonumber(msg.errorcode),tonumber(msg.curtime))
end

local __subsystem = ErrorSubsystem()
function ErrorSubsystem:Get()
    return __subsystem
end
return __subsystem