


---@class StoryStepBase
StoryStepBase = class("StoryStepBase")

function StoryStepBase:initialize()

end

function StoryStepBase:InitActions(stepid)
    ---@type table<number,table<number,StoryActionBase>>
    self.actionMap = {}
    ---@type storystep_config
    local tab = ClientDataManager:Get():GetDataTable(ConfigNames.storystep_config)
    local actions = tab.GetStepByID(stepid)
    if actions == nil then
        logError("---    StoryStepBase:InitActions    createstep = nil      stepid = ", stepid)
    end
    for i = 1, #actions do
        local action = StoryActionBase:CreateAction(actions[i])
        table.insert(self.actionMap, {actions[i].delay, action})
    end
end

function StoryStepBase:CheckCanNext()

end

function StoryStepBase:Touch()

end

function StoryStepBase:Skip()
    for i = 1, #self.actionMap do
        local temp = self.actionMap[i]
        temp[2]:QuickEnd()
    end
end

function StoryStepBase:Reset()

end





---@param config story_config_cell
function StoryStepBase:CreateStep(config)
    if config.skipType == StoryStepType.Timer then
        return StoryStepTimer(config)
    elseif config.skipType == StoryStepType.Click then
        return StoryStepClick(config)
    elseif config.skipType == StoryStepType.TimerClick then
        return StoryStepTimerClick(config)
    end
end