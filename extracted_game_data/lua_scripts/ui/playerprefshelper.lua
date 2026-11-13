---@class PlayerPrefsHelper
PlayerPrefsHelper = class("PlayerPrefsHelper")

function PlayerPrefsHelper:PlayerFlag()
    local flag = ""
    if PlayerDataManager then
        flag = PlayerDataManager:Get():GetPlayerRID() .. "_"
    end
    return flag
end
function PlayerPrefsHelper:TimeFlagDay()
    return CommonHelper:GetNowTime().Day
end
function PlayerPrefsHelper:SetInt(key,value)
    PlayerPrefs.SetInt(key, value)
    PlayerPrefs.Save()
end
function PlayerPrefsHelper:SetFloat(key,value)
    PlayerPrefs.SetFloat(key, value)
    PlayerPrefs.Save()
end
function PlayerPrefsHelper:SetString(key,value)
    PlayerPrefs.SetString(key, value)
    PlayerPrefs.Save()
end



--{{{key值
function PlayerPrefsHelper:Key_RaceRoomAutoReady()
    return self:PlayerFlag() .. "RaceRoomAutoReady"
end
function PlayerPrefsHelper:Key_RaceTopUpShow()
    return self:PlayerFlag() .. "RaceTopUpShow_%d_%d"
end
function PlayerPrefsHelper:Key_RaceTopUp2Show()
    return self:PlayerFlag() .. "RaceTopUpShow_%d_%d"
end
function PlayerPrefsHelper:Key_LoginVideo()
    return "video_login"
end
function PlayerPrefsHelper:Key_GuideBattleSpeed()
    return "GuideBattleSpeed"
end

function PlayerPrefsHelper:Key_LoginVideoSecond()
    return "video_login2"
end
function PlayerPrefsHelper:Key_Story(id)
    return self:PlayerFlag() .. "chapter_" .. id
end
function PlayerPrefsHelper:Key_Comic(id)
    return self:PlayerFlag() .. "comic_" .. id
end
function PlayerPrefsHelper:Key_Bag(id)
    return self:PlayerFlag() .. "bag_" .. id
end
function PlayerPrefsHelper:Key_Shop(id)
    return self:PlayerFlag() .. "shop_" .. id
end
function PlayerPrefsHelper:Key_LastLoginPlayerId()
    return "LastLoginPlayerId"
end
function PlayerPrefsHelper:Key_ActProclamationPop()
    return "ActProclamationPop"
end
function PlayerPrefsHelper:Key_AnnouncementPop()
    return "AnnouncementPop"
end
function PlayerPrefsHelper:Key_PveChapterRally()
    return self:PlayerFlag() .. "PveChapterRally"
end
function PlayerPrefsHelper:Key_PveChapterLevelRally()
    return self:PlayerFlag() .. "PveChapterLevelRally"
end
function PlayerPrefsHelper:Key_RaceSeniorTrainRally()
    return self:PlayerFlag() .. "RaceSeniorTrainRally"
end
function PlayerPrefsHelper:Key_RaceSeniorTrainLevelRally()
    return self:PlayerFlag() .. "RaceSeniorTrainRallyLevel"
end
function PlayerPrefsHelper:Key_PveChapterSelectTeam()
    return self:PlayerFlag() .. "PveChapterSelectTeam"
end
function PlayerPrefsHelper:Key_SystemPush()
    return "SystemPush"
end
function PlayerPrefsHelper:Key_PlayVideo(videoName)
    return self:PlayerFlag() .."PlayVideo"..videoName
end
function PlayerPrefsHelper:Key_LoginUrl()
    return "LoginUrl"
end
function PlayerPrefsHelper:Key_BgmOffOrOn()
    return "BgmOffOrOn"
end
function PlayerPrefsHelper:Key_SoundEffectOffOrOn()
    return "SoundEffectOffOrOn"
end
function PlayerPrefsHelper:Key_BgmValue()
    return "BgmValue"
end
function PlayerPrefsHelper:Key_SoundEffectValue()
    return "SoundEffectValue"
end
function PlayerPrefsHelper:Key_PowerSaving()
    return "PowerSaving"
end
function PlayerPrefsHelper:Key_PictureQuality()
    return "PictureQuality"
end
function PlayerPrefsHelper:Key_IsPostEnable()
    return "IsPostEnable"
end
function PlayerPrefsHelper:Key_LoginName()
    return "LoginName"
end
function PlayerPrefsHelper:Key_LoginPassword()
    return "LoginPassword"
end
function PlayerPrefsHelper:Key_LoginServerId()
    return "LoginServerId"
end
function PlayerPrefsHelper:Key_IsDebug()
    return "DebugView"
end
function PlayerPrefsHelper:Key_VerifyCarTips()
    return "Key_VerifyCarTips"
end

function PlayerPrefsHelper:Key_CameraType()
    return self:PlayerFlag() .."CameraType"
end
function PlayerPrefsHelper:Key_PointIndex(cameraType)
    return self:PlayerFlag() .."PointIndex_"..cameraType
end
function PlayerPrefsHelper:Key_ArticleFilterTogWhite()
    return "ArticleFilterTog_Q_W"
end
function PlayerPrefsHelper:Key_ArticleFilterTogGreen()
    return "ArticleFilterTog_Q_G"
end
function PlayerPrefsHelper:Key_ArticleFilterTogBlue()
    return "ArticleFilterTog_Q_B"
end
function PlayerPrefsHelper:Key_ArticleFilterTogPurple()
    return "ArticleFilterTog_Q_P"
end
function PlayerPrefsHelper:Key_ArticleFilterTogOrange()
    return "ArticleFilterTog_Q_O"
end
function PlayerPrefsHelper:Key_ArticleFilterTogRed()
    return "ArticleFilterTog_Q_R"
end
function PlayerPrefsHelper:Key_ArticleFilterStar1()
    return "ArticleFilterTog_Star1"
end
function PlayerPrefsHelper:Key_ArticleFilterStar2()
    return "ArticleFilterTog_Star2"
end
function PlayerPrefsHelper:Key_ArticleFilterStar3()
    return "ArticleFilterTog_Star3"
end
function PlayerPrefsHelper:Key_ArticleFilterStar4()
    return "ArticleFilterTog_Star4"
end
function PlayerPrefsHelper:Key_ArticleFilterStar5()
    return "ArticleFilterTog_Star5"
end
function PlayerPrefsHelper:Key_ArticleFilterTogLevelLow()
    return "ArticleFilterTog_LevelLow"
end
function PlayerPrefsHelper:Key_ArticleFilterTogLevelMiddle()
    return "ArticleFilterTog_LevelMiddle"
end
function PlayerPrefsHelper:Key_ArticleFilterTogLevelHigh()
    return "ArticleFilterTog_LevelHigh"
end
function PlayerPrefsHelper:Key_ArticleFilterTogReformYes()
    return "ArticleFilterTog_Reform_y"
end
function PlayerPrefsHelper:Key_ArticleFilterTogReformNo()
    return "ArticleFilterTog_Reform_N "
end

function PlayerPrefsHelper:Key_MainMenuViewCarIndex()
    return self:PlayerFlag() .. "MainMenuViewCarIndex "
end
function PlayerPrefsHelper:Key_SelfCountDownBtnUpTime()
    return "SelfCountDownBtnUpTime"
end
function PlayerPrefsHelper:Key_ReplayInputInfos()
    return "ReplayInputInfos"
end

function PlayerPrefsHelper:Key_GlobalLoginType()
    return "Global_LoginType"
end
function PlayerPrefsHelper:Key_PlayerBattleError()
    return self:PlayerFlag().."PlayerBattleError"
end
function PlayerPrefsHelper:Key_MainMenuTaskId()
    return self:PlayerFlag().."MainMenuTaskId"
end
function PlayerPrefsHelper:Key_RaceRankRaceType()
    return self:PlayerFlag().."RaceRankRaceType"
end
function PlayerPrefsHelper:Key_RaceRankIndexType(raceType)
    return self:PlayerFlag().."RaceRankIndexType_"..raceType
end

function PlayerPrefsHelper:Key_CarVerifyHistory(idx)
    return self:PlayerFlag().."_"..idx.."_CarVerifyHistory"
end

function PlayerPrefsHelper:Key_FirstBuy()
    return "FirstBuy"
end

function PlayerPrefsHelper:Key_BattleDoubleSpeed()
    return "BattleDoubleSpeed"
end


function PlayerPrefsHelper:Key_SpecialTrainLevel()
    return self:PlayerFlag().."SpecialTrainLevel"
end
function PlayerPrefsHelper:Key_SpecialTrainType()
    return self:PlayerFlag().."SpecialTrainType"
end
function PlayerPrefsHelper:Key_SelfChapterId()
    return self:PlayerFlag().."SelfChapterId"
end

function PlayerPrefsHelper:Key_JCPFlag()
    return self:PlayerFlag() .. "JCP_"
end
function PlayerPrefsHelper:Key_LoginTimeFlag()
    return self:PlayerFlag() .. "LoginTime"
end
function PlayerPrefsHelper:Key_BattleBgmOffOrOn()
    return self:PlayerFlag() .. "BattleBgmOffOrOn"
end
function PlayerPrefsHelper:Key_BattleBgmValue()
    return self:PlayerFlag() .. "BattleBgmValue"
end


function PlayerPrefsHelper:Key_ArUserAgreement()
    return self:PlayerFlag() .. "ArUserAgreement"
end
function PlayerPrefsHelper:Key_RecruitSubType()
    return self:PlayerFlag() .. "RecruitSubType"
end
function PlayerPrefsHelper:Key_MeshCache()
    return "MeshCache"
end

function PlayerPrefsHelper:Key_GameTrackCheck()
    return self:PlayerFlag() .. "GameTrackCheck"
end
function PlayerPrefsHelper:Key_GameBrakeSetting()
    return self:PlayerFlag() .. "GameBrakeSetting"
end

function PlayerPrefsHelper:Key_CarGrooveIdShow(id)
    return "CarGrooveIdShow_"..id
end

function PlayerPrefsHelper:Key_LanguageType()
    return "LanguageType"
end

function PlayerPrefsHelper:Key_GoogleCharge()
    return self:PlayerFlag() .. "GoogleCharge"
end
function PlayerPrefsHelper:Key_Mini4wdRuleView(type)
    return self:PlayerFlag() .. "Key_Mini4wdRuleView"..type
end

function PlayerPrefsHelper:Key_PopUpGiftFlag()
    return self:PlayerFlag() .. "PopUpGift"
end
function PlayerPrefsHelper:Key_RaceCarGodIndex()
    return self:PlayerFlag() .. "RaceCarGodIndex"
end
function PlayerPrefsHelper:Key_RaceCarGodMoudle()
    return self:PlayerFlag() .. "RaceCarGodMoudle"
end
function PlayerPrefsHelper:Key_RaceRankSelectPosition()
    return self:PlayerFlag() .. "RaceRankSelectPosition"
end
function PlayerPrefsHelper:Key_RaceTestSelectPosition(type)
    return self:PlayerFlag() .. "RaceTestSelectPosition_"..type
end
function PlayerPrefsHelper:Key_RecruitAnimSkip()
    return self:PlayerFlag() .. "Key_RecruitAnimSkip"
end

function PlayerPrefsHelper:Key_CarAttrRecommendVersion()
    return "CarAttrRecommendVersion"
end

--{{{主界面车
function PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(value)
    if value < 1 then
        value = 1
    end
    if value > 5 then
        value = 5
    end
    self:SetInt(self:Key_MainMenuViewCarIndex(), value)
end

function PlayerPrefsHelper:GetValue_MainMenuViewCarIndex()
    local value = PlayerPrefs.GetInt(self:Key_MainMenuViewCarIndex(), 1)
    if CarDataManager:Get():GetCarDataByIndex(value) and  CarDataManager:Get():GetCarDataByIndex(value).LockState~=ParkingLotState.Open then value=1 PlayerPrefsHelper:SetValue_MainMenuViewCarIndex(1) end
    return value
end
--}}}
--}}}

