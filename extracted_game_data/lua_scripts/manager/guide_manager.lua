---@class GuideManager
GuideManager=class("GuideManager")
function GuideManager:initialize()
    self.PlayerHasGuide = false
    self.GuideGroupCfg=ClientDataManager:Get():GetDataTable(ConfigNames.guidegroup_config)
end

function GuideManager:Get()
    if self._instance == nil then
        self._instance = GuideManager()
    end
    return self._instance
end

function GuideManager:Init(groupId,isCheck)
    if groupId==nil then return end
    if GameProperties.NewBieGuide==false then return end
    if PlayerDataManager:Get():GetPlayerLV()>8 and groupId<GuideState.GuideNewPlayer then
        self.curGroupId=GuideState.GuideStateAllExit
        PlayerDataManager:Get():SetGuideStep(self.curGroupId)
        return 
    end
    if self.curGroupId and self.curGroupId==groupId then return end
    if isCheck==nil then isCheck=false end
    if self.curGroupId == nil or isCheck then
        self.curGroupId = groupId
        self.ClickCount = 0
        ---@type table<number,table<number,GuideData>>
        self.guideData = nil --当前所有的引导VO数据
        ---@type GuideData
        self.curGuideStep = nil --当前正在执行的引导数据
        ---@type GuideBase
        self.CurGuide = 0 --当前正在执行的引导
        ---@type table<number,GuideBase>>
        self.GuideStepDic={}
        self:CheckLvTriggerGuide()
        self:CheckGuide()
        self:InitGuideStep()
        self:SetPlayerGuide(groupId)
    end
end

function GuideManager:CheckGuide()
    if self:CheckGuideExit(self.curGroupId) then
        self:LoadConfig()
        if self.curGroupId == GuideState.GuideStateNoExecute then
            if ClientDataManager:Get():GetIsNew() and PlayerDataManager:Get():GetPlayerRID()<=0 then
                self.curGroupId = GuideState.GuideStartId
            else
                self.curGroupId = GuideState.GuideStartId2
            end
        end
        if not ClientDataManager:Get():GetIsNew() then
            if self.curGroupId == GuideState.GuideStartId then
                self.curGroupId = GuideState.GuideStartId2
            end
        end
        if self.guideData[self.curGroupId] then
            self.curGuideStep = self.guideData[self.curGroupId][1]
        end

        --NetEasePoneFunc:Get():TutorialLog(PlayerDataManager:Get():GetPlayerServerID(), tostring(PlayerDataManager:Get():GetPlayerID()), PlayerDataManager:Get():GetPlayerName()
        --, tostring(self.curGroupId), ClientDataManager:Get():GetTemplateString(self.guideData[self.curGroupId][1]:GetDesc()), tostring(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())), PlayerDataManager:Get():GetPlayerLV(), -1, -1, -1, 0)
        --NetEaseDataManager:Get():SetPoneTutorialParam(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()), PlayerDataManager:Get():GetPlayerLV())

        if self.curGroupId~=GuideState.GuideStarCloseId  then
            CommonHelper:PlayGuideScreenEffectUIMask()
        end
    else
        return
    end
end
function GuideManager:CheckGuideExit(groupid)
    local flag =true
    flag= not self.GuideGroupCfg.CheckEndGroupId(groupid)
    if groupid==GuideState.GuideStateAllExit then
        flag=false
    end
    if groupid==90011 then
        flag=false
    end
    if groupid==-1 then
        flag= false
    end
    if groupid==nil then
        flag= false
    end
    return flag
