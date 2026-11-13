


---@class ChapterDataManager
ChapterDataManager = class("ChapterDataManager")

function ChapterDataManager:initialize()
    ---@type table<number, ChapterData>
    self.StoryList = {}

    ---@type table<number, ChapterData>
    self.CustomList = {}

    ---@type table<number, ChapterData>
    self.ChapterList = {}
end

function ChapterDataManager:Get()
    if self._instance == nil then
        self._instance = ChapterDataManager()
    end
    return self._instance
end

function ChapterDataManager:Init()
    self.StoryList = {}
    self.CustomList = {}
    self.ChapterList = {}

    ---@type map_config
    local tabmap = ClientDataManager:Get():GetDataTable(ConfigNames.map_config)
    local maplist = tabmap.GetConfigData()
    for k,v in pairs(maplist)  do
        local data = ChapterData()
        data:SetData(v)
        table.insert(self.ChapterList, data)

        if v.type == 1 then table.insert(self.CustomList, data) end
        if v.type == 2 then table.insert(self.StoryList, data) end
    end


    table.sort(self.ChapterList,function (a, b)
        return a.id < b.id
    end)
    table.sort(self.CustomList,function (a, b)
        return a.id < b.id
    end)
    table.sort(self.StoryList,function (a, b)
        return a.id < b.id
    end)
end

function ChapterDataManager:GetStoryList()
    return self.StoryList
end

function ChapterDataManager:GetCustomList()
    return self.CustomList
end



---@return ChapterData
function ChapterDataManager:GetChapterDataByID(id)
    for i = 1, #self.ChapterList do
        if self.ChapterList[i].id == id then
            return self.ChapterList[i]
        end
    end
end

---@return ChapterData
function ChapterDataManager:GetChapterDataByLevelID(id)
    local chpaterid = CommonHelper:AnalyseChapterId(id)
    for i = 1, #self.ChapterList do
        if self.ChapterList[i].id == chpaterid then
            return self.ChapterList[i]
        end
    end
end

---@return LevelData
function ChapterDataManager:GetLevelData(id)
    local chpaterid, levelid = CommonHelper:AnalyseChapterId(id)
    for i = 1, #self.ChapterList do
        if self.ChapterList[i].id == chpaterid then
            for m = 1, #self.ChapterList[i].LevelList do
                if self.ChapterList[i].LevelList[m].newid == id then
                    return self.ChapterList[i].LevelList[m]
                end
            end
        end
    end
end

---@return LevelData
function ChapterDataManager:GetLevelDataByIdx(chapterid, idx)
    for i = 1, #self.ChapterList do
        if self.ChapterList[i].id == chapterid then
            for m = 1, #self.ChapterList[i].LevelList do
                if self.ChapterList[i].LevelList[m].newid == idx then
                    return self.ChapterList[i].LevelList[m]
                end
            end
        end
    end
end

---@return ChapterData
function ChapterDataManager:GetCurChapter()
    local result
    for i = 1, #self.ChapterList do
        if self.ChapterList[i].lock then
            return result
        end
        result = self.ChapterList[i]
    end
    return result
end

---@param msg SC_GetAllChapterInfoRes
function ChapterDataManager:UpdateMsgChapterList(msg)
    for i = 1, #msg.chapterInfo do
        local chapterid = msg.chapterInfo[i].chapterId
        local process = msg.chapterInfo[i].passNum
        local states = msg.chapterInfo[i].rewards
        for m = 1, #self.ChapterList do
            if self.ChapterList[m].id == chapterid then
                self.ChapterList[m]:SetLock(false)
                self.ChapterList[m]:SetProcess(process)
                self.ChapterList[m]:SetAllBoxState(states)
                break
            end
        end
    end
end

function ChapterDataManager:UpdateMsgLevelList(msg)
    local data = self:GetChapterDataByID(msg.chapterId)
    for i = 1, #msg.levelInfos do
        local levelid = msg.levelInfos[i].num1
        local state = msg.levelInfos[i].num2
        local time = msg.levelInfos[i].num3
        for m = 1, #data.LevelList do
            if data.LevelList[m].newid == levelid then
                data.LevelList[m].lock = false
                data.LevelList[m].state = state
                data.LevelList[m].personRecord = time
                break
            end
        end
    end
end

function ChapterDataManager:UpdateMsgChapterBoxState(msg)
    for m = 1, #self.ChapterList do
        if self.ChapterList[m].id == msg.chapterId then
            self.ChapterList[m]:SetBoxState(msg.rLevelId,msg.state)
            break
        end
    end
end

function ChapterDataManager:UpdateMsgChapterData(levelid, boxstates, win, unkockId)

    local chpaterid = CommonHelper:AnalyseChapterId(levelid)
    for m = 1, #self.ChapterList do
        if self.ChapterList[m].id == chpaterid then
            self.ChapterList[m]:SetAllBoxState(boxstates)
            if win then
                local process = self.ChapterList[m].process
                local temp = self:GetLevelData(levelid)
                if temp.state ~= 1 then
                    process = process + 1
                    self.ChapterList[m]:SetProcess(process)
                end
            end
            break
        end
    end
    if unkockId~=nil then
        chpaterid = CommonHelper:AnalyseChapterId(unkockId)
        for m = 1, #self.ChapterList do
            if self.ChapterList[m].id == chpaterid then
                self.ChapterList[m]:SetLock(false)
                break
            end
        end
    end

end