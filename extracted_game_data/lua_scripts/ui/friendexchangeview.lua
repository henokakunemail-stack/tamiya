---@class FriendExchangeView : ViewBase
FriendExchangeView = class("LabSelectPopView", ViewBase)

function FriendExchangeView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "FriendExchangeViewAction")

end

local ExchangeNum = { 0, 0, 0, 0 }
local CostNum = { 0, 0, 0, 0 }

function FriendExchangeView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)

    self.InventorySVC = self:GetChildWightByParent("inventorySVC", self.gameObject, typeof(MoreRowScrollView))
    self.ExchangeSVC = self:GetChildWightByParent("exchangeSVC", self.gameObject, typeof(MoreRowScrollView))

    local rightObj = UIUtil.GetChild("titleCoin", self.gameObject)
    local rightParam = Param_ItemArticleParam()
    CommonHelper:SetItemComGroup(rightObj, UIModuleID.FriendExchange, CurrencyType.RentAndLendCoin, rightParam)

    self.allMaxNum = RentAndLendDataManager:Get():GetAllCoinNumData()

end

function FriendExchangeView:OnOpen()
    ---@type dicthirecoin_config
    local dicthirecoin_config = ClientDataManager:Get():GetDataTable(ConfigNames.dicthirecoin_config)
    self.ExchangeData = dicthirecoin_config:GetConfigData()

    self:RefreshSVCData()

    CommonHelper:HButtonSetCallback("BtnExchange", self.gameObject, function(data)
        local exStr, exID = self:GetSendHireCoinStr()
        if exID ~= "" and exStr ~= "" then
            if self:GetCostEnoughNum() then
                local boxFunc = function()
                    local _lockTxt = CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendExchange)
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, _lockTxt)
                    if ret == MessageBoxHelp.BtnType.OK then
                        --print("--560, --请求兑换雇佣货币 P2=待换货币id串 P3=数量串", exStr, exID)
                        RentAndLendSubsystem:Get():SendMsg_HireCoin(exStr, exID)
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendNotEnough))
            end
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendNotChoose))
        end
    end)

    CommonHelper:HButtonSetCallback("BtnReset", self.gameObject, function(data)
        self:SetResetData()
    end)

end

function FriendExchangeView:RefreshSVCData()
    self.allCostNum = RentAndLendDataManager:Get():GetAllGetCoinNumData()
    self.CoinData = RentAndLendDataManager:Get():GetFriendExchangeData()

    self:SetResetData()

end

function FriendExchangeView:SetResetData()
    ExchangeNum = { 0, 0, 0, 0 }
    CostNum = { 0, 0, 0, 0 }
    self:RefreshTitleData()
    self:RefreshExchangeSVCData()
end

function FriendExchangeView:RefreshTitleData()
    CommonHelper:SetText("show/###showNum", self.gameObject,
            string.format("%d/%d", self.allCostNum, self.allMaxNum))
    if self.CoinData[1] and self.CoinData[1]:GetFreshTime() > 0 then

        local _nowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())
        local _freshTime = self.CoinData[1]:GetFreshTime() - _nowTime
        local freshTimeStr = ""
        local DownTime = CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTime)
        local DownTimeSecond = CommonHelper:GetTempStr_Default(TemplateStringID.CommonCountDownTimeSecond)
        local _freshDay = math.modf(_freshTime / TimeSecond_Day)
        local _freshHour = math.modf((_freshTime - (_freshDay * TimeSecond_Day)) / TimeSecond_Hour)
        local _freshMinute = math.modf((_freshTime - (_freshDay * TimeSecond_Day) - (_freshHour * TimeSecond_Hour)) / TimeSecond_Minute)
        local _freshSecond = _freshTime - (_freshDay * TimeSecond_Day) - (_freshHour * TimeSecond_Hour) - (_freshMinute * TimeSecond_Minute)

        if _freshTime / TimeSecond_Day > 1 then
            freshTimeStr = string.format(DownTime, _freshDay, _freshHour, _freshMinute)
        else
            freshTimeStr = string.format(DownTimeSecond, _freshHour, _freshMinute, _freshSecond)
        end

        CommonHelper:SetText("show/###showTime", self.gameObject,
                string.format(CommonHelper:GetTempStr_Default(TemplateStringID.RentAndLendRefreshTime), freshTimeStr))
    end

    CommonHelper:SetGameObjectActive("show/###showTime", self.gameObject, self.CoinData[1] and self.CoinData[1]:GetFreshTime() > 0)

end
------

