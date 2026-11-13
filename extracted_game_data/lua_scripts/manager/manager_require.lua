--data_manager
require("manager/data_manager/playerdata_manager")
require("manager/data_manager/emaildata_manager")
require("manager/data_manager/taskdata_manager")
require("manager/data_manager/timer_manager")
require("manager/data_manager/luabutton_manager")
require("manager/data_manager/cardata_manager")
require("manager/data_manager/team_manager")
require("manager/data_manager/lightgroup_manager")
require("manager/data_manager/shopdata_manager")
require("manager/data_manager/shoppingcardata_manager")
require("manager/data_manager/chapterdata_manager")
require("manager/data_manager/pvechapterdata_manager")
require("manager/data_manager/newbiechapterdata_manager")
require("manager/data_manager/newplayercardata_manager")
require("manager/data_manager/raceseniortrain_manager")
require("manager/data_manager/announcementdata_manager")
require("manager/data_manager/staminadata_manager")
require("manager/data_manager/newbieguidedata_manager")
require("manager/data_manager/raceroom_manager")
require("manager/data_manager/invitedata_manager")
require("manager/data_manager/pvpchatdata_manager")
require("manager/data_manager/specialtrainingdata_manager")
require("manager/data_manager/selfchallengedata_manager")
require("manager/data_manager/suitdata_manager")
require("manager/data_manager/raceweek_manager")
require("manager/data_manager/neteasedata_manager")
require("manager/data_manager/seasonorderdata_manager")
require("manager/data_manager/racerank_manager")
require("manager/data_manager/matchmanager")
require("manager/data_manager/carcache_manager")
require("manager/data_manager/teamcache_manager")
require("manager/data_manager/raceselfchapterdata_manager")
require("manager/data_manager/raceselfleveldata_manager")
require("manager/data_manager/clubraceselfchapterdata_manager")
require("manager/data_manager/clubraceselfleveldata_manager")
require("manager/data_manager/logintaskdata_manager")
require("manager/data_manager/activitydata_manager")
require("manager/data_manager/rankinglistdata_manager")
require("manager/data_manager/noticedata_manager")
require("manager/data_manager/limitchapter_manager")
require("manager/data_manager/userdirect_manager")
require("manager/data_manager/userfirstgift_manager")
require("manager/data_manager/personalhome_manager")
require("manager/data_manager/racejcp_manager")
require("manager/data_manager/racexcup_manager")
require("manager/data_manager/racetop_manager")
require("manager/data_manager/racetopsuper_manager")
require("manager/data_manager/racesuperbattle_manager")
require("manager/data_manager/carattrrecommend_manager")
require("manager/data_manager/ranklisttestverify_manager")
require("manager/data_manager/raceassembleadddata_manager")
require("manager/data_manager/historydata_manager")
require("manager/data_manager/strengthactivity_manager")
require("manager/data_manager/adshop_manager")

--其他manager
require("manager/batchload_manager")

--sdk
require("manager/sdk/globalsdkdata_manager")
require("manager/sdk/quicksdkdata_manager")

require("manager/cachecleartrigger")
require("manager/crossdaytrigger")
require("manager/logoutclear_manager")

--背包
require("manager/knapsack/knapsack")
require("manager/knapsack/articlecell")
require("manager/knapsack/knapsack_manager")

--排行榜
require("manager/ranklist/rankinglist_data")

--剧情
require("manager/story/story_manager")
require("manager/story/story_data")
require("manager/story/storystep_base")
require("manager/story/storystep_click")
require("manager/story/storystep_timer")
require("manager/story/storystep_timerclick")
require("manager/story/storyaction_base")
require("manager/story/storyaction_role")
require("manager/story/storyaction_dialog")
require("manager/story/storyaction_bg")
require("manager/story/storyaction_rolestate")
require("manager/story/story_helper")


--剧情
require("manager/plot/plotmanager")
require("manager/plot/plothelper")
require("manager/plot/plotdata")
require("manager/plot/plotdatastep")
require("manager/plot/plotdataaction")
require("manager/plot/plotdataplayer")


--新手引导
require("manager/newbieguide/guide_base")
require("manager/newbieguide/guide_data")
require("manager/newbieguide/click_guide")
require("manager/newbieguide/dialog_guide")
require("manager/newbieguide/key_guide")
require("manager/newbieguide/break_guide")
require("manager/newbieguide/guide_manager")



--组装
require("manager/assemble/assemble_helper")
require("manager/assemble/assemble_equipmentdata")
require("manager/assemble/assemble_groovedata")
require("manager/assemble/assemble_clientdata")
require("manager/assemble/cardetail_data")
require("manager/assemble/assemblemanager")
require("manager/assemble/assemblenode")
require("manager/assemble/assemblesiftdata")

