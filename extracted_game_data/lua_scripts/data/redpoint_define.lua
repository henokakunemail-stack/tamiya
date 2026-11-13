
---@class RedPointType
RedPointType = {
    None = 0,--
    Server = 1, --服务器控制数据
    Client = 2, --客户端控制数据
}

---@class RedPointUIRefreshType
RedPointUIRefreshType = {
    Realtime = 1, --有数据变更及时刷新

}
---@class RedPointServerID
RedPointServerID = {
    S_Chapter = 1,  --章节奖励
    S_SpecialChallenge = 2, -- 训练pve
    S_Synthesis = 4,--配件合成
    S_PartLevel = 5,--配件升级
    S_LabActivation = 6,--科技激活
    S_TrackCreate = 7,--赛道生成
    S_RecruitFree = 9,--扭蛋免费
    S_SeasonOrderGet = 10,--战令奖励
    S_WeekCardGet = 11,--周卡领取
    S_MonthCardGet = 12,--月卡领取
    S_TaskAchievement = 13,--主线任务
    S_TaskDaily = 14,--日常任务
    S_TaskSeasonOrder = 15,--战令任务
    S_Task_7 = 17,--新手7日任务
    S_RaceRank = 19,--排位赛
    S_MonthSign = 20,--月卡签到
    S_FreePower = 27,--每日体力
    S_LuckInfo = 22,--幸运签
    S_CollectWord = 23,--集字
    S_LuckRotaryTable = 24,--幸运转盘
    S_SpringSignIn= 25,--春节签到
    S_Examination=26,--答题
    S_VideoDayGift=28,--观影
    S_VideoDayGiftSum=29,--观影累计
    S_VideoLuck=30,--转盘
    S_NewBie7Sign=31,--转盘
    S_FriendFriendShip=36,--友情点
    S_FriendFriendAdd=37,--添加好友
    S_ActivitySign=25,--商业化签到
    S_ActivityTask=33,--商业化任务
    S_ActivityReward=22,--商业化奖励
    S_ActivityAllBuy=34,--商业化一键后买
    S_ActivityBuy=34,--商业化连续充值
    S_ActivityNewActivity=38,--商业化新活动
    S_ClubSign=32,--俱乐部签到
    S_ClubTask=16,--俱乐部任务
    S_BoxOpenOrNull=39,--宝箱
    S_ActNewRechargerReward = 40,--新开累充活动
    S_ActSingleDayRechargerReward =41,--单日累计充值
    S_ActRechargerReward =42,--累计充值
    S_ActCharge = 43 , --新礼包
    S_FriendAgreeLendPart = 50, --有同意借出的配件
    S_FriendAskLendPart = 51, --有人申请借配件
    S_FriendAgreeRentPart = 52, --有同意雇佣的配件
    S_FriendAskRentPart = 53,  --用人申请雇佣配件
    S_RaceSelfChapter =44,
    --S_WelfareBoxAward = 55, --有可用宝箱
    --S_WelfareGetBoxAward = 56, --有可领取宝箱
    S_TaskNoviceSchedule = 60, --引导任务
    S_TaskNoviceTrade = 61, --引导任务
    S_Recruit_Task = 4019, --引导任务
    S_Recruit_Count = 4020, --引导任务
}
---@class RedPointFirstLoginID
RedPointFirstLoginID = {
    Examination=4100,--答题
    RaceJcp=4101,--Jcp
    Shop=4102,--商店
    SpecialTraining=4103,--商店
}

