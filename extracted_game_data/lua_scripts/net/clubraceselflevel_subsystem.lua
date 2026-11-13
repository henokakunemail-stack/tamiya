---@class ClubRaceSelfLevelSubsystem
ClubRaceSelfLevelSubsystem = class("ClubRaceSelfLevelSubsystem")

function ClubRaceSelfLevelSubsystem:initialize( ... )
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_CREATE_LEVEL_G2C_RES, self, self.RecSelfLevelCreate)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_JOIN_LEVEL_G2C_RES, self, self.RecSelfLevelJoin)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_GET_LEVEL_G2C_RES, self, self.RecSelfLevelGetList)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_GET_JOIN_LEVEL_G2C_RES, self, self.RecSelfLevelGetJoinList)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_GET_LEVEL_DETAIL_G2C_RES, self, self.RecSelfLevelGetDetail)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_LEVEL_BEGIN_RACE_G2C_RES, self, self.RecSelfLevelBeginRace)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_LEVEL_FINISH_RACE_G2C_RES, self, self.RecSelfLevelFinishRace)
end


function ClubRaceSelfLevelSubsystem:SendMsg_SelfLevelCreate(configId,sceneId,trackIdx,name)
    local reqData = {
        configId = configId,
        sceneId = sceneId,
        trackId = trackIdx,
        name = name,
    }
    local reqBytes = assert(Dll_PB.encode("GUILD_SC_CreateLevelReq", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_CREATE_LEVEL_C2G_REQ, reqBytes)
end
function ClubRaceSelfLevelSubsystem:RecSelfLevelCreate(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("GUILD_SC_CreateLevelRes", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CreateSuccess))
    ClubRaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetList(0)
end


function ClubRaceSelfLevelSubsystem:SendMsg_SelfLevelJoin(id)
    local reqData = {
        num=id,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_JOIN_LEVEL_C2G_REQ, reqBytes)
end
function ClubRaceSelfLevelSubsystem:RecSelfLevelJoin(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("Tuple1", data))
    print(ProtoMsgHelp.block(msg))

    UINotify:Get():SendNotification(UINotifyEvent.ClubRaceSelfLevelViewSetJoinSuccess,msg.num)

end

function ClubRaceSelfLevelSubsystem:SendMsg_SelfLevelGetList(id)
    local reqData = {
        num=id
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_GET_LEVEL_C2G_REQ, reqBytes)
end
function ClubRaceSelfLevelSubsystem:RecSelfLevelGetList(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("GUILD_SC_Level_GetGamesRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubRaceSelfLevelDataManager:Get():SetPageIndex(msg.result)
    ClubRaceSelfLevelDataManager:Get():SetAllInfo(msg)
    if UIManager:Get():IsViewShow("ClubRaceSelfLevelView")==false then
        UIManager:Get():OpenView("ClubRaceSelfLevelView", CanvasType.MainCanvas, "ClubRaceSelfLevelView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.ClubRaceSelfLevelViewSetAll)
end


function ClubRaceSelfLevelSubsystem:SendMsg_SelfLevelGetJoinList()
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_GET_JOIN_LEVEL_C2G_REQ,"")
end
function ClubRaceSelfLevelSubsystem:RecSelfLevelGetJoinList(data)
    ---@type SC_SC_Level_GetGamesRes
    local msg = assert(Dll_PB.decode("GUILD_SC_Level_GetGamesRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubRaceSelfLevelDataManager:Get():SetAllJoinedInfo(msg)
    if UIManager:Get():IsViewShow("ClubRaceSelfLevelView")==false then
        UIManager:Get():OpenView("ClubRaceSelfLevelView", CanvasType.MainCanvas, "ClubRaceSelfLevelView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.ClubRaceSelfLevelViewSetJoin)
end


function ClubRaceSelfLevelSubsystem:SendMsg_SelfLevelGetDetail(id)
    local reqData = {
        num=id
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_GET_LEVEL_DETAIL_C2G_REQ, reqBytes)
end
function ClubRaceSelfLevelSubsystem:RecSelfLevelGetDetail(data)
    ---@type SC_GUILD_SC_CreateLevelRes
    local msg = assert(Dll_PB.decode("GUILD_SC_CreateLevelRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubRaceSelfLevelDataManager:Get():UpdateSelfLevelData(msg.gameInfo)
end

function ClubRaceSelfLevelSubsystem:SendMsg_SelfLevelBeginRace(id,carIdx)
    local reqData = {
        num1=id,
        num2=carIdx,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple2_64_32", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_LEVEL_BEGIN_RACE_C2G_REQ, reqBytes)
end
function ClubRaceSelfLevelSubsystem:RecSelfLevelBeginRace(data)
    ---@type SC_SC_LevelBeginRaceRes
    local msg = assert(Dll_PB.decode("GUILD_SC_LevelBeginRaceRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubRaceSelfLevelDataManager:Get():RecBattleData(msg)
end

function ClubRaceSelfLevelSubsystem:SendMsg_SelfLevelFinishRace(id,info)
    local reqData = {
        gameId=id,
        resultInfo=info,
    }
    local reqBytes = assert(Dll_PB.encode("GUILD_SC_LevelFinishRaceReq", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_LEVEL_FINISH_RACE_C2G_REQ, reqBytes)
end
function ClubRaceSelfLevelSubsystem:RecSelfLevelFinishRace(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("GUILD_SC_LevelFinishRaceRes", data))
    print(ProtoMsgHelp.block(msg))
    BattleDataManager:Get():SetStateBattleResult()
end

local __subsystem = ClubRaceSelfLevelSubsystem()
function ClubRaceSelfLevelSubsystem:Get() return __subsystem end
return __subsystem