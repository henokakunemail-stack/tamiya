---@class PlayerInfoSubsystem
PlayerInfoSubsystem = class("PlayerInfoSubsystem")

function PlayerInfoSubsystem:initialize(...)
     NetResponseEventManager:Get():AddListener(MsgID.CHANGE_PLAYER_INFO_S2C_RES, self, self.RecvMsg_ChangeHeadIcon)
    NetResponseEventManager:Get():AddListener(MsgID.CHANGE_PLAYER_NAME_S2C_RES, self, self.RecvMsg_ChangePlayerName)
    NetResponseEventManager:Get():AddListener(MsgID.CHANGE_PLAYER_SIGN_S2C_RES, self, self.RecvMsg_ChangePlayerSign)
    NetResponseEventManager:Get():AddListener(MsgID.CHANGE_PLAYER_HEAD_ICON_S2C_RES, self, self.RecvMsg_ChangeHeadIconFrame)
    NetResponseEventManager:Get():AddListener(MsgID.GET_LEVEL_AWARD_S2C_RES, self, self.RecvMsg_GetLevelReward)

    --NetResponseEventManager:Get():AddListener(MsgID.GET_BASE_PLAYER_DATA_G2C_RES, self, self.RecvMsg_GetPlayerInfo)

    --NetResponseEventManager:Get():AddListener(MsgID.KICK_OUT_PLAYER_S2C_NOTIFY, self, self.RecvMsg_BeKicked)
    --NetResponseEventManager:Get():AddListener(MsgID.BAN_LOGIN_PLAYER_S2C_NOTIFY, self, self.RecvMsg_NotifyBanLoginTime)
    --NetResponseEventManager:Get():AddListener(MsgID.RANK_INFO_S2C_NOTIFY, self, self.RecvMsg_UpdateRankData)
    NetResponseEventManager:Get():AddListener(MsgID.GET_EXCHANGE_CODE_RES, self, self.RecvMsg_Code)
    NetResponseEventManager:Get():AddListener(MsgID.CHANGE_PLAYER_BG_S2C_RES, self, self.RecvMsg_ChangePlayerBG)
    NetResponseEventManager:Get():AddListener(MsgID.CHANGE_PLAYER_CUPS_S2C_RES, self, self.RecvMsg_ChangePlayerCups)
    NetResponseEventManager:Get():AddListener(MsgID.GET_PLAYER_BIND_INFO_S2C_RES, self, self.RecvMsg_GetBindInfo)
    NetResponseEventManager:Get():AddListener(MsgID.PLAYER_BIND_S2C_RES, self, self.RecvMsg_ChangePlayerBind)
end

----修改头像
function PlayerInfoSubsystem:SendMsg_ChangePlayerInfo(headIcon,iconFrame,sign,rolename)
    local reqData =CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),headIcon,iconFrame,sign,rolename})
    NetManager:Get():Send(MsgID.CHANGE_PLAYER_INFO_C2S_REQ, reqData)
end
function PlayerInfoSubsystem:RecvMsg_ChangeHeadIcon(data)
    print("修改头像成功")
    ---@type SC_RetAlterUser
    local msg = assert(Dll_PB.decode("RetAlterUser", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    if msg.rolename~=PlayerDataManager:Get():GetPlayerName() then
        UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoView_ChangeName, msg.rolename)
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeNameSuccess))
        KnapsackDataManager:Get():UpdatePropByConsume(msg.props)
    end
    if msg.sign~=PlayerDataManager:Get():GetPlayerSign() then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeSignSuccess))
    end
    if msg.headicon~=PlayerDataManager:Get():GetPlayerIcon() then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeIconSuccess))
    end
    if msg.iconframe~=PlayerDataManager:Get():GetPlayerIconFrame() then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeIconFarmSuccess))
    end
    PlayerDataManager:Get():SetPlayerIcon(msg.headicon)
    PlayerDataManager:Get():SetPlayerName(msg.rolename)
    PlayerDataManager:Get():SetPlayerSign(msg.sign)
    PlayerDataManager:Get():SetPlayerIconFrame(msg.iconframe)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerIcon)
    UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoView_ChangeSign, msg.sign)
end

----兑换码
function PlayerInfoSubsystem:SendMsg_UseCode(code)
    local reqByte=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),code})
    NetManager:Get():Send(MsgID.GET_EXCHANGE_CODE_REQ, reqByte)
end

