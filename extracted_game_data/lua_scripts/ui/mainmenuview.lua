---@class MainMenu:ViewBase
MainMenuView = class("MainMenuView", ViewBase)

function MainMenuView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "MainMenuAction")
end
local UI_Moudle=true
local _ShowNoUIBtn=1
function MainMenuView:Awake()
    log("---   MainMenu awake")

    self.MINIBtn = CommonHelper:HButtonSetCallback("MINIBtn", self.gameObject, function(hbtn)
        MINIGameSubsystem:Get():SendMsg_MINIGameInfo()
        SceneManager:Get():LoadingMINIGameScene()
    end)

    self.BtnPopUpGift = CommonHelper:HButtonSetCallback("BtnPopUpGift", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.PopUpGift)
    end)

    self.BtnRecruit = CommonHelper:HButtonSetCallback("BtnRecruit", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Recruit)
    end)
    self.BtnFriend = CommonHelper:HButtonSetCallback("BtnFriend", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Friend)
    end)

    self.BtnAnnouncement = CommonHelper:HButtonSetCallback("BtnAnnouncement", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Announcement)
    end)

    CommonHelper:HButtonSetCallback("BtnActProclamation", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.ActProclamation, { 2, 2 })
    end)

    CommonHelper:HButtonSetCallback("BtnLab", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.LabIron)
    end)

    self.TogShop = CommonHelper:HButtonSetCallback("BtnShop", self.gameObject, function(data)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Shop)
    end)

    self.BtnBag = CommonHelper:HButtonSetCallback("BtnBag", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Bag)
    end)

    self.ClubBtn = CommonHelper:HButtonSetCallback("BtnClub", self.gameObject, function(data)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Club)
    end)
    self.BtnFunctionStory = CommonHelper:HButtonSetCallback("BtnFunctionStory", self.gameObject, function(data)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Story)
    end)
    CommonHelper:HButtonSetCallback("BtnSetting", self.gameObject, function(data)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Setting)
    end)
    self.BtnEmail = CommonHelper:HButtonSetCallback("BtnEmail", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Email)
    end)
    ----新科技按钮
    self.BtnTask = CommonHelper:HButtonSetCallback("BtnTask", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Task,{TaskType.Daily,UIModuleID.MainMenu})
    end)
    self.BtnNoviceTask = CommonHelper:HButtonSetCallback("BtnNoviceTask", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Task,{TaskType.Novice,UIModuleID.MainMenu})
    end)
    CommonHelper:HButtonSetCallback("BtnNoviceTaskTips", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Task,{TaskType.Novice,UIModuleID.MainMenu})
    end)

    self.BtnSeasonOrder = CommonHelper:HButtonSetCallback("BtnSeasonOrder", self.gameObject, function(hbtn)
       UIManager:Get():OpenPopup("FoundListView",CanvasType.MainCanvas,"FoundListView")
        --FunctionSkipManager:Get():SkipToFunction(GameFunction.SeasonOrder)
    end)
    self.BtnRaceSuper = CommonHelper:HButtonSetCallback("BtnRaceSuper", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceSuper)
    end)


    self.BtnAccessoryWarehouse = CommonHelper:HButtonSetCallback("BtnAccessoryWarehouse", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.AccessoryWarehouse)
    end)
    CommonHelper:HButtonSetCallback("BtnSpecialTraining", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.SpecialTraining)
    end)
    self.BtnFunctionGarage = CommonHelper:HButtonSetCallback("BtnFunctionGarage", self.gameObject, function(data)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Garbage,UIModuleID.MainMenu)
    end)
    CommonHelper:HButtonSetCallback("BtnTrack", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.SelfTrack)
    end)
    CommonHelper:HButtonSetCallback("BtnActivity", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.PurchasePanel)
    end)
    self.BtnGarageJia=CommonHelper:HButtonSetCallback("BtnGarageJia", self.gameObject, function(hbtn)
        RaceAssembleSubsystem:Get():SendMsg_RaceAssembleInfo()
    end)
    self.BtnUEFA1=CommonHelper:HButtonSetCallback("BtnUEFA1", self.gameObject, function(hbtn)
        ---@type boolean
        ---@type LoginRaceActInfo
        local flag,data=RaceActManager:Get():GetRaceInfo(RaceActId.RaceUEFA,false,false,1)
        RaceFifaSubsystem:Get():SendMsg_GetInfo(data.SeasonId)
    end)
    self.BtnUEFA2=CommonHelper:HButtonSetCallback("BtnUEFA2", self.gameObject, function(hbtn)
        ---@type boolean
        ---@type LoginRaceActInfo
        local flag,data=RaceActManager:Get():GetRaceInfo(RaceActId.RaceUEFA,false,false,2)
        RaceFifaSubsystem:Get():SendMsg_GetInfo(data.SeasonId)
    end)

    --CommonHelper:HButtonSetCallback("BtnActAdvanceNotice", self.gameObject, function(hbtn)
    --    FunctionSkipManager:Get():SkipToFunction(GameFunction.ActAdvanceNotice)
    --end)
    self.BtnCommonAct = CommonHelper:HButtonSetCallback("BtnCommonAct", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.CommonAct)
    end)
    self.BtnReturnOldPlayer = CommonHelper:HButtonSetCallback("BtnReturnOldPlayer", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.ReturnOldPlayer)
    end)
    self.BtnRaceJCP =  CommonHelper:HButtonSetCallback("BtnRaceJCP", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceJcp)
    end)
    self.BtnRaceXCP =  CommonHelper:HButtonSetCallback("BtnRaceXCP", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceXCP)
    end)
    CommonHelper:HButtonSetCallback("btnLogin", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.LoginTask)
    end)
    CommonHelper:HButtonSetCallback("BtnRankList", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.MainRankList)
    end)
    self.BtnRaceTop = CommonHelper:HButtonSetCallback("BtnRaceTop", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceTop)
    end)
    self.BtnRaceTopSuper = CommonHelper:HButtonSetCallback("BtnRaceTopServer", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.RaceTopSuper)
    end)
    self.BtnWelfare=  CommonHelper:HButtonSetCallback("BtnWelfare", self.gameObject, function(hbtn)
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Welfare)
    end)
    self.BtnRace=CommonHelper:HButtonSetCallback("BtnRace", self.gameObject, function(data)
        SkipModuleHelper:Get():ToRaceView(false)
    end)
    self.BtnVideo=CommonHelper:HButtonSetCallback("BtnVideo", self.gameObject, function(data)
        CommonHelper:PlayPopupVideoByUrl()
    end)
    CommonHelper:HButtonSetCallback("BtnAdReward", self.gameObject, function(data)
        AdRewardSubsystem:Get():SendMsg_GetAdRewardList()
    end)
    self.GMBtn = CommonHelper:HButtonSetCallback("GMBtn", self.gameObject, function(hbtn)
        UIManager:Get():OpenView("GMView", CanvasType.MainCanvas)
    end)
    CommonHelper:SetHButtonEnable(self.GMBtn, GameProperties.GMEnable)
    CommonHelper:HButtonSetCallback("LocalBattle", self.gameObject, function(hbtn)
        CommonHelper:PlayLevelBattle()
    end)
    self.BtnBtnKp=CommonHelper:HButtonSetCallback("BtnKp", self.gameObject, function(hbtn)
        MonoHelper.SwitchToKpGame(true)
    end)

    self.BtnNoUI1=CommonHelper:HButtonSetCallback("BtnNoUI1", self.gameObject, function(hbtn)
        UI_Moudle=not UI_Moudle
        self:CloseAllUI(UI_Moudle)
    end)

    self.BtnNoUI2=CommonHelper:HButtonSetCallback("BtnNoUI2", self.gameObject, function(hbtn)
        UI_Moudle=not UI_Moudle
        self:CloseAllUI(UI_Moudle)
    end)

    self.BtnStrengthAct = CommonHelper:HButtonSetCallback("BtnStrengthAct", self.gameObject, function(hbtn)
        StrengthActivityManager:Get():OpenActivity(CapyActivityType.Strength,StrengthActivityType.Shop)
    end)
    self.BtnGachaAct = CommonHelper:HButtonSetCallback("BtnGachaAct", self.gameObject, function(hbtn)
        StrengthActivityManager:Get():OpenActivity(CapyActivityType.Recruit)
    end)

    CommonHelper:HButtonSetCallback("BtnNoUIBack", self.gameObject, function(hbtn)
        UI_Moudle=not UI_Moudle
        self:CloseAllUI(UI_Moudle)
    end)
    self.BtnBind=CommonHelper:HButtonSetCallback("BtnBind", self.gameObject, function(hbtn)
        PlayerInfoSubsystem:Get():SendMsg_GetBindInfo()
    end)
    self.BtnTestGift = CommonHelper:HButtonSetCallback("BtnTestGift", self.gameObject, function(data)
        local boxfunc = function()
            local str = CommonHelper:GetTempStr_Default(TemplateStringID.TestGiftText)
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
            if ret == MessageBoxHelp.BtnType.OK then
                CommonSubsystem:Get():SendMsg_TestGift()
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    end)

