---@class CommonNewActView : ViewBase
CommonNewActView = class("CommonNewActView", ViewBase)

function CommonNewActView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "CommonNewActViewAction")
end

function CommonNewActView:Awake()
    self.commonActList = self:GetChildWightByParent("CommonAct", self.gameObject, typeof(MoreRowScrollView))
    self.ChooseBtnSVC = UIUtil.GetTypeChildWightByParent("ChooseBtnSVC", self.gameObject, typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)


    self.PageView = {}
    self.CommonPageObj = {}
    self.PageTrans = self:GetChildByParent("PageTrans", self.gameObject).transform
    local itemCount = self.PageTrans.childCount
    for i = 0, itemCount - 1 do
        self.CommonPageObj[i] = self.PageTrans:GetChild(i)
    end
    self.CurActId = -1
end

local _selectID = 1
function CommonNewActView:OnOpen()
    self.CommonActPageList = {}
    local page_data = CommonFestivalDataManager:Get():GetAllDataIDTab()
    for i, v in pairs(page_data) do
        local pageCG = self:GetChildWightByParent("Page_Common_" .. v.actstyle, self.gameObject, typeof(CanvasGroup))
        self.CommonActPageList[v.actstyle] = pageCG
    end

    local curActId = (CommonFestivalDataManager:Get():GetAllDataIDTab()[1] and CommonFestivalDataManager:Get():GetAllDataIDTab()[1].actstyle < CommonFestivalType.LuckInfo) and -1 or CommonFestivalDataManager:Get():GetAllDataIDTab()[1].C_ID
    _selectID = 1
    self:InitChooseData()
    if curActId ~= -1 then
        self:ToggleOnClick(curActId)
    else
        local allActData = CommonFestivalDataManager:Get():GetAllDataIDTab()
        CommonFestivalDataManager:Get():InitOldActState(allActData, 1)
    end
    self.charge_finishGiftId=nil
end

local openingID
function CommonNewActView:ReOpen()
    local allActData = CommonFestivalDataManager:Get():GetAllDataIDTab()
    self.CommonActPageList = {}
    for i, v in pairs(allActData) do
        local pageCG = self:GetChildWightByParent("Page_Common_" .. v.actstyle, self.gameObject, typeof(CanvasGroup))
        self.CommonActPageList[v.actstyle] = pageCG
    end


    local IfOpen = CommonFestivalDataManager:Get():GetActivityNowActIfOpen(openingID)

    if IfOpen then
        local _timeNum = 1
        for i, v in pairs(allActData) do
            if v.C_ID == openingID then
                _timeNum = i
            end
        end

        if allActData[_timeNum].actstyle < CommonFestivalType.LuckInfo then
            CommonFestivalDataManager:Get():InitOldActState(allActData, openingID)
        else
            self:ToggleOnClick(openingID)
        end
    else
        if allActData[1].actstyle < CommonFestivalType.LuckInfo then
            CommonFestivalDataManager:Get():InitOldActState(allActData, 1)
        else
            self:ToggleOnClick(allActData[1].C_ID)
        end
        _selectID = 1
        self:InitChooseData()
    end
end

