---@class ReYunSdk
ReYunSdk = class("ReYunSdk")

function ReYunSdk:Get()
    if self._instance == nil then
        self._instance = ReYunSdk()
    end
    return self._instance
end

function ReYunSdk:initReYunSDK(appKey, channelId, caid1, caid2,
                               oaid, assetFileName, oaidLibrary,
                               startupParams, installParams)
    monoReYunSdk:initReYunSDK(appKey, channelId, caid1, caid2,
            oaid, assetFileName, oaidLibrary, startupParams, installParams)
end

function ReYunSdk:setPrintLog(print)
    monoReYunSdk:setPrintLog(print);
end
function ReYunSdk:GetCustomData(Rid)
    local data={}
    data.Rid=Rid
    return Dll_JSON.encode(data)
end
-- 必接
function ReYunSdk:register(account, rid)
    print("ReYunSdk:register" .. account )
    monoReYunSdk:register(tostring(account), self:GetCustomData(rid));
end
-- 必接
function ReYunSdk:login(account, serverId, rid)
    print("ReYunSdk:login" .. account .. serverId)
    local data={}
    monoReYunSdk:login(tostring(account), tostring(serverId), self:GetCustomData(rid));
end
-- 必接
function ReYunSdk:setryzf(ryTID, ryzfType, hbType, hbAmount, rid)
    print("ReYunSdk:setryzf" .. ryTID .. ryzfType .. hbAmount)
    monoReYunSdk:setryzf(ryTID, ryzfType, hbType, hbAmount, self:GetCustomData(rid));
end

function ReYunSdk:setDD(ryTID, hbType, hbAmount, customParams)
    monoReYunSdk:setDD(ryTID, hbType, hbAmount, customParams);
end

function ReYunSdk:setEvent(eventName, customParams)
    monoReYunSdk:setEvent(eventName, customParams);
end

function ReYunSdk:setTrackViewDuration(pageID, duration, customParams)
    monoReYunSdk:setTrackViewDuration(pageID, duration, customParams);
end

function ReYunSdk:setTrackAdShow(adPlatform, adId, playSuccess,
                                 customParams)
    monoReYunSdk:setTrackAdShow(adPlatform, adId, playSuccess, customParams);
end
-- 必接？
function ReYunSdk:setTrackAdClick(adPlatform, adId, customParams)
    print("ReYunSdk:setTrackAdClick" .. adPlatform .. adId)
    monoReYunSdk:setTrackAdClick(adPlatform, adId, customParams);
end

function ReYunSdk:setTrackAppDuration(duration, customParams)
    monoReYunSdk:setTrackAppDuration(duration, customParams);
end

function ReYunSdk:getDeviceId()
    return monoReYunSdk:getDeviceId()
end

function ReYunSdk:setASAEnable(enable)
    monoReYunSdk:setASAEnable(enable);
end

function ReYunSdk:setMobDNAEnable(enable)
    monoReYunSdk:setMobDNAEnable(enable);
end

function ReYunSdk:setAttributionCalllbackDelegate(callback)
    monoReYunSdk:setAttributionCalllbackDelegate(callback);
end

function ReYunSdk:setDeferredDeeplinkCalllbackDelegate(callback)
    monoReYunSdk:setDeferredDeeplinkCalllbackDelegate(callback);
end

function ReYunSdk:TrackEventRevenue(eventName, venue, orderId)
    monoReYunSdk:trackEventRevenue(eventName, venue, orderId)
end