function PlayerInfoSubsystem:RecvMsg_Code(data)
    ---@type SC_Exchange
    local msg = assert(Dll_PB.decode("Exchange", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist)
end

function PlayerInfoSubsystem:SendMsg_GetLevelReward(level)
    local reqByte=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),level})
    NetManager:Get():Send(MsgID.GET_LEVEL_AWARD_C2S_REQ, reqByte)
end

function PlayerInfoSubsystem:RecvMsg_GetLevelReward(data)
    ---@type SC_LevelAward
    local msg = assert(Dll_PB.decode("LevelAward", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist)
    PlayerDataManager:Get():UpdateLevelAward(msg.level)
    UINotify:Get():SendNotification(UINotifyEvent.PlayerLevelRewardUpdate)
    RedPointManager:Get():UpdateValue(RedPointID.PlayerLevelReward)
end




--更换签名
function PlayerInfoSubsystem:SendChangePlayerSign(sign)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),sign})
    NetManager:Get():Send(MsgID.CHANGE_PLAYER_SIGN_C2S_REQ, reqByte)
end
function PlayerInfoSubsystem:RecvMsg_ChangePlayerSign(data)
    -- print("更改角色名字")
    ---@type SC_AltUserSign
    local msg = assert(Dll_PB.decode("AltUserSign", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeSignSuccess))
    PlayerDataManager:Get():SetPlayerSign(msg.sign)
    UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoView_ChangeSign, msg.sign)
end

----更改角色名字
function PlayerInfoSubsystem:SendMsg_ChangePlayerName(playerName)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),playerName})
    NetManager:Get():Send(MsgID.CHANGE_PLAYER_NAME_C2S_REQ, reqByte)
end
function PlayerInfoSubsystem:RecvMsg_ChangePlayerName(data)
    print("更改角色名字")
    ---@type SC_AltUserRole
    local msg = assert(Dll_PB.decode("AltUserRole", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeNameSuccess))
    PlayerDataManager:Get():SetPlayerName(msg.rolename)
    UINotify:Get():SendNotification(UINotifyEvent.PlayerSelfInfoView_ChangeName, msg.rolename)
    UINotify:Get():SendNotification(UINotifyEvent.PersonalHomeView_ChangeName)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.props)

end




----修改头像框
function PlayerInfoSubsystem:SendMsg_ChangeHeadIconFrame(icon,iconframe)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),icon,iconframe})
    NetManager:Get():Send(MsgID.CHANGE_PLAYER_HEAD_ICON_C2S_REQ, reqByte)
end
function PlayerInfoSubsystem:RecvMsg_ChangeHeadIconFrame(data)
    ---@type SC_AltUserIcon
    local msg = assert(Dll_PB.decode("AltUserIcon", data))
    print(ProtoMsgHelp.block(msg))
    if msg.headicon~=PlayerDataManager:Get():GetPlayerIcon() then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeIconSuccess))
    end
    if msg.iconframe~=PlayerDataManager:Get():GetPlayerIconFrame() then
        CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeIconFarmSuccess))
    end
    PlayerDataManager:Get():SetPlayerIcon(msg.headicon)
    PlayerDataManager:Get():SetPlayerIconFrame(msg.iconframe)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PlayerIcon)
end

----获取角色信息
function PlayerInfoSubsystem:SendMsg_GetPlayerInfo(playerId)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:GetPlayerRID(),playerId})
    NetManager:Get():Send(OldMsgID.GET_BASE_PLAYER_DATA_C2G_REQ, reqByte)
end
function PlayerInfoSubsystem:RecvMsg_GetPlayerInfo(data)
    print("获取角色信息成功")
    local msg = assert(Dll_PB.decode("getPlayerInfoRes", data))
    print(ProtoMsgHelp.block(msg))
    SkipModuleHelper:Get():ToPlayerOtherInfoView(msg)
end


function PlayerInfoSubsystem:RecvMsg_BeKicked(data)
    ---@type SC_KickPlayerOutRes
    local msg = assert(Dll_PB.decode("KickPlayerOutRes", data))
    print(ProtoMsgHelp.block(msg))

    PlayerDataManager:Get():SetPlayerSDKLogoutType(SDKLogoutType.Kicked)

    PlayerDataManager:Get():SetPlayerKickType(msg.type)
    PlayerDataManager:Get():KickedByType(msg.type)
end

