---@class ClubRaceSelfChapterSubsystem
ClubRaceSelfChapterSubsystem = class("ClubRaceSelfChapterSubsystem")

function ClubRaceSelfChapterSubsystem:initialize(...)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_CREATE_CHAPTER_G2C_RES, self, self.RecCreateSelfChapter)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_GET_CHAPTER_G2C_RES, self, self.RecGetAllSelfChapter)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_GET_JOIN_CHAPTER_G2C_RES, self, self.RecGetAllJoinSelfChapter)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_GET_CHAPTER_DETAIL_G2C_RES, self, self.RecGetSelfChapterDetail)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_CHAPTER_BEGIN_RACE_G2C_RES, self, self.RecSelfChapterBeginRace)
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_SC_CHAPTER_FINISH_RACE_G2C_RES, self, self.RecSelfChapterFinishRace)
end

function ClubRaceSelfChapterSubsystem:SendMsg_CreateSelfChapter(id)
    local reqData = {
        num = id,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_CREATE_CHAPTER_C2G_REQ, reqBytes)
end

function ClubRaceSelfChapterSubsystem:RecCreateSelfChapter(data)
    ---@type SC_SC_CreateChapterRes
    local msg = assert(Dll_PB.decode("GUILD_SC_CreateChapterRes", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CreateSuccess))
    ClubRaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(0)
end

function ClubRaceSelfChapterSubsystem:SendMsg_GetAllSelfChapter(index)
    local reqData = {
        num = index,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_GET_CHAPTER_C2G_REQ, reqBytes)
end
function ClubRaceSelfChapterSubsystem:RecGetAllSelfChapter(data)
    ---@type SC_SC_Chapter_GetGamesRes
    local msg = assert(Dll_PB.decode("GUILD_SC_Chapter_GetGamesRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubRaceSelfChapterDataManager:Get():SetPageIndex(msg.result)
    ClubRaceSelfChapterDataManager:Get():SetAllInfo(msg)
    if UIManager:Get():IsViewShow("ClubRaceSelfChapterView")==false then
        UIManager:Get():OpenView("ClubRaceSelfChapterView", CanvasType.MainCanvas, "ClubRaceSelfChapterView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.ClubRaceSelfChapterViewSetAll)
end

function ClubRaceSelfChapterSubsystem:SendMsg_GetAllJoinSelfChapter()
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_GET_JOIN_CHAPTER_C2G_REQ,"")
end
function ClubRaceSelfChapterSubsystem:RecGetAllJoinSelfChapter(data)
    ---@type SC_SC_Chapter_GetGamesRes
    local msg = assert(Dll_PB.decode("GUILD_SC_Chapter_GetGamesRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubRaceSelfChapterDataManager:Get():SetAllJoinedInfo(msg)
    if UIManager:Get():IsViewShow("ClubRaceSelfChapterView")==false then
        UIManager:Get():OpenView("ClubRaceSelfChapterView", CanvasType.MainCanvas, "ClubRaceSelfChapterView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.ClubRaceSelfChapterViewSetJoin)
end

function ClubRaceSelfChapterSubsystem:SendMsg_GetSelfChapterDetail(id)
    local reqData = {
        num = id,
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_GET_CHAPTER_DETAIL_C2G_REQ,reqBytes)
end
function ClubRaceSelfChapterSubsystem:RecGetSelfChapterDetail(data)
    ---@type SC_GUILD_SC_CreateChapterRes
    local msg = assert(Dll_PB.decode("GUILD_SC_CreateChapterRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubRaceSelfChapterDataManager:Get():SetChapterData(msg)
    UIManager:Get():OpenView("ClubRaceSelfChapterListView", CanvasType.MainCanvas, "ClubRaceSelfChapterListView")
    UINotify:Get():SendNotification(UINotifyEvent.ClubRaceSelfChapterListView_SetLevelList)
end

function ClubRaceSelfChapterSubsystem:SendMsg_SelfChapterBeginRace(raceId, carIdx)
    local reqData = {
        gameId = raceId,
        carIdx = carIdx
    }
    local reqBytes = assert(Dll_PB.encode("GUILD_SC_ChapterBeginRaceReq", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_CHAPTER_BEGIN_RACE_C2G_REQ,reqBytes)
end
function ClubRaceSelfChapterSubsystem:RecSelfChapterBeginRace(data)
    ---@type SC_SC_ChapterBeginRaceRes
    local msg = assert(Dll_PB.decode("GUILD_SC_ChapterBeginRaceRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubRaceSelfChapterDataManager:Get():RecBattleData(msg)
end

function ClubRaceSelfChapterSubsystem:SendMsg_SelfChapterFinishRace(id,info)
    local reqData = {
        gameId=id,
        resultInfo=info,
    }
    local reqBytes = assert(Dll_PB.encode("GUILD_SC_ChapterFinishRaceReq", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SC_CHAPTER_FINISH_RACE_C2G_REQ,reqBytes)
end
function ClubRaceSelfChapterSubsystem:RecSelfChapterFinishRace(data)
    ---@type SC_SC_ChapterFinishRaceRes
    local msg = assert(Dll_PB.decode("GUILD_SC_ChapterFinishRaceRes", data))
    print(ProtoMsgHelp.block(msg))

    BattleDataManager:Get():SetStateBattleResult()
end


local __subsystem = ClubRaceSelfChapterSubsystem()
function ClubRaceSelfChapterSubsystem:Get()
    return __subsystem
end
return __subsystem