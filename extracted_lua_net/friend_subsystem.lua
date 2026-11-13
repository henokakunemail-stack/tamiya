---@class FriendSubsystem
FriendSubsystem = class("FriendSubsystem")

function FriendSubsystem:initialize(...)
    --NetResponseEventManager:Get():AddListener(MsgID.CHANGE_FRIENDSHIP_NOTIFY, self, self.Notify_ChangeFriendHeart)
    --NetResponseEventManager:Get():AddListener(MsgID.FRIEND_CHAT_NOTIFY, self, self.Notify_ChatOtherToSelf)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_OFFLINE_CHAT_RES, self, self.Notify_ChatOtherToSelfOffline)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_PLAYER_INFO_REQ, self, self.RecvMsg_GetPlayerInfo)

    NetResponseEventManager:Get():AddListener(MsgID.GET_FRIEND_LIST_S2C_RES, self, self.RecvMsg_GetAllFriends)
    NetResponseEventManager:Get():AddListener(MsgID.GET_SEARCH_FRIEND_S2C_RES, self, self.RecvMsg_SearchFriends)
    NetResponseEventManager:Get():AddListener(MsgID.ADD_FRIEND_S2C_RES, self, self.RecvMsg_AddFriends)
    NetResponseEventManager:Get():AddListener(MsgID.DEL_FRIEND_S2C_RES, self, self.RecvMsg_DelFriends)
    NetResponseEventManager:Get():AddListener(MsgID.REFUSE_FRIEND_S2C_RES, self, self.RecvMsg_DueRequest)
    NetResponseEventManager:Get():AddListener(MsgID.GIVE_FRIEND_GIFT_S2C_RES, self, self.RecvMsg_SendFriendHeart)
    NetResponseEventManager:Get():AddListener(MsgID.REV_FRIEND_GIFT_S2C_RES, self, self.RecvMsg_GetFriendHeart)
    NetResponseEventManager:Get():AddListener(MsgID.GET_APPLY_FRIEND_LIST_S2C_RES, self, self.RecvMsg_RequestFriends)
    NetResponseEventManager:Get():AddListener(MsgID.GET_RECOMMEND_FRIED_S2C_RES, self, self.RecvMsg_GetRecommend)
    NetResponseEventManager:Get():AddListener(MsgID.DENY_TALK_RES, self, self.RecvMsg_AddBlacklist)
    NetResponseEventManager:Get():AddListener(MsgID.ACCESS_TALK_RES, self, self.RecvMsg_DelBlacklist)
    NetResponseEventManager:Get():AddListener(MsgID.DENY_LIST_TALK_RES, self, self.RecvMsg_GetBlackFriends)
end

-------------------------------------------------------------获取好友列表数据
function FriendSubsystem:SendMsg_GetAllFriends()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })

    NetManager:Get():Send(MsgID.GET_FRIEND_LIST_C2S_REQ, data)
end

function FriendSubsystem:RecvMsg_GetAllFriends(data)
    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))

    FriendDataManager:Get():InitFriendsData(msg.friendlist)
    FriendDataManager:Get():SetHeartData(msg)
    local friendType = FriendDataManager:Get():GetFriendType()
    if friendType == FriendType.Init then
        UIManager:Get():OpenView("FriendListView", CanvasType.MainCanvas, "FriendListView")
        UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Friend)
    elseif friendType == FriendType.RoomInvite then
        CommonHelper:RoomInvite(ShareType.RoomInvite)
    end
    FriendDataManager:Get():SetFriendType(FriendType.None)
end
-------------------------------------------------------------获取好友列表数据
function FriendSubsystem:SendMsg_GetRecommend()
    local data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })
    NetManager:Get():Send(MsgID.GET_RECOMMEND_FRIED_C2S_REQ, data)
end

function FriendSubsystem:RecvMsg_GetRecommend(data)
    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))
    FriendDataManager:Get():InitRecommendListData(msg.friendlist)
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.AddFriend)
    UINotify:Get():SendNotification(UINotifyEvent.FriendBlackListView_InitFriendList)
end

-------------------------------------------------------------获取好友黑名单

