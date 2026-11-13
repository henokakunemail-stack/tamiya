function FriendListView:InitFriendListBtn()

    self. GetAllBtn = CommonHelper:HButtonSetCallback("BtnGetAll", self.gameObject, function(data)
        FriendSubsystem:Get():SendMsg_GetFriendHeart(FriendSendHeartType.All)
    end)
    self. GiveAllBtn = CommonHelper:HButtonSetCallback("BtnGiveAll", self.gameObject, function(data)
        FriendSubsystem:Get():SendMsg_SendFriendHeart(FriendSendHeartType.All)
    end)

    self. BtnBlack = CommonHelper:HButtonSetCallback("BtnBlack", self.gameObject, function(data)
        FriendDataManager:Get():SetFriendType(FriendType.BlackList)
        FriendSubsystem:Get():SendMsg_GetBlackFriends()
    end)

end

function FriendListView:InitFriendListInfo()
    ---@type dictcalc_config
    local globalvalue_config = ClientDataManager:Get():GetDataTable(ConfigNames.dictcalc_config)
    local friendCount = FriendDataManager:Get():GetFriendListCount()
    CommonHelper:SetText("###FriendCountText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), friendCount, globalvalue_config.GetById(GlobalValueKey.FriendMax).varval))

    --local heartCount = PlayerDataManager:Get():GetCurrency(CurrencyType.FriendShip)
    local heartCount = KnapsackDataManager:Get():GetArticleCountByCfgid(CurrencyType.FriendShip)
    CommonHelper:SetText("###FriendlyCountText", self.gameObject, tostring(heartCount))
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.FriendGoodMax)
    CommonHelper:SetText("###GetLimitCountText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), FriendDataManager:Get():GetReceiveHeartCount(),tonumber(cfg.varval)))

    CommonHelper:SetGameObjectActive("NoFriendText", self.gameObject, FriendDataManager:Get():GetFriendListCount() <= 0)

    --CommonHelper:SetHButtonClick(self.GetAllBtn, FriendDataManager:Get():GetFriendListCount() > 0, true)
end

---@param friendManagerType FriendManagerType
function FriendListView:InitFriendList(friendManagerType,isRefresh)

    local count = FriendDataManager:Get():GetFriendCountByType(friendManagerType)

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type FriendData
        local friendData = FriendDataManager:Get():GetFriendListByIndexType(friendManagerType, dataIndex + 1)
        CommonHelper:SetPlayerIcon("PlayerIcon100", itemObj, CommonHelper:GetPlayerIconById(tonumber(friendData:GetPlayerIcon())), CommonHelper:GetPlayerIconById(tonumber(friendData:GetPlayerIconFrame()),nil,HeadIconAttrType.Frame), nil, UIModuleID.Friend, friendData:GetLeaveTime() > 0)

        CommonHelper:SetText("###PlayerLevelText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.StrStr), "Lv", tostring(friendData:GetPlayerLV())))
        CommonHelper:SetText("###PlayerNameText", itemObj, tostring(friendData:GetPlayerName()))
        CommonHelper:SetText("###PlayerServerText", itemObj, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ServerTip), tostring(friendData:GetServerName())))

        local score = friendData:GetRankScore() == nil and 0 or friendData:GetRankScore()
        ---@type qualifyingrank_config_cell
        local cfg = CommonHelper:GetRankCfgByScore(score)
        CommonHelper:SetRankIconGroup("rankicon_s_1", itemObj, cfg)

        CommonHelper:SetGameObjectActive("TogOnLine/hover", itemObj, friendData:GetLeaveTime() == -1)
        CommonHelper:SetText("###LeaveTimeText", itemObj, CommonHelper:SetLeaveTime(friendData:GetLeaveTime()))

        local GetAndSendBtn = CommonHelper:HButtonSetCallback("GetAndSendBtn", itemObj, function(param)
            FriendSubsystem:Get():SendMsg_GetFriendHeart(friendData:GetPlayerId())
            FriendSubsystem:Get():SendMsg_SendFriendHeart(friendData:GetPlayerId())
        end)

        local PersonalHomeBtn = CommonHelper:HButtonSetCallback("PersonalHomeBtn", itemObj, function(param)
            PersonalHomeSubsystem:Get():SendLookHomeInfo(friendData:GetPlayerId())
        end)

        local SendBtn = CommonHelper:HButtonSetCallback("SendBtn", itemObj, function(param)
            FriendSubsystem:Get():SendMsg_SendFriendHeart(friendData:GetPlayerId())
        end)

        local GetBtn = CommonHelper:HButtonSetCallback("GetBtn", itemObj, function(param)
            FriendSubsystem:Get():SendMsg_GetFriendHeart(friendData:GetPlayerId())
        end)

        CommonHelper:HButtonSetCallback("ChatBtn", itemObj, function(param)
            if FriendDataManager:Get():IsBlackListPlayer(friendData:GetPlayerId()) then
                CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.InBackListCannotPrivateChat))
            else
                self:OnChatBtnClick(friendData)
            end
        end)
        --关闭私聊按钮跳转
        --CommonHelper:SetGameObjectActive("ChatBtn", itemObj,false)

        local AddFriendBtn = CommonHelper:HButtonSetCallback("AddFriendBtn", itemObj, function(param)
            --if friendData:GetPlayerLV() < CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, UnlockID.Friend).level then
            --    CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.OtherFriendLocked))
            --else
            if FriendDataManager:Get():IsCanAddFriend() then
                FriendSubsystem:Get():SendMsg_AddFriends(friendData:GetPlayerId())
            else
                CommonTipsHelper:ShowCenterTips("好友人数已达上限")
            end
            --end
        end)

        local DeleteBtn = CommonHelper:HButtonSetCallback("DeleteBtn ", itemObj, function(param)
            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.IsDelFriend))
                if ret == MessageBoxHelp.BtnType.OK then
                    --FriendDataManager:Get():SetFriendType(FriendType.DelFriendInChatPlayerInfo)
                    FriendSubsystem:Get():SendMsg_DelFriends(friendData:GetPlayerId())
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end)

        local AgreeBtn = CommonHelper:HButtonSetCallback("AgreeBtn", itemObj, function(param)
            if FriendDataManager:Get():IsCanAddFriend() then
                FriendSubsystem:Get():SendMsg_DueRequest(friendData:GetPlayerId(), FriendApplyType.Agree)
            else
                CommonTipsHelper:ShowCenterTips("好友人数已达上限")
            end
        end)

        local RefuseBtn = CommonHelper:HButtonSetCallback("RefuseBtn", itemObj, function(param)
            FriendSubsystem:Get():SendMsg_DueRequest(friendData:GetPlayerId(), FriendApplyType.Defuse)
        end)

        local BtnLendLookPart = CommonHelper:HButtonSetCallback("BtnLendLookPart", itemObj, function(param)
            --print("--530, --请求好友租借配件 P2=好友rid --", friendData:GetPlayerId())
            RentAndLendSubsystem:Get():SendMsg_FriendParts(friendData:GetPlayerId())
        end)
        local BtnRentLookPart = CommonHelper:HButtonSetCallback("BtnRentLookPart", itemObj, function(param)
            --print("--544, --请求好友雇佣配件 P2=好友rid --", friendData:GetPlayerId())
            RentAndLendSubsystem:SendMsg_FriendHire(friendData:GetPlayerId())
        end)
        CommonHelper:SetGameObjectActive("BtnRentLookPart",itemObj, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Rent))
        CommonHelper:SetGameObjectActive("BtnLendLookPart", itemObj, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Lend))


        CommonHelper:SetGameObjectActive("FriendListBtn", itemObj, friendManagerType == FriendManagerType.Friend)
        self:InitScrollItem(friendData, GetAndSendBtn, SendBtn, GetBtn, friendManagerType == FriendManagerType.Friend)

        CommonHelper:SetHButtonClick(AddFriendBtn, friendData:GetIfAdd() ~= FriendAddType.Friend and (friendManagerType == FriendManagerType.AddFriend or friendManagerType == FriendManagerType.SearchList), true)
        CommonHelper:SetHButtonClick(DeleteBtn, friendData:GetIfAdd() == FriendAddType.Friend, true)

        CommonHelper:SetHButtonClick(AgreeBtn, friendManagerType == FriendManagerType.Request, true)
        CommonHelper:SetHButtonClick(RefuseBtn, friendManagerType == FriendManagerType.Request, true)

        CommonHelper:SetHButtonClick(BtnLendLookPart, friendManagerType == FriendManagerType.RentAndLend, true)
        CommonHelper:SetHButtonClick(BtnRentLookPart, friendManagerType == FriendManagerType.RentAndLend, true)

        CommonHelper:HButtonSetCallback("ViewDetailBtn", itemObj, function(param)

            FriendSubsystem:Get():SendMsg_GetPlayerInfo(friendData:GetPlayerId())
        end)
    end
    if isRefresh then
        CommonHelper:InitMoreRowScrollView(self.FriendListScrollView, count, 1, UpdateFunc, false,nil,false)
    else
        CommonHelper:InitMoreRowScrollView(self.FriendListScrollView, count, 1, UpdateFunc, true)
    end

