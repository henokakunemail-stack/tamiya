---@class ComicStep
ComicStep = class("ComicStep")

function ComicStep:initialize()
    self.ID = -1
    ---@type comicaction_config_cell
    self.Cfg = nil
    self.IsPlayIng=false
    self.Actions={}
end

function ComicStep:SetData(id)
    self.ID = id
    self.Cfg = CommonHelper:GetTableDataByID(ConfigNames.comicstep_config, id)
    if self.Cfg == nil then
        log("---   error:PlotDataAction    cfg = nil    id = ", id)
        return
    end
    for i = 1, #self.Cfg.actionids do
        local actionid = self.Cfg.actionids[i]
        local data = ComicAction()
        data:SetData(actionid)
        table.insert(self.Actions, data)
    end
end

function ComicStep:ClearData()
    self.IsPlaying = false
end

function ComicStep:GetIsPlaying()
    return self.IsPlaying
end
function ComicStep:GetStepID()
    if self.Cfg then return self.Cfg.id end
    return -1
end

function ComicStep:Touch()
    if self.Cfg == nil then
        log("---   error:ComicStep:Touch()    cfg = nil,自动跳过！！！")
        ComicManager:Get():NextStep()
        return
    end
    log("---   ^^^   触发step", self.Cfg.id)

    self.IsPlaying = true
    self:TimerStart()

    for i = 1, #self.Actions do
        self.Actions[i]:Touch()
    end
end

function ComicStep:QuickEnd()
    for i = 1, #self.Actions do
        self.Actions[i]:QuickEnd()
    end

    self:TimerBreak()
    self:AutoSkipTimerBreak()
    self:StepEnd()
end

function ComicStep:Skip()
    self:TimerBreak()
    self:AutoSkipTimerBreak()
    self:ClearData()
end



function ComicStep:StepEnd()
    self.IsPlaying = false
    PlotManager:Get():NextStep()
end

function ComicStep:TimerStart()
    self.TimerID = TimerManager:Get():CreateTimer(self.Cfg.NewDuring, function()
        self:TimerEnd()
    end)
end

function ComicStep:TimerEnd()
    self.TimerID = -1
    self:AutoSkip()
end

function ComicStep:TimerBreak()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end




function ComicStep:AutoSkip()
    if self.Cfg.skiptype == 1 then
        self:AutoSkipTimerStart()
    else
        self:StepEnd()
    end
end
function ComicStep:AutoSkipTimerStart()
    self.AutoSkipTimerID = TimerManager:Get():CreateTimer(self.Cfg.NewSkipparam, function()
        self:AutoSkipTimerEnd()
    end)
end
function ComicStep:AutoSkipTimerEnd()
    self.AutoSkipTimerID = -1
    self:StepEnd()
end
function ComicStep:AutoSkipTimerBreak()
    TimerManager:Get():StopTimer(self.AutoSkipTimerID)
    self.AutoSkipTimerID = -1
end