end

function MainMenuView:SetBannerScroll()
    self.BannerScroll = UIUtil.GetTypeChildWightByParent("CarouselScrollView_Loop", self.gameObject, typeof(CarouselScrollView))

    CommonHelper:SetGameObjectActive("newbiebtn",self.gameObject,CommonHelper:CheckPlayerIsNewGuide())
    CommonHelper:SetGameObjectActive("CarouselScrollView_Loop",self.gameObject,not CommonHelper:CheckPlayerIsNewGuide())
    local dataList={}
    if PlayerDataManager:Get():GetSevenDayTask() or PlayerDataManager:Get():GetSevenSign() then
        table.insert(dataList,"LoginTaskView")
    end
    local welfareActive = MenuListManager:Get():GetMenuState("welfare") and HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnWelfare)
    --
    --if welfareActive then
    --    table.insert(dataList,"WelfareView")
    --end
    --
    if UserFirstGiftManager:Get():GetIsFirstShow() then
        table.insert(dataList,"FirstBuyView")
    end
    CommonHelper:CSGameObjectSetActive(self.BtnWelfare.gameObject,welfareActive)
    if welfareActive==false then
        RedPointManager:Get():UpdateValue(RedPointID.S_MonthSign,false)
        RedPointManager:Get():UpdateValue(RedPointID.S_FreePower,false)
    end
    self.ScrollRect= UIUtil.GetGameobjectComponent(self.BannerScroll.gameObject,typeof(ScrollRect))
    self.TempScrollRectH,self.TempScrollRectV=CommonHelper:ScrollViewEnableDrag(self.ScrollRect,true,false )
    CommonHelper:SetGameObjectActive("BannerScrollParent",self.gameObject,true)
    if #dataList>1 then
        _ShowNoUIBtn=1
        CommonHelper:SetGameObjectActive("BtnNoUI1",self.gameObject,true)
        CommonHelper:SetGameObjectActive("BtnNoUI2",self.gameObject,false)
        CommonHelper:InitCarouselScrollView(self.BannerScroll, #dataList, 5,function(dataIndex, itemObj, scroll)
            self:SetBannerItem(dataList,dataIndex+1, itemObj, self.BannerScroll)
        end)
    elseif #dataList == 1 then
        _ShowNoUIBtn=1
        CommonHelper:SetGameObjectActive("BtnNoUI1",self.gameObject,true)
        CommonHelper:SetGameObjectActive("BtnNoUI2",self.gameObject,false)
        CommonHelper:InitCarouselScrollView(self.BannerScroll, #dataList, nil,function(dataIndex, itemObj, scroll)
            self:SetBannerItem(dataList,dataIndex+1, itemObj, self.BannerScroll)
        end)
        self.TempScrollRectH,self.TempScrollRectV=CommonHelper:ScrollViewEnableDrag(self.ScrollRect,false,false)
    else
        CommonHelper:SetGameObjectActive("BannerScrollParent",self.gameObject,false)
        _ShowNoUIBtn=2
        CommonHelper:SetGameObjectActive("BtnNoUI1",self.gameObject,false)
        CommonHelper:SetGameObjectActive("BtnNoUI2",self.gameObject,true)

    end
