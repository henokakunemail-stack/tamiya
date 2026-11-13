---@type FriendSearchType
local _friendSearchType = FriendSearchType.Name
function FriendListView:InitFriendAddBtn()

    self.BtnSearch = CommonHelper:HButtonSetCallback("BtnSearch", self.gameObject, function(data)
        self:OnSearchFriendBtnClick()
    end)

    CommonHelper:InputFieldOnEndEdit(self.SearchInputField, function(str)
        if CommonHelper:IsNullOrEmpty(str) then
            UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendInfo, FriendManagerType.AddFriend)
        end
    end)

    CommonHelper:InitDropDown(self.DropDown, 2, function(uiDropDown, item, index)
        local str = index == 0 and CommonHelper:GetTempStr_Default(TemplateStringID.SearchFriendByName) or CommonHelper:GetTempStr_Default(TemplateStringID.SearchFriendByID)
        CommonHelper:SetText("###Text", item, str)
    end, function(int)
        _friendSearchType = int == 0 and FriendSearchType.Name or FriendSearchType.ID
        CommonHelper:InputFieldSetValue(self.SearchInputField, "")
        self:SetDropDownInfo()
    end,FriendSearchType.Name-1)
    _friendSearchType=FriendSearchType.Name
    local str = CommonHelper:GetTempStr_Default(TemplateStringID.SortByTime)
    CommonHelper:SetText("###roottext", self.SortPanelDropDown.gameObject, str)
    CommonHelper:InitDropDown(self.SortPanelDropDown, 2, function(uiDropDown, item, index)
        local str = index == 1 and CommonHelper:GetTempStr_Default(TemplateStringID.FriendSortLv) or CommonHelper:GetTempStr_Default(TemplateStringID.FriendSortTime)
        CommonHelper:SetText("Text", item, str)
    end, function(int)
        FriendDataManager:Get():SortFriend(int + 1)
        UINotify:Get():SendNotification(UINotifyEvent.FriendListView_InitFriendList, { FriendManagerType.Friend})
        local str = int + 1 == FriendSortType.Time and CommonHelper:GetTempStr_Default(TemplateStringID.SortByTime) or CommonHelper:GetTempStr_Default(TemplateStringID.SortByLv)
        CommonHelper:SetText("###roottext", self.SortPanelDropDown.gameObject, str)
    end)
end

----搜索好友按钮
function FriendListView:OnSearchFriendBtnClick()
    local searchFriendName = CommonHelper:InputFieldGetValue(self.SearchInputField)
    if CommonHelper:IsNullOrEmpty(searchFriendName) then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PlayerNameCannotBeNull))
    else
        FriendSubsystem:Get():SendMsg_SearchFriends(searchFriendName, _friendSearchType)
        CommonHelper:InputFieldSetValue(self.SearchInputField, "")
    end
end

function FriendListView:InitAddFriendInfo(friendManagerType)
    if friendManagerType == FriendManagerType.AddFriend then
        self:SetDropDownInfo()
        CommonHelper:InputFieldSetValue(self.SearchInputField, "")
        CommonHelper:SetText("###FriendAddText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.FriendCommand))
    elseif friendManagerType == FriendManagerType.SearchList then
        CommonHelper:SetText("###FriendAddText", self.gameObject, CommonHelper:GetTempStr_Default(TemplateStringID.FriendSearch))
    end
end

function FriendListView:SetDropDownInfo()
    local contentType = _friendSearchType == FriendSearchType.Name and InputField.ContentType.Standard or InputField.ContentType.IntegerNumber
    CommonHelper:InputFieldSetContentType(self.SearchInputField, contentType)
    local str = _friendSearchType == FriendSearchType.Name and CommonHelper:GetTempStr_Default(TemplateStringID.SearchFriendByName) or CommonHelper:GetTempStr_Default(TemplateStringID.SearchFriendByID)
    CommonHelper:SetText("###roottext", self.DropDown.gameObject, str)
end






