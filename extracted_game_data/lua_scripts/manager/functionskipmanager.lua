---@class FunctionSkipData
FunctionSkipData = class("FunctionSkipData")
function FunctionSkipData:initialize()
    self.ID=0
    self.class=nil
    self.Func=nil
end

---@class FunctionSkipManager
FunctionSkipManager = class("FunctionSkipManager")

---@return FunctionSkipManager
function FunctionSkipManager:Get()
    if self._instance == nil then
        self._instance = FunctionSkipManager()
    end
    return self._instance
end

function FunctionSkipManager:initialize()
    ---@type FunctionSkipData[]
    self.EvtMap = {}
    self:RegisterSkipFun(GameFunction.Story,FunctionSkipManager.SkipToChapter)
    self:RegisterSkipFun(GameFunction.Garbage,FunctionSkipManager.SkipToGarbage)
    self:RegisterSkipFun(GameFunction.Bag,FunctionSkipManager.SkipToBag)
    self:RegisterSkipFun(GameFunction.Setting,FunctionSkipManager.SkipToSetting)
    self:RegisterSkipFun(GameFunction.Shop,FunctionSkipManager.SkipToShop)
    self:RegisterSkipFun(GameFunction.Recruit,FunctionSkipManager.SkipToRecruit)
    self:RegisterSkipFun(GameFunction.Club,FunctionSkipManager.SkipToClub)
    self:RegisterSkipFun(GameFunction.Friend,FunctionSkipManager.SkipToFriend)
    self:RegisterSkipFun(GameFunction.Announcement,FunctionSkipManager.SkipToAnnouncement)
    self:RegisterSkipFun(GameFunction.Email,FunctionSkipManager.SkipToEmail)
    self:RegisterSkipFun(GameFunction.Task,FunctionSkipManager.SkipToTask)
    self:RegisterSkipFun(GameFunction.LabIron,FunctionSkipManager.SkipToLabIron)
    self:RegisterSkipFun(GameFunction.PVPRank,FunctionSkipManager.SkipToPVPRank)
    self:RegisterSkipFun(GameFunction.RaceRoom,FunctionSkipManager.SkipToRaceRoom)
    self:RegisterSkipFun(GameFunction.Chat,FunctionSkipManager.SkipToChat)
    self:RegisterSkipFun(GameFunction.Survey,FunctionSkipManager.SkipToSurvey)
    self:RegisterSkipFun(GameFunction.PartStrong,FunctionSkipManager.SkipToPartStrong)
    self:RegisterSkipFun(GameFunction.SelfChapter,FunctionSkipManager.SkipToSelfChapter)
    self:RegisterSkipFun(GameFunction.ClubChapter,FunctionSkipManager.SkipToClubChapter)
    self:RegisterSkipFun(GameFunction.ClubActivity,FunctionSkipManager.SkipToClubActivity)
    self:RegisterSkipFun(GameFunction.SelfTrack,FunctionSkipManager.SkipToSelfTrack)
    self:RegisterSkipFun(GameFunction.SelfRace,FunctionSkipManager.SkipToSelfRace)
    self:RegisterSkipFun(GameFunction.AccessoryWarehouse,FunctionSkipManager.SkipToAccessoryWarehouse)
    self:RegisterSkipFun(GameFunction.RaceCarGod,FunctionSkipManager.SkipToRaceCarGod)
    self:RegisterSkipFun(GameFunction.SeasonOrder,FunctionSkipManager.SkipToSeasonOrder)
    self:RegisterSkipFun(GameFunction.RaceSuper,FunctionSkipManager.SkipToRaceSuper)
    self:RegisterSkipFun(GameFunction.SpecialTraining,FunctionSkipManager.SkipToSpecialTraining)
    self:RegisterSkipFun(GameFunction.PurchasePanel,FunctionSkipManager.SkipToPurchasePanel)
    --self:RegisterSkipFun(GameFunction.ActAdvanceNotice,FunctionSkipManager.SkipToActAdvanceNotice)
    self:RegisterSkipFun(GameFunction.ActProclamation,FunctionSkipManager.SkipToActProclamation)
    self:RegisterSkipFun(GameFunction.CommonAct,FunctionSkipManager.SkipToCommonAct)
    self:RegisterSkipFun(GameFunction.ReturnOldPlayer,FunctionSkipManager.SkipToReturnOldPlayer)
    self:RegisterSkipFun(GameFunction.RaceJcp,FunctionSkipManager.SkipToRaceJcp)
    self:RegisterSkipFun(GameFunction.RaceXCP,FunctionSkipManager.SkipToRaceXCP)
    self:RegisterSkipFun(GameFunction.LoginTask,FunctionSkipManager.SkipToLoginTask)
    self:RegisterSkipFun(GameFunction.MainRankList,FunctionSkipManager.SkipToMainRankList)
    self:RegisterSkipFun(GameFunction.RaceTop,FunctionSkipManager.SkipToRaceTop)
    self:RegisterSkipFun(GameFunction.Welfare,FunctionSkipManager.SkipToWelfare)
    self:RegisterSkipFun(GameFunction.RaceTrot,FunctionSkipManager.SkipToRaceTrot)
    self:RegisterSkipFun(GameFunction.PopUpGift,FunctionSkipManager.SkipToPopUpGift)
    self:RegisterSkipFun(GameFunction.IllustratedHandbook,FunctionSkipManager.SkipToIllustratedHandbook)
    self:RegisterSkipFun(GameFunction.RaceTopSuper,FunctionSkipManager.SkipToRaceTopSuper)
    self:RegisterSkipFun(GameFunction.PlayAd,FunctionSkipManager.PlayAd)
