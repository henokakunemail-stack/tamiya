NetSubSystemNames = {
    login_subsystem = "login_subsystem",
    email_subsystem = "email_subsystem",
    knapsack_subsystem = "knapsack_subsystem",
    friend_subsystem = "friend_subsystem",
    task_subsystem = "task_subsystem",
    redpoint_subsystem = "redpoint_subsystem",
    notice_subsystem = "notice_subsystem",
    chapter_subsystem = "chapter_subsystem",
    team_subsystem = "team_subsystem",
    assemble_subsystem = "assemble_subsystem",
    battle_subsystem = "battle_subsystem",
    appearance_subsystem = "appearance_subsystem",
    shop_subsystem = "shop_subsystem",
    error_subsystem = "error_subsystem",
    club_subsystem = "club_subsystem",
    clubtrain_subsystem = "clubtrain_subsystem",
    common_subsystem = "common_subsystem",
    guide_subsystem = "guide_subsystem",
    recruit_subsystem = "recruit_subsystem",
    chat_subsystem = "chat_subsystem",
    reform_subsystem = "reform_subsystem",
    stamina_subsystem = "stamina_subsystem",
    newbieguide_subsystem = "newbieguide_subsystem",
    refreshplayerattr_subsystem = "refreshplayerattr_subsystem",
    raceroom_subsystem = "raceroom_subsystem",
    customtrack_subsystem = "customtrack_subsystem",
    lab_subsystem = "lab_subsystem",
    challenge_subsystem = "challenge_subsystem",
    playerinfo_subsystem = "playerinfo_subsystem",
    raceself_subsystem = "raceself_subsystem",
    selfchallenge_subsystem = "selfchallenge_subsystem",
    suit_subsystem = "suit_subsystem",
    raceweek_subsystem = "raceweek_subsystem",
    racerank_subsystem = "racerank_subsystem",
    survey_subsystem = "survey_subsystem",
    raceselfchapter_subsystem = "raceselfchapter_subsystem",
    raceselflevel_subsystem = "raceselflevel_subsystem",
    clubraceselfchapter_subsystem = "clubraceselfchapter_subsystem",
    clubraceselflevel_subsystem = "clubraceselflevel_subsystem",
    logintask_subsystem = "logintask_subsystem",
    activity_subsystem = "activity_subsystem",
    rankinglist_subsystem = "rankinglist_subsystem",
    limitchapter_subsystem = "limitchapter_subsystem",
    seasonorder_subsystem = "seasonorder_subsystem",
    warehouse_subsystem = "warehouse_subsystem",
    challengematch_subsystem = "challengematch_subsystem",
    personalhome_subsystem="personalhome_subsystem",
    commonfestival_subsystem = "commonfestival_subsystem",
    racetrot_subsystem = "racetrot_subsystem",
    examination_subsystem = "examination_subsystem",
    returnoldplayer_subsystem = "returnoldplayer_subsystem",
    racejcp_subsystem = "racejcp_subsystem",
    racexcup_subsystem = "racexcup_subsystem",
    raceclub3v3_subsystem = "raceclub3v3_subsystem",
    monthsign_subsystem = "monthsign_subsystem",
    freephysicalpower_subsystem = "freephysicalpower_subsystem",
    racetop_subsystem = "racetop_subsystem",
    racetopsuper_subsystem = "racetopsuper_subsystem",
    racegvg_subsystem = "racegvg_subsystem",
    raceseniortrain_subsystem="raceseniortrain_subsystem",
    racecargod_subsystem="racecargod_subsystem",
    racesuperbattle_subsystem="racesuperbattle_subsystem",
    minigame_subsystem="minigame_subsystem",
    rentandlend_subsystem = "rentandlend_subsystem",
    boxaward_subsystem = "boxaward_subsystem",
    illustratedhandbook_subsystem = "illustratedhandbook_subsystem",
    raceassemble_subsystem = "raceassemble_subsystem",
    raceassembleadd_subsystem = "raceassembleadd_subsystem",
    racefifa_subsystem = "racefifa_subsystem",
    capyactivity_subsystem = "capyactivity_subsystem",
    found_subsystem = "found_subsystem",
    adreward_subsystem = "adreward_subsystem",
}

