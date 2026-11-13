---@class ActBaseData
ActBaseData = class("ActBaseData")
function ActBaseData:initialize()
    self.actId = 0
    self.beginTime = 0
    self.endTime = 0
end

---@param msg SC_ActBaseDict
function ActBaseData:SetDataByMsg(msg)
    self.actId = msg.actId
    self.beginTime = msg.beginTime
    self.endTime = msg.endTime
end

function ActBaseData:GetActId()
    return self.actId
end

function ActBaseData:GetBeginTime()
    return self.beginTime
end

function ActBaseData:GetEndTime()
    return self.endTime
end

---@class CommonFestivalDataManager
CommonFestivalDataManager = class("CommonFestivalDataManager")

function CommonFestivalDataManager:initialize()
    ---@type table<number ,act_bussiness_config_cell>
    self.ActivityDataTab = {}
    ---@type  table<number,ActBaseData>
    self.ActBaseDataTab = {}
end

function CommonFestivalDataManager:Get()
    if self._instance == nil then
        self._instance = CommonFestivalDataManager()
    end
    return self._instance
end


--初始化活动列表
---@param dictActBase table<number,SC_ActBaseDict>
function CommonFestivalDataManager:InitDataIDTab(nowOpenActs, dictActBase)
    if #nowOpenActs == 0 then
        return self.ActivityDataTab
    end
    self.ActivityDataTab = {}
    for i, v in pairs(nowOpenActs) do
        ---@type act_bussiness_config_cell
        local _data = CommonHelper:GetTableDataByID(ConfigNames.act_bussiness_config, v)
        table.insert(self.ActivityDataTab, _data)
    end
    table.insert(self.ActivityDataTab, _data)
    for i = 1, #dictActBase do
        local actBaseData = ActBaseData()
        actBaseData:SetDataByMsg(dictActBase[i])
        self.ActBaseDataTab[actBaseData:GetActId()] = actBaseData
    end
    table.sort(self.ActivityDataTab, function(a, b)
        return a.orderseq < b.orderseq
    end)

end

---@return number,number @开始时间 ,结束时间
function CommonFestivalDataManager:GetActTime(actId)
    if actId and self.ActBaseDataTab[actId] then
        return self.ActBaseDataTab[actId]:GetBeginTime(), self.ActBaseDataTab[actId]:GetEndTime()
    end
end

function CommonFestivalDataManager:GetActActive(actType)
    for i, v in pairs(self.ActivityDataTab) do
        if v.actstyle == actType then
            return true
        end
    end

    return false
end

function CommonFestivalDataManager:GetAllDataIDTabByType(_type)
    local _data = {}
    local _typeData = {}

    for i, v in pairs(self.ActivityDataTab) do
        local bTime, eTime = self:GetActTime(v.C_ID)
        if bTime < CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) and eTime > CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) then
            table.insert(_data, v)
        end
    end

    for i, v in pairs(_data) do
        if v.acttype == _type then
            table.insert(_typeData, v)
        end
    end

    return _typeData
end

---@return table<number ,act_bussiness_config_cell>
function CommonFestivalDataManager:GetAllDataIDTab()
    local _data = {}
    local NowTime = CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())

    for i, v in pairs(self.ActivityDataTab) do
        local bTime, eTime = self:GetActTime(v.C_ID)
        if bTime < NowTime and eTime > NowTime then
            table.insert(_data, v)
        end
    end

    return _data
end

function CommonFestivalDataManager:GetActivityDataByID(ID)
    for i, v in pairs(self.ActivityDataTab) do
        if v.id == ID then
            return v
        end
    end
end

--不可以有同类型的活动ID
function CommonFestivalDataManager:GetActivityDataIDByType(_type)
    for i, v in pairs(self.ActivityDataTab) do
        if v.actstyle == _type then
            return v.C_ID
        end
    end
end

----每日赠礼-------------------
function CommonFestivalDataManager:InitEveryDayaData(msg)
    self.everyDay = {}

    self.everyDay = msg
end

function CommonFestivalDataManager:RefreshEveryDayaData(msg)
    for i, v in pairs(self.everyDay) do
        if v.itemid == msg.itemid then
            self.everyDay[i].buysum = msg.buysum
        end
    end

end

function CommonFestivalDataManager:GetEveryDayaData()

    return self.everyDay
end
--------------------------------

