
---@class AdjustSdk
AdjustSdk = class("AdjustSdk")

function AdjustSdk:Get()
    if self._instance == nil then
        self._instance = AdjustSdk()
    end
    return self._instance
end

---打点事件接口
---@param   eventName         TrackEventNames    事件名

function AdjustSdk:TrackEvent(eventName)
    CS.AdjustSdk:Get():trackEvent(eventName)
end

function AdjustSdk:TrackEventRevenue(eventName,venue,orderId)
    print("TrackEventRevenue:" .. eventName ..venue ..orderId)
    CS.AdjustSdk:Get():trackEventRevenue(eventName,venue,orderId)
end

function AdjustSdk:getAttribution()
    local attribution = CS.AdjustSdk:Get():getAttribution()
    if attribution == "" then
        attribution = "Others"
    end
    print(attribution)
    local lines = stringSplit(attribution, ":")
    return lines[1]
end

function AdjustSdk:getAttributionAll()
    local attribution = CS.AdjustSdk:Get():getAttributionAll()
    print(attribution)
    return attribution
end






