---------- 协议类结构注释，不require

---@class SC_ActBaseDict
---@field actId number
---@field beginTime number
---@field endTime number


---@class SC_ActChargeGift
---@field rid number
---@field actId number
---@field actBuyFlag table<number,number>
---@field nowday number
---@field buyItems table<number,number>


---@class SC_ActCount
---@field actType number
---@field countNo number
---@field awardIds table<number,number>
---@field awardNums table<number,number>
---@field giftFlag number
---@field actId number


---@class SC_ActCountGift
---@field rid number
---@field actId number
---@field downList SC_SomeDown
---@field giftFlags table<number,number>


---@class SC_ActDayGift
---@field rid number
---@field actId number
---@field actBuyFlag table<number,number>
---@field nowday number
---@field buyItems table<number,number>
---@field finishGift number
---@field finishGiftId number


---@class SC_ActDayGiftFinish
---@field rid number
---@field mySomeDown table<number,SC_SomeDown>
---@field finishGift number
---@field actId number


---@class SC_ActDesignGift
---@field itemId number
---@field awardId table<number,number>
---@field awardNum table<number,number>
---@field ifbuy number


---@class SC_ActDesignList
---@field rid number
---@field myDesignGift table<number,SC_ActDesignGift>
---@field actId number


---@class SC_ActGift
---@field itemid number
---@field chargetype number
---@field buytime number
---@field buysum number
---@field exptime number


---@class SC_ActGiftBuy
---@field itemid number
---@field buymax number
---@field buysum number


---@class SC_ActGiftPackage
---@field rid number
---@field actId number
---@field beginTime number
---@field endTime number
---@field giftPackages table<number,SC_ActGiftBuy>


---@class SC_ActGrowup
---@field lev number
---@field curtype number
---@field ifaward number
---@field itemid number


---@class SC_ActGrowupGift
---@field rid number
---@field alterActGrowup table<number,SC_ActGrowup>
---@field downlist SC_SomeDown
---@field unlockActGrowup table<number,SC_ActGrowup>


---@class SC_ActInfo
---@field itemid number
---@field chargetype number
---@field firsttime number
---@field buysum number
---@field buytime number
---@field exptime number
---@field giftTime number
---@field begintime number
---@field endtime number


---@class SC_ActLuckAward
---@field rid number
---@field hitVal table<number,number>
---@field mySomeDown table<number,SC_SomeDown>
---@field actId number


---@class SC_ActLuckInfo
---@field rid number
---@field luckflag number
---@field actId number


---@class SC_ActLuckTable
---@field rid number
---@field hitSeq table<number,number>
---@field mySomeDown table<number,SC_SomeDown>
---@field curConsume SC_Consume
---@field actId number


---@class SC_ActMission
---@field rid number
---@field actTasks table<number,SC_UserTask>
---@field curConsume SC_Consume
---@field actId number


---@class SC_ActPeriod
---@field itemid number
---@field chargetype number
---@field buytime number
---@field exptime number
---@field giftTime number


---@class SC_ActShopInfo
---@field rid number
---@field shopid number
---@field exchid number
---@field exchnum number
---@field shoplist table<number,SC_ShopItem>


---@class SC_ActSign
---@field rid number
---@field actId number
---@field actSigns table<number,number>
---@field nowday number


---@class SC_ActSignNow
---@field rid number
---@field curActSign SC_ActSign
---@field mySomeDown table<number,SC_SomeDown>
---@field curConsume SC_Consume


---@class SC_ActSumCharge
---@field rid number
---@field sumType number
---@field curSumval string
---@field boxGift number
---@field giftFlags table<number,number>
---@field mySomeDown table<number,SC_SomeDown>
---@field actId number


---@class SC_ActTimeToken
---@field rid number
---@field tokenid number
---@field lev number
---@field curexp number
---@field ifbuy number
---@field ifgift table<number,string>


---@class SC_ActToken
---@field rid number
---@field tokenid number
---@field begintime number
---@field endtime number
---@field lev number
---@field curexp number
---@field ifbuy number
---@field ifgift table<number,string>


---@class SC_ActWordExch
---@field exchinx number
---@field exchpropid number
---@field exchsum number
---@field exchnum number


---@class SC_ActWordGift
---@field rid number
---@field exchprop SC_ActWordExch
---@field mySomeDown table<number,SC_SomeDown>
---@field curConsume table<number,SC_Consume>
---@field actId number


---@class SC_ActWordList
---@field rid number
---@field myWordExch table<number,SC_ActWordExch>
---@field actId number


---@class SC_ActiveGift
---@field rid number
---@field taskgift SC_TaskActiveGift
---@field downlist SC_SomeDown


---@class SC_ActivityInfo
---@field rid number
---@field curActInfo table<number,SC_ActInfo>
---@field myActGrowup SC_UserActGrowup
---@field curActCount table<number,SC_ActCount>
---@field cporderid string
---@field myActLevelup SC_UserActGrowup
---@field curBind SC_UserRidInfo


---@class SC_AliveTech
---@field rid number
---@field curTech SC_UserTech
---@field curConsumes SC_ConsumGroup


---@class SC_AltUserBackground
---@field rid number
---@field background number


---@class SC_AltUserIcon
---@field rid number
---@field headicon number
---@field iconframe number


---@class SC_AltUserRole
---@field rid number
---@field rolename string
---@field props SC_Consume


---@class SC_AltUserSign
---@field rid number
---@field sign string


---@class SC_AltUserTitleCup
---@field rid number
---@field cups string


---@class SC_AlterPart
---@field rid number
---@field curCar SC_UserCar
---@field unloadParts table<number,number>
---@field loadParts number
---@field planSeq number
---@field deleteParts table<number,number>


---@class SC_AlterUserHead
---@field rid number
---@field alterHead table<number,SC_UserHead>


---@class SC_AlterrTask
---@field rid number
---@field alterTasks table<number,SC_UserTask>


---@class SC_Attr
---@field attrId number
---@field attrVal number


---@class SC_AuthuserMess
---@field uid string
---@field rid number
---@field lastsvr number
---@field svrs table<number,SC_svrList>
---@field authtoken string


---@class SC_Awards
---@field awardId table<number,number>
---@field awardNum table<number,number>


---@class SC_BaseC2S
---@field p1 string
---@field p2 string
---@field p3 string
---@field p4 string
---@field p5 string
---@field p6 string
---@field p7 string
---@field p8 string
---@field p9 string
---@field p10 table<number,number>
---@field p11 string


---@class SC_BaseG2A
---@field serverno string
---@field runstat string
---@field svrip string
---@field svrport string
---@field sumOnline number


---@class SC_BaseGame2World
---@field serverno number
---@field runstat string
---@field runflag string
---@field svrip string
---@field svrport number
---@field sumonline number


---@class SC_BattleError
---@field rid number
---@field errorcode number
---@field seqno number


---@class SC_BattleInfo
---@field rolename string
---@field scenceid string
---@field createtime string
---@field overtime string
---@field trackinfo SC_UserTrack
---@field firstracer table<number,SC_BattleRaceInfo>
---@field headicon number
---@field trackid number
---@field createrid number
---@field awardid string
---@field guildname string
---@field resulttime string
---@field diamondpool number
---@field rank3list table<number,SC_rank3>
---@field agree number
---@field iconframe number


---@class SC_BattleRaceInfo
---@field rid number
---@field rolename string
---@field position number
---@field car SC_UserCar
---@field headicon number
---@field iconframe number
---@field titleback number
---@field titlecup string
---@field curlevel number


---@class SC_BattleRecord
---@field battleid number
---@field curnum number
---@field maxnum number
---@field agree number


---@class SC_BeginFastPvp
---@field rid number
---@field trackid number
---@field scenseid number
---@field racelist table<number,SC_FighterInfo>
---@field curtimes number
---@field consumelist table<number,SC_Consume>
---@field starttime number
---@field match SC_FastMatch
---@field curlevel number


---@class SC_BeginGodPve
---@field rid number
---@field seasonid number
---@field starttime number
---@field race table<number,SC_RaceInfo>
---@field trackid number
---@field sceneid number


---@class SC_BeginPve
---@field rid number
---@field copyid number
---@field carid number
---@field starttime number
---@field car SC_UserCar
---@field cars table<number,SC_UserCar>
---@field carids table<number,number>
---@field curlevel number
---@field ver string


