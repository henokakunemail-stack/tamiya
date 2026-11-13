


---@class StoryStepTimerClick:StoryStepBase
StoryStepTimerClick = class("StoryStepTimerClick",StoryStepBase)

---@param config story_config_cell
function StoryStepTimerClick:initialize(config)
    ---@type table<number,number>
    self.timerlist = {}
    self.config = config
    self:InitActions(config.stepid)
end


function StoryStepTimerClick:CheckCanNext()
    return true
end

function StoryStepTimerClick:Touch()
    self:BreakTimer()
    self:TouchActionGroup()

    local during = tonumber(self.config.skipParam)
    local timerid = TimerManager:Get():CreateTimer(during * 0.001, self.TimerFinish, self)
    table.insert(self.timerlist,timerid)
end


function StoryStepTimerClick:TouchActionGroup()
    print("---   *****      TouchActionGroup",#self.actionMap)
    for i = 1, #self.actionMap do
        local temp = self.actionMap[i]
        --print("---   *****      temp",temp[1],temp[2])
        local timerid = TimerManager:Get():CreateTimer(temp[1] * 0.001, function() temp[2]:Touch() end)
        table.insert(self.timerlist,timerid)
    end
end

function StoryStepTimerClick:TimerFinish()
    StoryManager:Get():NextStep()
end


function StoryStepTimerClick:BreakTimer()
    for i = 1, #self.timerlist do
        TimerManager:Get():StopTimer(self.timerlist[i])
    end
    self.timerlist = {}
end

function StoryStepTimerClick:Reset()
    self:BreakTimer()
end

function StoryStepTimerClick:Skip()
    StoryStepBase.Skip(self)
    self:BreakTimer()
end