


---@class PlotDataStep
PlotDataStep = class("PlotDataStep")

function PlotDataStep:initialize()
    ---@type plotstep_config_cell
    self.Cfg = nil
    ---@type table<number, PlotDataAction>
    self.Actions = {}

    self.IsPlaying = false
end
function PlotDataStep:SetData(id)
    self.Cfg = CommonHelper:GetTableDataByID(ConfigNames.plotstep_config, id)
    if self.Cfg == nil then
        return
    end

    for i = 1, #self.Cfg.actions do
        local actionid = self.Cfg.actions[i]
        local data = PlotDataAction()
        local result= data:SetData(actionid)
        if result~=-1 then
            table.insert(self.Actions, data)
        end
    end
    table.sort(self.Actions, function (a, b)
        return a:GetID() < b:GetID()
    end)
end

function PlotDataStep:ClearData()
    self.IsPlaying = false
end

function PlotDataStep:GetIsPlaying()
    return self.IsPlaying
end
function PlotDataStep:GetStepID()
    if self.Cfg then return self.Cfg.id end
    return -1
end

function PlotDataStep:Touch()
    if self.Cfg == nil then
        log("---   error:PlotDataStep:Touch()    cfg = nil,自动跳过！！！")
        PlotManager:Get():NextStep()
        return
    end

    log("---   ^^^   触发step", self.Cfg.id)

    self.IsPlaying = true
    self:TimerStart()

    for i = 1, #self.Actions do
        self.Actions[i]:Touch()
    end
end

function PlotDataStep:QuickEnd()
    for i = 1, #self.Actions do
        self.Actions[i]:QuickEnd()
    end

    self:TimerBreak()
    self:AutoSkipTimerBreak()
    self:StepEnd()
end

function PlotDataStep:Skip()
    self:TimerBreak()
    self:AutoSkipTimerBreak()
    self:ClearData()
end



function PlotDataStep:StepEnd()
    self.IsPlaying = false
    PlotManager:Get():NextStep()
end

function PlotDataStep:TimerStart()
    self.TimerID = TimerManager:Get():CreateTimer(self.Cfg.NewDuring, function()
        self:TimerEnd()
    end)
end

function PlotDataStep:TimerEnd()
    self.TimerID = -1
    self:AutoSkip()
end

function PlotDataStep:TimerBreak()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end




function PlotDataStep:AutoSkip()
    if self.Cfg.skiptype == 1 then
        self:AutoSkipTimerStart()
    else
        self:StepEnd()
    end
end
function PlotDataStep:AutoSkipTimerStart()
    self.AutoSkipTimerID = TimerManager:Get():CreateTimer(self.Cfg.NewSkipparam, function()
        self:AutoSkipTimerEnd()
    end)
end
function PlotDataStep:AutoSkipTimerEnd()
    self.AutoSkipTimerID = -1
    self:StepEnd()
end
function PlotDataStep:AutoSkipTimerBreak()
    TimerManager:Get():StopTimer(self.AutoSkipTimerID)
    self.AutoSkipTimerID = -1
end