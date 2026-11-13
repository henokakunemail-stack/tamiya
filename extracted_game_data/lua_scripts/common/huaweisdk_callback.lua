---@class HuaWeiSDKCallBack
HuaWeiSDKCallBack = class("HuaWeiSDKCallBack")

function HuaWeiSDKCallBack:Get()
    if self._instance == nil then
        self._instance = HuaWeiSDKCallBack()
    end
    return self._instance
end

function HuaWeiSDKCallBack:OnLogin(status, uid)
    --QuickSdkDataManager:Get():SetIsLoginSDK(true)
    PlayerPrefsHelper:SetValue_LoginName(uid)
    UINotify:Get():SendNotification(UINotifyEvent.GameStartView_CloseLoginPanelCG, true)
    UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitServer, nil)
    NetManager:Get():ConnectLoginServer()
    UnifySDKManager:Get():IAccount():DismissMenu()
end

function HuaWeiSDKCallBack:OnLoginOut()
    LoginFuncHelper:LoginOut_GameBackToLogin_Combine(false, true, nil, true)
end

function HuaWeiSDKCallBack:OnPurchaseSuccess(orderId, orderNo, goodsId)
    CommonHelper:PlayScreenEffectWaiting(false)
    print("OnPurchaseSuccess" .. orderId .. "  orderNo" .. orderNo .. " goodsId" .. goodsId)
    --ActivitySubsystem:Get():SendMsg_Purchase_Quick_Shipment(goodsId, orderId)
    SDKHelper:Get():AddPurchase(orderId, orderNo,goodsId)
end

function HuaWeiSDKCallBack:OnPurchaseFail(errorReason)
    CommonHelper:PlayScreenEffectWaiting(false)
end

function HuaWeiSDKCallBack:OnPurchaseCancel(errorReason)
    CommonHelper:PlayScreenEffectWaiting(false)
end

function HuaWeiSDKCallBack:OnFbSharePhoto(errorReason, status)
    print("OnFbSharePhoto:" .. status)
end

function HuaWeiSDKCallBack:onBindInfoChanged(uid)
    print("onBindInfoChanged:" .. uid)
end

function HuaWeiSDKCallBack:onGetFBToken(token)
    CommonTipsHelper:ShowCenterTips("onGetFBTokenLua:" .. token);
    print("onGetFBTokenLua:" .. token)
end

function HuaWeiSDKCallBack:onNewFBToken(token)
    print("onNewFBTokenLua:" .. token)
end

function HuaWeiSDKCallBack:onFBMessageReceived(title, body)
    print("onFBMessageReceivedLua:" .. title .. body)
end