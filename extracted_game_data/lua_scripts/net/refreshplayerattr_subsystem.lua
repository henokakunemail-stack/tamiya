---@class RefreshPlayerAttrSubsystem
RefreshPlayerAttrSubsystem = class("RefreshPlayerAttrSubsystem")

function RefreshPlayerAttrSubsystem:initialize(...)
  --  NetResponseEventManager:Get():AddListener(MsgID.UPDATE_NUMBER_DATA_S2C_NOTIFY, self, self.RecvMsg_NotifyNumberChange)
end

function RefreshPlayerAttrSubsystem:RecvMsg_NotifyNumberChange(data)
    ---@type SC_Tuple2Array
    local msg = assert(Dll_PB.decode("Tuple2Array", data))
    print(ProtoMsgHelp.block(msg))
    if msg.numbers~=nil then
        PlayerDataManager:Get():SetCurrencyList(msg.numbers)
    end
end




local __subsystem = RefreshPlayerAttrSubsystem()
function RefreshPlayerAttrSubsystem:Get()
    return __subsystem
end
return __subsystem