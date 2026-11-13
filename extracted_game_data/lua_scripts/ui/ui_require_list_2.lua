require("ui/view/gamestart/serverinfoview")
require("ui/view/gamestart/serverinfoview_action")
require("ui/view/gamestart/selectserverview")
require("ui/view/gamestart/selectserverview_action")


-------------------------------------------------------uicommon
require("ui/uicommon/common_helper_setcolor")
require("ui/uicommon/common_helper_scrollview")
require("ui/uicommon/common_helper_minimap")
require("ui/uicommon/common_helper_uieffect")
require("ui/uicommon/common_helper_partgroup")
require("ui/uicommon/common_helper_partcfg")
require("ui/uicommon/common_helper_spritecfg")
require("ui/uicommon/common_helper_articlegroup")
require("ui/uicommon/common_helper_mathbitutil")
require("ui/uicommon/common_helper_shopgoodsgroup")
require("ui/uicommon/common_helper_skillgroup")
require("ui/uicommon/common_helper_audio")
require("ui/uicommon/common_helper_partorarticle")
require("ui/uicommon/common_helper_date")
require("ui/uicommon/common_helper_racemap")
require("ui/uicommon/common_helper_racetrack")
require("ui/uicommon/common_helper_nhpsdk")
require("ui/uicommon/common_helper_articlesort")
require("ui/uicommon/common_helper_attrcompare")
require("ui/uicommon/common_helper_chart")
require("ui/uicommon/common_helper_radarvalue")
require("ui/uicommon/common_helper_attrformula")
require("ui/uicommon/common_helper_verifycar")
require("ui/uicommon/common_helper_rankicon")
require("ui/uicommon/common_helper_item")
require("ui/uicommon/messagebox_helper")
require("ui/uicommon/articlemessagebox_helper")
require("ui/uicommon/commontips_helper")
require("ui/uicommon/skipmodule_helper")
require("ui/uicommon/homescene_helper")
require("ui/uicommon/homescene_carmesh_helper")
require("ui/uicommon/homescene_showcar_room")
require("ui/uicommon/common_helper_battle")
require("ui/uicommon/common_helper_superscrollview")
require("ui/uicommon/common_helper_club")
require("ui/uicommon/common_helper_countryInfo")
require("ui/uicommon/common_helper_systemsetting")
require("ui/uicommon/common_helper_tracksegmentgroup")
require("ui/uicommon/common_helper_reward")
require("ui/uicommon/common_helper_npcgroup")
require("ui/uicommon/common_helper_prop")
require("ui/uicommon/common_helper_net")
require("ui/uicommon/camerastack_helper")
require("ui/uicommon/cinemachinecamera_helper")
require("ui/uicommon/playerprefshelper")
require("ui/uicommon/common_helper_personalhome")
require("ui/uicommon/common_helper_car")
require("ui/uicommon/common_helper_item_old")
require("ui/uicommon/common_helper_audio_garage")
require("ui/uicommon/common_helper_audio_ui")
-------------------------------------------------------

-------------------------------------------------------loading
require("ui/loading/scene_manager")
require("ui/loading/scene/loading_base")
require("ui/loading/scene/maincityloading")
require("ui/loading/scene/pve_loading")
require("ui/loading/scene/testbattle_loading")
require("ui/loading/scene/trackreview_loading")
require("ui/loading/scene/customtrack_loading")
require("ui/loading/scene/battle_loading")
require("ui/loading/scene/realtimepvp_loading")
require("ui/loading/scene/minigame_loading")
-------------------------------------------------------

--messagebox
require("ui/view/messagebox/messageboxview")
require("ui/view/messagebox/messageboxview_action")

-------------------------------------------------------uicore
require("ui/view/pageprefab/page_partattrs")
require("ui/view/pageprefab/page_partbase")
require("ui/view/pageprefab/page_partreform")
require("ui/view/pageprefab/page_parttips")
require("ui/view/pageprefab/page_partinfo4")
require("ui/view/pageprefab/page_partinfo3")

require("ui/view/pageprefab/page_carbase")
require("ui/view/pageprefab/page_carattrs")
require("ui/view/pageprefab/page_carequipment")
require("ui/view/pageprefab/page_carinfo4")
require("ui/view/pageprefab/page_carinfo2")
require("ui/view/pageprefab/page_selectcar")
require("ui/view/pageprefab/page_selectcar_five")
require("ui/view/pageprefab/page_selectcar_five2")
require("ui/view/pageprefab/page_reviewcar")
-------------------------------------------------------
---
---





-------------------------------------------------------view
require("ui/view/helloview")
require("ui/view/helloview_action")

--commonpart
require("ui/view/commonpart/playrollview")
require("ui/view/commonpart/playrollview_action")
require("ui/view/commonpart/topinfoview")
require("ui/view/commonpart/topinfoview_action")
require("ui/view/commonpart/topleftinfoview")
require("ui/view/commonpart/topleftinfoview_action")
require("ui/view/commonpart/topinforecruitview")
require("ui/view/commonpart/topinforecruitview_action")
require("ui/view/commonpart/buttominfoview")
require("ui/view/commonpart/buttominfoview_action")
require("ui/view/commonpart/commonbgblueview")
require("ui/view/commonpart/commonbggreenview")
require("ui/view/commonpart/commonbgorangeview")
require("ui/view/commonpart/commonbgpinkview")
require("ui/view/commonpart/commonbgredview")
require("ui/view/commonpart/commonbgyellowview")
require("ui/view/commonpart/commonbg2view")
require("ui/view/commonpart/commonbgroseredview")
require("ui/view/commonpart/pviewassemblecar")
require("ui/view/commonpart/pviewassemblecar_action")
require("ui/view/commonpart/pviewpartinfo")
require("ui/view/commonpart/pviewpartinfo_action")
require("ui/view/commonpart/pviewpartinforeform")
require("ui/view/commonpart/pviewpartinforeform_action")
require("ui/view/commonpart/pviewcarinfo")
require("ui/view/commonpart/pviewcarinfo_action")
require("ui/view/commonpart/commoninputview")
require("ui/view/commonpart/commoninputview_action")

-- loadView
require("ui/view/loading/loading_view")
require("ui/view/loading/loading_view_action")
require("ui/view/gm/gmview")

--testView
require("ui/view/testview/testview")
require("ui/view/testview/testview_action")

--loginview
require("ui/view/login/loginview")
require("ui/view/login/loginview_action")

--rankingview
require("ui/view/rankinglist/rankinglistview")
require("ui/view/rankinglist/rankinglistview_action")
require("ui/view/rankinglist/mainrankinglistview")
require("ui/view/rankinglist/mainrankinglistview_action")
require("ui/view/rankinglist/rankinglistrewardview")
require("ui/view/rankinglist/rankinglistrewardview_action")
require("ui/view/rankinglist/page_ranklist_scrollview")
require("ui/view/rankinglist/racerankrankinglistrewardview")
require("ui/view/rankinglist/racerankrankinglistrewardview_action")



