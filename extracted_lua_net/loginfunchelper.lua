---@class LoginFuncHelper
LoginFuncHelper = class("LoginFuncHelper")
local _GameState = -1
---登出操作，断线，10次内连接成功
function LoginFuncHelper:LoginOut_QuickReconnect()

    --LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, false)
    if PlayerDataManager:Get():GetPlayerRID()~=0 then
        ClientDataManager:Get():SetGameState(GameState.Reconnecting)
        NetManager:Get():SetGameLogoutType(LogoutType.Reconnect)
        ----  ClientDataManager:Get():LogoutClearRes()
        ClientDataManager:Get():Logout()
        LoginSubSystem:Get():Send_ReContentServer()

    end

end
local OpenGameStartDone = nil
---@param isNeedLogOut boolean 是否需要sdk登出
function LoginFuncHelper:LoginOut_GameBackToLogin_Combine(isNeedLogOut, isExitGame, action, isLogin)
    OpenGameStartDone = action or nil
    isLogin = (isLogin == nil or isLogin == true)
    if isNeedLogOut then
        if UnifySDKManager:Get():IAccount() then
            UnifySDKManager:Get():IAccount():Logout()
        end
    end
    if UIManager:Get():IsViewShow("GameStartView") or UIManager:Get():IsViewShow("LoginView") then
        if UIManager:Get():IsPersistentViewShow("LoadingView") then
            CommonHelper:CloseLoading()
        end
        UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitCG, false)
        if not isNeedLogOut then
            UINotify:Get():SendNotification(UINotifyEvent.GameStartView_CloseLoginPanelCG,false)
        end
        UINotify:Get():SendNotification(UINotifyEvent.ScreenEffectView_StopAllTimer)
        if action then
            action()
        end
        return
    end
    SceneHomeManager:Get():RecycleScenePrefab()
    ClientDataManager:Get():SetGameState(GameState.LoginOut)
    if isExitGame then
        LoginSubSystem:Get():SendMsg_ExitGame()
    end
    NetManager:Get():SetGameServerLogout()
    NetManager:Get():DisconnetAll()
    LoginFuncHelper:LoginOut_GameBackToLoginSDK(isLogin)
    end

---登出操作，断线，返回登录界面
function LoginFuncHelper:LoginOut_GameBackToLoginSDK(isLogin)
    SceneManager:Get():BreakLoading()
    ClientDataManager:Get():SetGameState(GameState.LoginOut)
    NetManager:Get():SetGameLogoutType(LogoutType.BackToLogin)
   -- HVersionManager:SetHotFixDone(false)
    if SceneManager:Get():GetCurrentSceneId() ~= MainCityRes then
        SceneManager:Get():LoadingMainCity(LoadingMainCityType.BattleToGameStart,isLogin,true)
        BattleDataManager:Get():LogoutToLoginView()
    else
        LoginFuncHelper:LogoutClearRes(isLogin)
    end
end
function LoginFuncHelper:LogoutClearRes(isLogin)
    UINotify:Get():SendNotification(UINotifyEvent.ScreenEffectView_StopAllTimer)
    CommonHelper:PlayScreenEffectWhite(2,nil,nil,1.5)
   -- local isLogin= QuickSdkDataManager:Get():GetIsLogin()
    LoginFuncHelper:LoginOut_CloseView()
    ClientDataManager:Get():LogoutClearRes()
    ClientDataManager:Get():Logout()
    ClientDataManager:Get():ClearAccountData()
    UnifySDKHelper:Account_Login(isLogin)
end
function LoginFuncHelper:LoginOut_CloseView()
    LogoutClearManager:Get():Logout()
    CameraStackHelper:SetUIDefaultGroup()
    UIManager:Get():CloseAllPopups()
    UIManager:Get():CloseAllViews()
    CommonHelper:CloseLoading()
    GuideManager:Get():Break()
    RaceRoomManager:Get():ClearData()
    RaceRankManager:Get():ClearData()
    --UIManager:Get():OpenView("GameStartView", CanvasType.FrontCanvas, "GameStartView")
    if OpenGameStartDone then
        OpenGameStartDone()
        OpenGameStartDone = nil
    end
