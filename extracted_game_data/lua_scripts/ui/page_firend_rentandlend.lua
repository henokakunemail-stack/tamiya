function FriendListView:InitRentAndLendBtn()

    self.BtnExchange = CommonHelper:HButtonSetCallback("BtnExchange", self.gameObject, function(data)
        RentAndLendSubsystem:Get():SendMsg_HireExchCoin()
    end)

    self.BtnRent = CommonHelper:HButtonSetCallback("BtnRent", self.gameObject, function(data)
        self:OpenFriendRentAndLendView(FriendRentAndLendType.Rent)
    end)

    self.BtnLend = CommonHelper:HButtonSetCallback("BtnLend", self.gameObject, function(data)
        self:OpenFriendRentAndLendView(FriendRentAndLendType.Lend)
    end)

    UINotify:Get():SendNotification(UINotifyEvent.FriendListView_RefreshRentHaveInfo)
end

function FriendListView:InitRentAndLendInfo()
    CommonHelper:SetGameObjectActive("BtnRent", self.gameObject, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Rent))
    CommonHelper:SetGameObjectActive("BtnLend", self.gameObject, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Lend))
    CommonHelper:SetGameObjectActive("BtnExchange", self.gameObject, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Rent))
    CommonHelper:SetGameObjectActive("rentHave", self.gameObject, HVersionManager:GetServerFunctionIsFlag(CdnFunctionKey.Rent))

    ---@type dictcalc_config
    local globalvalue_config = ClientDataManager:Get():GetDataTable(ConfigNames.dictcalc_config)
    local friendCount = FriendDataManager:Get():GetFriendListCount()
    CommonHelper:SetText("###FriendCountText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), friendCount, globalvalue_config.GetById(GlobalValueKey.FriendMax).varval))

    local heartCount = KnapsackDataManager:Get():GetArticleCountByCfgid(CurrencyType.FriendShip)
    CommonHelper:SetText("###FriendlyCountText", self.gameObject, tostring(heartCount))
    ---@type dictcalc_config_cell
    local cfg = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.FriendGoodMax)
    CommonHelper:SetText("###GetLimitCountText", self.gameObject, string.format(CommonHelper:GetTempStr_Default(TemplateStringID.NumComNum), FriendDataManager:Get():GetReceiveHeartCount(), tonumber(cfg.varval)))

    CommonHelper:SetGameObjectActive("NoFriendText", self.gameObject, FriendDataManager:Get():GetFriendListCount() <= 0)

end

function FriendListView:OpenFriendRentAndLendView(_type)
    if _type == FriendRentAndLendType.Rent then
        --print("--552, --查看配件雇佣申请 P2类型 0-我的申请 1-申请我的", 1)
        RentAndLendSubsystem:Get():SendMsg_HireApp(1)
    end

    if _type == FriendRentAndLendType.Lend then
        --print("--538, --查看配件租借申请 P2类型 0-我的申请 1-申请我的", 1)
        RentAndLendSubsystem:Get():SendMsg_BorrowApp(1)
    end
end

function FriendListView:RefreshFriendRentAndLendCostData()
    local RentCostNum = CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config, CommonCfgKey.RentCostNum)
    local rentCostTxt = stringSplitToNumber(RentCostNum.varval, ':')

    local propCfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, rentCostTxt[1])
    CommonHelper:GetComponentSetUITexture("rentHave/RawImage", self.gameObject, propCfg.NewIcon, UIModuleID.FriendChooseProp)

    local rentHaveCount = KnapsackDataManager:Get():GetArticleCountByCfgid(rentCostTxt[1])
    CommonHelper:SetText("rentHave/###RentTxt", self.gameObject, rentHaveCount)
end