---@class ComicAction
ComicAction = class("ComicAction")

function ComicAction:initialize()
    self.ID = -1
    ---@type comicaction_config_cell
    self.Cfg = nil
end

function ComicAction:SetData(id)
    self.ID = id
    self.Cfg = CommonHelper:GetTableDataByID(ConfigNames.comicaction_config, id)
    if self.Cfg == nil then
        log("---   error:PlotDataAction    cfg = nil    id = ", id)
        return
    end
end
function ComicAction:Touch()
    if self.Cfg == nil then return end

    if self.Cfg.NewDelay > 0 then
        self:TimerStart()
    else
        self:Play()
    end
end

function ComicAction:QuickEnd()
    self:TimerBreak()
    self:Play(true)
end

function ComicAction:TimerStart()
    self.TimerID = TimerManager:Get():CreateTimer(self.Cfg.NewDelay, function()
        self:TimerEnd()
    end)
end
function ComicAction:TimerEnd()
    self.TimerID = -1
    self:Play()
end
function ComicAction:TimerBreak()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end



function ComicAction:Play(isquick)
    if isquick == nil then isquick = false end
    UINotify:Get():SendNotification(UINotifyEvent.ComicView_PlayAction,{self, isquick})
end

function ComicAction:GetImage() return self.Cfg.image end
function ComicAction:GetTweenType() return self.Cfg.tweentype end
function ComicAction:GetSize() return self.Cfg.size end
function ComicAction:GetPos() return self.Cfg.pos end
function ComicAction:GetDuration() return self.Cfg.duration end
function ComicAction:GetDelay() return self.Cfg.delay end