---@class SC_BorrowApp
---@field rid number
---@field partInx number
---@field applyPart SC_BorrowPart
---@field accessFlag number
---@field fRolename string
---@field fHeadIcon number
---@field fIconFrame number
---@field fCurLevel number
---@field borrowName string
---@field downlist table<number,SC_SomeDown>
---@field originRid number


---@class SC_BorrowDownPart
---@field rid number
---@field curApp SC_BorrowApp
---@field downPart SC_UserPart


---@class SC_BorrowPart
---@field source number
---@field partinx number
---@field copypartid number
---@field curlevel number
---@field breakflag number
---@field colorid number
---@field curEntry table<number,SC_UserPartEntry>
---@field exptime number
---@field oldinx number
---@field hexptime number
---@field partid number
---@field partAttrs table<number,SC_Attr>
---@field curstar number
---@field partage number
---@field stickerid number
---@field shellhole table<number,number>
---@field downtype number
---@field hirenum number
---@field hirerid number


---@class SC_BreakPart
---@field rid number
---@field breakPart SC_UserPart
---@field curConsumes SC_ConsumGroup
---@field carAttrs table<number,SC_Attr>
---@field breakFlag number


---@class SC_BuyActTimeToken
---@field rid number
---@field alterActTimeToken SC_ActTimeToken
---@field payMoney SC_Consume


---@class SC_BuyActToken
---@field rid number
---@field alterActToken SC_ActToken
---@field payMoney SC_Consume


---@class SC_CapyActGift
---@field itemId number
---@field acttype number
---@field buyNum number


---@class SC_ChapterAward
---@field rid number
---@field chapterid number
---@field awardno table<number,number>
---@field curdown SC_SomeDown


---@class SC_ChapterInfo
---@field chapterId number
---@field starNum number
---@field rewards table<number,number>
---@field btime number
---@field etime number
---@field finishsum number
---@field needlev number
---@field joined number
---@field copys table<number,SC_CopyInfo>
---@field testMaxNum number
---@field testCurNum number
---@field starOver number


---@class SC_ChargeFinish
---@field myPassFound SC_MyPassFound
---@field cporderid string
---@field curActGift SC_ActGift
---@field myActFirst table<number,SC_UserFirstGift>
---@field buyActToken number
---@field downlist SC_SomeDown
---@field giftFlags table<number,number>
---@field orderstatus number
---@field buyItems table<number,SC_UserTimeBuy>
---@field rid number
---@field myAdList SC_UserAdList
---@field firstflag number
---@field curActPeriod SC_ActPeriod
---@field buyActGrowup number
---@field buyBacksign number
---@field batCharge number
---@field buyActTimeToken number
---@field innerid string


---@class SC_ChargeMail
---@field itemid number
---@field cporderid string
---@field firstflag number
---@field myActFirst table<number,SC_UserFirstGift>


---@class SC_ChargeOrder
---@field rid number
---@field orderjson string
---@field seqno number
---@field orderstatus number
---@field token string
---@field innerid string
---@field markcode string


---@class SC_ChargeSucc
---@field rid number
---@field curdiamond number
---@field chargenum number
---@field curviplev number
---@field firstpay number
---@field cporderid string
---@field dsorderid string


---@class SC_ConsumGroup
---@field allConsumes table<number,SC_Consume>


---@class SC_Consume
---@field propsid number
---@field propsnum number


---@class SC_CopyInfo
---@field copyid number
---@field star table<number,number>
---@field fasttime number
---@field todynum number
---@field winsum number
---@field unlock number
---@field btime number
---@field awards table<number,number>


---@class SC_CopyStarAward
---@field rid number
---@field copyid number
---@field awardno table<number,number>
---@field curdown SC_SomeDown


---@class SC_CreateOrder
---@field createsucc number
---@field ordersign string
---@field seqno number
---@field itemId number
---@field markcode string
---@field brchoose number


---@class SC_CreateSucc
---@field rid number
---@field itemId number
---@field innerId string
---@field cporderId string
---@field markcode string
---@field chargeselect number
---@field url string


---@class SC_DayVideoGift
---@field seq number
---@field watchNum number
---@field maxWatch number
---@field curStatus number
---@field mySomeDown table<number,SC_SomeDown>
---@field countNum number
---@field countGift table<number,number>


---@class SC_Decompose
---@field rid number
---@field deParts table<number,number>
---@field curDown SC_SomeDown


---@class SC_DecomposeStore
---@field rid number
---@field deStoreParts table<number,SC_UserProp>
---@field curDown SC_SomeDown


---@class SC_DelHireApp
---@field rid number
---@field frid number
---@field partInx number


---@class SC_DelPartApp
---@field rid number
---@field frid number
---@field partInx number


---@class SC_DelUserTrack
---@field rid number
---@field delTrackId number
---@field alterProps table<number,SC_UserProp>


---@class SC_DenyTalk
---@field rid number
---@field denys table<number,SC_DenyTalkInfo>


---@class SC_DenyTalkInfo
---@field targId number
---@field targName string
---@field headicon number
---@field iconframe number


---@class SC_DirectCharge
---@field rid number
---@field chargeItems table<number,SC_DirectChargeItem>


---@class SC_DirectChargeItem
---@field itemid number
---@field firstflag number
---@field diamond number
---@field addmoney number


---@class SC_EditUserTrack
---@field rid number
---@field editTrack SC_UserTrack
---@field alterProps table<number,SC_UserProp>


---@class SC_ErrorMess
---@field errorcode string
---@field curtime number


---@class SC_ExchGold
---@field rid number
---@field payMoney SC_Consume
---@field downsome SC_SomeDown
---@field dispDown table<number,SC_downGold>
---@field exchgold number


---@class SC_Exchange
---@field rid number
---@field exchcode string
---@field downlist SC_SomeDown


---@class SC_FastCopyInfo
---@field stop string
---@field name string
---@field ver string
---@field time number
---@field titlecup string
---@field partrec string
---@field copyid number
---@field powerstart number
---@field attrs table<number,string>
---@field seeds table<number,number>
---@field stops table<number,string>
---@field rid number
---@field curleves table<number,string>
---@field icon number
---@field titleback string
---@field attr string
---@field chapterid number
---@field seed number
---@field times table<number,number>
---@field partrecs table<number,string>
---@field powerstarts table<number,number>


---@class SC_FastMatch
---@field continuewin number
---@field seasonid number
---@field matchwin table<number,number>
---@field curpoint number
---@field freshfighter number
---@field curdaynum number
---@field trackwinpercent table<number,number>
---@field boxid number
---@field sourceboxpoint table<number,number>
---@field stepno number
---@field selectedtrack number
---@field selectedFighter SC_FighterInfo
---@field actnum number
---@field rid number
---@field upmatch number
---@field curfastlve number
---@field freshtrack number
---@field maxboxpoint number
---@field payMoney SC_Consume
---@field maxdaynum number
---@field watchloc table<number,number>
---@field boxpoint number
---@field standbytrack table<number,number>
---@field standbyfighter table<number,SC_FighterInfo>
---@field winsum number


---@class SC_FighterInfo
---@field rid number
---@field rolename string
---@field position number
---@field curfastlve number
---@field curpoint number
---@field car SC_UserCar
---@field headicon number
---@field iconframe number
---@field point number
---@field superflag number
---@field titleback number
---@field titlecup string


---@class SC_FinishCharge
---@field rid number
---@field chargeInfo table<number,SC_ChargeFinish>
---@field curConsume SC_Consume


---@class SC_FinishFastPvp
---@field rid number
---@field curdown SC_SomeDown
---@field match SC_FastMatch
---@field errCode string


---@class SC_FinishGodPve
---@field rid number
---@field seasonid number
---@field curdown SC_SomeDown
---@field errcode string
---@field awards string


---@class SC_FinishJcup
---@field rid number
---@field curdown SC_SomeDown
---@field errCode string


---@class SC_FinishPve
---@field errcode string
---@field copyid number
---@field buyItems table<number,SC_UserTimeBuy>
---@field allStar number
---@field curdown SC_SomeDown
---@field staminaTime number
---@field level number
---@field addLev number
---@field winsum number
---@field levelupdown SC_SomeDown
---@field rid number
---@field moreexp number
---@field star table<number,number>
---@field curStar table<number,number>
---@field unlockcopy table<number,number>
---@field stamina number
---@field exp number
---@field addExp number
---@field num number
---@field curConsume SC_Consume


---@class SC_FinishPvp
---@field rid number
---@field score number
---@field point number
---@field num number
---@field curdown SC_SomeDown
---@field numrl number
---@field numtest number
---@field errcode string