--{{{房间赛自动准备
function PlayerPrefsHelper:SetValue_RaceRoomAutoReady(value)
    local value = value and 1 or 0
    self:SetInt(self:Key_RaceRoomAutoReady(), value)
end

function PlayerPrefsHelper:GetValue_RaceRoomAutoReady()
    local value = PlayerPrefs.GetInt(self:Key_RaceRoomAutoReady(), 0)
    return value == 1
end
--}}}
--{{{巅峰赛展示晋级
function PlayerPrefsHelper:SetValue_RaceTopUpShow(value)
    local value = value and 1 or 0
    self:SetInt(string.format(self:Key_RaceTopUpShow(),RaceTopManager:Get():GetSeasonId(),RaceTopManager:Get():GetStates()), value)
end

function PlayerPrefsHelper:GetValue_RaceTopUpShow()
    local value = PlayerPrefs.GetInt(string.format(self:Key_RaceTopUpShow(),RaceTopManager:Get():GetSeasonId(),RaceTopManager:Get():GetStates()), 0)
    return value == 1
end
--}}}

--{{{巅峰赛展示晋级
function PlayerPrefsHelper:SetValue_RaceTopSuperUpShow(value)
    local value = value and 1 or 0
    self:SetInt(string.format(self:Key_RaceTopUp2Show(), RaceTopSuperManager:Get():GetSeasonId(), RaceTopSuperManager:Get():GetStates()), value)
end

function PlayerPrefsHelper:GetValue_RaceTopSuperUpShow()
    local value = PlayerPrefs.GetInt(string.format(self:Key_RaceTopUp2Show(), RaceTopSuperManager:Get():GetSeasonId(), RaceTopSuperManager:Get():GetStates()), 0)
    return value == 1
end
--}}}


