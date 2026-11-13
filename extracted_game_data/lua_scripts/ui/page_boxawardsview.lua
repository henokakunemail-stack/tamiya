---@field GetUIModuleID fun(param:self):string
---@field gameObject  CS.UnityEngine.GameObject
---@field RequestOpen fun(param:self):void @可选重写
---@field OnOpen fun(param:self):string @可选重写
---@field ReOpen fun(param:self):string @可选重写
---@field OnClose fun(param:self):string @可选重写
---@class Page_BoxAwardsView
Page_BoxAwardsView = class("Page_BoxAwardsView", Page_WelfareViewBase)

function Page_BoxAwardsView:GetPageName()
    return "Page_BoxAwardsView"
end

function Page_BoxAwardsView:initialize(parentPref)
    self.parentPref = parentPref
end

function Page_BoxAwardsView:OnAwake()
    self.cmpTimerID = 0
    WelfareBoxDataManager:Get():SetBoxAwardWareData()
    self.BoxSVC = UIUtil.GetTypeChildWightInputPath("BoxSVC", self.parentPref, typeof(MoreRowScrollView))
    self.WareSVC = UIUtil.GetTypeChildWightInputPath("WareSVC", self.parentPref, typeof(MoreRowScrollView))
    self.TowingRangeObj = UIUtil.GetChild("TowingRangeObj", self.parentPref)
    self.dragItemObj = UIUtil.GetChild("DragItem", self.parentPref)

    CommonHelper:HButtonSetCallback("Page_BoxAwardsView/Center/BtnHelp", self.parentPref, function(hbtn)
        UIManager:Get():ShowPersistentView("BoxAwardHelpView", CanvasType.TopCanvas, "BoxAwardHelpView")
    end)

end

function Page_BoxAwardsView:OnOpen()
    self.DragDataID = -1
    if self.cmpTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.cmpTimerID)
    end

    self.cmpTimerID = TimerManager:Get():CreateTimerLoop(1, function()
        self:RefreshBoxInfo()
    end, nil, true)

    self.BoxSVC:MoveToStartPos()
    self:RefreshView()
end

function Page_BoxAwardsView:ReOpen()
    BoxAwardSubsystem:Get():SendMsg_ReqBoxQueue()
end

function Page_BoxAwardsView:RequestOpen()
    BoxAwardSubsystem:Get():SendMsg_ReqBoxQueue()
end

function Page_BoxAwardsView:RefreshView()
    self.boxVacancy = 0
    self.DragDataID = -1
    self.BoxData = WelfareBoxDataManager:Get():GetBoxAwardData()
    self.WareData = WelfareBoxDataManager:Get():GetBoxAwardWareData()
    self:RefreshBoxInfo()
    self:RefreshWareInfo()

    local BoxBool = false
    local WareBool = false
    local GetBoxBool = false
    for i, v in pairs(self.BoxData) do
        if v:GetBoxId() == 0 and v:GetUnlockFlag() > 0 then
            BoxBool = true
        end
    end
    for i, v in pairs(self.WareData) do
        local haveCount = KnapsackDataManager:Get():GetArticleCountByCfgid(v)
        if haveCount > 0 then
            WareBool = true
        end
    end

    for i, v in pairs(self.BoxData) do
        if v:GetBoxId() > 0 then
            local differenceValueTime = v:GetOpenTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - 1
            if differenceValueTime <= 0 then
                GetBoxBool = true
            end
        end
    end

    RedPointManager:Get():UpdateValue(RedPointID.S_WelfareBoxAwardState, (BoxBool and WareBool) or GetBoxBool)

    UINotify:Get():SendNotification(UINotifyEvent.WelfareVideoRefreshBtn)
end