---@class SC_FinishXcup
---@field rid number
---@field curdown SC_SomeDown
---@field errCode string


---@class SC_FriendInfo
---@field friendrid number
---@field headicon string
---@field iconframe string
---@field rolename string
---@field curlevel string
---@field lastlogin number
---@field ifadd number
---@field score number


---@class SC_FriendPart
---@field rid number
---@field frid number
---@field rolename string
---@field headicon number
---@field iconframe number
---@field curlevel number
---@field parts table<number,SC_BorrowPart>


---@class SC_Furniture
---@field rid number
---@field furnitureInx number
---@field furnitureId number


---@class SC_GetUserHome
---@field rid number
---@field rolename string
---@field homeinfo string
---@field cars table<number,SC_UserCar>
---@field reqrid number
---@field curlevel number
---@field guildname string
---@field sign string
---@field headicon number
---@field iconframe number
---@field myFurniture table<number,SC_Furniture>


---@class SC_GetWay
---@field rid number
---@field propid string
---@field copyids table<number,SC_wayinfo>


---@class SC_GiftActTimeToken
---@field rid number
---@field alterActToken SC_ActTimeToken
---@field downlist SC_SomeDown


---@class SC_GiftActToken
---@field rid number
---@field alterActToken SC_ActToken
---@field downlist SC_SomeDown


---@class SC_GodAward
---@field rankid number
---@field awardid number
---@field speed string


---@class SC_GodInfo
---@field rid number
---@field ranks table<number,SC_SeasonRanks>
---@field mygods table<number,SC_MyGod>


---@class SC_GuildInfo
---@field guildid number
---@field guildicon number
---@field guildpub string
---@field guildname string
---@field guildlev number
---@field guildmoney number
---@field needlev number
---@field guildtype number
---@field members number
---@field leader number
---@field leadername string


---@class SC_GuildSign
---@field rid number
---@field guildid number
---@field downlist table<number,SC_SomeDown>
---@field curExp number


---@class SC_GvgPointFinish
---@field rid number
---@field curnum number
---@field errcode string
---@field point number


---@class SC_GvgPointRank
---@field userranks table<number,SC_RankInfo>


---@class SC_GvgPointRanks
---@field ranks SC_GvgPointRank
---@field stageid number
---@field type number
---@field seqno number
---@field rid number


---@class SC_HireApp
---@field hirerid number
---@field partInx number
---@field copypartid number
---@field accessFlag number
---@field exptime number
---@field fRolename string
---@field fIconFrame number
---@field hireName string
---@field downlist table<number,SC_SomeDown>
---@field source number
---@field rid number
---@field hexptime number
---@field partiId number
---@field hirenum number
---@field fHeadIcon number
---@field fCurLevel number
---@field payMoney SC_Consume
---@field originRid number


---@class SC_HireCoin
---@field rid number
---@field curConsumes SC_ConsumGroup
---@field downlist SC_SomeDown
---@field exchCoins table<number,SC_HireCoinExch>


---@class SC_HireCoinExch
---@field exchCoin number
---@field exchNum number
---@field freshTime number
---@field maxNum number


---@class SC_HireDownPart
---@field rid number
---@field curApp SC_HireApp
---@field downPart SC_UserPart
---@field payMoney SC_Consume
---@field newFlag number


---@class SC_KillerAward
---@field rid number
---@field downlists table<number,SC_SomeDown>
---@field awards string


---@class SC_KillerGuess
---@field rid number
---@field consumelist table<number,SC_Consume>
---@field guessrid string


---@class SC_LevelAward
---@field rid number
---@field downlist SC_SomeDown
---@field level number


---@class SC_LoginProp
---@field rid number
---@field myParts table<number,SC_UserPart>
---@field myCars table<number,SC_UserCar>
---@field carShellNum number
---@field myPrivate table<number,SC_TalkInfo>
---@field myWorld table<number,SC_TalkInfo>
---@field myServer table<number,SC_TalkInfo>
---@field myTopSystem table<number,SC_TalkInfo>
---@field mySystemInfo table<number,SC_TalkInfo>
---@field myInviteInfo table<number,SC_TalkInfo>
---@field userinfo SC_UserInfoPacket


---@class SC_LoginSuccess
---@field myTrack table<number,SC_UserTrack>
---@field capyActives table<number,SC_UserActive>
---@field myProps table<number,SC_UserProp>
---@field myRecruits SC_RecruitInfo
---@field menulist table<number,SC_MenuInfo>
---@field myTradeTask table<number,SC_UserTask>
---@field myGuildTalk table<number,SC_TalkInfo>
---@field fieldFlag number
---@field curMonthPeriod SC_ActPeriod
---@field myPassFound table<number,SC_MyPassFound>
---@field userinfo SC_UserInfoPacket
---@field myReloadCharge table<number,SC_reloadCharge>
---@field finishFlag number
---@field curRedInfo SC_RedInfo
---@field myMainTask table<number,SC_UserTask>
---@field doubleDown number
---@field curWeekPeriod SC_ActPeriod
---@field testGiftFlag number
---@field errorCode string
---@field myActFirst table<number,SC_UserFirstGift>
---@field myBoxs table<number,SC_UserBox>
---@field myFurniture table<number,SC_Furniture>
---@field serverTime number
---@field dictActBase table<number,SC_ActBaseDict>
---@field refight number
---@field myTimebuy table<number,SC_UserTimeBuy>
---@field rid number
---@field myDirect table<number,SC_UserDirect>
---@field myShiftInfo SC_UserShiftInfo
---@field myHeads table<number,SC_UserHead>
---@field nowOpenActs table<number,number>
---@field maillist table<number,SC_MailInfo>
---@field myActiveTask table<number,SC_TaskActiveGift>
---@field startTime number


---@class SC_MailDeled
---@field rid number
---@field mailid table<number,number>


---@class SC_MailDown
---@field rid number
---@field mailid table<number,number>
---@field downlist table<number,SC_SomeDown>
---@field curgold number
---@field curdiamond number
---@field curfriendval number
---@field mailCharge table<number,SC_ChargeMail>


---@class SC_MailInfo
---@field mailid number
---@field mailtype number
---@field mailtop string
---@field mailcont string
---@field ifuse number
---@field exptime number
---@field userprop table<number,SC_UserProp>
---@field sendtime number
---@field sender string


---@class SC_MailOpened
---@field rid number
---@field mailid number
---@field ifuse number


---@class SC_MainTaskSubmit
---@field rid number
---@field finishMTask number
---@field newmainTask number
---@field downlist table<number,SC_SomeDown>


---@class SC_MatchBaseInfo
---@field stageid string
---@field matchid string


---@class SC_MatchInfo
---@field race1 SC_RacerInfo
---@field race2 SC_RacerInfo
---@field car1 table<number,SC_UserCar>
---@field car2 table<number,SC_UserCar>
---@field winlose table<number,string>
---@field time1 table<number,string>
---@field time2 table<number,string>
---@field seed number
---@field trackids string
---@field groundids string
---@field matchid string
---@field matchstr string
---@field loc1 table<number,number>
---@field loc2 table<number,number>


---@class SC_MatchInfos
---@field rid number
---@field matchs table<number,SC_MatchInfo>
---@field ranktype string
---@field rankgroup string
---@field watchrid string
---@field mygroup number
---@field stagestrs table<number,string>
---@field rids table<number,string>
---@field matchno string


---@class SC_MemberInfo
---@field rid string
---@field position string
---@field curactivity string
---@field donationsum string
---@field exchsum string
---@field jointime string
---@field rolename string
---@field curlevel string
---@field logintime string
---@field headicon string
---@field iconframe string
---@field weekpoint number


---@class SC_MenuInfo
---@field menuid number
---@field redpoint number


---@class SC_MyAd
---@field adId number
---@field viewNum number
---@field viewStart number
---@field expTime number


---@class SC_MyBorrowApp
---@field rid number
---@field curApp table<number,SC_BorrowApp>
---@field borrowType number


---@class SC_MyGod
---@field seasonid number
---@field speed string
---@field awards string


---@class SC_MyHireApp
---@field rid number
---@field curApp table<number,SC_HireApp>
---@field hireType number


---@class SC_MyPassFound
---@field foundId number
---@field foundType number
---@field subId number
---@field curLv number
---@field curExp number
---@field addNum number
---@field ifBuy number
---@field ifGift string
---@field buyProp number
---@field buyNum number
---@field expTime number