--{{{登录视频第一个
function PlayerPrefsHelper:SetValue_LoginVideo(value)
    local value = value and 1 or 0
    self:SetInt(self:Key_LoginVideo(), value)
end

function PlayerPrefsHelper:GetValue_LoginVideo()
    local value = PlayerPrefs.GetInt(self:Key_LoginVideo(), 0)
    return value == 1
end
--}}}


--{{{登录视频第二个
function PlayerPrefsHelper:SetValue_LoginVideoSecond(value)
    local value = value and 1 or 0
    self:SetInt(self:Key_LoginVideoSecond(), value)
end

function PlayerPrefsHelper:GetValue_LoginVideoSecond()
    local value = PlayerPrefs.GetInt(self:Key_LoginVideoSecond(), 0)
    return value == 1
end
--}}}


--{{{剧情
function PlayerPrefsHelper:SetValue_Story(id, value)
    self:SetInt(self:Key_Story(id), value)
end

function PlayerPrefsHelper:GetValue_Story(id)
    local value = PlayerPrefs.GetInt(self:Key_Story(id), 0)
    return value
end
--}}}
--{{{活动剧情
function PlayerPrefsHelper:SetValue_Comic(id, value)
    self:SetInt(self:Key_Comic(id), value)
end

function PlayerPrefsHelper:GetValue_Comic(id)
    local value = PlayerPrefs.GetInt(self:Key_Comic(id), 0)
    return value==1
end
--}}}