end

function MainMenuView:SetBannerItem(dataList,dataIndex, itemObj, scroll)
    if dataList[dataIndex]=="LoginTaskView" then
        CommonHelper:SetGameObjectActive("logintaskbanner",itemObj,true)
        CommonHelper:SetGameObjectActive("welfarebanner",itemObj,false)
        CommonHelper:SetGameObjectActive("firstbuybanner",itemObj,false)

        CommonHelper:HButtonSetCallback("Btn", itemObj, function(hbtn)
            FunctionSkipManager:Get():SkipToFunction(GameFunction.LoginTask,1)
            UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"LoginTaskView",true})
        end)
    elseif dataList[dataIndex]=="WelfareView"  then
        CommonHelper:SetGameObjectActive("logintaskbanner",itemObj,false)
        CommonHelper:SetGameObjectActive("firstbuybanner",itemObj,false)
        CommonHelper:SetGameObjectActive("welfarebanner",itemObj,true)
        CommonHelper:HButtonSetCallback("Btn", itemObj, function(hbtn)
            UIManager:Get():OpenView("WelfareView", CanvasType.MainCanvas, "WelfareView")
        end)
    elseif dataList[dataIndex]=="FirstBuyView"  then
        CommonHelper:SetGameObjectActive("logintaskbanner",itemObj,false)
        CommonHelper:SetGameObjectActive("welfarebanner",itemObj,false)
        CommonHelper:SetGameObjectActive("firstbuybanner",itemObj,true)
        CommonHelper:HButtonSetCallback("Btn", itemObj, function(hbtn)
            UIManager:Get():ShowPersistentView("ActivityFirstBuyView", CanvasType.FrontCanvas, "ActivityFirstBuyView")
            UINotify:Get():SendNotification(UINotifyEvent.ActivityFirstBuyView_InitViewInfo,false)
            UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"ActivityFirstBuyView",true})
        end)
    end