end
---@param class middleclass  不传的话就是静态方法
function FunctionSkipManager:RegisterSkipFun(key,func,class)
    local temp=FunctionSkipData()
    temp.ID=key
    if class then
        temp.class=class
    else
        temp.class=self
    end
    temp.Func=func
    self.EvtMap[key]=temp
end

function FunctionSkipManager:SkipToChapter(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Story }, function()
        if not RaceRankManager:Get():IsMatching() then
            ChapterSubsystem:Get():SendMsg_GetChapterList(function()
                if param then
                    local chpaterid = param
                    ChapterSubsystem:Get():SendMsg_GetChapterDetail(chpaterid)
                end
            end)
            RedPointManager:Get():UpdateValue(RedPointID.S_Chapter,false)
        end
    end)
end
function FunctionSkipManager:SkipToGarbage(param)
    SkipModuleHelper:SetOpenGarageType(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Garbage }, function()
        if not RaceRankManager:Get():IsMatching() then
            UIManager:Get():OpenView("GarageView", CanvasType.MainCanvas, "GarageView")
            CommonHelper:PlayScreenEffectUIMask()
        end
    end)
end
function FunctionSkipManager:SkipToBag(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Bag }, function()
        UIManager:Get():OpenView("BagView", CanvasType.MainCanvas, "BagView")
    end)
end
function FunctionSkipManager:SkipToSetting(param)
    UIManager:Get():OpenView("SettingView", CanvasType.MainCanvas, "SettingView")
end
function FunctionSkipManager:SkipToShop(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Shop }, function()
        UIManager:Get():OpenView("ShopView", CanvasType.MainCanvas, "ShopView")
        if param then
            ShopSubsystem:Get():SendMsg_ShopInfo(param)
        else
            ShopSubsystem:Get():SendMsg_ShopInfo(ShopID.Gold)
        end
        RedPointManager:Get():UpdateValue(RedPointID.Shop,false)
    end)
end
function FunctionSkipManager:SkipToRecruit(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Recruit }, function()
        if not RaceRankManager:Get():IsMatching() then
            RecruitSubsystem:Get():SendMsg_RecruitInfo()
        end
    end)
end
function FunctionSkipManager:SkipToClub(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Club }, function()
        local guildId = PlayerDataManager:Get():GetGuildId()
        if guildId == 0 then
            UIManager:Get():OpenView("ClubNoView", CanvasType.MainCanvas, "ClubNoView")
        else
            ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, guildId)
        end
    end)
end
function FunctionSkipManager:SkipToFriend(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Friend }, function()
        FriendSubsystem:Get():SendMsg_GetAllFriends()
        FriendDataManager:Get():SetFriendType(FriendType.Init)
    end)

end
function FunctionSkipManager:SkipToAnnouncement(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Announcement }, function()
        LoginSubSystem:Get():SendMsg_GetAnnouncement()
    end)
end
function FunctionSkipManager:SkipToEmail(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Email }, function()
        UIManager:Get():OpenView("EmailView", CanvasType.MainCanvas, "EmailView")
    end)
end
function FunctionSkipManager:SkipToTask(param)
    CommonHelper:SetUnlockFunc({ GameFunction.Task }, function()
        if not RaceRankManager:Get():IsMatching() then
            if param then
                TaskSubsystem:Get():SendMsg_GetTaskList(param[1],param[2],param[3])
            end
        end
    end)
