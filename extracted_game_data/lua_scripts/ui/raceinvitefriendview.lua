---@class RaceInviteFriendView:ViewBase
RaceInviteFriendView = class("RaceInviteFriendView", ViewBase)

function RaceInviteFriendView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceInviteFriendViewAction")
end

function RaceInviteFriendView:Awake()
    self:CacheViewData()
    self:InitViewBtn()
end

function RaceInviteFriendView:CacheViewData()
    self.FriendListScrollView = self:GetChildWight("FriendList", typeof(MoreRowScrollView))
    self.userData = nil
end

function RaceInviteFriendView:InitViewBtn()

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(param)
        UIManager:Get():ClosePopup()
    end)
end

---@param shareType ShareType
function RaceInviteFriendView:InitFriendList(shareType)
    local count = FriendDataManager:Get():GetFriendListCount()
    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type FriendData
        local friendData = FriendDataManager:Get():GetFriendDataByIndex(dataIndex + 1)

        CommonHelper:SetPlayerIcon("PlayerIcon100", itemObj, CommonHelper:GetPlayerIconById(friendData:GetPlayerIcon()), CommonHelper:GetPlayerIconById(friendData:GetPlayerIconFrame(),nil,HeadIconAttrType.Frame), nil, UIModuleID.RoomFriendInvite, friendData:GetLeaveTime() > 0)

        CommonHelper:SetText("###PlayerLevelText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "Lv", tostring(friendData:GetPlayerLV())))
        CommonHelper:SetText("###PlayerNameText", itemObj, tostring(friendData:GetPlayerName()))
        CommonHelper:SetText("###PlayerServerText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ServerTip), tostring(friendData:GetServerName())))

        local score = friendData:GetRankScore() == nil and 0 or friendData:GetRankScore()
        ---@type qualifyingrank_config_cell
        local cfg = CommonHelper:GetRankCfgByScore(score)
        CommonHelper:SetRankIconGroup("rankicon_s_1", itemObj, cfg)

        CommonHelper:SetGameObjectActive("TogOnLine/hover", itemObj, friendData:GetLeaveTime() == -1)
        CommonHelper:SetText("###LeaveTimeText", itemObj, CommonHelper:SetLeaveTime(friendData:GetLeaveTime()))

        local BtnInvite = CommonHelper:HButtonSetCallback("BtnInvite", itemObj, function(param)

            local levelNotEnough = UnlockDataManager:Get():IsUnLockByLevel(GameFunction.RaceRoom,friendData:GetPlayerLV())
            if  friendData:GetLeaveTime() >= 0   then
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FriendRoomInviteUnLine))
            elseif levelNotEnough then
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FriendRoomInviteLevelNotEnough))
            else
                self:OnInviteBtnClick(friendData, shareType)
            end
        end)

        CommonHelper:SetHButtonClick(BtnInvite, shareType == ShareType.RoomInvite or shareType == ShareType.ClubInvite, true)


    end
    CommonHelper:InitMoreRowScrollView(self.FriendListScrollView, count, 1, UpdateFunc, true)

    CommonHelper:SetGameObjectActive("NoFriendText", self.gameObject, count <= 0)
end

---@param friendData FriendData
function RaceInviteFriendView:OnInviteBtnClick(friendData, shareType)
    if shareType == ShareType.RoomInvite then
        if RaceRoomManager:Get():GetPlayerDataByID(friendData:GetPlayerId()) ~= nil then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RaceRoomHaveInRoom))
        else
            ---@type RaceRoomShareData
            local userData = {}
            userData.id = RaceRoomManager:Get():GetID()
            userData.joinNum = RaceRoomManager:Get():GetJoinNum()
            userData.maxNum = RaceRoomManager:Get():GetMaxNum()
            userData.name = RaceRoomManager:Get():GetName()
            userData.pwd = tostring(RaceRoomManager:Get():IsHavePasswd())
            userData.shareType = ShareType.RoomInvite

            if FriendDataManager:Get():IsBlackListPlayer(friendData:GetPlayerId()) then
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InBackListCannotPrivateChat))
            else
                FriendSubsystem:Get():SendMsg_PrivateChatToOther(friendData:GetPlayerId(), Dll_JSON.encode(userData), ChatOrLinkType.Link)
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FriedInviteSuccess))
            end
        end
    elseif shareType == ShareType.ClubInvite then
        local clubData = ClubDataManager:Get():GetCurSelectClubData()
        local userData = {
            icon = clubData:GetIcon(),
            count = clubData:GetMemberCount(),
            name=clubData:GetName(),
            shareType = ShareType.ClubInvite,
            maxCount = clubData:GetMemberMaxCount(),
        }
        if FriendDataManager:Get():IsBlackListPlayer(friendData:GetPlayerId()) then
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InBackListCannotPrivateChat))
        else
            FriendSubsystem:Get():SendMsg_PrivateChatToOther(friendData:GetPlayerId(), Dll_JSON.encode(userData), ChatOrLinkType.Invite)
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.FriedInviteSuccess))
        end
    end
end

function RaceInviteFriendView:OnClose()
    CommonHelper:ReleasePool(UIModuleID.RoomFriendInvite)
end






