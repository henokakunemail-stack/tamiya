function FriendListView:InitFriendApplyBtn()

    self. BtnRefuse = CommonHelper:HButtonSetCallback("BtnRefuse", self.gameObject, function(data)
       -- FriendSubsystem:Get():SendMsg_DueRequest(FriendDueRequestType.All, FriendApplyType.Defuse)
    end)

    self. BtnAgree = CommonHelper:HButtonSetCallback("BtnAgree", self.gameObject, function(data)
       -- FriendSubsystem:Get():SendMsg_DueRequest(FriendDueRequestType.All, FriendApplyType.Agree)
    end)

end

function FriendListView:InitApplyFriendInfo()
    local requestCount = FriendDataManager:Get():GetRequestFriendCount()
    CommonHelper:SetText("###FriendApplyCountText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), requestCount, CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, GlobalValueKey.FriendApplyMax).varval))
    CommonHelper:SetGameObjectActive("NoFriendApplyText", self.gameObject, requestCount <= 0)
    CommonHelper:SetHButtonClick(self.BtnRefuse, false, true)
    CommonHelper:SetHButtonClick(self. BtnAgree, false, true)
end