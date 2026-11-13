---@class ClubSubsystem
ClubSubsystem = class("ClubSubsystem")

function ClubSubsystem:initialize(...)
    --{{{消息注册

    NetResponseEventManager:Get():AddListener(MsgID.RECOMMEND_GUILD_S2C_RES, self, self.RecvMsg_GetAllClub)
    ------请求推荐俱乐部列表
    NetResponseEventManager:Get():AddListener(MsgID.CREATE_GUILD_S2C_RES, self, self.RecvMsg_GuildCreate)
    ------请求俱乐部创建
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_MEMBER_LIST_S2C_RES, self, self.RecvMsg_GuildMemberList)
    ------请求俱乐部成员列表
    --NetResponseEventManager:Get():AddListener(NewMsgID.GET_GUILD_APPLY_LIST_S2C_RES, self, self.RecvMsg_GetSelfApplyClubList)
    ------获得自己的申请列表
    NetResponseEventManager:Get():AddListener(MsgID.GET_GUILD_APPLY_LIST_S2C_RES, self, self.RecvMsg_GuildApplyList)
    ------获得自己的申请列表
    NetResponseEventManager:Get():AddListener(MsgID.JOIN_GUILD_S2C_RES, self, self.RecvMsg_GuildJoin)
    ------请求俱乐部申请加入
    NetResponseEventManager:Get():AddListener(MsgID.GET_GUILD_INFO_S2C_RES, self, self.RecvMsg_GuildInfo)
    ------获取俱乐部详细信息
    NetResponseEventManager:Get():AddListener(MsgID.SEARCH_GUILD_S2C_RES, self, self.RecvMsg_GuildSearchGuilds)
    ------搜索俱乐部
    --NetResponseEventManager:Get():AddListener(MsgID.RANK_GUILD_S2C_RES, self, self.RecvMsg_RankGuild)
    ------俱乐部排行列表

    NetResponseEventManager:Get():AddListener(MsgID.SIGN_GUILD_S2C_RES, self, self.RecvMsg_RankSign)
    ------俱乐部签到

    --
    ----------------------------以上是游戏服，以下是工会服----------------------------
    --
    NetResponseEventManager:Get():AddListener(MsgID.CHANGE_POS_GUILD_S2C_RES, self, self.RecvMsg_GuildChangePosition)
    ------请求更改玩家职位
   NetResponseEventManager:Get():AddListener(MsgID.SEND_GUILD_S2C_RES, self, self.RecvMsg_GuildChangePresident)
    ------请求转让会长
    NetResponseEventManager:Get():AddListener(MsgID.KICK_GUILD_S2C_RES, self, self.RecvMsg_GuildKickMember)
    ------请求把玩家踢出俱乐部
    NetResponseEventManager:Get():AddListener(MsgID.EXIT_GUILD_S2C_RES, self, self.RecvMsg_GuildExit)
    ------请求退出俱乐部
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_APPLY_LIST_S2C_RES, self, self.RecvMsg_GuildApplyList)
    ------请求申请列表返回,别人谁申请了自己的俱乐部
    --NetResponseEventManager:Get():AddListener(MsgID.CHANGE_VERIFY_S2C_RES, self, self.RecvMsg_GuildChangeJoinTypeRes)
    ------拉取玩家欢迎词
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_LOGS_S2C_RES, self, self.RecvMsg_GuildLogs)
    ------拉取工会日志
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_BROADCAST_MAIL_S2C_RES, self, self.RecvMsg_GuildBroadcastMail)
    ------发送全员邮件
    --
    --NetResponseEventManager:Get():AddListener(MsgID.BE_KICK_GUILD_S2C_NOTIFY, self, self.RecvMsg_BeKick)
    ------自己被踢出了俱乐部
    NetResponseEventManager:Get():AddListener(MsgID.DONATE_GUILD_S2C_RES, self, self.RecvMsg_GuildDonation)
    ------俱乐部捐赠
    --NetResponseEventManager:Get():AddListener(MsgID.GUILD_GET_DONATION_INFO_S2C_RES, self, self.RecvMsg_GetDonationInfoRes)
    ------俱乐部捐赠信息
    NetResponseEventManager:Get():AddListener(MsgID.ACTION_GUILD_S2C_RES, self, self.RecvMsg_NotifyGuildChange)
    ----玩家被审批加入俱乐部
    NetResponseEventManager:Get():AddListener(MsgID.CHANGE_GUILD_INFO_S2C_RES, self, self.RecvMsg_GuildChangeInfoRes)
    NetResponseEventManager:Get():AddListener(MsgID.CHANGE_GUILD_NAME_S2C_RES, self, self.RecvMsg_GuildChangeNameRes)
    ----更改俱乐部信息，比如加入方式，限制等级，宣言等
    NetResponseEventManager:Get():AddListener(MsgID.ACCEPT_GUILD_S2C_RES, self, self.RecvMsg_GuildAuditMember)
    NetResponseEventManager:Get():AddListener(MsgID.REFUSE_GUILD_APPLY_S2C_RES, self, self.RecvMsg_GuildAuditRefuseMember)
    ------请求处理俱乐部成员申请操作，是同意申请还是拒绝申请
    --
    ----}}}


