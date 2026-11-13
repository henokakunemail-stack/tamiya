---@class FullScreenSkillView : ViewBase
FullScreenSkillView = class("FullScreenSkillView", ViewBase)

function FullScreenSkillView:initialize()
    ViewBase.initialize(self)
end

function FullScreenSkillView:Awake()

end

function FullScreenSkillView:OnOpen()
    local icon=BattleDyDataManager:Get():GetSelfCarData():GetHolderIconName()
    CommonHelper:SetGameObjectActive("HeadFx",self.gameObject,icon~="0")
    if icon=="0" then
        return
    end
    UITextureManager:LoadTexture(icon, UIModuleID.BattleFullScreenSkillView, false, function(texture)
        local renderer=self:GetChildWight("HeadFx",typeof(Renderer))
        MonoHelper:RendererSetTexture(renderer,"_Main_Tex",texture)
    end)
end
function FullScreenSkillView:OnClose()
   CommonHelper:ReleasePool(UIModuleID.BattleFullScreenSkillView)
end