--mainmenuview
require("ui/view/mainmenu/mainmenuview")
require("ui/view/mainmenu/mainmenuview_action")
require("ui/view/mainmenu/raceview")
require("ui/view/mainmenu/raceview_action")
require("ui/view/mainmenu/interactionmainmenuview")
require("ui/view/mainmenu/interactionmainmenuview_action")

--chapter
require("ui/view/chapter/chapterlistview")
require("ui/view/chapter/chapterlistview_action")
require("ui/view/chapter/chapterview")
require("ui/view/chapter/chapterview_action")
require("ui/view/chapter/selectteamview")
require("ui/view/chapter/selectteamview_action")
require("ui/view/chapter/swapview")
require("ui/view/chapter/swapview_action")


require("ui/view/messagebox/articlemessageboxview")
require("ui/view/messagebox/articlemessageboxview_action")

--tips
require("ui/view/tips/centertipsview")
require("ui/view/tips/centertipsview_action")
require("ui/view/tips/pushview")
require("ui/view/tips/pushview_action")

--lottery
require("ui/view/recruit/recruitview_ani")
require("ui/view/recruit/recruitview_ani1")
require("ui/view/recruit/recruitview_ani2")
require("ui/view/recruit/recruitview_ani3")
require("ui/view/recruit/recruitview")
require("ui/view/recruit/recruitview_action")
require("ui/view/recruit/probabilityview")
require("ui/view/recruit/probabilityview_action")
require("ui/view/recruit/recruitshowview")
require("ui/view/recruit/recruitshowview_action")
require("ui/view/recruit/recruitskipview")
require("ui/view/recruit/recruitskipview_action")
require("ui/view/recruit/recruitminiexchageview")
require("ui/view/recruit/recruitminiexchageview_action")
require("ui/view/recruit/recruitminiexchangeedview")
require("ui/view/recruit/recruitminiexchangeedview_action")
require("ui/view/recruit/recruitminiexchagemoreview")
require("ui/view/recruit/recruitminiexchagemoreview_action")

--getreward
require("ui/view/getreward/getrewardview")
require("ui/view/getreward/getrewardview_action")
require("ui/view/getreward/showrewardview")
require("ui/view/getreward/showrewardview_action")

--team
require("ui/view/team/teamview")
require("ui/view/team/teamview_action")
require("ui/view/team/teameditorview")
require("ui/view/team/teameditorview_action")


--battle
require("ui/view/battle/battleexplainview")
require("ui/view/battle/battleexplainview_action")

require("ui/view/battle/battlepauseview")
require("ui/view/battle/battlepauseview_action")
require("ui/view/battle/battlestartskipview")
require("ui/view/battle/battlestartskipview_action")
require("ui/view/battle/battlestartswitchview")
require("ui/view/battle/battlestartswitchview_action")

require("ui/view/battle/battleraceinfoview")
require("ui/view/battle/battleraceinfoview_action")
require("ui/view/battle/battlestartview")
require("ui/view/battle/battlestartview_action")

require("ui/view/battle/page_battlebase_init")
require("ui/view/battle/page_battlebase_rank")
require("ui/view/battle/page_battlebase_shortchat")

require("ui/view/battle/battlenewoutdoorview")
require("ui/view/battle/battlenewoutdoorview_action")
require("ui/view/battle/battlenewsystemview")
require("ui/view/battle/battlenewsystemview_action")
require("ui/view/battle/fullscreenskillview")

require("ui/view/battle/page_battle_result")
require("ui/view/battle/page_battle_result_reward")
require("ui/view/battle/page_battle_result_rank")
require("ui/view/battle/page_battle_result_race")
require("ui/view/battle/page_battle_result_storyreward")
require("ui/view/battle/page_battle_result_trot")
require("ui/view/battle/page_battle_result_club3v3")
require("ui/view/battle/page_battle_result_racejcp")
require("ui/view/battle/page_battle_result_racexcp")
require("ui/view/battle/page_battle_result_recegvg")
require("ui/view/battle/page_battle_result_cargod")
require("ui/view/battle/page_battle_result_playerrank")

require("ui/view/battle/battleresultview")
require("ui/view/battle/battleresultview_action")

require("ui/view/battle/trackpositionselectview")
require("ui/view/battle/trackpositionselectview_action")
require("ui/view/battle/skilldetailview")
require("ui/view/battle/skilldetailview_action")

--survey
require("ui/view/sdk/surveyview")
require("ui/view/sdk/surveyview_action")


--activity

require("ui/view/activity/page_activitybase")
require("ui/view/activity/page_activitysuperpack")
require("ui/view/activity/page_activityspecialgift")
require("ui/view/activity/page_rechargeview")
require("ui/view/activity/page_rechargediamonview")
require("ui/view/activity/page_preferentialbag")
require("ui/view/activity/page_activityweekcard")
require("ui/view/activity/page_activitynewbiegift")
require("ui/view/activity/page_activitygrowthaward")
require("ui/view/activity/page_growthawardmax")
require("ui/view/activity/page_activityrookiepackage")
require("ui/view/activity/page_activitydecalsbag")

require("ui/view/activity/activityfirstbuyview")
require("ui/view/activity/activityfirstbuyview_action")
require("ui/view/activity/activityview")
require("ui/view/activity/activityview_action")
require("ui/view/found/seasonorderview")
require("ui/view/found/seasonorderview_action")
require("ui/view/found/seasonorderlevelview")
require("ui/view/found/seasonorderlevelview_action")
require("ui/view/found/seasonordertaskview")
require("ui/view/found/seasonordertaskview_action")
require("ui/view/found/foundpasscargodview")
require("ui/view/found/foundpasscargodview_action")
require("ui/view/found/foundpasslevelview")
require("ui/view/found/foundpasslevelview_action")
require("ui/view/found/foundpassstoryview")
require("ui/view/found/foundpassstoryview_action")
require("ui/view/found/foundpasstoggleview")
require("ui/view/found/foundpasstoggleview_action")
require("ui/view/found/foundlistview")
require("ui/view/found/foundlistview_action")

require("ui/view/strengthprintctview/strengthsprintactview")
require("ui/view/strengthprintctview/strengthsprintactview_action")
require("ui/view/strengthprintctview/recruitsprintactview")
require("ui/view/strengthprintctview/recruitsprintactview_action")
require("ui/view/strengthprintctview/page_strengthactivitybaseview")
require("ui/view/strengthprintctview/page_strengthactivityshopview")
require("ui/view/strengthprintctview/page_strengthactivitygiftview")
require("ui/view/activity/page_activitygrowthaward")
require("ui/view/activity/page_actchargeview")


require("ui/view/activity/activitycashregisterview")
require("ui/view/activity/activitycashregisterview_action")
require("ui/view/activity/activitychoosepayview")
require("ui/view/activity/activitychoosepayview_action")