end

--function ClubSubsystem:SendSendMsg_EnterGuild()
--    ---@type SC_Tuple1_64
--    local reqData = {
--        num = PlayerDataManager:Get():GetPlayerUID()
--    }
--    local reqBytes = assert(Dll_PB.encode("Tuple1_64", reqData))
--
--    NetManager:Get():SendGuild(MsgID.GUILD_CONNECT_GUILD_C2GUILD_REQ, reqBytes)
--end
--
--function ClubSubsystem:RecvMsg_EnterGuild(data)
--    print("进入工会服返回")
--
--    if not ClubDataManager:Get():GetFirstEnterServer() and ClubDataManager:Get():IsHadClub() then
--        ClubSubsystem:Get():SendMsg_GuildLogs()
--        ClubDataManager:Get():SetFirstEnterServer(true)
--    end
--end



--{{{以下是游戏服

-------------------------------------------------------------获取俱乐部列表
function ClubSubsystem:SendMsg_GetAllClub()
    print("给服务器发送消息，获得所有俱乐部的信息")

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })

    NetManager:Get():Send(MsgID.RECOMMEND_GUILD_C2S_REQ, reqByte)

end

function ClubSubsystem:RecvMsg_GetAllClub(data)
    print("获得俱乐部返回列表")

    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))

    if #msg.guildlist > 0 then
        ClubDataManager:Get():SetCurSelectClubId(msg.guildlist[1].guildid)
    end

    ClubDataManager:Get():InitRecommendClubData(msg)
    ClubDataManager:Get():SetClubListType(ClubListType.Recommend)
    if #msg.guildlist > 0 then
        UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubList, { ClubListType.Recommend, true })
        ClubDataManager:Get():SetServerHaveClub(true)
    else
        UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_NoClub, false)
        ClubDataManager:Get():SetServerHaveClub(false)
    end
end

-------------------------------------------------------------创建俱乐部请求
function ClubSubsystem:SendMsg_GuildCreate(guildName, declaration, joinType, limitLv, icon)
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), icon, guildName, limitLv, joinType, declaration })
    NetManager:Get():Send(MsgID.CREATE_GUILD_C2S_REQ, reqByte)
end

-------------------------------------------------------------创建俱乐部返回
function ClubSubsystem:RecvMsg_GuildCreate(data)
    print("服务器返回创建俱乐部")
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))

    print(ProtoMsgHelp.block(msg))

    PlayerDataManager:Get():SetGuildId(msg.myguild.guildid)
    PlayerDataManager:Get():SetGuildName(msg.myguild.guildname)
    --PlayerDataManager:Get():SetCurrency(CurrencyType.Diamond, msg.diamond)

    ClubDataManager:Get():SetCurSelectClubId(msg.myguild.guildid)
    ClubDataManager:Get():InitSelfClubData(msg.myguild)

    ClubDataManager:Get():SetClubListType(ClubListType.Recommend)
    ClubDataManager:Get():GetClubDataById(msg.myguild.guildid):InitMemberList(msg)

    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_InitMainChatInfo)
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"Check",false})
    UIManager:Get():CloseView()--ClubNoView
    UIManager:Get():OpenView("ClubMainMenuView", CanvasType.MainCanvas, "ClubMainMenuView")
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"Check",true})
    GlobalAd:Get():GlobalAdjust_CreateClub(msg.myguild.guildname)
    if msg.consumelist ~= nil and #msg.consumelist > 0 then
        KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.consumelist)
    end


    --创建俱乐部
    QuickTaHelper:TrackUnionEvent(1,"")
