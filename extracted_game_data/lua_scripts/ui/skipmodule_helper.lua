---@class SkipModuleHelper
SkipModuleHelper = class("SkipModuleHelper")

local __instance
---@return SkipModuleHelper
function SkipModuleHelper:Get()
    if __instance == nil then
        __instance = SkipModuleHelper()
    end
    return __instance
end

function SkipModuleHelper:Loading_BattleToPVEChapter(param, type, onback)
    CommonHelper:PlayGuideScreenEffectUIMask()
    SkipModuleHelper:Get():ToMainMenuView(true)
    if not CommonHelper:CheckPlayerIsNewGuide() then
        if PopupManager:Get().RallyIngQueue:GetSize() <= 0 then
            ChapterSubsystem:Get():SendMsg_GetChapterList(function()
                local chpaterid = CommonHelper:AnalyseChapterId(param)
                ChapterSubsystem:Get():SendMsg_GetChapterDetail(chpaterid, onback)
            end)
        else
            if onback then
                onback()
            end
            CommonHelper:CloseGuideScreenEffectUIMask()
        end
    else
        if onback then
            onback()
        end
    end
end
function SkipModuleHelper:Loading_BattleToNewbieChapter(param, type, onback)
    CommonHelper:PlayGuideScreenEffectUIMask()
    if CommonHelper:CheckPlayerIsNewGuide() then
        if GuideManager:Get():GetCurGuideStep():GetNextLevelId() == -99 then
            UIManager:Get():OpenView("InitialView", CanvasType.MainCanvas, "InitialView")
        else
            ChapterSubsystem:Get():SendMsg_GetChapterRank(GuideManager:Get():GetCurGuideStep():GetNextLevelId(), 0)
        end
        if onback then
            onback()
        end
    else
        if onback then
            onback()
        end
    end
end
function SkipModuleHelper:Loading_BattleToRaceAssembleTest(param, type, onback)
    CommonHelper:PlayGuideScreenEffectUIMask()
    if RaceAssembleAddManager:Get():GetOpenType() == UIModuleID.RaceRank then
        SkipModuleHelper:Get():Loading_BattleToPVPRank(param, function()
            RaceAssembleAddManager:Get():ReOpen()
            if onback then
                onback()
            end
        end)
    end

end

