---@class CustomtrackSubsystem
CustomtrackSubsystem = class("CustomtrackSubsystem")

function CustomtrackSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.GET_CUSTOM_TRACK_LIST_S2C_RES , self, self.RecvMsg_SelfTrackInfo)
    NetResponseEventManager:Get():AddListener(MsgID.SAVE_CUSTOM_TRACK_S2C_RES , self, self.RecvMsg_SelfTrackData)
    NetResponseEventManager:Get():AddListener(MsgID.DEL_CUSTOM_TRACK_S2C_RES , self, self.RecvMsg_UpdateSegmentBag)
    NetResponseEventManager:Get():AddListener(MsgID.TEST_RUN_CUSTOM_TRACK_S2C_RES , self, self.RecvMsg_TestRunTime)
end
function CustomtrackSubsystem:RecvMsg_SelfTrackInfo(data)
    ---@type SC_UserTrackList
    local msg = assert(Dll_PB.decode("UserTrackList", data))
    print(ProtoMsgHelp.block(msg))
   -- UIManager:Get():OpenView("RaceMenuView",CanvasType.MainCanvas,"RaceMenuView")
   -- if msg.type==CustomTrackViewOpenType.CustomTrack then
   -- UINotify:Get():SendNotification(UINotifyEvent.CustomTrackListViewOpen)
   -- elseif msg.type==CustomTrackViewOpenType.RaceRoom then
   --     UINotify:Get():SendNotification(UINotifyEvent.RaceRoomTrackListView_SetMsgData)
   -- elseif msg.type==CustomTrackViewOpenType.MainCity then
   --     --UIManager:Get():OpenView("RaceMenuView",CanvasType.MainCanvas,"RaceMenuView")
   --
   -- end

end
function CustomtrackSubsystem:RecvMsg_UpdateSegmentBag(data)
    ---@type SC_DelUserTrack
    local msg = assert(Dll_PB.decode("DelUserTrack", data))
    print(ProtoMsgHelp.block(msg))
    RaceTrackDataManager:Get():DelTrackDataByServerId(msg.delTrackId)
    for i = 1, #msg.alterProps do
        SegmentDataManager:Get():UpdateTrackSegmentNum(msg.alterProps[i])
    end
    UINotify:Get():SendNotification(UINotifyEvent.CustomTrackListViewOpen)
end
function CustomtrackSubsystem:RecvMsg_TestRunTime(data)
    ---@type SC_UserTrack
    local msg = assert(Dll_PB.decode("UserTrack", data))
    print(ProtoMsgHelp.block(msg))
    local data=RaceTrackData()
    data:SetData(nil,nil,msg)
    RaceTrackDataManager:Get():SetTrackListById(data)
end
function CustomtrackSubsystem:RecvMsg_SelfTrackData(data)
    ---@type SC_EditUserTrack
    local msg = assert(Dll_PB.decode("EditUserTrack", data))
    print(ProtoMsgHelp.block(msg))
    for i = 1, #msg.alterProps do
        SegmentDataManager:Get():UpdateTrackSegmentNum(msg.alterProps[i])
    end
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TrackSaveSuccess))
    local data=RaceTrackData()
    data:SetData(nil,nil,msg.editTrack)
    RaceTrackDataManager:Get():SetTrackListById(data)
    UINotify:Get():SendNotification(UINotifyEvent.CustomTrackSaveSuccess)
end
function CustomtrackSubsystem:SendMsg_DelTrack(id)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.DEL_CUSTOM_TRACK_C2S_REQ,reqBytes)
end
function CustomtrackSubsystem:SendMsg_TrackTestRun(id,time)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id,time})
    NetManager:Get():Send(MsgID.TEST_RUN_CUSTOM_TRACK_C2S_REQ,reqBytes)
end
function CustomtrackSubsystem:SendMsg_GetTrackList()
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.GET_CUSTOM_TRACK_LIST_C2S_REQ,reqBytes)
end

function CustomtrackSubsystem:SendMsg_UpdateTrackData(data,type)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),data.idx,data.trackInfo.name,data.number,data.trackInfo.angle,data.trackInfo.bias.s1,data.trackInfo.bias.s2,data.trackInfo.bias.s3,data.canRun},data.trackInfo.data)
    NetManager:Get():Send(MsgID.SAVE_CUSTOM_TRACK_C2S_REQ,reqBytes)
end
local __subsystem=CustomtrackSubsystem()
function CustomtrackSubsystem:Get() return __subsystem end
return __subsystem