-------------------------------------------------图片恢复默认
function CommonHelper:ImageSetMaterialDefault(image)
    --local mat = Material(image.material)
    --mat.shader = ShaderCache.GetShader("UI/Default")
    if image then
        image.material = nil
    end
end
-------------------------------------------------

UIGrayMaterial = nil
-------------------------------------------------图片置灰
function CommonHelper:ImageSetGray(image, isgray)
    if image then
        if UIGrayMaterial == nil then
            UIGrayMaterial = Material(image.material)
            UIGrayMaterial.shader = ShaderCache.GetShader("UI/4wd/ColorGrayScale")
        end
        if isgray then
            image.material = UIGrayMaterial
        else
            image.material = nil
        end
    end

end
-------------------------------------------------




-------------------------------------------------水印
function CommonHelper:ImageSetWaterMask(isWaterMask, image, texName, poolId)
    local mat = Material(image.material)
    if isWaterMask then
        mat.shader = ShaderCache.GetShader("UI/4wd/WaterMask")
        UITextureManager:LoadTexture(texName, poolId, false, function(texture)
            mat:SetTexture("_SourceTex", texture)
        end)
    end
    image.material = mat
end
-------------------------------------------------





-------------------------------------------------自发光
function CommonHelper:ImageSetLightGlow(image, isshine)

    if isshine then
        local mat = Material(image.material)
        mat.shader = ShaderCache.GetShader("UI/4wd/LightGlow")
        image.material = mat
    end

end
-------------------------------------------------



-------------------------------------------------全屏闪白
function CommonHelper:PlayScreenEffectWhite(type,func, class, time)
    UIManager:Get():ShowPersistentView("ScreenEffectView", CanvasType.TopCanvas, "ScreenEffectView", false, true)
    if type == 1 then
        UINotify:Get():SendNotification(UINotifyEvent.ScreenEffectView_Alpha0To1,{ func, class, time })
    elseif type == 2 then
        UINotify:Get():SendNotification(UINotifyEvent.ScreenEffectView_Alpha1To0,{ func, class, time })
    else
        UINotify:Get():SendNotification(UINotifyEvent.ScreenEffectView_Alpha0To0,{ func, class, time })
    end
end
function CommonHelper:PlayScreenEffectWhite0to0(func, class, time)
    UIManager:Get():ShowPersistentView("ScreenEffectView", CanvasType.TopCanvas, "ScreenEffectView", false, true)
    UINotify:Get():SendNotification(UINotifyEvent.ScreenEffectView_Alpha0To0, { func, class, time })
end
-------------------------------------------------

-------------------------------------------------转菊花
function CommonHelper:PlayScreenEffectWaiting(enable)
    if enable then
        UIManager:Get():ShowPersistentView("ScreenEffectView", CanvasType.TopCanvas, "ScreenEffectView", false, true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.ScreenEffectView_Waiting, enable)
end

-------------------------------------------------

-------------------------------------------------全屏遮罩
function CommonHelper:PlayScreenEffectUIMask(time)
    UIManager:Get():ShowPersistentView("ScreenEffectView", CanvasType.TopCanvas, "ScreenEffectView", false, true)
    UINotify:Get():SendNotification(UINotifyEvent.ScreenEffectView_UIMask, time)
end


function CommonHelper:PlayScreenEffectNull(enable)
    if enable then
        UIManager:Get():ShowPersistentView("ScreenEffectView", CanvasType.TopCanvas, "ScreenEffectView", false, true)
    else
        UIManager:Get():HidePersistentView("ScreenEffectView")
    end
end

-------------------------------------------------

-------------------------------------------------打开空白view
function CommonHelper:OpenEmptyView(enable)
    --if enable then
    --    UIManager:Get():OpenView("ScreenEffectView", CanvasType.TopCanvas, "ScreenEffectView")
    --else
    --    if UIManager:Get():IsViewShow("ScreenEffectView") then
    --        UIManager:Get():CloseView()
    --    end
    --end
end



function CommonHelper:PlayGuideScreenEffectUIMask(time)
    UIManager:Get():ShowPersistentView("GuideScreenEffectView", CanvasType.TopCanvas, "GuideScreenEffectView", false, true)
    UINotify:Get():SendNotification(UINotifyEvent.GuideScreenEffectView_UIMask, time)
end

function CommonHelper:CloseGuideScreenEffectUIMask()
    if UIManager:Get():IsPersistentViewShow("GuideScreenEffectView") then
        UIManager:Get():HidePersistentView("GuideScreenEffectView")
    end
end
