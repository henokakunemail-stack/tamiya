local StepType = {
    Bg = 1,
    Role = 2,
    Dialog = 3,
    RoleState = 4,
}



---@class StoryActionBase
StoryActionBase = class("StoryActionBase")


function StoryActionBase:initialize()

end

function StoryActionBase:Touch()

end

function StoryActionBase:QuickEnd()

end




---@param config storystep_config_cell
function StoryActionBase:CreateAction(config)
    --print("---    CreateAction       actionid = ", config.actionid)
    if config.actionType == StepType.Role then
        return StoryActionRole(config.actionid)
    elseif config.actionType == StepType.Dialog then
        return StoryActionDialog(config.actionid)
    elseif config.actionType == StepType.Bg then
        return StoryActionBG(config.actionid)
    elseif config.actionType == StepType.RoleState then
        return StoryActionRoleState(config.actionid)
    end
end