


local StateType = {
    Waiting = 1,
    Showing = 2,
}




---@class StoryStepTimer:StoryStepBase
StoryStepTimer = class("StoryStepTimer",StoryStepBase)

---@param config story_config_cell
function StoryStepTimer:initialize(config)
    ---@type table<number,number>
    self.timerlist = {}
    self.config = config
    self.CurState = StateType.Waiting
    self:InitActions(config.stepid)
end


function StoryStepTimer:CheckCanNext()
    if self.CurState == StateType.Waiting then
        return true
    end
    return false
end

function StoryStepTimer:Touch()
    if self.CurState == StateType.Showing then
        print("---   剧情正在播放，不能触发下一步")
        return
    end
    self.CurState = StateType.Showing

    self:TouchActionGroup()

    local during = tonumber(self.config.skipParam)
    local timerid = TimerManager:Get():CreateTimer(during * 0.001, self.TimerFinish, self)
    table.insert(self.timerlist,timerid)
end

function StoryStepTimer:TouchActionGroup()
    for i = 1, #self.actionMap do
        local temp = self.actionMap[i]
        local timerid = TimerManager:Get():CreateTimer(temp[1] * 0.001, function() temp[2]:Touch() end)
        table.insert(self.timerlist,timerid)
    end
end

function StoryStepTimer:TimerFinish()
    self.CurState = StateType.Waiting
    self:BreakTimer()
    StoryManager:Get():NextStep()
end






function StoryStepTimer:BreakTimer()
    for i = 1, #self.timerlist do
        TimerManager:Get():StopTimer(self.timerlist[i])
    end
    self.timerlist = {}
end

function StoryStepTimer:Reset()
    self.CurState = StateType.Waiting
    self:BreakTimer()
end







