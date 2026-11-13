---@class NewBieGuideDataManager
NewBieGuideDataManager = class("NewBieGuideDataManager")
function NewBieGuideDataManager:Get()
    if self._instance == nil then
        self._instance = NewBieGuideDataManager()
    end
    return self._instance
end
function NewBieGuideDataManager:initialize()
    self.PlayerHasGuide = false
    CacheClearTrigger:Get():RegisterEvent(self, self.ClearData)
end
function NewBieGuideDataManager:OnInit(groupId)
    if self.curGroupId == nil then
        self.curGroupId = groupId
        self.cfg = nil
        ---@type table<number,table<number,newbieguide_config_cell>>
        self.guideData = nil --当前所有的引导VO数据
        self.curGuideData = {} --当前正在执行的引导VO数据
        self.curGuideStep = 0 --当前正在执行的引导步骤数
        self.nextGuideStep = 0
        self.ClickCount = 0
        self:CheckGuide()
    end
end

function NewBieGuideDataManager:CheckGuide()
    if self.curGroupId ~= GuideState.GuideStateExit then
        self:LoadConfig()
        if self.curGroupId == GuideState.GuideStateNoExecute then
            self.curGroupId = GuideState.GuideStartId
            --print(self.curGroupId)
        end
        --print("当前引导:"..self.guideData[self.curGroupId][1].UiName)
        --取引导组的第一步
        self.curGuideStep = self.guideData[self.curGroupId][1]

        --if NewBieGuideDataManager:Get():IsNeedShowGuide(self.gameObject.name) then
        --UIManager:Get():ShowPersistentView("NewbieGuideView", CanvasType.MainCanvas, "NewBieGuideView", true)
        --UINotify:Get():SendNotification(UINotifyEvent.StartNewBieGuide)
        --NetEasePoneFunc:Get():TutorialLog(PlayerDataManager:Get():GetPlayerServerID(), tostring(PlayerDataManager:Get():GetPlayerID()), PlayerDataManager:Get():GetPlayerName()
        --, tostring(self.curGroupId), ClientDataManager:Get():GetTemplateString(self.guideData[self.curGroupId][1].Desc), tostring(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())), PlayerDataManager:Get():GetPlayerLV(), -1, -1, -1, 0)
        --NetEaseDataManager:Get():SetPoneTutorialParam(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()), PlayerDataManager:Get():GetPlayerLV())
        if self.curGroupId~=GuideState.GuideStarCloseId then
           CommonHelper:PlayGuideScreenEffectUIMask()
        end
    else
        return
    end
end

function NewBieGuideDataManager:LoadConfig()
    self.guideData = {} --当前所有的引导VO数据
    if ClientDataManager:Get().IsConfig2 then
        ---@type newbieguide_config
        self.cfg = ClientDataManager:Get():GetDataTable(ConfigNames.newbieguide2_config)
    else
        ---@type newbieguide_config
        self.cfg = ClientDataManager:Get():GetDataTable(ConfigNames.newbieguide_config)
    end
    -- local temp=CommonHelper:GetTableDataByID(ConfigNames.newbieguide_config,100101)
    for k, v in pairs(self.cfg.GetConfigData()) do
        if self.guideData[v.group] == nil then
            self.guideData[v.group] = {}
        end
        table.insert(self.guideData[v.group], v)
    end
    for k, v in pairs(self.guideData) do
        table.sort(v, function(a, b)
            return a.id < b.id
        end)
    end

end

function NewBieGuideDataManager:GetNextGroupByNextStepId(nextStepId)
    self.nextStepCfg = self:GetGuideCfg(nextStepId)
    if self.nextStepCfg.group ~= self.curGuideData.group and self:CheckGuideIsDone(self.curGuideData.stepId) then
        self.curGroupId = self.nextStepCfg
    end
end

function NewBieGuideDataManager:GetGroupById(stepId)
    local cfg = self:GetGuideCfg(stepId)
    if self.GuideData[cfg.group] ~= nil then
        return self.GuideData
    end
end

function NewBieGuideDataManager:CleanAllGuideData()
    self.guideData = {}
end

