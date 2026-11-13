---@class UniWebViewCallBack
UniWebViewCallBack = class("UniWebViewCallBack")

function UniWebViewCallBack:Get()
    if self._instance == nil then
        self._instance = UniWebViewCallBack()
    end
    return self._instance
end


function UniWebViewCallBack:OnPageStarted(url)
    print("OnPageStarted:"..url)
    if string.find(url,"http://www.protonjoy.com/pay.html") ~= nil then
        --baxi可申请发货
        ActivitySubsystem:Get().isBaXiPayCanShipment = true
    else
        ActivitySubsystem:Get().isBaXiPayCanShipment = false
    end
end
function UniWebViewCallBack:OnMessageReceived()
    print("OnMessageReceived")
end
function UniWebViewCallBack:OnShouldClose()
    print("OnShouldClose")
end
function UniWebViewCallBack:OnPageErrorReceived()
    print("OnPageErrorReceived")
end
function UniWebViewCallBack:OnPageFinished()
    print("OnPageFinished")
end