-------------------------------------------------------------搜索好友
---@param type FriendSearchType
function FriendSubsystem:SendMsg_SearchFriends(friendId, type)

    local reqByte = nil
    if type == FriendSearchType.ID then
        reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), friendId, "" })
    elseif type == FriendSearchType.Name then
        reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), "", friendId })
    end

    NetManager:Get():Send(MsgID.GET_SEARCH_FRIEND_C2S_REQ, reqByte)
end

function FriendSubsystem:RecvMsg_SearchFriends(data)
    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))

    FriendDataManager:Get():SetFriendNum(msg.sums)

    FriendDataManager:Get():InitSearchListData(msg.friendlist)
    --刷新界面
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.SearchList)
    if #msg.friendlist <= 0 then
        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PlayerNotFind))
    end
end

-------------------------------------------------------------请求添加好友
---@param requestId @添加好友的ID
function FriendSubsystem:SendMsg_AddFriends(requestId)
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), requestId })

    NetManager:Get():Send(MsgID.ADD_FRIEND_C2S_REQ, reqByte)
end

function FriendSubsystem:RecvMsg_AddFriends(data)
    --local msg = assert(Dll_PB.decode("requestFriendRes", data))
    --print(ProtoMsgHelp.block(msg))
    --
    --if MsgErrorManager:Get():HttpMsgError(msg.result) then
    --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.HasAddFriend))
    --    --UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.AddFriend)
    --else
    --
    --end
    print("---------添加好友-----------")

    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))
    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.HasAddFriend))
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.AddFriend)

    --local data= QuickTaData:GetFiendSystem(
    --        1,
    --        msg.friendrid,
    --        FriendDataManager:Get():GetFriendNum()
    --)
    --QuickTa:Get():TrackEvent(TrackEventNames.FiendSystem,data)
end

-------------------------------------------------------------请求删除好友
---@param delId @添加好友的ID
function FriendSubsystem:SendMsg_DelFriends(delId)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), delId })

    NetManager:Get():Send(MsgID.DEL_FRIEND_C2S_REQ, reqByte)
end

function FriendSubsystem:RecvMsg_DelFriends(data)
    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))

    FriendDataManager:Get():SetFriendNum(msg.sums)
    FriendDataManager:Get():DelFriend(msg.friendrid)
    if FriendType.DelFriendInChatPlayerInfo == FriendDataManager:Get():GetFriendType() then
        --UINotify:Get():SendNotification(UINotifyEvent.ChatView_PlayerInfo_SetBtnInfo)
    elseif FriendType.DelFriendInOtherPlayerInfo == FriendDataManager:Get():GetFriendType() then
        UINotify:Get():SendNotification(UINotifyEvent.PlayerOtherInfoView_SetBtnInfo)
    end

    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Friend)

    --ChatDataManager:Get():DeletePrivateChat(msg.friendrid)
    --if ChatDataManager:Get():GetCurSelectPrivateId() == -1 then
    --    UINotify:Get():SendNotification(UINotifyEvent.ChatView_SetPrivateShowData, ChatType.Private)
    --end
    --UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitPrivateList, -1)
    --
    --FriendDataManager:Get():SetFriendType(FriendType.None)

    --local data= QuickTaData:GetFiendSystem(
    --        2,
    --        msg.friendrid,
    --        FriendDataManager:Get():GetFriendNum()
    --)
    --QuickTa:Get():TrackEvent(TrackEventNames.FiendSystem,data)

end

