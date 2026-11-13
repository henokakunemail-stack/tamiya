


---@class StoryActionRoleState:StoryActionBase
StoryActionRoleState = class("StoryActionRoleState", StoryActionBase)

function StoryActionRoleState:initialize(id)
    ---@type storyactionrolestate_config_cell
    self.config = CommonHelper:GetTableDataByID(ConfigNames.storyactionrolestate_config, id)
end

function StoryActionRoleState:Touch()
    --UINotify:Get():SendNotification(UINotifyEvent.PlotSetRoleState, self.config  , false)
end

function StoryActionRoleState:QuickEnd()
    --UINotify:Get():SendNotification(UINotifyEvent.PlotSetRoleState, self.config , true)
end