end
function MainMenuView:SetNoviceTaskTips()
    CommonHelper:SetHButtonClick(self.BtnNoviceTask,TaskDataManager:Get():GetNoviceFlag(),true)
    if TaskDataManager:Get():GetNoviceFlag() then
        local taskId=TaskDataManager:Get():GetMainMenuViewTaskId()
        ---@type dictmission_config_cell
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.task_config,taskId)
        local taskTips=CommonHelper:SetGameObjectActive("tasktips",self.gameObject,cfg~=nil)
        if cfg then
            self.TipCoroutine= cs_coroutine.start(function()
                CommonHelper:Tween_PlayerTweenScaleByParent("tasktipsback",self.BtnNoviceTask.gameObject,Vector3(0,1,1),Vector3(1,1,1),0.04,0)
                CommonHelper:Tween_PlayerTweenPositionByParent("RedPoint1Welfare",self.BtnNoviceTask.gameObject,Vector3(144,-18,0),Vector3(456,0,0),0.04,0.6)
                coroutine.yield(CS.UnityEngine.WaitForSeconds(15))
                CommonHelper:Tween_PlayerTweenScaleByParent("tasktipsback",self.BtnNoviceTask.gameObject,Vector3(1,1,1),Vector3(0,1,1),0.04,0)
                CommonHelper:Tween_PlayerTweenPositionByParent("RedPoint1Welfare",self.BtnNoviceTask.gameObject,Vector3(456,0,0),Vector3(144,-18,0),0.08,0)
                self.TipCoroutine=nil
            end)
            CommonHelper:SetText("###tasktittle",taskTips,CommonHelper:GetTempStr_Default(TemplateStringID.MainTaskTipsTittle,CommonHelper:GetTempStr_Default(cfg.missionname)))
            CommonHelper:SetText("###taskdesc",taskTips,CommonHelper:GetTempStr_Default(cfg.missionmemo))
        end
    end