function CommonNewActView:InitChooseData()
    local allActData = CommonFestivalDataManager:Get():GetAllDataIDTab()

    local UpdateFunc = function(dataIndex, itemObj, scroll)
        ---@type act_bussiness_config_cell
        local data = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, allActData[dataIndex + 1].C_ID)
        local redActive = false
        CommonHelper:SetGameObjectActive("choose", itemObj, _selectID == dataIndex + 1)
        CommonHelper:SetGameObjectActive("common", itemObj, _selectID ~= dataIndex + 1)

        openingID = allActData[_selectID].C_ID

        CommonHelper:SetText("choose/###Text", itemObj, CommonHelper:GetTempStr_Default(data.actname))
        CommonHelper:SetText("common/###Text", itemObj, CommonHelper:GetTempStr_Default(data.actname))

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(btn)
            print("ChooseBtnSVC*******", dataIndex + 1)
            if data.actstyle < CommonFestivalType.LuckInfo then
                if allActData[dataIndex + 1].actstyle == CommonFestivalType.SignIn then
                    CommonFestivalSubSystem:Get():SendMsg_SignInfo(allActData[dataIndex + 1].C_ID)
                end
                if allActData[dataIndex + 1].actstyle == CommonFestivalType.Exchange then
                    CommonFestivalSubSystem:Get():SendMsg_ActShopInfo(allActData[dataIndex + 1].C_ID)
                end
                if allActData[dataIndex + 1].actstyle == CommonFestivalType.Charge then
                    CommonFestivalSubSystem:Get():SendMsg_ActDayGift(allActData[dataIndex + 1].C_ID)
                end
                if allActData[dataIndex + 1].actstyle == CommonFestivalType.LimitTask then
                    TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.CommonFestivalLimitTask)
                end
                if allActData[dataIndex + 1].actstyle == CommonFestivalType.MoreMoney then
                    CommonFestivalSubSystem:Get():SendMsg_ActChargeGift(allActData[dataIndex + 1].C_ID)
                end
                if allActData[dataIndex + 1].actstyle == CommonFestivalType.Cumulative then
                    CommonFestivalSubSystem:Get():SendMsg_CountCharge(allActData[dataIndex + 1].C_ID)
                end
                if allActData[dataIndex + 1].actstyle == CommonFestivalType.CustomGift then
                    CommonFestivalSubSystem:Get():SendMsg_DesignGift(allActData[dataIndex + 1].C_ID)
                end
                if allActData[dataIndex + 1].actstyle == CommonFestivalType.EveryDayGift then
                    ActivitySubsystem:Get():SendMsg_GetActivity(allActData[dataIndex + 1].itemids)
                end
                self:ToggleOnClick(-1)
            else
                self:ToggleOnClick(btn.intData)
            end
            _selectID = dataIndex + 1

            UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshChooseBtn)
        end, data.C_ID)
        if data.actstyle < CommonFestivalType.LuckInfo then
        else
            if self:GetPageView(data.C_ID) then
                redActive = self:GetPageView(data.C_ID):GetRedPointActive()
            end
        end
        CommonHelper:SetGameObjectActive("RedPoint1", itemObj, redActive)
    end

    CommonHelper:InitMoreRowScrollView(self.ChooseBtnSVC, #allActData, 1, UpdateFunc, true, nil, false)

end

function CommonNewActView:RefreshActPage(msg, pageID)

    for i, v in pairs(self.CommonPageObj) do
        local v_obj = UIUtil.GetGameobjectComponent(v.gameObject, typeof(CanvasGroup))
        UIUtil.ShowCanvasGroup(v_obj, false)
    end

    for k, v in pairs(self.CommonActPageList) do
        UIUtil.ShowCanvasGroup(v, k == pageID and true or false)
    end

    if pageID == CommonFestivalType.SignIn then
        local pageBGName = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, msg.actId)
        CommonHelper:GetComponentSetUITexture("pagebg", self.gameObject, pageBGName.actbg .. ".png", UIModuleID.CommonAct)
        local pagepage = Page_CommonFestivalSignInView(self.CommonActPageList[pageID].gameObject)
        pagepage:RefreshSignInInfo(msg)
    elseif pageID == CommonFestivalType.Exchange then
        local pageBGName = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, msg.shopid)
        CommonHelper:GetComponentSetUITexture("pagebg", self.gameObject, pageBGName.actbg .. ".png", UIModuleID.CommonAct)
        local pagepage = Page_CommonFestivalExchangeView(self.CommonActPageList[pageID].gameObject)
        pagepage:RefreshExchangeInfo(msg)
    elseif pageID == CommonFestivalType.Charge then
        local pageBGName = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, msg.actId)
        CommonHelper:GetComponentSetUITexture("pagebg", self.gameObject, pageBGName.actbg .. ".png", UIModuleID.CommonAct)
        local pagepage = Page_CommonFestivalChargeView(self.CommonActPageList[pageID].gameObject)
        if msg.finishGiftId ~= nil and msg.finishGiftId>0 then
            self.charge_finishGiftId=msg.finishGiftId
        end
        pagepage:RefreshChargeInfo(msg,self.charge_finishGiftId)
    elseif pageID == CommonFestivalType.MoreMoney then
        local pageBGName = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, msg.actId)
        CommonHelper:GetComponentSetUITexture("pagebg", self.gameObject, pageBGName.actbg .. ".png", UIModuleID.CommonAct)
        local pagepage = Page_CommonFestivalMoreMoneyView(self.CommonActPageList[pageID].gameObject)
        pagepage:RefreshMoreMoneyInfo(msg)
    elseif pageID == CommonFestivalType.Cumulative then
        local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.Cumulative)
        local pageBGName = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, actID)
        CommonHelper:GetComponentSetUITexture("pagebg", self.gameObject, pageBGName.actbg .. ".png", UIModuleID.CommonAct)
        local pagepage = Page_CommonFestivalCumulativeView(self.CommonActPageList[pageID].gameObject)
        pagepage:RefreshCumulativeInfo()
    elseif pageID == CommonFestivalType.CustomGift then
        local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.CustomGift)
        local pageBGName = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, actID)
        CommonHelper:GetComponentSetUITexture("pagebg", self.gameObject, pageBGName.actbg .. ".png", UIModuleID.CommonAct)
        local pagepage = Page_CommonFestivalCustomGiftView(self.CommonActPageList[pageID].gameObject)
        pagepage:RefreshCustomGiftInfo()
    elseif pageID == CommonFestivalType.EveryDayGift then
        local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.EveryDayGift)
        local pageBGName = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, actID)
        CommonHelper:GetComponentSetUITexture("pagebg", self.gameObject, pageBGName.actbg .. ".png", UIModuleID.CommonAct)
        local pagepage = Page_CommonFestivalEveryDayView(self.CommonActPageList[pageID].gameObject)
        pagepage:RefreshEveryDayInfo()
    elseif pageID == CommonFestivalType.LimitTask then
        local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.LimitTask)
        local pageBGName = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, actID)
        CommonHelper:GetComponentSetUITexture("pagebg", self.gameObject, pageBGName.actbg .. ".png", UIModuleID.CommonAct)
        local pagepage = Page_CommonFestivalLimitTaskView(self.CommonActPageList[pageID].gameObject)
        pagepage:RefreshLimitTask()
    end