--garage
require("ui/view/garage/garageview")
require("ui/view/garage/garageview_action")
require("ui/view/garage/garagetipsview")
require("ui/view/garage/garagetipsview_action")
require("ui/view/garage/carverifyhistoryview")
require("ui/view/garage/carverifyhistoryview_action")
require("ui/view/garage/inheritfilterview")
require("ui/view/garage/inheritfilterview_action")
require("ui/view/garage/inheritlevelview")
require("ui/view/garage/inheritlevelview_action")
require("ui/view/garage/page_garage_appearance")
require("ui/view/garage/page_garage_awake")
require("ui/view/garage/page_garage_carinfo")
require("ui/view/garage/page_garage_color")
require("ui/view/garage/page_garage_grid")
require("ui/view/garage/page_garage_gridlist")
require("ui/view/garage/page_garage_hole")
require("ui/view/garage/page_garage_partinfo")
require("ui/view/garage/page_garage_partlist")
require("ui/view/garage/page_garage_partmap")
require("ui/view/garage/page_garage_reform")
require("ui/view/garage/page_garage_reformcost")
require("ui/view/garage/page_garage_reformselect")
require("ui/view/garage/page_garage_reformreplace")
require("ui/view/garage/page_garage_star")
require("ui/view/garage/page_garage_sticker")
require("ui/view/garage/page_garage_strong")
require("ui/view/garage/page_garage_levelup")
require("ui/view/garage/page_garage_attrtip")
require("ui/view/garage/page_garage_featuretip")
require("ui/view/garage/pre_garage_caridx")
require("ui/view/garage/page_garage_partcolor")
require("ui/view/garage/page_garage_partcolorcost")
require("ui/view/garage/page_garage_verifycar")
require("ui/view/garage/page_garage_verifycarresult")
require("ui/view/garage/page_garage_inherit")
require("ui/view/garage/page_garage_inheritcost")
require("ui/view/garage/page_garage_inheritlevelup")
require("ui/view/garage/page_garage_inheritrecasting")
require("ui/view/garage/page_garage_inheritselect")
require("ui/view/garage/page_garage_motoradjust")
require("ui/view/garage/page_garage_shellchange")
require("ui/view/garage/page_garage_motoradjustcost")
require("ui/view/garage/page_garage_advanced")
require("ui/view/garage/page_garage_advancedselect")
require("ui/view/garage/page_garage_partsticker")



--require("ui/view/garage/assembleview")
--require("ui/view/garage/assembleview_action")
--require("ui/view/garage/developview")
--require("ui/view/garage/developview_action")
require("ui/view/garage/reformresultview")
require("ui/view/garage/reformresultview_action")
require("ui/view/garage/inheritrecastingresultview")
require("ui/view/garage/inheritrecastingresultview_action")
require("ui/view/garage/developstarresultview")
require("ui/view/garage/developstarresultview_action")
require("ui/view/garage/reformstrongresultview")
require("ui/view/garage/reformstrongresultview_action")
require("ui/view/garage/partlevelupresultview")
require("ui/view/garage/partlevelupresultview_action")
require("ui/view/garage/partyokeview")
require("ui/view/garage/partyokeview_action")
require("ui/view/garage/partawakesuccessview")
require("ui/view/garage/partawakesuccessview_action")
--require("ui/view/garage/page_garagecolor")
--require("ui/view/garage/page_garagesticker")
--require("ui/view/garage/page_garagehole")
--require("ui/view/garage/page_garagegrid")
--require("ui/view/garage/pre_developreform")
--require("ui/view/garage/pre_developstar")
require("ui/view/garage/pre_garage_assemblemap")
require("ui/view/garage/pre_garage_partdetail")
--require("ui/view/garage/pre_garage_partlist")
--require("ui/view/garage/pre_garage_comparepart")

--require("ui/view/garage/transformview")
--require("ui/view/garage/transformview_action")
--require("ui/view/garage/changepartview")
--require("ui/view/garage/changepartview_action")
--require("ui/view/garage/partstarupview")
--require("ui/view/garage/partstarupview_action")
--require("ui/view/garage/reformview")
--require("ui/view/garage/reformview_action")
--require("ui/view/garage/reformstrongview")
--require("ui/view/garage/reformstrongview_action")
--require("ui/view/garage/reformselectview")
--require("ui/view/garage/reformselectview_action")
--require("ui/view/garage/reformcostview")
--require("ui/view/garage/reformcostview_action")
--require("ui/view/garage/partupsucceedview")
--require("ui/view/garage/partupsucceedview_action")
--require("ui/view/garage/reformsucceedview")
--require("ui/view/garage/reformsucceedview_action")
--require("ui/view/garage/reformfailview")
--require("ui/view/garage/reformfailview_action")
--require("ui/view/garage/partstarupsucceedview")
--require("ui/view/garage/partstarupsucceedview_action")
--require("ui/view/garage/radardetailview")
--require("ui/view/garage/radardetailview_action")

--playerdetail

require("ui/view/playerinfo/playerheadiconview")
require("ui/view/playerinfo/playerheadiconview_action")
require("ui/view/playerinfo/playerlevelupview")
require("ui/view/playerinfo/playerlevelupview_action")
require("ui/view/playerinfo/playerlevelrewardview")
require("ui/view/playerinfo/playerlevelrewardview_action")
require("ui/view/playerinfo/playerinfoselectcarview")
require("ui/view/playerinfo/playerinfoselectcarview_action")
require("ui/view/playerinfo/playerselfinfoview")
require("ui/view/playerinfo/playerselfinfoview_action")
require("ui/view/playerinfo/exhibituseview")
require("ui/view/playerinfo/exhibituseview_action")
require("ui/view/playerinfo/personalhomestorageview")
require("ui/view/playerinfo/personalhomestorageview_action")
require("ui/view/playerinfo/personalhomeview")
require("ui/view/playerinfo/personalhomeview_action")
require("ui/view/playerinfo/page_playerinfo_setting")
require("ui/view/playerinfo/page_playerinfo_roleinfo")
require("ui/view/playerinfo/page_otherplayerinfo_roleinfo")
require("ui/view/playerinfo/otherplayerinfoview")
require("ui/view/playerinfo/otherplayerinfoview_action")
require("ui/view/playerinfo/settingview")
require("ui/view/playerinfo/settingview_action")
require("ui/view/playerinfo/playerrenameview")
require("ui/view/playerinfo/playerrenameview_action")
require("ui/view/playerinfo/page_playersampleinfoview")



