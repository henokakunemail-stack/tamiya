---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@class Page_VideoLuckyTableView
Page_VideoLuckyTableView = class("Page_VideoLuckyTableView", Page_WelfareViewBase)

function Page_VideoLuckyTableView:initialize()

end

function Page_VideoLuckyTableView:GetPageName()
    return "Page_VideoLuckyTableView"
end

function Page_VideoLuckyTableView:OnAwake()
    self.ScrollView = UIUtil.GetTypeChildWightInputPath("ScrollView", self.gameObject, typeof(MoreRowScrollView))

    self.cs_RotaryTableAnim = UIUtil.GetTypeChildWightByParent("rewardTransParent", self.gameObject, typeof(CS.RotaryTableAnim))

    self.rewardTransParent = UIUtil.GetChild("rewardTransParent", self.gameObject)
    self.haloEffectTrans = UIUtil.GetChild("haloEffectTrans", self.gameObject)
    WelfareVideoDataManager:Get():InitLuckyTableAwardData()

end

function Page_VideoLuckyTableView:RefreshView()

    local LuckyTableState = WelfareVideoDataManager:Get():GetLuckyTableStateData()

    local maxWatch = LuckyTableState[1]:GetMaxWatch()
    local watchNum = LuckyTableState[1]:GetWatchNum()
    local canUseNum = LuckyTableState[1]:GetCanUseNum()

    CommonHelper:SetText("BtnVideo/###text", self.gameObject, (maxWatch - watchNum) .. "/" .. maxWatch)
    CommonHelper:SetText("###HaveUseNum", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LuckRotaryLotteryDrawSurplusNum), canUseNum))

    self:RefreshLotteryTicket()

end

function Page_VideoLuckyTableView:RequestOpen()
    ----连续礼赠

    MonthSignSubsystem:Get():SendMsg_ReqVideoLuck()
    WelfareVideoDataManager:Get():SetWelfareFuncID(WelfareFuncType.luckyTable)
end

function Page_VideoLuckyTableView:GetPurchaseByIndex(index)
    local actConfig = WelfareVideoDataManager:Get():GetLuckyTableAwardData()

    local table = stringSplit(actConfig.itemids, ':')
    if #table < index then
        return -1
    else
        return tonumber(table[index])
    end
end

function Page_VideoLuckyTableView:OnOpen()
    self.cs_RotaryTableAnim:Init(self.haloEffectTrans.transform)
    CommonHelper:HButtonSetCallback("BtnHelp", self.gameObject, function(btn)
        CommonHelper:ShowHelpView(PageDetailType.ActLuckRotaryTable, nil, nil, true)
    end)

    CommonHelper:GetComponentSetUITexture("BG", self.gameObject, "welfare_luckytable_bg.png", UIModuleID.Welfare)

    local luckRotaryTables = WelfareVideoDataManager:Get():GetLuckyTableAwardData()

    for i, v in pairs(luckRotaryTables) do
        self:SetItem(i - 1, v)
    end

    self.aniSwitch = false
    self.aniSwitchBtn = CommonHelper:HButtonSetCallback("aniSwitch", self.gameObject, function(btn)
        self:AniSwitch()
    end)
    self:AniSwitch()

    CommonHelper:HButtonSetCallback("drawBtnOne", self.gameObject, function(hbtn)
        local canUseNum = self:GetGetCanUseNum()
        if canUseNum > 0 then
            MonthSignSubsystem:Get():SendMsg_ReqVideoLuckyTable(1)
            CommonHelper:PlayGuideScreenEffectUIMask()
        else
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.WelfareLuckTableNoNum))
        end
    end)

    self.drawBtnMult = CommonHelper:HButtonSetCallback("drawBtnMult", self.gameObject, function(hbtn)
        local canUseNum = self:GetGetCanUseNum()
        local num = canUseNum
        if num > 0 then
            num = num > 10 and 10 or num
            MonthSignSubsystem:Get():SendMsg_ReqVideoLuckyTable(num)
            CommonHelper:PlayGuideScreenEffectUIMask()
        else
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.WelfareLuckTableNoNum))
        end
    end)

    self.BtnVideo = CommonHelper:HButtonSetCallback("BtnVideo", self.gameObject, function(hbtn)
        local LuckyTableState = WelfareVideoDataManager:Get():GetLuckyTableStateData()
        local maxWatch = LuckyTableState[1]:GetMaxWatch()
        local watchNum = LuckyTableState[1]:GetWatchNum()
        if (maxWatch - watchNum) > 0 then
            WelfareVideoDataManager:Get():CreateTimerID(WelfareFuncType.luckyTable)
            MaxSdkAds:Get():ShowRewardedAd()
        else
            CommonTipsHelper:ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.WelfareVideoRunOutOf))
        end
    end)

end

function Page_VideoLuckyTableView:GetGetCanUseNum()
    local LuckyTableState = WelfareVideoDataManager:Get():GetLuckyTableStateData()
    local canUseNum = LuckyTableState[1]:GetCanUseNum()
    return canUseNum
end