end

---登出操作，断线，返回登录界面,绑定账号
--function LoginFuncHelper:LoginOut_BindGuest()
--    if NetEaseDataManager:Get():GetIsLogin() then
--        NetManager:Get():SetGameLogoutType(LogoutType.BackToLogin)
--    end
--    LoginFuncHelper:LoginOut_CloseView()
--end

function LoginFuncHelper:EnterGame()

    local entertype = NetManager:Get():GetGameEnterType()
    log("---   进入游戏 type = ", entertype)
    if entertype == GameEnterType.AppStart then
        QuickTa:Get():TrackEvent(TrackEventNames.EnterGame_AppStart, nil,TrackEventType.First,AnalysisType.EnterGame_AppStart)
        LoginFuncHelper:EnterGame_AppStart()
    end
    if entertype == GameEnterType.QucikReconnect then
        LoginFuncHelper:EnterGame_QuickReconnect()
    end
    if entertype == GameEnterType.BackToLogin then
        LoginFuncHelper:EnterGame_GameBackToLogin()
    end
end

--{{{ 进入游戏
---app启动进入游戏
function LoginFuncHelper:EnterGame_AppStart()
    UIManager:Get():CloseView()
    LoginFuncHelper:EnterScene()
end

---断线重连连接成功，10次内连接成功，进入游戏
function LoginFuncHelper:EnterGame_QuickReconnect()
    LoginFuncHelper:EnterScene()
end

---重新返回登录界面，进入游戏
function LoginFuncHelper:EnterGame_GameBackToLogin()
    UIManager:Get():CloseView()
    LoginFuncHelper:EnterScene()
end
--}}}



--{{{ 进入场景
function LoginFuncHelper:EnterScene()
    local entertype = NetManager:Get():GetGameEnterType()
    log("---   #####################   test    111 = ", entertype)
    if entertype == GameEnterType.AppStart then
        QuickTa:Get():TrackEvent(TrackEventNames.EnterScene_AppStart, nil,TrackEventType.First,AnalysisType.EnterScene_AppStart)
        LoginFuncHelper:EnterScene_AppStart()
    end
    if entertype == GameEnterType.QucikReconnect then
        LoginFuncHelper:EnterScene_QuickReconnect()
    end
    if entertype == GameEnterType.BackToLogin then
        LoginFuncHelper:EnterScene_GameBackToLogin()
    end
end

---app启动进入场景
function LoginFuncHelper:EnterScene_AppStart()

    log("---   app启动进入场景")
    LoginFuncHelper:AdvanceLoad()
    --NetEaseDataManager:Get():SetIsLogin(true)
    QuickSdkDataManager:Get():SetIsLogin(true)

    TeamCacheManager:Get():InitData()

    if RaceRankManager:Get():ReEnterBattle() then
        return
    end
    if RaceTopManager:Get():ReEnterBattle() then
        return
    end
    if RaceTopSuperManager:Get():ReEnterBattle() then
        return
    end

    if RaceJcpManager:Get():ReEnterBattle() then
        return
    end
    if RaceTrotManager:Get():ReEnterBattle() then
        return
    end

    if RaceRoomManager:Get():ReEnterBattle() then
        return
    end
    if RaceClub3V3Manager:Get():ReFight() then
        return
    end
   if RaceGVGManager:Get():ReFight() then
        return
    end
    SceneManager:Get():FirstLoadingMainCity()
end

---断线重连连接成功，10次内连接成功，进入场景
function LoginFuncHelper:EnterScene_QuickReconnect()
    log("---   10次内连接成功，进入场景")

end
function LoginFuncHelper:EnterServer_ContentGameServer()
    if ClientDataManager:Get():GetIsNew() then
        LoginFuncHelper:PlayerVideoCreateUser(function()
            LoginFuncHelper:EnterGame()
        end)
    else

    end
end

---重新返回登录界面，进入场景
function LoginFuncHelper:EnterScene_GameBackToLogin()
    log("---   重新返回登录界面，进入场景")

    TeamCacheManager:Get():InitData()
    if RaceRankManager:Get():ReEnterBattle() then
        return
    end
    if RaceTopManager:Get():ReEnterBattle() then
        return
    end
    if RaceTopSuperManager:Get():ReEnterBattle() then
        return
    end
    if RaceJcpManager:Get():ReEnterBattle() then
        return
    end
    if RaceTrotManager:Get():ReEnterBattle() then
        return
    end
    if RaceRoomManager:Get():ReEnterBattle() then
        return
    end
    if RaceClub3V3Manager:Get():ReFight() then
        return
    end
    if RaceGVGManager:Get():ReFight() then
        return
    end
    SceneManager:Get():LoadingMainCity()
end

--}}}