--knapsack
require("ui/view/knapsack/bagmenuview")
require("ui/view/knapsack/bagmenuview_action")
require("ui/view/knapsack/knapsackview")
require("ui/view/knapsack/knapsackview_action")
require("ui/view/knapsack/equipmentview")
require("ui/view/knapsack/equipmentview_action")
require("ui/view/knapsack/articleinfoview")
require("ui/view/knapsack/articleinfoview_action")
require("ui/view/knapsack/articleinfouseview")
require("ui/view/knapsack/articleinfouseview_action")
require("ui/view/knapsack/articleinfopartview")
require("ui/view/knapsack/articleinfopartview_action")
require("ui/view/knapsack/partinfoview")
require("ui/view/knapsack/partinfoview_action")
require("ui/view/knapsack/quickgetarticleview")
require("ui/view/knapsack/quickgetarticleview_action")
require("ui/view/knapsack/optionalgiftdetailsview")
require("ui/view/knapsack/optionalgiftdetailsview_action")

--bag
require("ui/view/bag/bagview")
require("ui/view/bag/bagview_action")
require("ui/view/bag/bagpartinfoview")
require("ui/view/bag/bagpartinfoview_action")
require("ui/view/bag/costuseinfoview")
require("ui/view/bag/costuseinfoview_action")
require("ui/view/bag/minicarinfoview")
require("ui/view/bag/minicarinfoview_action")
require("ui/view/bag/articlefilterview")
require("ui/view/bag/articlefilterview_action")
require("ui/view/bag/usebroadcastview")
require("ui/view/bag/usebroadcastview_action")
require("ui/view/bag/optionalgiftview")
require("ui/view/bag/optionalgiftview_action")
require("ui/view/bag/articlecountselectview")
require("ui/view/bag/articlecountselectview_action")

--email
require("ui/view/email/emailview")
require("ui/view/email/emailview_action")

--friend
require("ui/view/friend/friendview")
require("ui/view/friend/page_friend_list")
require("ui/view/friend/page_friend_apply")
require("ui/view/friend/page_friend_add")
require("ui/view/friend/page_firend_rentandlend")
require("ui/view/friend/friendview_action")
require("ui/view/friend/friendchoosepropview")
require("ui/view/friend/friendchoosepropview_action")
require("ui/view/friend/friendexchangeview")
require("ui/view/friend/friendexchangeview_action")
require("ui/view/friend/friendrentandlendview")
require("ui/view/friend/friendrentandlendview_action")

require("ui/view/friend/friendblacklistview")
require("ui/view/friend/friendblacklistview_action")

require("ui/view/friend/raceinvitefriendview")
require("ui/view/friend/raceinvitefriendview_action")
require("ui/view/friend/roominvitepopview")
require("ui/view/friend/roominvitepopview_action")



--plot
require("ui/view/plot/plotview")
require("ui/view/plot/plotview_action")
require("ui/view/comic/comicview")
require("ui/view/comic/comicview_action")
--require("ui/view/plot/plotviewbackground")
--require("ui/view/plot/plotviewdialog")
--require("ui/view/plot/plotviewrole")
--require("ui/view/plot/plotviewrolestate")
--require("ui/view/plot/plotviewrendertexturebg")


--screeneffect
require("ui/view/screeneffect/screeneffectview")
require("ui/view/screeneffect/screeneffectview_action")
require("ui/view/screeneffect/guidescreeneffectview")
require("ui/view/screeneffect/guidescreeneffectview_action")
require("ui/view/screeneffect/carbuildmaskview")
require("ui/view/screeneffect/carbuildmaskview_action")



--gainway
require("ui/view/gainway/gainwayview")
require("ui/view/gainway/gainwayview_action")


--appearance
require("ui/view/appearance/appearancemenuview")
require("ui/view/appearance/appearancemenuview_action")
require("ui/view/appearance/shellcolorview")
require("ui/view/appearance/shellcolorview_action")
require("ui/view/appearance/shellstickerview")
require("ui/view/appearance/shellstickerview_action")
require("ui/view/appearance/lightweightview")
require("ui/view/appearance/lightweightview_action")
require("ui/view/appearance/shellgridview")
require("ui/view/appearance/shellgridview_menu")
require("ui/view/appearance/shellgridview_action")
require("ui/view/appearance/shellgridmenuview")
require("ui/view/appearance/shellgridmenuview_action")

--shop
require("ui/view/shop/shopview")
require("ui/view/shop/shopview_action")
require("ui/view/shop/shoppingcarview")
require("ui/view/shop/shoppingcarview_action")
require("ui/view/shop/goodsinfoview")
require("ui/view/shop/goodsinfoview_action")
require("ui/view/shop/shopbuydoneview")
require("ui/view/shop/shopbuydoneview_action")


--club
require("ui/view/club/page_clubcreate")
require("ui/view/club/page_clubmemberinfo")

require("ui/view/club/clubnoview")
require("ui/view/club/clubnoview_list")
require("ui/view/club/clubnoview_create")
require("ui/view/club/clubnoview_action")

require("ui/view/club/clubmainmenuview")
require("ui/view/club/clubmainmenuview_edit")
require("ui/view/club/clubmainmenuview_action")

require("ui/view/club/clubexchangegetreawrdview")
require("ui/view/club/clubexchangegetrewardview_action")

require("ui/view/club/clubexchangeview")
require("ui/view/club/clubexchangeview_action")
require("ui/view/club/clubmainmenuviewdata")
require("ui/view/club/clubrenameview")
require("ui/view/club/clubrenameview_action")

require("ui/view/clubtask/clubtaskview")
require("ui/view/clubtask/clubtaskview_action")

require("ui/view/clubtrain/clubtrainselectcarbaseview")
require("ui/view/clubtrain/clubtrainview")
require("ui/view/clubtrain/clubtrainview_action")
require("ui/view/clubtrain/clubtrainselectcarview")
require("ui/view/clubtrain/clubtrainselectcarview_action")
require("ui/view/clubtrain/clubtrainsettingview")
require("ui/view/clubtrain/clubtrainsettingview_action")

require("ui/view/initial/initialview")
require("ui/view/initial/initialview_action")
require("ui/view/initial/initialplayerview")
require("ui/view/initial/initialplayerview_action")
require("ui/view/initial/newplayerchapterlistview")
require("ui/view/initial/newplayerchapterlistview_action")
require("ui/view/initial/newplayerselectcarview")
require("ui/view/initial/newplayerselectcarview_action")

--setting
require("ui/view/setting/debugview")
require("ui/view/setting/debugview_action")

--chat
require("ui/view/chat/chatviewdata_init")
require("ui/view/chat/chatviewdata_scroll")
require("ui/view/chat/chatviewdata_friend")
require("ui/view/chat/chatviewdata_prefab")
require("ui/view/chat/chatviewdata_playerinfo")
require("ui/view/chat/page_emoji")
require("ui/view/chat/page_chatquick")


require("ui/view/chat/chatshortcutdata")

require("ui/view/chat/chatview")
require("ui/view/chat/chatview_action")

require("ui/view/chat/chatinvitetypeview")
require("ui/view/chat/chatinvitetypeview_action")

