
---@type StoryData
local __CurStoryData = nil
local __FinishFunction = nil
local __FinishFunctionParam = nil
local __FinishClass = nil

---@class StoryManager
StoryManager = class("StoryManager")

function StoryManager:initialize()
    ---@type table<number, StoryData>
    self.storyList = {}
end

function StoryManager:Get()
    if self._instance == nil then
        self._instance = StoryManager()
    end
    return self._instance
end

function StoryManager:OnInit()
    ---@type story_config
    local table = ClientDataManager:Get():GetDataTable(ConfigNames.story_config)

    local storyCfg = table.GetStorys()
    --print("---    剧情数量 " , #storyCfg)
    for i = 1, #storyCfg do
        self.storyList[i] = StoryData(storyCfg[i])
    end
end

function StoryManager:StartStory(id, finishEvt, finishParam, class)

    UIManager:Get():OpenView("PlotView", CanvasType.MainCanvas, "PlotView")

    for i = 1, #self.storyList do
        if self.storyList[i].storyid == id then
            __CurStoryData = self.storyList[i]
            break
        end
    end

    print("---   触发剧情，查找剧情数据：",id,__CurStoryData)

    if __CurStoryData then
        __CurStoryData:Start()
    end

    __FinishFunction = finishEvt or nil
    __FinishFunctionParam = finishParam or nil
    __FinishClass = class or nil
end

function StoryManager:EndStory()
    print("---   剧情结束：")
    UIManager:Get():CloseView()

    if __FinishFunction ~= nil then
        if __FinishClass then
            __FinishFunction(__FinishClass, __FinishFunctionParam)
        else
            __FinishFunction(__FinishFunctionParam)
        end
    end
    __CurStoryData = nil
    __FinishFunction = nil
    __FinishFunctionParam = nil
    __FinishClass = nil


end

function StoryManager:NextStep()
    if __CurStoryData then
        __CurStoryData:SkipStep()
    end
end



function StoryManager:SkipStory()
    __CurStoryData:SkipStory()
    self.EndStory()
end

function StoryManager:SkipStep()
    __CurStoryData:SkipStep()
end