--模型装配
require("manager/meshbuilder/carbuilder")
require("manager/meshbuilder/carbuilder_datastruct")
require("manager/meshbuilder/carbuilder_analysedata")
require("manager/meshbuilder/carbuilder_appearance")
require("manager/meshbuilder/carbuilder_function")
require("manager/meshbuilder/carbuilder_combine")
require("manager/meshbuilder/carbuilder_cscardataresource")
require("manager/meshbuilder/carbuilder_ruleexpand")
require("manager/meshbuilder/carbuilder_recycle")
require("manager/meshbuilder/carbuilder_meshdict")
require("manager/meshbuilder/carbuilder_shader")
require("manager/meshbuilder/carbuildermanager")
require("manager/meshbuilder/carbuildertexture_manager")
require("manager/meshbuilder/carbuilder_texture")
require("manager/meshbuilder/cupbuilder_texture")
require("manager/meshbuilder/cupanim_helper")
require("manager/meshbuilder/carassemblerule")
require("manager/meshbuilder/part_builder")
require("manager/meshbuilder/meshcachedata")
require("manager/meshbuilder/meshcachemgr")
require("manager/meshbuilder/carbuilderhelper")
require("manager/meshbuilder/meshcamera_helper")



--战斗数据
require("manager/battle/battle_resultdata")
require("manager/battle/battledata")
require("manager/battle/battledata_manager")
require("manager/battle/battledata_helper")
require("manager/battle/battlehelper")
require("manager/battle/battlehelper2_0")
require("manager/battle/battlereplay_helper")
require("manager/battle/lua_roominitdata")
require("manager/battle/csharp_roominitdata")
require("manager/battle/roominitdata_helper")
require("manager/battle/battledydata_manager")
require("manager/battle/battlestatebase")
require("manager/battle/battlestatechallenge")
require("manager/battle/battlestatelocal")
require("manager/battle/battlestatepve")
require("manager/battle/battlestaterank")
require("manager/battle/battlestateroom")
require("manager/battle/battlestateselfchallenge")
require("manager/battle/battlestateself")
require("manager/battle/battledatachallenge")
require("manager/battle/battledatalocal")
require("manager/battle/battledatapve")
require("manager/battle/battledatarank")
require("manager/battle/battledataroom")
require("manager/battle/battledataself")
require("manager/battle/battledataclubtrain")
require("manager/battle/battlestateclubtrain")
require("manager/battle/battledataselfchallenge")
require("manager/battle/battledataraceselfchapter")
require("manager/battle/battlestateraceselfchapter")
require("manager/battle/battledataraceselflevel")
require("manager/battle/battlestateraceselflevel")
require("manager/battle/battledataclubraceselfchapter")
require("manager/battle/battlestateclubraceselfchapter")
require("manager/battle/battledataclubraceselflevel")
require("manager/battle/battlestateclubraceselflevel")
require("manager/battle/battledataracereplay")
require("manager/battle/battlestateracereplay")
require("manager/battle/battledataguidebattle")
require("manager/battle/battlestateguidebattle")
require("manager/battle/battledatatestrun")
require("manager/battle/battlestatetestrun")
require("manager/battle/battledataracetrot")
require("manager/battle/battlestateracetrot")
require("manager/battle/battledataracejcp")
require("manager/battle/battlestateracejcp")
require("manager/battle/battledataracexcp")
require("manager/battle/battlestateracexcp")
require("manager/battle/battledataracetop")
require("manager/battle/battlestateracetop")
require("manager/battle/battledataracetopsuper")
require("manager/battle/battlestateracetopsuper")
require("manager/battle/battledataraceclub3v3")
require("manager/battle/battlestateraceclub3v3")
require("manager/battle/battledataracegvg")
require("manager/battle/battlestateracegvg")
require("manager/battle/battledataraceseniortrain")
require("manager/battle/battlestateraceseniortrain")
require("manager/battle/battledataracecargod")
require("manager/battle/battlestateracecargod")
require("manager/battle/battledataracesuperbattle")
require("manager/battle/battlestateracesuperbattle")
require("manager/battle/battledataraceassemble")
require("manager/battle/battlestateraceassemble")
require("manager/battle/battledataracenewbie")
require("manager/battle/battlestateracenewbie")
require("manager/battle/battledataraceassembletest")
require("manager/battle/battlestateraceassembletest")

--外观系统


--AR系统
require("manager/ar/arhelper")
require("manager/ar/armanager")
require("manager/ar/arstate_control")

--prefabcache
require("manager/prefabcache/prefabcache_data")
require("manager/prefabcache/prefabcache_manager")

--matcache
require("manager/matcache/matcache_data")
require("manager/matcache/matcache_manager")

