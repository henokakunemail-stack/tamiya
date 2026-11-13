


---@class StoryActionScreenEffect:StoryActionBase
StoryActionScreenEffect = class("StoryActionScreenEffect", StoryActionBase)

function StoryActionScreenEffect:initialize(id)
    ---@type storyactionscreeneffect_config_cell
    self.config = CommonHelper:GetTableDataByID(ConfigNames.storyactionscreeneffect_config, id)
end

function StoryActionScreenEffect:Touch()
    CommonHelper:PlayScreenEffectWhite(self.config.Type)
end

function StoryActionScreenEffect:QuickEnd()

end