function FriendExchangeView:RefreshExchangeSVCData()

    local ExchangeFunc = function(dataIndex, itemObj, scroll)
        local left_data = self.ExchangeData[dataIndex + 1]

        -------
        local _upNum = KnapsackDataManager:Get():GetArticleCountByCfgid(left_data.exchcoin)
        CommonHelper:SetText("###upText", itemObj, _upNum)
        CommonHelper:SetText("###downText", itemObj, string.format("-%d", CostNum[dataIndex + 1]))
        local articleCfg = CommonHelper:GetTableDataByID(ConfigNames.article_config, left_data.exchcoin)
        CommonHelper:GetComponentSetUITexture("###coinIcon", itemObj, articleCfg.NewIcon, UIModuleID.FriendExchange)
        -------

        local leftObj = UIUtil.GetChild("leftItem", itemObj)
        local leftParam = Param_ItemArticleParam()
        leftParam.count = left_data.neednum
        CommonHelper:SetItemComGroup(leftObj, UIModuleID.FriendExchange, left_data.exchcoin, leftParam)

        local rightObj = UIUtil.GetChild("rightItem", itemObj)
        local rightParam = Param_ItemArticleParam()
        rightParam.count = 1
        CommonHelper:SetItemComGroup(rightObj, UIModuleID.FriendExchange, CurrencyType.RentAndLendCoin, rightParam)

        CommonHelper:HButtonSetCallback("BtnAdd", itemObj, function(data)
            self:SetExchangeNumAddByID(dataIndex + 1)
            self:SetCostNumByID(dataIndex + 1)

            self:RefreshExchangeSVCData()
        end)

        CommonHelper:HButtonSetCallback("BtnSub", itemObj, function(data)
            self:SetExchangeNumSubByID(dataIndex + 1)
            self:SetCostNumByID(dataIndex + 1)

            self:RefreshExchangeSVCData()
        end)

        CommonHelper:HButtonSetCallback("BtnMIN", itemObj, function(data)
            ExchangeNum[dataIndex + 1] = 1
            self:SetCostNumByID(dataIndex + 1)

            self:RefreshExchangeSVCData()
        end)

        CommonHelper:HButtonSetCallback("BtnMAX", itemObj, function(data)
            self:GetResidueNumByID(dataIndex + 1)
            self:SetCostNumByID(dataIndex + 1)

            self:RefreshExchangeSVCData()
        end)
        if self.CoinData[dataIndex + 1] then
            local _showResidue = self.CoinData[dataIndex + 1]:GetMaxNum() - self.CoinData[dataIndex + 1]:GetExchNum()
            CommonHelper:SetText("###exchangeNum", itemObj,
                    string.format("%d/%d", ExchangeNum[dataIndex + 1], _showResidue))
        end

    end

    CommonHelper:InitMoreRowScrollView(self.ExchangeSVC, #self.ExchangeData, 2, ExchangeFunc, true, nil, false)

end

function FriendExchangeView:SetExchangeNumAddByID(ID)
    ExchangeNum[ID] = ExchangeNum[ID] + 1
    if self.CoinData[ID] then
        local _residue = self.CoinData[ID]:GetMaxNum() - self.CoinData[ID]:GetExchNum()
        if ExchangeNum[ID] >= _residue then
            ExchangeNum[ID] = _residue
        end
    end

end

function FriendExchangeView:SetExchangeNumSubByID(ID)
    ExchangeNum[ID] = ExchangeNum[ID] - 1
    if ExchangeNum[ID] <= 0 then
        ExchangeNum[ID] = 0
    end
end

function FriendExchangeView:SetCostNumByID(ID)
    CostNum[ID] = self.ExchangeData[ID].neednum * ExchangeNum[ID]
end

--总共的
function FriendExchangeView:GetTotalNum()
    local _tNum = 0
    for i, v in pairs(ExchangeNum) do
        _tNum = _tNum + v
    end
    return _tNum
end

--获取剩余数量根据ID
function FriendExchangeView:GetResidueNumByID(ID)
    if self.CoinData[ID] then
        local _residueNum = self.CoinData[ID]:GetMaxNum() - self.CoinData[ID]:GetExchNum()
        if _residueNum > 0 then
            ExchangeNum[ID] = _residueNum
        end
    end
end

function FriendExchangeView:GetCostEnoughNum()
    for i, v in pairs(ExchangeNum) do
        if v ~= 0 then
            local _have = KnapsackDataManager:Get():GetArticleCountByCfgid(self.ExchangeData[i].exchcoin)
            if _have < CostNum[i] then
                return false
            end
        end
    end
    return true
end

function FriendExchangeView:GetSendHireCoinStr()
    local exStr = ""
    local exID = ""
    for i, v in pairs(ExchangeNum) do
        if v ~= 0 then
            exStr = exStr .. self.ExchangeData[i].exchcoin .. ":"
            exID = exID .. ExchangeNum[i] .. ":"
        end
    end

    exStr = string.sub(exStr, 1, #exStr - 1)
    exID = string.sub(exID, 1, #exID - 1)

    return exStr, exID

end

function FriendExchangeView:OnClose()
    ExchangeNum = { 0, 0, 0, 0 }
    CostNum = { 0, 0, 0, 0 }
end