end

function CommonNewActView:LimitTaskTurn(taskID)
    local pagepage = Page_CommonFestivalLimitTaskView(self.CommonActPageList[CommonFestivalType.LimitTask].gameObject)
    pagepage:RefreshLimitTask()
    pagepage:LimitTaskTurn(taskID)
end

function CommonNewActView:OnClose()
    self:ToggleOnClick(-1)
    CommonHelper:ReleasePool(UIModuleID.CommonAct)
end

function CommonNewActView:ToggleOnClick(actId)

    if actId == self.CurActId and self:GetPageView(actId) then
        self:GetPageView(actId):RequestOpen()
    elseif actId ~= self.CurActId and self:GetPageView(actId) then
        ---历史原因
        for i, v in pairs(self.CommonPageObj) do
            local v_obj = UIUtil.GetGameobjectComponent(v.gameObject, typeof(CanvasGroup))
            UIUtil.ShowCanvasGroup(v_obj, false)
        end
        ---历史原因
        local lastActId = self.CurActId
        self.CurActId = actId
        self:GetPageView(actId):RequestOpen()
        if self:GetPageView(lastActId) then
            self:GetPageView(lastActId):Close()
        end
    elseif actId ~= self.CurActId and actId == -1 then
        if self:GetPageView(self.CurActId) then
            self:GetPageView(self.CurActId):Close()
        end
        self.CurActId = actId
    end
end

function CommonNewActView:OpenActPage(actId)
    if actId ~= -1 then
        if self.CurActId == actId and self:GetPageView(actId) then
            self:GetPageView(actId):Open()
        end
    end
end

function CommonNewActView:PageRunAction(data)
    local actId = data[1]
    actId = actId == -1 and self.CurActId or actId
    if actId and self:GetPageView(actId) then
        table.remove(data, 1)
        self:GetPageView(actId):RunAction(data)
    end
end

---@return Page_CommonActViewBase
function CommonNewActView:GetPageView(actId)
    if actId == -1 then
        return nil
    end
    return self.PageView[actId] and self.PageView[actId] or self:CreatePageView(actId)
end

function CommonNewActView:CreatePageView(actId)
    self.PageView[actId] = Page_CommonActViewBase.CreatePageActView(actId, self.gameObject)
    return self.PageView[actId]
end





