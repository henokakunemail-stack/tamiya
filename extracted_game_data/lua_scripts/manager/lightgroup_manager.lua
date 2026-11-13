

local __instance
---@class LightGroupManager
LightGroupManager = class("LightGroupManager")
function LightGroupManager:initialize()

end
---@return LightGroupManager
function LightGroupManager:Get()
    if __instance == nil then
        __instance = LightGroupManager()
    end
    return __instance
end

function LightGroupManager:BuildLight(resname)

    local temp = CommonHelper:GetRootObjectExactMath(SceneHome_LightGroup_Home)
    if temp then
        temp:SetActive(resname == SceneHome_LightGroup_Home)
    end


    temp = CommonHelper:GetRootObjectExactMath(SceneHome_LightGroup_Table)
    if temp then
        temp:SetActive(resname == SceneHome_LightGroup_Table)
    end


    temp = CommonHelper:GetRootObjectExactMath(SceneHome_LightGroup_Recruit)
    if temp then
        temp:SetActive(resname == SceneHome_LightGroup_Recruit)
    end


    temp = CommonHelper:GetRootObjectExactMath(SceneHome_LightGroup_Garage)
    if temp then
        temp:SetActive(resname == SceneHome_LightGroup_Garage)
    end


    temp = CommonHelper:GetRootObjectExactMath(SceneHome_LightGroup_Article)
    if temp then
        temp:SetActive(resname == SceneHome_LightGroup_Article)
    end

end
function LightGroupManager:DisableLightGroup()
    CSUtil.DisableLightGroup()
end