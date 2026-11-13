


---@class PlotDataAction
PlotDataAction = class("PlotDataAction")

function PlotDataAction:initialize()
    self.ID = -1
    ---@type plotaction_config_cell
    self.Cfg = nil
    ---@type PlotDataPlayer
    self.Player = nil
end
function PlotDataAction:SetData(id)
    self.ID = id
    self.Cfg = CommonHelper:GetTableDataByID(ConfigNames.plotaction_config, id)
    if self.Cfg == nil then
        return -1
    end

    if self:GetActionType() == 1 then
        self.Player = PlotDataPlayer()
        self.Player:SetData(self.Cfg.playerid)
    end
    return self
end

function PlotDataAction:Touch()
    if self.Cfg == nil then return end

    if self.Cfg.NewDelay > 0 then
        self:TimerStart()
    else
        self:Play()
    end
end

function PlotDataAction:QuickEnd()
    self:TimerBreak()
    self:Play(true)
end

function PlotDataAction:GetID() return self.ID end
function PlotDataAction:GetPlayer() return self.Player end

function PlotDataAction:GetActionType() return self.Cfg.actiontype end
function PlotDataAction:GetJoin() return self.Cfg.joinmode end
function PlotDataAction:GetPos() return self.Cfg.pos end
function PlotDataAction:GetPicIdx() return self.Cfg.heropicidx end
function PlotDataAction:GetRawImgIdx() return self.Cfg.hreopicid end
function PlotDataAction:GetPicAni() return self.Cfg.picani end
function PlotDataAction:GetMiniIcon() return self.Cfg.miniicon end
function PlotDataAction:GetMiniIconAni() return self.Cfg.iconani end
function PlotDataAction:GetGary() return self.Cfg.gary end
function PlotDataAction:GetMoveIdx() return self.Cfg.moveidx end
function PlotDataAction:GetMoveAni() return self.Cfg.moveani end



function PlotDataAction:GetDialogType() return self.Cfg.dialogtype end
function PlotDataAction:GetDialogAni() return self.Cfg.dialogani end
function PlotDataAction:GetContentType() return self.Cfg.contenttype end
function PlotDataAction:GetContent() return self.Cfg.content end















function PlotDataAction:TimerStart()
    self.TimerID = TimerManager:Get():CreateTimer(self.Cfg.NewDelay, function()
        self:TimerEnd()
    end)
end
function PlotDataAction:TimerEnd()
    self.TimerID = -1
    self:Play()
end
function PlotDataAction:TimerBreak()
    TimerManager:Get():StopTimer(self.TimerID)
    self.TimerID = -1
end



function PlotDataAction:Play(isquick)
    if isquick == nil then isquick = false end
    UINotify:Get():SendNotification(UINotifyEvent.PlotAction,{self, isquick})
end