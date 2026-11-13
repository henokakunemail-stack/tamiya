

---@class GuideSubsystem
GuideSubsystem = class("GuideSubsystem")

function GuideSubsystem:initialize( ... )
  --  NetResponseEventManager:Get():AddListener(MsgID.SELECT_NEW_CAR_S2C_RES , self, self.RecvMsg_SelectNewCar)

end

function GuideSubsystem:SendMsg_SelectNewCar(carid)
    local reqData = {
        carId = carid,
    }
    local reqBytes = assert(Dll_PB.encode("SelectNewCarReq", reqData))
   -- NetManager:Get():Send(MsgID.SELECT_NEW_CAR_C2S_REQ, reqBytes)
end

function GuideSubsystem:RecvMsg_SelectNewCar(data)
    --local msg = assert(Dll_PB.decode("GetShopInfoRes", data))
    --print(ProtoMsgHelp.block(msg))

    UINotify:Get():SendNotification(UINotifyEvent.InitialView_Succeed)
end


local __subsystem = GuideSubsystem()
function GuideSubsystem:Get() return __subsystem end
return __subsystem