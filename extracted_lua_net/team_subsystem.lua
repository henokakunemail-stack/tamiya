

---@class TeamSubsystem
TeamSubsystem = class("TeamSubsystem")

function TeamSubsystem:initialize( ... )
    --NetResponseEventManager:Get():AddListener(MsgID.CAR_CHANGE_S2C_NOTIFY , self, self.RecvMsg_AllCars)
    --NetResponseEventManager:Get():AddListener(MsgID.CAR_ATTR_CHANGE_S2C_NOTIFY , self, self.RecvMsg_UpdateCarInfo)
    --NetResponseEventManager:Get():AddListener(MsgID.CHANGE_LINEUP_S2C_RES , self, self.RecvMsg_ChangeCar)
    --NetResponseEventManager:Get():AddListener(MsgID.CHANGE_LINEUP_IDX_S2C_RES , self, self.RecvMsg_ChangeCurTeamIdx)

end

function TeamSubsystem:RecvMsg_AllCars(data)
    ---@type SC_NotifyCarChange
    local msg = assert(Dll_PB.decode("NotifyCarChange", data))
    print(ProtoMsgHelp.block(msg))
    CarCacheManager:Get():UpdateCache()
end

function TeamSubsystem:RecvMsg_UpdateCarInfo(data)
    ---@type SC_NotifyCarAttrChange
    local msg = assert(Dll_PB.decode("NotifyCarAttrChange", data))
    print(ProtoMsgHelp.block(msg))
    local data = CarDataManager:Get():GetCarDataByCarID(msg.carIdx)
    data:UpdateAttrs(msg.attrs)

    UINotify:Get():SendNotification(UINotifyEvent.Msg_CarAttrUpdate)
end

--function TeamSubsystem:SendMsg_ChangeCar(teamIdx, carIdx, carID)
--    print("---          ",teamIdx, carIdx, carID)
--    local reqData = {
--        lineupIdx = teamIdx,
--        posIdx = carIdx,
--        carIdx = carID,
--    }
--    local reqBytes = assert(Dll_PB.encode("ChangeLineupReq", reqData))
--    NetManager:Get():Send(MsgID.CHANGE_LINEUP_C2S_REQ, reqBytes)
--end
--function TeamSubsystem:RecvMsg_ChangeCar(data)
--    local msg = assert(Dll_PB.decode("ChangeLineupRes", data))
--    print(ProtoMsgHelp.block(msg))
--
--    local cardata = CarDataManager:Get():GetCarDataByCarID(msg.carIdx)
--    CarDataManager:Get():UpdateCarTeam( msg.carId, msg.lineupIdx + 1, msg.posIdx+ 1)
--    TeamManager:Get():UpdateTeamData( msg.lineupIdx+ 1, msg.posIdx+ 1, cardata)
--end


--function TeamSubsystem:SendMsg_ChangeCurTeamIdx(teamIdx)
--    local reqData = {
--        lineupIdx = teamIdx - 1,
--    }
--    local reqBytes = assert(Dll_PB.encode("ChangeLineIdxReq", reqData))
--    NetManager:Get():Send(MsgID.CHANGE_LINEUP_IDX_C2S_REQ, reqBytes)
--end
--function TeamSubsystem:RecvMsg_ChangeCurTeamIdx(data)
--    local msg = assert(Dll_PB.decode("ChangeLineupIdxRes", data))
--    print(ProtoMsgHelp.block(msg))
--end



local __subsystem = TeamSubsystem()
function TeamSubsystem:Get() return __subsystem end
return __subsystem