require("ui/view/chat/page_chatplayerinfo")
require("ui/view/chat/page_quickchat")
require("ui/view/chat/page_mainchat")
require("ui/view/chat/page_singlechannelchat")
require("ui/view/chat/page_singlechannelchat_playerinfo")
require("ui/view/chat/page_singlechannelchat_2")

--ChallengeMatch
require("ui/view/challengematch/challengematchview")
require("ui/view/challengematch/challengematchview_action")
require("ui/view/challengematch/challengematchcreateview")
require("ui/view/challengematch/challengematchcreateview_action")
require("ui/view/challengematch/challengemathrankinglistrewardview")
require("ui/view/challengematch/challengemathrankinglistrewardview_action")
require("ui/view/challengematch/challengemathrankinglistview")
require("ui/view/challengematch/challengemathrankinglistview_action")
require("ui/view/challengematch/challengematchticketview")

--lab
require("ui/view/lab/labmainview")
require("ui/view/lab/labmainview_action")
require("ui/view/lab/page_labbase")
require("ui/view/lab/page_labcompound")
require("ui/view/lab/page_lablimitcompound")
require("ui/view/lab/page_labresolve")
require("ui/view/lab/page_labrestore")

require("ui/view/lab/labresolvepropview")
require("ui/view/lab/labresolvepropview_action")

require("ui/view/lab/labchoosepropview")
require("ui/view/lab/labchoosepropview_action")


--track
require("ui/view/track/trackmainview")
require("ui/view/track/trackmainview_action")
require("ui/view/track/trackmainview_mould")
require("ui/view/track/trackmainview_manufacture")
require("ui/view/track/trackmainview_timebase")

--commonfestival
require("ui/view/commonfestival/page_commonfestivalsigninview")
require("ui/view/commonfestival/page_commonfestivalexchangeview")
require("ui/view/commonfestival/page_commonfestivalchargeview")
require("ui/view/commonfestival/page_commonfestivallimittaskview")
require("ui/view/commonfestival/commonfestivaltipsview")
require("ui/view/commonfestival/commonfestivaltipsview_action")

require("ui/view/commonfestivaltwo/page_commonfestivalcumulativeview")
require("ui/view/commonfestivaltwo/page_commonfestivalcustomgiftview")
require("ui/view/commonfestivaltwo/page_commonfestivaleverydayview")
require("ui/view/commonfestivaltwo/page_commonfestivalmoremoneyview")

require("ui/view/commonnewact/page_commonactviewbase")
require("ui/view/commonnewact/commonnewactview")
require("ui/view/commonnewact/commonnewactview_action")
require("ui/view/commonnewact/page_commonactluckinfoview")
require("ui/view/commonnewact/page_commonactsigninview")
require("ui/view/commonnewact/page_commonactcollectwordsview")
require("ui/view/commonnewact/page_commonactluckrotarytableview")
require("ui/view/commonnewact/page_commonfestivaldualoutputview")
require("ui/view/commonnewact/page_commonacttimetokenview")
require("ui/view/commonnewact/page_commonactsupportview")
require("ui/view/commonnewact/page_commonactrechargerewardview")
require("ui/view/commonnewact/page_commonactrotarytablebagview")


-------------------------------------------------------
--Task
require("ui/view/task/taskview")
require("ui/view/task/taskview_action")

--help
require("ui/view/help/helpview")
require("ui/view/help/helpview_action")
require("ui/view/help/page_otherstyleview")

--Announcement
require("ui/view/announcement/announcementview")
require("ui/view/announcement/announcementview_action")


--stamina
require("ui/view/mainmenu/staminaview")
require("ui/view/mainmenu/staminaview_action")

require("ui/view/mainmenu/buygoldview")
require("ui/view/mainmenu/buygoldview_action")
require("ui/view/mainmenu/buygoldtipsview")
require("ui/view/mainmenu/buygoldtipsview_action")
require("ui/view/mainmenu/buygoldnotarizeview")
require("ui/view/mainmenu/buygoldnotarizeview_action")


--stamina
require("ui/view/newbieguide/newbieguideview")
require("ui/view/newbieguide/newbieguide_action")
require("ui/view/newbieguide/guideview_action")
require("ui/view/newbieguide/guideview")
require("ui/view/guidegarage/guidegarageview")
require("ui/view/guidegarage/guidegarageview_action")
require("ui/view/guidegarage/page_guidegarage_carinfo")
require("ui/view/guidegarage/page_guidegarage_partinfo")
require("ui/view/guidegarage/page_guidegarage_partlist")
require("ui/view/guidegarage/page_guidegarage_partmap")

--raceroom
require("ui/view/raceroom/carinfoview")
require("ui/view/raceroom/carinfoview_action")
require("ui/view/raceroom/raceoverlookview")
require("ui/view/raceroom/raceoverlookview_action")

require("ui/view/raceroom/raceroomview")
require("ui/view/raceroom/raceroomview_action")
require("ui/view/raceroom/raceroomcreateview")
require("ui/view/raceroom/raceroomcreateview_action")
require("ui/view/raceroom/raceroomdetailview")
require("ui/view/raceroom/raceroomdetailview_action")
require("ui/view/raceroom/raceroomreviseview")
require("ui/view/raceroom/raceroomreviseview_action")
require("ui/view/raceroom/raceroomselectcarview")
require("ui/view/raceroom/raceroomselectcarview_action")
require("ui/view/raceroom/tracklistview")
require("ui/view/raceroom/tracklistview_action")

--pvprank
require("ui/view/pvprank/pvprankresultview")
require("ui/view/pvprank/pvprankresultview_action")

--racetop
require("ui/view/racetop/racetopview")
require("ui/view/racetop/racetopview_action")
require("ui/view/racetop/racetopupview")
require("ui/view/racetop/racetopupview_action")
require("ui/view/racetop/racetopgroupview")
require("ui/view/racetop/racetopgroupview_action")
require("ui/view/racetop/racetoprankinglistview")
require("ui/view/racetop/racetoprankinglistview_action")


require("ui/view/racetopsuper/racetopsuperview")
require("ui/view/racetopsuper/racetopsuperview_action")
require("ui/view/racetopsuper/racetopsuperupview")
require("ui/view/racetopsuper/racetopsuperupview_action")
require("ui/view/racetopsuper/racetopsupergroupview")
require("ui/view/racetopsuper/racetopsupergroupview_action")
require("ui/view/racetopsuper/racetopsuperrankinglistview")
require("ui/view/racetopsuper/racetopsuperrankinglistview_action")


--customtrackeditorview

