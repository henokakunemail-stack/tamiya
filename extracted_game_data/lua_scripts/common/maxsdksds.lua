
---@class MaxSdkAds
MaxSdkAds = class("MaxSdkAds")

function MaxSdkAds:Get()
    if self._instance == nil then
        self._instance = MaxSdkAds()
    end
    return self._instance
end

function MaxSdkAds:ShowRewardedAd()
    --CS.MaxSdkManager:Get():ShowRewardedAd()
end

function MaxSdkAds:SetUserId(userid)
    --CS.MaxSdkManager:Get():SetUserId(userid)
end

function MaxSdkAds:SetMuted(isMuted)
   -- CS.MaxSdkManager:Get():SetMuted(isMuted)
end

function MaxSdkAds:ShowRewardedAdCustomData(adUnitIdentifier, placement, customData)
   -- CS.MaxSdkManager:Get():ShowRewardedAdCustomData(adUnitIdentifier, placement, customData)
end