end
function FunctionSkipManager:SkipToLabIron(param)
    CommonHelper:SetUnlockFunc({ GameFunction.LabIron }, function()
       --LabDataManager:Get():OpenDefaultToggle()
        LabSubsystem:Get():SendMsg_ReqComposeList()
    end)
end
function FunctionSkipManager:SkipToPVPRank(param)
    CommonHelper:SetUnlockFunc({ GameFunction.PVPRank }, function()
        RaceRankSubsystem:Get():SendMsg_SessionInfo()
    end)
end
function FunctionSkipManager:SkipToRaceRoom(param)
    CommonHelper:SetUnlockFunc({ GameFunction.RaceRoom }, function()
        UIManager:Get():OpenView("RaceRoomView", CanvasType.MainCanvas, "RaceRoomView")
    end)
end
function FunctionSkipManager:SkipToChat(param)

end
function FunctionSkipManager:SkipToSurvey(param)

end
function FunctionSkipManager:SkipToPartStrong(param)

end
function FunctionSkipManager:SkipToSelfChapter(param)
    CommonHelper:SetUnlockFunc({ GameFunction.SelfChapter }, function()
        if not RaceRankManager:Get():IsMatching() then
            RaceSelfChapterSubsystem:Get():SendMsg_GetAllSelfChapter(false)
        end
    end)
end
function FunctionSkipManager:SkipToClubChapter(param)

end
function FunctionSkipManager:SkipToClubActivity(param)

end
function FunctionSkipManager:SkipToSelfTrack(param)
    UIManager:Get():OpenView("CustomTrackListView", CanvasType.MainCanvas, "CustomTrackListView")
end
function FunctionSkipManager:SkipToSelfRace(param)
    if not HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.SelfRace) then
        CommonTipsHelper:Get():ShowCenterTips("功能未开启")
        return
    end
    CommonHelper:SetUnlockFunc({ GameFunction.SelfRace }, function()
        if not RaceRankManager:Get():IsMatching() then
            ChallengeMatchSubsystem:Get():SendMsg_BattleList()
            --RaceSelfLevelSubsystem:Get():SendMsg_SelfLevelGetList(0)
        end
    end)
end
function FunctionSkipManager:SkipToAccessoryWarehouse(param)
    CommonHelper:SetUnlockFunc({ GameFunction.AccessoryWarehouse }, function()
        WarehouseSubsystem:Get():SendMsg_GetOpenStore()
    end)
end
function FunctionSkipManager:SkipToRaceCarGod(param)
    CommonHelper:SetUnlockFunc({ GameFunction.RaceCarGod }, function()
        RaceCarGodSubsystem:Get():SendMsg_OneGodInfo(param)
    end)


end
function FunctionSkipManager:SkipToSeasonOrder(param)
    CommonHelper:SetUnlockFunc({ GameFunction.SeasonOrder }, function()
        SeasonOrderSubsystem:Get():SendMsg_GetSeasonInfo()
    end)
end
function FunctionSkipManager:SkipToRaceSuper(param)
    CommonHelper:SetUnlockFunc({ GameFunction.RaceSuper }, function()
        RaceSuperBattleSubsystem:Get():SendMsg_EnterRaceSuperBattle(false,param)
    end)
end
function FunctionSkipManager:SkipToSpecialTraining(param)
    CommonHelper:SetUnlockFunc({ GameFunction.SpecialTraining }, function()
        if not RaceRankManager:Get():IsMatching() then
            ChallengeSubsystem:Get():SendGetChallengeInfo()
            RedPointManager:Get():UpdateValue(RedPointID.SpecialTraining,false)
        end
    end)
end
function FunctionSkipManager:SkipToPurchasePanel(param)
    SkipModuleHelper:Get():ToPurchasePanel()
end

function FunctionSkipManager:SkipToActAdvanceNotice(param)
    if not UIManager:Get():IsPersistentViewShow("ActAdvanceNoticeView") then
        UIManager:Get():ShowPersistentView("ActAdvanceNoticeView", CanvasType.MainCanvas, "ActAdvanceNoticeView")
        UINotify:Get():SendNotification(UINotifyEvent.ActAdvanceNotice_UpdateAnnouncementData, param)
    else
        UINotify:Get():SendNotification(UINotifyEvent.ActAdvanceNotice_UpdateAnnouncementData, param)
    end