---@param index number
---@param luckRotaryTableData LuckRotaryTableData
function Page_VideoLuckyTableView:SetItem(index, luckRotaryTableData)
    local itemCount = self.rewardTransParent.transform.childCount
    local propType, configData = CommonHelper:GetPropTypeById(luckRotaryTableData.propsid)
    if index < itemCount and configData then
        local itemObj = self.rewardTransParent.transform:GetChild(index).gameObject
        local icon = "uitex_sucai_default.png"
        local name = ""
        if propType == PropType.TracKSegment then
            icon = configData.icon
            name = configData.name
        elseif propType == PropType.Part then
            icon = configData.icon
            name = configData.partname
        elseif propType == PropType.Article then
            icon = configData.icon .. ".png"
            name = configData.name
        end
        CommonHelper:GetComponentSetUITexture("icon", itemObj, icon, UIModuleID.Welfare)
        CommonHelper:SetText("###iconNum", itemObj,
                string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LuckRotaryAwardPublicity),
                        ClientDataManager:Get():GetTemplateString(name), luckRotaryTableData.propsnum))
        CommonHelper:SetGameObjectActive("commonImg", itemObj, not luckRotaryTableData.ishitflag)
        CommonHelper:SetGameObjectActive("specialImg", itemObj, luckRotaryTableData.ishitflag)
        CommonHelper:HButtonSetCallback("DetailsBtn", itemObj, function(hbtn)
            local rewardData = RewardData()
            rewardData:SetDataIdNum(luckRotaryTableData:GetPropsId(), luckRotaryTableData:GetPropsNum())
            CommonHelper:ShowRewardPopup({ rewardData }, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
        end)
    end
end

function Page_VideoLuckyTableView:RefreshLotteryTicket()
    local _state = WelfareVideoDataManager:Get():GetLuckyTableStateData()
    local num = _state[1]:GetCanUseNum()

    CommonHelper:SetText("###lotteryTicketNum", self.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LuckRotaryLotteryDrawSurplusNum), num))

    if num == 0 then
        num = 1
    elseif num > 10 then
        num = 10
    end
    CommonHelper:SetText("###num", self.drawBtnMult.gameObject,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.LuckRotaryLotteryDrawMultNum), num))

end

function Page_VideoLuckyTableView:AniSwitch()
    self.aniSwitch = not self.aniSwitch
    CommonHelper:SetGameObjectActive("checked", self.aniSwitchBtn.gameObject, self.aniSwitch)
    CommonHelper:SetGameObjectActive("unChecked", self.aniSwitchBtn.gameObject, not self.aniSwitch)
end

function Page_VideoLuckyTableView:RetLuckyTable(data)
    self:RefreshLotteryTicket()
    CommonHelper:CSGameObjectSetActive(self.haloEffectTrans, true)
    local aniCallBack = data[1]
    table.remove(data, 1)
    if self.aniSwitch then
        if data and type(data[1]) == "table" and #data[1] > 1 then
            self:StartDrawAniMult(data[1], aniCallBack)
        elseif data and type(data[1]) == "table" and #data[1] > 0 then
            CommonHelper:SetGameObjectActive("haloEffectImage", self.haloEffectTrans, true)
            CommonHelper:SetGameObjectActive("checkedImage", self.haloEffectTrans, false)
            self.cs_RotaryTableAnim:StartLuckyDrawOne(data[1][1] - 1, function(index)
                --CommonHelper:CSGameObjectSetActive(self.haloEffectTrans,false)
                CommonHelper:SetGameObjectActive("haloEffectImage", self.haloEffectTrans, false)
                CommonHelper:SetGameObjectActive("checkedImage", self.haloEffectTrans, true)
                if aniCallBack then
                    aniCallBack()
                end
                CommonHelper:CloseGuideScreenEffectUIMask()
            end)
        else
            logError("奖励没有吗？？？？？？？？")
        end
    else
        self.cs_RotaryTableAnim:SetHaloResult(data[1][#data[1]] - 1)
        CommonHelper:SetGameObjectActive("haloEffectImage", self.haloEffectTrans, false)
        CommonHelper:SetGameObjectActive("checkedImage", self.haloEffectTrans, true)
        if aniCallBack and type(aniCallBack) == "function" then
            aniCallBack()
        end
        CommonHelper:CloseGuideScreenEffectUIMask()
    end
end

function Page_VideoLuckyTableView:StartDrawAniMult(data, aniCallBack)
    if #data > 0 then
        CommonHelper:SetGameObjectActive("haloEffectImage", self.haloEffectTrans, true)
        CommonHelper:SetGameObjectActive("checkedImage", self.haloEffectTrans, false)
        self.cs_RotaryTableAnim:StartLuckyDrawMult(data[1] - 1, function(index)
            CommonHelper:SetGameObjectActive("haloEffectImage", self.haloEffectTrans, false)
            CommonHelper:SetGameObjectActive("checkedImage", self.haloEffectTrans, true)
            if (index == -1 or #data == 1) and aniCallBack then
                aniCallBack()
                CommonHelper:CloseGuideScreenEffectUIMask()
            else
                table.remove(data, 1)
                self.coroutine = cs_coroutine.start(function()
                    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.6))
                    self:StartDrawAniMult(data, aniCallBack)
                end)
            end
        end)
    end
end

function Page_VideoLuckyTableView:GetRedPointActive()
    return RedPointManager:Get():GetValue(RedPointID.S_VideoLuck)
end

function Page_VideoLuckyTableView:OnClose()
    if self.coroutine then
        cs_coroutine.stop(self.coroutine)
    end
    self.cs_RotaryTableAnim:SetHaloResult(0)
end