--好友
require("manager/data_manager/frienddata_manager")
require("manager/data_manager/rentandlenddata_manager")

--解锁
require("manager/unlock/unlock_manager")
require("manager/unlock/menulist_manager")
require("manager/unlock/functionskipmanager")
require("manager/unlock/raceact_manager")
require("manager/unlock/unlock_helper")

--问卷
require("manager/data_manager/survey_manager")

--聊天
require("manager/chat/chatdata_manager")
require("manager/chat/chatdata_private")
require("manager/chat/chatdata_explain")
require("manager/chat/chatdata_file")
require("manager/chat/chatdata_time")
require("manager/chat/chatdata_red")

--俱乐部
require("manager/club/clubdata_manager")
require("manager/club/clubchatdata_manager")
require("manager/club/clubtraindata_manager")
--分享
require("manager/share/sharedata_manager")

--研究所（科技）
require("manager/data_manager/labdata_manager")

require("manager/data_manager/trackdata_manager")
require("manager/data_manager/trackdata_time_manager")

require("manager/data_manager/recruitdata_manager")

--挑战赛
require("manager/data_manager/challengematch_manager")

--通用活动
require("manager/data_manager/commonfestivaldata_manager")
require("manager/data_manager/luckrotarytabledata_manager")
require("manager/data_manager/actsignindata_manager")
require("manager/data_manager/collectdata_manager")
require("manager/data_manager/timetoken_manager")
require("manager/data_manager/rechargereward_manager")
require("manager/data_manager/giftpackagedata_manager")


--老玩家回归
require("manager/data_manager/returnoldplayerdata_manager")

--customtracksegment
require("manager/data_manager/tracksegmentdata_manager")
require("manager/data_manager/racetrackdata_manager")
require("manager/data_manager/segmentdata_manager")

require("manager/data_manager/msgerror_manager")

require("manager/data_manager/raceself_manager")
require("manager/data_manager/raceselfcache_manager")

--AccessoryWarehouse
require("manager/data_manager/warehousedata_manager")

--racetrot
require("manager/data_manager/racetrot_manager")

--racetrot
require("manager/data_manager/raceclub3v3_manager")

--红点
require("manager/redpoint/redpointhelper")
require("manager/redpoint/repointfunction")
require("manager/redpoint/redpoint_manager")
require("manager/redpoint/redpoint_database")
require("manager/redpoint/redpoint_datamsg")
require("manager/redpoint/redpoint_dataask")
require("manager/redpoint/redpoint_databag")
require("manager/redpoint/redpoint_datachat")
require("manager/redpoint/redpoint_datarecruit")
require("manager/redpoint/redpoint_datatask")
require("manager/redpoint/redpoint_friend")
require("manager/redpoint/redpoint_datagarage")
require("manager/redpoint/redpoint_loginactivity")
require("manager/redpoint/redpoint_activity")
require("manager/redpoint/redpoint_activitypay")
require("manager/redpoint/redpoint_email")

--debug
require("manager/data_manager/debuglogdata_manager")
require("manager/data_manager/playerlevelupdata_manager")

--展示品
require("manager/exhibitbuilder/exhibitbuilder")
require("manager/exhibitbuilder/exhibitbuildermanager")
require("manager/exhibitbuilder/exhibitcachedata")
require("manager/exhibitbuilder/exhibitcachemgr")
require("manager/exhibitbuilder/exhibitboxmgr")

require("manager/data_manager/monthsign_manager")
require("manager/data_manager/welfarevideodata_manager")
require("manager/data_manager/welfareboxdata_manager")

--钻石换金币
require("manager/data_manager/buygolddata_manager")

require("manager/data_manager/racegvg_manager")
require("manager/data_manager/racecargoddata_manager")

--主场景交互
require("manager/mainscene/mainscene_help")
require("manager/mainscene/mainscene_manager")
require("manager/mainscene/mainscenebox_factory")
require("manager/mainscene/mainsceneboxinfo")

--小游戏
require("manager/data_manager/minigamedata_manager")

--快捷充值
require("manager/data_manager/chargetipsdata_manager")

require("manager/data_manager/actadvancenoticedata_manager")


require("manager/comic/comicmanager")
require("manager/comic/comicaction")
require("manager/comic/comicdata")
require("manager/comic/comicstep")
require("manager/comic/comichelper")

require("manager/data_manager/popupgiftdata_manager")
require("manager/data_manager/illustratedhandbookdata_manager")

require("manager/data_manager/forbiddendata_manager")
require("manager/data_manager/playersampleinfodata_manager")

require("manager/data_manager/raceassembledata_manager")
require("manager/data_manager/racefifadata_manager")
require("manager/data_manager/foundlist_manager")