---{{{  登录成功初始化数据
---@param msg SC_LoginSuccess
function LoginFuncHelper:EnterMainCity(msg)

    -- print("玩家数据",ProtoMsgHelp.block(msg.userinfo))
    -- print("玩家头像数据",ProtoMsgHelp.block(msg.myHeads))
    -- print("道具数据",ProtoMsgHelp.block(msg.myProps))
    -- print("配件数据",ProtoMsgHelp.block(msg.myParts))
    -- print("功能数据",ProtoMsgHelp.block(msg.menulist))
    -- print("时间",msg.serverTime)
    -- print("车数据",ProtoMsgHelp.block(msg.myCars))
    -- print("邮件数据",ProtoMsgHelp.block(msg.maillist))
    -- print("主线任务数据",ProtoMsgHelp.block(msg.myMainTask))
    -- print("聊天数据",ProtoMsgHelp.block(msg.myTalks))
    -- print("自建赛道数据",ProtoMsgHelp.block(msg.myTrack))
    -- print("补单数据",ProtoMsgHelp.block(msg.myReloadCharge))
    -- print("首冲数据",ProtoMsgHelp.block(msg.myActFirst))
    -- print("直购数据",ProtoMsgHelp.block(msg.myDirect))
     print("当前活动数据",ProtoMsgHelp.block(msg.nowOpenActs))
    if ClientDataManager:Get():GetIsNew() then
        CommonHelper:SendAdJustToken(TrackEventNames.end_race,AnalysisType.end_race)
        QuickTa:Get():TrackEvent(TrackEventNames.end_race, nil,TrackEventType.First,AnalysisType.end_race)
    end
    UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0.3)
    CommonHelper:SetServerTime(msg.serverTime)
    ClientDataManager:Get():InitLoginConfig()
    PlayerDataManager:Get():InitPlayData(msg.userinfo)
    PlayerDataManager:Get():SetTestGiftFlag(msg.testGiftFlag)
    PlayerDataManager:Get():SetHeadList(msg.myHeads)
    PlayerDataManager:Get():InitReChargeList(msg.myReloadCharge)

    UserDirectManager:Get():SetUserDirectData(msg.myDirect)
    UserFirstGiftManager:Get():SetUserFirstGiftData(msg.myActFirst)
    CommonFestivalDataManager:Get():InitDataIDTab(msg.nowOpenActs,msg.dictActBase)
    WelfareBoxDataManager:Get():InitBoxAwardData(msg.myBoxs)
    ReturnOldPlayerDataManager:Get():InitReturnState(msg.userinfo.rebackfalg)
    ReturnOldPlayerDataManager:Get():InitReturnEmailData(msg)
    StrengthActivityManager:Get():SetCurActivityData(msg.capyActives)


    RedPointManager:Get():InitMenuList(msg.menulist)
    NetManager:Get():SendDurationEvent()
    ClientDataManager:Get():SetServerStartTime(msg.startTime)

    
    EmailDataManager:Get():InitEmailListData(msg.maillist)
    RaceRankManager:Get():CheckBattle(msg.refight)
    RaceJcpManager:Get():CheckBattle(msg.refight)
    RaceClub3V3Manager:Get():SetReFight(msg.refight)
    RaceTrotManager:Get():CheckBattle(msg.refight)
    RaceTopManager:Get():CheckBattle(msg.refight)
    RaceTopSuperManager:Get():CheckBattle(msg.refight)
    RaceGVGManager:Get():CheckBattle(msg.refight)
    RedPointManager:Get():UpdateServer(msg.curRedInfo)
    RaceActManager:Get():Init(msg.curRedInfo.fights)
    TaskDataManager:Get():InitNoviceTask(msg.myTradeTask)
    TaskDataManager:Get():SetNoviceFlag(msg.finishFlag)
    KnapsackDataManager:Get():SetPropsKnapsack(msg.myProps)
    SegmentDataManager:Get():RecServerData(msg.myProps)
    GuideManager:Get():Init(PlayerDataManager:Get():GetGuideStep())
    --TaskDataManager:Get():OnInit(msg.myMainTask)
    --TaskDataManager:Get():InitActive(msg.myActiveTask)

   -- ChatDataManager:Get():Init(msg.myTalks)
    ChatDataManager:Get():TalkInfosParser(msg.myGuildTalk)
    monoNetMgr:EndHeartBeat()
    NetManager:Get():StartHeartBeat()
    RaceTrackDataManager:Get():RecServerData(msg.myTrack)
    StaminaDataManager:Get():StartIncreaseStamina()
    UnlockDataManager:Get():InitData()
    UnlockDataManager:Get():UpdateLockUIData()
    PersonalHomeDataManager:Get():UpdatePersonalHomeData(msg.myFurniture,true)
    LoginSubSystem:Get():Send_GetPartData()
    RechargeRewardManager:Get():Clear()
    PopUpGiftDataManager:Get():UpdateDataList(msg.myTimebuy,true)
    CommonHelper:SendAdJustToken(TrackEventNames.EnterPlayerData,AnalysisType.EnterPlayerData)
    QuickTa:Get():TrackEvent(TrackEventNames.EnterPlayerData, nil,TrackEventType.First,AnalysisType.EnterPlayerData)
end
--}}}
---@param msg SC_LoginProp
function LoginFuncHelper:EnterServerPart(msg,flag)
    cs_coroutine.start(function()
        UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0.4)
        PlayerDataManager:Get():InitPlayData(msg.userinfo)
        KnapsackDataManager:Get():SetPartsData(msg.myParts)
        coroutine.yield()
        UINotify:Get():SendNotification(UINotifyEvent.UpdateLoadingViewProgress, 0.8)
        ChatDataManager:Get():TalkInfosParser(msg.myPrivate,msg.myWorld,msg.myServer,msg.myTopSystem,msg.mySystemInfo,msg.myInviteInfo)
        CarDataManager:Get():InitCars(msg.myCars)
        NewPlayerCarDataManager:Get():Init(msg.myParts,msg.myCars)
        CarCacheManager:Get():InitData()
        TeamCacheManager:Get():InitData()
        ReturnOldPlayerDataManager:Get():SetCarShellNum(msg.carShellNum)
        QuickTa:Get():TrackEvent(TrackEventNames.EnterPlayerCarData, nil,TrackEventType.First,AnalysisType.EnterPlayerCarData)
        if ClientDataManager:Get():GetGameState()~=GameState.CrossDay then
            if NetManager:Get().GameLoginType==LoginType.Normal or ClientDataManager:Get():GetIsNew() or flag then
                PVEChapterDataManager:Get():Init()
                RaceSeniorTrainManager:Get():Init()
                local isNew=ClientDataManager:Get():GetIsNew()
                LoginFuncHelper:SendCreateNicknameSuccessLog(isNew)
                if GameProperties.NewBieGuide and isNew then
                    LoginFuncHelper:OpenNewPlayerChapterView(isNew)
                else
                    if isNew then
                        ClientDataManager:Get():SetIsNew(false)
                        while TeamCacheManager:Get():GetMainCarLoadProcess() < 1 do
                            coroutine.yield()
                        end
                        QuickTa:Get():TrackEvent(TrackEventNames.NewPlayerLoadCarSuccess, nil,TrackEventType.First,AnalysisType.NewPlayerLoadCarSuccess)
                        SkipModuleHelper:ToMainMenuView(true)
                        CommonHelper:CloseLoading()
                    else
                        LoginFuncHelper:EnterGame()
                    end
                end
            end
        else
            LoginFuncHelper:CrossDay()
            PlotManager:Get():OnInit()
        end
        if NetManager:Get().GameLoginType==LoginType.Reconnect then
            --SDKManager:Get():QueryPurchasesAsync()
            PopupManager:Get():PopupFirstInitPopup()
            NetDelayManager:Get():OnReConnect()
            PlotManager:Get():OnInit()
        end
        ClientDataManager:Get():SetGameState(GameState.Login_GameServer)
    end)
