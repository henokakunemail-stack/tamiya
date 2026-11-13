---@class RecruitSprintActView : ViewBase
RecruitSprintActView = class("RecruitSprintActView", ViewBase)

function RecruitSprintActView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RecruitSprintActViewAction")
end

function RecruitSprintActView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose", self.gameObject, function(data)
        UIManager:Get():ClosePopup()
    end)
    CommonHelper:HButtonSetCallback("goBtn", self.gameObject, function()
        UIManager:Get():ClosePopup()
        FunctionSkipManager:Get():SkipToFunction(GameFunction.Recruit)
    end)
    self._scrollScrollRect=self:GetChildWight("MoreRowScrollView_H",typeof(ScrollRect))
end

function RecruitSprintActView:OnOpen()
    self.ActivityData=StrengthActivityManager:Get().CurActivityData
    CommonHelper:SetNewLineText("###StrengthActivityGiftDesc",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSprintActDesc))
    CommonHelper:SetText("###activityname",self.gameObject,  CommonHelper:GetTempStr_Default(self.ActivityData.Cfg.actname))
    CommonHelper:SetText("###GachaCount",self.gameObject,  self.ActivityData.Score)
    local durationTime = string.format(CommonHelper:GetTempStr_Default(TemplateStringID.FestivalTimeText,
            self.ActivityData.BTime.Month, self. ActivityData.BTime.Day,  self.ActivityData.BTime.Hour, self.ActivityData.BTime.Minute,
            self. ActivityData.ETime.Month,  self.ActivityData.ETime.Day, self. ActivityData.ETime.Hour,  self.ActivityData.ETime.Minute))
    CommonHelper:SetNewLineText("###activitytime",self.gameObject, durationTime)
    self:SetBoxList()

end

function RecruitSprintActView:SetSliderStateGroup(num,awards)
   local progress=self:GetProgress(num,awards)
    CommonHelper:SetSlider("SliderBaseColor",self.gameObject, progress)
end
function RecruitSprintActView:GetProgress(num, awardList)
    local count = #awardList
    if count == 0 then return 0 end
    local step = 1 / (count)
    -- 小于等于第一个奖励点
    if num <= awardList[1].Cfg.score then
        return (num / awardList[1].Cfg.score) * step
    end

    -- 大于等于最后一个奖励点
    if num >= awardList[count].Cfg.score then
        return 1
    end

    -- 找到区间（从第2个点开始找）
    local curIndex = nil
    for i = 2, count do
        if num == awardList[i].Cfg.score then
            -- 恰好等于某个奖励点
            return (i) / (count)
        elseif num < awardList[i].Cfg.score then
            curIndex = i
            break
        end
    end

    -- 区间边界
    local prevScore = awardList[curIndex - 1].Cfg.score
    local curScore  = awardList[curIndex].Cfg.score

    -- 区间内插值 (0~1)
    local t = (num - prevScore) / (curScore - prevScore)

    local baseProgress = (curIndex-1) * step

    return baseProgress + t * step
end

function RecruitSprintActView:ReOpen()

end
function RecruitSprintActView:SetBoxList()
    self.ActivityData=StrengthActivityManager:Get().CurActivityData
    local BoxSlider = {}
    local awardList=self.ActivityData.AwardList
    local maxScore=awardList[#awardList].Cfg.score
    local minReward=0
    local maxReward=1
    local curReward=0
    for i = 1, #awardList do
        -- 保持平均分配的进度条值计算方式
        local num=math.modf((((maxScore/#awardList)*i)/maxScore)*100)*0.01
        table.insert( BoxSlider,num)
        if (awardList[i].State==StrengthActivityAwardState.CanReceive or awardList[i].State==StrengthActivityAwardState.CanNotReceive) and
                num>minReward and num<maxReward and curReward==0 then
            curReward=num
        end
    end
    self._scrollScrollRect.horizontalNormalizedPosition=curReward
    self.BoxSlider = CommonHelper:SetBoxStateSlider("BoxSlider", self.gameObject, BoxSlider, function(item, index, BoxSlider)
        local temp=awardList[index + 1]
        CommonHelper:HButtonSetCallback("BoxBtn", item, function(hbtn)
            CapyActivitySubsystem:Get():SendMsg_CapyActivityReward(self.ActivityData.ActType,self.ActivityData.ActType)
        end, index)
        CommonHelper:SetText("###fullText", item,temp.Cfg.score)
        CommonHelper:SetGameObjectActive("full", item, temp.State>0)
        CommonHelper:SetGameObjectActive("Hemisphere_2", item, temp.Cfg.score ~= maxScore)
        CommonHelper:SetGameObjectActive("rightHemisphere", item, temp.Cfg.score == maxScore)
        CommonHelper:SetGameObjectActive("BoxBtn", item, temp.State==StrengthActivityAwardState.CanReceive)
        local tween = UIUtil.GetTypeChildWightInputPath("BoxState", item,typeof(FXUITweenMoreGroup))
        if temp.State==StrengthActivityAwardState.CanReceive then
            CommonHelper:TMG_PlayAllTween(tween, 0)
        else
            CommonHelper:TMG_StopAllTween(tween, 0)
        end

        local rewards= CommonHelper:SetDataByStrIdAndNum(temp.Cfg.award,temp.Cfg.num)
        for i = 1, 2 do
            local obj= CommonHelper:SetGameObjectActive(string.format("reward%d",i), item, rewards[i]~=nil)
            if rewards[i] then
                local param = Param_ItemArticleParam()
                param.count=rewards[i].num
                CommonHelper:SetItemComGroup(obj, UIModuleID.StrengthActivity, rewards[i].id, param, function(btnData)
                    CommonHelper:ShowPartInfoByCfgId(btnData, UIModuleID.StrengthActivity, false)
                end, rewards[i].id)
                CommonHelper:SetGameObjectActive("haveopen", obj, temp.State==StrengthActivityAwardState.ReceiveCompleted)
                CommonHelper:SetGameObjectActive("RedPointPart", obj, temp.State==StrengthActivityAwardState.CanReceive)
                if temp.State~=StrengthActivityAwardState.CanReceive then
                    obj.transform.localRotation=Quaternion.identity
                end
            end
        end
    end)
    self:SetSliderStateGroup(self.ActivityData.Score,awardList)
end


function RecruitSprintActView:Refresh()
    self:SetBoxList()
end

function RecruitSprintActView:OnClose()

end