require("ui/view/customtrackeditorview/customtrackeditorview")
require("ui/view/customtrackeditorview/customtrackeditorview_action")
require("ui/view/customtrackeditorview/customtracklistview_action")
require("ui/view/customtrackeditorview/customtracklistview")
require("ui/view/customtrackeditorview/tracksegmentshopview")
require("ui/view/customtrackeditorview/tracksegmentshopview_action")
require("ui/view/customtrackeditorview/tracksegmentgoodinfoview")
require("ui/view/customtrackeditorview/tracksegmentgoodinfoview_action")
require("ui/view/customtrackeditorview/tracksegmentneedview")
require("ui/view/customtrackeditorview/tracksegmentneedview_action")
require("ui/view/customtrackeditorview/page_tracksegmentshopview")

--attributeview
require("ui/view/attribute/attributeview")
require("ui/view/attribute/attributeview_action")

--specialtraining
require("ui/view/specialtraining/specialtrainingview")
require("ui/view/specialtraining/specialtrainingview_action")
require("ui/view/specialtraining/page_specialtrain_selectcar")

--race
require("ui/view/race/racemenuview")
require("ui/view/race/racemenuview_action")
require("ui/view/race/pre_racerulebaseinfo")
require("ui/view/race/pre_racerulefightgroup")
require("ui/view/race/pre_racerulefightgrouplist")
require("ui/view/race/pre_racerulesift")
require("ui/view/race/pre_raceruleresult")
require("ui/view/race/raceruleresultview")
require("ui/view/race/raceruleresultview_action")
require("ui/view/race/racerulesiftview")
require("ui/view/race/racerulesiftview_action")
require("ui/view/race/racerulefightgroupview")
require("ui/view/race/racerulefightgroupview_action")
require("ui/view/race/racerulefightgrouplistview")
require("ui/view/race/racerulefightgrouplistview_action")

--raceself
require("ui/view/raceself/raceselfview")
require("ui/view/raceself/raceselfview_action")
require("ui/view/raceself/raceselfcreateview")
require("ui/view/raceself/raceselfcreateview_step1")
require("ui/view/raceself/raceselfcreateview_step2")
require("ui/view/raceself/raceselfcreateview_step3")
require("ui/view/raceself/raceselfcreateview_step4")
require("ui/view/raceself/raceselfcreateview_action")
require("ui/view/raceself/raceselfdateview")
require("ui/view/raceself/raceselfdateview_action")
require("ui/view/raceself/raceselfjoinview")
require("ui/view/raceself/raceselfjoinview_action")
require("ui/view/raceself/raceselfselectcarview")
require("ui/view/raceself/raceselfselectcarview_action")
require("ui/view/raceself/raceselfhistoryview")
require("ui/view/raceself/raceselfhistoryview_action")
require("ui/view/raceself/raceselfmapview")
require("ui/view/raceself/raceselfmapview_action")
require("ui/view/raceself/raceselfsubresultview")
require("ui/view/raceself/raceselfsubresultview_action")

--racestreet
require("ui/view/racestreet/racestreetview")
require("ui/view/racestreet/racestreetview_action")

--selfchallenge
--require("ui/view/selfchallenge/selfchallengemenuview")
--require("ui/view/selfchallenge/selfchallengemenuview_action")
--require("ui/view/selfchallenge/selfchallengeothergamelistview")
--require("ui/view/selfchallenge/selfchallengeothergamelistview_action")
--require("ui/view/selfchallenge/selfchallengefilterview")
--require("ui/view/selfchallenge/selfchallengefilterview_action")
--require("ui/view/selfchallenge/selfchallengeselectteamview")
--require("ui/view/selfchallenge/selfchallengeselectteamview_action")
--require("ui/view/selfchallenge/selfchallengechapterlistview")
--require("ui/view/selfchallenge/selfchallengechapterlistview_action")
--require("ui/view/selfchallenge/selfchallengeselfgamelistview")
--require("ui/view/selfchallenge/selfchallengeselfgamelistview_action")
--require("ui/view/selfchallenge/selfchallengecreateview")
--require("ui/view/selfchallenge/selfchallengecreateview_action")
--require("ui/view/selfchallenge/selfchallengeselectsceneview")
--require("ui/view/selfchallenge/selfchallengeselectsceneview_action")
--require("ui/view/selfchallenge/selfchallengeselectnpcview")
--require("ui/view/selfchallenge/selfchallengeselectnpcview_action")
--require("ui/view/selfchallenge/selfchallengeselecttrackview")
--require("ui/view/selfchallenge/selfchallengeselecttrackview_action")
--require("ui/view/selfchallenge/selfchallengecreate_previewview")
--require("ui/view/selfchallenge/selfchallengecreate_selectsceneview")
--require("ui/view/selfchallenge/selfchallengecreate_selectticketsview")
--require("ui/view/selfchallenge/selfchallengecreate_setgameview")
--require("ui/view/selfchallenge/selfchallengecreate_setrewardview")
--require("ui/view/selfchallenge/selfchallengeselectticketsview")
--require("ui/view/selfchallenge/selfchallengeselectticketsview_action")
--require("ui/view/selfchallenge/selfchallengeselectrewardview")
--require("ui/view/selfchallenge/selfchallengeselectrewardview_action")

--suit
require("ui/view/suit/suitlistview")
require("ui/view/suit/suitlistview_action")
require("ui/view/suit/suitwarningview")
require("ui/view/suit/suitwarningview_action")
require("ui/view/suit/suitfirstpartview")
require("ui/view/suit/suitfirstpartview_action")

--championship
require("ui/view/racechampionship/championshipview")
require("ui/view/racechampionship/championshipview_action")

--raceweek
require("ui/view/raceweek/page_raceweekfightgroup")
require("ui/view/raceweek/page_raceweekjoin")
require("ui/view/raceweek/page_raceweekresult")
require("ui/view/raceweek/pre_raceweekbaseinfo")
require("ui/view/raceweek/raceweekview")
require("ui/view/raceweek/raceweekview_action")
require("ui/view/raceweek/raceweekdetailview")
require("ui/view/raceweek/raceweekdetailview_action")
require("ui/view/raceweek/raceweekselectcarview")
require("ui/view/raceweek/raceweekselectcarview_action")
require("ui/view/raceweek/raceweekmapview")
require("ui/view/raceweek/raceweekmapview_action")
require("ui/view/raceweek/raceweekhistoryview")
require("ui/view/raceweek/raceweekhistoryview_action")

--racerank
require("ui/view/racerank/racerankview")
require("ui/view/racerank/page_racerank_selectcar")
require("ui/view/racerank/racerankview_action")
require("ui/view/racerank/racerankmatchingview")
require("ui/view/racerank/racerankmatchingview_action")
require("ui/view/racerank/racerankjoinview")
require("ui/view/racerank/racerankjoinview_action")
require("ui/view/racerank/racerankroomview")
require("ui/view/racerank/racerankroomview_action")
require("ui/view/racerank/racerankrewardview")
require("ui/view/racerank/racerankrewardview_action")
require("ui/view/racerank/racerankspeedview")
require("ui/view/racerank/racerankspeedview_action")
require("ui/view/racerank/racerankhistoryview")
require("ui/view/racerank/racerankhistoryview_action")
require("ui/view/racerank/mini4wdruleview")
require("ui/view/racerank/mini4wdruleview_action")