MsgID = {
    ERROR_RES = 999,
    BROAD_MSG_S2C_NOTICE = 197,
    --{{{登录注册
    REGISTER_SERVER_C2S_REQ = 80, --注册账号
    REGISTER_SERVER_S2C_RES = 81,
    GET_SERVER_LIST_C2S_REQ = 90, --请求服务器列表
    GET_SERVER_LIST_S2C_RES = 91,
    ENTER_SERVER_C2S_REQ = 93, --进入game
    ENTER_SERVER_S2C_RES = 94,
    ENTER_SERVER_GET_PART_C2S_REQ = 100,
    ENTER_SERVER_PART_S2C_RES = 101,
    ENTER_RECONNECT_C2S_RES = 96, --重连
    CREATE_ROLE_C2S_REQ = 833, --选车
    CREATE_ROLE_S2C_RES = 834, --选车
    ADVANCE_CREATE_ROLE_C2S_REQ = 92, --选车
    --}}}
    --{{{玩家信息
    CHANGE_PLAYER_INFO_C2S_REQ = 298,
    CHANGE_PLAYER_INFO_S2C_RES = 299,

    CHANGE_PLAYER_NAME_C2S_REQ = 281,
    CHANGE_PLAYER_NAME_S2C_RES = 282,
    CHANGE_PLAYER_HEAD_ICON_C2S_REQ = 283,
    CHANGE_PLAYER_HEAD_ICON_S2C_RES = 284,
    CHANGE_PLAYER_SIGN_C2S_REQ = 285,
    CHANGE_PLAYER_SIGN_S2C_RES = 286,

    CHANGE_PLAYER_BG_C2S_REQ=181,
    CHANGE_PLAYER_BG_S2C_RES=182,
    CHANGE_PLAYER_CUPS_C2S_REQ=183,
    CHANGE_PLAYER_CUPS_S2C_RES=184,
    GET_PLAYER_BIND_INFO_C2S_REQ=921,
    GET_PLAYER_BIND_INFO_S2C_RES=922,
    PLAYER_BIND_C2S_REQ=923,
    PLAYER_BIND_S2C_RES=924,
    --}}}
    --{{{公告
    GET_ANNOUNCEMENT_C2S_REQ = 99,
    GET_ANNOUNCEMENT_S2C_RES = 100,
    --}}}
    --{{{跨天刷新
    NOTIFY_NEW_DAY_FRESH_S2C_RES = 103, --通知客户端可以跨天操作
    GET_DAY_FRESH_C2S_REQ = 104, --请求跨天操作
    GET_DAY_FRESH_S2C_RES = 105, --请求跨天操作返回
    --}}}
    --{{{体力
    GET_REBACK_PWR_C2S_REQ = 106, --请求回复体力
    GET_REBACK_PWR_S2C_RES = 107, --请求回复体力返回
    GET_USE_DRUG_PWR_C2S_REQ = 110, --使用体力药剂
    GET_USE_DRUG_PWR_S2C_RES = 111, --使用体力药剂返回
    --}}}
    --{{{打开礼包
    GET_REWARD_C2S_REQ = 108,
    GET_REWARD_S2C_RES = 109,
    GET_ARTICLE_LEVEL_LIST_C2S_REQ = 620,
    GET_ARTICLE_LEVEL_LIST_S2C_RES = 621,
    --}}}
    --{{{7日签到
    GET_7_SIGN_IN_C2S_REQ = 156,
    GET_7_SIGN_IN_S2C_RES = 157,
    GET_7_SIGN_IN_REWARD_C2S_REQ = 158,
    GET_7_SIGN_IN_REWARD_S2C_RES = 159,
    --}}}
    --{{{车库
    USE_GARAGE_KEY_C2S_REQ = 112, --使用车库钥匙
    USE_GARAGE_KEY_S2C_RES = 113,
    ALTER_PART_C2S_REQ = 114, --更换配件
    ALTER_PART_S2C_RES = 115,
    UNLOAD_PART_C2S_REQ = 116, --卸下配件
    UNLOAD_PART_S2C_RES = 117,
    UP_PART_LV_C2S_REQ = 118, --配件升级
    UP_PART_LV_S2C_RES = 119, --配件升级
    UP_PART_STAR_C2S_REQ = 120, --配件升星
    UP_PART_STAR_S2C_RES = 121, --配件升星
    UP_PART_REFORM_C2S_REQ = 122, --配件改造
    UP_PART_REFORM_S2C_RES = 123, --配件改造
    DEL_PART_REFORM_C2S_REQ = 177, --配件改造删除
    DEL_PART_REFORM_S2C_RES = 178, --配件改造删除
    VERIFY_CAR_C2S_REQ = 368, --配件改造删除
    VERIFY_CAR_S2C_RES = 369, --配件改造删除
    PART_UP_REFORM_C2S_REQ = 124, --配件强化
    PART_UP_REFORM_S2C_RES = 125, --配件强化
    PART_REFORM_AGAIN_C2S_REQ = 126, --配件重铸
    PART_REFORM_AGAIN_S2C_RES = 127, --配件重铸
    SHELL_HOLE_C2S_REQ = 143, --车壳打孔
    SHELL_HOLE_S2C_RES = 144, --车壳打孔
    SHELL_SCARF_C2S_REQ = 145, --车壳纱网
    SHELL_SCARF_S2C_RES = 146, --车壳纱网
    SHELL_COLOR_C2S_REQ = 147, --车壳喷漆
    SHELL_COLOR_S2C_RES = 148, --车壳
    SHELL_ALTER_STICK_C2S_REQ = 149, --车壳贴纸
    SHELL_ALTER_STICK_S2C_RES = 150, --车壳贴纸
    SHELL_RESET_C2S_REQ = 261, --车壳还原 0喷漆   1贴纸  2孔位  3纱网
    SHELL_RESET_S2C_RES = 262, --
    ADD_ARTICLE_LOCK_C2S_REQ = 219, --车壳还原 0喷漆   1贴纸  2孔位  3纱网
    ADD_ARTICLE_LOCK_S2C_RES = 220, --
    ALTER_PART_COPY_C2S_REQ = 595, --更换配件
    ALTER_PART_COPY_S2C_RES = 596,
    INHERIT_PART_C2S_REQ = 570, --请求传承
    INHERIT_PART_S2C_RES = 571,
    INHERIT_PART_LEVEL_UP_C2S_REQ = 572, --请求传承升级
    INHERIT_PART_LEVEL_UP_S2C_RES = 573,
    INHERIT_PART_RECASTING_C2S_REQ = 364, --请求传承重铸
    INHERIT_PART_RECASTING_S2C_RES = 365,
    INHERIT_PART_DEL_C2S_REQ = 366, --请求传承删除
    INHERIT_PART_DEL_S2C_RES = 367,
    BREAK_UP_C2S_REQ = 566, --请求觉醒P2=配件id
    BREAK_UP_S2C_RES = 567, --返回觉醒
    --}}}
    --{{{商店
    GET_SHOP_INFO_C2S_REQ = 223, --获取商店信息
    GET_SHOP_INFO_S2C_RES = 224,
    REFRESH_SHOP_C2S_REQ = 225, --刷新商店
    REFRESH_SHOP_S2C_RES = 226,
    BUY_GOOD_C2S_REQ = 227, --购买物品
    BUY_GOOD_S2C_RES = 228,
    --}}}
    --{{{邮件
    READ_MAIL_C2S_REQ = 200, --获取所有邮件
    READ_MAIL_S2C_RES = 201,
    GET_MAIL_C2S_REQ = 202, --领取邮件
    GET_MAIL_S2C_RES = 203,
    DELETE_MAIL_C2S_REQ = 204, --删除单个邮件
    DELETE_MAIL_S2C_RES = 205,
    NEW_MAIL_S2C_RES = 206, --新邮件
    --}}}
    --{{{实验室
    DECOMPOSE_PART_C2S_REQ = 128, --分解
    DECOMPOSE_PART_S2C_RES = 129,
    USE_COMPOSE_DRAW_C2S_REQ = 141, --使用图纸
    USE_COMPOSE_DRAW_S2C_RES = 142,



    SPECIAL_PART_C2S_REQ = 568, -- 请求限定合成列表
    SPECIAL_PART_S2C_RES = 569, -- 返回限定合成列表
    UNLOCK_PIC_C2S_REQ = 575, -- 请求解锁合成配件P2=配件id
    UNLOCK_PIC_S2C_RES = 576, -- 返回解锁限定合成配件
    COMPOSE_SPECIAL_C2S_REQ = 577, -- 请求合成限定配件P2=配件id
    COMPOSE_SPECIAL_S2C_RES = 578, -- 返回合成限定配件
    COMPOSE_LIST_C2S_REQ = 579, -- 请求合成列表
    COMPOSE_LIST_S2C_RES = 580, -- 返回合成列表
    COMPOSE_C2S_REQ = 581, -- 请求合成P2=配件id
    COMPOSE_S2C_RES = 582, -- 返回合成
    UP_LEV_BUILDER_C2S_REQ = 583, -- 请求升级改造师
    UP_LEV_BUILDER_S2C_RES = 584, -- 返回升级改造师等级
    COMPOSE_PART_NEW_C2S_REQ = 831, -- 请求合成
    COMPOSE_PART_NEW_S2C_RES = 832, -- 请求返回


    --}}}

    --{{{道具直购
    BUY_DIRECT_C2S_REQ = 195, --请求购买直接购买道具P2=道具idP3=数量
    BUY_DIRECT_S2C_RES = 196, --返回直接购买道具
    --}}}

    --{{{购买金币
    EX_CH_GOLD_C2S_REQ = 179, --请求点金手 P2=次数
    EX_CH_GOLD_S2C_RES = 180, --返回点金结果
    --}}}


    --{{{扭蛋券快捷
    REQ_CHARGE_C2S_REQ = 494, --请求充值档位
    RET_CHARGE_S2C_RES = 495, --返回请求充值档位
    REQ_DIRECT_ALERT_C2S_REQ = 140, --请求设置直购弹出提醒P2=道具idP3=coinidP4=0不弹1弹出
    RET_DIRECT_ALERT_S2C_RES = 141, --返回设置直购弹出提醒
    --}}}

    --{{{商业化活动
    REQ_FIRST_CHARGE_C2S_REQ = 233, --请求首充奖励 P2发天数
    RET_FIRST_CHARGE_S2C_RES = 234, --返回首充奖励
    PERIOD_GIFT_C2S_REQ = 239, --请求领取周月卡奖励
    PERIOD_GIFT_S2C_RES = 240, --领取周月卡奖励
    ACTIVITY_INFO_C2S_REQ = 241, --请求活动信息 P2=当前第一个活动id的所有giftid
    ACTIVITY_INFO_S2C_RES = 242, --返回活动信息
    GROWTH_UP_GIFT_C2S_REQ = 237, --请求领取成长战令
    GROWTH_UP_GIFT_C2S_RES = 238, --返回领取成长战令
    ACT_LEVEL_UP_C2S_REQ = 235, --请求领取成长战令II
    ACT_LEVEL_UP_C2S_RES = 236, --返回领取成长战令II
    --}}}

    --{{{通用活动
    REQ_ACT_SIGN_NFO = 249, --请求签到活动信息 P2=actid
    RET_ACT_SIGN_NFO = 250, --返回签到活动
    REQ_ACT_SIGN_NOW = 251, --请求签到P2=actid P3=签到天 P4=0正常1补签
    RET_ACT_SIGN_NOW = 252, --返回签到
    REQ_ACT_SHOP_INFO = 253, --请求活动兑换商城
    RET_ACT_SHOP_INFO = 254, --返回活动兑换商城
    REQ_BUY_ACT_SHOP = 255, --请求兑换商城物品P2=shopid P3=商品idP4=数量
    RET_BUY_ACT_SHOP = 256, --返回活动商城
    REQ_ACT_DAY_GIFT = 257, --请求查看活动日礼包 P2=活动id
    RET_ACT_DAY_GIFT = 258, --返回活动日礼包
    REQ_ACT_DAY_FINISH = 259, --请求活动日礼包最终奖励 P2=活动id
    RET_ACT_DAY_FINISH = 260, --返回最终奖励
    REQ_ACT_CHARGE_GIFT = 267, --请求查看暴击充值礼包P2=活动id
    RET_ACT_CHARGE_GIFT = 268, --返回查看暴击充值礼包
    REQ_COUNT_CHARGE = 269, --请求累计充值P2=活动id
    RET_COUNT_CHARGE = 270, --返回累计充值
    REQ_COUNT_GIFT = 271, --请求累计充值奖励P2=活动idP3=序号0开始
    RET_COUNT_GIFT = 272, --累计充值奖励
    REQ_DESIGN_GIFT = 277, --请求定制礼包P2=actID
    RET_DESIGN_GIFT = 278, --返回定制礼包
    REQ_ACT_MISSION = 287, --请求抽取活动任务P2=次数
    RET_ACT_MISSION = 288, --返回活动任务
    REQ_LOCK_DESIGN = 289, --请求定制礼包锁定 p2=充值项id P3=自定礼包充值串
    RET_LOCK_DESIGN = 290, --返回定制礼包锁定
    REQ_LUCK_INFO = 291, --请求幸运签信息
    RET_LUCK_INFO = 292, --返回幸运签
    REQ_LUCK_AWARD = 293, --请求幸运签
    RET_LUCK_AWARD = 294, --返回幸运签
    REQ_LUCKY_TABLE = 295, --"请求幸运转盘 P2=次数
    RET_LUCKY_TABLE = 296, --返回幸运转盘
    REQ_ACT_WORD_LIST = 229, --请求集字奖励
    RET_ACT_WORD_LIST = 230, --返回集字奖励列表
    REQ_ACT_WORD_GIFT = 231, --请求领取集字奖励 P2=奖励id
    RET_ACT_WORD_GIFT = 232, --返回集字奖励

    --}}}

    --{{{ 趣味答题
    REQ_QUESTION = 659, --请求题库
    RET_QUESTION = 660, --返回题库
    REQ_ANSWER = 661, --请求答题
    RET_ANSWER = 662, --返回答题
    --}}}

    --{{{老玩家回归
    REQ_REBACK_SIGN_INFO = 263, --请求回归签到信息
    RET_REBACK_SIGN_INFO = 264, --返回回归签到信息
    REQ_REBACK_SIGN = 265, --请求回归签到P2=天数P3=0/1普通高级
    RET_REBACK_SIGN = 266, --返回回归签到
    RE_BACK_SUPPORT_C2S_REQ = 526, --请求回归支援列表
    RE_BACK_SUPPORT_S2C_RES = 527, --返回回归支援列表
    SUPPORT_PART_C2S_REQ = 528, --请求支援P2=槽位locP3=配件id
    SUPPORT_PART_S2C_RES = 529, --返回支援
    --}}}

    --{{{俱乐部
    ACCEPT_GUILD_C2S_REQ = 300, --请求审核俱乐部成员
    ACCEPT_GUILD_S2C_RES = 301,

    CREATE_GUILD_C2S_REQ = 302, --请求创建俱乐部
    CREATE_GUILD_S2C_RES = 303,

    GET_GUILD_INFO_C2S_REQ = 304, --请求俱乐部信息
    GET_GUILD_INFO_S2C_RES = 305,

    CHANGE_GUILD_INFO_C2S_REQ = 306, --请求修改俱乐部信息
    CHANGE_GUILD_INFO_S2C_RES = 307,

    GET_GUILD_APPLY_LIST_C2S_REQ = 308, --请求俱乐部的申请列表
    GET_GUILD_APPLY_LIST_S2C_RES = 309,

    REFUSE_GUILD_APPLY_C2S_REQ = 310, --请求拒绝申请
    REFUSE_GUILD_APPLY_S2C_RES = 311,

    EXIT_GUILD_C2S_REQ = 312, --请求退出俱乐部
    EXIT_GUILD_S2C_RES = 313,

    KICK_GUILD_C2S_REQ = 314, --请求踢出俱乐部
    KICK_GUILD_S2C_RES = 315,

    JOIN_GUILD_C2S_REQ = 316, --请求加入俱乐部
    JOIN_GUILD_S2C_RES = 317,

    SEARCH_GUILD_C2S_REQ = 318, --请求搜索俱乐部
    SEARCH_GUILD_S2C_RES = 319,

    CHANGE_POS_GUILD_C2S_REQ = 320, --请求俱乐部改变职位
    CHANGE_POS_GUILD_S2C_RES = 321,

    SEND_GUILD_C2S_REQ = 322, --请求俱乐部转让
    SEND_GUILD_S2C_RES = 323,

    DONATE_GUILD_C2S_REQ = 324, --请求俱乐部贡献
    DONATE_GUILD_S2C_RES = 325,

    RECOMMEND_GUILD_C2S_REQ = 326, --请求推荐俱乐部
    RECOMMEND_GUILD_S2C_RES = 327,

    --RANK_GUILD_C2S_REQ=328,--请求俱乐部排行
    --RANK_GUILD_S2C_RES=329,
    SIGN_GUILD_C2S_REQ = 328, --请求俱乐部签到
    SIGN_GUILD_S2C_RES = 329,

    ACTION_GUILD_S2C_RES = 330, --通知被操作的玩家刷新俱乐部信息

    CHANGE_GUILD_NAME_C2S_REQ = 331, --请求修改俱乐部信息
    CHANGE_GUILD_NAME_S2C_RES = 332,

    --}}}
    --{{{好友
    GET_FRIEND_LIST_C2S_REQ = 340, --请求好友列表
    GET_FRIEND_LIST_S2C_RES = 341,

    GET_APPLY_FRIEND_LIST_C2S_REQ = 342, --请求好友审核列表
    GET_APPLY_FRIEND_LIST_S2C_RES = 343,

    ADD_FRIEND_C2S_REQ = 344, --请求申请加好友
    ADD_FRIEND_S2C_RES = 345,

    REFUSE_FRIEND_C2S_REQ = 346, --同意 拒绝加好友
    REFUSE_FRIEND_S2C_RES = 347,

    --AGREE_FRIEND_C2S_REQ = 348, --合并成一个
    --AGREE_FRIEND_S2C_RES = 349,

    DEL_FRIEND_C2S_REQ = 350, --删除好友
    DEL_FRIEND_S2C_RES = 351,

    REV_FRIEND_GIFT_C2S_REQ = 352, --领取好友礼物
    REV_FRIEND_GIFT_S2C_RES = 353,

    GIVE_FRIEND_GIFT_C2S_REQ = 354, --赠送好友礼物
    GIVE_FRIEND_GIFT_S2C_RES = 355,

    GET_SEARCH_FRIEND_C2S_REQ = 215, --搜索列表
    GET_SEARCH_FRIEND_S2C_RES = 216,

    GET_RECOMMEND_FRIED_C2S_REQ = 217, --推荐好友
    GET_RECOMMEND_FRIED_S2C_RES = 218,

    --}}}

    --{{{租借
    REQ_FRIEND_PARTS_C2S_REQ = 530, --请求租借好友配件 P2=好友rid
    RET_FRIEND_PARTS_S2C_RES = 531, --返回请求租借好友配件
    REQ_BORROW_PART_C2S_REQ = 532, --请求租借配件 P2=好友rid P3=配件索引 P4=角色名 P5=headicon P6=iconframe P7=curlevel
    RET_BORROW_PART_S2C_RES = 533, --返回请求租借配件
    REQ_ACCEPT_BORROW_C2S_REQ = 534, --同意租借配件 P2=好友rid P3=配件索引
    RET_ACCEPT_BORROW_S2C_RES = 535, --返回同意租借配件
    REQ_DOWN_BORROW_C2S_REQ = 536, --获得租借来的配件 P2=好友rid P3=配件索引
    RET_DOWN_BORROW_S2C_RES = 537, --返回获得租借来的配件

    REQ_BORROW_APP_C2S_REQ = 538, --查看配件租借申请 P2类型 0-我的申请 1-申请我的
    RET_BORROW_APP_S2C_RES = 539, --返回查看配件租借申请
    REQ_DEL_BORROW_APP_C2S_REQ = 540, --删除配件租借申请 P2=好友rid P3=配件索引
    RET_DEL_BORROW_APP_S2C_RES = 541, --返回删除配件租借申请
    REQ_DENY_BORROW_C2S_REQ = 542, --拒绝配件租借申请 P2=申请人rid P3=配件索引
    RET_DENY_BORROW_S2C_RES = 543, --返回拒绝配件租借申请

    REQ_FRIEND_HIRE_C2S_REQ = 544, --请求好友雇佣配件 P2=好友rid
    RET_FRIEND_HIRE_S2C_RES = 545, --返回请求好友雇佣配件
    REQ_HIRE_PART_C2S_REQ = 546, --请求雇佣配件 P2=好友rid P3=配件索引
    RET_HIRE_PART_S2C_RES = 547, --返回请求雇佣配件
    REQ_ACCEPT_HIRE_C2S_REQ = 548, --同意雇佣配件 P2=好友rid P3=配件索引
    RET_ACCEPT_HIRE_S2C_RES = 549, --返回同意雇佣配件
    REQ_DOWN_HIRE_C2S_REQ = 550, --获得雇佣来的配件 P2=好友rid P3=配件索引
    RET_DOWN_HIRE_S2C_RES = 551, --返回获得雇佣来的配件

    REQ_HIRE_APP_C2S_REQ = 552, --查看配件雇佣申请 P2类型 0-我的申请 1-申请我的
    RET_HIRE_APP_S2C_RES = 553, --返回查看配件雇佣申请
    REQ_DEL_HIRE_APP_C2S_REQ = 554, --删除配件雇佣申请 P2=好友rid P3=配件索引
    RET_DEL_HIRE_APP_S2C_RES = 555, --返回删除配件雇佣申请
    REQ_DENY_HIRE_C2S_REQ = 556, --拒绝配件雇佣申请 P2=申请人rid P3=配件索引
    RET_DENY_HIRE_S2C_RES = 557, --返回拒绝配件雇佣申请
    REQ_HIRE_EXCH_COIN_C2S_REQ = 558, --请求雇佣货币兑换信息
    RET_HIRE_EXCH_COIN_S2C_RES = 559, --返回请求雇佣货币兑换信息
    REQ_HIRE_COIN_C2S_REQ = 560, --请求兑换雇佣货币 P2=待换货币id串 P3=数量串
    RET_HIRE_COIN_S2C_RES = 561, --返回请求兑换雇佣货币

    --}}}

    --{{{7日任务
    GET_7_LOGIN_REWARD_C2S_REQ = 229, --请求领取7日登录奖励
    GET_7_LOGIN_REWARD_S2C_RES = 230, --领取7日登录奖励
    GET_MONTH_LOGIN_REWARD_C2S_REQ = 231, --请求领取月登录奖励
    GET_MONTH_LOGIN_REWARD_S2C_RES = 232, --领取月登录奖励
    --}}}
    --{{{
    --}}}
    --{{{扭蛋
    RECRUIT_START_C2S_REQ = 151, --获取奖池信息
    RECRUIT_START_S2C_RES = 152,
    RECRUIT_FINISH_C2S_REQ = 153, --抽奖结束
    RECRUIT_FINISH_S2C_RES = 154,
    RECRUIT_SHARE_C2S_REQ = 211, --分享奖励
    RECRUIT_SHARE_S2C_RES = 212,
    RECRUIT_MINI_EXCHANGE_C2S_REQ = 490, --保底兑换
    RECRUIT_MINI_EXCHANGE_S2C_RES = 491,
    RECRUIT_COUNT_INFO_C2S_REQ = 606, --次数奖励信息
    RECRUIT_COUNT_INFO_S2C_RES = 607,
    RECRUIT_COUNT_GET_REWARD_C2S_REQ = 608, --次数奖励领取
    RECRUIT_COUNT_GET_REWARD_S2C_RES = 609,
    --}}}
    --{{{自定义赛道
    GET_CUSTOM_TRACK_LIST_C2S_REQ = 160, --自定义赛道
    GET_CUSTOM_TRACK_LIST_S2C_RES = 161, --自定义赛道
    SAVE_CUSTOM_TRACK_C2S_REQ = 162, --保存自定义赛道
    SAVE_CUSTOM_TRACK_S2C_RES = 163, --自定义赛道
    DEL_CUSTOM_TRACK_C2S_REQ = 164, --删除自定义赛道
    DEL_CUSTOM_TRACK_S2C_RES = 165, --自定义赛道
    TEST_RUN_CUSTOM_TRACK_C2S_REQ = 213, --试跑自定义赛道
    TEST_RUN_CUSTOM_TRACK_S2C_RES = 214, --自定义赛道
    --}}}
    --{{{任务
    GET_TASK_LIST_REQ = 132, --获取任务列表
    GET_TASK_LIST_RES = 133, --获取任务列表
    GET_TASK_REWARD_REQ = 134, --获取任务奖励
    GET_TASK_REWARD_RES = 135, --
    GET_ACTIVE_REWARD_REQ = 136, --请求活跃奖励
    GET_ACTIVE_REWARD_RES = 137, --
    NOTIFY_TASK_RES = 138, --推送变化任务
    NOTIFY_HEAD_ICON_RES = 139, --推送变化头像
    REQ_TRADE_AWARD_C2S_REQ = 496, --请求引导任务章节奖励P2=章节号
    RET_TRADE_AWARD_S2C_RES = 497, --
    --}}}
    --{{{兑换码
    GET_EXCHANGE_CODE_REQ = 130,
    GET_EXCHANGE_CODE_RES = 131,
    --}}}
    --{{{聊天
    SEND_TALK_C2S_REQ = 191, --聊天信息P2=类型0系统1私聊2工会3房间4世界P3=目标idP4=内容
    NOTIFY_TALK_INFO_S2C_RES = 192, --聊天信息   TalkInfo
    DENY_TALK_REQ = 193,--屏蔽聊天
    DENY_TALK_RES = 194,--屏蔽聊天 DenyTalk
    ACCESS_TALK_REQ = 498,--解除聊天
    ACCESS_TALK_RES = 499,--解除聊天 DenyTalk
    GET_DENY_LIST_TALK_REQ = 593,--获取黑名单列表
    DENY_LIST_TALK_RES = 594,--黑名单列表 DenyTalk
    --}}}


    --{{{ 新手引导
    UPDATE_GUIDE_STEP_C2G_REQ = 155,
    UPDATE_GUIDE_STEP_G2C_RES = 759,
    GET_LEVEL_AWARD_C2S_REQ=618,
    GET_LEVEL_AWARD_S2C_RES=619,
    --}}}
    --{{{章节
    GET_ALL_CHAPTER_C2S_REQ = 370, --请求所有章节信息
    GET_ALL_CHAPTER_S2C_RES = 371,
    GET_CHAPTER_INFO_C2S_REQ = 372, --请求章节具体信息
    GET_CHAPTER_INFO_S2C_RES = 373,
    GET_LEVEL_INFO_C2S_REQ = 374, --请求关卡具体信息
    GET_LEVEL_INFO_S2C_RES = 375,
    GET_CHAPTER_REWARD_C2S_REQ = 376, --请求章节奖励
    GET_CHAPTER_REWARD_S2C_RES = 377,
    CHAPTER_BATTLE_BEGIN_C2S_REQ = 378, --开始战斗
    CHAPTER_BATTLE_BEGIN_S2C_RES = 379,
    CHAPTER_BATTLE_FINISH_C2S_REQ = 380, --战斗结算
    CHAPTER_BATTLE_FINISH_S2C_RES = 381,
    GET_CHAPTER_ALL_REWARD_C2S_REQ = 382,
    GET_CHAPTER_ALL_REWARD_S2C_RES = 383,
    GET_CHAPTER_RANK_LIST_C2S_REQ = 616,
    GET_CHAPTER_RANK_LIST_S2C_RES = 617,
    --}}}
    --{{{活动章节
    GET_ACTIVE_CHAPTER_C2S_REQ = 384, --请求打开活动章节
    GET_ACTIVE_CHAPTER_S2C_RES = 385, --返回打开活动章节
    GET_ONE_ACTIVE_CHAPTER_C2S_REQ = 386, --请求X活动章节
    GET_ONE_ACTIVE_CHAPTER_S2C_RES = 387, --返回X动章节
    BEGIN_ACTIVE_CHAPTER_C2S_REQ = 388, --请求活动章节比赛
    BEGIN_ACTIVE_CHAPTER_S2C_RES = 389, --返回活动章节比赛
    FINISH_ACTIVE_CHAPTER_C2S_REQ = 390, --请求结算活动章节比赛
    FINISH_ACTIVE_CHAPTER_S2C_RES = 391, --返回结算活动章节比赛
    ACTIVE_CHAPTER_STAR_REWARD_C2S_REQ = 818, --请求副本星级奖励
    ACTIVE_CHAPTER_STAR_REWARD_S2C_RES = 819, --返回副本星级奖励
    ACTIVE_CHAPTER_GET_REWARD_C2S_REQ = 820, --请求活动章节奖励
    ACTIVE_CHAPTER_GET_REWARD_S2C_RES = 821, --返回活动章节奖励
    --}}}
    --{{{扫荡
    SWAP_CHAPTER_C2S_REQ = 392,
    SWAP_CHAPTER_S2C_RES = 393,
    --}}}
    --{{{极限挑战
    GET_LIMIT_CHAPTER_C2S_REQ = 394, --请求打开极限章节
    GET_LIMIT_CHAPTER_S2C_RES = 395, --返回打开极限章节
    GET_LIMIT_CHAPTER_ONE_C2S_RES = 396, --请求X极限章节
    GET_LIMIT_CHAPTER_ONE_S2C_RES = 397, --返回X极限章节
    BEGIN_LIMIT_CHAPTER_BATTLE_C2S_RES = 398, --请求极限章节比赛
    BEGIN_LIMIT_CHAPTER_BATTLE_S2C_RES = 399, --返回极限章节比赛
    FINISH_LIMIT_CHAPTER_BATTLE_C2S_RES = 400, --请求结算极限章节比赛
    FINISH_LIMIT_CHAPTER_BATTLE_S2C_RES = 401, --返回结算极限章节比赛
    --}}}
    --{{{ 特训
    GET_TEST_TRAIN_C2S_REQ = 402, --请求特训章节
    GET_TEST_TRAIN_S2C_RES = 403, --返回特训章节
    BEGIN_TEST_TRAIN_C2S_RES = 404, --开始特训章节
    BEGIN_TEST_TRAIN_S2C_RES = 405, --开始特训章节
    FINISH_TEST_TRAIN_C2S_RES = 406, --完成特训章节
    FINISH_TEST_TRAIN_S2C_RES = 407, --完成特训章节
    --}}}
    --{{{排位
    GET_RANK_INFO_C2S_REQ = 433, --请求赛季信息
    GET_RANK_INFO_S2C_RES = 434,
    ENTER_RANK_MATCHING_C2S_REQ = 420, --请求加入赛季匹配pvp
    ENTER_RANK_MATCHING_S2C_RES = 421, --返回加入赛季匹配pvp
    CANCEL_RANK_MATCHING_C2S_REQ = 422, --取消匹配pvp
    CANCEL_RANK_MATCHING_S2C_RES = 423,
    ACCEPT_RANK_MATCHING_C2S_REQ = 424, --请求接受匹配pvp
    ACCEPT_RANK_MATCHING_S2C_RES = 425,
    RANK_MATCHING_SUCCESS_S2C_RES = 426, --返回赛季匹配成功
    RANK_BATTLE_BEGIN_S2C_RES = 427, --返回赛季比赛开始
    RANK_BATTLE_FINISH_C2S_REQ = 428, --请求赛季比赛结束
    RANK_BATTLE_FINISH_S2C_RES = 429, --请求赛季比赛结束
    RANK_LEASE_S2C_RES = 430, --返回匹配解散
    RANK_RE_BATTLE_S2C_RES = 658, --返回匹配解散
    --}}}
    --{{{商业化
    CREATE_ORDER_C2S_REQ = 170, --请求创建订单
    CREATE_ORDER_S2C_RES = 171, --请求创建订单完成
    ORDER_SUCCESS_C2S_REQ = 172, --订单成功可发货
    FINISH_ORDER_C2S_REQ = 173, --请求发货
    FINISH_ORDER_S2C_RES = 174, --发货完成
    CREATE_ORDER_FALSE_C2S_REQ = 903, --临时用的假充值-直接回174发货完成

    CREATE_GOOGLE_ORDER_C2S_REQ = 911, --"请求创建谷歌订单"
    CREATE_GOOGLE_ORDER_S2C_RES = 912, --"订单创建完成"
    CHECK_GOOGLE_ORDER_C2S_REQ = 913, --"请求验证谷歌订单"
    CHECK_GOOGLE_ORDER_S2C_RES = 914, --"谷歌订单验证完成"
    FINISH_GOOGLE_ORDER_C2S_REQ = 915, --"请求谷歌订单发货"
    FINISH_GOOGLE_ORDER_S2C_RES = 916, --"谷歌订单发货完成"
    FINISH_APPLE_ORDER_C2S_REQ = 917, --"请求Apple发货"
    FINISH_APPLE_ORDER_C2S_RES = 918, --"Apple发货完成"
    CREAT_EBR_ORDER_C2S_REQ = 919, --"请求创建巴西充值订单"
    CREAT_EBR_ORDER_C2S_RES = 920, --"创建巴西充值订单完成"

    TOKEN_EXCHANGE_C2S_REQ = 835, --"代币兑换"
    TOKEN_EXCHANGE_S2C_RES = 836, --"代币兑换返回"

    TOKEN_COIN_EXCHANGE_C2S_REQ = 910, --"代币兑换"




    --}}}

    --{{{开启随机宝箱
    OPEN_RAND_BOX_C2S_REQ = 564, --请求打开随机宝箱 P2=宝箱id
    OPEN_RAND_BOX_S2C_RES = 565, --返回请求打开随机宝箱
    SELL_GOODS_C2S_REQ = 1010, --请求分解道具
    SELL_GOODS_S2C_RES = 1011, --返回分解道具
    --}}}

    --{{{回放
    GET_RACE_RECORD_C2S_REQ = 435,
    GET_RACE_RECORD_S2C_RES = 436,
    GET_PVE_RECORD_S2C_RES = 437,
    GET_PVE_RECORD_S2C_RES = 438,
    --}}}
    --{{{ 排行榜
    GET_RANK_LIST_C2S_REQ = 440, --请求排位赛排行榜
    GET_RANK_LIST_S2C_RES = 441,
    GET_USE_CAR_DATA_C2S_REQ = 431,
    GET_USE_CAR_DATA_S2C_REQ = 432,
    --}}}
    --{{{房间赛
    CREATE_RACE_ROOM_C2S_REQ = 628, --创建房间
    CREATE_RACE_ROOM_S2C_RES = 629, --创建房间
    ENTER_RACE_ROOM_C2S_REQ = 630, --进入房间
    ENTER_RACE_ROOM_S2C_RES = 631, --
    EXIT_RACE_ROOM_C2S_REQ = 632, --退出房间
    EXIT_RACE_ROOM_S2C_RES = 633, --
    DISSOLUTION_RACE_ROOM_C2S_REQ = 634, --解散房间
    DISSOLUTION_RACE_ROOM_S2C_RES = 635, --
    KICK_OUT_RACE_ROOM_C2S_REQ = 636, --踢出房间
    KICK_OUT_RACE_ROOM_S2C_RES = 637, --
    READY_RACE_ROOM_C2S_REQ = 638, --准备房间
    READY_RACE_ROOM_S2C_RES = 639, --
    CANCEL_READY_RACE_ROOM_C2S_REQ = 640, --取消准备房间
    CANCEL_RACE_ROOM_S2C_RES = 641, --
    BEGIN_BATTLE_RACE_ROOM_C2S_REQ = 642, --房间战斗
    BEGIN_BATTLE_RACE_ROOM_S2C_RES = 643,
    GET_RACE_ROOM_LIST_C2S_REQ = 644, --
    GET_RACE_ROOM_LIST_S2C_RES = 645, --
    RACE_ROOM_CHANGE_CAR_C2S_REQ = 646, --
    RACE_ROOM_CHANGE_CAR_S2C_RES = 647, --
    RACE_ROOM_CHANGE_TRACK_C2S_REQ = 648, --
    RACE_ROOM_CHANGE_TRACK_S2C_RES = 649, --
    SEARCH_RACE_ROOM_C2S_REQ = 650, --
    SEARCH_RACE_ROOM_S2C_RES = 651, --
    FINISH_RACE_ROOM_C2S_REQ = 652, --
    FINISH_RACE_ROOM_S2C_RES = 653, --
    OBSERVER_RACE_ROOM_C2S_REQ = 626, --进入房间
    OBSERVER_RACE_ROOM_S2C_RES = 627, --
    --}}}
    --{{{战令
    GET_SEASON_ORDER_C2S_RES = 243,
    GET_SEASON_ORDER_S2C_REQ = 244,
    GET_SEASON_ORDER_LEVEL_C2S_RES = 245,
    GET_SEASON_ORDER_LEVEL_S2C_REQ = 246,
    GET_SEASON_ORDER_GIFT_C2S_RES = 247,
    GET_SEASON_ORDER_GIFT_S2C_REQ = 248,
    --}}}

    --{{{配件仓库
    GET_STOREDEC_C2S_RES = 198, --请求分解配件P2=配件ID串P3=配件数量串
    GET_STOREDEC_S2C_REQ = 199, --返回分解配件
    GET_PULLPART_C2S_RES = 207, --仓库取出配件P2=配件id串P3=数量串
    GET_PULLPART_S2C_REQ = 208, --返回取出配件
    GET_OPENSTORE_C2S_RES = 209, --打开配件仓库
    GET_OPENSTORE_S2C_REQ = 210, --返回配件仓库信息
    --}}}

    --{{{赛事挑战
    GET_CREATE_BATTLE_C2S_RES = 452, --请求创建挑战赛
    GET_CREATE_BATTLE_S2C_REQ = 453, --返回创建挑战赛
    GET_BATTLE_LIST_C2S_RES = 454, --请求挑战赛列表
    GET_BATTLE_LIST_S2C_REQ = 455, --返回挑战赛列表
    GET_SEARCH_BATTLE_C2S_RES = 456, --请求搜索挑战赛
    GET_SEARCH_BATTLE_S2C_REQ = 457, --返回搜索挑战赛
    GET_JOIN_BATTLE_C2S_RES = 458, --请求参加挑战赛
    GET_JOIN_BATTLE_S2C_REQ = 459, --返回参加挑战赛
    GET_BEGIN_BATTLE_C2S_RES = 460, --请求开始挑战赛
    GET_BEGIN_BATTLE_S2C_REQ = 461, --返回开始挑战赛
    GET_FINISH_BATTLE_C2S_RES = 462, --请求结算挑战赛
    GET_FINISH_BATTLE_S2C_REQ = 463, --返回结算挑战赛
    GET_BATTLE_DETAIL_C2S_RES = 464, --请求挑战赛详细信息
    GET_BATTLE_DETAIL_S2C_REQ = 465, --返回挑战赛详细信息
    GET_BATTLE_RANK_C2S_RES = 466, --请求挑战赛排行
    GET_BATTLE_RANK_S2C_REQ = 467, --返回挑战赛排行
    GET_BATTLE_AGREE_C2S_RES = 468, --请求挑战赛点赞
    GET_BATTLE_AGREE_S2C_RES = 469, --返回挑战赛点赞
    GET_BATTLE_HISTORY_C2S_RES = 470, --请求挑战赛点赞
    GET_BATTLE_HISTORY_S2C_REQ = 471, --返回挑战赛点赞
    --}}}
    --{{{疾走赛
    RACE_TROT_ENTER_C2S_RES = 472, --请求进入疾走赛
    RACE_TROT_ENTER_S2C_REQ = 473, --返回疾走赛
    RACE_TROT_SELECT_TRACK_C2S_RES = 474, --选中赛道
    RACE_TROT_SELECT_TRACK_S2C_REQ = 475, --返回赛道
    RACE_TROT_SELECT_ENEMY_C2S_RES = 476, --选中对手
    RACE_TROT_SELECT_ENEMY_S2C_REQ = 477, --返回对手
    RACE_TROT_REFRESH_TRACK_C2S_RES = 478, --请求刷新赛道
    RACE_TROT_REFRESH_TRACK_S2C_REQ = 479, --返回新赛道
    RACE_TROT_REFRESH_ENEMY_C2S_RES = 480, --请求刷新对手
    RACE_TROT_REFRESH_ENEMY_S2C_REQ = 481, --刷新对手
    RACE_TROT_OBSERVATION_ENEMY_C2S_RES = 482, --侦查对手
    RACE_TROT_OBSERVATION_ENEMY_S2C_REQ = 483, --返回对手详细信息
    RACE_TROT_BEGIN_BATTLE_C2S_RES = 484, --请求疾跑赛比赛开始
    RACE_TROT_BEGIN_BATTLE_S2C_REQ = 485, --返回疾跑赛比赛开始
    RACE_TROT_RE_BATTLE_C2S_RES = 492, --战斗重连
    RACE_TROT_RE_BATTLE_S2C_REQ = 493, --战斗重连
    RACE_TROT_FINISH_BATTLE_C2S_RES = 486, --请求疾跑赛比赛结算
    RACE_TROT_FINISH_BATTLE_S2C_REQ = 487, --请求疾跑赛比赛结算
    RACE_TROT_RANK_LIST_C2S_RES = 488, --请求疾跑赛比赛结算
    RACE_TROT_RANK_LIST_S2C_REQ = 489, --请求疾跑赛比赛结算

    --RACE_TROT_GET_RECORD_C2S_RES = 474, --请求查看战绩
    --RACE_TROT_GET_RECORD_S2C_REQ = 475, --返回个人战绩





    --}}}
    --{{{ 红点
    RED_TIPS_S2C_NOTIFY = 138,
    --}}}

    --{{{ 个人家园
    PERSONAL_SAVE_HOME_C2S_REQ = 654, --保存个人家园信息
    PERSONAL_SAVE_HOME_S2C_RES = 655, --返回保存家园信息
    PERSONAL_LOOK_HOME_C2S_REQ = 656, --请求查看家园信息
    PERSONAL_LOOK_HOME_S2C_RES = 657, --返回查看家园信息
    --}}}

    --{{{JCP
    JCP_INFO_C2S_REQ = 671, --请求JCP信息
    JCP_INFO_S2C_RET = 672,
    JCP_JOIN_C2S_REQ = 673, --請求JCP报名
    JCP_JOIN_S2C_RET = 674,
    JCP_MATCH_C2S_REQ = 675, --請求加入匹配
    JCP_MATCH_S2C_RET = 676,
    JCP_MATCH_END_S2C_RET = 677,
    JCP_CANCEL_C2S_REQ = 678, --请求取消比配
    JCP_CANCEL_S2C_RET = 679,
    JCP_ACCEPT_C2S_REQ = 680, --请求接受比配
    JCP_ACCEPT_S2C_RET = 681,
    JCP_REFIGH_C2S_REQ = 682, --重连
    JCP_START_S2C_RET = 683, --开始战斗
    JCP_FINISH_C2S_REQ = 684, --请求jcp结算
    JCP_FINISH_S2C_RET = 685,
    JCP_TEST_FINISH_C2S_REQ = 686, --请求试跑jcp结算
    JCP_TEST_FINISH_S2C_RET = 687,
    JCP_REPLAY_C2S_REQ = 688, ---回放
    JCP_REPLAY_S2C_RET = 689,
    --}}}


    --{{{ 俱乐部赛事
    RACE_CLUB3V3_INFO_C2S_REQ = 700,
    RACE_CLUB3V3_INFO_S2C_RES = 701,
    RACE_CLUB3V3_BEGIN_BATTLE_C2S_REQ = 702,
    RACE_CLUB3V3_BEGIN_BATTLE_S2C_RES = 703,
    RACE_CLUB3V3_FINISH_BATTLE_C2S_REQ = 704,
    RACE_CLUB3V3_FINISH_BATTLE_S2C_RES = 705,
    RACE_CLUB3V3_CLUB_REWARD_C2S_REQ = 706,
    RACE_CLUB3V3_CLUB_REWARD_S2C_RES = 707,
    RACE_CLUB3V3_SELF_REWARD_C2S_REQ = 708,
    RACE_CLUB3V3_SELF_REWARD_S2C_RES = 709,
    RACE_CLUB3V3_REBATTLE_C2S_REQ = 710,
    RACE_CLUB3V3_REBATTLE_S2C_RES = 711,
    --}}}


    --{{{ 月签到
    MONTH_SIGN_C2S_REQ = 273, --请求月签到列表
    MONTH_SIGN_S2C_RET = 274,
    RETROACTIVE_MONTH_SIGN_C2S_REQ = 275, --请求月签到P2=日期 P3=0正常1补签
    RETROACTIVE_MONTH_SIGN_S2C_RET = 276,
    --}}}

    --{{{ 体力
    GET_POWER_C2S_REQ = 279, --免费体力
    GET_POWER_S2C_RET = 280,
    --}}}

    --{{{观影幸运转盘
    REQ_VIDEO_LUCK = 500, --请求观影幸运转盘
    RET_VIDEO_LUCK = 501, --返回观影幸运转盘
    REQ_PLAY_VIDEO_LUCK = 502, --请求观影幸运转盘播放开始 P2=影片id P3=播放时间 P4=md5(playtime=xxxrid=xxx+movieId=xxx+tokenstr)
    RET_PLAY_VIDEO_LUCK = 503, --返回观影幸运转盘播放开始
    REQ_FIN_VIDEO_LUCK = 504, --请求观影幸运转盘播放结束发货 P2=影片id P3=播放时间
    RET_FIN_VIDEO_LUCK = 505, --返回观影幸运转盘播放结束发货
    REQ_VIDEO_LUCKY_TABLE = 506, --请求观影幸运转盘 P2=次数
    RET_VIDEO_LUCKY_TABLE = 507, --返回观影幸运转盘
    --}}}

    --{{{观影每日礼赠
    REQ_DAY_VIDEO = 508, --请求每日观影
    RET_DAY_VIDEO = 509, --返回每日观影
    REQ_DAY_VIDEO_PLAY = 510, --开始每日观影 P2=影片id P3=播放时间 P4=序号 P5=md5(playtime=xxxrid=xxx+movieId=xxx+seq=xx+tokenstr)
    RET_DAY_VIDEO_PLAY = 511, --返回每日观影播放开始
    REQ_SUCC_DAY_VIDEO = 512, --请求每日观影结束 P2=影片id P3=播放时间 P4=序号
    RET_SUCC_DAY_VIDEO = 513, --返回每日观影播放结束
    REQ_DAY_VIDEO_GIFT = 514, --请求每日观影奖励 P2=序号
    RET_DAY_VIDEO_GIFT = 515, --返回每日观影奖励

    REQ_SAVE_ORDERING_C2S_REQ = 663, --请求保存方案
    RET_SAVE_ORDERING_S2C_RET = 664, --返回方案
    --}}}

    --{{{宝箱
    REQ_BOX_QUEUE_C2S_REQ = 516, --请求进入宝箱队列
    RET_BOX_QUEUE_S2C_RET = 517, --宝箱队列
    REQ_OPEN_BOX_C2S_REQ = 518, --请求打开宝箱P2=位置P3=宝箱id
    RET_OPEN_BOX_S2C_RET = 519, --宝箱
    REQ_CANCEL_BOX_C2S_REQ = 520, --请求取消宝箱P2=位置
    RET_CANCEL_BOX_S2C_RET = 521, --宝箱
    REQ_BOX_GIFT_C2S_REQ = 522, --领取宝箱P2=位置P3=1立即开
    RET_BOX_GIFT_S2C_RET = 523, --宝箱掉落
    REQ_UNLOCK_BOX_C2S_REQ = 524, --解锁宝箱位置P2=位置
    RET_UNLOCK_BOX_S2C_RET = 525, --宝箱队列

    --}}}

    --{{{车神传说
    REQ_GOD_INFO_C2S_REQ = 780, --请求车神传说
    RET_GOD_INFO_S2C_RES = 781, --返回车神传说
    REQ_ONE_GOD_INFO_C2S_REQ = 782, --请求某个车神传说
    RET_ONE_GOD_INFO_S2C_RES = 783, --返回某个车神传说
    REQ_GOD_START_C2S_REQ = 784, --请求车神比赛开始
    RET_GOD_START_S2C_RES = 785, --返回车神比赛开始
    REQ_GOD_FINISH_C2S_REQ = 786, --请求车神比赛结束
    RET_GOD_FINISH_S2C_RES = 787, --返回车神比赛结束
    --}}}

    --{{{ 巅峰赛
    RACE_TOP_INFO_C2S_REQ = 720, --请求巅峰赛信息
    RACE_TOP_INFO_S2C_RET = 721, --
    RACE_TOP_AUDITION_BEGIN_BATTLE_C2S_REQ = 722,
    RACE_TOP_AUDITION_BEGIN_BATTLE_S2C_RES = 723,
    RACE_TOP_AUDITION_FINISH_BATTLE_C2S_REQ = 724,
    RACE_TOP_AUDITION_FINISH_BATTLE_S2C_RES = 725,
    RACE_TOP_TOP_BEGIN_BATTLE_C2S_REQ = 726,
    RACE_TOP_TOP_BEGIN_BATTLE_S2C_RES = 727,
    RACE_TOP_TOP_FINISH_BATTLE_C2S_REQ = 728,
    RACE_TOP_TOP_FINISH_BATTLE_S2C_RES = 729,
    RACE_TOP_B_BEGIN_BATTLE_C2S_REQ = 730,
    RACE_TOP_B_BEGIN_BATTLE_S2C_RES = 731,
    RACE_TOP_B_FINISH_BATTLE_C2S_REQ = 732,
    RACE_TOP_B_FINISH_BATTLE_S2C_RES = 733,
    RACE_TOP_AUDITION_RANK_LIST_C2S_REQ = 734,
    RACE_TOP_AUDITION_RANK_LIST_S2C_RES = 735,
    RACE_TOP_B_RANK_LIST_C2S_REQ = 736,
    RACE_TOP_B_RANK_LIST_S2C_RES = 737,
    RACE_TOP_TOP_RANK_LIST_C2S_REQ = 738,
    RACE_TOP_TOP_RANK_LIST_S2C_RES = 739,
    RACE_TOP_RECORD_C2S_REQ = 740,
    RACE_TOP_RECORD_S2C_RES = 741,
    RACE_TOP_RE_FIGHT_C2S_REQ = 742,
    RACE_TOP_RE_FIGHT_S2C_RES = 743,
    RACE_TOP_GOOD_C2S_REQ = 744,
    RACE_TOP_GOOD_S2C_RES = 745,
    --}}}

    --{{{ 巅峰赛跨服
    RACE_TOP2_INFO_C2S_REQ = 950, --请求巅峰赛信息
    RACE_TOP2_INFO_S2C_RET = 951, --
    RACE_TOP2_AUDITION_BEGIN_BATTLE_C2S_REQ = 952,
    RACE_TOP2_AUDITION_BEGIN_BATTLE_S2C_RES = 953,
    RACE_TOP2_AUDITION_FINISH_BATTLE_C2S_REQ = 954,
    RACE_TOP2_AUDITION_FINISH_BATTLE_S2C_RES = 955,
    RACE_TOP2_TOP_BEGIN_BATTLE_C2S_REQ = 956,
    RACE_TOP2_TOP_BEGIN_BATTLE_S2C_RES = 957,
    RACE_TOP2_TOP_FINISH_BATTLE_C2S_REQ = 958,
    RACE_TOP2_TOP_FINISH_BATTLE_S2C_RES = 959,
    RACE_TOP2_B_BEGIN_BATTLE_C2S_REQ = 960,
    RACE_TOP2_B_BEGIN_BATTLE_S2C_RES = 961,
    RACE_TOP2_B_FINISH_BATTLE_C2S_REQ = 962,
    RACE_TOP2_B_FINISH_BATTLE_S2C_RES = 963,
    RACE_TOP2_AUDITION_RANK_LIST_C2S_REQ = 964,
    RACE_TOP2_AUDITION_RANK_LIST_S2C_RES = 965,
    RACE_TOP2_B_RANK_LIST_C2S_REQ = 966,
    RACE_TOP2_B_RANK_LIST_S2C_RES = 967,
    RACE_TOP2_TOP_RANK_LIST_C2S_REQ = 968,
    RACE_TOP2_TOP_RANK_LIST_S2C_RES = 969,
    RACE_TOP2_RECORD_C2S_REQ = 970,
    RACE_TOP2_RECORD_S2C_RES = 971,
    RACE_TOP2_RE_FIGHT_C2S_REQ = 972,
    RACE_TOP2_RE_FIGHT_S2C_RES = 973,
    RACE_TOP2_GOOD_C2S_REQ = 974,
    RACE_TOP2_GOOD_S2C_RES = 975,
    --}}}

    --{{{ 使用喇叭
    SMALL_SPEAK_C2S_REQ = 904,
    SMALL_SPEAK_S2C_RET = 905,
    --}}}


    --{{{实验室进阶
    PART_AGE_UP_C2S_REQ = 585, --请求配件进化P2=配件索引P3=消耗配件索引串
    PART_AGE_UP_S2C_RET = 586, --返回配件进化
    --}}}

    --{{{配件还原
    PART_RETURN_C2S_REQ = 587,
    PART_RETURN_S2C_RET = 588,
    --}}}

    --{{{ GVG
    RACE_GVG_JOIN_C2S_REQ = 747,
    RACE_GVG_JOIN_S2C_RET = 748,
    RACE_GVG_INFO_C2S_REQ = 749,
    RACE_GVG_INFO_S2C_RET = 750,
    RACE_GVG_BEGIN_BATTLE_C2S_REQ = 751,
    RACE_GVG_BEGIN_BATTLE_S2C_RET = 752,
    RACE_GVG_FINISH_BATTLE_C2S_REQ = 753,
    RACE_GVG_FINISH_BATTLE_S2C_RET = 754,
    RACE_GVG_RANK_LIST_C2S_REQ = 755,
    RACE_GVG_RANK_LIST_S2C_RET = 756,
    RACE_GVG_RE_BATTLE_C2S_REQ = 757,
    RACE_GVG_RE_BATTLE_S2C_RET = 758,
    RACE_GVG_BATTLE_INFO_C2S_REQ = 759,
    RACE_GVG_BATTLE_INFO_S2C_RET = 760,
    RACE_GVG_RANK_LIST_ALL_C2S_REQ = 777,
    RACE_GVG_RANK_LIST_ALL_S2C_RET = 778,
    --}}}

    --{{{限时活动通行证
    ACT_TIME_TOKEN_C2S_REQ = 166,
    ACT_TIME_TOKEN_S2C_RET = 167,
    ACT_GIFT_TIME_TOKEN_C2S_REQ = 168,
    ACT_GIFT_TIME_TOKEN_S2C_RET = 169,
    ACT_UP_TIME_TOKEN_LEV_C2S_REQ = 175,
    ACT_UP_TIME_TOKEN_LEV_S2C_RET = 176,
    --}}}
    ---{{{高级训练
    GET_ALL_SENIOR_TRAIN_C2S_REQ = 761, --请求所有章节信息
    GET_ALL_SENIOR_TRAIN_S2C_RES = 762,
    GET_SENIOR_TRAIN_INFO_C2S_REQ = 763, --请求章节具体信息
    GET_SENIOR_TRAIN_INFO_S2C_RES = 764,
    GET_SENIOR_TRAIN_LEVEL_INFO_C2S_REQ = 765, --请求关卡具体信息
    GET_SENIOR_TRAIN_LEVEL_INFO_S2C_RES = 766,
    GET_SENIOR_TRAIN_REWARD_C2S_REQ = 767, --请求章节奖励
    GET_SENIOR_TRAIN_REWARD_S2C_RES = 768,
    SENIOR_TRAIN_BATTLE_BEGIN_C2S_REQ = 769, --开始战斗
    SENIOR_TRAIN_BATTLE_BEGIN_S2C_RES = 770,
    SENIOR_TRAIN_BATTLE_FINISH_C2S_REQ = 771, --战斗结算
    SENIOR_TRAIN_BATTLE_FINISH_S2C_RES = 772,
    GET_SENIOR_TRAIN_ALL_REWARD_C2S_REQ = 773, --战斗结算
    GET_SENIOR_TRAIN_ALL_REWARD_S2C_RES = 774,
    SWAP_SENIOR_TRAIN_C2S_REQ = 775,
    SWAP_SENIOR_TRAIN_S2C_RES = 776,
    --}}}
    ---{{{大乱斗
    GET_SUPER_BATTLE_INFO_C2S_REQ = 790, --请求大乱斗信息
    GET_SUPER_BATTLE_INFO_S2C_RES = 791,
    SUPER_BATTLE_JOIN_C2S_REQ = 792, --请求大乱斗排名
    SUPER_BATTLE_JOIN_S2C_RES = 793,
    SUPER_BATTLE_SELECT_CAR_C2S_REQ = 794, --请求选车
    SUPER_BATTLE_SELECT_CAR_S2C_RES = 795,
    SUPER_BATTLE_CONFIRM_CAR_C2S_REQ = 796, --请求确认选车
    SUPER_BATTLE_CONFIRM_CAR_S2C_RES = 797,
    SUPER_BATTLE_RANK_LIST_C2S_REQ = 798, --排行榜
    SUPER_BATTLE_RANK_LIST_S2C_RES = 799,
    SUPER_BATTLE_PLAYER_OFF_RANK_LIST_C2S_REQ = 804, --排行榜
    SUPER_BATTLE_PLAYER_OFF_RANK_LIST_S2C_RES = 805,
    SUPER_BATTLE_64_RANK_LIST_C2S_REQ = 806, --排行榜
    SUPER_BATTLE_64_RANK_LIST_S2C_RES = 807,
    SUPER_BATTLE_GUESS_C2S_REQ = 800, --竞猜
    SUPER_BATTLE_GUESS_S2C_RES = 801,
    SUPER_BATTLE_BAN_TRACK_C2S_REQ = 802, --禁图
    SUPER_BATTLE_BAN_TRACK_S2C_RES = 803,
    SUPER_BATTLE_RACE_RESULT_C2S_REQ = 808, --比赛结果
    SUPER_BATTLE_RACE_RESULT_S2C_RES = 809,
    SUPER_BATTLE_RACE_RECORD_C2S_REQ = 810, --比赛回放
    SUPER_BATTLE_RACE_RECORD_S2C_RES = 811,
    SUPER_BATTLE_AWARD_C2S_REQ = 812, --比赛回放
    SUPER_BATTLE_AWARD_S2C_RES = 813,
    --}}}

    ---{{{累计充值
    SUM_CHARGE_C2S_REQ = 589,
    SUM_CHARGE_S2C_RES = 590,
    SUM_CHARGE_GIFT_C2S_REQ = 591,
    SUM_CHARGE_GIFT_S2C_REQ = 592,
    ---}}}

    ACT_GIFT_PACKAGE_C2S_REQ = 623, --請求限时活动礼包 P2=actid
    ACT_GIFT_PACKAGE_S2C_RES = 624, --返回限时活动礼包

    ---{{{自选宝箱
    OPTIONAL_BOX_C2S_REQ = 562,
    OPTIONAL_BOX_S2C_RES = 563,
    ---}}}

    ---{{{测试充值
    TEST_GIFT_C2S_REQ = 611, --请求测试充值返利
    TEST_GIFT_S2C_RES = 612, --返回测试充值返利
    ---}}}
    ---{{{请求举报
    RUN_FALSE_C2S_REQ = 906, --请求测试充值返利
    RUN_FALSE_S2C_RES = 907, --返回测试充值返利
    ---}}}

    ---{{{小游戏消息
    MINI_GAME_C2S_REQ=814,
    MINI_GAME_S2C_RES=815,
    MINI_GAME_AWARD_C2S_REQ=816,
    MINI_GAME_AWARD_S2C_RES=817,
    ---}}}
    ---

    ---{{{
    COLLECT_LIST_C2S_REQ=597,
    COLLECT_LIST_S2C_RET=598,
    COLLECT_GIFT_C2S_REQ=599,
    COLLECT_GIFT_S2C_RET=600,
    CUP_COLLECT_C2S_REQ=602,
    CUP_COLLECT_S2C_RET=603,
    CUP_COLLECT_GIFT_C2S_REQ=604,
    CUP_COLLECT_GIFT_S2C_RET=605,

    ---}}}
    ---{{{组装赛组装逻辑
    RACE_ASSEMBLE_INFO_C2S_REQ=187,
    RACE_ASSEMBLE_INFO_S2C_RES=188,
    RACE_ASSEMBLE_REFORM_C2S_REQ=185,
    RACE_ASSEMBLE_REFORM_S2C_RES =186,
    RACE_ASSEMBLE_REFORM_DEL_C2S_REQ=189,
    RACE_ASSEMBLE_REFORM_DEL_S2C_RES=190,
    ---}}}
    ---{{{组装赛比赛
    RACE_ASSEMBLE_BATTLE_BEGIN_C2S_REQ=980,
    RACE_ASSEMBLE_BATTLE_BEGIN_S2C_RES=981,
    RACE_ASSEMBLE_BATTLE_FINISH_C2S_REQ=982,
    RACE_ASSEMBLE_BATTLE_FINISH_S2C_RES=983,
    RACE_ASSEMBLE_RECORD_C2S_REQ=986,
    RACE_ASSEMBLE_RECORD_S2C_RES=987,
    RACE_ASSEMBLE_RANK_LIST_C2S_REQ=988,
    RACE_ASSEMBLE_RANK_LIST_S2C_RES=989,
    RACE_ASSEMBLE_JOIN_C2S_REQ=990,
    RACE_ASSEMBLE_JOIN_S2C_RES=991,
    RACE_ASSEMBLE_FAIR_AGREE_C2S_REQ=992,
    RACE_ASSEMBLE_FAIR_AGREE_S2C_RES=993,
    ---}}}
    ---{{{世界杯竞猜
    RACE_FIFA_INFO_C2S_REQ=1000,
    RACE_FIFA_INFO_S2C_RES=1001,
    RACE_FIFA_SELECT_CHAMPION_C2S_REQ=1002,
    RACE_FIFA_SELECT_CHAMPION_S2C_RES=1003,
    RACE_FIFA_SELECT_WINNER_C2S_REQ=1004,
    RACE_FIFA_SELECT_WINNER_S2C_RES=1005,
    RACE_FIFA_GET_REWARD_C2S_REQ=1006,
    RACE_FIFA_GET_REWARD_S2C_RES=1007,
    ---}}}
    ---{{{
    RACE_ASSEMBLE_ADD_INFO_C2S_REQ=1008,
    RACE_ASSEMBLE_ADD_INFO_S2C_RES=1009,
    ---}}}
     ---{{{
    CAPY_ACTIVE_C2S_REQ =1100, --请求卡皮活动
    CAPY_ACTIVE_S2C_RES =1101, --返回卡皮活动
    CAPY_ACTIVE_AWARD_C2S_REQ =1102, --请求卡皮活动奖励
    CAPY_ACTIVE_AWARD_S2C_RES =1103, --返回卡皮活动奖励
    ---}}}
    ---{{{
    GET_FOUND_INFO_C2S_REQ =1041, --请求新通行证信息
    GET_FOUND_INFO_S2C_RES =1042, --返回卡皮活动
    GET_FOUND_AWARD_C2S_REQ =1043, --请求新通行证
    GET_FOUND_AWARD_S2C_RES =1044, --返回卡皮活动奖励
    ---}}}
    ---{{{
    PART_CUP_C2S_REQ =1104, --请求底盘切割
    PART_CUP_S2C_RES =1105, --返回底盘切割
    PART_PIT_C2S_REQ =1043, --请求配件整备
    PART_PIT_S2C_RES =1044, --返回配件整备
    ---}}}
    ---{{{
    GET_RACE_XCP_INFO_C2S_REQ =1121, --請求XCUP赛季信息
    GET_RACE_XCP_INFO_S2C_RES =1122, --返回XCUP赛季信息
    RACE_XCP_JOIN_C2S_REQ =1123, --請求XCUP报名
    RACE_XCP_JOIN_S2C_RES =1124, --返回XCUP报名
    RACE_XCP_BATTLE_START_C2S_REQ =1125, --请求加入XCUP战斗
    RACE_XCP_BATTLE_START_S2C_RES =1126, --返回XCUP开始战斗
    RACE_XCP_BATTLE_FINISH_C2S_REQ =1127, --请求加入XCUP战斗
    RACE_XCP_BATTLE_FINISH_S2C_RES =1128, --返回XCUP开始战斗
    RACE_XCP_BATTLE_TEST_FINISH_C2S_REQ =1129, --请求加入XCUP战斗
    RACE_XCP_BATTLE_TEST_FINISH_S2C_RES =1130, --返回XCUP开始战斗
    RACE_XCP_RECORD_C2S_REQ =1131, --请求加入XCUP战斗
    RACE_XCP_RECORD_S2C_RES =1132, --返回XCUP开始战斗
    RACE_XCP_REFIGHT_C2S_REQ =1133, --返回XCUP开始战斗
    ---}}}
    ---{{{
    GET_AD_REWARD_LIST_C2S_REQ =1141,
    GET_AD_REWARD_LIST_S2C_RES =1142,
    START_AD_REWARD_C2S_REQ =1143,
    START_AD_REWARD_S2C_RES =1144,
    END_AD_REWARD_C2S_REQ =1145,
    END_AD_REWARD_S2C_RES =1146,
    ---}}}
}
NoMsgIdxMsgID={
    { ReqId = MsgID.GET_ALL_CHAPTER_C2S_REQ,showMask=true},
    { ReqId = MsgID.GET_CHAPTER_INFO_C2S_REQ,showMask=true},
    { ReqId = MsgID.UPDATE_GUIDE_STEP_C2G_REQ,showMask=false},
    { ReqId = MsgID.GET_DAY_FRESH_C2S_REQ,showMask=false},
    { ReqId = MsgID.ENTER_SERVER_GET_PART_C2S_REQ, showMask=false},
    { ReqId = MsgID.ENTER_SERVER_C2S_REQ, showMask=false},
}

--- ReqId = MsgID.GET_SHOP_GOODS_C2S_REQ, ResId = MsgID.GET_SHOP_GOODS_S2C_RES 正常
--- ReqId = MsgID.GET_SHOP_GOODS_C2S_REQ, ResId = MsgID.GET_SHOP_GOODS_S2C_RES,isShowMask=false,AutoCloseTime=10不开启遮罩,AutoCloseFunc 自动关闭的回调
-- 不需要自动重发的消息
DelayMsgID = {

}