--{{{-------获取推荐\申请列表好友---------
---@param type FriendRecommendRequestType @添加好友的ID
function FriendSubsystem:SendMsg_RecommendFriends(type)

    --local reqData = {
    --    type = type,
    --}
    --local reqBytes = assert(Dll_PB.encode("recommendFriendsReq", reqData))
    --local url, jsonStr = FriendDataManager:Get():GetUrl(MsgID.RECOMMEND_FRIENDS_C2S_REQ, reqBytes)
    --NetManager:Get():SendHttpPost_Friend(url, function(data)
    --    FriendSubsystem:Get():RecvMsg_RecommendFriends(data)
    --end, function(code)
    --    print("sendHttpError.......code:  " .. tostring(code))
    --end, jsonStr)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })

    NetManager:Get():Send(MsgID.GET_APPLY_FRIEND_LIST_C2S_REQ, reqByte)

end

function FriendSubsystem:RecvMsg_RecommendFriends(data)
    --local msg = assert(Dll_PB.decode("recommendFriendsRes", data))
    --print(ProtoMsgHelp.block(msg))
    --if MsgErrorManager:Get():HttpMsgError(msg.result) then
    --    if FriendDataManager:Get():GetFriendType() == FriendType.Init then
    --        FriendSubsystem:Get():SendMsg_GetAllFriends()
    --    end
    --
    --    --刷新界面
    --    if msg.type == FriendRecommendRequestType.Recommend then
    --        FriendDataManager:Get():InitRecommendListData(msg.friends)
    --        UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.AddFriend)
    --    elseif msg.type == FriendRecommendRequestType.Request then
    --        FriendDataManager:Get():InitRequestListData(msg.friends)
    --        UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Request)
    --    end
    --else
    --
    --end

    if FriendDataManager:Get():GetFriendType() == FriendType.Init then
        FriendSubsystem:Get():SendMsg_GetAllFriends()
    end

    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))
    FriendDataManager:Get():SetFriendNum(msg.sums)
    FriendDataManager:Get():InitRequestListData(msg.friendlist)
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Request)
end

---@param type FriendRecommendRequestType @添加好友的ID
function FriendSubsystem:SendMsg_RequestFriends(type)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })

    NetManager:Get():Send(MsgID.GET_APPLY_FRIEND_LIST_C2S_REQ, reqByte)

end

function FriendSubsystem:RecvMsg_RequestFriends(data)
    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))
    FriendDataManager:Get():SetFriendNum(msg.sums)
    FriendDataManager:Get():InitRequestListData(msg.friendlist)
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Request)
    RedPointManager:Get():UpdateValue(RedPointID.S_FriendFriendAdd,FriendDataManager:Get():IsHaveRedPoint_Apply())
end

--}}}

-------------------------------------------------------------处理好友请求
---@param playerId @添加好友的ID
---@param agree  FriendApplyType@是否同意请求 0同意 1拒绝
function FriendSubsystem:SendMsg_DueRequest(playerId, agree)

    --local reqData = {
    --    playerId = playerId,
    --    agree = agree
    --}
    --local reqBytes = assert(Dll_PB.encode("dueRequestFriendReq", reqData))
    --
    --local url, jsonStr = FriendDataManager:Get():GetUrl(MsgID.DUE_REQUEST_FRIEND_C2S_REQ, reqBytes)
    --NetManager:Get():SendHttpPost_Friend(url, function(data)
    --    FriendSubsystem:Get():RecvMsg_DueRequest(data)
    --end, function(code)
    --    print("sendHttpError.......code:  " .. tostring(code))
    --end, jsonStr)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), playerId, agree })

    NetManager:Get():Send(MsgID.REFUSE_FRIEND_C2S_REQ, reqByte)

end

function FriendSubsystem:RecvMsg_DueRequest(data)
    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))
    FriendDataManager:Get():SetFriendNum(msg.sums)
    FriendDataManager:Get():DueRequestData(msg.friendrid, msg.assert)
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Request)
    --6同意加好友 7拒绝加好友
    local friendType = 7
    if msg.assert == FriendApplyType.Agree then
        friendType =6
    end
    --local data= QuickTaData:GetFiendSystem(
    --        friendType,
    --        msg.friendrid,
    --        FriendDataManager:Get():GetFriendNum()
    --)   --是否同意请求加好友msg.assert
    --QuickTa:Get():TrackEvent(TrackEventNames.FiendSystem,data)
end