---@class SC_NewRaceInfo
---@field rid number
---@field rolename string
---@field position number
---@field score number
---@field car SC_UserCar
---@field testrace number
---@field headicon number
---@field iconframe number
---@field op string
---@field curlev number
---@field titleback number
---@field titlecup string
---@field trackid string


---@class SC_OneGodInfo
---@field rid number
---@field seasonid number
---@field ranks SC_SeasonRanks
---@field mygod SC_MyGod
---@field godawards table<number,SC_GodAward>


---@class SC_OpenOptionalBox
---@field rid number
---@field curConsume SC_Consume
---@field downlist SC_SomeDown


---@class SC_OpenPackage
---@field rid number
---@field curConsume SC_Consume
---@field downlist SC_SomeDown


---@class SC_OpenRandBox
---@field rid number
---@field curConsume SC_Consume
---@field downlist SC_SomeDown


---@class SC_OpenScience
---@field rid number
---@field curScience SC_UserScience
---@field curConsumes SC_ConsumGroup


---@class SC_PartInherit
---@field rid number
---@field inheritId number
---@field consumePartinxs table<number,number>
---@field curPart SC_UserPart
---@field curConsumes SC_Consume
---@field planSeq number
---@field carAttrs table<number,SC_Attr>


---@class SC_PartInheritAlter
---@field rid number
---@field inheritId number
---@field curConsumes SC_Consume
---@field curPart SC_UserPart
---@field planSeq number
---@field carAttrs table<number,SC_Attr>


---@class SC_PartInheritUplev
---@field rid number
---@field inheritId number
---@field attrid table<number,number>
---@field curPart SC_UserPart
---@field curConsumes SC_ConsumGroup
---@field planSeq number
---@field carAttrs table<number,SC_Attr>
---@field upLev number
---@field curexp number
---@field reformval table<number,number>
---@field consumePartinxs table<number,number>


---@class SC_PartLevelUp
---@field planSeq number
---@field carAttrs table<number,SC_Attr>
---@field curPart SC_UserPart
---@field curConsume SC_Consume


---@class SC_PartStore
---@field rid number
---@field storePart table<number,SC_UserProp>


---@class SC_PlayerUpLevel
---@field uplevel number
---@field curlevel number
---@field curexp number


---@class SC_PullStore
---@field rid number
---@field deStoreParts table<number,SC_UserProp>
---@field pullParts SC_SomeDown


---@class SC_PveRecord
---@field rid number
---@field rolename string
---@field iconframe number
---@field headicon number
---@field seed number
---@field fasttime number
---@field partrec string
---@field curattrec string
---@field op number
---@field powerstart number


---@class SC_RaceInfo
---@field rid number
---@field rolename string
---@field position number
---@field score number
---@field car SC_UserCar
---@field testrace number
---@field headicon number
---@field iconframe number
---@field op string
---@field curlev number
---@field powerstart string
---@field cars table<number,SC_UserCar>
---@field titleback number
---@field titlecup string


---@class SC_RacerInfo
---@field rid string
---@field rolename string
---@field score string
---@field headicon string
---@field iconframe string
---@field level number
---@field titleback string
---@field titlecup string


---@class SC_RankInfo
---@field stageid number
---@field rid number
---@field headicon string
---@field iconframe string
---@field rolename string
---@field speed string
---@field guildid string
---@field point string
---@field guildname string
---@field rankid number
---@field titleback number
---@field titlecup string


---@class SC_RebackSign
---@field rid number
---@field curSign SC_UserBackSign
---@field mySomeDown table<number,SC_SomeDown>


---@class SC_RebackSupport
---@field loc number
---@field actId number
---@field unlockTime number
---@field supportPart SC_BorrowPart
---@field freshTime number


---@class SC_RecruitChance
---@field propId number
---@field propType number
---@field propNum number
---@field Chance string


---@class SC_RecruitDetail
---@field recruitstyle number
---@field employeeids table<number,number>
---@field recruitstatus table<number,number>
---@field recruitpay number
---@field freetime number


---@class SC_RecruitInfo
---@field sumval number
---@field moneyId number
---@field CurSelect string
---@field tenExpend number
---@field freeTime number
---@field readyTime number
---@field endTime number
---@field dayNum number
---@field pTicket number
---@field curShare number
---@field recruitId number
---@field awardids table<number,number>
---@field oneExpend number
---@field selectnum number
---@field freeNum number
---@field beginTime number
---@field prizeNum number
---@field daySum number
---@field curPrizeNum number


---@class SC_RedInfo
---@field rid number
---@field redid table<number,number>
---@field fights table<number,SC_fightInfo>
---@field activeid table<number,number>


---@class SC_RefromPart
---@field rid number
---@field curEntryId number
---@field curPart SC_UserPart
---@field curConsumes SC_ConsumGroup
---@field planSeq number
---@field carAttrs table<number,SC_Attr>
---@field entryAttrs table<number,SC_Attr>


---@class SC_ReqAccept
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqAlterCar
---@field rid number
---@field cardid number
---@field serverid number
---@field seqno number
---@field car SC_UserCar


---@class SC_ReqAlterTrack
---@field rid number
---@field trackid number
---@field serverid number
---@field seqno number


---@class SC_ReqBattleAgree
---@field rid number
---@field seqno number
---@field serverid number
---@field battleid number


---@class SC_ReqBattleDetail
---@field rid number
---@field seqno number
---@field serverid number
---@field battleid number


---@class SC_ReqBattleList
---@field rid number
---@field seqno number
---@field serverid number


---@class SC_ReqBattleRank
---@field rid number
---@field seqno number
---@field serverid number
---@field battleid number


---@class SC_ReqCancle
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqCreateBattle
---@field rid number
---@field awardid string
---@field trackid string
---@field scenceid string
---@field rolename string
---@field guildname string
---@field seqno number
---@field serverid number
---@field createtime number
---@field resulttime number
---@field headicon number
---@field iconframe number


---@class SC_ReqCreateSelfRoom
---@field rid number
---@field racer SC_SelfRaceInfo
---@field trackid number
---@field groundid number
---@field pwd string
---@field roomname string
---@field tracktype number
---@field serverid number
---@field seqno number
---@field selftrack number
---@field randomtype number


---@class SC_ReqEnterSelfRoom
---@field rid number
---@field roomid number
---@field pwd string
---@field racer SC_SelfRaceInfo
---@field serverid number
---@field seqno number


---@class SC_ReqFinishSelf
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqGuildInfo
---@field rid number
---@field seqno number
---@field serverid number


---@class SC_ReqGuildPveInfo
---@field rid number
---@field seasonid number
---@field curnum number
---@field maxnum number
---@field trackid table<number,number>
---@field scenceid table<number,number>
---@field btime number
---@field etime number
---@field personscore number
---@field guildscore number
---@field personaward string
---@field guildaward string


---@class SC_ReqGvgPointRank
---@field rid number
---@field stageid number
---@field inx number
---@field type number
---@field seqno number
---@field serverid number


---@class SC_ReqGvgPointScoreInfo
---@field rid number
---@field inx number
---@field seqno number
---@field serverid number


---@class SC_ReqJoinBattle
---@field rid number
---@field seqno number
---@field serverid number
---@field battleid number
---@field addCoin number


---@class SC_ReqKickSelfRoom
---@field rid number
---@field kickrid number
---@field serverid number
---@field seqno number


---@class SC_ReqMatch
---@field rid number
---@field carid number
---@field serverid number
---@field seqno number
---@field trackid number
---@field scenesid number
---@field test number
---@field race SC_RaceInfo


---@class SC_ReqPVP
---@field rid number
---@field race SC_RaceInfo
---@field serverid number
---@field seqno number
---@field beginner number
---@field trackid number
---@field scenesid number


---@class SC_ReqPVPAccept
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqPVPCancle
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqQuitSelfRoom
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqRank
---@field rid number
---@field ranktype number


---@class SC_ReqRankCar
---@field rid number


---@class SC_ReqReadySelfRoom
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqReleaseSelfRoom
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqSearchBattle
---@field rid number
---@field seqno number
---@field serverid number
---@field battleid number


---@class SC_ReqSearchSelf
---@field rid number
---@field roomid number
---@field serverid number
---@field seqno number


