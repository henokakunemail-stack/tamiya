---@class RoomInvitePopView:ViewBase
RoomInvitePopView = class("RoomInvitePopView", ViewBase)

function RoomInvitePopView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RoomInvitePopViewAction")
end

function RoomInvitePopView:Awake()
    self:CacheViewData()
    self:InitChatViewBtn()
end

function RoomInvitePopView:CacheViewData()
    ---@type SC_FriendChatRes @再加一个friendId
    self.userData = nil
end

function RoomInvitePopView:InitViewInfo()
    self. userData = InviteDataManager:Get():GetInviteMsgByIdxType(ChatInviteType.RaceRoom, nil)

    CommonHelper:SetPlayerIcon("PlayerIcon60", self.gameObject, CommonHelper:GetPlayerIconById(self.userData:GetPlayerIcon()), CommonHelper:GetPlayerIconById(self.userData:GetPlayerIconFrame(),nil,HeadIconAttrType.Frame), nil,UIModuleID.RoomInvite)
    CommonHelper:SetText("###PlayerNameText", self.gameObject, self. userData:GetName())
end

function RoomInvitePopView:InitChatViewBtn()
    self.BtnAgree = CommonHelper:HButtonSetCallback("BtnAgree", self.gameObject, function(param)
        CommonHelper:SetUnlockFunc({ GameFunction.RaceRoom },function()
            UIManager:Get():ClosePopup()

            local isHavePW = self.userData:GetInvitation().pwd == "true"
            SkipModuleHelper:Get():ToRaceRoomDetail(tonumber(self.userData:GetInvitation().id), isHavePW)

            InviteDataManager:Get():RemoveInviteMsgByIdxType(ChatInviteType.RaceRoom, nil)
        end,function()
            UIManager:Get():ClosePopup()
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RoomInviteLevelNotEnough))
        end)
    end)

    self.BtnRefuse = CommonHelper:HButtonSetCallback("BtnRefuse", self.gameObject, function(param)
        if FriendDataManager:Get():IsBlackListPlayer(self.userData:GetSendId()) then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InBackListCannotPrivateChat))
        else
            UIManager:Get():ClosePopup()

            InviteDataManager:Get():RemoveInviteMsgByIdxType(ChatInviteType.RaceRoom, nil)
            --
            FriendSubsystem:Get():SendMsg_PrivateChatToOther(self.userData:GetSendId(), CommonHelper:GetTempStr_Default(TemplateStringID.RefuseInvite), ChatOrLinkType.Link)
            --
            CommonHelper:OpenInvitePopView()
        end
    end)

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
        InviteDataManager:Get():RemoveInviteMsgByIdxType(ChatInviteType.RaceRoom, nil)
        CommonHelper:OpenInvitePopView()
    end)

end

function RoomInvitePopView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RoomInvite)
end