end

-------------------------------------------------------------申请加入俱乐部
---@param opt ClubApplyType
function ClubSubsystem:SendMsg_GuildJoin(id, opt)
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id })

    NetManager:Get():Send(MsgID.JOIN_GUILD_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildJoin(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    if ClubDataManager:Get():GetCurSelectClubData()  == nil  and msg.myguild ~= nil then
        ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, msg.myguild.guildid)
    else
        if msg.myguild ~= nil then
            if UIManager:Get():IsPersistentViewShow("ChatView") then
                UIManager:Get():HidePersistentView("ChatView")
            end
            PlayerDataManager:Get():SetGuildId(msg.myguild.guildid)
            PlayerDataManager:Get():SetGuildName(msg.myguild.guildname)
            --  ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, msg.joinId)
            UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_InitMainChatInfo)
            ClubDataManager:Get():InitSelfClubData(msg.myguild)
            if  ClubDataManager:Get():GetCurSelectClubData() then
                ClubDataManager:Get():GetCurSelectClubData():InitMemberList(msg)
            end
            if UIManager:Get():IsViewShow("ClubNoView") then
                UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"Check",false})
                UIManager:Get():CloseView()
            end
            if UIManager:Get():IsPersistentViewShow("ChatView") then
                UIManager:Get():HidePersistentView("ChatView")
            end
            UIManager:Get():OpenView("ClubMainMenuView", CanvasType.MainCanvas, "ClubMainMenuView")
            UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"Check",true})
            GlobalAd:Get():GlobalAdjust_JoinClub(msg.myguild.guildname)
        else
            --local tempListType = ClubDataManager:Get():GetClubListType()
            --
            --local curSelectClubData = ClubDataManager:Get():GetCurSelectClubData()
            --
            --if curSelectClubData ~= nil then
            --    --local isHadApply = curSelectClubData:GetHasApplyFor()
            --    -- ClubDataManager:Get():GetCurSelectClubData():SetHasApplyFor(not isHadApply)
            --
            --    if tempListType == ClubListType.Search then
            --        ClubDataManager:Get():SetClubListType(ClubListType.Recommend)
            --        if ClubDataManager:Get():GetCurSelectClubData() ~= nil then
            --            ClubDataManager:Get():GetCurSelectClubData():SetHasApplyFor(not isHadApply)
            --        end
            --        ClubDataManager:Get():SetClubListType(tempListType)
            --    end
            --
            --    --if not isHadApply then
            --    --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ClubHaveSendApply))
            --    --end
            --
            --    UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubList, { ClubListType.Recommend, false })
            --    UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubInfo)
            --else
            --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ClubHaveSendApply))
            --end
            local tempListType = ClubDataManager:Get():GetClubListType()
            if ClubDataManager:Get():GetCurSelectClubData() ~= nil then
                ClubDataManager:Get():GetCurSelectClubData():SetHasApplyFor(true)
            end
            --ClubDataManager:Get():GetClubDataById(tonumber(msg.success)):SetHasApplyFor(true)
            if tempListType == ClubListType.Search then
                ClubDataManager:Get():SetClubListType(ClubListType.Recommend)
                if ClubDataManager:Get():GetCurSelectClubData() ~= nil then
                    ClubDataManager:Get():GetCurSelectClubData():SetHasApplyFor(true)
                end
                ClubDataManager:Get():SetClubListType(tempListType)
            end
            UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubList, { ClubListType.Recommend, false })
            UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubInfo)
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ClubHaveSendApply))
        end
    end

   --请求加入俱乐部
    QuickTaHelper:TrackUnionEvent(2,"")
end

