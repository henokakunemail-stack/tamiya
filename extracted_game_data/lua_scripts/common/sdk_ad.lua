---@class SdkAd
SdkAd = class("SdkAd")

function SdkAd:Get()
    if self._instance == nil then
        self._instance = SdkAd()
    end
    return self._instance
end

function SdkAd:SetKey(key, value)
    value = value or 1
    PlayerPrefs.SetInt(key, value)
    PlayerPrefs.Save()
end

function SdkAd:IsHaveKey(key)
    return PlayerPrefs.GetInt(key, 0) == 1
end

function SdkAd:SdkAdjust_Login(uid)
    if SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_Login(uid)
    end
end

function SdkAd:SdkAdjust_CreateRole(roleName)
    if SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_CreateRole(roleName)
    end
end

function SdkAd:SdkAdjust_JoinClub(clubName)
    if SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_JoinClub(clubName)
    end
end

function SdkAd:SdkAdjust_CreateClub(clubName)
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_CreateClub(clubName)
    elseif SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_CreateClub(clubName)
    end
end

function SdkAd:SdkAdjust_Purchase(currencyType, price)
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_Purchase(currencyType, price)
    elseif SDKHelper:Get():ChickQuickSdk() then

    end
end

function SdkAd:SdkAdjust_PurchaseDetail(eventName, transactionId, price, currency)
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_PurchaseDetail(eventName, transactionId, price, currency)
    elseif SDKHelper:Get():ChickQuickSdk() then

    end
end

function SdkAd:SdkAdjust_ChallengeGame(eventName, gameId)
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_ChallengeGame(eventName, gameId)
    elseif SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_ChallengeGame(eventName, gameId)
    end
end

function SdkAd:SdkAdjust_CreateChallengeGame(gameId)
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_CreateChallengeGame(gameId)
    elseif SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_CreateChallengeGame(gameId)
    end
end

function SdkAd:SdkAdjust_JoinChallengeGame(gameId)
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_JoinChallengeGame(gameId)
    elseif SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_JoinChallengeGame(gameId)
    end
end

function SdkAd:SdkAdjust_RaceRank()
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_RaceRank()
    elseif SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_RaceRank()
    end
end

function SdkAd:SdkAdjust_Recruit(isTen)
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_Recruit(isTen)
    elseif SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_Recruit(isTen)
    end
end

---@param isDayFinish @当前任务是否完成
function SdkAd:SdkAdjust_Task(isDayFinish)
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_Task(isDayFinish)
    elseif SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_Task(isDayFinish)
    end
end

function SdkAd:SdkAdjust_Day2Login()
    if SDKHelper:Get():ChickGtaSdk() then
        GlobalAd:Get():GlobalAdjust_Day2Login()
    elseif SDKHelper:Get():ChickQuickSdk() then
        QuickAd:Get():QuickAdjust_Day2Login()
    end
end

function SdkAd:SdkAdjust_Prepay(goodsId)--请求订单
    if SDKHelper:Get():ChickGtaSdk() then
    elseif SDKHelper:Get():ChickQuickSdk() then
       -- QuickAd:Get():QuickAdjust_Prepay(goodsId)
    end
end

function SdkAd:SdkAdjust_PrepayFinished(orderId)--请求订单返回
    if SDKHelper:Get():ChickGtaSdk() then
    elseif SDKHelper:Get():ChickQuickSdk() then
       -- QuickAd:Get():QuickAdjust_PrepayFinished(orderId)
    end
end

function SdkAd:SdkAdjust_PayServerPre(goodsId)--请求发货
    if SDKHelper:Get():ChickGtaSdk() then
    elseif SDKHelper:Get():ChickQuickSdk() then
       -- QuickAd:Get():QuickAdjust_PayServerPre(goodsId)
    end
end

function SdkAd:SdkAdjust_PayServerBack(orderId)--发货返回
    if SDKHelper:Get():ChickGtaSdk() then
    elseif SDKHelper:Get():ChickQuickSdk() then
       -- QuickAd:Get():QuickAdjust_PayServerBack(orderId)
    end
end







