function PlayerInfoSubsystem:RecvMsg_NotifyBanLoginTime(data)
    ---@type SC_NotifyBanLoginTime
    local msg = assert(Dll_PB.decode("NotifyBanLoginTime", data))
    print(ProtoMsgHelp.block(msg))

    local serverInfo = ClientDataManager:Get():GetServerInfoByServerId(tonumber(PlayerPrefsHelper:GetValue_LoginServerId()))

    NetEaseDetect:Get():LoginFail(
            serverInfo:GetGroupId(),
            serverInfo:GetName(),
            serverInfo:GetIp(),
            tonumber(serverInfo:GetPort()),
            "被封号",
            "-1",
            "-1"
    )

    CommonHelper:LoginTipPop(CommonHelper:GetTempStr_Default(TemplateStringID.LoginTips_1011), CommonHelper:GetTempStr_Default(TemplateStringID.OK), function()
        --if msg.leftTime == -1 then
        --    message = CommonHelper:GetTempStr_Default(TemplateStringID.AccountBanForever)
        --else
        --    local dateInt = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) + msg.leftTime
        --    local date = CommonHelper:ConvertIntToDataTime(dateInt * 1000)
        --    local dateStr = date:ToString("yyyy:MM:dd HH:mm:ss")
        --    message = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.BanUntil), dateStr)
        --end
        LoginFuncHelper:LoginOut_GameBackToLogin_Combine(true, true, nil, true)
    end)
end

function PlayerInfoSubsystem:RecvMsg_UpdateRankData(data)
    ---@type SC_RankInfo
    local msg = assert(Dll_PB.decode("RankInfo", data))
    print(ProtoMsgHelp.block(msg))
    PlayerDataManager:Get():UpdateRankData(msg)
end

----更改角色背景板子
function PlayerInfoSubsystem:SendMsg_ChangePlayerBG(bgid)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),bgid})
    NetManager:Get():Send(MsgID.CHANGE_PLAYER_BG_C2S_REQ, reqByte)
end
function PlayerInfoSubsystem:RecvMsg_ChangePlayerBG(data)
    print("背景板子")
    ---@type SC_AltUserBackground
    local msg = assert(Dll_PB.decode("AltUserBackground", data))
    print(ProtoMsgHelp.block(msg))
    PlayerDataManager:Get():SetBgId(msg.background)
    CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeBGSuccess))
end

----更改角色奖杯
function PlayerInfoSubsystem:SendMsg_ChangePlayerCups(cups)
    local cupsStr= table.concat(cups,':')
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),cupsStr})
    NetManager:Get():Send(MsgID.CHANGE_PLAYER_CUPS_C2S_REQ, reqByte)
end
function PlayerInfoSubsystem:RecvMsg_ChangePlayerCups(data)
    print("更改角色名字")
    ---@type SC_AltUserTitleCup
    local msg = assert(Dll_PB.decode("AltUserTitleCup", data))
    print(ProtoMsgHelp.block(msg))
    local cups=stringSplitToNumber(msg.cups,":")
    PlayerDataManager:Get():SetCups(cups)
    CommonTipsHelper:Get():ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.ChangeCupSuccess))
end

function PlayerInfoSubsystem:SendMsg_GetBindInfo()
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),cupsStr})
    NetManager:Get():Send(MsgID.GET_PLAYER_BIND_INFO_C2S_REQ, reqByte)
end

function PlayerInfoSubsystem:RecvMsg_GetBindInfo(data)
    ---@type SC_UserBindInfo
    local msg = assert(Dll_PB.decode("UserBindInfo", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ShowPersistentView("Game4WDBindView",CanvasType.MainCanvas,"GameBindView")
    UINotify:Get():SendNotification(UINotifyEvent.Game4WDBind_SetData,{msg,true})
end
function PlayerInfoSubsystem:SendMsg_ChangePlayerBind(id)
    local reqByte = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),1,id})
    NetManager:Get():Send(MsgID.PLAYER_BIND_C2S_REQ, reqByte)
end
function PlayerInfoSubsystem:RecvMsg_ChangePlayerBind(data)
    ---@type SC_UserBindInfo
    local msg = assert(Dll_PB.decode("UserBindInfo", data))
    print(ProtoMsgHelp.block(msg))
    PlayerDataManager:Get():UpdateBindInfo(msg.curBind)
    UINotify:Get():SendNotification(UINotifyEvent.Game4WDBind_SetData,{msg,false})
end

local __subsystem = PlayerInfoSubsystem()
function PlayerInfoSubsystem:Get()
    return __subsystem
end
return __subsystem