end

function FunctionSkipManager:SkipToActProclamation(param)
    QuickTa:Get():TrackEvent(TrackEventNames.events_open, nil,TrackEventType.First,AnalysisType.events_open)
    UIManager:Get():ShowPersistentView("ActProclamationView", CanvasType.FrontCanvas, "ActProclamationView")
    UINotify:Get():SendNotification(UINotifyEvent.ActAdvanceNotice_RefreshTitleState, param)
end

function FunctionSkipManager:SkipToCommonAct(param)
    CommonFestivalDataManager:Get():GetActivityNewState()
end


function FunctionSkipManager:SkipToReturnOldPlayer(param)
    ReturnOldPlayerSubsystem:Get():SendMsg_ReturnBackSignInfo()
end
function FunctionSkipManager:SkipToRaceJcp(param)
    RaceJcpSubsystem:Get():SendMsg_RaceJCPInfo()
    RedPointManager:Get():UpdateValue(RedPointID.RaceJcp,false)
end
function FunctionSkipManager:SkipToRaceXCP(param)
    RaceXCupSubsystem:Get():SendMsg_Info()
    RedPointManager:Get():UpdateValue(RedPointID.RaceXCP,false)
end

function FunctionSkipManager:SkipToLoginTask(param)
    if PlayerDataManager:Get():GetSevenSign() and param==1 then
        LoginTaskSubSystem:Get():SendMsg_GetSignInInfo()
    else
        TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.Day7)
    end
end

function FunctionSkipManager:SkipToMainRankList(param)
    --if  RaceActManager:Get():GetRaceInfo(RaceActId.RaceGVG,false,false) then
    --    RaceGVGSubsystem:Get():SendMsg_GetClubRankList()
    --else
        RankingListSubsystem:Get():SendMsg_RankingListInfo(RankingListType.MainSpeed, 0)
    --end
end

function FunctionSkipManager:SkipToRaceTop(param)
    RaceTopSubsystem:Get():SendMsg_EnterRaceTop(param)
end
function FunctionSkipManager:SkipToRaceTopSuper(param)
    CommonHelper:SetUnlockFunc({ GameFunction.RaceTopSuper },function()
        RaceTopSuperSubsystem:Get():SendMsg_EnterRaceTop(param)
    end)

end
function FunctionSkipManager:PlayAd(param)
    AdsManager:ShowSdk(param,function(type)

    end)
end

function FunctionSkipManager:SkipToWelfare(param)
    WelfareVideoDataManager:Get():RefreshWelfareViewState()
end

function FunctionSkipManager:SkipToRaceTrot(param)
    CommonHelper:SetUnlockFunc({ GameFunction.RaceTrot }, function()
        if RaceActManager:Get():GetRaceInfo(RaceActId.RaceTrot,true) then
            RaceTrotSubsystem:Get():SendMsg_EnterRaceTrot(param)
        else
            UIManager:Get():OpenView("RaceTrotEnterView", CanvasType.MainCanvas, "RaceTrotEnterView")
        end
    end)
end

function FunctionSkipManager:SkipToPopUpGift()
    UIManager:Get():OpenPopup("PopUpGiftView", CanvasType.FrontCanvas, "PopUpGiftView")
end

function FunctionSkipManager:SkipToIllustratedHandbook()
    if not UIManager:Get():IsPersistentViewShow("IllustratedHandbookView") then
        UIManager:Get():ShowPersistentView("IllustratedHandbookView", CanvasType.MainCanvas, "IllustratedHandbookView")
    end
end

function FunctionSkipManager:SkipToFunction(key,param,skipToMain,skipToRaceView,RaceViewForce)
    if skipToMain then
        SkipModuleHelper:ToMainMenuView(false)
    end
    if skipToRaceView then
        SkipModuleHelper:ToRaceView(RaceViewForce,function()
            if self.EvtMap[key] then
                if  self.EvtMap[key].Func then
                    if self.EvtMap[key].class then
                        self.EvtMap[key].Func(self.EvtMap[key].class,param)
                    else
                        self.EvtMap[key].Func(param)
                    end
                end
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NotRequiredSkip))
            end
        end)
    else
        if self.EvtMap[key] then
            if  self.EvtMap[key].Func then
                if self.EvtMap[key].class then
                    self.EvtMap[key].Func(self.EvtMap[key].class,param)
                else
                    self.EvtMap[key].Func(param)
                end
            end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.NotRequiredSkip))
        end
    end
end
