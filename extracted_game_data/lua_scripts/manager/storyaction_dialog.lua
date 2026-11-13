

---@class StoryActionDialog:StoryActionBase
StoryActionDialog = class("StoryActionDialog", StoryActionBase)

function StoryActionDialog:initialize(id)
    ---@type storyactiondialog_config_cell
    self.config = CommonHelper:GetTableDataByID(ConfigNames.storyactiondialog_config, id)
end

function StoryActionDialog:Touch()
    --UINotify:Get():SendNotification(UINotifyEvent.PlotSetDialog, self.config , false)
end

function StoryActionDialog:QuickEnd()
    --UINotify:Get():SendNotification(UINotifyEvent.PlotSetDialog, self.config , true)
end
