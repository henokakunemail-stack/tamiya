
local joinType = {
    EnterSence = 1,
    LeaveSence = 2,
}


---@class StoryActionRole:StoryActionBase
StoryActionRole = class("StoryActionRole", StoryActionBase)

function StoryActionRole:initialize(id)
    ---@type storyactionrole_config_cell
    self.config = CommonHelper:GetTableDataByID(ConfigNames.storyactionrole_config, id)
end

function StoryActionRole:Touch()
    if self.config.joinType == joinType.EnterSence then
        --UINotify:Get():SendNotification(UINotifyEvent.PlotRoleEnterSence, self.config , false)
    else
        --UINotify:Get():SendNotification(UINotifyEvent.PlotRoleLeaveSence, self.config , false)
    end
end


function StoryActionRole:QuickEnd()
    if self.config.joinType == joinType.EnterSence then
        --UINotify:Get():SendNotification(UINotifyEvent.PlotRoleEnterSence, self.config , true)
    else
        --UINotify:Get():SendNotification(UINotifyEvent.PlotRoleLeaveSence, self.config , true)
    end
end
