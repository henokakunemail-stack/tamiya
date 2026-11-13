---@class Page_CommonFestivalLimitTaskView
Page_CommonFestivalLimitTaskView = class("Page_CommonFestivalLimitTaskView")

function Page_CommonFestivalLimitTaskView:initialize(parentPref)

    self.parentPref = parentPref
    self:SetLimitTask()
end

function Page_CommonFestivalLimitTaskView:SetLimitTask()
    self.TaskSVC = UIUtil.GetTypeChildWightByParent("TaskSVC", self.parentPref, typeof(MoreRowScrollView))

    CommonHelper:SetText("Introduce/###titleText", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalLimitTaskTitle))
    CommonHelper:SetText("###BoxSliderText", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalLimitTaskBoxSlider))

    CommonHelper:HButtonSetCallback("BtnRandom", self.parentPref, function(data)
        CommonFestivalSubSystem:Get():SendMsg_ActMission(1)
    end)

    CommonHelper:HButtonSetCallback("BtnShop", self.parentPref, function(data)
        local propData = CommonHelper:GetTableDataByID(ConfigNames.dictdirect_config, CommonFestivalPropType.LimitTaskExchangeProp)
        local maxcount = KnapsackDataManager:Get():GetArticleCountByCfgid(propData.coinid)
        if maxcount > 0 then
            --CommonHelper:OpenBuyDirectView(CommonFestivalPropType.LimitTaskExchangeProp, maxcount, true)
            CommonHelper:OpenBuyDirectView(CommonFestivalPropType.LimitTaskExchangeProp, maxcount, true, BuyDirectType.CommonFestivalLimitTask)
        else
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalNotChargeProps))
        end
    end)

    local actID = CommonFestivalDataManager:Get():GetActivityDataIDByType(CommonFestivalType.LimitTask)
    local _beginTime, _endTime = CommonFestivalDataManager:Get():GetActTime(actID)
    local starttime = CommonHelper:ConvertIntToDataTime(_beginTime * 1000)
    local endtime = CommonHelper:ConvertIntToDataTime(_endTime * 1000)
    CommonHelper:SetText("time/###time", self.parentPref,
            CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
                    starttime.Month, starttime.Day, starttime.Hour, starttime.Minute,
                    endtime.Month, endtime.Day, endtime.Hour, endtime.Minute))

    CommonHelper:SetText("Introduce/###showText", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalLimitRandom))

    self.TimeScrollContentTrans = UIUtil.GetChild("TaskSVC/Content", self.parentPref).transform

    CommonHelper:HButtonSetCallback("BtnHelp", self.parentPref, function(data)
        CommonHelper:ShowHelpView(PageDetailType.CommonFestivalLimitTask, nil, nil, true)
    end)

    CommonHelper:SetGameObjectActive("BtnRandom_Gray", self.parentPref, false)

end