--{{{---------黑名单(功能废弃)----------
function FriendSubsystem:SendMsg_GetBlackFriends()

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID() })

    NetManager:Get():Send(MsgID.GET_DENY_LIST_TALK_REQ, reqByte)
end

function FriendSubsystem:RecvMsg_GetBlackFriends(data)
    ---@type SC_DenyTalk
    local msg = assert(Dll_PB.decode("DenyTalk", data))
    print(ProtoMsgHelp.block(msg))
    FriendDataManager:Get():UpdateBlackListData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_SetLuaViewInfo, { "BlackView", "BlackView" })
    UIManager:Get():OpenPopup("FriendBlackListView", CanvasType.MainCanvas, "FriendBlackListView")
    --FriendDataManager:Get():SetFriendType(FriendType.None)
    --if MsgErrorManager:Get():HttpMsgError(msg.result) then
    --    if FriendDataManager:Get():GetFriendType() == FriendType.BlackList then
    --        FriendDataManager:Get():InitBlackListData(msg.blacks)
    --        UINotify:Get():SendNotification(UINotifyEvent.FriendListView_SetLuaViewInfo, { "BlackView", "BlackView" })
    --        UIManager:Get():OpenPopup("FriendBlackListView", CanvasType.MainCanvas, "FriendBlackListView")
    --    end
    --    FriendDataManager:Get():SetFriendType(FriendType.None)
    --else
end

---@param addId @添加黑名单的ID
function FriendSubsystem:SendMsg_AddBlacklist(playerId,nickName,icon,iconframe)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), playerId,nickName,icon,iconframe })

    NetManager:Get():Send(MsgID.DENY_TALK_REQ, reqByte)
end
--data ="����lujia003 ���lujia004 �"
function FriendSubsystem:RecvMsg_AddBlacklist(data)
    ---@type SC_DenyTalk
    local msg = assert(Dll_PB.decode("DenyTalk", data))
    print(ProtoMsgHelp.block(msg))
    FriendDataManager:Get():UpdateBlackListData(msg)
    --if MsgErrorManager:Get():HttpMsgError(msg.result) then
    --FriendDataManager:Get():AddBlackFriend(msg.playerId)
    if FriendType.BlackFriendInChatPlayerInfo == FriendDataManager:Get():GetFriendType() then
        --UINotify:Get():SendNotification(UINotifyEvent.ChatView_PlayerInfo_SetBtnInfo)
    elseif FriendType.BlackFriendInOtherPlayerInfo == FriendDataManager:Get():GetFriendType() then
        UINotify:Get():SendNotification(UINotifyEvent.PlayerOtherInfoView_SetBtnInfo)
    end
end

-------------------------------------------------------------删除黑名单
---@param delId @删除黑名单的ID
function FriendSubsystem:SendMsg_DelBlacklist(playerId)
    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), playerId})

    NetManager:Get():Send(MsgID.ACCESS_TALK_REQ, reqByte)

end

function FriendSubsystem:RecvMsg_DelBlacklist(data)

    ---@type SC_DenyTalk
    local msg = assert(Dll_PB.decode("DenyTalk", data))
    print(ProtoMsgHelp.block(msg))
    FriendDataManager:Get():UpdateBlackListData(msg)
    UINotify:Get():SendNotification(UINotifyEvent.FriendBlackListView_InitFriendList)
    --if MsgErrorManager:Get():HttpMsgError(msg.result) then
    --    if FriendDataManager:Get():IsFriendLimit() then
    --        CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FriendCountMax))
    --    else
    --        FriendDataManager:Get():RemoveBlackFriendById(msg.delId)
    --    end
    --    UINotify:Get():SendNotification(UINotifyEvent.FriendBlackListView_InitFriendList)
    --else
    --
    --end
end
--}}}

-------------------------------------------------------------赠送友情点
---@param playerId @赠送友情点的好友ID
function FriendSubsystem:SendMsg_SendFriendHeart(playerId)

    --local reqData = {
    --    playerId = playerId
    --}
    --local reqBytes = assert(Dll_PB.encode("sendFriendHeartReq", reqData))
    --
    --local url, jsonStr = FriendDataManager:Get():GetUrl(MsgID.SEND_FRIEND_HEART_C2S_REQ, reqBytes)
    --NetManager:Get():SendHttpPost_Friend(url, function(data)
    --    FriendSubsystem:Get():RecvMsg_SendFriendHeart(data)
    --end, function(code)
    --    print("sendHttpError.......code:  " .. tostring(code))
    --end, jsonStr)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), playerId })

    NetManager:Get():Send(MsgID.GIVE_FRIEND_GIFT_C2S_REQ, reqByte)


end