end
function GuideManager:CheckLvTriggerGuide()
    if self.curGroupId then
        if self.curGroupId <= GuideState.GuideNewPlayer then return end
        if self.GuideGroupCfg.CheckEndGroupId(self.curGroupId)then
        else
            if self.curGroupId > GuideState.GuideStateLevelTrigger then
                self.curGroupId=GuideState.GuideStateAllExit
                PlayerDataManager:Get():SetGuideStep(self.curGroupId)
                return
            end
        end

        if GameProperties.NewBieGuide==false  then return end
        -- if self.curGroupId ==GuideState.GuideState8Exit then return end
        local unlockTable = UnlockDataManager:Get():GetUnlockByLevelID(PlayerDataManager:Get():GetPlayerLV())--这是解锁的表
        local funcId = {}
        if unlockTable ~= nil then
            for funcIdKey, funcIdKeyValue in pairs(unlockTable) do
                table.insert(funcId, funcIdKeyValue)
            end
        end
        local guideId=-1
        if #funcId > 0 then
            for i = 1, #funcId do
                ---@type functionlist_config_cell
                local cfg = nil
                if ClientDataManager:Get().IsConfig2 then
                    cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist2_config, funcId[i])
                else
                    cfg=CommonHelper:GetTableDataByID(ConfigNames.functionlist_config, funcId[i])
                end

                if cfg.newbieguideId~=-1 and guideId==-1 then
                    guideId=cfg.newbieguideId
                end
            end
        end
        if guideId==-1 then return end
        local group= nil
        if ClientDataManager:Get().IsConfig2 then
            group=CommonHelper:GetTableDataByID(ConfigNames.guidegroup2_config, guideId)
        else
            group=CommonHelper:GetTableDataByID(ConfigNames.guidegroup_config, guideId)
        end
        if group==nil then return  end
        if self.GuideGroupCfg.CheckPlayerGroupEnd(self.curGroupId,guideId) then return end
        if self.GuideGroupCfg.CheckPlayerGroupIsGroup(self.curGroupId,guideId) then
        else
            self.curGroupId=guideId
        end
        PlayerDataManager:Get():SetGuideStep(self.curGroupId)
    end
end

function GuideManager:LoadConfig()

    self.guideData = {} --当前所有的引导VO数据
    ---@type newbieguide_config
    local cfg = nil
    if ClientDataManager:Get().IsConfig2 then
        ---@type newbieguide_config
        cfg = ClientDataManager:Get():GetDataTable(ConfigNames.newbieguide2_config)
    else
        ---@type newbieguide_config
        cfg = ClientDataManager:Get():GetDataTable(ConfigNames.newbieguide_config)
    end
    for k, v in pairs(cfg.GetConfigData()) do
        if self.guideData[v.group] == nil then
            self.guideData[v.group] = {}
        end
        local guideData=GuideData(v)
        table.insert(self.guideData[v.group], guideData)
    end
    for k, v in pairs(self.guideData) do
        table.sort(v, function(a, b)
            return a.guideCfg.C_ID < b.guideCfg.C_ID
        end)
    end

end

function GuideManager:GetCurGuideStep()
    return self.curGuideStep
end
---@return GuideData
function GuideManager:GetLastGuideStep()
    return self.LastGuideStep
end
function GuideManager:InitGuideStep()
    self.GuideStepDic[GuideType.DialogGuide]=DialogGuide()
    self.GuideStepDic[GuideType.ClickGuide]=ClickGuide()
    self.GuideStepDic[GuideType.KeyGuide]=KeyGuide()
    self.GuideStepDic[GuideType.BreakGuide]=BreakGuide()
end

function GuideManager:Execute(uiname,type,endFunc,param)
    --try( function()
        if self:IsNeedShowGuide(uiname,type,param) then
            print("新手引导",self.curGuideStep:GetId(),self.curGuideStep:GetDesc())
            local guide= self.GuideStepDic[self.curGuideStep:GetType()]
            if guide then
                local enter= guide:Enter(self.curGuideStep)
                if enter then
                    self.CurGuide=guide
                    self.CurGuide.EndFunc=endFunc
                    self.CurGuide:Execute()
                end
            else
                if endFunc then
                    endFunc()
                    endFunc=nil
                end
                CommonHelper:CloseGuideScreenEffectUIMask()
                log("没有该类型的引导")
            end
        else
            if endFunc then
                endFunc()
                endFunc=nil
            end
            CommonHelper:CloseGuideScreenEffectUIMask()
            log("当前界面没有新手引导")
        end
    --end).catch(function(error)
       -- logError(error)
   -- end)
end

function GuideManager:End()
    try( function()
        if self.curGuideStep then
            log("新手引导结束",self.curGuideStep:GetId())
            self.ClickCount=self.ClickCount+1
            if self.curGuideStep:GetVideoName()~="-1" then
                self.PlayVideo=true
                CommonHelper:PlayGuideScreenEffectUIMask()
                local video=stringSplit(self.curGuideStep:GetVideoName(),',')
                self.CurGuide:StopVoice()
                UIManager:Get():HidePersistentView("NewbieGuideView")
                if video[2]=="-1" then
                    video[2]=nil
                end
                CommonHelper:PlayerVideo(video[1], function()
                    self.PlayVideo=false
                    CommonHelper:CloseGuideScreenEffectUIMask()
                    if self.CurGuide then
                        self.CurGuide:End()
                    end
                end,video[2],nil,tonumber(video[3])==1)


            else
                if self.CurGuide then
                    self.CurGuide:End()
                end
            end
        end
    end).catch(function(error)
        logError(error)
    end)