function Page_CommonFestivalLimitTaskView:RefreshLimitTask()
    CommonHelper:SetGameObjectActive("ItemComAward", self.parentPref, false)
    CommonHelper:SetGameObjectActive("BtnGetAward", self.parentPref, false)

    self.limitTaskData = CommonFestivalDataManager:Get():GetLimitTaskData()
    self.curTasks = self.limitTaskData.curTasks
    self.actMissionGifts = self.limitTaskData.actMissionGifts

    CommonHelper:InitMoreRowScrollView(self.TaskSVC, #self.curTasks, 5, function(index, itemObj, scroll)
        -- 0未完成   1已接未完成   2完成   3已领

        CommonHelper:SetGameObjectActive("NoOpen", itemObj, self.curTasks[index + 1].curstatus == 0)
        CommonHelper:SetGameObjectActive("Underway", itemObj, self.curTasks[index + 1].curstatus == 1 or self.curTasks[index + 1].curstatus == 2)
        CommonHelper:SetGameObjectActive("Got", itemObj, self.curTasks[index + 1].curstatus == 3)
        CommonHelper:SetGameObjectActive("ItemBtn", itemObj, self.curTasks[index + 1].curstatus == 1 or self.curTasks[index + 1].curstatus == 2)

        CommonHelper:HButtonSetCallback("ItemBtn", itemObj, function(data)
            self:RefreshIntroduce(index + 1, self.curTasks[index + 1].missionid)
        end, self.curTasks[index + 1].missionid)

        if self.curTasks[index + 1].curstatus == 1 then
            self:RefreshIntroduce(index + 1, self.curTasks[index + 1].missionid)
        end

    end)

    if CommonFestivalDataManager:Get():GetCurTasksGot() then
        CommonHelper:SetText("Introduce/###showText", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalLimitTaskAllGet))
        CommonHelper:SetGameObjectActive("BtnGetAward", self.parentPref, false)
        CommonHelper:SetGameObjectActive("ItemComAward", self.parentPref, false)
        CommonHelper:SetGameObjectActive("BtnRandom", self.parentPref, false)
        CommonHelper:SetGameObjectActive("BtnRandom_Gray", self.parentPref, true)
    end

    if CommonFestivalDataManager:Get():GetCurTasksAllGot() then
        CommonHelper:SetText("Introduce/###showText", self.parentPref, CommonHelper:GetTempStr_Default(TemplateStringID.CommonFestivalLimitTaskAllGot))
        CommonHelper:SetGameObjectActive("BtnGetAward", self.parentPref, false)
        CommonHelper:SetGameObjectActive("ItemComAward", self.parentPref, false)
        CommonHelper:SetGameObjectActive("BtnRandom", self.parentPref, false)
        CommonHelper:SetGameObjectActive("BtnRandom_Gray", self.parentPref, true)

    end

    --顶部进度条
    local BoxSlider = {}
    for i = 1, #self.actMissionGifts do
        local num = math.modf((self.actMissionGifts[i].activeval / self.actMissionGifts[#self.actMissionGifts].activeval) * 100)
        table.insert(BoxSlider, num * 0.01)
    end

    CommonHelper:SetBoxStateSlider("BoxSlider", self.parentPref, BoxSlider, function(item, index, BoxSlider)
        CommonHelper:SetBoxState("BoxState", item, tonumber(self.actMissionGifts[index + 1].ifgift))
        CommonHelper:SetText("###value", item, tostring(self.actMissionGifts[index + 1].activeval))
        CommonHelper:HButtonSetCallback("BoxBtn", item, function(hbtn)
            self:ClickBoxBtn(index + 1)
        end, index)
    end)

    CommonHelper:SetSlider("SliderBaseColor", self.parentPref, self.limitTaskData.actMissionVal / self.actMissionGifts[#self.actMissionGifts].activeval)

end

function Page_CommonFestivalLimitTaskView:RefreshIntroduce(index, taskID)

    local inTaskData = CommonHelper:GetTableDataByID(ConfigNames.task_config, taskID)

    CommonHelper:SetText("Introduce/###showText", self.parentPref, CommonHelper:GetTempStr_Default(inTaskData.missionmemo))
    CommonHelper:SetText("Introduce/###showNumText", self.parentPref,
            string.format(ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskItemProgress), self.curTasks[index].curval, inTaskData.succval)) --succval

    local item = UIUtil.GetChild("Introduce/ItemComAward", self.parentPref)
    local param = Param_ItemArticleParam()
    param.count = tonumber(inTaskData.awardnums)
    CommonHelper:SetItemComGroup(item, UIModuleID.CommonFestivalTwo, tonumber(inTaskData.awardids), param, function(btnData)
        CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.CommonFestivalTwo)
    end, tonumber(inTaskData.awardids))

    local chooseTask = CommonFestivalDataManager:Get():GetChooseLimitTaskByID(taskID)
    CommonHelper:SetGameObjectActive("BtnGetAward", self.parentPref, chooseTask.curstatus == 2)
    CommonHelper:SetGameObjectActive("ItemComAward", self.parentPref, chooseTask.curstatus == 1 or chooseTask.curstatus == 2)

    CommonHelper:HButtonSetCallback("BtnGetAward", self.parentPref, function(data)
        --print("领取任务奖励,134, --获取任务奖励", chooseTask.tasktype, chooseTask.missionid, taskID, 0)
        TaskSubsystem:Get():SendMsg_GetReward(chooseTask.tasktype, chooseTask.missionid, 0)
    end)

end

function Page_CommonFestivalLimitTaskView:LimitTaskTurn(taskID)

    local contentTrans = self.TimeScrollContentTrans
    local itemCount = contentTrans.childCount

    for i = 1, itemCount - 1 do
        if self.curTasks[i].missionid == taskID.actTasks[1].missionid then

            local itemObj = self.TimeScrollContentTrans:GetChild(i - 1)

            local ui_tween_turn_scale = UIUtil.GetTypeChildWightInputPath("ui_tween_turn", itemObj, typeof(TweenRotation))
            ui_tween_turn_scale:ResetToBeginning()
            CommonHelper:CSGameObjectSetActive(ui_tween_turn_scale.gameObject, true)
            CommonHelper:PlayTween(self.ui_tween_turn_scale)

            local cs_Start_turn = cs_coroutine.start(function()
                coroutine.yield(CS.UnityEngine.WaitForSeconds(1.0))
                CommonHelper:CSGameObjectSetActive(ui_tween_turn_scale.gameObject, false)
            end)

            if cs_Start_turn then
                cs_coroutine.stop(cs_Start_turn)
                cs_Start_turn = nil
            end
        end

    end
end

--function Page_CommonFestivalLimitTaskView:LimitTaskMove(taskID)
--    local contentTrans = self.TimeScrollContentTrans
--    local itemCount = contentTrans.childCount
--
--    for i = 0, itemCount do
--        if self.curTasks[i].missionid == taskID then
--
--            local itemObj = self.TimeScrollContentTrans:GetChild(i - 1)
--
--            local ui_tween_move = UIUtil.GetTypeChildWightInputPath("ui_tween_move", itemObj, typeof(TweenScale))
--
--            ui_tween_move:ResetToBeginning()
--            CommonHelper:CSGameObjectSetActive(ui_tween_move.gameObject, true)
--            CommonHelper:PlayTween(self.ui_tween_move)
--
--            local cs_Start_turn = cs_coroutine.start(function()
--                coroutine.yield(CS.UnityEngine.WaitForSeconds(1.0))
--                CommonHelper:CSGameObjectSetActive(ui_tween_move.gameObject, false)
--            end)
--
--            if cs_Start_turn then
--                cs_coroutine.stop(cs_Start_turn)
--                cs_Start_turn = nil
--            end
--        end
--
--    end
--end

function Page_CommonFestivalLimitTaskView:GetDataTime(_time)
    local _timeStr = ""

    local month = tonumber(os.date("%m", _time))
    local day = tonumber(os.date("%d", _time))
    local hour = tonumber(os.date("%H", _time))
    local minute = tonumber(os.date("%M", _time))
    --月日時分
    _timeStr = month .. "月" .. day .. "日 " .. hour .. "時" .. minute .. "分"

    return _timeStr
end

function Page_CommonFestivalLimitTaskView:ClickBoxBtn(i)
    local _dataTa = CommonFestivalDataManager:Get().LimitTaskActive

    if self.actMissionGifts[i].ifgift == 1 then
        --print("请求领取回归任务宝箱 ",self.actMissionGifts[i].activetype, self.actMissionGifts[i].activeval)
        TaskSubsystem:Get():SendMsg_GetActiveReward(self.actMissionGifts[i].activetype, self.actMissionGifts[i].activeval)
    elseif self.actMissionGifts[i].ifgift == 0 then
        CommonHelper:ShowRewardPopup(_dataTa[i].activeReward, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
    else
        CommonHelper:ShowRewardPopup(_dataTa[i].activeReward, ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
    end

end