end
function MainMenuView:SetNewBieShowBtn()
   CommonHelper:SetGameObjectActive("BtnGroupLeft",self.gameObject,not CommonHelper:CheckPlayerIsNewGuide())
   CommonHelper:SetGameObjectActive("BtnGroupRight",self.gameObject,not CommonHelper:CheckPlayerIsNewGuide())
   CommonHelper:SetGameObjectActive("LeftBannerView",self.gameObject,not CommonHelper:CheckPlayerIsNewGuide())
   CommonHelper:SetGameObjectActive("fxroot2222",self.gameObject,not CommonHelper:CheckPlayerIsNewGuide())
    if CommonHelper:CheckPlayerIsNewGuide() then
        CommonHelper:SetGameObjectActive("BtnNoUI1",self.gameObject,false)
        CommonHelper:SetGameObjectActive("BtnNoUI2",self.gameObject,false)
    end
end

function MainMenuView:SetScene()
    local port = CommonHelper:CameraPortUIFit("CameraUIFit", self.gameObject)
    SceneHomeManager:Get():SetMainCitySceneValue()
    if MainCitySceneValue==SceneChangeID.MainCity then
        HomeSceneHelper:SetMainCity(port)
    end
    if MainCitySceneValue==SceneChangeID.MainCity_New then
        HomeSceneHelper:SetMainCity_New(port)
    end
    if MainCitySceneValue==SceneChangeID.MainCity_Autumn then
        HomeSceneHelper:SetMainCityAutumn(port)
    end
    if MainCitySceneValue==SceneChangeID.MainCity_NewNight then
        HomeSceneHelper:SetMainCity_NewNight(port)
    end

end


function MainMenuView:OnOpen()
    UI_Moudle=true
    self:CloseAllUI(UI_Moudle)
    --PersonalHomeSubsystem:Get():SendLookHomeInfo(PlayerDataManager:Get():GetPlayerRID())
    self:SetScene()
    self:InitBtnInfo()
    self:SetCar()
    self.mainChat = CommonHelper:InitMainChat(ChatType.World, self.gameObject, UIModuleID.MainMenu)

    self:RefreshFirstBuyRedPoint()
    self:RefreshTestGiftBtn()
    self:SetBannerScroll()
    self:SetNoviceTaskTips()
    self:SetNewBieShowBtn()
    self:UpdatePopupGift()
    self:UpdateBoxAwardRedPointState()
    self:SetBtnState()
end
function MainMenuView:ReOpen()
    self:SetScene()
    PopupManager:Get():SetIsCheckRallyPopup(true)
    self:SetCar()
    self:SetBannerScroll()
    self:RefreshFirstBuyRedPoint()
    self:SetNoviceTaskTips()
    self:SetNewBieShowBtn()
    self:ReOpenView()
    self:UpdatePopupGift()
    self:UpdateBoxAwardRedPointState()
    self:RefreshTestGiftBtn()
    self:SetBtnState()