local GetGuildInfoCallback=nil
-------------------------------------------------------------请求俱乐部详细信息
---@param type ClubInfoType
function ClubSubsystem:SendMsg_GuildInfo(type, guildId,backFun)
    GetGuildInfoCallback=backFun
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), guildId })
    NetManager:Get():Send(MsgID.GET_GUILD_INFO_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildInfo(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    if msg.myguild then
        PlayerDataManager:Get():SetGuildId(msg.myguild.guildid)   --为了纠错使
        ClubDataManager:Get():SetCurSelectClubId(msg.myguild.guildid)
        if ClubDataManager:Get():IsHadClub() then
            --ClubDataManager:Get():GetCurSelectClubData():InitMemberList(msg)
            PlayerDataManager:Get():SetGuildName(msg.myguild.guildname)
            ClubDataManager:Get():InitSelfClubData(msg.myguild)
            ClubDataManager:Get():SetClubListType(ClubListType.Recommend)
            ClubDataManager:Get():GetCurSelectClubData():InitMemberList(msg)
            if UIManager:Get():IsViewShow("ClubNoView") then
                UIManager:Get():CloseView()
            end
            if not UIManager:Get():IsViewShow("ClubMainMenuView") then
                UIManager:Get():OpenView("ClubMainMenuView", CanvasType.MainCanvas, "ClubMainMenuView")
            end
            if RaceClub3V3Manager:Get().ReturnBattle then
                RaceClub3v3Subsystem:Get():SendMsg_GetInfo()
                RaceClub3V3Manager:Get().ReturnBattle=false
            end
            if  RaceGVGManager:Get().ReturnBattleGVG then
                RaceGVGSubsystem:Get():SendMsg_GetInfo()
                RaceGVGManager:Get().ReturnBattleGVG=false
            end
        else
            ClubDataManager:Get():GetCurSelectClubData():InitClubDetailData(msg.myguild)
            UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubInfo)
        end
    else
        --说明我被t了，或者是其他未知原因导致我没有工会了
        PlayerDataManager:Get():SetGuildId(0)
        PlayerDataManager:Get():SetGuildName("")
        if UIManager:Get():IsViewShow("ClubMainMenuView") then
            SkipModuleHelper:Get():ToMainMenuView(false)
        end
        UIManager:Get():OpenView("ClubNoView", CanvasType.MainCanvas, "ClubNoView")
    end
    if GetGuildInfoCallback then
        GetGuildInfoCallback()
        GetGuildInfoCallback=nil
    end
end
function ClubSubsystem:RecvMsg_RankGuild(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
end

function ClubSubsystem:SendMsg_GuildBtnSign()
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetGuildId() })
    NetManager:Get():Send(MsgID.SIGN_GUILD_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_RankSign(data)
    ---@type SC_GuildSign
    local msg = assert(Dll_PB.decode("GuildSign", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1])
    if msg.curExp>0 then
        ClubDataManager:Get():GetCurSelectClubData():SetCoin(msg.curExp)
        ----刷新俱乐部UI
        UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_UpdateSlider)

        local curSelectClubId = ClubDataManager:Get():GetCurSelectClubId()
        ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, curSelectClubId)
    end
    RedPointManager:Get():UpdateValue(RedPointID.S_ClubSign,false)
end

--{{{俱乐部成员列表 废弃
-------------------------------------------------------------请求俱乐部成员列表
function ClubSubsystem:SendMsg_GuildMemberList(guildId)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), guildId })

    NetManager:Get():Send(MsgID.GUILD_MEMBER_LIST_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildMemberList(data)
    ---@type SC_GuildMemberListRes
    local msg = assert(Dll_PB.decode("GuildMemberListRes", data))

    print("服务器返回俱乐部成员列表,RecvMsg_GuildMemberList_俱乐部成员数量" .. #msg.members)

    print(ProtoMsgHelp.block(msg))

    ClubDataManager:Get():GetCurSelectClubData():InitMemberList(msg)

    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.MemberList)
end
--}}}

