---@class QuickAd
QuickAd = class("QuickAd")

function QuickAd:Get()
    if self._instance == nil then
        self._instance = QuickAd()
    end
    return self._instance
end

function QuickAd:SetKey(key, value)
    value = value or 1
    PlayerPrefs.SetInt(key, value)
    PlayerPrefs.Save()
end

function QuickAd:IsHaveKey(key)
    return PlayerPrefs.GetInt(key, 0) == 1
end

function QuickAd:QuickAdjust_Login(uid)
    --monoQuickAd:QuickAdjust_Login(QuickAd_EventKey.Ad_Login, uid)
end

function QuickAd:QuickAdjust_CreateRole(roleName)
    --if not self:IsHaveKey(QuickAd_EventKey.Ad_Complete_Registration) then
    --    monoQuickAd:QuickAdjust_CreateRole(QuickAd_EventKey.Ad_Complete_Registration, roleName)
    --    self:SetKey(QuickAd_EventKey.Ad_Complete_Registration, 1)
    --end
end

function QuickAd:QuickAdjust_JoinClub(clubName)
    --if not self:IsHaveKey(QuickAd_EventKey.Ad_Join_Club) then
    --    monoQuickAd:QuickAdjust_JoinClub(QuickAd_EventKey.Ad_Join_Club, clubName)
    --    self:SetKey(QuickAd_EventKey.Ad_Join_Club, 1)
    --end
end

function QuickAd:QuickAdjust_CreateClub(clubName)
    --if not self:IsHaveKey(QuickAd_EventKey.Ad_Sign_Up_Club) then
    --    monoQuickAd:QuickAdjust_CreateClub(QuickAd_EventKey.Ad_Sign_Up_Club, clubName)
    --    self:SetKey(QuickAd_EventKey.Ad_Sign_Up_Club, 1)
    --end
end

function QuickAd:QuickAdjust_Purchase(currencyType, price)
    --if not self:IsHaveKey(QuickAd_EventKey.Ad_First_Purchase) then
    --    monoQuickAd:QuickAdjust_Purchase(QuickAd_EventKey.Ad_First_Purchase, to(currencyType), to(price))
    --    self:SetKey(QuickAd_EventKey.Ad_First_Purchase, 1)
    --end

    --monoQuickAd:QuickAdjust_Purchase(QuickAd_EventKey.Ad_In_App_Purchase, to(currencyType), to(price))
end
function QuickAd:QuickAdjust_PurchaseDetail(eventName, transactionId, price, currency)
    --monoQuickAd:QuickAdjust_PurchaseDetail(eventName, transactionId, price, currency)
end

function QuickAd:QuickAdjust_ChallengeGame(eventName, gameId)
    --if not self:IsHaveKey(eventName) then
    --    monoQuickAd:QuickAdjust_ChallengeGame(eventName, tostring(gameId))
    --    self:SetKey(eventName, 1)
    --end
end

function QuickAd:QuickAdjust_CreateChallengeGame(gameId)
    --self:QuickAdjust_ChallengeGame(QuickAd_EventKey.Ad_Create_Game, gameId)
end

function QuickAd:QuickAdjust_JoinChallengeGame(gameId)
    --self:QuickAdjust_ChallengeGame(QuickAd_EventKey.Ad_Join_Game, gameId)
end

function QuickAd:QuickAdjust_RaceRank()
    --self:SetKey(QuickAd_PrefKey.Ad_Rank_Count_Pref, PlayerPrefs.GetInt(QuickAd_PrefKey.Ad_Rank_Count_Pref, 0) + 1)
    --
    --if not self:IsHaveKey(QuickAd_EventKey.Ad_First_Rank_Game) then
    --    monoQuickAd:QuickAdjust_RaceRank(QuickAd_EventKey.Ad_First_Rank_Game)
    --    self:SetKey(QuickAd_EventKey.Ad_First_Rank_Game, 1)
    --end
    --
    --if PlayerPrefs.GetInt(QuickAd_PrefKey.Ad_Rank_Count_Pref, 0) == 5 then
    --    monoQuickAd:QuickAdjust_RaceRank(QuickAd_EventKey.Ad_First_Rank_Game5)
    --end
    --
    --if PlayerPrefs.GetInt(QuickAd_PrefKey.Ad_Rank_Count_Pref, 0) == 10 then
    --    monoQuickAd:QuickAdjust_RaceRank(QuickAd_EventKey.Ad_First_Rank_Game10)
    --end
    --
    --monoQuickAd:QuickAdjust_RaceRank(QuickAd_EventKey.Ad_Play_Rank)
end

function QuickAd:QuickAdjust_Recruit(isTen)
    --if not self:IsHaveKey(QuickAd_EventKey.Ad_First_Draw) then
    --    monoQuickAd:QuickAdjust_Recruit(QuickAd_EventKey.Ad_First_Draw)
    --    self:SetKey(QuickAd_EventKey.Ad_First_Draw, 1)
    --end
    --
    --if isTen and not self:IsHaveKey(QuickAd_EventKey.Ad_First_Ten_Draw) then
    --    monoQuickAd:QuickAdjust_Recruit(QuickAd_EventKey.Ad_First_Ten_Draw)
    --    self:SetKey(QuickAd_EventKey.Ad_First_Ten_Draw, 1)
    --end
    --
    --monoQuickAd:QuickAdjust_Recruit(QuickAd_EventKey.Ad_Draw)
end

---@param isDayFinish @当前任务是否完成
function QuickAd:QuickAdjust_Task(isDayFinish)
    --if not self:IsHaveKey(QuickAd_EventKey.Ad_Finish_First_Task) then
    --    monoQuickAd:QuickAdjust_Task(QuickAd_EventKey.Ad_Finish_First_Task)
    --    self:SetKey(QuickAd_EventKey.Ad_Finish_First_Task, 1)
    --end
    --
    --if isDayFinish and not self:IsHaveKey(QuickAd_EventKey.Ad_Finish_Daily_Task) then
    --    monoQuickAd:QuickAdjust_Task(QuickAd_EventKey.Ad_Finish_Daily_Task)
    --    self:SetKey(QuickAd_EventKey.Ad_Finish_Daily_Task, 1)
    --end
end

function QuickAd:QuickAdjust_Day2Login()
    --if not self:IsHaveKey(QuickAd_EventKey.Ad_Day2retention) then
    --    monoQuickAd:QuickAdjust_Day2Login(QuickAd_EventKey.Ad_Day2retention)
    --
    --    self:SetKey(QuickAd_EventKey.Ad_Day2retention, 1)
    --end
end

function QuickAd:QuickAdjust_Prepay(goodsId)
   -- monoQuickAd:QuickAdjust_Prepay(QuickAd_EventKey.Ad_Prepay,goodsId)
end

function QuickAd:QuickAdjust_PrepayFinished(orderId)
   -- monoQuickAd:QuickAdjust_PrepayFinished(QuickAd_EventKey.Ad_PrepayFinished,orderId)

end

function QuickAd:QuickAdjust_PayServerPre(goodsId)
   -- monoQuickAd:QuickAdjust_PayServerPre(QuickAd_EventKey.Ad_PayServerPre,goodsId)
end

function QuickAd:QuickAdjust_PayServerBack(orderId)
   -- monoQuickAd:QuickAdjust_PayServerBack(QuickAd_EventKey.Ad_PayServerBack,orderId)
end



