end
function MainMenuView:SetBtnState()
    self:RefreshGarageRedPoint()
    self:RefreshCommonActBtn()
    self:RefreshStrengthSprintActBtn()
    self:RefreshReturnOldPlayerBtn()
    CommonHelper:SetHButtonClick(self.MINIBtn, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.MiniGame), true)
    CommonHelper:SetHButtonClick(self.BtnBind, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.GameBind), true)
    CommonHelper:SetHButtonClick(self.BtnBtnKp,HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.ShowCovert),true)
    CommonHelper:SetHButtonClick(self.BtnSeasonOrder, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.SeasonOrder), true)
    CommonHelper:SetHButtonClick(self.BtnRaceSuper, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnRaceSuper) and RaceActManager:Get():GetRaceInfo(RaceActId.RaceSuperBattle) and PlayerDataManager:Get():GetPlayerServerID()~=171, true)
    CommonHelper:SetHButtonClick(self.BtnAccessoryWarehouse, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Warehouse), true)
    CommonHelper:SetHButtonClick(self.BtnVideo, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnVideo), true)
    CommonHelper:SetHButtonClick(self.BtnRaceTop, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.RaceTop) and RaceActManager:Get():GetRaceInfo(RaceActId.RaceTop) , true)
    CommonHelper:SetHButtonClick(self.BtnRaceTopSuper, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnRaceTopSuper) and RaceActManager:Get():GetRaceInfo(RaceActId.BtnRaceTopSuper) , true)
    CommonHelper:SetHButtonClick(self.BtnRaceJCP, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.RaceJCP) and RaceActManager:Get():GetRaceInfo(RaceActId.RaceJcp), true)
    CommonHelper:SetHButtonClick(self.BtnRaceXCP, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.RaceXCP) and RaceActManager:Get():GetRaceInfo(RaceActId.RaceXCP), true)
    CommonHelper:SetHButtonClick(self.BtnUEFA1, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnUEFA) and RaceActManager:Get():GetRaceInfo(RaceActId.RaceUEFA,false,false,1), true)
    CommonHelper:SetHButtonClick(self.BtnUEFA2, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnUEFA) and RaceActManager:Get():GetRaceInfo(RaceActId.RaceUEFA,false,false,2), true)
    CommonHelper:SetHButtonClick(self.BtnGarageJia, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnGarageJia) and RaceActManager:Get():GetRaceInfo(RaceActId.RaceAssemble), true)
    CommonHelper:SetHButtonClick(self.BtnAdReward, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.BtnAdReward) , true)
    --CommonHelper:SetHButtonClick(self.RaceAssembleAdd, VersionManager:Get():GetServerFunctionIsFlag(CdnFunctionKey.RaceAssembleAdd) and RaceActManager:Get():GetRaceInfo(RaceActId.RaceAssembleAdd), true)

end
function MainMenuView:ReOpenView()
    if self:GetLuaViewInfo("Check")==false then
        return
    end
    if self:GetLuaViewInfo("GuideCheck")==false then
        return
    end
    if self:GetLuaViewInfo("ActivityFirstBuyView") then
        UIManager:Get():ShowPersistentView("ActivityFirstBuyView", CanvasType.FrontCanvas, "ActivityFirstBuyView")
        UINotify:Get():SendNotification(UINotifyEvent.ActivityFirstBuyView_InitViewInfo,false)
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"ActivityFirstBuyView",true})
    end
    if self:GetLuaViewInfo("LoginTaskView") then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.LoginTask,LoginTaskDataManager:Get():GetBtnFlag())
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"LoginTaskView",true})
    end
    if self:GetLuaViewInfo("SeasonOrderView") then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.SeasonOrder)
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"SeasonOrderView",true})
    end
end

function MainMenuView:OnOpenAnimEnd()
    if not CommonHelper:CheckPlayerIsNewGuide() then
        PopupManager:Get():PopupFirstInitPopup()
    else
        PopupManager:Get():Clear()
    end
    PopupManager:Get():PopRallyPopupView()
    self:CheckNewBieGuide()
    ActivitySubsystem:Get():ReloadCharge(PlayerDataManager:Get().ReChargeList)
    PlayerDataManager:Get().ReChargeList = nil
end

function MainMenuView:OnClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    self:ClearLuaViewInfo()
    if  self.TipCoroutine then
        cs_coroutine.stop(self.TipCoroutine)
        self.TipCoroutine=nil
    end
    if self.popUpGiftCountdown ~= nil then
        cs_coroutine.stop(self.popUpGiftCountdown)
        self.popUpGiftCountdown = nil
    end
    UI_Moudle=true
    self:CloseAllUI(UI_Moudle)