end
function LoginFuncHelper:OpenNewPlayerChapterView(isNew)
    if GuideManager:Get():GetCurGuideStep() then
        NewBieChapterDataManager:Get():Init()
        --if GuideManager:Get():GetCurGuideStep():GetNextLevelId()>0 then
        --    cs_coroutine.start(function()
        --        coroutine.yield()
        --        coroutine.yield()
        --        coroutine.yield()
        --        CommonHelper:CloseLoading()
        --    end)
        --    ChapterSubsystem:Get():SendMsg_GetChapterRank(GuideManager:Get():GetCurGuideStep():GetNextLevelId(),0)
        --    return
        --end
        --if GuideManager:Get():GetCurGuideStep():GetGroup()>GuideState.GuideSelectCarId and #CarDataManager:Get():GetCarList()<=0 then
        --    GuideManager:Get():Init(GuideState.GuideSelectCarId,true)
        --end
        --if GuideManager:Get():GetCurGuideStep():GetNextLevelId()==-99 then
        --    UIManager:Get():OpenView("InitialView", CanvasType.MainCanvas, "InitialView")
        --    return
        --end
        if #CarDataManager:Get():GetCarList()>0 and isNew then
            if isNew then
                cs_coroutine.start(function()
                    ClientDataManager:Get():SetIsNew(false)
                    while TeamCacheManager:Get():GetMainCarLoadProcess() < 1 do
                        coroutine.yield()
                    end
                end)
            end
            SkipModuleHelper:ToMainMenuView(true)
        end
    end