--{{{获取自己申请俱乐部列表 废弃
-------------------------------------------------------------获取自己申请俱乐部列表
function ClubSubsystem:SendMsg_GetSelfApplyClubList()
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetGuildId() })

    NetManager:Get():Send(MsgID.GET_GUILD_APPLY_LIST_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GetSelfApplyClubList(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))

    ClubDataManager:Get():InitSelfApplyListData(msg.applylist)

    ClubDataManager:Get():SetClubListType(ClubListType.SelfApply)
    UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_InitClubList, { ClubListType.SelfApply, true })
end
---}}}

-------------------------------------------------------------搜索俱乐部请求
function ClubSubsystem:SendMsg_GuildSearchGuilds(searchStr)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),searchStr })
    NetManager:Get():Send(MsgID.SEARCH_GUILD_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildSearchGuilds(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    if #msg.guildlist > 0  then
        ClubDataManager:Get():InitSearchClubListData(msg.guildlist[1])
        UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_AfterSearch, msg.guildlist[1])
    else
        --可以提示一句啥也没搜索到
        UINotify:Get():SendNotification(UINotifyEvent.ClubNoView_List_NoClub, false)
    end
end
--}}}


--{{{以下是工会服

-------------------------------------------------------------处理俱乐部申请操作，同意还是拒绝
---@param opt ClubAuditType
function ClubSubsystem:SendMsg_GuildAuditMember(guestPlayerId, opt)
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetGuildId(),guestPlayerId})
    if opt == ClubAuditType.Agree then
        NetManager:Get():Send(MsgID.ACCEPT_GUILD_C2S_REQ, reqByte)
    elseif opt == ClubAuditType.Refuse then
        NetManager:Get():Send(MsgID.REFUSE_GUILD_APPLY_C2S_REQ, reqByte)
    end
end

function ClubSubsystem:RecvMsg_GuildAuditMember(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    ClubDataManager:Get():GetCurSelectClubData():DeleteApplyMember(msg.success,true)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.MemberList)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.ApplyList)
end

function ClubSubsystem:RecvMsg_GuildAuditRefuseMember(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    ClubDataManager:Get():GetCurSelectClubData():DeleteApplyMember(msg.success,false)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.ApplyList)
end
-------------------------------------------------------------请求俱乐部申请列表，别人谁申请了自己的俱乐部
function ClubSubsystem:SendMsg_GuildApplyList()
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetGuildId() })
    NetManager:Get():Send(MsgID.GET_GUILD_APPLY_LIST_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildApplyList(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    ClubDataManager:Get():GetCurSelectClubData():InitApplyMemberList(msg)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.ApplyList)
end

-------------------------------------------------------------更改玩家职位
---@param position ClubMemberPosition
function ClubSubsystem:SendMsg_GuildChangePosition(guestPlayerId, position)
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetGuildId(),guestPlayerId,position })
    NetManager:Get():Send(MsgID.CHANGE_POS_GUILD_C2S_REQ, reqByte)
    local unionType = 0
    if position == ClubMemberPosition.Manager then
        unionType = 4
    end
    if position == ClubMemberPosition.RankAndFile then
        unionType = 5
    end
    QuickTaHelper:TrackUnionEvent(unionType,guestPlayerId)

end

function ClubSubsystem:RecvMsg_GuildChangePosition(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))

    ClubDataManager:Get():GetCurSelectClubData():InitMemberList(msg)

    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.MemberList)
end
-------------------------------------------------------------转让玩家为会长
---@param position ClubMemberPosition
function ClubSubsystem:SendMsg_GuildChangePresident(guestPlayerId, position)
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetGuildId(),guestPlayerId,position })
    NetManager:Get():Send(MsgID.SEND_GUILD_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildChangePresident(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    ClubDataManager:Get():GetClubDataById(msg.myguild.guildid):InitMemberList(msg)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitViewInfo)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.MemberList)

    --PlayerDataManager:Get():SetCurrency(CurrencyType.Diamond, msg.diamond)
    QuickTaHelper:TrackUnionEvent(6,msg.leader)