function FriendSubsystem:RecvMsg_SendFriendHeart(data)
    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))

    if msg.downlist[1] and #msg.downlist[1].downProps==1 and msg.downlist[1].downProps[1].propid==CurrencyType.FriendShip then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FriedShipGiveSuccess))
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.downlist[1])
    else
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1])
    end

    FriendDataManager:Get():UpdateHeartData(msg.alterrids, FriendGiftType.Send)
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Friend)


    --local data= QuickTaData:GetFiendSystem(
    --        8,
    --        msg.friendrid,
    --        FriendDataManager:Get():GetFriendNum()
    --)    --赠送好友礼物
    --QuickTa:Get():TrackEvent(TrackEventNames.FiendSystem,data)
end

-------------------------------------------------------------领取友情点
---@param playerId @赠送友情点的好友ID
function FriendSubsystem:SendMsg_GetFriendHeart(playerId)

    --local reqData = {
    --    playerId = playerId
    --}
    --local reqBytes = assert(Dll_PB.encode("receiveFriendHeartReq", reqData))
    --
    --local url, jsonStr = FriendDataManager:Get():GetUrl(MsgID.RECEIVE_FRIEND_HEART_C2S_REQ, reqBytes)
    --NetManager:Get():SendHttpPost_Friend(url, function(data)
    --    FriendSubsystem:Get():RecvMsg_GetFriendHeart(data)
    --end, function(code)
    --    print("sendHttpError.......code:  " .. tostring(code))
    --end, jsonStr)

    local reqByte = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), playerId })

    NetManager:Get():Send(MsgID.REV_FRIEND_GIFT_C2S_REQ, reqByte)
end

function FriendSubsystem:RecvMsg_GetFriendHeart(data)
    -----@type SC_receiveFriendHeartRes
    --local msg = assert(Dll_PB.decode("receiveFriendHeartRes", data))
    --print(ProtoMsgHelp.block(msg))
    --
    --if MsgErrorManager:Get():HttpMsgError(msg.result) then
    --    FriendDataManager:Get():ReceiveHeartData(msg.playerId)
    --
    --    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Friend)
    --else
    --
    --end

    ---@type SC_UserFriends
    local msg = assert(Dll_PB.decode("UserFriends", data))
    print(ProtoMsgHelp.block(msg))
    if #msg.downlist>0 then
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.downlist[1])
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FriedShipGetSuccess))
    end
    FriendDataManager:Get():UpdateHeartData(msg.alterrids, FriendGiftType.Recv)
    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Friend)
    RedPointManager:Get():UpdateValue(RedPointID.S_FriendFriendShip,false)

    --local data= QuickTaData:GetFiendSystem(
    --        9,
    --        msg.friendrid,
    --        FriendDataManager:Get():GetFriendNum()
    --)
    --QuickTa:Get():TrackEvent(TrackEventNames.FiendSystem,data)
end

function FriendSubsystem:Notify_ChangeFriendHeart(data)
    ---@type SC_NotifyFriendShipChange
    local msg = assert(Dll_PB.decode("NotifyFriendShipChange", data))
    print(ProtoMsgHelp.block(msg))

    PlayerDataManager:Get():SetCurrency(CurrencyType.FriendShip, msg.friendShip)

    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.Friend)
end

---@param chatOrLinkType ChatOrLinkType
function FriendSubsystem:SendMsg_PrivateChatToOther(targetPid, content, chatOrLinkType)
    --local reqData = {
    --    pid = PlayerDataManager:Get():GetPlayerRID(),
    --    targetPid = targetPid,
    --    content = content,
    --    type = chatOrLinkType,
    --}
    ChatSubsystem:Get():SendMsg_ChatData(ChatType.Private,"",targetPid,content,nil,nil,true)
end