---@class RedPointID  红点
RedPointID = {
    --服务器端
    --S_Task = 1,
    S_Chapter = 1,  --章节奖励
    S_SpecialChallenge = 2, -- 训练pve
    S_Synthesis = 4,--配件合成
    S_PartLevel = 5,--配件升级
    S_LabActivation = 6,--科技激活
    S_TrackCreate = 7,--赛道生成
    S_RecruitFree = 9,--扭蛋免费
    S_SeasonOrderGet = 10,--战令奖励
    S_WeekCardGet = 11,--周卡领取
    S_MonthCardGet = 12,--月卡领取
    S_TaskAchievement = 13,--主线任务
    S_TaskDaily = 14,--日常任务
    S_TaskSeasonOrder = 15,--战令任务
    S_Task_7 = 17,--新手7日任务
    S_RaceRank = 19,--排位赛
    S_MonthSign = 20,--月卡签到
    S_FreePower = 27,--每日体力
    S_LuckInfo = 22,--幸运签
    S_CollectWord = 23,--集字
    S_LuckRotaryTable = 24,--幸运转盘
    S_SpringSignIn= 25,--春节签到
    S_Examination=26,--答题
    S_VideoDayGift=28,--观影
    S_VideoDayGiftSum=29,--观影累计
    S_VideoLuck=30,--转盘
    S_NewBie7Sign=31,--转盘
    S_FriendFriendShip=36,--友情点
    S_FriendFriendAdd=37,--添加好友
    S_ActivitySign=25,--商业化签到
    S_ActivityTask=33,--商业化任务
    S_ActivityReward=22,--商业化奖励
    S_ActivityAllBuy=34,--商业化一键后买
    S_ActivityBuy=34,--商业化连续充值
    S_ActivityNewActivity=38,--商业化新活动
    S_ClubSign=32,--俱乐部签到
    S_ClubTask=16,--俱乐部任务
    S_ActNewRechargerReward = 40,--新开累充活动
    S_ActSingleDayRechargerReward =41,--单日累计充值
    S_ActRechargerReward =42,--累计充值
    S_ActCharge = 44 , --新礼包
    S_RaceSelfChapter =45,--活动章节

    S_FriendAgreeLendPart = 50, --有同意借出的配件
    S_FriendAskLendPart = 51, --有人申请借配件
    S_FriendAgreeRentPart = 52, --有同意雇佣的配件
    S_FriendAskRentPart = 53,  --用人申请雇佣配件

    S_BoxOpenOrNull = 39, --宝箱
    --S_WelfareBoxAward = 55, --有可用宝箱
    --S_WelfareGetBoxAward = 56, --有可领取宝箱

    S_TaskNoviceSchedule = 60, --引导任务
    S_TaskNoviceTrade = 61, --引导任务
    S_TaskRank = 62, --引导任务
    S_TaskDailyRank = 63, --引导任务
    S_TaskSpecialTraining = 64, --引导任务
    S_Jcp = 65, --引导任务
    S_Xcp = 66, --引导任务


    S_LabGroup=4000,
    S_SeasonOrder=4001,
    S_Activity=4002,
    S_TaskView=4003,
    S_NewPlayerActivity=4004,
    S_LabPartGroup=4005,
    S_LabTrackGroup=4006,
    S_Welfare=4007, --福利
    S_CommonAct=4008, --通用活動紅點
    S_Friend=4009,
    S_Club=4010,
    S_WelfareVideoGift=4011,
    S_FriendLend=4012,
    S_FriendRent=4013,
    S_RaceGroup=4014,
    S_NoviceTaskGroup=4015,
    S_RankTaskGroup=4016,
    SpecialTrainingGroup=4017,
    S_WelfareBoxAwardState = 4018,
    RecruitGroup=4019,
    S_Recruit_Task = 4020,--抽奖_友情
    S_Recruit_Count = 4021,--抽奖_友情

    RaceJcp=4101,--Jcp
    Shop=4102,--商店
    SpecialTraining=4103,--商店
    RaceSuperBattle=4104,--大乱斗
    RaceXCP=4105,--大乱斗

    --客户端
    Bag = 5010,--背包
    Garage = 5011,
    Chat = 5020,--聊天
    Recruit = 5030,--抽奖
    Recruit_Diamond = 5031,--抽奖_钻石
    Recruit_Gold = 5032,--抽奖_金币
    Recruit_Friend = 5033,--抽奖_友情
    Ask = 5040,--调查问卷
    Task = 5050,--任务
    Task_Daily = 5051,--任务日常
    Task_Week = 5052,--任务周长
    Task_Achievement = 5053,--任务周长
    ActivityPay = 5054,--任务周长
    RaceTrot=5060,--黄金联赛
    RaceClubPoint=5070,--俱乐部积分赛






    LoginActivity_Login=5070,--新手活动
    LoginActivity_Sign=5071,--新手活动七日签到
    LoginActivity_NoviceTask=5072,--新手活动活动

    Activity_FirstBuy=5080,--首充


    Email=5090,--邮件

    Activity_Welfare=5110,--福利

    CollectWord_StartIndex = 5120,--集字  5120-5139 --动态生成
    CollectWord_EndIndex = 5139,--集字  5120-5139 --动态生成

    PlayerLevelReward = 5150,--等级奖励
}

local function GetRedPointTable(startIndex,endIndex)
    local tempTable={}
    for i = startIndex, endIndex do
        tempTable[i]=i-startIndex+1
    end
    return tempTable
end


