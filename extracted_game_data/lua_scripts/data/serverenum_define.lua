


--服务器约定枚举

---@class SerE_RaceHistoryModuleType
SerE_RaceHistoryModuleType = {
    Room = 1,--房间赛
    --Rank = 2,--排位赛
    Self = 3,--自建赛事
    Week = 4,--周赛
    Rank = 5,--天梯
}

---@class SerE_RecordType
SerE_RecordType = {
    --回放类型
    Default = 1,--默认
    Rank = 5,--天梯赛
}

---@class SerE_PVPType
SerE_PVPType = {
    RaceRank = 1,--天梯赛
    RaceRoom = 2,--房间赛
}


---@class SerE_RaceRankState
SerE_RaceRankState = {
    None = -1,
    Ready = 1,
    Loading = 2,
    Fight = 3,
    Result = 4,
}

---@class SerE_RaceRoomState
SerE_RaceRoomState = {
    None = -1,
    Wait = 1,
    Loading = 2,
    Fight = 3,
    Result = 4,--结算完成后，房间等待之前
}


---@class SerE_RaceRoomErrorType
SerE_RaceRoomErrorType = {
    CREATE_ROOM = 1,--创建房间错误
    JOIN_ROOM = 2,--加入房间错误
    QUICK_JOIN_ROOM = 3,--快速加入房间错误
}

---@class SerE_RaceRoomListType
SerE_RaceRoomListType = {
    All = 0,--所有类型房间
    Three = 3,--三轨房间
    Five = 5,--五轨房间
}