end

--{{{发送创建昵称成功
function LoginFuncHelper:SendCreateNicknameSuccessLog(IsNew)
    if IsNew then
        QuickTa:Get():TrackEvent(TrackEventNames.CreateNicknameSuccess)
        QuickTa:Get():TrackEvent(TrackEventNames.Register)
        QuickTaHelper:Get():TrackGraphicsDeviceInfoEvent()
        UnifySDKHelper:Purchase_SubmitRoleInfo(PurchaseRoleInfoData_SubmitType.CreateRole)

        UnifySDKHelper:Analysis_Register()
        --if SDKHelper:Get():ChickMyQuickSdk() then
        --    ReYunSdk:Get():register(PlayerDataManager:Get():GetPlayerUID() or ReYunSdk:Get():getDeviceId(),PlayerDataManager:Get():GetPlayerRID())
        --end
    else
        UnifySDKHelper:Purchase_SubmitRoleInfo(PurchaseRoleInfoData_SubmitType.StartGame)
    end
    UnifySDKHelper:Analysis_Login()
    --if SDKHelper:Get():ChickMyQuickSdk() then
    --    ReYunSdk:Get():login(PlayerDataManager:Get():GetPlayerUID(),PlayerDataManager:Get():GetPlayerServerID(),PlayerDataManager:Get():GetPlayerRID())
    --end
end
--}}}

--{{{跨天需要处理ui逻辑
function LoginFuncHelper:CrossDay()
    --CarBuilderManager:Get():AddBuildMask()
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_RefreshActivityMidBtn)
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_RefreshReturnOldPlayerBtn)
    CrossDayTrigger:Get():CrossDay()
    --CarBuilderManager:Get():RemoveBuildMask()
end
--}}}