---@class RedPointGroupID  红点组，客户端对id的分类整合
RedPointGroupID=
{
    [RedPointID.S_LabGroup]={
        [RedPointID.S_Synthesis]=1,
        [RedPointID.S_PartLevel]=2,
        [RedPointID.S_LabActivation]=3,
        [RedPointID.S_TrackCreate]=4,
    },
    [RedPointID.S_LabPartGroup]={
        [RedPointID.S_Synthesis]=1,
        [RedPointID.S_PartLevel]=2,
    },
    [RedPointID.S_LabTrackGroup]={
        [RedPointID.S_LabActivation]=1,
        [RedPointID.S_TrackCreate]=2,
    },
    [RedPointID.S_SeasonOrder]={
        [RedPointID.S_SeasonOrderGet]=1,
        [RedPointID.S_TaskSeasonOrder]=2,
    },
    [RedPointID.S_Activity] = {
        [RedPointID.S_WeekCardGet] = 1,
        [RedPointID.S_MonthCardGet] = 2,
        [RedPointID.S_ActCharge] = 3,
    },
    [RedPointID.S_NewPlayerActivity]={
        [RedPointID.S_Task_7]=1,
        [RedPointID.LoginActivity_Sign]=1,
    },

    [RedPointID.S_TaskView]={
        [RedPointID.S_TaskAchievement]=1,
        [RedPointID.S_TaskDaily]=2,
        [RedPointID.S_NoviceTaskGroup] = 3,
    },
    [RedPointID.S_NoviceTaskGroup]={
        [RedPointID.S_TaskNoviceSchedule] = 1,
        [RedPointID.S_TaskNoviceTrade] = 2,
    },
    [RedPointID.S_RankTaskGroup]={
        [RedPointID.S_TaskRank] = 1,
        [RedPointID.S_TaskDailyRank] = 2,
    },

    [RedPointID.S_Welfare] = {
        [RedPointID.S_MonthSign] = 1,
        [RedPointID.S_FreePower] = 2,
        [RedPointID.S_VideoDayGift] = 3,
        [RedPointID.S_VideoDayGiftSum] = 4,
        [RedPointID.S_VideoLuck] = 5,
        [RedPointID.S_Examination] = 6,
        [RedPointID.S_WelfareBoxAwardState] = 7,
    },

    [RedPointID.S_WelfareVideoGift]={
        [RedPointID.S_VideoDayGift]=1,
        [RedPointID.S_VideoDayGiftSum]=2,
    },

    [RedPointID.S_WelfareBoxAwardState]={
        [RedPointID.S_BoxOpenOrNull] = 1,
        --[RedPointID.S_WelfareBoxAward] = 2,
        --[RedPointID.S_WelfareGetBoxAward] = 3,
    },

    [RedPointID.S_CommonAct]={
        [RedPointID.S_LuckInfo]=1,
        [RedPointID.S_CollectWord]=2,
        [RedPointID.S_LuckRotaryTable]=3,
        [RedPointID.S_SpringSignIn]=4,
        --[RedPointID.S_ActivityNewActivity]=5,
        [RedPointID.S_ActivityBuy]=6,
        [RedPointID.S_ActivityAllBuy]=7,
        [RedPointID.S_ActivityReward]=8,
        --[RedPointID.S_ActivityTask]=9,
        [RedPointID.S_ActivitySign]=10,
        [RedPointID.S_ActNewRechargerReward]=11,
        [RedPointID.S_ActSingleDayRechargerReward]=12,
        [RedPointID.S_ActRechargerReward]=13,
    },
    [RedPointID.S_Friend]={
        [RedPointID.S_FriendFriendShip]=1,
        [RedPointID.S_FriendFriendAdd]=2,
        [RedPointID.S_FriendRent] = 3,
        [RedPointID.S_FriendLend] = 4,
    },
    [RedPointID.S_FriendRent] = {
        [RedPointID.S_FriendAgreeRentPart] = 1,
        [RedPointID.S_FriendAskRentPart] = 2,
    },
    [RedPointID.SpecialTrainingGroup]={
      [RedPointID.SpecialTraining]=1,
      [RedPointID.S_TaskSpecialTraining]=2,
    },
    [RedPointID.S_FriendLend] = {
        [RedPointID.S_FriendAgreeLendPart] = 1,
        [RedPointID.S_FriendAskLendPart] = 2,
    },
    [RedPointID.S_Club]={
        [RedPointID.S_ClubSign]=1,
        [RedPointID.S_ClubTask]=2,
    },
    [RedPointID.S_RaceGroup]={
        [RedPointID.S_RaceRank]=1,
        [RedPointID.S_RaceSelfChapter]=2,
    },
    [RedPointID.RecruitGroup]={
        [RedPointID.S_RecruitFree]=1,
        [RedPointID.S_Recruit_Task]=2,
        [RedPointID.S_Recruit_Count]=3,
    },
    [RedPointID.S_CollectWord] = GetRedPointTable(RedPointID.CollectWord_StartIndex,RedPointID.CollectWord_EndIndex),
}
