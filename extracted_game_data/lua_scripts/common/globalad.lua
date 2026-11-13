---@class GlobalAd
GlobalAd = class("GlobalAd")

function GlobalAd:Get()
    if self._instance == nil then
        self._instance = GlobalAd()
    end
    return self._instance
end

function GlobalAd:SetKey(key, value)
    value = value or 1
    PlayerPrefs.SetInt(key, value)
    PlayerPrefs.Save()
end

function GlobalAd:IsHaveKey(key)
    return PlayerPrefs.GetInt(key, 0) == 1
end

function GlobalAd:GlobalAdjust_Login()
    --monoGlobalAd:GlobalAdjust_Login(GlobalAd_EventKey.Ad_Login)
end

function GlobalAd:GlobalAdjust_CreateRole(roleName)
    if not self:IsHaveKey(GlobalAd_EventKey.Ad_Complete_Registration) then
        --monoGlobalAd:GlobalAdjust_CreateRole(GlobalAd_EventKey.Ad_Complete_Registration, roleName)
        self:SetKey(GlobalAd_EventKey.Ad_Complete_Registration, 1)
    end
end

function GlobalAd:GlobalAdjust_JoinClub(clubName)
    if not self:IsHaveKey(GlobalAd_EventKey.Ad_Join_Club) then
        --monoGlobalAd:GlobalAdjust_JoinClub(GlobalAd_EventKey.Ad_Join_Club, clubName)
        self:SetKey(GlobalAd_EventKey.Ad_Join_Club, 1)
    end
end

function GlobalAd:GlobalAdjust_CreateClub(clubName)
    if not self:IsHaveKey(GlobalAd_EventKey.Ad_Sign_Up_Club) then
        --monoGlobalAd:GlobalAdjust_CreateClub(GlobalAd_EventKey.Ad_Sign_Up_Club, clubName)
        self:SetKey(GlobalAd_EventKey.Ad_Sign_Up_Club, 1)
    end
end

function GlobalAd:GlobalAdjust_Purchase(currencyType, price)
    if not self:IsHaveKey(GlobalAd_EventKey.Ad_First_Purchase) then
        --monoGlobalAd:GlobalAdjust_Purchase(GlobalAd_EventKey.Ad_First_Purchase, tostring(currencyType), tostring(price))
        self:SetKey(GlobalAd_EventKey.Ad_First_Purchase, 1)
    end

    --monoGlobalAd:GlobalAdjust_Purchase(GlobalAd_EventKey.Ad_In_App_Purchase, tostring(currencyType), tostring(price))
end
function GlobalAd:GlobalAdjust_PurchaseDetail(eventName, transactionId, price, currency)
    --monoGlobalAd:GlobalAdjust_PurchaseDetail(eventName, transactionId, price, currency)
end

function GlobalAd:GlobalAdjust_ChallengeGame(eventName, gameId)
    if not self:IsHaveKey(eventName) then
        --monoGlobalAd:GlobalAdjust_ChallengeGame(eventName, tostring(gameId))
        self:SetKey(eventName, 1)
    end
end

function GlobalAd:GlobalAdjust_CreateChallengeGame(gameId)
    self:GlobalAdjust_ChallengeGame(GlobalAd_EventKey.Ad_Create_Game, gameId)
end

function GlobalAd:GlobalAdjust_JoinChallengeGame(gameId)
    self:GlobalAdjust_ChallengeGame(GlobalAd_EventKey.Ad_Join_Game, gameId)
end

function GlobalAd:GlobalAdjust_RaceRank()
    self:SetKey(GlobalAd_PrefKey.Ad_Rank_Count_Pref, PlayerPrefs.GetInt(GlobalAd_PrefKey.Ad_Rank_Count_Pref, 0) + 1)

    if not self:IsHaveKey(GlobalAd_EventKey.Ad_First_Rank_Game) then
        --monoGlobalAd:GlobalAdjust_RaceRank(GlobalAd_EventKey.Ad_First_Rank_Game)
        self:SetKey(GlobalAd_EventKey.Ad_First_Rank_Game, 1)
    end

    if PlayerPrefs.GetInt(GlobalAd_PrefKey.Ad_Rank_Count_Pref, 0) == 5 then
        --monoGlobalAd:GlobalAdjust_RaceRank(GlobalAd_EventKey.Ad_First_Rank_Game5)
    end

    if PlayerPrefs.GetInt(GlobalAd_PrefKey.Ad_Rank_Count_Pref, 0) == 10 then
        --monoGlobalAd:GlobalAdjust_RaceRank(GlobalAd_EventKey.Ad_First_Rank_Game10)
    end

    --monoGlobalAd:GlobalAdjust_RaceRank(GlobalAd_EventKey.Ad_Play_Rank)
end

function GlobalAd:GlobalAdjust_Recruit(isTen)
    if not self:IsHaveKey(GlobalAd_EventKey.Ad_First_Draw) then
        --monoGlobalAd:GlobalAdjust_Recruit(GlobalAd_EventKey.Ad_First_Draw)
        self:SetKey(GlobalAd_EventKey.Ad_First_Draw, 1)
    end

    if isTen and not self:IsHaveKey(GlobalAd_EventKey.Ad_First_Ten_Draw) then
        --monoGlobalAd:GlobalAdjust_Recruit(GlobalAd_EventKey.Ad_First_Ten_Draw)
        self:SetKey(GlobalAd_EventKey.Ad_First_Ten_Draw, 1)
    end

    --monoGlobalAd:GlobalAdjust_Recruit(GlobalAd_EventKey.Ad_Draw)
end

---@param isDayFinish @当前任务是否完成
function GlobalAd:GlobalAdjust_Task(isDayFinish)
    if not self:IsHaveKey(GlobalAd_EventKey.Ad_Finish_First_Task) then
        --monoGlobalAd:GlobalAdjust_Task(GlobalAd_EventKey.Ad_Finish_First_Task)
        self:SetKey(GlobalAd_EventKey.Ad_Finish_First_Task, 1)
    end

    if isDayFinish and not self:IsHaveKey(GlobalAd_EventKey.Ad_Finish_Daily_Task) then
        --monoGlobalAd:GlobalAdjust_Task(GlobalAd_EventKey.Ad_Finish_Daily_Task)
        self:SetKey(GlobalAd_EventKey.Ad_Finish_Daily_Task, 1)
    end
end

function GlobalAd:GlobalAdjust_Day2Login()
    if not self:IsHaveKey(GlobalAd_EventKey.Ad_Day2retention) then
        --monoGlobalAd:GlobalAdjust_Day2Login(GlobalAd_EventKey.Ad_Day2retention)

        self:SetKey(GlobalAd_EventKey.Ad_Day2retention, 1)
    end
end



