--{{{初始化玩家base数据
function LoginFuncHelper:InitPlayerInfo_BaseData(playerinfo)
    PlayerDataManager:Get():OnInitBaseData(playerinfo)

    --LoginSubSystem:Get():SendMsg_EnterPlayer()
end
--}}}

--{{{初始化玩家part数据
function LoginFuncHelper:InitPlayerInfo_PartData(msg)
    PlayerDataManager:Get():OnInitPartData(msg)
    -- ChapterDataManager:Get():Init()

end
--}}}


--{{{登录后视频
function LoginFuncHelper:FirstEnterMainCityDone()
    print("加载场景完成进入游戏")
    if ClientDataManager:Get():GetIsNew() then
        if GameProperties.AreaType == AreaType.AreaTypeDNY and GameProperties.isTs then
            GameProperties.NewBieGuide=false
            local cfg=ClientDataManager:Get():GetDataTable(ConfigNames.dictcar_config)
            ---@type dictcar_config_cell[]
            local _Data=cfg.GetConfigData()
            local _InitialViewSelectCar={}
            for k, v in pairs(_Data) do
                if v.cartype==1 then
                    table.insert(_InitialViewSelectCar,v)
                end
            end
            table.sort(_InitialViewSelectCar,function(a, b)
                return a.sort<b.sort
            end)
            LoginSubSystem:Get():CreateUser(ClientDataManager:Get():GetUID(),_InitialViewSelectCar[math.random(1,#_InitialViewSelectCar)].C_ID)
        else
            --if GameProperties.NewBieGuide then
            --    if PlayerDataManager:Get():GetGuideStep()==0 then
            --        LoginSubSystem:Get():AdvanceCreateUser("",0)
            --    end
            --else
                UIManager:Get():OpenView("InitialView", CanvasType.MainCanvas, "InitialView")
        end
    else
        if #CarDataManager:Get():GetCarList()>0 then
            SkipModuleHelper:ToMainMenuView(true)
        else
            if GameProperties.NewBieGuide and CommonHelper:CheckPlayerIsNewGuide() then
                LoginFuncHelper:OpenNewPlayerChapterView(false)
            else
                UIManager:Get():OpenView("InitialView", CanvasType.MainCanvas, "InitialView")
            end
        end
    end
end
--}}}
--{{{登录后视频
function LoginFuncHelper:PlayerVideoCreateUser(func)
    if  GameProperties.IsPlayVideo and HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.SignVideo) then
        if SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk2) then
            CommonHelper:PlayViewVideoByUrl(func)
        elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk3) then
            CommonHelper:PlayViewVideoByUrl(func)
        elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk4) then
            CommonHelper:PlayViewVideoByUrl(func)
        elseif SDKHelper:Get():ChickSdkType(SDKChannelNames.IsUseUltraSdk5) then
            CommonHelper:PlayViewVideoByUrl(func)
        else
            CommonHelper:PlayerVideo("video_login.mp4", function()
                func()
            end,nil,nil,true)
        end
            else
            func()
            end
    end
--}}}
--{{{登录后连接GameServer
function LoginFuncHelper:ContentGameServer(ip,post)
    LoginSubSystem:Get():SendMsg_GetMainMenuList(function(data)
        MenuListManager:Get():Init(data)
        if ClientDataManager:Get():GetIsNew() then
            LoginFuncHelper:PlayerVideoCreateUser(function()
                NetManager:Get():ConnectGameServer(ip,post)
            end)
        else
            if CommonHelper:IsNullOrEmpty(ip) then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1001))
            else
                NetManager:Get():ConnectGameServer(ip,post)
            end
        end
    end)
end
--}}}