function FriendSubsystem:RecvMsg_PrivateChatToOther(data)
    ---@type SC_FriendChatRes
    local msg = assert(Dll_PB.decode("FriendChatRes", data))
    print(ProtoMsgHelp.block(msg))

    if MsgErrorManager:Get():HttpMsgError(msg.result) then
        if msg.chatInfo.type == ChatOrLinkType.Link then
            print("这是自己邀请别人进入房间赛，不用处理")
            if msg.chatInfo.content ~= CommonHelper:GetTempStr_Default(TemplateStringID.RefuseInvite) then
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InviteSuccess))--拒绝别人邀请的时候，自己不弹框
            end
        else
            local chatData = ChatDataManager:Get():SetChatData(msg, ChatType.Private)

            --和谁私聊的，自己说话，不需要把自己添加到私聊玩家数据里面
            chatData:SetSendId(PlayerDataManager:Get():GetPlayerRID())

            if msg.chatInfo.type == ChatOrLinkType.Invite then
                chatData:SetMessageType(ChatPrefabType.ClubInvite)
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InviteSuccess))--拒绝别人邀请的时候，自己不弹框
            end

            ChatDataManager:Get():AddChatMsgByType(ChatType.Private, chatData, true, true)

            ChatDataManager:Get():UpdateScrollList(chatData)
        end
    else
    end
end

---@param data SC_FriendChatRes
function FriendSubsystem:Notify_ChatOtherToSelf(data)
    ---@type SC_FriendChatRes
    local msg = assert(Dll_PB.decode("FriendChatRes", data))
    print(ProtoMsgHelp.block(msg))

    local chatData = ChatDataManager:Get():SetChatData(msg, ChatType.Private)
    if msg.chatInfo.type == ChatOrLinkType.Link then
        if msg.chatInfo.content == CommonHelper:GetTempStr_Default(TemplateStringID.RefuseInvite) then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RefuseInvite))
        else
            print("这是别人邀请别人自己进入房间赛，需要弹出弹框")
            InviteDataManager:Get():AddInviteMsgByType(chatData, ChatInviteType.RaceRoom)
            CommonHelper:OpenInvitePopView()
        end
        return
    end

    if msg.chatInfo.type == ChatOrLinkType.Invite then
        chatData:SetMessageType(ChatPrefabType.ClubInvite)
    end

    ChatDataManager:Get():AddChatMsgByType(ChatType.Private, chatData, true, true)

    ChatDataManager:Get():UpdateScrollList(chatData)

    ----刷新主界面UI
    --UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_UpdateChatText, { ChatType.Private, chatData:GetSendId() })
end

function FriendSubsystem:SendMsg_ChatOtherToSelfOffline()
    NetManager:Get():Send(OldMsgID.GET_OFFLINE_CHAT_REQ, "")
    print("如果没回508，就代表没有离线消息")
end

function FriendSubsystem:Notify_ChatOtherToSelfOffline(data)
    --如果没回508，就代表没有离线消息
    ---@type SC_OfflineChat
    local msg = assert(Dll_PB.decode("OfflineChat", data))

    print(ProtoMsgHelp.block(msg))

    ChatDataManager:Get():AddMultiChatMsgByType(ChatType.Private, msg.chatList)

    UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitPrivateList, -1)
end

--------------请求玩家信息----------------
function FriendSubsystem:SendMsg_GetPlayerInfo(playerId)
    --print("  FriendSubsystem:SendMsg_GetPlayerInfo    ",debug.traceback())
    --local reqData = {
    --    playerId = playerId,
    --}
    --local reqBytes = assert(Dll_PB.encode("getPlayerInfoReq", reqData))
    --
    --local url, jsonStr = FriendDataManager:Get():GetUrl(OldMsgID.GET_PLAYER_INFO_REQ, reqBytes)
    --NetManager:Get():SendHttpPost_Json(url, function(data)
    --    FriendSubsystem:Get():RecvMsg_GetPlayerInfo(data)
    --end, function(code)
    --    print("sendHttpError.......code:  " .. tostring(code))
    --end, jsonStr)
end

function FriendSubsystem:RecvMsg_GetPlayerInfo(data)
    ---@type SC_getPlayerInfoRes
    local msg = assert(Dll_PB.decode("getPlayerInfoRes", data))
    print(ProtoMsgHelp.block(msg))

    --UIManager:Get():ClosePopup()--关闭好友黑名单pop
    SkipModuleHelper:Get():ToPlayerOtherInfoView(msg, true)
end

local __subsystem = FriendSubsystem()
---@return FriendSubsystem
function FriendSubsystem:Get()
    return __subsystem
end
return __subsystem