---@class SC_ReqSeasonInfo
---@field paynum number
---@field seasonid number
---@field score number
---@field firstRacers table<number,SC_NewRaceInfo>
---@field maxnum number
---@field nonrltrackids table<number,string>
---@field scenceid number
---@field goodtimes table<number,string>
---@field btime number
---@field testnum number
---@field currlnum number
---@field firstRLRacer SC_RaceInfo
---@field rid number
---@field maxpaynum number
---@field curnum number
---@field rltrackids table<number,string>
---@field trackid number
---@field goodtracks table<number,string>
---@field firstRacer SC_RaceInfo
---@field etime number
---@field maxtest number
---@field continuewin number


---@class SC_ReqSelfCancle
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqSelfRoomList
---@field rid number
---@field serverid number
---@field seqno number
---@field tracktype number


---@class SC_ReqSelfStart
---@field rid number
---@field serverid number
---@field seqno number


---@class SC_ReqWatchSelfRoom
---@field rid number
---@field roomid number
---@field pwd string
---@field serverid number
---@field seqno number


---@class SC_RetAccept
---@field rid number
---@field accetprid number
---@field seqno number


---@class SC_RetAlterCar
---@field rid number
---@field alterrid number
---@field car SC_UserCar
---@field seqno number


---@class SC_RetAlterTrack
---@field rid number
---@field trackid number
---@field seqno number


---@class SC_RetAlterUser
---@field rid number
---@field headicon number
---@field iconframe number
---@field sign string
---@field rolename string
---@field props SC_Consume


---@class SC_RetBattle
---@field rid number
---@field battles table<number,SC_BattleInfo>
---@field records table<number,SC_BattleRecord>
---@field fightnum number
---@field maxfightnum number
---@field consumelist table<number,SC_Consume>


---@class SC_RetBattleAgree
---@field rid number
---@field battleid number


---@class SC_RetBattleDetail
---@field rid number
---@field seqno number
---@field battles table<number,SC_BattleInfo>
---@field records table<number,SC_BattleRecord>


---@class SC_RetBattleList
---@field rid number
---@field battles table<number,SC_BattleInfo>
---@field seqno number
---@field createflag number


---@class SC_RetBattleRank
---@field rid number
---@field rankid number
---@field score number
---@field rankjson string
---@field seqno number


---@class SC_RetBattleRecord
---@field start SC_RetBeginBattle
---@field lookrid number


---@class SC_RetBeginBattle
---@field rid number
---@field starttime number
---@field curnum number
---@field battleid number
---@field scenceid number
---@field trackinfo SC_UserTrack
---@field racers table<number,SC_BattleRaceInfo>
---@field trackid number


---@class SC_RetCancle
---@field rid number
---@field seqno number


---@class SC_RetEnterSelfRoom
---@field rid number
---@field roomid number
---@field trackid number
---@field groundid number
---@field createid number
---@field racer table<number,SC_SelfRaceInfo>
---@field enterRid number
---@field roomname string
---@field seqno number
---@field selftrack SC_UserTrack
---@field pwd string
---@field tracktype number
---@field randomtype number
---@field s1 number
---@field s2 number


---@class SC_RetFifaInfo
---@field seasonid number
---@field rid number
---@field btime number
---@field etime number
---@field championtimie number
---@field champion string
---@field awardids table<number,number>
---@field matchstr table<number,string>
---@field consume SC_Consume
---@field basematchs table<number,string>
---@field curdown SC_SomeDown
---@field championodds string
---@field championaward number


---@class SC_RetFinishBattle
---@field rid number
---@field curnum number
---@field maxnum number
---@field battleid number


---@class SC_RetFinishSelf
---@field rid number
---@field seqno number


---@class SC_RetGuildInfo
---@field rid number
---@field infos string
---@field seqno number


---@class SC_RetGuildPVEBegin
---@field rid number
---@field starttime number
---@field starts table<number,SC_RetGuildPVEStart>
---@field curlevel number


---@class SC_RetGuildPVEFinish
---@field rid number
---@field scores number
---@field bat number


---@class SC_RetGuildPVEStart
---@field rid number
---@field starttime number
---@field cars SC_UserCar
---@field runflag number
---@field sceneid number
---@field trackid number
---@field scores number


---@class SC_RetGuildPersonPointAward
---@field rid number
---@field guildaward string
---@field guildpersonaward string
---@field downlist table<number,SC_SomeDown>
---@field curExp number


---@class SC_RetGuildPointAward
---@field rid number
---@field guildaward string
---@field guildpersonaward string
---@field downlist table<number,SC_SomeDown>
---@field curExp number


---@class SC_RetGvgPointInfo
---@field guildname string
---@field curnum number
---@field guildscore string
---@field fguildname string
---@field open number
---@field fguildscore string
---@field etime number
---@field canjoin number
---@field cetime number
---@field score number
---@field seasonid number
---@field guildid string
---@field rid number
---@field guildicon string
---@field trackid number
---@field fguildid string
---@field status number
---@field fguildicon string
---@field btime number
---@field inx number
---@field cbtime number
---@field scenceid number
---@field fasttime number
---@field maxnum number


---@class SC_RetGvgPointJoin
---@field rid number


---@class SC_RetGvgPointScoreInfo
---@field rid number
---@field guildids table<number,number>
---@field scores table<number,number>
---@field seqno number


---@class SC_RetGvgPointStart
---@field rid number
---@field round number
---@field starttime number
---@field curtime number
---@field sceneid number
---@field trackid number
---@field race table<number,SC_RaceInfo>


---@class SC_RetJcup
---@field lspeed1 string
---@field lspeed3 string
---@field bjoin number
---@field carshell string
---@field btime number
---@field jcupid number
---@field trackid number
---@field cars table<number,SC_UserCar>
---@field speed1 string
---@field speed3 string
---@field rid number
---@field lspeed2 string
---@field join number
---@field carplans string
---@field ejoin number
---@field lcarshell string
---@field etime number
---@field scenceid number
---@field firstRacer SC_RaceInfo
---@field usedcars table<number,number>
---@field speed2 string


---@class SC_RetJcupJoin
---@field rid number
---@field join number


---@class SC_RetJoinBattle
---@field rid number
---@field consumelist table<number,SC_Consume>
---@field records table<number,SC_BattleRecord>
---@field addcoin number


---@class SC_RetKickSelfRoom
---@field rid number
---@field kickrid number
---@field serverid number
---@field seqno number


---@class SC_RetKillerInfo
---@field seasonid number
---@field status number
---@field needext number
---@field btime number
---@field awards string
---@field cbtime number
---@field score string
---@field cars table<number,SC_UserCar>
---@field scences string
---@field statustype number
---@field fail number
---@field rid number
---@field startext number
---@field open number
---@field bantracks table<number,number>
---@field etime number
---@field overext number
---@field cetime number
---@field joined number
---@field trackids string
---@field matchs table<number,SC_MatchInfo>
---@field carids string


---@class SC_RetMatch
---@field rid number
---@field seqno number


---@class SC_RetMatchSucc
---@field rid number
---@field roomid number
---@field race table<number,SC_RaceInfo>
---@field sureTime number
---@field sceneid number
---@field trackid number


---@class SC_RetPVP
---@field rid number
---@field seqno number


---@class SC_RetPVPAccept
---@field rid number
---@field accetprid number
---@field seqno number


---@class SC_RetPVPCancle
---@field rid number
---@field seqno number


---@class SC_RetPVPMatchSucc
---@field rid number
---@field roomid number
---@field race table<number,SC_RaceInfo>
---@field sureTime number
---@field sceneid number
---@field trackid number


---@class SC_RetPVPRecord
---@field start SC_RetPVPStart
---@field lookrid number


---@class SC_RetPVPRelease
---@field rid number


---@class SC_RetPVPStart
---@field rid number
---@field roomid number
---@field starttime number
---@field testrace number
---@field sceneid number
---@field trackid number
---@field race table<number,SC_RaceInfo>
---@field curtime number
---@field protect number
---@field ver string
---@field selectpos number
---@field consume SC_Consume
---@field paynum number
---@field pay number
---@field newracetype number


---@class SC_RetQuitSelfRoom
---@field rid number
---@field quitrid number
---@field seqno number
---@field errorcode number


---@class SC_RetRaceRecord
---@field start SC_RetStart
---@field lookrid number
---@field starts SC_RetStarts


---@class SC_RetRank
---@field rid number
---@field ranktype number
---@field rankid number
---@field score number
---@field rankjson string
---@field seasonid number
---@field guildInfo SC_UserGuild
---@field rankgroup number
---@field myrankgroup number
---@field lookgroup number
---@field point number
---@field curtrackid string
---@field trackids table<number,string>