--jcp
require("ui/view/racejcp/racejcpview")
require("ui/view/racejcp/racejcpview_action")
require("ui/view/racejcp/racejcpmatchingview")
require("ui/view/racejcp/racejcpmatchingview_action")
require("ui/view/racejcp/racejcpjoinview")
require("ui/view/racejcp/racejcpjoinview_action")
require("ui/view/racejcp/racejcpranklistview")
require("ui/view/racejcp/racejcpranklistview_action")
require("ui/view/racejcp/racejcpranklistrewardview")
require("ui/view/racejcp/racejcpranklistrewardview_action")
--xcp
require("ui/view/racexcp/racexcpview")
require("ui/view/racexcp/racexcpview_action")
require("ui/view/racexcp/racexcpmatchingview")
require("ui/view/racexcp/racexcpmatchingview_action")
require("ui/view/racexcp/racexcpjoinview")
require("ui/view/racexcp/racexcpjoinview_action")
require("ui/view/racexcp/racexcpranklistview")
require("ui/view/racexcp/racexcpranklistview_action")
require("ui/view/racexcp/racexcpranklistrewardview")
require("ui/view/racexcp/racexcpranklistrewardview_action")

--raceselfchapter
require("ui/view/raceselfchapter/raceselfchapterview")
require("ui/view/raceselfchapter/raceselfchapterview_action")
require("ui/view/raceselfchapter/raceselfchapterlistview")
require("ui/view/raceselfchapter/raceselfchapterlistview_action")
require("ui/view/raceselfchapter/raceselfchaptercreateview")
require("ui/view/raceselfchapter/raceselfchaptercreateview_action")
require("ui/view/raceselfchapter/raceselfchaptertaskview")
require("ui/view/raceselfchapter/raceselfchaptertaskview_action")

require("ui/view/raceselflevel/raceselflevelview")
require("ui/view/raceselflevel/raceselflevelview_action")
require("ui/view/raceselflevel/raceselflevelcreateview")
require("ui/view/raceselflevel/raceselflevelcreateview_action")


--clubraceselfchapter
require("ui/view/clubraceselfchapter/clubraceselfchapterview")
require("ui/view/clubraceselfchapter/clubraceselfchapterview_action")
require("ui/view/clubraceselfchapter/clubraceselfchapterlistview")
require("ui/view/clubraceselfchapter/clubraceselfchapterlistview_action")
require("ui/view/clubraceselfchapter/clubraceselfchaptercreateview")
require("ui/view/clubraceselfchapter/clubraceselfchaptercreateview_action")

require("ui/view/clubraceselflevel/clubraceselflevelview")
require("ui/view/clubraceselflevel/clubraceselflevelview_action")
require("ui/view/clubraceselflevel/clubraceselflevelcreateview")
require("ui/view/clubraceselflevel/clubraceselflevelcreateview_action")

--debugpersistview
require("ui/view/debug/debugpersistview")
require("ui/view/debug/debugpersistview_action")

--selectteamview
require("ui/view/selectteam/selectteambaseview")
require("ui/view/selectteam/selectteambaseview_action")
require("ui/view/selectteam/page_selectcarbase")
require("ui/view/selectteam/page_raceselflevelselectcar")
require("ui/view/selectteam/page_raceselfchapterselectcar")
require("ui/view/selectteam/page_clubraceselflevelselectcar")
require("ui/view/selectteam/page_clubraceselfchapterselectcar")
require("ui/view/selectteam/page_challengeselectcar")
require("ui/view/selectteam/page_pvechapterselectcar")
require("ui/view/selectteam/page_raceseniortrainselectcar")
require("ui/view/selectteam/page_selectcarcommon")




--pvechapterview

require("ui/view/pvechapter/pvechapterlistview")
require("ui/view/pvechapter/pvechapterlistview_action")
require("ui/view/pvechapter/pvechapterview")
require("ui/view/pvechapter/pvechapterview_action")
require("ui/view/pvechapter/pvechapterrewardview")
require("ui/view/pvechapter/pvechapterrewardview_action")
require("ui/view/pvechapter/pvechapterlevelinfoview")
require("ui/view/pvechapter/pvechapterlevelinfoview_action")
require("ui/view/pvechapter/pvechapterranklistview")
require("ui/view/pvechapter/pvechapterranklistview_action")


--LoginTaskView

require("ui/view/login/page_logintasksignview")
require("ui/view/login/logintaskview")
require("ui/view/login/logintaskview_action")
require("ui/view/login/page_loginnovicetaskview")


--EncyclopediaView
require("ui/view/encyclopedia/encyclopediaview")
require("ui/view/encyclopedia/encyclopediaview_action")

require("ui/view/encyclopedia/encyclopediadetailview")
require("ui/view/encyclopedia/encyclopediadetailview_action")


--limitchapterview
require("ui/view/limitchapter/limitchapterview")
require("ui/view/limitchapter/limitchapterview_action")

--buyDirect
require("ui/view/buydirect/buydirectview")
require("ui/view/buydirect/buydirectview_action")

--AccessoryWarehouse
require("ui/view/warehouse/warehouseview")
require("ui/view/warehouse/warehouseview_action")

--AR
require("ui/view/ar/armainview")
require("ui/view/ar/armainview_action")
require("ui/view/ar/aruseragreementview")
require("ui/view/ar/aruseragreementview_action")

--老玩家回归
require("ui/view/returnoldplayer/returnoldplayerview")
require("ui/view/returnoldplayer/returnoldplayerviewaction")
require("ui/view/returnoldplayer/page_returnoldplayersignview")
require("ui/view/returnoldplayer/page_returnoldplayertaskview")
require("ui/view/returnoldplayer/page_returnoldplayerboxview")
require("ui/view/returnoldplayer/returnoldplayeremailview")

require("ui/view/raceclub3v3/raceclub3v3view")
require("ui/view/raceclub3v3/raceclub3v3view_action")
require("ui/view/raceclub3v3/raceclub3v3rewardview")
require("ui/view/raceclub3v3/raceclub3v3rewardview_action")


--RaceTrot
require("ui/view/racetrot/racetrotselecttrackview")
require("ui/view/racetrot/racetrotselecttrackview_action")
require("ui/view/racetrot/racetrotselectcarview")
require("ui/view/racetrot/racetrotselectcarview_action")
require("ui/view/racetrot/racetrotselectenemyview")
require("ui/view/racetrot/racetrotselectenemyview_action")
require("ui/view/racetrot/racetrothistoryview")
require("ui/view/racetrot/racetrothistoryview_action")
require("ui/view/racetrot/racetrotranklistview")
require("ui/view/racetrot/racetrotranklistview_action")
require("ui/view/racetrot/racetrotrankrewardview")
require("ui/view/racetrot/racetrotrankrewardview_action")
require("ui/view/racetrot/racetrotrankshowview")
require("ui/view/racetrot/racetrotrankshowview_action")
require("ui/view/racetrot/racetrotenterview")
require("ui/view/racetrot/racetrotenterview_action")

