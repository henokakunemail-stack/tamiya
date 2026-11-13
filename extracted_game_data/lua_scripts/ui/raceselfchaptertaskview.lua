---@class RaceSelfChapterTaskView : ViewBase
RaceSelfChapterTaskView = class("RaceSelfChapterTaskView", ViewBase)

function RaceSelfChapterTaskView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "RaceSelfChapterTaskViewAction")
end

function RaceSelfChapterTaskView:Awake()
    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function (hbtn)
        UIManager:Get():ClosePopup()
    end)
    self.LevelView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Level", self.gameObject, typeof(MoreRowScrollView))
    self.TaskView = UIUtil.GetTypeChildWightInputPath("MoreRowScrollView_Task", self.gameObject, typeof(MoreRowScrollView))
    self.PointGroup = {}
    for i = 0, 5 do
        local temp = UIUtil.GetChild("BoxState"..i, self.ActiveObj)
        self.PointGroup[i]=temp
    end
    self.SliderStateGroup={}
    for i = 1, 6 do
        local temp = UIUtil.GetChild("SliderState"..i, self.ActiveObj)
        table.insert(self.SliderStateGroup, temp)
    end
end

function RaceSelfChapterTaskView:OnOpen()

end
---@param data RaceSelfChapterData
function RaceSelfChapterTaskView:SetData(data)
    ---@type RaceSelfChapterData
    self.ChapterData=data
    self.SelectIdx=1
    self:SetSlider(self.ChapterData.BoxState,self.ChapterData.process)
    self:SetLevelScrollView()
    self:SetTaskScrollView()
end
function RaceSelfChapterTaskView:SetLevelScrollView()
    CommonHelper:InitMoreRowScrollView(self.LevelView,#self.ChapterData.Cops,1,function(dataIndex, itemObj, scroll)
        local data=self.ChapterData.Cops[dataIndex+1]
        CommonHelper:SetText("Normal/###levelimage",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelName,dataIndex+1))
        CommonHelper:SetText("select/###levelimage",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelName,dataIndex+1))

        if data.unlock==0 then
            local subTime=CommonHelper:SubTime(data.btime*1000)
            local day = CommonHelper:GetConvertMillSecond(subTime)
            if math.abs(day)>=1 then
                local dataTime= CommonHelper:ConvertIntToDataTime(data.btime*TimeMilliSecond_Second)
                CommonHelper:SetText("Normal/###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterDataOpen,dataTime.Month,dataTime.Day))
                CommonHelper:SetText("select/###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterDataOpen,dataTime.Month,dataTime.Day))
            else
                CommonHelper:SetText("Normal/###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterTomorrowOpen))
                CommonHelper:SetText("select/###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterTomorrowOpen))
            end
        else
            if data.isDone then
                CommonHelper:SetText("Normal/###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelProgressDone))
                CommonHelper:SetText("select/###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelProgressDone))
            else
                CommonHelper:SetText("Normal/###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelProgressNo))
                CommonHelper:SetText("select/###progress",itemObj,CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelProgressNo))
            end
        end
       CommonHelper:HButtonSetCallback("HButton",itemObj,function(hbtn)
           if self.SelectIdx~=hbtn.intData then
               self.SelectIdx=hbtn.intData
               self:SetTaskScrollView()
               CommonHelper:MoreRowView_RefreshCurList(self.LevelView,false)
           end
       end,dataIndex+1)

       CommonHelper:SetGameObjectActive("select",itemObj,self.SelectIdx==dataIndex+1)
       CommonHelper:SetGameObjectActive("Normal",itemObj,self.SelectIdx~=dataIndex+1)
        CommonHelper:SetGameObjectActive("RedPointModule",itemObj,self.ChapterData:GetCopyHasRedPoint(dataIndex+1))
    end)
end
function RaceSelfChapterTaskView:SetTaskScrollView()
    if self.ChapterData.Cops[self.SelectIdx].taskList==nil then return end
    CommonHelper:InitMoreRowScrollView(self.TaskView,#self.ChapterData.Cops[self.SelectIdx].taskList,1,function(dataIndex, itemObj, scroll)
        ---@type RaceSelfChapterTaskData
         local data=self.ChapterData.Cops[self.SelectIdx].taskList[dataIndex+1]
         local stargroup=UIUtil.GetChild("stargroup",itemObj)
         for i = 1, 3 do
            CommonHelper:SetGameObjectActive(string.format("star%dgray",i),stargroup,data.Cfg.difficultylevel==i and (data.State==RaceSelfChapterTaskState.Rally or self.ChapterData.Cops[self.SelectIdx].unlock==0 ))
            CommonHelper:SetGameObjectActive(string.format("star%d",i),stargroup,data.Cfg.difficultylevel==i and self.ChapterData.Cops[self.SelectIdx].unlock==1 and (data.State==RaceSelfChapterTaskState.Get or data.State==RaceSelfChapterTaskState.Done))
         end
        local color=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskColor2)
        local state=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState1)
        if self.ChapterData.Cops[self.SelectIdx].unlock==0 then
            color=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskColor2)
            state=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState1)
        else
            if data.State==RaceSelfChapterTaskState.Get then
                --color=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskColor1)
                --state=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState3)
            elseif data.State==RaceSelfChapterTaskState.Rally then
                color=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskColor1)
                state=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState2)
            elseif data.State==RaceSelfChapterTaskState.Done then
                color=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskColor1)
                state=CommonHelper:GetTempStr_Default(TemplateStringID.RaceSelfChapterLevelTaskState3)
            end
        end

        CommonHelper:SetText("###desctask",itemObj,string.format(color,CommonHelper:GetLevelPassDesc(tonumber(data.Cfg.cond),data.Cfg.succval)))
        CommonHelper:SetText("###score",itemObj,string.format(color,CommonHelper:GetTempStr_Default(TemplateStringID.NoviceaActiveAdd,data.Cfg.sumpoint)))
        if self.ChapterData.Cops[self.SelectIdx].unlock==1 and data.State==RaceSelfChapterTaskState.Get then
            CommonHelper:SetGameObjectActive("BtnGetReward",itemObj,true)
            CommonHelper:SetText("###state",itemObj,"")
        else
            CommonHelper:SetGameObjectActive("BtnGetReward",itemObj,false)
            CommonHelper:SetText("###state",itemObj,string.format(color,state))
        end

        local rewards={}
        local awardids=stringSplitToNumber(data.Cfg.goodsids,':')
        local nums=stringSplitToNumber(data.Cfg.goodsnums,':')
        for i = 1, #awardids do
            local data=RewardData()
            data:SetDataIdNum(awardids[i],nums[i])
            table.insert(rewards,data)
        end
        for i = 1, 2 do
            local ItemComObj = CommonHelper:SetGameObjectActive("ItemCom_" .. i, itemObj,rewards[i]~=nil)
            if rewards[i] then
                local param = Param_ItemArticleParam()
                param.count = rewards[i].num
                CommonHelper:SetItemComGroup(ItemComObj,UIModuleID.RaceSelfChapterTask,rewards[i].id,param,function(data)
                    CommonHelper:ShowPartInfoByCfgId(tonumber(data), UIModuleID.RaceSelfChapterTask)
                end,rewards[i].id)
            end
        end
        CommonHelper:HButtonSetCallback("BtnGetReward",itemObj,function(hbtn)
            RaceSelfChapterSubsystem:Get():SendMsg_GetSelfChapterStarRewardDetail(self.ChapterData.Cops[self.SelectIdx].copyid,self.ChapterData.Cops[self.SelectIdx].taskList[hbtn.intData+1].Cfg.starid)
        end,dataIndex)
    end)