function CommonFestivalDataManager:GetActivityState(_type)
    local actData = CommonFestivalDataManager:Get():GetAllDataIDTabByType(_type)

    if #actData > 0 then
        if actData[1].actstyle == CommonFestivalType.SignIn then
            CommonFestivalSubSystem:Get():SendMsg_SignInfo(actData[1].C_ID)
        end
        if actData[1].actstyle == CommonFestivalType.Exchange then
            CommonFestivalSubSystem:Get():SendMsg_ActShopInfo(actData[1].C_ID)
        end
        if actData[1].actstyle == CommonFestivalType.Charge then
            CommonFestivalSubSystem:Get():SendMsg_ActDayGift(actData[1].C_ID)
        end
        if actData[1].actstyle == CommonFestivalType.LimitTask then
            TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.CommonFestivalLimitTask)
        end
        ----------TWO---TWO------------------------------------------------
        ---
        if actData[1].actstyle == CommonFestivalType.MoreMoney then
            CommonFestivalSubSystem:Get():SendMsg_ActChargeGift(actData[1].C_ID)
        end
        if actData[1].actstyle == CommonFestivalType.Cumulative then
            CommonFestivalSubSystem:Get():SendMsg_CountCharge(actData[1].C_ID)
        end
        if actData[1].actstyle == CommonFestivalType.CustomGift then
            CommonFestivalSubSystem:Get():SendMsg_DesignGift(actData[1].C_ID)
        end
        if actData[1].actstyle == CommonFestivalType.EveryDayGift then
            ActivitySubsystem:Get():SendMsg_GetActivity(actData[1].itemids)
        end

    else
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.CommonFestivalIsOver))
    end

end

function CommonFestivalDataManager:GetActivityNowActIfOpen(actID)
    local allActData = CommonFestivalDataManager:Get():GetAllDataIDTab()

    for i, v in pairs(allActData) do
        if v.C_ID == actID then
            return true
        end
    end
    return false
end

function CommonFestivalDataManager:GetActivityNewState()
    ---@type table<number ,act_bussiness_config_cell>
    local allActData = CommonFestivalDataManager:Get():GetAllDataIDTab()

    if not UIManager:Get():IsPopViewShow("CommonNewActView") then
        UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
    else
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshReOpen)
    end

    if #allActData > 0 then
        --if allActData[1].actstyle < CommonFestivalType.LuckInfo then
        --    self:InitOldActState(allActData, 1)
        --else
        --    --UINotify:Get():SendNotification(UINotifyEvent.CommonAct_OpenPage, allActData[1].C_ID)
        --end
    else
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.CommonFestivalIsOver))
    end
end

function CommonFestivalDataManager:InitOldActState(allActData, actID)
    local _ActData = self:GetAllDataIDTab()
    local _timeNum = 1
    for i, v in pairs(_ActData) do
        if v.C_ID == actID then
            _timeNum = i
        end
    end

    if allActData[_timeNum].actstyle == CommonFestivalType.SignIn then
        CommonFestivalSubSystem:Get():SendMsg_SignInfo(allActData[_timeNum].C_ID)
    end
    if allActData[_timeNum].actstyle == CommonFestivalType.Exchange then
        CommonFestivalSubSystem:Get():SendMsg_ActShopInfo(allActData[_timeNum].C_ID)
    end
    if allActData[_timeNum].actstyle == CommonFestivalType.Charge then
        CommonFestivalSubSystem:Get():SendMsg_ActDayGift(allActData[_timeNum].C_ID)
    end
    if allActData[_timeNum].actstyle == CommonFestivalType.LimitTask then
        TaskSubsystem:Get():SendMsg_GetTaskList(TaskType.CommonFestivalLimitTask)
    end
    if allActData[_timeNum].actstyle == CommonFestivalType.MoreMoney then
        CommonFestivalSubSystem:Get():SendMsg_ActChargeGift(allActData[_timeNum].C_ID)
    end
    if allActData[_timeNum].actstyle == CommonFestivalType.Cumulative then
        CommonFestivalSubSystem:Get():SendMsg_CountCharge(allActData[_timeNum].C_ID)
    end
    if allActData[_timeNum].actstyle == CommonFestivalType.CustomGift then
        CommonFestivalSubSystem:Get():SendMsg_DesignGift(allActData[_timeNum].C_ID)
    end
    if allActData[_timeNum].actstyle == CommonFestivalType.EveryDayGift then
        ActivitySubsystem:Get():SendMsg_GetActivity(allActData[_timeNum].itemids)
    end
end


function CommonFestivalDataManager:InitCustomGiftData(msg)
    self.DesignGift = msg.myDesignGift
end

