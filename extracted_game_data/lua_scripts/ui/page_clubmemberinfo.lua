---@class Page_clubmember_setup
PageClubMemberInfo = class("PageClubMemberInfo")

function PageClubMemberInfo:initialize()

end

function PageClubMemberInfo:InitData(parentPref, uiModuleID)
    self.parentPref = parentPref.gameObject
    self.parentPrefCanvas = parentPref
    self.uiModuleID = uiModuleID
    self:CacheViewData()
end
function PageClubMemberInfo:closeParentPref()
    UIUtil.ShowCanvasGroup(self.parentPrefCanvas, false)
end

function PageClubMemberInfo:CacheViewData()
    self.MemberInfo = nil
end

function PageClubMemberInfo:InitViewInfo(clubData,memberInfo,pos)

    self.MemberInfo = memberInfo
    local image = UIUtil.GetTypeChildWightInputPath("InfoParent", self.parentPref, typeof(Image))
    --image.transform.position = Vector3(pos.x + 180 , pos.y,pos.z)
    image.transform.position = pos
    local BtnSetPresident = CommonHelper:HButtonSetCallback("SetPresidentBtn", self.parentPref, function(param)
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.ClubSetPresident))
            if ret == MessageBoxHelp.BtnType.OK then
                ClubSubsystem:Get():SendMsg_GuildChangePresident(memberInfo:GetPlayerId(), ClubMemberPosition.President)
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        UIUtil.ShowCanvasGroup(self.parentPrefCanvas, false)
    end)

    local BtnSetManager = CommonHelper:HButtonSetCallback("SetManagerBtn", self.parentPref, function(param)
        ClubSubsystem:Get():SendMsg_GuildChangePosition(memberInfo:GetPlayerId(), ClubMemberPosition.Manager)
        UIUtil.ShowCanvasGroup(self.parentPrefCanvas, false)
    end)

    local AddFriendBtn = CommonHelper:HButtonSetCallback("AddFriendBtn", self.parentPref, function(param)
        if FriendDataManager:Get():IsCanAddFriend() then
            FriendSubsystem:Get():SendMsg_AddFriends(memberInfo:GetPlayerId())
        else
            CommonTipsHelper:ShowCenterTips("好友人数已达上限")
        end
        UIUtil.ShowCanvasGroup(self.parentPrefCanvas, false)
    end)
    local BtnSetOrdinary = CommonHelper:HButtonSetCallback("BtnSetOrdinary", self.parentPref, function(param)
        ClubSubsystem:Get():SendMsg_GuildChangePosition(memberInfo:GetPlayerId(), ClubMemberPosition.RankAndFile)
        UIUtil.ShowCanvasGroup(self.parentPrefCanvas, false)
    end)

    local InfoBtn = CommonHelper:HButtonSetCallback("InfoBtn", self.parentPref, function(param)
        --CommonTipsHelper:Get():ShowCenterTips("功能未开启，敬请期待")
        PersonalHomeSubsystem:Get():SendLookHomeInfo(memberInfo:GetPlayerId())
        UIUtil.ShowCanvasGroup(self.parentPrefCanvas, false)
    end)

    local BtnKick = CommonHelper:HButtonSetCallback("KickBtn", self.parentPref, function(param)
        local boxFunc = function()
            local ret = MessageBoxHelp:Get():OpenBox_OKCancel(nil, CommonHelper:GetTempStr_Default(TemplateStringID.ClubKickMem))
            if ret == MessageBoxHelp.BtnType.OK then
                ClubSubsystem:Get():SendMsg_GuildKickMember(memberInfo:GetPlayerId())
            end
        end
        MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        UIUtil.ShowCanvasGroup(self.parentPrefCanvas, false)
    end)


    ---@type dictguildprivilege_config

    local cell = CommonHelper:GetTableDataByID(ConfigNames.dictguildprivilege_config, ClubDataManager:Get():GetCurSelectClubData():GetSelfPosition())
    local list = stringSplitToNumber(cell.privs, ':')
    local isChangeMemPos = false
    local isKickClubMember = false
    for i = 1, #list do
        if tonumber(list[i]) == ClubMemAuthorId.ChangeMemPos then
            isChangeMemPos = true
        elseif tonumber(list[i]) == ClubMemAuthorId.KickClubMember then
            isKickClubMember = true;
        end
    end

    -- 会长      0 转让会长 1设置副会长 3查看详情  4加好友 5 踢出工会
    -- 副会长    0 查看详情 1加好友 2踢出工会
    -- 成员      0 查看详情 1加好友

    --改变成员等级权限
    --升为管理
    CommonHelper:SetHButtonClick(BtnSetManager,  memberInfo:GetPosition() < ClubMemberPosition.Manager and isChangeMemPos, true)
    --降为成员
    CommonHelper:SetHButtonClick(BtnSetOrdinary,  memberInfo:GetPosition() == ClubMemberPosition.Manager and isChangeMemPos, true)
    --转让会长(俱乐部)
    CommonHelper:SetHButtonClick(BtnSetPresident,  clubData:GetSelfPosition() == ClubMemberPosition.President and memberInfo:GetPosition() ~= ClubMemberPosition.President and isChangeMemPos, true)
    --踢人
    isKickClubMember = isKickClubMember and memberInfo:GetPosition() < ClubMemberPosition.Manager
    CommonHelper:SetHButtonClick(BtnKick,  isKickClubMember, true)

    --除了自己都可以加好友
    CommonHelper:SetHButtonClick(AddFriendBtn,  memberInfo:GetPlayerId() ~= tostring(PlayerDataManager:Get():GetPlayerRID()), true)

end
