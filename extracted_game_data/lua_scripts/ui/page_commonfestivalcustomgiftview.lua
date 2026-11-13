---@class Page_CommonFestivalCustomGiftView
---定制自选礼包

Page_CommonFestivalCustomGiftView = class("Page_CommonFestivalCustomGiftView")

local titleBtnTag = 1
function Page_CommonFestivalCustomGiftView:initialize(parentPref)
    self.parentPref = parentPref
    self.RightSVC = UIUtil.GetTypeChildWightByParent("ChooseRightSVC", self.parentPref, typeof(MoreRowScrollView))

    self._tagData = { "", "", "", "" }

end

function Page_CommonFestivalCustomGiftView:RefreshCustomGiftInfo()
    self.designgift = ClientDataManager:Get():GetDataTable(ConfigNames.dictdesigngift_config)
    self.AllGiftData = CommonFestivalDataManager:Get():GetCustomGiftData()
    self.ChooseLabel = self.AllGiftData[titleBtnTag]
    self:RefreshLeftInfo(self.ChooseLabel)
    self._tagData = { "", "", "", "" }
    self:RefreshRightInfo(0)

    CommonHelper:HButtonSetCallback("BtnLocking", self.parentPref, function(data)
        if self:GetBuyState() then
            local buyStr = ""
            for i, v in pairs(self._tagData) do
                local v_data = stringSplit(v, ':')
                buyStr = buyStr .. v_data[1] .. ":"
            end
            buyStr = string.sub(buyStr, 1, #buyStr - 1)

            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalTipsLockedTxt))
                if ret == MessageBoxHelp.BtnType.OK then
                    local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.CustomGift)
                    CommonFestivalSubSystem:SendMsg_LockDesign(self.ChooseLabel.itemId, actID, buyStr)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalCustomGiftErrText))
        end
    end)

  local  BtnBuy= CommonHelper:HButtonSetCallback("BtnBuy", self.parentPref, function(data)
        if CommonFestivalDataManager:Get():CommonFestivalGetCustomGiftLockState(titleBtnTag) then

            local buyStr = ""
            for i, v in pairs(self._tagData) do
                local v_data = stringSplit(v, ':')
                buyStr = buyStr .. v_data[1] .. ":"
            end
            buyStr = string.sub(buyStr, 1, #buyStr - 1)

            CommonHelper:ChargeMoneyByID(self.ChooseLabel.itemId, buyStr)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalCustomGiftErrLockText))
        end
    end)
    CommonHelper:SetBtnIsRmbOrToken(BtnBuy,CommonHelper:GetChargeCfgByAreaAndItemId(self.ChooseLabel.itemId))
    CommonHelper:SetNewLineText("###ShowText", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalCustomGifShowText))

    local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.CustomGift)
    local t_beginTime, t_endTime = CommonFestivalDataManager:Get():GetActTime(actID)
    local _beginTime = CommonHelper:ConvertIntToDataTime(t_beginTime * 1000)
    local _endTime = CommonHelper:ConvertIntToDataTime(t_endTime * 1000)
    CommonHelper:SetText("###time", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
                    _beginTime.Month, _beginTime.Day, _beginTime.Hour, _beginTime.Minute,
                    _endTime.Month, _endTime.Day, _endTime.Hour, _endTime.Minute))

    CommonHelper:SetText("BtnLocking/###text", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalBtnLockTxt))
    CommonHelper:SetText("BtnLocked/###text", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalBtnLockedTxt))

end

