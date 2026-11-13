


---@class StoryActionBG:StoryActionBase
StoryActionBG = class("StoryActionBG", StoryActionBase)

function StoryActionBG:initialize(id)
    ---@type storyactionbackground_config_cell
    self.config = CommonHelper:GetTableDataByID(ConfigNames.storyactionbackground_config, id)
end

function StoryActionBG:Touch()
    --UINotify:Get():SendNotification(UINotifyEvent.PlotSetBackground, self.config , false)
end

function StoryActionBG:QuickEnd()
    --UINotify:Get():SendNotification(UINotifyEvent.PlotSetBackground, self.config , true)
end