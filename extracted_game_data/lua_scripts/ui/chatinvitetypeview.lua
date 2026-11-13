---@class ChatInviteTypeView:ViewBase
ChatInviteTypeView = class("ChatInviteTypeView", ViewBase)

function ChatInviteTypeView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "ChatInviteTypeViewAction")
end

function ChatInviteTypeView:Awake()
    self:CacheViewData()
    self:InitChatViewBtn()
end

function ChatInviteTypeView:CacheViewData()
    self.userData = ""
end

---@param shareType ShareType
function ChatInviteTypeView:InitViewInfo(shareType, userData,showPos)
    ---这里添加设置位置
    self.shareType = shareType

    self.userData = userData

    self.inviteChild = UIUtil.GetChild("inviteChild", self.gameObject)
    self.ClubShare = UIUtil.GetChild("ClubShare", self.gameObject)
    self.RaceInvite = UIUtil.GetChild("RaceInvite", self.gameObject)
    self.ChallengeMatchInvite = UIUtil.GetChild("ChallengeMatchInvite", self.gameObject)

    --CommonHelper:SetHButtonClick(self.BtnClub, (ClubDataManager:Get():IsHadClub() and shareType ~= ShareType.ClubInvite), true)
    CommonHelper:SetHButtonClick(self.BtnClub, false, true)
   -- CommonHelper:SetHButtonClick(self.ClubShare, false, true)
    CommonHelper:SetHButtonClick(self.BtnPrivate, false, true)
    CommonHelper:SetHButtonClick(self.BtnLocal, false, true)
    CommonHelper:SetGameObjectActive("bg2",self.gameObject,false)
    CommonHelper:SetGameObjectActive("bg1",self.gameObject,true)
    self:ChangeBtnParent(shareType)
    if showPos~=nil  then
        self.ChallengeMatchInvite.transform.position = showPos
        CommonHelper:SetObjRectPos(self.inviteChild,100,-65)--位置做下偏移
    end

end

---@param shareType ShareType
function ChatInviteTypeView:ChangeBtnParent(shareType)
    if shareType == ShareType.ClubInvite then
        UIUtil.SetParentGameObject(self.ClubShare, self.inviteChild)
    elseif shareType == ShareType.RoomInvite then
        UIUtil.SetParentGameObject(self.RaceInvite, self.inviteChild)
    elseif shareType == ShareType.ChallengeMatchInvite then
        UIUtil.SetParentGameObject(self.ChallengeMatchInvite, self.inviteChild)
    end
end

function ChatInviteTypeView:InitChatViewBtn()
    self.BtnWorld = CommonHelper:HButtonSetCallback("BtnWorld", self.gameObject, function(param)
        --ChatSubsystem:Get():SendMsg_PlayerChatReq(ChatType.World, self.userData, ChatOrLinkType.Link)
        if not CommonHelper:CheckPlayerIsNewGuide() then
            --ChatSubsystem:Get():SendMsg_ChatData(ChatType.World, "", 0,self.userData)
            ChatSubsystem:Get():SendMsg_ChatData(ChatType.Invite, "", 0,self.userData)
        else
            ChatSubsystem:Get():SendMsg_ChatData(ChatType.Local, "", 0,self.userData)
        end
        self:OnInviteBtnClick(ChatType.World, nil)
    end)

    self.BtnLocal = CommonHelper:HButtonSetCallback("BtnLocal", self.gameObject, function(param)
        --ChatSubsystem:Get():SendMsg_PlayerChatReq(ChatType.Local, self.userData, ChatOrLinkType.Link)
        ChatSubsystem:Get():SendMsg_ChatData(ChatType.Local, self.userData, 0)
        self:OnInviteBtnClick(ChatType.Local, nil)
    end)

    self.BtnClub = CommonHelper:HButtonSetCallback("BtnClub", self.gameObject, function(param)
        --ChatSubsystem:Get():SendMsg_ClubChat(ChatType.Club, self.userData, ChatOrLinkType.Link)
        ChatSubsystem:Get():SendMsg_ChatData(ChatType.Club, self.userData, 0)
        self:OnInviteBtnClick(ChatType.Club, nil)
    end)

    self.BtnPrivate = CommonHelper:HButtonSetCallback("BtnPrivate", self.gameObject, function(param)
        self:OnInviteBtnClick(ChatType.Club, nil)
        CommonHelper:RoomInvite(ShareType.ClubInvite)
    end)

    CommonHelper:HButtonSetCallback("BtnBack", self.gameObject, function()
        UIManager:Get():ClosePopup()
    end)

end

---@param friendData FriendData
function ChatInviteTypeView:OnInviteBtnClick(chatType, friendData)
    UIManager:Get():ClosePopup()
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.ShareSuccess))
    --UIManager:Get():OpenView("ChatView",CanvasType.MainCanvas,"ChatView")
    --local userdata={}
    --userdata.chatType=chatType
    --userdata.playerId=friendData==nil and -1 or friendData:GetPlayerId()

    --UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitFriendList,friendData:GetPlayerId())
    --UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitTogState,chatType)
    --if not friendData:GetIsReadPrivateMsg()  then
    --    ChatDataManager:Get():ReadSingleChatMsgFromLocalByChatType(ChatType.Private,friendData:GetPlayerId())
    --    friendData:SetIsReadPrivateMsg(true)
    --    FriendDataManager:Get():UpdateFriendData(friendData)
    --end
    --UINotify:Get():SendNotification(UINotifyEvent.ChatView_InitChatScrollList,userdata)
end








