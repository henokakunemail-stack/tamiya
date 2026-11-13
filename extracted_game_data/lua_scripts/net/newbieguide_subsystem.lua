---@class NewBieSubSystem
NewBieSubSystem = class("NewBieSubSystem")

function NewBieSubSystem:initialize( ... )
  NetResponseEventManager:Get():AddListener(MsgID.UPDATE_GUIDE_STEP_G2C_RES , self, self.RecvMsg_NewBieStep)
end
function NewBieSubSystem:RecvMsg_NewBieStep(data)
    ---@type SC_UserTimeBuy
    local msg = assert(Dll_PB.decode("UserTimeBuy", data))
    PopUpGiftDataManager:Get():UpdateDataByMsg(msg,true)
    PopUpGiftDataManager:Get():DelayPopUpShow()
end
function NewBieSubSystem:SendMsgUpdateGuideStepRes(id)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.UPDATE_GUIDE_STEP_C2G_REQ,data,true)
end
local __subsystem=NewBieSubSystem()
function NewBieSubSystem:Get() return __subsystem end
return __subsystem