end
function MainMenuView:OnAutoClose()
    HomeSceneCarMeshHelper:Get():ClearCache()
    HomeSceneHelper:SetDefaultScene()
    if  self.TipCoroutine then
        cs_coroutine.stop(self.TipCoroutine)
        self.TipCoroutine=nil
    end
    if self.popUpGiftCountdown ~= nil then
        cs_coroutine.stop(self.popUpGiftCountdown)
        self.popUpGiftCountdown = nil
    end
    if self.fastestTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.fastestTimerID)
    end
    UI_Moudle=true
    self:CloseAllUI(UI_Moudle)
end
function MainMenuView:SetCar()
    print("主页面展示车")

    local Car = CarDataManager:Get():GetCarDataByIndex(PlayerPrefsHelper:GetValue_MainMenuViewCarIndex())
    HomeSceneCarMeshHelper:Get():SetDataByCarData(Car, MainCitySceneValue, AnimateType.MainCity)


end
function MainMenuView:InitBtnInfo()
    self:SetBannerScroll()
end

function MainMenuView:UpdateChatText(chatType, playerId)
    self.mainChat:InitChatList(chatType, playerId)
end

function MainMenuView:InitMainChatInfo()
    self.mainChat:CacheData()
end

function MainMenuView:RefreshGarageRedPoint()
    RedPointManager:Get():UpdateValue(RedPointID.Garage)
end

function MainMenuView:RefreshFirstBuyRedPoint()
    RedPointManager:Get():UpdateValue(RedPointID.LoginActivity_Login)
    RedPointManager:Get():UpdateValue(RedPointID.Activity_FirstBuy)
    RedPointManager:Get():UpdateValue(RedPointID.PlayerLevelReward)
end

function MainMenuView:RefreshCommonActBtn()
    local activityData = CommonFestivalDataManager:Get():GetAllDataIDTab()
    CommonHelper:SetGameObjectActive("BtnCommonAct", self.gameObject, #activityData > 0 and HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.LimitActivity) )
    if UIManager:Get():IsPopViewShow("CommonNewActView") then
        FunctionSkipManager:Get():SkipToFunction(GameFunction.CommonAct)
    end

end

function MainMenuView:RefreshStrengthSprintActBtn()
    local isShow = StrengthActivityManager:Get():CheckBtnIsShow(CapyActivityType.Strength)
    local btn = CommonHelper:SetGameObjectActive("BtnStrengthAct", self.gameObject, isShow )
    if isShow then
        CommonHelper:SetText("###ActText", btn.gameObject, CommonHelper:GetTempStr_Default(StrengthActivityManager:Get():GetActivityDataByType(CapyActivityType.Strength).Cfg.actname))
    end
    isShow = StrengthActivityManager:Get():CheckBtnIsShow(CapyActivityType.Recruit)
    btn = CommonHelper:SetGameObjectActive("BtnGachaAct", self.gameObject, isShow )
    if isShow then
        CommonHelper:SetText("###ActText", btn.gameObject, CommonHelper:GetTempStr_Default(StrengthActivityManager:Get():GetActivityDataByType(CapyActivityType.Recruit).Cfg.actname))
    end
end

function MainMenuView:RefreshReturnOldPlayerBtn()
    CommonHelper:SetGameObjectActive("BtnReturnOldPlayer", self.gameObject, ReturnOldPlayerDataManager:Get():GetReturnState() and HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.ReturnOldPlayer))
end

function MainMenuView:RefreshTestGiftBtn()
    local testGiftFlag = PlayerDataManager:Get():GetTestGiftFlag()
    CommonHelper:SetGameObjectActive("BtnTestGift", self.gameObject, testGiftFlag)
end