--welfareview
require("ui/view/welfare/multiselectview")
require("ui/view/welfare/multiselectview_action")
require("ui/view/welfare/welfareview")
require("ui/view/welfare/welfareview_action")
require("ui/view/welfare/page_welfareviewbase")
require("ui/view/welfare/page_monthsignview")
require("ui/view/welfare/page_physicalpowerview")
require("ui/view/welfare/page_videodaygiftview")
require("ui/view/welfare/page_videoluckytableview")
require("ui/view/welfare/page_boxawardsview")
require("ui/view/welfare/page_examinationview")
require("ui/view/boxawardhelp/boxawardhelpview")
require("ui/view/boxawardhelp/boxawardhelpview_action")




require("ui/view/videoplay/videoplayforurlview")
require("ui/view/videoplay/videoplayforurlview_action")


require("ui/view/racegvg/racegvgview")
require("ui/view/racegvg/racegvgview_action")
require("ui/view/racegvg/racegvgranklistview")
require("ui/view/racegvg/racegvgranklistview_action")
require("ui/view/racegvg/racegvgresultview")
require("ui/view/racegvg/racegvgresultview_action")
require("ui/view/help/racestateview")
require("ui/view/help/racestateview_action")

require("ui/view/transit/transitview")
require("ui/view/transit/transitview_action")

require("ui/view/raceseniortrain/raceseniortrainlistview")
require("ui/view/raceseniortrain/raceseniortrainlistview_action")
require("ui/view/raceseniortrain/raceseniortrainview")
require("ui/view/raceseniortrain/raceseniortrainview_action")


--CarGod
require("ui/view/racecargod/racecargodview")
require("ui/view/racecargod/racecargodview_action")
require("ui/view/racecargod/racecargodinfoview")
require("ui/view/racecargod/page_racecargod_selectcar")
require("ui/view/racecargod/racecargodinfoview_action")



--SuperBattle
require("ui/view/racesuperbattle/racesuperbattleview")
require("ui/view/racesuperbattle/racesuperbattleview_action")
require("ui/view/racesuperbattle/racesuperbattleenterview")
require("ui/view/racesuperbattle/racesuperbattleenterview_action")
require("ui/view/racesuperbattle/racesuperbattlerecordview")
require("ui/view/racesuperbattle/racesuperbattlerecordview_action")
require("ui/view/racesuperbattle/racesuperbattlerankview")
require("ui/view/racesuperbattle/racesuperbattlerankview_action")
require("ui/view/racesuperbattle/racesuperbattlebantrackview")
require("ui/view/racesuperbattle/racesuperbattlebantrackview_action")
require("ui/view/racesuperbattle/racesuperbattlelistview")
require("ui/view/racesuperbattle/racesuperbattlelistview_action")
require("ui/view/racesuperbattle/page_superbattle_selectcar")


--minigame

require("ui/view/minigame/minigameview")
require("ui/view/minigame/minigameview_action")

--recruitgo
require("ui/view/recruitgo/recruitgoview")
require("ui/view/recruitgo/recruitgoview_action")
require("ui/view/recruitgo/chargetipsview")
require("ui/view/recruitgo/chargetipsview_action")

--actadvancenotice
require("ui/view/actadvancenotice/page_actadvancenoticeviewbase")
require("ui/view/actadvancenotice/page_actadvancenoticeracetrotview")
require("ui/view/actadvancenotice/page_actadvancenoticeracetopview")
require("ui/view/actadvancenotice/page_actadvancenoticeracegvgview")
require("ui/view/actadvancenotice/page_actadvancenoticeracesuperbattleview")
require("ui/view/actadvancenotice/actproclamationview")
require("ui/view/actadvancenotice/actproclamationview_action")


require("ui/view/popupgift/popupgiftview")
require("ui/view/popupgift/popupgiftview_action")
require("ui/view/popupgift/page_popupgiftviewbase")
require("ui/view/popupgift/page_popupgiftlevelview")
require("ui/view/popupgift/page_popupgiftluckview")
require("ui/view/popupgift/page_popupgiftfailureview")
require("ui/view/popupgift/page_popupgiftstickerview")

require("ui/view/illustratedhandbook/illustratedhandbookview")
require("ui/view/illustratedhandbook/illustratedhandbookview_action")
require("ui/view/illustratedhandbook/page_illustratedhandbookviewbase")
require("ui/view/illustratedhandbook/page_illustratedhandbookpartview")
require("ui/view/illustratedhandbook/page_illustratedhandbookportraitview")
require("ui/view/illustratedhandbook/page_illustratedhandbookcupview")


require("ui/view/messagebox/playertipsview")
require("ui/view/messagebox/playertipsview_action")
require("ui/view/activity/giftshowrewardview")
require("ui/view/activity/giftshowrewardview_action")

require("ui/view/forbidden/forbiddenview")
require("ui/view/forbidden/forbiddenview_action")
require("ui/view/raceassemble/racetestrunenterview")
require("ui/view/raceassemble/racetestrunenterview_action")
require("ui/view/raceassemble/raceassemblegarageview")
require("ui/view/raceassemble/raceassemblegarageview_action")
require("ui/view/raceassemble/raceassembleenterview")
require("ui/view/raceassemble/raceassembleenterview_action")
require("ui/view/raceassemble/raceassembleranklistview")
require("ui/view/raceassemble/raceassembleranklistview_action")
require("ui/view/raceassemble/page_raceassemblegarage_carinfo")
require("ui/view/raceassemble/page_raceassemblegarage_partinfo")
require("ui/view/raceassemble/page_raceassemblegarage_partlist")
require("ui/view/raceassemble/page_raceassemblegarage_partmap")
require("ui/view/raceassemble/page_raceassemblegarage_reform")
require("ui/view/raceassemble/page_raceassemblegarage_reformselect")

require("ui/view/racefifa/racefifaguessview")
require("ui/view/racefifa/racefifaguessview_action")
require("ui/view/racefifa/racefifaknockoutview")
require("ui/view/racefifa/racefifaknockoutview_action")
require("ui/view/racefifa/racefifateamlistview")
require("ui/view/racefifa/racefifateamlistview_action")

require("ui/view/bag/articledisassembleview")
require("ui/view/bag/articledisassembleview_action")
require("ui/view/racerank/raceranktrackview")
require("ui/view/racerank/raceranktrackview_action")
require("ui/view/racerank/raceranknewview")
require("ui/view/racerank/raceranknewview_action")
require("ui/view/racerank/page_raceranknew_selectcar")
require("ui/view/gamebind/gamebindview")
require("ui/view/gamebind/gamebindview_action")