end
function GuideManager:Kill()
    if self.curGuideStep then
        log("新手引导结束",self.curGuideStep:GetId())
        if self.CurGuide then
            self.CurGuide:Kill()
        end
    end
end


function GuideManager:IsCompleteTypeIsClose()
    if self:GetCurGuideStep() then
        return  self:GetCurGuideStep():GetCompleteType()==GuideCompletType.CloseView or self:GetCurGuideStep():GetCompleteType()==GuideCompletType.OpenPopupClose
    end
    return false
end
function GuideManager:IsCompleteTypeIsOpen()
    if self:GetCurGuideStep() then
        if self:GetCurGuideStep():GetCompleteType()==GuideCompletType.OpenView then
            GuideManager:Get():End()
        end
    end
end


function GuideManager:SetPlayerGuide(groupId)
    local step= groupId and groupId or  PlayerDataManager:Get():GetGuideStep()
    local flag =false
    flag =self:CheckGuideExit(step)
    if GameProperties.NewBieGuide==false then
        flag=false
    end
    self.PlayerHasGuide=flag
    CSLuaHelper:Get():SetNewPlayerGuideState(self.PlayerHasGuide)
end

function GuideManager:GetPlayerHasGuide()
    return self.PlayerHasGuide
end

function GuideManager:GetLastTriggerTime() return self.lastTriggerTime end

function GuideManager:SetLastTriggerTime(trigger_time) self.lastTriggerTime=trigger_time end

function GuideManager:Skip()
    if self.CurGuide then
        self.CurGuide:Skip()
    end
end
function GuideManager:SwitchEnd()
    UIManager:Get():HidePersistentView("NewbieGuideView")
    self.curGroupId = GuideState.GuideStateExit
    PlayerDataManager:Get():SetGuideStep(self.curGroupId)
    NewBieSubSystem:Get():SendMsgUpdateGuideStepRes(self.curGroupId)
    self.curGuideStep = nil
    self.PlayerHasGuide = false
    CommonHelper:CloseGuideScreenEffectUIMask()
    CSLuaHelper:Get():SetNewPlayerGuideState(self.PlayerHasGuide)
    PlayerDataManager:Get():SetGuideStep(self.curGroupId)
end
function GuideManager:SwitchCurEnd()
    UIManager:Get():HidePersistentView("NewbieGuideView")
    local group= nil
    if ClientDataManager:Get().IsConfig2 then
        group= CommonHelper:GetTableDataByID(ConfigNames.guidegroup2_config, self.curGuideStep:GetGroup())
    else
        group= CommonHelper:GetTableDataByID(ConfigNames.guidegroup_config, self.curGuideStep:GetGroup())
    end
    self.curGroupId = group.NextGroup
    PlayerDataManager:Get():SetGuideStep(self.curGroupId)
    NewBieSubSystem:Get():SendMsgUpdateGuideStepRes(self.curGroupId)
    self.curGuideStep = nil
    self.PlayerHasGuide = false
    CommonHelper:CloseGuideScreenEffectUIMask()
    CSLuaHelper:Get():SetNewPlayerGuideState(self.PlayerHasGuide)
    PlayerDataManager:Get():SetGuideStep(self.curGroupId)
end


