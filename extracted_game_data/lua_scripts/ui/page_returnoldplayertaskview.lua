---@class Page_ReturnOldPlayerTaskView
Page_ReturnOldPlayerTaskView = class("Page_ReturnOldPlayerTaskView")

function Page_ReturnOldPlayerTaskView:initialize(parentPref)

    self.parentPref = parentPref
    self:SetTaskInObjData()
    self.activeGifts = {}
end

function Page_ReturnOldPlayerTaskView:SetTaskInObjData()
    self.TaskObj = {}

    for i = 1, 4 do
        local _TaskObj = UIUtil.GetChild("ReturnOldPlayer_TaskObj_" .. i, self.parentPref)
        table.insert(self.TaskObj, _TaskObj)
    end
end

function Page_ReturnOldPlayerTaskView:RefreshTaskInInfo()

    local curTasks = ReturnOldPlayerDataManager:Get():GetCurTasks()

    for i = 1, #self.TaskObj do

        local _taskData = CommonHelper:GetTableDataByID(ConfigNames.task_config, curTasks[i].missionid)

        CommonHelper:SetText("###title", self.TaskObj[i].gameObject, CommonHelper:GetTempStr_Default(_taskData.missionname))
        CommonHelper:SetText("###introduce", self.TaskObj[i].gameObject, CommonHelper:GetTempStr_Default(_taskData.missionmemo))

        CommonHelper:SetText("item_1/###count", self.TaskObj[i].gameObject,
                CommonHelper:GetTempStr_Default(TemplateStringID.ArticleCountFormat, _taskData.pointval))

        local obj = UIUtil.GetChild("item_2", self.TaskObj[i].gameObject)
        local param = Param_ItemArticleParam()
        param.count = tonumber(_taskData.awardnums)
        CommonHelper:SetItemComGroup(obj, UIModuleID.ReturnOldPlayer, tonumber(_taskData.awardids), param)

        CommonHelper:HButtonSetCallback("BtnGet", self.TaskObj[i].gameObject, function(data)
            --print("领取任务奖励,134, --获取任务奖励", curTasks[i].tasktype, curTasks[i].missionid, 0)
            TaskSubsystem:Get():SendMsg_GetReward(curTasks[i].tasktype, curTasks[i].missionid, 0)
        end)

        CommonHelper:SetGameObjectActive("BtnGet", self.TaskObj[i].gameObject, curTasks[i].curstatus == 2)
        CommonHelper:SetGameObjectActive("GetImg", self.TaskObj[i].gameObject, curTasks[i].curstatus == 3)
        CommonHelper:SetGameObjectActive("NoFinishImg", self.TaskObj[i].gameObject, curTasks[i].curstatus == 1)

    end

    local BoxSlider = {}

    self.activeGifts = ReturnOldPlayerDataManager:Get():GetReBackActiveGifts()
    for i = 1, #self.activeGifts do
        local num = math.modf((self.activeGifts[i].activeval / self.activeGifts[#self.activeGifts].activeval) * 100)
        table.insert(BoxSlider, num * 0.01)
    end

    CommonHelper:SetBoxStateSlider("BoxSlider", self.parentPref, BoxSlider, function(item, index, BoxSlider)
        CommonHelper:SetBoxState("BoxState", item, tonumber(self.activeGifts[index + 1].ifgift))
        CommonHelper:SetText("###value", item, tostring(self.activeGifts[index + 1].activeval))
        CommonHelper:HButtonSetCallback("BoxBtn", item, function(hbtn)
            self:ClickBoxBtn(index + 1)
        end, index)
    end)

    local taskInfo = ReturnOldPlayerDataManager:Get():GetReBackTaskValGifts()

    CommonHelper:SetSlider("SliderBaseColor", self.parentPref, taskInfo / self.activeGifts[#self.activeGifts].activeval)

    CommonHelper:SetText("ActiveBg/###ScoreNum", self.parentPref, tostring(taskInfo))

    local awardMaxData = ReturnOldPlayerDataManager:Get():SetTaskMaxGifts()
    local _type, _data = CommonHelper:GetPropTypeById(tonumber(awardMaxData.awardids))
    local _iconName = _type == PropType.Part and _data.partname or _data.name
    local _coinImg = _type == PropType.Part and _data.icon or _data.icon .. ".png"

    CommonHelper:SetText("ShowAward/###awardName", self.parentPref, CommonHelper:GetTempStr_Default(_iconName))
    CommonHelper:GetComponentSetUITexture("###awardIcon", self.parentPref, _coinImg, UIModuleID.ReturnOldPlayer)
    CommonHelper:SetText("ShowAward/###awardTxt", self.parentPref,
            string.format(CommonHelper:GetTempStr_Default(TemplateStringID.ReturnOldPlayerGetDay), awardMaxData.activeval))

end

function Page_ReturnOldPlayerTaskView:ClickBoxBtn(i)
    local _dataTa = ReturnOldPlayerDataManager:Get().dailyActiveState

    if self.activeGifts[i].ifgift == 1 then
        print("请求领取回归任务宝箱 ",self.activeGifts[i].activetype, self.activeGifts[i].activeval)
        TaskSubsystem:Get():SendMsg_GetActiveReward(self.activeGifts[i].activetype, self.activeGifts[i].activeval)
    elseif self.activeGifts[i].ifgift == 0 then
        CommonHelper:ShowRewardPopup(_dataTa[i].activeReward, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
    else
        CommonHelper:ShowRewardPopup(_dataTa[i].activeReward, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
    end

end