--{{{预加载
function LoginFuncHelper:AdvanceLoad()

    --UIManager:Get():CacheViewWithActiveFasle("ButtomInfoView")
    UIManager:Get():CacheViewWithActiveFasle(CommonHelper:GetMainMenuViewName())
    UIManager:Get():CacheViewWithActiveFasle("TopInfoView")
    UIManager:Get():CacheViewWithActiveFasle("PveChapterView")
    UIManager:Get():CacheViewWithActiveFasle("GarageView")
    UIManager:Get():CacheViewWithActiveFasle("BattleNewSystemView")
    UIManager:Get():CacheViewWithActiveFasle("ShopView")
    --UIManager:Get():CacheViewWithActiveFasle("PlayerSelfInfoView")
    UIManager:Get():CacheViewWithActiveFasle("SelectTeamBaseView")

    --CS.AudioManager:Get():CacheAudioSound("bgm_battle.mp3")
    --AudioManager:CacheAudioSound("audio_bgm_inbattle_01.mp3")
    --AudioManager:CacheAudioSound("audio_bgm_inbattle_02.mp3")
    --AudioManager:CacheAudioSound("audio_bgm_inbattle_03.mp3")
    --AudioManager:CacheAudioSound("startcooldown_1.wav")
    --AudioManager:CacheAudioSound("startcooldown_3.wav")

    SelfDefineTrack:OnCacheLoad()
    self:AdvanceSegmentCache()
    Start_AfterLogin()
end
--}}}

function LoginFuncHelper:AdvanceSegmentCache()
    local config= ClientDataManager:Get():GetDataTable(ConfigNames.tracksegement_config)
    local configData = config.GetConfigData()

    local index = 0;
    for k, v in pairs(configData)  do
        if v.editflag==1 then
            AssetsManager.LoadAsync( v.resname, typeof(GameObject))
            index = index + 1
        end
    end


end


--{{{连接game服
function LoginFuncHelper:ConnectingGame()
    CommonHelper:PlayScreenEffectUIMask(999)
end
--}}}
local ErrorCount = 0
--{{{连接game服finish
function LoginFuncHelper:ConnectingGameFinish(isSuccess)
    ErrorCount = 0
    if isSuccess then
        CommonHelper:PlayScreenEffectNull(false)
    end
end
--}}}


--{{{连接game服Error
function LoginFuncHelper:ConnectingGameError()
    local boxfunc = function()
        local text = ClientDataManager:Get():GetTemplateString(TemplateStringID.LoginTips_1010)
        local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
        if ret == MessageBoxHelp.BtnType.OK then
            CommonHelper:PlayScreenEffectWaiting(false)
            CommonHelper:PlayScreenEffectNull(false)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    UINotify:Get():SendNotification(UINotifyEvent.GameStartView_InitBtnInfo, true)
    UINotify:Get():SendNotification(UINotifyEvent.LoginView_InitBtn, true)
end
--}}}

---{{{检查客户端网络
function LoginFuncHelper:CheckLoginedClientNetState()
    if NetManager:Get():GetNetReachability() == NetworkReachability.NotReachable then
        -- LoginFuncHelper:ConnectingGameError()
    end
    NetManager:Get():SendDurationEvent()
end
---}}}
function LoginFuncHelper:SetGameState(gameState)
    ClientDataManager:Get():SetGameState(gameState)
end

function LoginFuncHelper:ConnectLoginServer()
    LoginSubSystem:Get():SendMsg_GetLoginWhiteConfig(function(data)
        local whitecfg=Dll_JSON.decode(data)
        LoginFuncHelper:CheckPlayerIsWhiteCfg(whitecfg,function()
            NetManager:Get():ConnectLoginServer()
        end)
    end)
end

function LoginFuncHelper:CheckPlayerIsWhiteCfg(data,func)
    if data.maintain==0 then
        func()
    else
        local uid = PlayerPrefsHelper:GetValue_LoginName()
        local isWhite= false
        if data.whitelist and #data.whitelist>0 then
            for i = 1, #data.whitelist do
                if uid==data.whitelist[i] then
                    isWhite= true
                    func()
                    break
                end
            end
        end
        if not isWhite then
            if CommonHelper:IsNullOrEmpty(GameProperties.maintainUrl) then
                CommonTipsHelper:Get():ShowPushTips(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1001))
                return
            end
            NetManager:Get():SendHttpGet_GetAnnouncement(GameProperties.maintainUrl, function(data)
                local boxfunc = function()
                    local text = data
                    local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text, ClientDataManager:Get():GetTemplateString(TemplateStringID.GameWarmPrompt), nil, nil, false, false, true)
                    if ret == MessageBoxHelp.BtnType.OK then
                        if SDKHelper:Get():ChickSdk() then
                            UINotify:Get():SendNotification(UINotifyEvent.GameStartView_ReOpenServerInfo)
                        else

                        end
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
            end)
        end
    end
