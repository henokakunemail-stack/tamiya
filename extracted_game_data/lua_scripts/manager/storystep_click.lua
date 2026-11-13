


---@class StoryStepClick:StoryStepBase
StoryStepClick = class("StoryStepClick",StoryStepBase)

---@param config story_config_cell
function StoryStepClick:initialize(config)
    ---@type table<number,number>
    self.timerlist = {}
    self.config = config
    self:InitActions(config.stepid)
end


function StoryStepClick:CheckCanNext()
    return true
end

function StoryStepClick:Touch()

    self:TouchActionGroup()

    local during = tonumber(self.config.skipParam)
    local timerid = TimerManager:Get():CreateTimer(during, self.TimerFinish, self)
    table.insert(self.timerlist,timerid)
end


function StoryStepClick:TouchActionGroup()
    for i = 1, #self.actionMap do
        local temp = self.actionMap[i]
        local timerid = TimerManager:Get():CreateTimer(temp[1], function() temp[2]:Touch() end)
        table.insert(self.timerlist,timerid)
    end
end

function StoryStepClick:TimerFinish()
    self:BreakTimer()
end


function StoryStepClick:BreakTimer()
    for i = 1, #self.timerlist do
        TimerManager:Get():StopTimer(self.timerlist[i])
    end
    self.timerlist = {}
end