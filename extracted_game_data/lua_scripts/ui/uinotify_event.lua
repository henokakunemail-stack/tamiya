-- 每个页面的消息都加100，以防止不同的人命名的id重复
---@class UINotifyEvent
UINotifyEvent = {
    ZrgTest_PrintCommon = 10,
    --OpenHelloWorldView = 1,
    --OpenTestView = 2,

    Msg_PartReform = 1,
    Msg_PartReformReset = 2,
    Msg_PartReformLvup = 3,
    Msg_PartStarUp = 4,
    Msg_ShellColor = 5,
    Msg_ShellSticker = 6,
    Msg_ShellGrid = 7,
    Msg_Assemble = 8,
    Msg_PlayerCurrency = 9,
    Msg_PlayerStamina = 10,
    Msg_PlayerExp = 11,
    Msg_PlayerLv = 12,
    Msg_PlayerIcon = 13,
    Msg_PartLevelUp = 14,
    Msg_PartLock = 15,
    Msg_CarAttrUpdate = 16,
    Msg_CarIdxOpen = 17,
    Msg_PartColor = 18,
    Msg_SetFriendShip = 19,
    Msg_CloseUI = 20,
    Msg_LeftCloseUI = 21,
    Msg_PartVerifyAttr = 22,
    Msg_PartInherit = 23,
    Msg_PartInheritRecastingBack = 24,
    Msg_PartAwake = 25,
    Msg_PartUp = 26,
    Msg_PartSticker = 27,


    -- LoadingView
    LoadingView_IsAutoClose = 101,
    LoadingView_SetFinishEvt = 103,
    UpdateLoadingViewProgress = 102,
    UpdateLoadingFinish = 104,

    -- LoginView
    LoginView_OpenLoginView = 201,
    LoginView_OpenLogoutView = 202,

    UpdateServerInfo = 203,
    SetSelectServerInfo = 204,


    LoginView_OpenInputNameView = 205,
    LoginView_InitBtn = 206,

    GameStartView_UpdateServerInfo = 207,
    GameStartView_InitServerInfo = 209,
    GameStartView_ServerMaintain = 210,
    GameStartView_InitBtnInfo = 211,
    GameStartView_InitCG = 212,
    GameStartView_CloseLoginPanelCG =213,
    GameStartView_InitServer =214,
    GameStartView_ReOpenServerInfo =215,

    --NetViewAction
    OpenNetWaitingView = 301,
    CloseNetWaitingView = 302,

    --MainMenuView

    MainMenuView_InitBtnInfo = 402,
    MainMenuView_UpdateChatText = 403,
    MainMenuView_InitMainChatInfo = 404,
    MainMenuView_RefreshFirstBuyRedPoint = 405,
    MainMenuView_RefreshActivityMidBtn = 406,
    MainMenuView_RefreshReturnOldPlayerBtn = 407,
    MainMenuView_SetLuaViewInfo = 408,
    MainMenuView_RefreshTestGift = 409,

    --InteractionMainMenuView

    InteractionMainMenuView_InitBtnInfo = 420,
    InteractionMainMenuView_UpdateChatText = 421,
    InteractionMainMenuView_InitMainChatInfo = 422,
    InteractionMainMenuView_RefreshFirstBuyRedPoint = 423,
    InteractionMainMenuView_RefreshActivityMidBtn = 424,
    InteractionMainMenuView_RefreshReturnOldPlayerBtn = 425,

    -- getreward
    OpenGetRewardView = 501,
    OpenShowRewardView = 502,
    CloseGetRewardFun = 503,
    PlayerLevelSetData = 504,
    OpenGetRewardView_RewardData = 505,
    GiftShowRewardView_SetData = 506,

    -- MessageBoxView
    MessageBoxView_SetLayout = 601,
    MessageBoxView_ClickToggle = 602,
    -- ArticleMessageBoxView
    ArticleMessageBoxView_SetLayout = 603,
    ArticleMessageBoxView_ClickToggle = 604,

    -- AttributeView
    AttributeView_SetData = 651,
    -- tipsview

    ShowTips_Center = 701,
    ShowTips_Top = 702,


    HelpView_SetData = 801,


    --ChapterView
    ChapterView_ClickTogType = 911,
    ChapterView_UpdateChapterView = 912,


    --ChapterListView
    ChapterListView_SetLevelList = 923,
    ChapterListView_UpdateBox = 925,

    --SelectTeamView
    SelectTeamView_SetData = 931,
    SelectTeamView_Fight = 932,
    SelectTeamView_ClickChange = 933,
    SelectTeamView_Swap = 934,
    SelectTeamView_Refresh = 935,
    SelectTeamView_UpdateRewardView = 936,


    --InitialView
    InitialView_SelectCar = 951,
    InitialView_Sure = 952,
    InitialView_Succeed = 953,


    --RecruitView
    RecruitView_InitViewInfo = 961,
    RecruitView_SetData = 962,
    RecruitView_SkipAni = 963,
    RecruitView_PlayAni = 964,
    RecruitView_InitBtn = 967,
    RecruitView_StartCountTime = 968, --开始抽奖
    RecruitView_UpdateRecruitList = 969, --更新抽奖类型
    RecruitView_OnRecruitClick = 965, --更新抽奖类型
    RecruitView_RefreshTopInfo = 966, --更新抽奖类型

    --RecruitShowView
    RecruitShowView_InitViewInfo = 971,
    RecruitShowView_SkipAni = 972,
    RecruitShowView_LoadCars = 973,
    RecruitShowView_FirstShareClose = 974,

    --ProbabilityView
    ProbabilityView_SetData = 981,
    ProbabilityView_UpdateScroll = 982,
    RecruitMiniExchangeView_SetData = 983,
    RecruitMiniExchangedView_SetData = 984,
    RecruitMiniExchangeMoreView_SetData = 985,


    --battle
    BattleNewSystemView_InitBattleExplain=1005,
    BattleExplainView_ShowTips=1006,
    BattleStartView_ShowRaceState = 1007,
    BattleStartView_BattleCountDown = 1008,

    BattleNewSystemView_InitChatList = 1009,
    BattleNewOutdoorView_SetSkillTweenIsPause = 1010,
    BattleNewSystemView_UpdateBattleRank = 1011,
    BattleNewSystemView_UpdateScrollList = 1013,
    BattleNewSystemView_SetTalkContent = 1014,
    BattleNewOutdoorView_UpdateBattleRank = 1015,
    BattleNewSystemView_OnFinishedBattle = 1016,
    BattleNewOutdoorView_UpdateSkillCardDataCd = 1017,
    BattleNewOutdoorView_SkillCardCdFinish = 1018,
    BattleFlashView_SetSkillUI = 1019,
    BattleNewOutdoorView_OnFinishedBattle = 1020,
    -- email
    EmailListView_InitEmailList = 1021,
    EmailListView_UpdateEmailView = 1022,
    EmailListView_RefreshEmail = 1023,
    EmailDetailView_OpenEmailDetail = 1024,
    EmailListView_DeleteEmail = 1025,
    EmailGetReward = 1026,

    -- plot
    PlotAction = 1031,
    BattleNewSystemView_OpenGameTools = 1032,
    BattleNewSystemView_Dispose = 1033,
    BattleNewSystemView_UpdateAccelerateBtnState = 1034,
    BattleNewSystemView_UpdateProtectBtnState = 1035,
    BattleNewSystemView_SetBeanCount = 1036,
    BattleNewSystemView_PlayBeanEffect = 1037,
    BattleNewSystemView_ProtectStage = 1038,
    BattleNewSystemView_RecoverStart = 1039,
    BattleNewSystemView_RecoverEnd = 1040,
    BattleNewSystemView_CountDown = 1050,
    BattleNewSystemView_BuffUpdate = 1051,
    BattleNewSystemView_SetBattleCostImage = 1052,
    BattleNewSystemView_SkillCardCdFinish = 1053,
    --
    --PlotSetDialog = 1033,
    --PlotSetBackground = 1034,
    --PlotSetRoleState = 1035,
    --PlotSetRenderTextureBG = 1036,

    -- ScreenEffect
    ScreenEffectView_Alpha0To1 = 1041,
    ScreenEffectView_Alpha1To0 = 1042,
    ScreenEffectView_Alpha0To0 = 1043,
    ScreenEffectView_Waiting = 1044,
    ScreenEffectView_UIMask = 1045,
    GuideScreenEffectView_UIMask = 1046,
    ScreenEffectView_StopAllTimer = 1047,


    --equipment
    GarageView_ShellHole = 1131,
    GarageView_PartReview = 1132,
    GarageView_ShellHoleReview = 1133,
    GarageView_ShellGridReview = 1134,
    GarageView_ShellColorReview = 1135,
    GarageView_ShellStickerReview = 1136,
    GarageView_ResetCar = 1137,
    GarageView_ResetOrgCar = 1138,
    GarageView_SetPartListSelect = 1139,
    --GarageView_ShowAttrTip = 1138,
    --GarageView_ShowFeatureTip = 1139,
    GarageTipsView_SetData = 1140,
    GarageView_ReviewPartSticker = 1141,
    --PartStarUp


    --equipment
    GarageView_SetPartinfo = 1151,
    GarageView_SetPartinfoByCfg = 1152,
    GarageView_PartReviewByCfg = 1153,


    --knapsack
    KnapsackView_SetData = 1181,
    KnapsackView_UpdateScrollView = 1182,
    KnapsackView_RefreshData = 1183,
    KnapsackView_UpdateTogView = 1184,
    KnapsackView_ClickTog = 1185,
    --article
    ArticleInfoView_SetDataByCellid = 1191,
    ArticleInfoUseView_SetData = 1192,
    ArticleInfoUseView_SetCount = 1193,


    ArticleInfoView_SetDataByCfg = 1195,
    TrackSegmentFeatureView_SetDataByCfg = 1196,


    TrackSegmentInfoView_SetData = 1198,
    --ArticleInfoPartView_ClickTog = 1195,
    --ArticleInfoPartView_UpdateScrollReform = 1197,
    --ArticleInfoPartView_UpdateScrollInfo = 1198,

    --shop
    ShopView_UpdateScrollView = 1201,
    ShopView_SetData = 1202,
    ShopView_ClickItem = 1203,
    SetGoodsInfoView = 1205,
    ShopView_CallBack = 1206,
    ShopBuyDoneOpen = 1207,
    BuyGoodSuccess = 1208,
    SetBuyNum = 1209,
    ShopViewAutoRefresh = 1210,
    ShopArticleInfoView_SetData = 1211,
    ShopArticleInfoPartView_SetData = 1212,
    ShopArticleInfoPartView_ClickTog = 1213,
    ShopArticleInfoPartView_UpdateScrollAttr = 1214,
    ShopArticleInfoPartView_UpdateScrollReform = 1215,
    ShopArticleInfoPartView_UpdateScrollInfo = 1216,

    --club
    ClubApplyMemberListView_InitApplyViewInfo = 1220, --设置申请界面
    ClubNoView_List_InitClubList = 1221, --打开俱乐部类表面板，初始化俱乐部类表中的俱乐部信息
    ClubMemberListView_InitMemberListViewInfo = 1222, --初始化主界面信息
    ClubExchangeGetRewardView_SetRewardInfo = 1223, --获得奖励

    ClubNoView_List_InitClubInfo = 1224,
    ClubExchangeView_UpdateExchangePlayerAttr = 1225, --兑换之后更新玩家属性
    --ClubInfoView_UpdateClubInfoView = 1226, --打开俱乐部主页面板
    ClubMainMenuView_UpdateChatScrollView = 1227,
    ClubMemberListView_InitMemberList = 1228, --打开创建成功面板，初始化创建的俱乐部信息
    --ClubInfoView_JoinSuccessOrFail = 1229, --加入俱乐部成功或失败
    ClubApplyMemberListView_InitApplyList = 1230, --设置单个申请成员的信息
    ClubMainMenuView_InitViewInfo = 1231,
    ClubBadgeView_InitBadgeList = 1232, --初始化俱乐部头像
    ClubNoView_List_AfterSearch = 1233, --初始化搜索俱乐部

    ClubMainMenuView_UpdateMemberList = 1234,
    ClubExchangeView_UpdateExchangeViewInfo = 1235, --更新兑换界面

    ClubMainMenuView_OnExitSuccess = 1236, --退出俱乐部成功
    ClubMainMenuView_InitMemberList = 1237,
    ClubMemberInfoView_InitClubMemberInfoView = 1238, --初始化俱乐部成员的消息
    ClubMemberInfoView_InitClubMemberFuncBtn = 1239, --初始化俱乐部成员按钮消息
    ClubEditView_UpdateCreateEditBaseView = 1240, --更新编辑的界面，图标

    ClubNoView_List_NoClub = 1241, --服务器里没有任何俱乐部
    ClubMainMenuView_UpdateSlider = 1242, --服务器刷新贡献值
    ClubMainMenuView_OnBtnClick = 1243, --俱乐部关闭按钮
    ClubMainMenuView_SetLuaViewInfo = 1244, --

    --ClubTask
    ClubTaskView_SetData = 1245,  --俱乐部任务

    --task
    TaskViewSetData = 1250,
    RefreshCurView = 1251,
    RefreshNoviceView = 1252,

    --announcement
    AnnouncementViewSetContent = 1260,
    ActivityViewOpen = 1261,
    AnnouncementViewOpen = 1262,


    --ReformSelectView
    ReformSelectView_SetData = 1281,


    --ReformStrongView
    ReformStrongView_SetData = 1301,


    --EquipmentView
    EquipmentView_UpdateScrollView = 1311,
    EquipmentView_UpdateTog = 1312,
    EquipmentView_ClickTog = 1313,
    EquipmentView_Refresh = 1314,

    --SwapView
    SwapView_SetData = 1321,
    SwapView_ClickNum = 1322,
    SwapView_ClickMax = 1323,

    --set
    --SettingView_InitSound=1331,

    --StaminaView
    StaminaView_UpdateData = 1331,

    --buyGold
    UpdateBuyGoldView = 1334,
    ShowBuyGoldTips_Center = 1336,
    ShowBuyGoldNotarize_Center = 1338,

    --配件养成反馈
    ReformSucceedView_SetData = 1341,
    PartStarUpView_SetData = 1342,
    PartUpSucceedView_SetData = 1343,
    PartLevelupResultView_SetData = 1344,
    InheritRecastingResultView_SetData = 1345,


    --newBieGuide
    UpdateNewBieGuideList = 1362,
    StartNewBieGuide = 1363,
    EndNewbieGuide = 1364,
    CloseNewbieGuide = 1365,
    EscCurNewBie = 1366,


    RaceRoomTrackListView_SetMsgData = 1382,


    RaceRoomView_SetData = 1401,
    RaceRoomView_Refresh = 1402,
    RaceRoomView_UpdateSearch = 1403,
    RaceRoomView_SetViewInfo = 1404,
    RaceRoomView_CreateViewAuto = 1405,

    RaceRoomDetailView_SetData = 1411,
    RaceRoomDetailView_Revise = 1412,
    RaceRoomDetailView_ReviseWithoutMesh = 1413,
    RaceRoomDetailView_UpdateChatScrollView = 1414,
    RaceRoomDetailView_SetViewInfo = 1415,
    RaceRoomDetailView_ReviseViewAuto = 1416,


    TrackListSetCallBack = 1420,
    TrackListSetData = 1421,


    ---------------------------------

    --CustomTrack
    CustomTrackListViewOpen = 1480,
    CustomTrackItemSetData = 1481,
    CustomTrackEditorOpen = 1482,
    TrackSegmentShopViewOpen = 1483,
    TrackSegmentShopViewClickItem = 1484,
    BuyGoodSuccess = 1485,
    SetBuyNum = 1486,
    TrackSegmentSetGoodsInfoView = 1487,
    TrackSegmentBuyGoodSuccess = 1488,
    TrackSegmentSetBuyNum = 1489,
    CustomTrackSaveSuccess = 1490,
    CustomTrackShopBack = 1491,
    CustomTrackUpdate = 1492,


    --SpecialTraining
    SpecialTrainingViewSetData = 1591,
    SpecialTrainingViewUpdate = 1592,
    SpecialTrainingViewUpdateReward = 1593,
    SpecialTrainingView_SelectCar = 1594,
    SpecialTrainingView_TrackReview = 1595,
    SpecialTrainingView_RewardReview = 1596,
    --SpecialTrainingViewSetData=1591,



    --PlayerInfoView
    PlayerInfoView_InitInfoViewInfo = 1611,
    PlayerInfoView_SelectCarBack = 1612,
    PlayerInfoView_SelectCarOpen = 1613,
    PlayerInfoView_ChangeSign = 1614,
    --Friend
    FriendBlackListView_InitFriendList = 1621,
    FriendListView_InitFriendList = 1623,
    FriendListView_InitFriendInfo = 1624,
    FriendListView_InitRedPointInfo = 1625,
    FriendListView_SetLuaViewInfo = 1626,
    FriendListView_ClearLuaViewInfo = 1627,
    FriendListView_RefreshRentHaveInfo = 1628,

    --raceselfview
    RaceSelfView_SetData = 1631,
    RaceSelfView_UpdateScrollView = 1632,
    RaceSelfView_ClickItem = 1633,

    --selfChallenge
    SelfChallengeMenuViewOpen = 1641,
    SelfChallengeFilterViewOpen = 1642,
    SelfChallengeSelectSceneOpen = 1643,
    SelfChallengeCreateViewOpen = 1644,
    SelfChallengeCreateSelectTickets = 1645,
    SelfChallengeCreateSetDifficulty = 1646,
    SelfChallengeCreateSelectScene = 1647,
    SelfChallengeCreateSetReward = 1648,
    SelfChallengeCreateSetName = 1649,


    --SelfChallengeChapterListView
    SelfChallengeChapterListView_UpdateLevelView = 1650,
    SelfChallengeChapterListView_ClickLevelItem = 1651,
    SelfChallengeChapterListView_SetLevelList = 1652,
    SelfChallengeChapterListView_ClickBox = 1653,
    SelfChallengeChapterListView_UpdateBox = 1654,

    --SelfChallengeSelectTeamView
    SelfChallengeSelectTeamView_SetData = 1660,
    SelfChallengeSelectTeamView_Fight = 1661,
    SelfChallengeSelectTeamView_ClickChange = 1662,
    SelfChallengeSelectTeamView_Swap = 1663,
    SelfChallengeSelectTeamView_Refresh = 1664,
    SelfChallengeSelectTeamView_UpdateRewardView = 1665,

    RaceSelfCreateView_ClickBtnStep = 1671,
    RaceSelfCreateView_ClickBtnCreate = 1672,
    RaceSelfCreateView_Step1_ClickTog = 1673,
    RaceSelfCreateView_Step2_ClickTogType = 1674,
    RaceSelfCreateView_Step2_ClickTogNum = 1675,
    RaceSelfCreateView_Step2_SelectTrack = 1676,
    RaceSelfCreateView_Step2_ClickBtnReview = 1677,
    RaceSelfCreateView_Step3_UpdateDate = 1678,
    RaceSelfCreateView_Step4_ClickTogCost = 1679,
    RaceSelfCreateView_Step4_UpdateScrollView = 1680,

    SelfRaceDateView_SetData = 1681,
    SelfRaceDateView_ClickTogDate = 1682,
    SelfRaceDateView_UpdateScrollView = 1683,
    SelfRaceDateView_ClickScrollItem = 1684,

    RaceSelfJoinView_SetData = 1691,
    RaceSelfJoinView_ClickBtnJoin = 1692,
    RaceSelfJoinView_ClickBtnChangeCar = 1693,
    RaceSelfJoinView_UpdateScrollView = 1694,

    LabIronResetView_RefreshScrollView = 1701,
    LabIronResolveView_RefreshScrollView = 1702,
    LabIronExtractView_RefreshScrollView = 1703,

    RaceSelfSelectCarView_SetData = 1711,
    RaceSelfSelectCarView_SelectCar = 1712,

    --SelfChallenge
    SelfChallengeOtherGameListSetData = 1720,
    SelfChallengeOtherGameListUpdateScrollView = 1721,
    SelfChallengeSelfGameListSetData = 1722,
    SelfChallengeSelfGameListUpdateScrollView = 1723,

    RaceSelfHistoryView_SetData = 1781,
    RaceSelfHistoryView_ClickTog = 1782,
    RaceSelfHistoryView_UpdateScrollJoin = 1783,
    RaceSelfHistoryView_ClickItemJoin = 1784,
    RaceSelfHistoryView_UpdateScrollCreate = 1785,
    RaceSelfHistoryView_ClickItemCreate = 1786,

    RaceSelfMapView_SetData = 1791,
    RaceSelfMapView_ClickTog = 1792,

    CommonInputView_SetData = 1801,
    PlayerRenameView_SetData = 1802,

    SuitListView_SetData = 1811,
    SuitListView_SetMsgData = 1812,
    SuitListView_RefreshScroll = 1813,


    SuitWarningView_SetData = 1821,

    --SelfChallenge

    SelfChallengeCreateSetDifficultySetDefault = 1830,
    SelfChallengeCreateSetDifficultyUpdateSelectDays = 1831,
    SelfChallengeCreateSetDifficultyUpdateSelectPassNum = 1832,
    SelfChallengeCreateSetDifficultyUpdateSelectType = 1833,
    SelfChallengeCreateSetDifficultyUpdateSelectDifficulty = 1834,
    SelfChallengeCreateCommitParam = 1835,
    SelfChallengeSelectSceneOpen = 1841,
    SelfChallengeCreateSelectSceneBack = 1842,
    SelfChallengeSelectTrackOpen = 1843,
    SelfChallengeSelectTrackBack = 1844,
    SelfChallengeSelectNpcOpen = 1845,
    SelfChallengeCreateSelectNpcBack = 1846,
    SelfChallengeCreateClearData = 1847,


    SelfChallengeCreateSelectTicketsBack = 1860,
    SelfChallengeCreateSelectTicketsClose = 1861,
    SelfChallengeCreateSetDifficultyClose = 1862,
    SelfChallengeCreateSelectSceneClose = 1863,
    SelfChallengeCreateSetRewardClose = 1863,
    SelfChallengeCreateSetNameClose = 1864,
    SelfChallengeSelectRewardSetData = 1865,
    SelfChallengeCreateSetRewardBack = 1866,
    SelfChallengeFilterBack = 1867,

    SuitFirstPartView_SetData = 1851,


    --clubtrain
    ClubTrainView_InitTrainViewInfo = 1871,
    ClubTrainView_UpdateRank = 1872,
    ClubTrainSettingView_InitScrollView = 1873,

    RaceRuleResultView_SetData = 1881,

    RaceRuleFightGroupView_SetData = 1891,

    RaceRuleFightGroupListView_SetData = 1901,

    RaceRuleSiftView_SetData = 1911,

    ---------------CustomTrackShop
    TrackSegmentShopViewSetPlayerMoney = 1921,


    RaceWeekDetailView_SetData = 1930,

    ChampionshipView_SetRaceWeek = 1940,

    RaceWeekSelectCarView_SetData = 1950,

    RaceWeekMapView_SetData = 1960,

    RaceWeekHistoryView_SetData = 1970,

    RaceRankView_SetData = 1990,
    RaceRankView_SetSpeedRank = 1991,

    RaceRankJoinView_SetData = 2000,
    RaceRankJoinView_PlayerReady = 2001,

    RaceRankRoomView_SetData = 2010,
    RaceRankRoomView_UpdatePlayerReady = 2011,
    RaceRankRoomView_SetMesh = 2012,
    RaceRankRoomView_RefreshUI = 2013,

    RaceRankRewardView_SetData = 2020,
    RaceRankRewardView_UpdateState = 2021,

    RaceRankSpeedView_SetData = 2030,

    RaceRankHistoryView_SetData = 2040,

    ChatView_InitPrivateList = 2050,
    ChatView_UpdateChatScrollView = 2051,
    ChatView_InitChatScrollList = 2052,
    ChatView_InitTogState = 2053,
    ChatShareTypeView_InitViewInfo = 2054, --分享选择，是分享到世界还是本地
    RoomInvitePopView_InitViewInfo = 2055, --房间邀请弹框，别人邀请你的弹框
    RaceInviteFriendView_InitViewInfo = 2056, --邀请好友的界面，打开好友邀请界面
    ChatView_PlayerInfo_InitPageViewInfo = 2057, --打开玩家信息界面
    ChatView_PlayerInfo_SetBtnInfo = 2058, --打开玩家信息界面
    ChatView_UpdatePrivateList = 2059, --刷新私聊玩家数据
    ChatView_SetPrivateShowData = 2060, --设置私聊界面
    ChatView_Word_Translate=2063,--世界翻译


    AssembleView_SetDataByMap = 2061,
    AssembleView_SetDataByList = 2062,

    DevelopView_SetData = 2071,

    DebugViewShowLogView = 3000,
    DebugViewShowLogView_SetAttrs = 3001,


    PlayerSelfInfoViewUpdateTog = 3010,
    PlayerSelfInfoViewSetData = 3011,
    PlayerSelfInfoView_ChangeSign = 3012,
    PlayerSelfInfoView_ChangeName = 3013,
    PlayerOtherInfoView_SetData = 3014,
    PlayerOtherInfoView_SetBtnInfo = 3015,


    ---bagview
    BagViewRefresh = 3021,
    BagPartInfoViewSetData = 3022,
    CostUseViewSetData = 3023,
    CostUseViewRefresh = 3024,
    MiniCarInfoViewSetData = 3025,
    OptionalGiftViewSetData = 3026,
    OptionalGiftDetailsViewSetData = 3027,

    TopInfoRecruitView_InitViewInfo = 3031,

    SurveyView_UpdateScrollList = 3041,

    ---PlayerLevelUpView
    PlayerLevelUpView_InitViewInfo = 3051,
    PlayerLevelRewardView_InitViewInfo = 3052,

    --RaceSelfChapterView
    RaceSelfChapterViewSetTickets = 3071,
    RaceSelfChapterViewSetData = 3072,
    RaceSelfChapterViewSetJoin = 3073,
    RaceSelfChapterListView_SetLevelList = 3074,
    RaceSelfChapterSelectTeamView_SetData = 3075,
    RaceSelfChapterTaskView_SetData = 3076,
    RaceSelfChapterTaskView_Refresh = 3077,
    RaceSelfChapterListView_Refresh = 3078,

    --RaceSelfLevel
    RaceSelfLevelSelectSceneCallBack = 3081,
    RaceSelfLevelSelectNpc = 3082,
    RaceSelfLevelSelectNpcCallBack = 3083,
    RaceSelfLevelSelectReward = 3084,
    RaceSelfLevelSelectRewardCallBack = 3085,
    RaceSelfLevelViewSetAll = 3086,
    RaceSelfLevelViewSetJoin = 3087,
    RaceSelfLevelSelectTeamView_SetData = 3088,
    RaceSelfLevelViewSetJoinSuccess = 3089,
    RaceSelfLevelViewSetDetail = 3090,

    SelectTeamBaseViewSetData = 3100,
    SelectTeamViewPveChapterSetData = 3101,
    SelectTeamViewPveChapterSetCommon = 3102,
    SelectTeamViewRaceSeniorChapterSetData = 3103,


    ---实验室
    LabSelectPopView_InitViewInfo = 3113,
    LabMainMenu_UpdateUpgradeArticleList = 3115,
    LabMainMenu_InitBagList = 3116,
    LabMainMenu_InitCmpUpgBaseInfo = 3117,
    LabMainMenu_PutPropToGrid = 3118,
    LabMainMenu_InitRestoreBagList = 3119,

    --PveChapterListView
    PveChapterListView_SetLevelList = 3120,
    PVEChapterListView_UpdateBox = 3121,
    PVEChapterListView_Refresh = 3122,
    PVEChapterListView_SetViewInfo = 3123,
    PVEChapterRewardView_SetData = 3124,
    PVEChapterLevelInfoView_SetData = 3125,
    PVEChapterRankListView_SetData = 3126,

    --ClubRaceSelfChapterView
    ClubRaceSelfChapterViewSetTickets = 3141,
    ClubRaceSelfChapterViewSetAll = 3142,
    ClubRaceSelfChapterViewSetJoin = 3143,
    ClubRaceSelfChapterListView_SetLevelList = 3144,
    ClubRaceSelfChapterSelectTeamView_SetData = 3145,

    --ClubRaceSelfChapterView
    ClubRaceSelfLevelSelectSceneCallBack = 3151,
    ClubRaceSelfLevelSelectNpc = 3152,
    ClubRaceSelfLevelSelectNpcCallBack = 3153,
    ClubRaceSelfLevelSelectReward = 3154,
    ClubRaceSelfLevelSelectRewardCallBack = 3155,
    ClubRaceSelfLevelViewSetAll = 3156,
    ClubRaceSelfLevelViewSetJoin = 3166,
    ClubRaceSelfLevelSelectTeamView_SetData = 3167,
    ClubRaceSelfLevelViewSetJoinSuccess = 3168,
    ClubRaceSelfLevelViewSetDetail = 3169,


    LoginTaskSignView_InitTaskLoginInfo = 3179,
    LoginNoviceTaskView_RefreshCurView = 3180,
    LoginNoviceTaskView_SetData = 3181,
    LoginTaskSignView_RefreshLoginInfo = 3182,

    ActivityView_InitPageInfo = 3191,
    ActivityFirstBuyView_InitViewInfo = 3192,
    ActivityView_Refresh = 3193,
    ActivityView_RefreshChargeState = 3194,
    ActivityView_SetData = 3196,
    ActivityCashRegisterView_OpenByUrl = 3197,
    ActivityChoosePayView_InitViewInfo = 3198,

    --encyclopedia
    EncyclopediaView_ChoosePage = 3201,
    EncyclopediaDetailView_SetData = 3202,

    ArticleFilterView_ArticleSetData = 3211,
    ArticleFilterView_AssembleSiftSetData = 3212,


    ---新手引导
    GuideEnter = 3220,
    GuideExecute = 3221,
    ClickGuideEnd = 3222,
    ClickGuideOpenSkip = 3223,
    OpenBattleBreakButton = 3224,

    ---排行榜
    RankListView_SetData = 3230,
    RankListRewardView_SetData = 3231,
    RaceRankRankListRewardView_SetData = 3232,

    ---跑马灯
    TopLeftInfoView_UpdateRollText_System =3240,
    TopLeftInfoView_UpdateRollText_Player=3241,

    ---道具直购
    BuyDirectViewSetData = 3250,
    BuyDirectViewRefresh = 3251,

    ---主页面排行榜
    MainRankingListView_SetData = 3261,
    MainRankingListView_SetCar = 3262,

    ---赛道科技
    TrackScienceMenuView_InitData = 3270,
    TrackScienceMenuView_InitTimeData = 3271,
    TrackScienceMenuView_InitIntroduceData = 3272,
    TrackScienceMenuView_InitManufactureIntroduceData = 3273,
    TrackScienceMenuView_UpdateTimeList = 3274,
    TrackScienceMenuView_UpdateTitleScroll = 3275,
    TrackScienceMenuView_UpdateMouldScroll = 3276,

    ---配件仓库
    AccessoryWarehouseView_InitData = 3280,
    AccessoryWarehouseView_RefreshData = 3281,

    ---SeasonOrderView
    SeasonOrderView_SetData=3291,
    SeasonOrderLevelView_SetData=3292,
    SeasonOrderView_BuyFinish=3293,
    SeasonOrderTaskView_SetData=3294,
    SeasonOrderView_SetLuaViewInfo=3295,

    ---挑战赛
    ChallengeMatch_InitData = 3300,
    ChallengeMatch_RefreshData = 3301,
    ChallengeMatchCreate_RefreshChooseTrack = 3302,
    ChallengeMatchCreate_RefreshChooseScene = 3303,
    ChallengeMatchCreate_RefreshChooseTicket = 3304,

    ---挑战赛排行榜
    ChallengeMathRankingListView_SetData=3310,

    QuickGetArticleView_SetData=3330,

    ---通用活动
    CommonFestival_RefreshChooseBtn = 3340,
    CommonFestival_RefreshSignInByID = 3341,
    CommonFestival_RefreshExchangeByID = 3342,
    CommonFestival_RefreshTips = 3343,
    CommonFestival_RefreshChargeByID = 3344,
    CommonFestival_RefreshLastGiftState = 3345,
    CommonFestival_RefreshLimitTask = 3346,
    CommonFestival_RefreshLimitTaskTurn = 3347,
    CommonFestival_RefreshLimitTaskMove = 3348,

    CommonAct_PageRunAction=3349,

    ---激走赛


    RankTrotSelectTrack_SetData =3350,
    RankTrotSelectEnemy_SetData =3351,
    RankTrotSelectCar_SetData =3352,
    RankTrotHistory_SetData =3353,
    RankTrotRankShow_SetData =3354,
    RankTrotRankReward_SetData =3355,
    RankTrotRankList_SetData =3356,
    RankTrotSelectEnemy_RefreshWatch =3357,

    ---私人家园
    PersonalHome_OnClick=3360,
    PersonalHome_OnBeginDrag=3361,
    PersonalHome_Exchange=3362,
    PersonalHomeViewUpdateTog = 3363,
    PersonalHomeViewSetData = 3364,
    PersonalHomeView_ChangeSign = 3365,
    PersonalHomeView_ChangeName = 3366,
    PersonalHomeExhibitAssembleOver = 3367,
    PersonalHomeClearView=3371,


    PersonalHomeStorageView_SetData = 3368,
    ExhibitViewSetData = 3369,

    --- 趣味答题
    ExaminationView_RefreshDetails = 3370,

    --- 老玩家回归
    ReturnOldPlayer_RefreshChooseBtn = 3380,
    ReturnOldPlayer_SetSign = 3381,
    ReturnOldPlayer_SetTask = 3382,
    ReturnOldPlayer_SetBox = 3383,
    ReturnOldPlayer_SetSupport = 3384,


    --- JCP赛事
    RaceJCPView_SetData = 3392,
    RaceJCPJoinView_SetData = 3393,
    RaceJCPJoinView_PlayerReady=3394,
    RaceJcpRankListView_SetData =3395,
    RaceJcpRankListReward_SetData=3396,

    ---RaceClub3v3
    RefreshRaceClub3v3Reward=3400,

    ---月签到刷新
    MonthSignListDataRefresh = 3401,
    ---免费体力刷新
    FreePhysicalPowerRefresh =3402,
    ---观影每日礼赠
    VideoDayGiftInitData = 3403,
    WelfareVideoRefreshBtn = 3404,
    WelfareVideo_PageRunAction = 3405,
    ---观影幸运转盘
    VideoLuckyTableInitData = 3406,
    VideoLuckyTableRefresh = 3407,
    WelfareVideoOpenPage = 3408,
    WelfareReOpen = 3409,

    ---通用活动2
    CommonFestivalTwo_RefreshChooseBtn = 3410,
    CommonFestivalTwo_RefreshCumulative = 3411,
    CommonFestivalTwo_RefreshCustomGift = 3412,
    CommonFestivalTwo_RefreshEveryDay = 3413,
    CommonFestivalTwo_RefreshMoreMoney = 3414,
    CommonFestivalTwo_RefreshChooseBtn2 = 3415,
    CommonFestival_RefreshTipsCustomGiftLock = 3417,

    ---AR
    ARState_Update=3426,

    ---设置喇叭
    SetBroadcastType=3431,

    ---PlayVideo
    VideoPlayer_Play=3440,






    CommonAct_RefreshChooseBtn = 3441,
    CommonAct_RefreshPage = 3442,
    CommonAct_OpenPage = 3443,
    CommonAct_RefreshReOpen = 3444,

    ---觉醒
    LabMainMenu_InitViewInfo = 3450,
    LabMainMenu_OpenCurView = 3451,
    LabMainMenu_RefreshCurView = 3452,
    LabChooseProp_SetData = 3453,


    ---racegvg

    RaceGVG_SetData=3490,
    RaceGVGRankList_SetData=3491,
    RaceGVGResult_SetData=3492,
    RaceGVGRaceState_SetData=3493,




    ---假车库
    GuideGarageView_SetData=3480,
    GuideGarageView_SetPartinfo=3481,
    GuideGarageView_PartReview=3482,
    GuideGarageView_PartChange=3483,
    GuideGarageView_PartRemove=3484,
    GuideGarageView_ResetCar=3485,
    GuideGarageView_ChangeMain=3486,

    ---跳转界面
    TransitView_UpdateData=3487,

    RaceSeniorTrain_SetLevelList = 3490,
    RaceSeniorTrain_UpdateBox = 3491,
    RaceSeniorTrain_Refresh = 3492,

    ---车神传说
    RaceCarGod_InitCarGod = 3500,
    RaceGVG_SetSeasonData = 3501,

    -----宝箱奖励
    --WelfareBoxAward = 3510,
     WelfareBoxAwardHelp = 3510,

    ---租借
    InitRentOrLendInfoByType = 3520,
    InitFriendChoosePart = 3521,
    RefreshFriendExchangeData = 3522,

    RaceSuperBattle_SetData = 3530,
    RaceSuperBattleRankList_SetData = 3531,
    RaceSuperBattleRankList_SetData = 3532,
    RaceSuperBattleBanTrack_SetData = 3533,
    RaceSuperBattleList_SetData = 3534,
    RaceSuperBattleList_Refresh = 3535,
    RaceSuperBattleRecord_SetData = 3536,


    RaceState_SetData = 3540,

    RecruitGoViewSetData = 3550, --扭蛋券特殊直购
    RecruitGoViewRefreshAlert = 3551,
    ChargeTipsSetData = 3560,


    ---ActAdvanceNotice
    ActAdvanceNotice_RefreshChooseBtn = 3561,
    ActAdvanceNotice_RefreshPage = 3562,
    ActAdvanceNotice_OpenPage = 3563,
    ActAdvanceNotice_RefreshReOpen = 3564,
    ActAdvanceNotice_PageRunAction=3565,
    ActAdvanceNotice_UpdatePageNumState = 3566,
    ActAdvanceNotice_RefreshTitleState = 3567,
    ActAdvanceNotice_RefreshTitleSystem = 3568,
    ActAdvanceNotice_RefreshTitleRace = 3569,

    ComicView_PlayAction=3570,
    ComicView_PlayActionImage=3570,

    Mini4wdRuleView_SetData=3580,

    PlayerLevelRewardUpdate=3590,

    PopUpGiftView_SetPageView=3591,
    PopUpGiftView_Refresh=3592,

    IllustratedHandbookView_SetPageView=3593,
    IllustratedHandbookView_RefreshCurView=3594,

    CarVerifyHistoryView_SetData=3600,

    PlayerTipsView_SetData=3610,


    ---BattleStartSwitchView
    OpenSwitchViewData = 3620,

    InheritFilterView_SetData=3630,
    InheritLevelView_SetData=3631,

    ArticleCountSelectView_SetData=3640,
    ArticleCountSelectView_ClickNum=3641,



    TrackPositionSelectView_SetData=3650,

    MultiSelectView_SetData = 3660,


    ---组装赛车库
    AssembleGarageView_SetData=3670,
    AssembleGarageView_SetPartinfo=3671,
    AssembleGarageView_ResetCar=3675,
    AssembleGarageView_Assemble=3672,
    AssembleGarageView_PartReview=3673,


    Part_AwakeResultSetData = 3680,

    ---组装赛比赛
    RaceAssembleSetData=3690,
    RaceAssembleRankingListView_SetData=3700,


    ---RaceTop
    RaceTop_SetData=3710,
    RaceTopGroup_SetData=3711,


    RaceTopSuper_SetData=3720,
    RaceTopGroup2_SetData=3721,

    RaceFifaGuessView_GuessSuccess=3730,
    RaceFifaGroupView_GuessSuccess=3731,
    RaceFifaGuessView_SetData=3732,
    RaceFifaTeamListView_SetDataGuess=3733,
    RaceFifaTeamListView_SetDataCountry=3734,

    NewBieChapterListView_SetLevelList = 3740,
    NewBieChapterListView_UpdateBox = 3741,
    NewBieChapterListView_Refresh = 3742,
    NewBieChapterListView_SetViewInfo = 3743,
    NewPlayerSelectCarViewSetData = 3745,

    RaceTestRunSetData=3750,

    ArticleDisassembleViewRefresh=3760,
    ArticleDisassembleViewSetData=3761,

    RaceRankSelectTrack_SetData = 3770,
    RaceRankNew_SetData = 3771,
    Game4WDBind_SetData = 3772,


    StrengthSprint_RefreshData = 3780,
    StrengthSprint_OpenActivity = 3781,
    RecruitSprint_Refresh = 3782,
    FoundPassToggleView_SetToggle = 3783,
    FoundPassToggleView_CloseView = 3784,
    FoundPassStory_Refresh = 3785,
    FoundPassLevel_Refresh = 3786,
    FoundPassCarGod_Refresh = 3788,


    RaceXCPView_SetData = 3790,
    RaceXCPJoinView_SetData = 3791,
    RaceXCPJoinView_PlayerReady=3792,
    RaceXCPRankListReward_SetData =3793,
    RaceXCPRankListView_SetData =3794,

}
