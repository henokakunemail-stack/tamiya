
---@class LimitSubsystem
LimitSubsystem = class("LimitSubsystem")

function LimitSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.GET_LIMIT_CHAPTER_S2C_RES , self, self.RecvMsg_SelectNewCar)
    NetResponseEventManager:Get():AddListener(MsgID.GET_LIMIT_CHAPTER_ONE_S2C_RES , self, self.RecvMsg_SelectNewCar)
    NetResponseEventManager:Get():AddListener(MsgID.BEGIN_LIMIT_CHAPTER_BATTLE_S2C_RES , self, self.RecvMsg_BeginBattle)
    NetResponseEventManager:Get():AddListener(MsgID.FINISH_LIMIT_CHAPTER_BATTLE_S2C_RES , self, self.RecvMsg_FinishBattle)
end

function LimitSubsystem:SendMsg_GetChapter()
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.GET_LIMIT_CHAPTER_C2S_REQ,data)
end

function LimitSubsystem:RecvMsg_GetChapter(data)
    ---@type SC_UserChapter
    local msg = assert(Dll_PB.decode("UserChapter", data))
    print(ProtoMsgHelp.block(msg))
end
function LimitSubsystem:SendMsg_GetOneChapter(id)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.GET_LIMIT_CHAPTER_ONE_C2S_RES,data)
end

function LimitSubsystem:RecvMsg_GetOneChapter(data)
    ---@type SC_UserCopy
    local msg = assert(Dll_PB.decode("UserCopy", data))
    print(ProtoMsgHelp.block(msg))
end
function LimitSubsystem:SendMsg_BeginBattle(levelid, idx)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),levelid, idx})
    NetManager:Get():Send(MsgID.BEGIN_LIMIT_CHAPTER_BATTLE_C2S_RES,data)
end

function LimitSubsystem:RecvMsg_BeginBattle(data)
    ---@type SC_BeginPve
    local msg = assert(Dll_PB.decode("BeginPve", data))
    print(ProtoMsgHelp.block(msg))
end
function LimitSubsystem:SendMsg_FinishBattle(levelid,carIdx ,rank, time, error)
    local data=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),levelid,carIdx ,rank, time, error})
    NetManager:Get():Send(MsgID.FINISH_LIMIT_CHAPTER_BATTLE_C2S_RES,data)
end

function LimitSubsystem:RecvMsg_FinishBattle(data)
    ---@type SC_FinishPve
    local msg = assert(Dll_PB.decode("FinishPve", data))
    print(ProtoMsgHelp.block(msg))
end


local __subsystem = LimitSubsystem()
function LimitSubsystem:Get() return __subsystem end
return __subsystem