end
local _CurBoxState=nil
---@param boxstate PVEChapterBoxData[]
function RaceSelfChapterTaskView:SetSlider(boxstate,value)
    if boxstate==nil or #boxstate<1 then return end
    _CurBoxState=boxstate
    local BoxSlider = {}
    CommonHelper:SetSlider("SliderBaseColor",self.gameObject,value/boxstate[#boxstate].star)
    local done=true
    for i = 1, #boxstate do
        local num=math.modf((boxstate[i].star/boxstate[#boxstate].star)*100)
        table.insert( BoxSlider,num*0.01)
        if done and boxstate[i].state~=LevelBoxState.ReceiveCompleted then
            done=false
        end
    end
    CommonHelper:SetGameObjectActive("chapterdone",self.gameObject,done)
    CommonHelper:SetBoxStateSlider("processgroup",self.gameObject,BoxSlider,function(item,index,BoxSlider)
        CommonHelper:SetBoxState("BoxData",item, boxstate[index+1].state)
        CommonHelper:SetText("haveopen/###value",item,boxstate[index+1].star)
        CommonHelper:SetText("canopen/###value",item,boxstate[index+1].star)
        CommonHelper:SetText("notopen/###value",item,boxstate[index+1].star)
        CommonHelper:HButtonSetCallback("BoxBtn",item,function (hbtn)
            self:ClickBoxBtn(index+1)
        end,index)
    end)
end
function RaceSelfChapterTaskView:ClickBoxBtn(i)
    if _CurBoxState[i].state==LevelBoxState.CanReceive then
        RaceSelfChapterSubsystem:Get():SendMsg_GetSelfChapterReward( self.ChapterData.id,_CurBoxState[i].star)
    elseif _CurBoxState[i].state==LevelBoxState.CanNotReceive then
        CommonHelper:ShowRewardPopup(_CurBoxState[i].rewards,ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
    else
        CommonHelper:ShowRewardPopup(_CurBoxState[i].rewards,ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
    end
end
function RaceSelfChapterTaskView:Refresh()
    self.ChapterData=RaceSelfChapterDataManager:Get():GetCurChapterData()
    CommonHelper:MoreRowView_RefreshCurList(self.LevelView,false)
    CommonHelper:MoreRowView_RefreshCurList(self.TaskView,false)
    self:SetSlider(self.ChapterData.BoxState,self.ChapterData.process)
end
function RaceSelfChapterTaskView:ReOpen()

end
function RaceSelfChapterTaskView:OnClose()
   CommonHelper:ReleasePool(UIModuleID.RaceSelfChapterTask)
end