function SkipModuleHelper:Loading_BattleToRaceRoom(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
    if RaceRoomManager:Get():IsInRoom() and RaceRoomManager:Get():GetLeaderID() > 0 then
        CommonHelper:SetUnlockFunc({ GameFunction.RaceRoom }, function()
            UIManager:Get():OpenView("RaceRoomView", CanvasType.MainCanvas, "RaceRoomView")
        end)
        UIManager:Get():OpenView("RaceRoomDetailView", CanvasType.MainCanvas, "RaceRoomDetailView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetData)
        if RaceRoomManager:Get():IsLeader() and RaceRoomManager:Get():IsRandom() then
            ---@type RaceTrackData
            local trackData = RaceRoomManager:Get():GetTrackData()
            ---@type RaceTrackData[]
            local trackList = CommonHelper:GetTrackListByType(trackData:GetMiniTrackType(), trackData:GetRaceNumber(), TrackListModule.RaceRoom, { 1, 2, 3, 4, 5, 6 })
            local result = trackList[math.random(1, #trackList)]
            RaceRoomSubsystem:Get():SendMsg_ReviseRoom(result:GetId(), 1, backfunc)
        else
            if backfunc then
                backfunc()
            end
        end
    else
        RaceRoomManager:Get():ClearData()
        CommonHelper:SetUnlockFunc({ GameFunction.RaceRoom }, function()
            UIManager:Get():OpenView("RaceRoomView", CanvasType.MainCanvas, "RaceRoomView")
        end)
        if backfunc then
            backfunc()
        end
    end
end

function SkipModuleHelper:Loading_BattleToPVPRank(param, backFunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    RaceRankSubsystem:Get():SendMsg_SessionInfo(function()
        UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
        UIManager:Get():OpenView("RaceRankView", CanvasType.MainCanvas, "RaceRankView")
        UINotify:Get():SendNotification(UINotifyEvent.RaceRankView_SetData)
        if backFunc then
            backFunc()
        end
    end)
    --CommonSubsystem:Get():SendMsg_CheckServerTime()
end

function SkipModuleHelper:Loading_BattleToWeekRank(param, backFunc)
    -- UIManager:Get():OpenView("SpecialTrainingView", CanvasType.MainCanvas, "SpecialTrainingView")
    SkipModuleHelper:Get():ToMainMenuView(false)
    if SpecialTrainingDataManager:Get():GetCurChallengeTeam().id == 4 then
        SpecialTrainingDataManager:Get():LoadConfig()
        SpecialTrainingDataManager:Get():SetCurChallenge(4)
        SpecialTrainingDataManager:Get():SetSelectChallenge(SpecialTrainingLevel.high)
        SkipModuleHelper:Get():ToSelectCarView(RaceModel.Challenge, nil)
        if backFunc then
            backFunc()
        end
    else
        if not RaceRankManager:Get():IsMatching() then
            ChallengeSubsystem:Get():SendGetChallengeInfo(backFunc)
        end
    end
end

function SkipModuleHelper:Loading_BattleToClubTrain(param, backFunc)
    ClubTrainSubsystem:Get():SendMsg_GetSelfTrackRaceInfo()
end

function SkipModuleHelper:Loading_BattleToRaceSelf(param)
    UIManager:Get():OpenView("RaceSelfView", CanvasType.MainCanvas, "RaceSelfView")
    RaceSelfSubsystem:Get():SendMsg_GetAllList()
end

function SkipModuleHelper:Loading_BattleToSelfChallenge(param, backfunc)
    UIManager:Get():OpenView("SelfChallengeMenuView", CanvasType.MainCanvas, "SelfChallengeMenuView")
    if backfunc then
        backfunc()
    end
end

function SkipModuleHelper:Loading_BattleToRaceSelfLevel(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
    ChallengeMatchSubsystem:Get():SendMsg_BattleList(backfunc)
end
function SkipModuleHelper:Loading_BattleToRaceAssemble(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    RaceAssembleSubsystem:Get():SendMsg_RaceAssembleInfo(backfunc)
end

function SkipModuleHelper:Loading_BattleToRaceSelfChapter(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
    RaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(true, backfunc)
end

function SkipModuleHelper:Loading_BattleToGameStart(param, backfunc)
    LoginFuncHelper:LogoutClearRes(param)
    if backfunc then
        backfunc()
    end
end

function SkipModuleHelper:Loading_StartToRaceRank(param, backfunc)
    UIManager:Get():OpenView("RaceRankRoomView", CanvasType.MainCanvas, "RaceRankRoomView", false, true)
    UINotify:Get():SendNotification(UINotifyEvent.RaceRankRoomView_SetData)
    if backfunc then
        backfunc()
    end
end

function SkipModuleHelper:Loading_StartToRaceRoom(param, backfunc)
    UIManager:Get():OpenView("RaceRoomDetailView", CanvasType.MainCanvas, "RaceRoomDetailView")
    UINotify:Get():SendNotification(UINotifyEvent.RaceRoomDetailView_SetData)
    if backfunc then
        backfunc()
    end
end

function SkipModuleHelper:Loading_ToAR(param)
    UIManager:Get():OpenView("ARView", CanvasType.MainCanvas, "ARView")
end

function SkipModuleHelper:Loading_ARToMainMenu(param)
    self:OpenMainMenu()
end
function SkipModuleHelper:Loading_GuideBattleToMainMenu(param, backfunc)
    self:OpenMainMenu()
    if backfunc then
        backfunc()
    end
end
function SkipModuleHelper:Loading_BattleErrorToRaceView(param, backfunc)
    if not UIManager:Get():IsViewShow("RaceView") then
        SkipModuleHelper:Get():ToMainMenuView(false)
        UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
    end
    if backfunc then
        backfunc()
    end
end
function SkipModuleHelper:Loading_BattleToRaceTrot(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
    FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceTrot, backfunc)
end
function SkipModuleHelper:Loading_BattleToRaceJcp(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    RaceJcpSubsystem:SendMsg_RaceJCPInfo(backfunc)
end
function SkipModuleHelper:Loading_BattleToRaceTop(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceTop, backfunc)
end
function SkipModuleHelper:Loading_BattleToRaceTopSuper(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceTopSuper, backfunc)
end
function SkipModuleHelper:Loading_BattleToRaceGVG(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    CommonHelper:SetUnlockFunc({ GameFunction.Club }, function()
        local guildId = PlayerDataManager:Get():GetGuildId()
        if guildId == 0 then
            UIManager:Get():OpenView("ClubNoView", CanvasType.MainCanvas, "ClubNoView")
            if backfunc then
                backfunc()
            end
        else
            ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, guildId, backfunc)
            RaceGVGManager:Get().ReturnBattleGVG = true
        end
    end)
end
function SkipModuleHelper:Loading_BattleStateRaceSeniorTrain(param, type, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(true)
    if not CommonHelper:CheckPlayerIsNewGuide() then
        if PopupManager:Get().RallyIngQueue:GetSize() <= 0 then
            ChallengeSubsystem:Get():SendGetChallengeInfo(function()
                RaceSeniorTrainSubsystem:Get():SendMsg_GetChapterList(function()
                    local chpaterid = CommonHelper:AnalyseChapterId(param)
                    RaceSeniorTrainSubsystem:Get():SendMsg_GetChapterDetail(chpaterid, backfunc)
                end)
            end)
        else
            if backfunc then
                backfunc()
            end
        end
    else
        if backfunc then
            backfunc()
        end
    end
end
function SkipModuleHelper:Loading_BattleToRaceCarGod(param, type, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(true)
    FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceCarGod, backfunc, false, true, true)
end
function SkipModuleHelper:Loading_BattleToRaceSuperBattle(param, type, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(true)
    FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceSuper, backfunc)
end

function SkipModuleHelper:Loading_BattleToRaceClub3V3(param, backfunc)
    SkipModuleHelper:Get():ToMainMenuView(false)
    CommonHelper:SetUnlockFunc({ GameFunction.Club }, function()
        local guildId = PlayerDataManager:Get():GetGuildId()
        if guildId == 0 then
            UIManager:Get():OpenView("ClubNoView", CanvasType.MainCanvas, "ClubNoView")
            if backfunc then
                backfunc()
            end
        else
            ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, guildId, backfunc)
            RaceClub3V3Manager:Get().ReturnBattle = true
        end
    end)
end

function SkipModuleHelper:Loading_TestRunToMainMenu(param, backfunc)
    self:OpenMainMenu()
    UIManager:Get():OpenView("CustomTrackListView", CanvasType.MainCanvas, "CustomTrackListView")
    if backfunc then
        backfunc()
    end
end

function SkipModuleHelper:Loading_ReviewClose(param, backfunc)
    UIManager:CloseView()
    UIManager:ClosePopup()
    if backfunc then
        backfunc()
    end
end
local _OpenGarageType = nil
function SkipModuleHelper:ToGarage(type)
    _OpenGarageType = type
    FunctionSkipManager:Get():SkipToFunction(GameFunction.Garbage, type)
end
function SkipModuleHelper:GetOpenGarageType()
    return _OpenGarageType
end
function SkipModuleHelper:SetOpenGarageType(type)
    _OpenGarageType = type
end

function SkipModuleHelper:ToStory()

end
function SkipModuleHelper:BackToMainMenuView(isCheck, backFun, CancelFun)
    if isCheck then
        local boxfunc = function()
            local str = CommonHelper:GetTempStr_Default(TemplateStringID.BackToMainOkOrCancel)
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
            if ret == MessageBoxHelp.BtnType.OK then
                SkipModuleHelper:Get():ToMainMenuView(false)
                if backFun then
                    backFun()
                end
            end
            if ret == MessageBoxHelp.BtnType.Cancel then
                if CancelFun then
                    CancelFun()
                end
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    else
        SkipModuleHelper:Get():ToMainMenuView(false)
        if backFun then
            backFun()
        end
    end
end

function SkipModuleHelper:ToMainMenuView(isCheckPopup)
    self:OpenMainMenu()
    PopupManager:Get():SetIsCheckRallyPopup(isCheckPopup)
end

function SkipModuleHelper:OpenMainMenu()
    if MainCitySceneValue == SceneChangeID.MainCity_Interaction then
        UIManager:Get():OpenView("InteractionMainMenuView", CanvasType.MainCanvas, "InteractionMainMenuView")
    else
        if GameProperties.AreaType == AreaType.AreaTypeDNY and GameProperties.isTs then
            UIManager:Get():OpenView("MainMenuTsView", CanvasType.MainCanvas, "MainMenuView")
        else
            UIManager:Get():OpenView("MainMenuView", CanvasType.MainCanvas, "MainMenuView")
        end

    end
end

function SkipModuleHelper:RaceRoomToMainMenu()
    -- 房间赛被迫退出tracksegmentdata_manager
    if UIManager:Get():CheckViewExist("RaceRoomMenuView") then
        UIManager:Get():CloseAllViews()
        UIManager:Get():CloseAllPopups()
        SkipModuleHelper:Get():ToMainMenuView(true)
    end
end

function SkipModuleHelper:ToRaceRoomDetail(id, flagpasswd)
    if flagpasswd then
        UIManager:Get():OpenPopup("CommonInputView", CanvasType.FrontCanvas, "CommonInputView")
        local param = CommonInputViewParam()
        param.TitleName = CommonHelper:GetTempStr_Default(TemplateStringID.PleaseInputPassword)
        param.DefaultValue = ""
        param.Func = function(nilparam, value)
            SkipModuleHelper:Get():ToMainMenuView(false)
            RaceRoomSubsystem:Get():SendMsg_JoinSelectedRoom(id, value)
        end
        UINotify:Get():SendNotification(UINotifyEvent.CommonInputView_SetData, param)
    else
        SkipModuleHelper:Get():ToMainMenuView(false)
        RaceRoomSubsystem:Get():SendMsg_JoinSelectedRoom(id, "")
    end
end






--{{{车方案
function SkipModuleHelper:ToCarSuitList(carid)
    UIManager:Get():ShowPersistentView("SuitListView", CanvasType.FrontCanvas, "SuitListView")
    local param = SuitListViewParam()
    param.UIColor = UIColor.Blue
    param.CarIdx = carid
    UINotify:Get():SendNotification(UINotifyEvent.SuitListView_SetData, param)
    SuitSubsystem:Get():SendMsg_GetList()
end
--}}}

--{{{ 玩家信息
function SkipModuleHelper:ToPlayerInfoView(type, param)

    --
    if type == SkipPlayerInfoView.Setting then
        UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoViewUpdateTog, { SkipPlayerInfoView.Setting, param })
        UINotify:Get():SendNotification(UINotifyEvent.PersonalHomeViewUpdateTog, { SkipPlayerInfoView.Setting, param })
    elseif type == SkipPlayerInfoView.PlayerInfo then
        UIManager:Get():OpenView("PlayerSelfInfoView", CanvasType.MainCanvas, "PlayerSelfInfoView")
        UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoViewUpdateTog, { SkipPlayerInfoView.PlayerInfo, param })
        UINotify:Get():SendNotification(UINotifyEvent.PersonalHomeViewUpdateTog, { SkipPlayerInfoView.PlayerInfo, param })
    elseif type == SkipPlayerInfoView.RankHistory then
        UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoViewUpdateTog, { SkipPlayerInfoView.RankHistory, param })
        UINotify:Get():SendNotification(UINotifyEvent.PersonalHomeViewUpdateTog, { SkipPlayerInfoView.RankHistory, param })
    elseif type == SkipPlayerInfoView.PersonalHome then
        UIManager:Get():OpenView("PersonalHomeView", CanvasType.MainCanvas, "PersonalHomeView")
        UINotify:Get():SendNotification(UINotifyEvent.PersonalHomeViewUpdateTog, { SkipPlayerInfoView.PersonalHome, param })
    end
end
--}}}
--{{{ 查看其他玩家信息
function SkipModuleHelper:ToPlayerOtherInfoView(param, keepShowPrevious)
    keepShowPrevious = keepShowPrevious or false
    UIManager:Get():OpenPopup("OtherPlayerInfoView", CanvasType.FrontCanvas, "OtherPlayerInfoView", keepShowPrevious)
    UINotify:Get():SendNotification(UINotifyEvent.PlayerOtherInfoView_SetData, param)
    --if type==SkipPlayerInfoView.PlayerInfo then
    --
    --elseif type==SkipPlayerInfoView.RankHistory then
    --
    --end
end
--}}}

--{{{ 去选车界面
function SkipModuleHelper:ToSelectCarView(type, param)
    UIManager:Get():OpenView("SelectTeamBaseView", CanvasType.MainCanvas, "SelectTeamBaseView")
    UINotify:Get():SendNotification(UINotifyEvent.SelectTeamBaseViewSetData, { type, param })
end
--}}}

--{{{ 配件选择
---@param articleList  ArticleCell[]
function SkipModuleHelper:ToArticleFilterView(articleList, func, isUseLastResult)
    UIManager:Get():OpenPopup("ArticleFilterView", CanvasType.MainCanvas, "ArticleFilterView")
    UINotify:Get():SendNotification(UINotifyEvent.ArticleFilterView_ArticleSetData, { articleList, isUseLastResult, func })
end
--}}}
--{{{ 配件选择
---@param articleList  AssembleSiftData[]
function SkipModuleHelper:ToAssembleFilterView(articleList, curdata, func, isUseLastResult)
    UIManager:Get():OpenPopup("ArticleFilterView", CanvasType.MainCanvas, "ArticleFilterView")
    UINotify:Get():SendNotification(UINotifyEvent.ArticleFilterView_AssembleSiftSetData, { articleList, curdata, isUseLastResult, func })
end
--}}}

function SkipModuleHelper:ToRaceView(force, func)
    if not UIManager:Get():IsViewShow("RaceView") then
        if force then
            if not UIManager:Get():IsViewShow("RaceView") then
                UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
            end
            if func then
                func()
            end
        else
            RaceRankSubsystem:Get():SendMsg_SessionInfo(function()
                UIManager:Get():OpenView("RaceView", CanvasType.MainCanvas, "RaceView")
                if func then
                    func()
                end
            end, false)
        end
    else
        if func then
            func()
        end
    end

end
function SkipModuleHelper:ToPurchasePanel(force)
    ActivityDataManager:Get():Init()
    ActivitySubsystem:Get():SendMsg_GetActivity(ActivityDataManager:Get():GetActivityList()[1].giftid, true)
end


--{{{假车库跳转
---@param data CarReviewData
---@param list dictfairmatchparts_config_cell[]
function SkipModuleHelper:ToGuideGarageView(data, list, type)
    UIManager:Get():OpenView("GuideGarageView", CanvasType.MainCanvas, "GuideGarageView")
    UINotify:Get():SendNotification(UINotifyEvent.GuideGarageView_SetData, { data, list, type })
end
--}}}
--{{{假车库跳转
---@param data CarData[]
---@param bag KnapsackData
function SkipModuleHelper:ToAssembleGarageView(data, bag, type)
    UIManager:Get():OpenView("RaceAssembleGarageView", CanvasType.MainCanvas, "RaceAssembleGarageView")
    UINotify:Get():SendNotification(UINotifyEvent.AssembleGarageView_SetData, { data, bag, type })
end
--}}}