--{{{商店
function PlayerPrefsHelper:SetValue_Shop(id, value)
    self:SetString(self:Key_Shop(id), value)
end

function PlayerPrefsHelper:GetValue_Shop(id)
    local value = PlayerPrefs.GetString(self:Key_Shop(id), "")
    return value
end
--}
--{{{背包
function PlayerPrefsHelper:SetValue_Bag(id, value)
    self:SetInt(self:Key_Bag(id), value)
end

function PlayerPrefsHelper:GetValue_Bag(id)
    local value = PlayerPrefs.GetInt(self:Key_Bag(id), 0)
    return value
end
--}
--{{{上次登录玩家
function PlayerPrefsHelper:SetValue_PlayerId()
    self:SetInt(self:Key_LastLoginPlayerId(), PlayerDataManager:Get():GetPlayerUID())
end

function PlayerPrefsHelper:GetValue_LastLoginPlayer()
    local value = PlayerPrefs.GetInt(self:Key_LastLoginPlayerId(), 0)
    return value
end
--}}}
--{{{公告面板主动弹出
function PlayerPrefsHelper:SetValue_AnnouncementPop(value)
    self:SetInt(self:Key_AnnouncementPop(), value)
end

function PlayerPrefsHelper:GetValue_AnnouncementPop()
    local value = PlayerPrefs.GetInt(self:Key_AnnouncementPop(), 0)
    return value == 1
end

--}}}

--{{{公告面板主动弹出2
function PlayerPrefsHelper:SetValue_ActProclamationPop(value)
    self:SetInt(self:Key_ActProclamationPop(), value)
end

function PlayerPrefsHelper:GetValue_ActProclamationPop()
    local value = PlayerPrefs.GetInt(self:Key_ActProclamationPop(), 0)
    return value == 1
end
--}}}

--{{{剧情进行中
function PlayerPrefsHelper:SetValue_PveChapterRally(value)
    self:SetInt(self:Key_PveChapterRally(), value)
end

function PlayerPrefsHelper:GetValue_PveChapterRally()
    local value = PlayerPrefs.GetInt(self:Key_PveChapterRally(), 0)
    return value
end
--}}}

--{{{剧情关卡进行中
function PlayerPrefsHelper:SetValue_PveChapterLevelRally(value)
    self:SetInt(self:Key_PveChapterLevelRally(), value)
end

function PlayerPrefsHelper:GetValue_PveChapterLevelRally()
    local value = PlayerPrefs.GetInt(self:Key_PveChapterLevelRally(), 0)
    return value
end
--}}}
--{{{难点挑战进行中
function PlayerPrefsHelper:SetValue_RaceSeniorTrainRally(value)
    self:SetInt(self:Key_RaceSeniorTrainRally(), value)
end

function PlayerPrefsHelper:GetValue_RaceSeniorTrainRally()
    local value = PlayerPrefs.GetInt(self:Key_RaceSeniorTrainRally(), 0)
    return value
end
--}}}
--{{{难点挑战关卡进行中
function PlayerPrefsHelper:SetValue_RaceSeniorTrainLevelRally(value)
    self:SetInt(self:Key_RaceSeniorTrainLevelRally(), value)
end

function PlayerPrefsHelper:GetValue_RaceSeniorTrainLevelRally()
    local value = PlayerPrefs.GetInt(self:Key_RaceSeniorTrainLevelRally(), 0)
    return value
end
--}}}
--{{{剧情选车
function PlayerPrefsHelper:SetValue_PveChapterSelectTeam(value)
    self:SetInt(self:Key_PveChapterSelectTeam(), value)
end

function PlayerPrefsHelper:GetValue_PveChapterSelectTeam()
    local value = PlayerPrefs.GetInt(self:Key_PveChapterSelectTeam(), 1)
    return value
end
--}}}
--{{{登录url
function PlayerPrefsHelper:SetValue_LoginUrl(value)
    self:SetString(self:Key_LoginUrl(), value)
end

function PlayerPrefsHelper:GetValue_LoginUrl()
    local value = PlayerPrefs.GetString(self:Key_LoginUrl(), "")
    return value
end
--}}}

--{{{系统推送
function PlayerPrefsHelper:SetValue_SystemPush(value)
    self:SetInt(self:Key_SystemPush(), value)
end

function PlayerPrefsHelper:GetValue_SystemPush()
    local value = PlayerPrefs.GetInt(self:Key_SystemPush(), 1)
    return value
end
--}}}
--{{{省电模式
function PlayerPrefsHelper:SetValue_PowerSaving(value)
    self:SetInt(self:Key_PowerSaving(), value)
end

function PlayerPrefsHelper:GetValue_PowerSaving()
    local value = PlayerPrefs.GetInt(self:Key_PowerSaving(), -1)
    return value
end
--}}}
--{{{后期
function PlayerPrefsHelper:SetValue_IsPostEnable(value)
    self:SetInt(self:Key_IsPostEnable(), value)
end

function PlayerPrefsHelper:GetValue_IsPostEnable()
    local value = PlayerPrefs.GetInt(self:Key_IsPostEnable(), 1)
    return value
end
--}}}
--{{{画质
function PlayerPrefsHelper:SetValue_PictureQuality(value)
    self:SetInt(self:Key_PictureQuality(), value)
end

function PlayerPrefsHelper:GetValue_PictureQuality()
    local value = PlayerPrefs.GetInt(self:Key_PictureQuality(), 1)
    return value
end
--}}}
--{{{音量开关
function PlayerPrefsHelper:SetValue_BgmOffOrOn(value)
    self:SetFloat(self:Key_BgmOffOrOn(), value)
end

function PlayerPrefsHelper:GetValue_BgmOffOrOn()
    local value = PlayerPrefs.GetFloat(self:Key_BgmOffOrOn(), 1)
    return value
end
--}}}
--{{{音量开关
function PlayerPrefsHelper:SetValue_GuideBattleSpeed(value)
    self:SetFloat(self:Key_GuideBattleSpeed(), value)
end

function PlayerPrefsHelper:GetValue_GuideBattleSpeed()
    local value = PlayerPrefs.GetFloat(self:Key_GuideBattleSpeed(), 1)
    return value
end
--}}}
--{{{音效开关
function PlayerPrefsHelper:SetValue_SoundEffectOffOrOn(value)
    self:SetFloat(self:Key_SoundEffectOffOrOn(), value)
end

function PlayerPrefsHelper:GetValue_SoundEffectOffOrOn()
    local value = PlayerPrefs.GetFloat(self:Key_SoundEffectOffOrOn(), 1)
    return value
end
--}}}
--{{{音量
function PlayerPrefsHelper:SetValue_BgmValue(value)
    self:SetFloat(self:Key_BgmValue(), value)
end

function PlayerPrefsHelper:GetValue_BgmValue()
    local value = PlayerPrefs.GetFloat(self:Key_BgmValue(), 1)
    return value
end
--}}}
--{{{音效
function PlayerPrefsHelper:SetValue_SoundEffectValue(value)
    self:SetFloat(self:Key_SoundEffectValue(), value)
end

function PlayerPrefsHelper:GetValue_SoundEffectValue()
    local value = PlayerPrefs.GetFloat(self:Key_SoundEffectValue(), 1)
    return value
end
--}}}
--{{{用户名
function PlayerPrefsHelper:SetValue_LoginName(value)
    self:SetString(self:Key_LoginName(), value)
end

function PlayerPrefsHelper:GetValue_LoginName()
    local value = PlayerPrefs.GetString(self:Key_LoginName(), "")
    return value
end
--}}}

--{{{用户名
function PlayerPrefsHelper:SetValue_LoginPassword(value)
    self:SetString(self:Key_LoginPassword(), value)
end

function PlayerPrefsHelper:GetValue_LoginPassword()
    local value = PlayerPrefs.GetString(self:Key_LoginPassword(), "")
    return value
end
--}}}
--{{{服务器Id
function PlayerPrefsHelper:SetValue_LoginServerId(value)
    self:SetString(self:Key_LoginServerId(), value)
end

function PlayerPrefsHelper:GetValue_LoginServerId()
    local serverInfo = ClientDataManager:Get():GetRecommendServer()
    local value = PlayerPrefs.GetString(self:Key_LoginServerId(), tostring(serverInfo == nil and "-1" or serverInfo:GetServerId()))
    return value
end
--}}}
--{{{Debug模式
function PlayerPrefsHelper:SetValue_IsDebug(value)
    self:SetString(self:Key_IsDebug(), value)
end

function PlayerPrefsHelper:GetValue_IsDebug()
    local value = PlayerPrefs.GetString(self:Key_IsDebug(), "false")
    return value
end
--}}}
--{{{Debug模式
function PlayerPrefsHelper:SetValue_VerifyCarTips(value)
    self:SetInt(self:Key_VerifyCarTips(), value)
end

function PlayerPrefsHelper:GetValue_VerifyCarTips()
    local value = PlayerPrefs.GetInt(self:Key_VerifyCarTips(), 0)
    return value
end
--}}}
--{{{战斗镜头
function PlayerPrefsHelper:SetValue_CameraType(value)
    self:SetInt(self:Key_CameraType(), value)
end

function PlayerPrefsHelper:GetValue_CameraType()
    local value = PlayerPrefs.GetInt(self:Key_CameraType(), 1)
    return value
end
--}}}
--{{{战斗镜头
function PlayerPrefsHelper:SetValue_PointIndex(cameraType,value)
    self:SetInt(self:Key_PointIndex(cameraType), value)
end

function PlayerPrefsHelper:GetValue_PointIndex(cameraType,default)
    local value = PlayerPrefs.GetInt(self:Key_PointIndex(cameraType or PlayerPrefsHelper:GetValue_CameraType()), default or 1)
    return value
end
--}}}
--{{{筛选品质白
function PlayerPrefsHelper:SetValue_ArticleFilterTogWhite(value)
    self:SetInt(self:Key_ArticleFilterTogWhite(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterTogWhite()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogWhite(), 1)
    return value == 1
end
--}}}
--{{{筛选品质绿
function PlayerPrefsHelper:SetValue_ArticleFilterTogGreen(value)
    self:SetInt(self:Key_ArticleFilterTogGreen(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterTogGreen()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogGreen(), 1)
    return value == 1
end
--}}}--{{{筛选品质蓝
function PlayerPrefsHelper:SetValue_ArticleFilterTogBlue(value)
    self:SetInt(self:Key_ArticleFilterTogBlue(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterTogBlue()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogBlue(), 1)
    return value == 1
end
--}}}--{{{筛选品质紫
function PlayerPrefsHelper:SetValue_ArticleFilterTogPurple(value)
    self:SetInt(self:Key_ArticleFilterTogPurple(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterTogPurple()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogPurple(), 1)
    return value == 1
end
--}}}--{{{筛选品质橙
function PlayerPrefsHelper:SetValue_ArticleFilterTogOrange(value)
    self:SetInt(self:Key_ArticleFilterTogOrange(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterTogOrange()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogOrange(), 1)
    return value == 1
end
--}}}
--{{{筛选品质橙
function PlayerPrefsHelper:SetValue_ArticleFilterTogRed(value)
    self:SetInt(self:Key_ArticleFilterTogRed(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterTogRed()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogRed(), 1)
    return value == 1
end
--}}}
--}}}--{{{筛选星级1
function PlayerPrefsHelper:SetValue_ArticleFilterStar1(value)
    self:SetInt(self:Key_ArticleFilterStar1(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterStar1()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterStar1(), 1)
    return value == 1
end
--}}}
--{{{筛选星级2
function PlayerPrefsHelper:SetValue_ArticleFilterStar2(value)
    self:SetInt(self:Key_ArticleFilterStar2(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterStar2()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterStar2(), 1)
    return value == 1
end
--}}}
--{{{筛选星级3
function PlayerPrefsHelper:SetValue_ArticleFilterStar3(value)
    self:SetInt(self:Key_ArticleFilterStar3(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterStar3()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterStar3(), 1)
    return value == 1
end
--}}}
--{{{筛选星级4
function PlayerPrefsHelper:SetValue_ArticleFilterStar4(value)
    self:SetInt(self:Key_ArticleFilterStar4(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterStar4()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterStar4(), 1)
    return value == 1
end
--}}}
--{{{筛选星级5
function PlayerPrefsHelper:SetValue_ArticleFilterStar5(value)
    self:SetInt(self:Key_ArticleFilterStar5(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterStar5()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterStar5(), 1)
    return value == 1
end
--}}}
--{{{筛选级别低
function PlayerPrefsHelper:SetValue_ArticleFilterLevelLow(value)
    self:SetInt(self:Key_ArticleFilterTogLevelLow(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterLevelLow()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogLevelLow(), 1)
    return value == 1
end
--}}}
--{{{筛选级别中
function PlayerPrefsHelper:SetValue_ArticleFilterLevelMiddle(value)
    self:SetInt(self:Key_ArticleFilterTogLevelMiddle(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterLevelMiddle()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogLevelMiddle(), 1)
    return value == 1
end
--}}}
--{{{筛选级别高
function PlayerPrefsHelper:SetValue_ArticleFilterLevelHigh(value)
    self:SetInt(self:Key_ArticleFilterTogLevelHigh(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterLevelHigh()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogLevelHigh(), 1)
    return value == 1
end
--}}}
--{{{筛选是否改造是
function PlayerPrefsHelper:SetValue_ArticleFilterTogReformYes(value)
    self:SetInt(self:Key_ArticleFilterTogReformYes(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterTogReformYes()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogReformYes(), 1)
    return value == 1
end
--}}}
--{{{筛选是否改造否
function PlayerPrefsHelper:SetValue_ArticleFilterTogReformNo(value)
    self:SetInt(self:Key_ArticleFilterTogReformNo(), value)
end

function PlayerPrefsHelper:GetValue_ArticleFilterTogReformNo()
    local value = PlayerPrefs.GetInt(self:Key_ArticleFilterTogReformNo(), 1)
    return value == 1
end
--}}}

--{{{登录类型

function PlayerPrefsHelper:SetValue_GlobalLoginType(value)
    self:SetString(self:Key_GlobalLoginType(), value)
end
function PlayerPrefsHelper:GetValue_GlobalLoginType()
    local value = PlayerPrefs.GetString(self:Key_GlobalLoginType(), "")
    return value
end
--}}}

--{{{首充打开
function PlayerPrefsHelper:SetValue_FirstBuy(value)
    self:SetInt(self:Key_FirstBuy(), value)
end
function PlayerPrefsHelper:GetValue_FirstBuy()
    local value = PlayerPrefs.GetInt(self:Key_FirstBuy(), 0)
    return value
end
--}}}
--{{{两倍速
function PlayerPrefsHelper:SetValue_BattleDoubleSpeed(value)
    self:SetInt(self:Key_BattleDoubleSpeed(), value)
end
function PlayerPrefsHelper:GetValue_BattleDoubleSpeed()
    local value = PlayerPrefs.GetInt(self:Key_BattleDoubleSpeed(), 1)
    return value==2
end
--}}}


--{{{特训选择级别
function PlayerPrefsHelper:SetValue_SpecialTrainLevel(value)
    self:SetInt(self:Key_SpecialTrainLevel(), value)
end
function PlayerPrefsHelper:GetValue_SpecialTrainLevel()
    local value = PlayerPrefs.GetInt(self:Key_SpecialTrainLevel(), SpecialTrainingLevel.low)
    return value
end
--}}}
--{{{特训选择类型
function PlayerPrefsHelper:SetValue_SpecialTrainType(value)
    self:SetInt(self:Key_SpecialTrainType(), value)
end
function PlayerPrefsHelper:GetValue_SpecialTrainType()
    local value = PlayerPrefs.GetInt(self:Key_SpecialTrainType(), 0)
    return value
end
--}}}
--{{{自建章节进入关卡
function PlayerPrefsHelper:SetValue_SelfChapterId(value)
    self:SetInt(self:Key_SelfChapterId(), value)
end
function PlayerPrefsHelper:GetValue_SelfChapterId()
    local value = PlayerPrefs.GetInt(self:Key_SelfChapterId(), 1)
    return value
end
--}}}
--{{{播放视频
function PlayerPrefsHelper:SetValue_PlayerVideo(videoName,value)
    self:SetInt(self:Key_PlayVideo(videoName), value)
end
function PlayerPrefsHelper:GetValue_PlayerVideo(videoName)
    local value = PlayerPrefs.GetInt(self:Key_PlayVideo(videoName), 0)
    return value==0
end
--}}}

--{{{
function PlayerPrefsHelper:SetValue_SelfCountDownBtnUpTime(value)
    self:SetInt(self:Key_SelfCountDownBtnUpTime(), value)
end
function PlayerPrefsHelper:GetValue_SelfCountDownBtnUpTime()
    local value = PlayerPrefs.GetInt(self:Key_SelfCountDownBtnUpTime(), 0)
    return value
end
--}}}
--{{{自建章节进入关卡
function PlayerPrefsHelper:SetValue_ReplayInputInfos(value)
    self:SetString(self:Key_ReplayInputInfos(), value)
end
function PlayerPrefsHelper:GetValue_ReplayInputInfos()
    local value = PlayerPrefs.GetString(self:Key_ReplayInputInfos(), "")
    return value
end
--}}}
--{{{序列化聊天内容
function PlayerPrefsHelper:SetValue_ChatContent(value)
    self:SetInt(value, self:TimeFlagDay())
end
function PlayerPrefsHelper:GetValue_ChatContent(md5)
    local value = PlayerPrefs.GetInt(md5, 0)
    return value
end
--}}}

--{{{JCP 参赛车辆顺序
function PlayerPrefsHelper:SetValue_JCP(bTime,jcpIndex,carIndex)
    self:SetInt(self:Key_JCPFlag()..bTime.."_"..jcpIndex, carIndex)
end


function PlayerPrefsHelper:GetValue_JCP(bTime,jcpIndex)
    local value = PlayerPrefs.GetInt(self:Key_JCPFlag()..bTime.."_"..jcpIndex, -1)
    return value
end

function PlayerPrefsHelper:DeleteKey_JCP(bTime,jcpIndex)
    PlayerPrefs.DeleteKey(self:Key_JCPFlag()..bTime.."_"..jcpIndex)
end
--}}}

--{{{登录时间
function PlayerPrefsHelper:SetValue_LoginTime()
    self:SetInt(self:Key_LoginTimeFlag(),self:TimeFlagDay())
end


function PlayerPrefsHelper:GetValue_LoginTime()
    local value = PlayerPrefs.GetInt(self:Key_LoginTimeFlag(), 0)
    return value
end
--}}}
--{{{战斗音效开关
function PlayerPrefsHelper:SetValue_BattleBgmOffOrOn(value)
    self:SetFloat(self:Key_BattleBgmOffOrOn(),value)
end


function PlayerPrefsHelper:GetValue_BattleBgmOffOrOn()
    local value = PlayerPrefs.GetFloat(self:Key_BattleBgmOffOrOn(), 0.8)
    return value
end
--}}}


--{{{战斗音效音量
function PlayerPrefsHelper:SetValue_BattleBgmValue(value)
    self:SetFloat(self:Key_BattleBgmValue(),value)
end


function PlayerPrefsHelper:GetValue_BattleBgmValue()
    local value = PlayerPrefs.GetFloat(self:Key_BattleBgmValue(), 0.8)
    return value
end
--}}}



--{{{AR登录须知
function PlayerPrefsHelper:SetValue_ArUserAgreement()
    self:SetInt(self:Key_ArUserAgreement(),1)
end


function PlayerPrefsHelper:GetValue_ArUserAgreement()
    local value = PlayerPrefs.GetInt(self:Key_ArUserAgreement(), 0)
    return value
end
--}}}
--{{{扭蛋默认选项
function PlayerPrefsHelper:SetValue_RecruitSubType(value)
    self:SetInt(self:Key_RecruitSubType(),value)
end


function PlayerPrefsHelper:GetValue_RecruitSubType()
    local value = PlayerPrefs.GetInt(self:Key_RecruitSubType(), 1)
    return value
end
--}}}
--{{{扭蛋默认选项
function PlayerPrefsHelper:SetValue_MeshCache(value)
    self:SetString(self:Key_MeshCache(),value)
end


function PlayerPrefsHelper:GetValue_MeshCache()
    local value = PlayerPrefs.GetString(self:Key_MeshCache(), "")
    return value
end
--}}}


--{{{语言
function PlayerPrefsHelper:SetValue_LanguageType(type)
    self:SetInt(self:Key_LanguageType(),type)
end


function PlayerPrefsHelper:GetValue_LanguageType()
    local value = PlayerPrefs.GetInt(self:Key_LanguageType(), ClientDataManager:Get().LanguageType)
    return value
end
--}}}


--{{{赛道检测
function PlayerPrefsHelper:SetValue_GameTrackCheck(type)
    self:SetInt(self:Key_GameTrackCheck(),type)
end


function PlayerPrefsHelper:GetValue_GameTrackCheck()
    local value = PlayerPrefs.GetInt(self:Key_GameTrackCheck(), 0)
    return value
end
--}}}
--{{{赛道检测
function PlayerPrefsHelper:SetValue_GameBrakeSetting(type)
    self:SetInt(self:Key_GameBrakeSetting(),type)
end


function PlayerPrefsHelper:GetValue_GameBrakeSetting()
    local value = PlayerPrefs.GetInt(self:Key_GameBrakeSetting(), 1)
    return value
end
--}}}
--{{{车库槽位展示
function PlayerPrefsHelper:SetValue_Car_GrooveIDShow(id,type)
    self:SetInt(self:Key_CarGrooveIdShow(id),type)
end


function PlayerPrefsHelper:GetValue_Car_GrooveIDShow(id)
    local value = PlayerPrefs.GetInt(self:Key_CarGrooveIdShow(id), 1)
    print(self:Key_CarGrooveIdShow(id),value)
    return value
end
--}}}
--{{{玩家第一次失败
function PlayerPrefsHelper:SetValue_PlayerBattleError(value)
    if not self:GetValue_PlayerBattleError() then
        self:SetInt(self:Key_PlayerBattleError(),value)
    end
end


function PlayerPrefsHelper:GetValue_PlayerBattleError()
    local value = PlayerPrefs.GetInt(self:Key_PlayerBattleError(), 0)
    return value==1
end
--}}}
--{{{玩家主页面任务id
function PlayerPrefsHelper:SetValue_MainMenuTaskId(value)
    self:SetInt(self:Key_MainMenuTaskId(),value)
end


function PlayerPrefsHelper:GetValue_MainMenuTaskId()
    local value = PlayerPrefs.GetInt(self:Key_MainMenuTaskId(), 0)
    return value
end
--}}}
--{{{排位类型
function PlayerPrefsHelper:SetValue_RaceRankRaceType(value)
    self:SetInt(self:Key_RaceRankRaceType(),value)
end


function PlayerPrefsHelper:GetValue_RaceRankRaceType()
    local value = PlayerPrefs.GetInt(self:Key_RaceRankRaceType(), RaceProtectType.Protect)
    return value
end
--}}}
--{{{排位类型
function PlayerPrefsHelper:SetValue_RaceRankIndexType(_RaceType,dataIndex)
    self:SetInt(self:Key_RaceRankIndexType(_RaceType),dataIndex)
end


function PlayerPrefsHelper:GetValue_RaceRankIndexType(_RaceType)
    local value = PlayerPrefs.GetInt(self:Key_RaceRankIndexType(_RaceType),0)
    return value
end
--}}}
--{{{排位类型
function PlayerPrefsHelper:SetValue_CarVerifyHistory(idx,value)
    self:SetString(self:Key_CarVerifyHistory(idx),value)
end


function PlayerPrefsHelper:GetValue_CarVerifyHistory(idx)
    local value = PlayerPrefs.GetString(self:Key_CarVerifyHistory(idx), "")
    return value
end
--}}}

--{{{
function PlayerPrefsHelper:SetValue_Mini4wdRuleViewOpen(type,value)
    self:SetInt(self:Key_Mini4wdRuleView(type),value)
end

function PlayerPrefsHelper:GetValue_Mini4wdRuleViewOpen(type)
    local value = PlayerPrefs.GetInt(self:Key_Mini4wdRuleView(type), 0)
    return value==1
end
--}}}


--{{{谷歌充值log记录  1、充值成功和登录成功后，判断log不为空先上传log并重置   2、发货成功重置当前log不上传
function PlayerPrefsHelper:AddValue_GoogleChargeLog(type ,logInfo)
    local value = PlayerPrefs.GetString(self:Key_GoogleCharge(), "")

    local _time = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    self:SetString(self:Key_GoogleCharge(), value .. "logTime:" .. _time .. "type:" .. type .. "info:" .. logInfo)
    --log("AddValue_GoogleChargeLog" .. PlayerPrefsHelper:GetValue_GoogleChargeLog())
end

function PlayerPrefsHelper:GetValue_GoogleChargeLog()
    local value = PlayerPrefs.GetString(self:Key_GoogleCharge(), "")
    --log("GetValue_GoogleChargeLog" .. value)
    return value
end

function PlayerPrefsHelper:ResetValue_GoogleChargeLog()
    PlayerPrefs.DeleteKey(self:Key_GoogleCharge())
    self:SetString(self:Key_GoogleCharge(),self:PlayerFlag() .. ":")
    --log("ResetValue_GoogleChargeLog" .. PlayerPrefsHelper:GetValue_GoogleChargeLog())
end

function PlayerPrefsHelper:SetValue_Skill_Xuanfeng(value)
    self:SetInt("skill_xuanfeng", value)
end

function PlayerPrefsHelper:GetValue_Skill_Xuanfeng()
    local value = PlayerPrefs.GetInt("skill_xuanfeng", -1)
    --log("GetValue_GoogleChargeLog" .. value)
    return value
end

function PlayerPrefsHelper:SetValue_Skill_ClimbWall(value)
    self:SetInt("skill_paqiang", value)
end

function PlayerPrefsHelper:GetValue_Skill_ClimbWall()
    local value = PlayerPrefs.GetInt("skill_paqiang", -1)
    --log("GetValue_GoogleChargeLog" .. value)
    return value
end


function PlayerPrefsHelper:SetValue_PopUpGift(value)
    self:SetInt(self:Key_PopUpGiftFlag().."_"..value,1)
end

function PlayerPrefsHelper:GetValue_PopUpGift(value)
    local value = PlayerPrefs.GetInt(self:Key_PopUpGiftFlag().."_"..value,0)
    return value
end
function PlayerPrefsHelper:SetValue_CarAttrRecommendVersion(value)
    self:SetString(self:Key_CarAttrRecommendVersion(),value)
end

function PlayerPrefsHelper:GetValue_CarAttrRecommendVersion()
    local value = PlayerPrefs.GetString(self:Key_CarAttrRecommendVersion(),"")
    return value
end
function PlayerPrefsHelper:SetValue_RaceCarGodIndex(value)
    self:SetInt(self:Key_RaceCarGodIndex(),value)
end

function PlayerPrefsHelper:GetValue_RaceCarGodIndex(defaultValue)
    local value = PlayerPrefs.GetInt(self:Key_RaceCarGodIndex(),defaultValue)
    return value
end
function PlayerPrefsHelper:SetValue_RaceCarGodMoudle(value)
    self:SetInt(self:Key_RaceCarGodMoudle(),value)
end

function PlayerPrefsHelper:GetValue_RaceCarGodMoudle()
    local value = PlayerPrefs.GetInt(self:Key_RaceCarGodMoudle(),1)
    return value
end
function PlayerPrefsHelper:SetValue_RaceRankSelectPosition(value)
    self:SetInt(self:Key_RaceRankSelectPosition(),value)
end

function PlayerPrefsHelper:GetValue_RaceRankSelectPosition()
    local value = PlayerPrefs.GetInt(self:Key_RaceRankSelectPosition(),0)
    return value
end
function PlayerPrefsHelper:SetValue_RaceTestSelectPosition(type,value)
    self:SetInt(self:Key_RaceTestSelectPosition(type),value)
end

function PlayerPrefsHelper:GetValue_RaceTestSelectPosition(type)
    local value = PlayerPrefs.GetInt(self:Key_RaceTestSelectPosition(type),0)
    return value
end
function PlayerPrefsHelper:SetValue_RecruitAnimSkip(value)
    if value then
        PlayerPrefs.SetInt(self:Key_RecruitAnimSkip(),1)
    else
        PlayerPrefs.SetInt(self:Key_RecruitAnimSkip(),-1)
    end
end

function PlayerPrefsHelper:GetValue_RecruitAnimSkip()
    local value = PlayerPrefs.GetInt(self:Key_RecruitAnimSkip(),-1)==1
    return value
end


--}}}