function MainMenuView:CloseAllUI(flag)
    UIUtil.ShowCanvasGroupByName("Center", self.gameObject, flag)
    CommonHelper:SetGameObjectActive("BtnNoUI1",self.gameObject,flag and _ShowNoUIBtn==1)
    CommonHelper:SetGameObjectActive("BtnNoUI2",self.gameObject,flag and _ShowNoUIBtn==2)
    CommonHelper:SetGameObjectActive("BtnNoUIBack",self.gameObject,not flag)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_CloseUI,flag)
end


function MainMenuView:OnBackKey()
    if UIManager:Get():IsPersistentViewShow("AnnouncementView") then
        return
    end
    print("主页面按下了返回键")
    if UIManager:Get():GetTopPopViewName() ~= "" then
        if UIManager:Get():GetTopPopStackView().IsViewShow then
            return
        end
    end
    if UIManager:Get():IsPersistentViewShow("NewbieGuideView") then
        return
    end

    if UIManager:Get():GetTopViewName() == self.gameObject.name then
        if UnifySDKManager:Get():IAccount():CanQuitGame() then
            UnifySDKManager:Get():IAccount():QuitGame()
        else
            local boxfunc = function()
                local str = CommonHelper:GetTempStr_Default(TemplateStringID.MakeSureToQuitTheGame)
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, str)
                if ret == MessageBoxHelp.BtnType.OK then
                    HotfixHelper:ApplicationQuit()
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
        end
    end
end

function MainMenuView:UpdatePopupGift()
    local list = PopUpGiftDataManager:Get():GetActivePopUpGiftDataList()
    ---@type PopUpGiftData
    self.popUpGiftData = nil
    for _, data in pairs(list) do
        if self.popUpGiftData == nil  then
            self.popUpGiftData = data
        elseif self.popUpGiftData:GetEndTime() > data:GetEndTime() then
            self.popUpGiftData = data
        end
    end
    CommonHelper:SetHButtonClick(self.BtnPopUpGift, self.popUpGiftData~=nil,true)
    if self.popUpGiftData ~= nil then
        self:CountDownTime()
    end
end

function MainMenuView:CountDownTime()
    if self.popUpGiftCountdown == nil then
        self.popUpGiftCountdown = cs_coroutine.start(function()
            while self.popUpGiftData and self.popUpGiftData:IsActive() do
                local subTime = math.abs(CommonHelper:SubTime(self.popUpGiftData:GetEndTime() * 1000))
                local totalSecond = subTime * 0.001
                local _hour = math.floor(totalSecond / TimeSecond_Hour)
                local _minute = math.floor(totalSecond / TimeSecond_Minute) - _hour * 60
                local _second = math.floor(totalSecond - _hour * TimeSecond_Hour - _minute * TimeSecond_Minute)
                local time = CommonHelper:TransferTimeToString({hour=_hour,minute=_minute,second=_second,milliSecond=0},false)
                local timestr = string.format("%s:%s:%s", time.hour, time.minute, time.second)
                CommonHelper:SetText("###PopUpGiftDataContent", self.gameObject, timestr)
                coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
            end
            self.popUpGiftCountdown = nil
            self:UpdatePopupGift()
        end)
    end
end

function MainMenuView:UpdateBoxAwardRedPointState()
    WelfareBoxDataManager:Get():SetBoxAwardFastestTime()
    local fastestData = WelfareBoxDataManager:Get():GetBoxAwardFastestTime()
    local redState = RedPointManager:Get():GetValue(RedPointID.S_WelfareBoxAwardState)

    if self.fastestTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.fastestTimerID)
    end

    if fastestData and redState == false then

        self.fastestTimerID = TimerManager:Get():CreateTimerLoop(1, function()
            local differenceValueTime = fastestData:GetOpenTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - 1
            if differenceValueTime <= 0 then
                if self.fastestTimerID ~= 0 then
                    TimerManager:Get():StopTimer(self.fastestTimerID)
                end
                RedPointManager:Get():UpdateValue(RedPointID.S_WelfareBoxAwardState, true)
            end
        end, nil, true)

    end
end
