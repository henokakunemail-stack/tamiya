
---@class CommonTipsHelper
CommonTipsHelper = class("CommonTipsHelper")

local __instance
---@return CommonTipsHelper
function CommonTipsHelper:Get()
    if __instance == nil then
        __instance = CommonTipsHelper()
    end
    return __instance
end

-------------------------------------------------通用提示，中间飘字
function CommonTipsHelper:ShowCenterTips(str)
    local isshow = UIManager:Get():IsPersistentViewShow("CenterTipsView")
    if isshow == false then
        UIManager:Get():ShowPersistentView("CenterTipsView", CanvasType.TopCanvas, "CenterTipsView",false,true)
    end
    UINotify:Get():SendNotification(UINotifyEvent.ShowTips_Center, str)
end
-------------------------------------------------


-------------------------------------------------通用提示，顶部推送
function CommonTipsHelper:ShowPushTips(str)
    UINotify:Get():SendNotification(UINotifyEvent.ShowTips_Top, str)
end
-------------------------------------------------