function Page_BoxAwardsView:RefreshBoxInfo()
    CommonHelper:InitMoreRowScrollView(self.BoxSVC, #self.BoxData, 1, function(dataIndex, itemObj, scroll)
        local _data = self.BoxData[dataIndex + 1]
        local _DataBoxID = _data:GetBoxId()

        local differenceValueTime = _data:GetOpenTime() - CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - 1
        if differenceValueTime <= 0 then
            differenceValueTime = 0
        end

        local itemBGQuality = 0
        if _DataBoxID ~= 0 then
            itemBGQuality = CommonHelper:GetTableDataByID(ConfigNames.article_config, _DataBoxID)
        end

        if _DataBoxID > 0 then
            local obj = UIUtil.GetChild("ItemCom_202", itemObj)
            local iconName = CommonHelper:GetTableDataByID(ConfigNames.article_config, _DataBoxID).NewIcon
            CommonHelper:GetComponentSetUITexture("ItemIcon", obj, iconName, UIModuleID.Welfare)
            local _maxTime = CommonHelper:GetTableDataByID(ConfigNames.article_config, _DataBoxID)
            local sliderValue = differenceValueTime / _maxTime.propsadd/_data:GetBoxSum()
            CommonHelper:SetSlider("com_ExpSlider", itemObj, 1 - sliderValue)
        end
        local str=""
        if _DataBoxID ~= 0 then
            str = CommonHelper:GetTempStr_Default(TemplateStringID.Lab_LockBoxNum,_data:GetBoxSum())
        end
        CommonHelper:SetText("###locknum",itemObj,str)

        CommonHelper:SetGameObjectActive("quality_dt", itemObj, true)
        if _DataBoxID == 0 then
            CommonHelper:SetGameObjectActive("quality_dt", itemObj, false)
        end

        if _DataBoxID > 0 and differenceValueTime > 0 then
            CommonHelper:GetComponentSetImage("quality_dt", itemObj, "boxaward_bg_" .. itemBGQuality.propsgrade .. "_dt", UIModuleID.Welfare)
        end

        if _DataBoxID > 0 and differenceValueTime == 0 then
            CommonHelper:GetComponentSetImage("quality_dt", itemObj, "boxaward_open_bg_" .. itemBGQuality.propsgrade .. "_dt", UIModuleID.Welfare)
        end

        local selfDefineTime = CommonHelper:GetSelfTransferTimeStr(differenceValueTime, 1)
        if selfDefineTime.day~="0" then
            CommonHelper:SetText("###TimeText", itemObj,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.DHMS), selfDefineTime.day,selfDefineTime.hour, selfDefineTime.minute, selfDefineTime.second))
        else
            CommonHelper:SetText("###TimeText", itemObj,
                    string.format(CommonHelper:GetTempStr_Default(TemplateStringID.HMS),selfDefineTime.hour, selfDefineTime.minute, selfDefineTime.second))
        end
        CommonHelper:SetGameObjectActive("BoxLock", itemObj, _data:GetUnlockFlag() == 0)
        CommonHelper:SetGameObjectActive("BtnUnlock", itemObj, _data:GetUnlockFlag() == 0)

        CommonHelper:SetGameObjectActive("###TimeText", itemObj, differenceValueTime ~= 0)
        CommonHelper:SetGameObjectActive("com_ExpSlider", itemObj, differenceValueTime ~= 0)
        CommonHelper:SetGameObjectActive("BtnDrag", itemObj, _DataBoxID == 0)
        CommonHelper:SetGameObjectActive("ItemCom_202", itemObj, _DataBoxID > 0)
        CommonHelper:SetGameObjectActive("ItemArticle_202", itemObj, _DataBoxID > 0)
        CommonHelper:SetGameObjectActive("BtnGetGray", itemObj, _DataBoxID == 0 and differenceValueTime == 0)
        CommonHelper:SetGameObjectActive("BtnGet", itemObj, _DataBoxID > 0 and differenceValueTime == 0)
        CommonHelper:SetGameObjectActive("BtnCancel", itemObj, _DataBoxID > 0 and differenceValueTime > 0)
        CommonHelper:SetGameObjectActive("BtnSpeedUp", itemObj, _DataBoxID > 0 and differenceValueTime > 0)
        CommonHelper:SetGameObjectActive("###unlockText", itemObj, _DataBoxID == 0 and _data:GetUnlockFlag() > 0)

        local _lockTxtData = CommonHelper:GetTableDataByID(ConfigNames.dictboxloc_config, dataIndex + 1)
        local _lockTxt = CommonHelper:GetTempStr_Default(_lockTxtData.boxlocconsum)
        CommonHelper:SetText("###lockText", itemObj, _lockTxt)

        CommonHelper:HButtonSetCallback("BtnUnlock", itemObj, function(hbtn)
            if _lockTxtData.unlockcond == 1 then
                local boxFunc = function()
                    local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, _lockTxt)
                    if ret == MessageBoxHelp.BtnType.OK then
                        --print("--524, --解锁宝箱位置 P2=位置", dataIndex + 1, _lockTxt)
                        BoxAwardSubsystem:Get():SendMsg_ReqUnlockBox(dataIndex + 1)
                    end
                end
                MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
            else
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.BoxAwardInadequateCondition))
            end
        end, dataIndex + 1)

        CommonHelper:HButtonSetCallback("BtnCancel", itemObj, function(hbtn)
            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, CommonHelper:GetTempStr_Default(TemplateStringID.BoxAwardCancelOpen))
                if ret == MessageBoxHelp.BtnType.OK then
                    --print("--520, --请求取消宝箱 P2=位置", dataIndex + 1)
                    BoxAwardSubsystem:Get():SendMsg_ReqCancelBox(dataIndex + 1)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end)

        CommonHelper:HButtonSetCallback("BtnSpeedUp", itemObj, function(hbtn)
            local _minuteText = WelfareBoxDataManager:Get():GetCostData(differenceValueTime)
            local boxFunc = function()
                local ret = MessageBoxHelp:Get():OpenBox_OKCancel(UIColor.Blue, _minuteText)
                if ret == MessageBoxHelp.BtnType.OK then
                    --print("--522, --领取宝箱 P2=位置 P3=1立即开启", dataIndex + 1, 1)
                    BoxAwardSubsystem:Get():SendMsg_ReqBoxGift(dataIndex + 1, 1)
                end
            end
            MessageBoxHelp.Get():StartCoroutineBox(boxFunc)
        end)

        CommonHelper:HButtonSetCallback("BtnGet", itemObj, function(hbtn)
            --print("--522, --领取宝箱 P2=位置 P3=1立即开启", dataIndex + 1, 0)
            BoxAwardSubsystem:Get():SendMsg_ReqBoxGift(dataIndex + 1, 0)
        end)
        ------拖拽触发---------------------------------------------------------------------------

        --CommonHelper:OnTriggerObjectSetCallback("BtnTrigger", itemObj,
        --        function(other, hbtn)
        --        end,
        --        function(other, hbtn)
        --            self.boxVacancy = 0
        --        end,
        --        function(other, hbtn)
        --            self:SetBoxVacancy(dataIndex + 1)
        --        end)
        --------------------------------------------------------------------------

    end, false, false, false)