function CommonFestivalDataManager:RefreshCustomGiftIfBuy(msg)
    for i, v in pairs(self.DesignGift) do
        if v.itemId == msg.myDesignGift[1].itemId then
            v.awardId = msg.myDesignGift[1].awardId
            v.awardNum = msg.myDesignGift[1].awardNum
            v.ifbuy = msg.myDesignGift[1].ifbuy
        end
    end
end

function CommonFestivalDataManager:CommonFestivalGetCustomGiftLockState(lockTag)
    for i, v in pairs(self.DesignGift) do
        if i == lockTag and v.ifbuy == 2 then
            return true
        end
    end

    return false
end

function CommonFestivalDataManager:RefreshCustomGiftData(msg)
    for i, v in pairs(self.DesignGift) do
        if v.itemId == msg.curActGift.itemid then
            v.ifbuy = 0
        end
    end
end

function CommonFestivalDataManager:GetCustomGiftData()
    return self.DesignGift
end

function CommonFestivalDataManager:InitCumulativeCurActCount(msg)
    self.curActCount = msg.curActCount
end

function CommonFestivalDataManager:GetCumulativeCurActCount()
    return self.curActCount
end

function CommonFestivalDataManager:InitCumulativeCurActInfo(msg)
    self.curActInfo = msg.curActInfo
end

function CommonFestivalDataManager:GetCumulativeCurActInfo()
    return self.curActInfo
end

function CommonFestivalDataManager:RefreshCumulativeCurActInfo(msg)
    for i, v in pairs(self.curActCount) do
        v.giftFlag = msg.giftFlags[i]
    end

    for i, v in pairs(self.curActInfo) do
        if v.itemid == msg.curActGift.itemid then
            v.buysum = msg.curActGift.buysum
        end
    end

    return self.curActInfo
end

function CommonFestivalDataManager:RefreshCumulativeFlagInfo(msg)
    for i, v in pairs(self.curActCount) do
        v.giftFlag = msg.giftFlags[i]
    end
end

function CommonFestivalDataManager:InitActive(msg)
    self.dailyActiveState = {}
    for i = 1, #msg do
        if msg[i].actType == ChargeType.Cumulative then
            local temp = ActiveData()
            temp:SetData(msg[i])
            table.insert(self.dailyActiveState, temp)
        end
    end
end

function CommonFestivalDataManager:GetActive()
    return self.dailyActiveState
end

function CommonFestivalDataManager:InitLimitTaskData(msg)
    self.LimitTaskData = {}
    self.LimitTaskData = msg
end

function CommonFestivalDataManager:GetLimitTaskData()
    return self.LimitTaskData

end

function CommonFestivalDataManager:RefreshLimitTaskGiftData(msg)
    for i, v in pairs(self.LimitTaskData.actMissionGifts) do
        if v.activeval == msg.activeval then
            v.ifgift = msg.ifgift
        end
    end
end

function CommonFestivalDataManager:RefreshLimitTaskData(msg)
    for i, v in pairs(self.LimitTaskData.curTasks) do
        if v.missionid == msg.actTasks[1].missionid then
            v.curstatus = msg.actTasks[1].curstatus
        end
    end
end

function CommonFestivalDataManager:RefreshGotLimitTaskData(msg)
    self.LimitTaskData.actMissionVal = msg.actTaskVal
    for i, v in pairs(self.LimitTaskData.curTasks) do
        if v.missionid == msg.missionId[1] then
            v.curstatus = 3
        end
    end
end

function CommonFestivalDataManager:GetChooseLimitTaskByID(taskID)
    for i, v in pairs(self.LimitTaskData.curTasks) do
        if v.missionid == taskID then
            return v
        end
    end
end

function CommonFestivalDataManager:GetCurTasksAllGot()
    for i, v in pairs(self.LimitTaskData.curTasks) do
        -- 0未完成   1已接未完成   2完成   3已领
        if v.curstatus ~= 3 then
            return false
        end
    end
    return true

end

function CommonFestivalDataManager:GetCurTasksGot()
    for i, v in pairs(self.LimitTaskData.curTasks) do
        -- 0未完成   1已接未完成   2完成   3已领
        if v.curstatus < 1 then
            return false
        end
    end
    return true

end

function CommonFestivalDataManager:InitLimitTaskActive(msg)
    self.LimitTaskActive = {}
    for i = 1, #msg.actMissionGifts do
        if msg.actMissionGifts[i].activetype == TaskType.CommonFestivalLimitTask then
            local temp = ActiveData()
            temp:SetData(msg.actMissionGifts[i])
            table.insert(self.LimitTaskActive, temp)
        end
    end
end

function CommonFestivalDataManager:Clear()
    self.ActivityDataTab = {}
    self.DesignGift = {}
end