function NewBieGuideDataManager:GetGuideCfg(stepId)
    local rtnCfg = nil
    if stepId then
        rtnCfg = CommonHelper:GetTableDataByID(ConfigNames.newbieguide2_config, stepId)
    end
    return rtnCfg
end

function NewBieGuideDataManager:IsRallyGuide()
    if self.guideData == nil then
        return false
    end
    if self.curGroupId ~= self.curGuideStep.group then
        return false
    end
    return true
end

function NewBieGuideDataManager:IsCurGuide(guideTaskId)

end
-- 引导数据替换
function NewBieGuideDataManager:SwitchCurGuideStep()
    print("下一个")
    if self.curGuideStep == nil then
        return
    end
    --- -1 没有下步引导
    if self.curGuideStep.nextStep == -1 then
        NewBieSubSystem:Get():SendMsgUpdateGuideStepRes(99)

        --local beginTime, beginLv = NetEaseDataManager:Get():GetPoneTutorialParam()

        --NetEasePoneFunc:Get():TutorialLog(PlayerDataManager:Get():GetPlayerServerID(), tostring(PlayerDataManager:Get():GetPlayerID()), PlayerDataManager:Get():GetPlayerName()
        --, tostring(self.curGroupId), ClientDataManager:Get():GetTemplateString(self.guideData[self.curGroupId][1].Desc), tostring(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())), beginLv, PlayerDataManager:Get():GetPlayerLV(), self.ClickCount, CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - beginTime, 1)
        self.curGroupId = GuideState.GuideStateExit
        PlayerDataManager:Get():SetGuideStep(GuideState.GuideStateExit)
        self.curGuideStep = nil
        self.PlayerHasGuide = false
        CommonHelper:CloseGuideScreenEffectUIMask()
        CSLuaHelper:Get():SetNewPlayerGuideState(self.PlayerHasGuide)
        return
    end
    local nextStep = self:GetGuideCfg(self.curGuideStep.nextStep)
    if nextStep ~= nil and  self.curGuideStep.isKey == GuideStepIsKey.IsKey then
            local group=nil
        if ClientDataManager:Get().IsConfig2 then
            group= CommonHelper:GetTableDataByID(ConfigNames.guidegroup2_config, self.curGuideStep.group)
        else
            group= CommonHelper:GetTableDataByID(ConfigNames.guidegroup_config, self.curGuideStep.group)
        end

          --  NewBieSubSystem:Get():SendMsgUpdateGuideStepRes(group.NextGroup)
            PlayerDataManager:Get():SetGuideStep(group.NextGroup)
    end
    if nextStep ~= nil then
        -- 切换为下一次引导
        self.curGuideStep = nextStep
    end
end
--[[
	获取当前的引导步骤
]]
function NewBieGuideDataManager:GetCurGuideStep()
    return self.curGuideStep
end

--[[
	对当前的引导步骤置零
]]
function NewBieGuideDataManager:CleanCurGuideStep()
    self.curGuideStep = 0 --当前正在执行的引导步骤数
end

function NewBieGuideDataManager:Reset()
    self.guideData = {}
end

function NewBieGuideDataManager:IsNeedShowGuide(uiname)
    if self.curGroupId == GuideState.GuideStateExit then
        return false
    end
    if self.guideData == nil then
        return false
    end
    if self.curGuideStep == nil then
        return false
    end
    --if self.StepState==GuideStepState.Reallying then
    --    return false
    --end

    if self.curGuideStep.interfaceID ~= uiname then
        return false
    end
    return true
end

function NewBieGuideDataManager:CheckNextIsMain()
    local nextStep = self:GetGuideCfg(self.curGuideStep.nextStep)
    if nextStep.interfaceID == "MainMenuView" then
        UINotify:Get():SendNotification(UINotifyEvent.UpdateNewBieGuideList)
        return true
    end
    return false
end

function NewBieGuideDataManager:CheckNewBieGuide(name)
    if self:IsNeedShowGuide(name) then
        UINotify:Get():SendNotification(UINotifyEvent.StartNewBieGuide)
    end
end
function NewBieGuideDataManager:ClearData()
    self.curGroupId = nil
    self.curGuideStep = nil
    NewBieGuideDataManager:Get().StepState=GuideStepState.End
    UINotify:Get():SendNotification(UINotifyEvent.EndNewbieGuide)
end