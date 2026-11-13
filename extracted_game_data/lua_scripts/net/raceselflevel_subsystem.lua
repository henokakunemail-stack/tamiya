---@class RaceSelfLevelSubsystem
RaceSelfLevelSubsystem = class("RaceSelfLevelSubsystem")

function RaceSelfLevelSubsystem:initialize( ... )

end

function RaceSelfLevelSubsystem:SendMsg_SelfLevelCreate(configId,sceneId,trackIdx,name)
    local reqData = {
         configId = configId,
         sceneId = sceneId,
         trackId = trackIdx,
         name = name,
    }
    local reqBytes = assert(Dll_PB.encode("SC_CreateLevelReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_CREATE_LEVEL_C2B_REQ, body, self.RecSelfLevelCreate, self)
end
function RaceSelfLevelSubsystem:RecSelfLevelCreate(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("SC_CreateLevelRes", data))
    print(ProtoMsgHelp.block(msg))
    if msg.result==51 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.HoldCostNoCount))
    else
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CreateSuccess))
        RaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetList(0)
    end

end


function RaceSelfLevelSubsystem:SendMsg_SelfLevelJoin(id)
    local reqData = {
        num=id,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_JOIN_LEVEL_C2B_REQ, body, self.RecSelfLevelJoin, self)
end
function RaceSelfLevelSubsystem:RecSelfLevelJoin(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("Tuple1", data))
    print(ProtoMsgHelp.block(msg))

    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfLevelViewSetJoinSuccess,msg.num)

end

function RaceSelfLevelSubsystem:SendMsg_SelfLevelGetList(id)
    local reqData = {
       num=id
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_GET_LEVEL_C2B_REQ, body, self.RecSelfLevelGetList, self)
end
function RaceSelfLevelSubsystem:RecSelfLevelGetList(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("SC_Level_GetGamesRes", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfLevelDataManager:Get():SetPageIndex(msg.num)
    RaceSelfLevelDataManager:Get():SetAllInfo(msg)
    if UIManager:Get():IsViewShow("RaceSelfLevelView")==false then
        UIManager:Get():OpenView("RaceSelfLevelView", CanvasType.MainCanvas, "RaceSelfLevelView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfLevelViewSetAll)
end


function RaceSelfLevelSubsystem:SendMsg_SelfLevelGetJoinList()
    --local reqData = {
    --    gameId=id,
    --    resultInfo=info,
    --}
    --local reqBytes = assert(Dll_PB.encode("SC_ChapterFinishRaceReq", reqData))
    --local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_GET_JOIN_LEVEL_C2B_REQ, "", self.RecSelfLevelGetJoinList, self)
end
function RaceSelfLevelSubsystem:RecSelfLevelGetJoinList(data)
    ---@type SC_SC_Level_GetGamesRes
    local msg = assert(Dll_PB.decode("SC_Level_GetGamesRes", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfLevelDataManager:Get():SetAllJoinedInfo(msg)
    if UIManager:Get():IsViewShow("RaceSelfLevelView")==false then
        UIManager:Get():OpenView("RaceSelfLevelView", CanvasType.MainCanvas, "RaceSelfLevelView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.RaceSelfLevelViewSetJoin)
end


function RaceSelfLevelSubsystem:SendMsg_SelfLevelGetDetail(id)
    local reqData = {
        num=id
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_GET_LEVEL_DETAIL_C2B_REQ, body, self.RecSelfLevelGetDetail, self)
end
function RaceSelfLevelSubsystem:RecSelfLevelGetDetail(data)
    ---@type SC_SC_CreateLevelRes
    local msg = assert(Dll_PB.decode("SC_CreateLevelRes", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfLevelDataManager:Get():UpdateSelfLevelData(msg.gameInfo)
end

function RaceSelfLevelSubsystem:SendMsg_SelfLevelBeginRace(id,carIdx)
    local reqData = {
        num1=id,
        num2=carIdx,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple2_64_32", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_LEVEL_BEGIN_RACE_C2B_REQ, body, self.RecSelfLevelBeginRace, self)
end
function RaceSelfLevelSubsystem:RecSelfLevelBeginRace(data)
    ---@type SC_SC_LevelBeginRaceRes
    local msg = assert(Dll_PB.decode("SC_LevelBeginRaceRes", data))
    print(ProtoMsgHelp.block(msg))
    RaceSelfLevelDataManager:Get():RecBattleData(msg)
end

function RaceSelfLevelSubsystem:SendMsg_SelfLevelFinishRace(id,info)
    local reqData = {
        gameId=id,
        resultInfo=info,
    }
    local reqBytes = assert(Dll_PB.encode("SC_LevelFinishRaceReq", reqData))
    local body = CommonHelper:ConvertByteArrayToString(reqBytes)
    NetManager:Get():SendHttpPost_RaceSelf(self:GetUrl(), OldMsgID.SC_LEVEL_FINISH_RACE_C2B_REQ, body, self.RecSelfLevelFinishRace, self)
end
function RaceSelfLevelSubsystem:RecSelfLevelFinishRace(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("SC_LevelFinishRaceRes", data))
    print(ProtoMsgHelp.block(msg))
    BattleDataManager:Get():SetStateBattleResult()
end


function RaceSelfLevelSubsystem:GetUrl(type)
    if type == nil then
        type = ServerType.Battle
    end
    local servertype = type
    local serverdata = ClientDataManager:Get():GetServerInfoByIndex(servertype, 1)
    local str = string.format("http://%s:%d/battle/battle?", serverdata.ip, serverdata.port)
    return str

end
local __subsystem = RaceSelfLevelSubsystem()
function RaceSelfLevelSubsystem:Get() return __subsystem end
return __subsystem