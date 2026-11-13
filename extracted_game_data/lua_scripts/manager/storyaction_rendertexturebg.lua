


---@class StoryActionRenderTextureBG:StoryActionBase
StoryActionRenderTextureBG = class("StoryActionRenderTextureBG", StoryActionBase)

function StoryActionRenderTextureBG:initialize(id)
    ---@type storyactionrendertexturebg_config
    self.config = CommonHelper:GetTableDataByID(ConfigNames.storyactionrendertexturebg_config, id)
end

function StoryActionRenderTextureBG:Touch()
    --UINotify:Get():SendNotification(UINotifyEvent.PlotSetRenderTextureBG, self.config , false)
end

function StoryActionRenderTextureBG:QuickEnd()

end