function Page_CommonFestivalCustomGiftView:RefreshLeftInfo(msg)
    for i, v in pairs(self.AllGiftData) do
        local btnTitle = CommonHelper:HButtonSetCallback("BtnTitle_" .. i, self.parentPref, function(data)
            titleBtnTag = i
            self.ChooseLabel = v
            self._tagData = { "", "", "", "" }
            CommonHelper:SetGameObjectActive("BtnChoose", self.parentPref, false)
            self:RefreshLeftInfo(v)
            self:RefreshRightInfo(0)

        end)

        CommonHelper:SetGameObjectActive("bgShow", btnTitle.gameObject, titleBtnTag == i)
        CommonHelper:SetGameObjectActive("###text1", btnTitle.gameObject, titleBtnTag == i)
        CommonHelper:SetGameObjectActive("###text2", btnTitle.gameObject, titleBtnTag ~= i)

        local BtnBuyNum = CommonHelper:GetChargeCfgByAreaAndItemId(self.AllGiftData[titleBtnTag].itemId)
        CommonHelper:SetText("BtnBuy/###priceText", self.parentPref, BtnBuyNum.pricename)

    end

    self.giftData = self.designgift.GetDataById(msg.itemId)

    if msg.ifbuy == 1 then

        for i, v in pairs(self._tagData) do
            local ItemComObj = UIUtil.GetChild("ItemComLeft_" .. i, self.parentPref)
            local leftBtn = CommonHelper:HButtonSetCallback("BtnLeft_" .. i, self.parentPref, function(data)
                self.ArightTag = i
                self.rightTag = -1

                CommonHelper:SetGameObjectActive("BtnChoose", self.parentPref, true)
                self:RefreshRightInfo(i)
            end)

            leftBtn.gameObject:SetActive(true)
            local leftAddObj = UIUtil.GetChild("leftAdd_" .. i, self.parentPref)

            if v == "" then
                ItemComObj.gameObject:SetActive(false)
                leftAddObj.gameObject:SetActive(true)
            else
                ItemComObj.gameObject:SetActive(true)
                leftAddObj.gameObject:SetActive(false)

                local v_data = stringSplit(v, ':')
                local param = Param_ItemArticleParam()
                param.count = tonumber(v_data[2])
                CommonHelper:SetItemComGroup(ItemComObj, UIModuleID.CommonFestivalTwo, tonumber(v_data[1]), param, function(btnData)
                end, tonumber(v_data[1]))

            end
        end

        CommonHelper:SetGameObjectActive("BtnBuy", self.parentPref, true)
        CommonHelper:SetGameObjectActive("BtnLocking", self.parentPref, true)
        CommonHelper:SetGameObjectActive("BtnLocked", self.parentPref, false)

    elseif msg.ifbuy == 2 then
        for i = 1, 4 do
            local Itemobj = UIUtil.GetChild("ItemComLeft_" .. i, self.parentPref)
            Itemobj:SetActive(true)
            local param = Param_ItemArticleParam()
            param.count = tonumber(msg.awardNum[i])
            CommonHelper:SetItemComGroup(Itemobj, UIModuleID.CommonFestivalTwo, tonumber(msg.awardId[i]), param, function(btnData)
            end, tonumber(msg.awardId[i]))

            local Btnobj = UIUtil.GetChild("BtnLeft_" .. i, self.parentPref)
            Btnobj:SetActive(false)
            local leftAddObj = UIUtil.GetChild("leftAdd_" .. i, self.parentPref)
            leftAddObj:SetActive(false)
        end

        self:RefreshRightInfo(0)

        CommonHelper:SetGameObjectActive("BtnBuy", self.parentPref, true)
        CommonHelper:SetGameObjectActive("BtnLocking", self.parentPref, false)
        CommonHelper:SetGameObjectActive("BtnLocked", self.parentPref, true)
    else

        for i = 1, 4 do
            local Itemobj = UIUtil.GetChild("ItemComLeft_" .. i, self.parentPref)
            Itemobj:SetActive(true)
            local param = Param_ItemArticleParam()
            param.count = tonumber(msg.awardNum[i])
            CommonHelper:SetItemComGroup(Itemobj, UIModuleID.CommonFestivalTwo, tonumber(msg.awardId[i]), param, function(btnData)
            end, tonumber(msg.awardId[i]))

            local Btnobj = UIUtil.GetChild("BtnLeft_" .. i, self.parentPref)
            Btnobj:SetActive(false)
            local leftAddObj = UIUtil.GetChild("leftAdd_" .. i, self.parentPref)
            leftAddObj:SetActive(false)
        end

        self:RefreshRightInfo(0)

        CommonHelper:SetGameObjectActive("BtnBuy", self.parentPref, false)
        CommonHelper:SetGameObjectActive("BtnLocking", self.parentPref, false)
        CommonHelper:SetGameObjectActive("BtnLocked", self.parentPref, false)
    end

end

function Page_CommonFestivalCustomGiftView:RefreshRightInfo(ID)
    if ID == 0 then
        self.RightSVC.gameObject:SetActive(false)
        CommonHelper:SetGameObjectActive("BtnChoose", self.parentPref, false)
    else
        self.RightSVC.gameObject:SetActive(true)

        local chooseData = { }
        local chooseDataNum = { }
        for i, v in pairs(self.giftData) do
            if v.gridno == ID then
                chooseData = stringSplit(v.giftids, ':')
                chooseDataNum = stringSplit(v.giftnums, ':')
            end
        end

        local UpdateFunc = function(dataIndex, itemObj, scroll)
            local obj = UIUtil.GetChild("ItemCom", itemObj)
            local param = Param_ItemArticleParam()
            param.count = tonumber(chooseDataNum[dataIndex + 1])
            CommonHelper:SetItemComGroup(obj, UIModuleID.CommonFestivalTwo, tonumber(chooseData[dataIndex + 1]), param, function(btnData)
            end, tonumber(chooseData[dataIndex + 1]))

            CommonHelper:HButtonSetCallback("ItemBtns", itemObj, function(data)
                self.rightTag = data.intData
                self:RefreshRightInfo(self.ArightTag)
            end, dataIndex)

            CommonHelper:SetGameObjectActive("chooseShow", itemObj, self.rightTag == dataIndex)
            local MaskState = self:GetMaskState(chooseData[dataIndex + 1], ID)
            CommonHelper:SetGameObjectActive("chooseMask", itemObj, MaskState)

        end

        CommonHelper:InitMoreRowScrollView(self.RightSVC, #chooseData, 3, UpdateFunc, true,
                function()
                end, false)

        CommonHelper:SetGameObjectActive("BtnChoose", self.parentPref, true)
        CommonHelper:HButtonSetCallback("BtnChoose", self.parentPref, function(data)
            for i, v in pairs(self._tagData) do
                if i == ID and self.rightTag > -1 then
                    self._tagData[i] = chooseData[self.rightTag + 1] .. ":" .. chooseDataNum[self.rightTag + 1]
                end
            end
            self:RefreshLeftInfo(self.ChooseLabel)
            self:RefreshRightInfo(self.ArightTag)
        end)
    end

end

function Page_CommonFestivalCustomGiftView:GetBuyState()
    for i, v in pairs(self._tagData) do
        if v == "" then
            return false
        end
    end

    return true
end

function Page_CommonFestivalCustomGiftView:GetMaskState(chooseData, ID)
    for i, v in pairs(self._tagData) do
        if i == ID then
            local _maskData = { }
            _maskData = stringSplit(v, ':')

            if self.rightTag ~= nil and _maskData[1] == chooseData then
                return true
            else
                return false
            end
        end
    end

end