function GuideManager:Switch()
    print("下一个")
    if self.curGuideStep == nil then
        return
    end
    if  self.curGuideStep:GetNextStep() == -1 then
        --local beginTime, beginLv = NetEaseDataManager:Get():GetPoneTutorialParam()
        --NetEasePoneFunc:Get():TutorialLog(PlayerDataManager:Get():GetPlayerServerID(), tostring(PlayerDataManager:Get():GetPlayerUID()), PlayerDataManager:Get():GetPlayerName()
        --, tostring(self.curGroupId), ClientDataManager:Get():GetTemplateString(self.guideData[self.curGroupId][1]:GetDesc()), tostring(CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime())), beginLv, PlayerDataManager:Get():GetPlayerLV(), self.ClickCount, CommonHelper:ConvertDateTimeToInt(CommonHelper:GetNowTime()) - beginTime, 1)
        UIManager:Get():HidePersistentView("NewbieGuideView")
        UINotify:Get():SendNotification(UINotifyEvent.MainMenuView_SetLuaViewInfo,{"GuideCheck",true})
        local group= nil
        if ClientDataManager:Get().IsConfig2 then
             group= CommonHelper:GetTableDataByID(ConfigNames.guidegroup2_config, self.curGuideStep:GetGroup())
        else
            group= CommonHelper:GetTableDataByID(ConfigNames.guidegroup_config, self.curGuideStep:GetGroup())
        end
        self.curGroupId = group.NextGroup
        PlayerDataManager:Get():SetGuideStep(self.curGroupId)
        if group.C_ID<GuideState.GuideStateLevelTrigger then
            NewBieSubSystem:Get():SendMsgUpdateGuideStepRes(group.NextGroup)
        end
        self.curGuideStep = nil
        self.PlayerHasGuide = false
        CommonHelper:CloseGuideScreenEffectUIMask()
        CSLuaHelper:Get():SetNewPlayerGuideState(self.PlayerHasGuide)
        PlayerDataManager:Get():SetGuideStep(group.NextGroup)
        return
    end
    local nextStep = self:GetGuideCfg(self.curGuideStep:GetNextStep())
    if nextStep ~= nil and  self.curGuideStep:GetIsKey() == GuideStepIsKey.IsKey and self.curGuideStep:GetGroup()~=GuideState.GuideStartId then
        local group= nil
        if ClientDataManager:Get().IsConfig2 then
            group= CommonHelper:GetTableDataByID(ConfigNames.guidegroup2_config, self.curGuideStep:GetGroup())
        else
            group= CommonHelper:GetTableDataByID(ConfigNames.guidegroup_config, self.curGuideStep:GetGroup())
        end
        if group.C_ID<2999 then
            NewBieSubSystem:Get():SendMsgUpdateGuideStepRes(group.NextGroup)
        end
        PlayerDataManager:Get():SetGuideStep(group.NextGroup)
    end
    if nextStep ~= nil then
        -- 切换为下一次引导
        self.LastGuideStep=self.curGuideStep
        self.curGuideStep = nextStep

    end
end

function GuideManager:GetGuideCfg(stepId)
    local rtnCfg = nil
    if stepId then
        local cfg = nil
        if ClientDataManager:Get().IsConfig2 then
            ---@type newbieguide_config
            cfg = CommonHelper:GetTableDataByID(ConfigNames.newbieguide2_config,stepId)
        else
            ---@type newbieguide_config
            cfg = CommonHelper:GetTableDataByID(ConfigNames.newbieguide_config,stepId)
        end
        if cfg then
            for i = 1, #self.guideData[cfg.group] do
                if self.guideData[cfg.group][i]:GetId()==stepId then
                    rtnCfg=self.guideData[cfg.group][i]
                    break
                end
            end
        end
    end
    return rtnCfg
end

function GuideManager:IsNeedShowGuide(uiname,type,param)
    if not self:CheckGuideExit(self.curGroupId) then
        return false
    end
    if self.guideData == nil then
        return false
    end
    if self.curGuideStep == nil then
        return false
    end
    if type and type==GuideTriggerType.Battle then
        return true
    end
    if type and type==GuideTriggerType.LevelTrigger then
        return true
    end
   if type and type==GuideTriggerType.BattleError then
        return true
    end
    if type and type==GuideTriggerType.PveLevelTrigger then
        local levelData=RaceSeniorTrainManager:Get():GetLevelDataByLevelId(param)
        if levelData.starNum<1 then
            return true
        else
            return false
        end

    end
    if self.curGuideStep:GetInterfaceID() ~= uiname then
        return false
    end
    return true
end
function GuideManager:CheckGuideIsGuideStartId2()

   return self.curGroupId == GuideState.GuideStartId2
end
function GuideManager:ClearData()

    self.curGroupId = nil
    self.curGuideStep = nil
    self.GuideStepDic=nil
end
function GuideManager:Break()
    if self.CurGuide and self.CurGuide~=0  then
        self.CurGuide:Break()
    end
    UIManager:Get():HidePersistentView("NewbieGuideView")
    CommonHelper:CloseGuideScreenEffectUIMask()
    self:ClearData()
end