end
function LoginFuncHelper:EnterGameError(error)
    local boxfunc = function()
        local text = CommonHelper:GetTempStr_Default(TemplateStringID.GameLoadPartErrorBack)
        local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text,CommonHelper:GetTempStr_Default(TemplateStringID.GameLoadPartErrorBack), nil, nil, false, false, true)
        if ret == MessageBoxHelp.BtnType.OK then
            LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, nil, false)
        end
    end
    MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    QuickTa:Get():TrackEvent(TrackEventNames.GameEnterError,{errorlog=error})
end
--{{{资源加载报错
function LoginFuncHelper:OnAssetException(bundleName, assetName)
    local nameType= stringSplit(assetName,".")
    logError("bundleName-》",bundleName,"assetName->",assetName)
    if nameType[2]=="png" then
        --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GameLoadPngError))
    elseif nameType[2]=="txt" then
        local boxfunc = function()
            local text = CommonHelper:GetTempStr_Default(TemplateStringID.GameLoadTableErrorBack)
            local ret = MessageBoxHelp:Get():OpenBox_OK(UIColor.Blue, text,CommonHelper:GetTempStr_Default(TemplateStringID.GameLoadPartErrorBack), nil, nil, false, false, true)
            if ret == MessageBoxHelp.BtnType.OK then
                LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, nil, false)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxfunc)
    elseif nameType[2]=="mat" then
        --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GameLoadMatError))
    elseif nameType[2]=="prefab" then
        --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GameLoadPrefabError))
    else
       --CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.GameLoadAssetError))
    end
    local trackTable={
        bundleName = bundleName,
        assetName = assetName
    }
    QuickTa:Get():TrackEvent(TrackEventNames.GameLoadAssetError,trackTable)

end
--}}}

--{{{释放所有资源，重新加载，包括lua
function LoginFuncHelper:ReleaseAllAssets()
    ClientDataManager:Get():LogoutClearAssets()
    LuaRelevance:Get():Release()
    HotFixLuaEvent:Get():Clear()
    mono.ReleaseAllAssets()
end
--}}}

--{{{自动创建角色
function LoginFuncHelper:NoRacerAutoCreate()

    NetManager:Get():ConnectLoginServer(function()
        local uid = PlayerPrefsHelper:GetValue_LoginName()
        LoginSubSystem:Get():Send_GetServerList(uid,function(msg)
            NetManager:Get():DisconnectLoginServer()
            local hasPlayer=false
            ---@type SC_svrList
            local recommendServer=nil
            ---@type  SC_AuthuserMess msg
            for i = 1, #msg.svrs do
                if msg.svrs[i].rid~=0 and not hasPlayer then
                    hasPlayer=true
                end
                if recommendServer==nil and msg.svrs[i].recommend==1 then
                    recommendServer=msg.svrs[i]
                end
                mono.Add4wdServer(msg.svrs[i].svrcode,msg.svrs[i].svrname)
            end
            if not hasPlayer and recommendServer==nil then
                recommendServer=msg.svrs[#msg.svrs]
            end
            if recommendServer and not hasPlayer then
                ClientDataManager:Get():SetLoginMsg(msg)
                ClientDataManager:Get():SetIsNew(true)
                NetManager:Get():ConnectGameServer(recommendServer.ipadd,recommendServer.svrport,function()
                    LoginSubSystem:Get():AdvanceCreateUser("",0,function(msg)
                        NetManager:Get():SetGameServerLogout()
                        NetManager:Get():DisconnectGameServer()
                        CommonHelper:PlayScreenEffectNull(false)
                    end)
                end)
            end
        end)
    end)
end
--}}}
