


---@class StoryData
StoryData = class("StoryData")

function StoryData:initialize(cfg)
    self.CurStepIndex = 0
    ---@type StoryStepBase
    self.CurStep = nil
    ---@type table<number, story_config_cell>
    self.storyCfg = cfg
    ---@type table<number, StoryStepBase>
    self.stepList = {}
    self.storyid = self.storyCfg[1].storyid
    self:InitStepList()
end

function StoryData:InitStepList()
    --print("---    step数量 " , #self.storyCfg)
    for i = 1, #self.storyCfg do
        local steptemp = StoryStepBase:CreateStep(self.storyCfg[i])
        table.insert(self.stepList, steptemp)
    end
end

function StoryData:Start()
    self.CurStepIndex = 1
    self.CurStep = self.stepList[self.CurStepIndex]

    self.CurStep:Touch()
end

function StoryData:Next()
    if self.CurStep:CheckCanNext() == false then
        return
    end

    self.CurStepIndex = self.CurStepIndex + 1
    self.CurStep = self.stepList[self.CurStepIndex]

    if self.CurStep == nil then
        self:End()
    else
        self.CurStep:Touch()
    end
end

function StoryData:End()
    self.CurStepIndex = 0
    self.CurStep = nil
    for i = 1, #self.stepList do
        self.stepList[i]:Reset()
    end
    StoryManager:Get():EndStory()
end

function StoryData:SkipStory()
    self.CurStepIndex = 0
    self.CurStep = nil
    for i = 1, #self.stepList do
        self.stepList[i]:Reset()
    end
end
function StoryData:SkipStep()
    if self.CurStep ~= nil then
        self.CurStep:Skip()
    end
    self:Next()
end