end

function Page_BoxAwardsView:RefreshWareInfo()
    CommonHelper:InitMoreRowScrollView(self.WareSVC, #self.WareData, 1, function(dataIndex, itemObj, scroll)
        local _data = self.WareData[dataIndex + 1]
        local obj = UIUtil.GetChild("ItemCom_138", itemObj)
        local param = Param_ItemArticleParam()
        param.count = KnapsackDataManager:Get():GetArticleCountByCfgid(_data)

        CommonHelper:SetItemComGroup(obj, UIModuleID.Welfare, _data, param, function()
            local NoPosition = WelfareBoxDataManager:Get():GetBoxLocData()
            if NoPosition == 0 then
                CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.BoxAwardNoPosition))
            elseif param.count>1 then
                UIManager:Get():OpenPopup("MultiSelectView", CanvasType.FrontCanvas, "MultiSelectView")
                UINotify:Get():SendNotification(UINotifyEvent.MultiSelectView_SetData,{_data, param.count})
            elseif param.count>0 then
                print("--518, --请求打开宝箱 P2=位置 P3=宝箱id", NoPosition, _data)
                BoxAwardSubsystem:Get():SendMsg_ReqOpenBox(NoPosition, _data)
            end
        end)

        CommonHelper:SetText("###boxName", itemObj, CommonHelper:GetTempStr_Default(CommonHelper:GetTableDataByID(ConfigNames.article_config, _data).name))




        ------拖拽---------------------------------------------------------------------------
        --local DragParent = UIUtil.GetChild("custom", itemObj)
        --local DragObj = UIUtil.GetChild("BtnDragItem", itemObj)
        --
        --local ItemObj_Position = obj.transform.localPosition
        --
        --CommonHelper:DragObjectSetCallback("BtnDragItem", itemObj, function(hbtn)
        --    self.boxVacancy = 0
        --    self.DragDataID = -1
        --    local _haveNum = KnapsackDataManager:Get():GetArticleCountByCfgid(_data.boxId)
        --    if _haveNum > 0 then
        --        local iconName = CommonHelper:GetTableDataByID(ConfigNames.article_config, _data.boxId).NewIcon
        --        CommonHelper:GetComponentSetUITexture("dragIcon", self.dragItemObj, iconName, UIModuleID.Welfare)
        --        --self.DragPar = DragObj.transform.parent
        --        UIUtil.SetParentGameObject(self.parentPref, DragObj, false, false)
        --        UIUtil.SetParentGameObject(DragObj, self.dragItemObj, true, true)
        --        CommonHelper:CSGameObjectSetActive(self.dragItemObj, true)
        --        self.DragDataID = _data.boxId
        --    else
        --        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.BoxAwardNoBox))
        --    end
        --end, function(other, hbtn)
        --    self:IfInAnArea()
        --    UIUtil.SetParentGameObject(DragParent, DragObj, true, false)
        --    DragObj.transform.localPosition = ItemObj_Position
        --    CommonHelper:CSGameObjectSetActive(self.dragItemObj, false)
        --end)
        --------------------------------------------------------------------------

    end, false, false, false)

end

function Page_BoxAwardsView:IfInAnArea()
    if self.boxVacancy > 0 and self.DragDataID ~= -1 then
        --print("--518, --请求打开宝箱 P2=位置 P3=宝箱id", self.boxVacancy, self.DragDataID)
        BoxAwardSubsystem:Get():SendMsg_ReqOpenBox(self.boxVacancy, self.DragDataID)
    end
end

function Page_BoxAwardsView:SetBoxVacancy(_vacancy)
    self.boxVacancy = _vacancy
end

function Page_BoxAwardsView:GetRedPointActive()
    return RedPointManager:Get():GetValue(RedPointID.S_WelfareBoxAwardState)
end

function Page_BoxAwardsView:OnClose()
    WelfareBoxDataManager:Get():SetBoxAwardFastestTime()

    if self.cmpTimerID ~= 0 then
        TimerManager:Get():StopTimer(self.cmpTimerID)
    end
end