end
-------------------------------------------------------------把玩家踢出俱乐部
function ClubSubsystem:SendMsg_GuildKickMember(id)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetGuildId(),id })
    NetManager:Get():Send(MsgID.KICK_GUILD_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildKickMember(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    ClubDataManager:Get():GetCurSelectClubData():InitMemberList(msg)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitMemberList, ClubMainMenuType.MemberList)
end
-------------------------------------------------------------自己被踢了  废弃
function ClubSubsystem:RecvMsg_BeKick()
    CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubBeKicked))

    ChatDataManager:Get():ClearChatDataByChatType(ChatType.Club)

    PlayerDataManager:Get():SetGuildId(0)
    PlayerDataManager:Get():SetGuildName("")

    NetManager:Get():DisconnectGuildServer(false)
    ClubDataManager:Get():Clear()

    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_InitMainChatInfo)

    if UIManager:Get():IsViewShow("ClubMainMenuView") then
        UIManager:Get():CloseView()

        SkipModuleHelper:Get():ToMainMenuView(true)
    end
end

-------------------------------------------------------------退出俱乐部，就是把自己踢出俱乐部
function ClubSubsystem:SendMsg_GuildExit()
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(),PlayerDataManager:Get():GetGuildId()})
    NetManager:Get():Send(MsgID.EXIT_GUILD_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildExit(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))

    ChatDataManager:Get():ClearChatDataByChatType(ChatType.Club)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_OnExitSuccess)
    UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_InitMainChatInfo)

    QuickTaHelper:TrackUnionEvent(3,"")

end

-------------------------------------------------------------设置工会宣言
function ClubSubsystem:SendMsg_GuildSetDeclaration(type, content)
    print("请求设置工会宣言")
    local reqData = {
        type = type, ---1是公告，2是宣言
        content = content,
    }
    local reqBytes = assert(Dll_PB.encode("GuildSetDeclarationReq", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_SET_DECLARATION_C2S_REQ, reqBytes)
end

function ClubSubsystem:RecvMsg_GuildSetDeclaration(data)
    ---@type SC_GuildSetDeclarationRes
    local msg = assert(Dll_PB.decode("GuildSetDeclarationRes", data))
    print(ProtoMsgHelp.block(msg))

    if msg.type == ClubInfoType.Self then
        ClubDataManager:Get():GetCurSelectClubData():SetNotice(msg.content)
    else
        ClubDataManager:Get():GetCurSelectClubData():SetDeclaration(msg.content)
    end
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitViewInfo)
end

-------------------------------------------------------------修改俱乐部设定,是否需要审批
function ClubSubsystem:SendMsg_GuildChangeJoinTypeReq(joinType)
    local reqData = {
        joinType = joinType
    }
    local reqBytes = assert(Dll_PB.encode("GuildChangeJoinTypeReq", reqData))
    NetManager:Get():SendGuild(OldMsgID.CHANGE_VERIFY_C2S_REQ, reqBytes)
end

function ClubSubsystem:RecvMsg_GuildChangeJoinTypeRes(data)

    local msg = assert(Dll_PB.decode("GuildChangeJoinTypeRes", data))
    print(ProtoMsgHelp.block(msg))
    ClubDataManager:Get():GetCurSelectClubData():SetJoinType(msg.joinType)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitViewInfo)
end

-------------------------------------------------------------更改俱乐部信息，比如加入方式，限制等级，宣言等，
function ClubSubsystem:SendMsg_GuildChangeInfoReq(notice, joinType, limitLv, icon)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),icon, PlayerDataManager:Get():GetGuildName(), limitLv,joinType, notice,PlayerDataManager:Get():GetGuildId() })
    NetManager:Get():Send(MsgID.CHANGE_GUILD_INFO_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildChangeInfoRes(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    local clubData = ClubDataManager:Get():GetCurSelectClubData()
    clubData:SetJoinType(msg.myguild.guildtype)
    clubData:SetLimitLv(msg.myguild.needlev)
    clubData:SetIcon(msg.myguild.guildicon)
    clubData:SetDeclaration(msg.myguild.guildpub)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitViewInfo)
end
-------------------------------------------------------------更改俱乐部名称
function ClubSubsystem:SendMsg_GuildChangeName(guideid, name)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),guideid,name })
    NetManager:Get():Send(MsgID.CHANGE_GUILD_NAME_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildChangeNameRes(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))
    local clubData = ClubDataManager:Get():GetCurSelectClubData()
    clubData:SetClubName(msg.myguild.guildname)
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.consumelist)
    UINotify:Get():SendNotification(UINotifyEvent.ClubMainMenuView_InitViewInfo)
    UIManager:Get():ClosePopup()
    CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ClubChangeNameSuccess))