---@class SC_RetRankCar
---@field rid number
---@field car SC_UserCar


---@class SC_RetReadySelfRoom
---@field rid number
---@field readyrid number
---@field seqno number


---@class SC_RetReleaseSelfRoom
---@field rid number
---@field seqno number


---@class SC_RetSearchBattle
---@field rid number
---@field seqno number
---@field battles table<number,SC_BattleInfo>
---@field records table<number,SC_BattleRecord>


---@class SC_RetSearchSelf
---@field rid number
---@field trackid number
---@field selfroom SC_SelfRoomInfo
---@field seqno number


---@class SC_RetSelfCancle
---@field rid number
---@field canclerid number
---@field seqno number


---@class SC_RetSelfRoomList
---@field rid number
---@field roomlist table<number,SC_SelfRoomInfo>
---@field seqno number


---@class SC_RetSelfStart
---@field rid number
---@field readyrid number
---@field seqno number
---@field starttime number


---@class SC_RetStart
---@field rid number
---@field roomid number
---@field starttime number
---@field testrace number
---@field sceneid number
---@field trackid number
---@field race table<number,SC_RaceInfo>
---@field curtime number
---@field carid number
---@field ver string


---@class SC_RetStarts
---@field rid number
---@field starts table<number,SC_RetStart>
---@field ver string


---@class SC_RetTopInfo
---@field rid number
---@field curnum number
---@field trackid number
---@field maxnum number
---@field status number
---@field open number
---@field btime number
---@field etime number
---@field cbtime number
---@field cetime number
---@field scenceid number
---@field firstRacer SC_RaceInfo
---@field score string
---@field canjoin number
---@field seasonid number


---@class SC_RetTopRecord
---@field start SC_RetTopStart
---@field lookrid number
---@field type string


---@class SC_RetTopStart
---@field rid number
---@field starttime number
---@field sceneid number
---@field trackid number
---@field race table<number,SC_RaceInfo>
---@field curtime number
---@field round number
---@field ver string


---@class SC_RetXcup
---@field lspeed1 string
---@field lspeed3 string
---@field bjoin number
---@field carshell string
---@field btime number
---@field xcupid number
---@field trackids string
---@field cars table<number,SC_UserCar>
---@field speed1 string
---@field speed3 string
---@field rid number
---@field lspeed2 string
---@field join number
---@field carplans string
---@field ejoin number
---@field lcarshell string
---@field etime number
---@field scenceids string
---@field firstRacer SC_RaceInfo
---@field usedcars table<number,number>
---@field speed2 string


---@class SC_RetXcupJoin
---@field rid number
---@field join number


---@class SC_RoomError
---@field rid number
---@field errorcode number
---@field seqno number


---@class SC_ScienceList
---@field rid number
---@field mySciences table<number,SC_UserScience>


---@class SC_SeasonAward
---@field from number
---@field to number
---@field awardids string
---@field awardnums string


---@class SC_SeasonAwards
---@field rid number
---@field awards table<number,SC_SeasonAward>
---@field awardtype number


---@class SC_SeasonError
---@field rid number
---@field errorcode number
---@field seqno number


---@class SC_SeasonRanks
---@field seasonid number
---@field rankinfo string
---@field trackid number
---@field scenceid number


---@class SC_SelfError
---@field rid number
---@field errorcode number
---@field seqno number


---@class SC_SelfRaceInfo
---@field rid number
---@field rolename string
---@field headicon number
---@field iconframe number
---@field curlevel number
---@field car SC_UserCar
---@field position number
---@field score number
---@field ready number
---@field titleback number
---@field titlecup string


---@class SC_SelfRoomInfo
---@field roomid number
---@field trackid number
---@field groundid number
---@field pwd string
---@field roomname string
---@field tracktype number
---@field curnum number
---@field createracer SC_SelfRaceInfo
---@field selftrack SC_UserTrack
---@field randomtype number
---@field watchnum number


---@class SC_ShopInfo
---@field rid number
---@field shopid number
---@field freshnum number
---@field freshtime number
---@field shoplist table<number,SC_ShopItem>
---@field payMoney SC_Consume
---@field freshcoin number
---@field freshpay number
---@field curGuildLev number
---@field btime number
---@field etime number


---@class SC_ShopItem
---@field propsid number
---@field propsytpe number
---@field coinid number
---@field price number
---@field discount number
---@field curnum number
---@field limitnum number
---@field grid number
---@field cond number
---@field condval number
---@field tag number


---@class SC_SomeDown
---@field rid number
---@field downProps table<number,SC_UserProp>
---@field downParts table<number,SC_UserPart>
---@field downExp SC_PlayerUpLevel
---@field toMail number
---@field partViewId table<number,number>
---@field downFurniture table<number,SC_Furniture>
---@field downHeadFrame table<number,SC_UserHead>
---@field downDrivers table<number,SC_UserDriver>
---@field alivePartId table<number,number>
---@field aliveCupId table<number,number>


---@class SC_SpecialPart
---@field partId number
---@field unlockflag number


---@class SC_StarUpPart
---@field rid number
---@field partInx number
---@field curConsumes table<number,SC_Consume>
---@field curStar number


---@class SC_SupportList
---@field rid number
---@field endTime number
---@field curSupports table<number,SC_RebackSupport>
---@field actId number


---@class SC_SupportPart
---@field rid number
---@field curSupports SC_RebackSupport
---@field downPart SC_UserPart
---@field actId number


---@class SC_SvrInfo
---@field serverId number
---@field curLoad number
---@field svrType number
---@field curStatus number


---@class SC_SysPubInfo
---@field success number
---@field infos table<number,SC_pubinfo>


---@class SC_TalkInfo
---@field rid number
---@field sendName string
---@field infoType number
---@field content string
---@field targId number
---@field headicon number
---@field iconframe number
---@field curlevel number
---@field score number
---@field logouttime number
---@field roomid number
---@field contentjson string
---@field subtype string
---@field index string
---@field sendtime number


---@class SC_TaskActiveGift
---@field activetype number
---@field activeval number
---@field ifgift number


---@class SC_TaskFinish
---@field rid number
---@field tradeseq number
---@field ifgift number
---@field downlist SC_SomeDown


---@class SC_TaskGift
---@field rid number
---@field missionId table<number,number>
---@field downlist table<number,SC_SomeDown>
---@field daytaskval number
---@field day7taskval number
---@field nextMission table<number,SC_UserTask>
---@field curToken SC_ActToken
---@field rebacktaskval number
---@field curGuildExp number
---@field actTaskVal number
---@field curTimeToken SC_ActTimeToken
---@field curTradeSeq number


---@class SC_TaskList
---@field rid number
---@field curTasks table<number,SC_UserTask>
---@field daytaskval number
---@field day7taskval number
---@field activeGifts table<number,SC_TaskActiveGift>
---@field day7Endtime number
---@field rebackTaskval number
---@field rebackactiveGifts table<number,SC_TaskActiveGift>
---@field actMissionVal number
---@field actMissionGifts table<number,SC_TaskActiveGift>
---@field curTradeMission table<number,SC_TradeMission>
---@field curTradeSeq number


---@class SC_TestCharge
---@field rid number
---@field mySomeDown SC_SomeDown
---@field testGiftFlag number


---@class SC_TopFight
---@field rid number
---@field rolename string
---@field iconframe string
---@field headicon string
---@field time number
---@field frid number
---@field frolename string
---@field ficonframe string
---@field fheadicon string
---@field ftime number
---@field round number
---@field winlost number


---@class SC_TopFightRank
---@field seasonid number
---@field list32 table<number,SC_TopFight>
---@field list16 table<number,SC_TopFight>
---@field list8 table<number,SC_TopFight>
---@field list4 table<number,SC_TopFight>
---@field list2 table<number,SC_TopFight>


---@class SC_TopFightRanks
---@field ranks SC_TopFightRank
---@field agreerid string
---@field ticks table<number,number>
---@field rids table<number,number>


---@class SC_TopFinish
---@field rid number
---@field curnum number
---@field errcode string


---@class SC_TradeMission
---@field tradeseq number
---@field ifgift number
---@field curval number
---@field sumval number


---@class SC_TvInfo
---@field content string
---@field lev number
---@field broadnum number
---@field type number
---@field partid number
---@field tvid number
---@field rolename string