end

---@param friendData FriendData
function FriendListView:InitScrollItem(friendData, GetAndSendBtn, SendBtn, GetBtn, isInit)
    if isInit == false then
        return
    end

    local isSendMe = FriendDataManager:Get():IsSendMe(friendData:GetPlayerId())
    local isGive = FriendDataManager:Get():IsGive(friendData:GetPlayerId())
    local isRecv = FriendDataManager:Get():IsRecv(friendData:GetPlayerId())
    --if isSendMe == true and isGive == false and isRecv == false then
    --    CommonHelper:SetHButtonClick(GetAndSendBtn, true, true)
    --else
    CommonHelper:SetHButtonClick(GetAndSendBtn, false, true)
    -- end

    if isSendMe == true  and isRecv == false then
        CommonHelper:SetHButtonClick(GetBtn, true, true)
    else
        CommonHelper:SetHButtonClick(GetBtn, false, true)
    end

    if isSendMe == false and isGive == false and isRecv == false then
        CommonHelper:SetHButtonClick(SendBtn, true, true)
    else
        CommonHelper:SetHButtonClick(SendBtn, false, true)
    end
end

function FriendListView:InitRedPointInfo()
    --CommonHelper:SetGameObjectActive("RedPointModule", self.TogFriendList.gameObject, FriendDataManager:Get():IsHaveRedPoint_List())
    --CommonHelper:SetGameObjectActive("RedPointModule", self.TogApplyFriend.gameObject, FriendDataManager:Get():IsHaveRedPoint_Apply())
end