end

-------------------------------------------------------------被审批加入俱乐部 ----通知被操作的玩家刷新俱乐部信息
function ClubSubsystem:RecvMsg_NotifyGuildChange(data)
    ---@type SC_actionGuild
    local msg = assert(Dll_PB.decode("actionGuild", data))
    print(ProtoMsgHelp.block(msg))
    PlayerDataManager:Get():SetGuildId(tonumber(msg.guildid))
    if msg.fresh == "1" then
        --被审批加入俱乐部
        if UIManager:Get():IsViewShow("ClubNoView") then
            ClubSubsystem:Get():SendMsg_GuildInfo(ClubInfoType.Self, msg.guildid)
        end
    end
    if msg.fresh == "2" then
        --1是被申请审核通过  2是被踢了
        if UIManager:Get():IsViewShow("ClubMainMenuView") then
            UIManager:Get():CloseView();
        end
    end
end

-------------------------------------------------------------请求工会日志
function ClubSubsystem:SendMsg_GuildLogs()
    local reqData = {
        num = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
    }
    local reqBytes = assert(Dll_PB.encode("Tuple1", reqData))
    NetManager:Get():SendGuild(OldMsgID.GUILD_LOGS_C2S_REQ, reqBytes)
end

function ClubSubsystem:RecvMsg_GuildLogs(data)
    ---@type SC_GuildLogsRes
    local msg = assert(Dll_PB.decode("GuildLogsRes", data))
    print(ProtoMsgHelp.block(msg))

    if msg.result == ClubOperateResult.Success then
        if #msg.logs > 0 then
            table.sort(msg.logs, function(a, b)
                return a.time < b.time
            end)
        end
        for i = 1, #msg.logs do
            local chatData = ChatData()
            chatData:SetClubLogData(msg.logs[i])
            ChatDataManager:Get():AddNotificationMsgByType(ChatType.Club, chatData)
        end
    end
end

-------------------------------------------------------------俱乐部捐赠
function ClubSubsystem:SendMsg_GuildDonation()
    print("俱乐部捐赠")
    --NetManager:Get():SendGuild(OldMsgID.GUILD_DONATION_C2S_REQ, "")
    local reqByte = CommonHelper:GetNetSendData()
    NetManager:Get():Send(MsgID.DONATE_GUILD_C2S_REQ, reqByte)
end

function ClubSubsystem:RecvMsg_GuildDonation(data)
    ---@type SC_UserGuild
    local msg = assert(Dll_PB.decode("UserGuild", data))
    print(ProtoMsgHelp.block(msg))

    if msg.success == ClubOperateResult.Success then
        UIManager:Get():OpenPopup("ClubExchangeGetRewardView", CanvasType.MainCanvas, "ClubExchangeGetRewardView")
        ---todo 跟服务器协商
        UINotify:Get():SendNotification(UINotifyEvent.ClubExchangeView_UpdateExchangePlayerAttr, msg)
    end
end

-------------------------------------------------------------获取俱乐部捐赠详细信息
function ClubSubsystem:SendMsg_GetDonationInfoReq()
    NetManager:Get():SendGuild(OldMsgID.GUILD_GET_DONATION_INFO_C2S_REQ, "")
end

function ClubSubsystem:RecvMsg_GetDonationInfoRes(data)
    ---@type SC_DonationRes
    local msg = assert(Dll_PB.decode("GetDonationInfoRes", data))
    print(ProtoMsgHelp.block(msg))
    if msg.result == ClubOperateResult.Success then
        UIManager:Get():OpenView("ClubExchangeView", CanvasType.MainCanvas, "ClubExchangeView")
        UINotify:Get():SendNotification(UINotifyEvent.ClubExchangeView_UpdateExchangeViewInfo, msg.donationInfo)
    end
end

--}}}


local __subsystem = ClubSubsystem()
function ClubSubsystem:Get()
    return __subsystem
end
return __subsystem