---@class SC_UnloadPart
---@field rid number
---@field curCar SC_UserCar
---@field unloadParts table<number,number>
---@field deleteParts table<number,number>


---@class SC_UnlockSpecial
---@field rid number
---@field partId number
---@field myConsume SC_Consume


---@class SC_UpLevelBuilder
---@field rid number
---@field curLab SC_UserLab
---@field myCousume SC_Consume


---@class SC_UseSpeaker
---@field props SC_Consume
---@field speakertime number


---@class SC_UserActGrowup
---@field rid number
---@field curActGrowup table<number,SC_ActGrowup>


---@class SC_UserActSign
---@field rid number
---@field myActSignInfo SC_UserActSignInfo
---@field mySomeDown table<number,SC_SomeDown>
---@field curConsume SC_Consume


---@class SC_UserActSignInfo
---@field actId number
---@field beginTime number
---@field endTime number
---@field curDay number
---@field signFlag table<number,number>


---@class SC_UserActive
---@field acttype number
---@field score number
---@field awardid number
---@field btime number
---@field endtime number
---@field awards table<number,number>
---@field actShop table<number,SC_ShopItem>
---@field myGift table<number,SC_CapyActGift>


---@class SC_UserActiveInfo
---@field rid number
---@field ua table<number,SC_UserActive>
---@field downProp table<number,SC_SomeDown>


---@class SC_UserAdList
---@field rid number
---@field myAdInfo table<number,SC_MyAd>
---@field adAward table<number,SC_SomeDown>


---@class SC_UserAlterShell
---@field curPart SC_UserPart
---@field consumeProp SC_Consume
---@field carAttrs table<number,SC_Attr>


---@class SC_UserAnswer
---@field rid number
---@field questions string
---@field finish number
---@field downlist SC_SomeDown


---@class SC_UserBackSign
---@field rid number
---@field begintime number
---@field signGift table<number,number>
---@field nowday number
---@field ifbuy number


---@class SC_UserBearCard
---@field rid number
---@field cardId number
---@field cardType number
---@field cardLv number
---@field isNew number


---@class SC_UserBearInfo
---@field rid number
---@field srvId number
---@field finishNum number
---@field fasTest number
---@field myBearMatch table<number,SC_UserBearMatch>
---@field myBearCard table<number,SC_UserBearCard>
---@field mySomeDown table<number,SC_SomeDown>
---@field curConsume SC_Consume


---@class SC_UserBearMatch
---@field rid number
---@field matchId number
---@field matchType number
---@field curPeriod number
---@field matchStart number
---@field linkid number
---@field adId string
---@field copyAward string
---@field adStart number
---@field dayNum number


---@class SC_UserBindInfo
---@field rid number
---@field curBind SC_UserRidInfo
---@field bindList table<number,SC_UserRidInfo>
---@field expTime number


---@class SC_UserBox
---@field boxLoc number
---@field boxId number
---@field openTime number
---@field unlockFlag number
---@field expTime number
---@field boxSum number


---@class SC_UserBoxCancle
---@field rid number
---@field cancleBox SC_UserBox
---@field cancelDown table<number,SC_SomeDown>


---@class SC_UserBoxGift
---@field rid number
---@field curBox SC_UserBox
---@field boxDown table<number,SC_SomeDown>
---@field curConsume table<number,SC_Consume>


---@class SC_UserBoxList
---@field rid number
---@field myBoxs table<number,SC_UserBox>


---@class SC_UserBoxOpen
---@field rid number
---@field openBox SC_UserBox
---@field curConsume table<number,SC_Consume>


---@class SC_UserBoxUnlock
---@field rid number
---@field unlockBox SC_UserBox
---@field curConsume table<number,SC_Consume>


---@class SC_UserCar
---@field rid number
---@field planseq number
---@field unlockflag number
---@field carplanname string
---@field carDetails table<number,SC_UserCarDetail>
---@field carAttrs table<number,SC_Attr>
---@field ifuse number
---@field positon number
---@field loc number
---@field verifyAttr table<number,number>


---@class SC_UserCarDetail
---@field partseq number
---@field partInx number
---@field partId number
---@field unlockflag number
---@field stickerid number
---@field colorid number
---@field shellhole table<number,number>
---@field partage number
---@field canUsed number
---@field copyPartId number
---@field copystickerid number
---@field copycolorid number
---@field copyshellhole table<number,number>


---@class SC_UserChapter
---@field rid number
---@field chapters table<number,SC_ChapterInfo>


---@class SC_UserCollect
---@field partid number
---@field alive number


---@class SC_UserCollectGift
---@field rid number
---@field mySomeDown SC_SomeDown
---@field collectLevel number
---@field collectVal number
---@field collectGift number


---@class SC_UserCollects
---@field rid number
---@field myCollects table<number,SC_UserCollect>
---@field collectLevel number
---@field collectVal number
---@field collectGift number


---@class SC_UserCompose
---@field rid number
---@field breakFlag number
---@field curConsumes SC_ConsumGroup
---@field downlist SC_SomeDown
---@field curLab SC_UserLab
---@field counsumPartInx table<number,number>


---@class SC_UserCopy
---@field rid number
---@field chapterid number
---@field copys table<number,SC_CopyInfo>


---@class SC_UserCopyPart
---@field curPart SC_UserPart
---@field consumeProp SC_ConsumGroup


---@class SC_UserCupCollect
---@field cupid number
---@field alive number
---@field giftflag number


---@class SC_UserCupCollectGift
---@field rid number
---@field mySomeDown SC_SomeDown
---@field curCup SC_UserCupCollect


---@class SC_UserCupCollects
---@field rid number
---@field myCollects table<number,SC_UserCupCollect>


---@class SC_UserDirect
---@field rid number
---@field propid number
---@field curnum number
---@field pay table<number,number>
---@field coinid number
---@field ifalert number


---@class SC_UserDriver


---@class SC_UserFairInfo
---@field curnum number
---@field planseq number
---@field racestyle string
---@field matchendTime number
---@field myCars table<number,SC_UserCar>
---@field consumelist table<number,SC_Consume>
---@field fairParts table<number,SC_UserPart>
---@field rank3list table<number,SC_rank3>
---@field agree number
---@field awardid number
---@field rid number
---@field raceType string
---@field matchId number
---@field uiModuleID string
---@field matchFinishTime number
---@field needjoin number
---@field trackid number
---@field scenceid number
---@field diamondpool number
---@field matchbeginTime number


---@class SC_UserFirstGift
---@field rid number
---@field actType number
---@field Actfirstcharge number
---@field downlist SC_SomeDown


---@class SC_UserFriends
---@field rid number
---@field friendrid number
---@field friendlist table<number,SC_FriendInfo>
---@field downlist table<number,SC_SomeDown>
---@field sums number
---@field assert number
---@field sends table<number,string>
---@field receives table<number,string>
---@field gets table<number,string>
---@field alterrids table<number,number>


---@class SC_UserGame
---@field rid number
---@field gameaward number
---@field downlist SC_SomeDown


---@class SC_UserGuild
---@field myguild SC_GuildInfo
---@field guildlist table<number,SC_GuildInfo>
---@field memberlist table<number,SC_MemberInfo>
---@field applylist table<number,SC_MemberInfo>
---@field success string
---@field consumelist table<number,SC_Consume>
---@field downlist table<number,SC_SomeDown>


---@class SC_UserHead
---@field rid number
---@field headid number
---@field unlockflag number


---@class SC_UserInfoPacket
---@field friendgiftnum number
---@field collectLevel number
---@field rolename string
---@field firstlogin number
---@field background number
---@field curexp number
---@field daySign number
---@field guildid number
---@field guildsign number
---@field levelawards table<number,number>
---@field serverid number
---@field seasonscore number
---@field exchgold number
---@field curlevel number
---@field daygift number
---@field curcopyid number
---@field guildname string
---@field continueday number
---@field weekHire number
---@field uid string
---@field tradeNo string
---@field collectGift number
---@field iconframe number
---@field offlinedays number
---@field curBind SC_UserRidInfo
---@field staminatime number
---@field sevenDayTask number
---@field loginday number
---@field weekBorrow number
---@field rid number
---@field friendrecvnum number
---@field collectVal number
---@field headicon number
---@field rebackfalg number
---@field cups string
---@field stamina number
---@field montySign number
---@field sign string
---@field powergift table<number,string>


---@class SC_UserInherit
---@field partinx number
---@field inheritid number
---@field attrId table<number,number>
---@field powerlev number
---@field curexp number
---@field attrVal table<number,number>
---@field reformval table<number,number>
---@field maxexp number


---@class SC_UserKey
---@field rid number
---@field openCar SC_UserCar
---@field unlockCar number
---@field curConsume SC_Consume
---@field downlist SC_SomeDown


---@class SC_UserLab
---@field rid number
---@field curbuilderLev number
---@field curExp number
---@field uplevExp number


---@class SC_UserMail
---@field rid number
---@field mails table<number,SC_MailInfo>


---@class SC_UserMonthSign
---@field rid number
---@field mySignInfo table<number,SC_UserSignInfo>
---@field monthNum number
---@field monthCardExp number


---@class SC_UserMonthSignAct
---@field rid number
---@field curSignInfo SC_UserSignInfo
---@field signType number
---@field mySomeDown table<number,SC_SomeDown>
---@field curConsume SC_Consume
---@field monthSign number


---@class SC_UserPart
---@field downtype number
---@field partinx number
---@field ifuse number
---@field curstar number
---@field copypartid number
---@field stickerid number
---@field curInherit table<number,SC_UserInherit>
---@field shellhole table<number,number>
---@field copystickerid number
---@field partAttrs table<number,SC_Attr>
---@field copyshellhole table<number,number>
---@field lockstatus number
---@field partFieldAttrs table<number,SC_Attr>
---@field source number
---@field rid number
---@field exptime number
---@field partid number
---@field hirenum number
---@field curlevel number
---@field skillIds table<number,number>
---@field colorid number
---@field inheritNum number
---@field planseq number
---@field copycolorid number
---@field curEntry table<number,SC_UserPartEntry>
---@field breakflag number
---@field partage number


---@class SC_UserPartAge
---@field rid number
---@field agePart SC_UserPart
---@field carAttrs table<number,SC_Attr>
---@field downlist SC_SomeDown
---@field counsumPartInx table<number,number>


---@class SC_UserPartEntry
---@field partinx number
---@field entryid number
---@field quality number
---@field powerlev number
---@field seq number


---@class SC_UserPartReturn
---@field rid number
---@field returnPart SC_UserPart
---@field downlist SC_SomeDown
---@field curConsumes SC_ConsumGroup


---@class SC_UserPassFoundInfo
---@field rid number
---@field myPassFound table<number,SC_MyPassFound>
---@field downProp table<number,SC_SomeDown>
---@field consumePay SC_Consume


---@class SC_UserPeriodGift
---@field rid number
---@field itemid number
---@field giftstatus number
---@field downlist SC_SomeDown
---@field curActPeriod SC_ActPeriod


---@class SC_UserPowerGift
---@field rid number
---@field pwrseq number
---@field stamina number
---@field staminatime number
---@field myConsume SC_Consume


---@class SC_UserProp
---@field rid number
---@field propid number
---@field propnum number
---@field alterNum number
---@field expTime number


---@class SC_UserQuestList
---@field rid number
---@field questions string
---@field finish number
---@field downlist SC_SomeDown


---@class SC_UserReBackPow
---@field rid number
---@field rebackFlag number
---@field curtime number
---@field stamina number
---@field staminatime number
---@field drugCousume SC_Consume


---@class SC_UserRecruit
---@field rid number
---@field myRecruits table<number,SC_RecruitInfo>
---@field mySomeDown table<number,SC_SomeDown>
---@field curConsume SC_Consume
---@field buyItems table<number,SC_UserTimeBuy>


---@class SC_UserRecruitCountGift
---@field rid number
---@field awardSeq number
---@field mySomeDown table<number,SC_SomeDown>


---@class SC_UserRecruitCounts
---@field rid number
---@field awardCount table<number,number>
---@field awardFlag table<number,number>
---@field curNum number
---@field awardList table<number,SC_Awards>


---@class SC_UserRidInfo
---@field wdRid number
---@field roleName string
---@field headIcon number
---@field iconFrame number
---@field serverId number


---@class SC_UserScience
---@field rid number
---@field scienceLev number
---@field unlockFlag number
---@field ownTechs table<number,SC_UserTech>


---@class SC_UserShare
---@field rid number
---@field recruitid number
---@field sharestatus number
---@field downlist SC_SomeDown


---@class SC_UserShiftInfo
---@field rid number
---@field uid string
---@field srid number


---@class SC_UserSign
---@field rid number
---@field mySignInfo table<number,SC_UserSignInfo>
---@field mySomeDown table<number,SC_SomeDown>
---@field curConsume SC_Consume
---@field daySign number
---@field monthSign number


---@class SC_UserSignInfo
---@field dayNum number
---@field curStatus number
---@field ifGet number
---@field ifRepair number
---@field ifbat number


---@class SC_UserSpecialParts
---@field rid number
---@field partList table<number,SC_SpecialPart>


---@class SC_UserTask
---@field rid number
---@field missionid number
---@field condtionid number
---@field curval number
---@field curstatus number
---@field tasktype number
---@field dayno number
---@field actId number
---@field tradeseq number


---@class SC_UserTech
---@field rid number
---@field techId number
---@field curStatus number
---@field startTime number
---@field ownTracks table<number,SC_procTrack>


---@class SC_UserTimeBuy
---@field rid number
---@field itemid number
---@field exptime number
---@field ifbuy number
---@field begintime number


---@class SC_UserTrack
---@field trackid number
---@field rid number
---@field trackname string
---@field tracknum number
---@field angle number
---@field offsetx number
---@field offsety number
---@field offsetz number
---@field canrun number
---@field myTrackItems table<number,number>
---@field seqNo number
---@field tradepay number
---@field createtime number


---@class SC_UserTrackList
---@field rid number
---@field myTrack table<number,SC_UserTrack>


---@class SC_UserVideoAD
---@field rid number
---@field dayVideoGifts table<number,SC_DayVideoGift>
---@field countNum number
---@field countGift table<number,number>


---@class SC_VideoCountGift
---@field rid number
---@field countGift table<number,number>
---@field mySomeDown table<number,SC_SomeDown>


---@class SC_VideoLuckTable
---@field rid number
---@field watchNum number
---@field maxWatch number
---@field canUseNum number
---@field hitSeq table<number,number>
---@field mySomeDown table<number,SC_SomeDown>


---@class SC_VideoPlay
---@field rid number
---@field videoId number


---@class SC_WatchFighter
---@field rid number
---@field watchloc number
---@field payMoney SC_Consume


---@class SC_WriteLogInfo
---@field serverno string
---@field loginfo string


---@class SC_actionGuild
---@field rid string
---@field fresh string
---@field guildid string


---@class SC_buyActShop
---@field rid number
---@field shopid number
---@field shoplist table<number,SC_ShopItem>
---@field payMoney SC_Consume
---@field downsome SC_SomeDown
---@field exchid number
---@field exchnum number


---@class SC_buyDirect
---@field rid number
---@field buynum number
---@field payMoney SC_Consume
---@field downsome SC_SomeDown
---@field buyPropId number
---@field coinid number
---@field ifalert number


---@class SC_buyShop
---@field rid number
---@field shopid number
---@field curItem SC_ShopItem
---@field payMoney SC_Consume
---@field downsome SC_SomeDown


---@class SC_downGold
---@field pay number
---@field downgold number
---@field batval number


---@class SC_fightInfo
---@field fightid number
---@field btime number
---@field etime number
---@field seasonid number


---@class SC_finishTrack
---@field rid number
---@field curTrack SC_procTrack
---@field downlist SC_SomeDown


---@class SC_procTrack
---@field rid number
---@field trackId number
---@field startTime number
---@field procnum number
---@field curConsumes SC_Consume


---@class SC_pubinfo
---@field pubid number
---@field title string
---@field content string
---@field pubtag string
---@field sender string
---@field createtime number
---@field endtime number


---@class SC_rank3
---@field rid number
---@field rolename string
---@field headicon string
---@field iconframe string
---@field rankid string
---@field score string


---@class SC_reloadCharge
---@field rid number
---@field cporderid string
---@field markcode string


---@class SC_saveUserHome
---@field rid number


---@class SC_sellGoods
---@field rid number
---@field pay SC_Consume
---@field downsome SC_SomeDown


---@class SC_svrList
---@field svrcode number
---@field svrname string
---@field rid number
---@field ipadd string
---@field svrport number
---@field recommend number
---@field runstat string
---@field domain string


---@class SC_wayinfo
---@field copyid number
---@field num number
