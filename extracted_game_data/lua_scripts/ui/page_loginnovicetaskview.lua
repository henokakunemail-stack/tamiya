---@class Page_LoginNoviceTaskView
Page_LoginNoviceTaskView = class("Page_LoginNoviceTaskView")

function Page_LoginNoviceTaskView:initialize()
    self.TogGroup={}
end
---@type TaskData[]
local _CurData=nil
local _CurPage=nil
function Page_LoginNoviceTaskView:SetRoot(root)
    self.parentPref=root
    for i = 1, 7 do
        local  tog=CommonHelper:HButtonSetCallback("TogDay"..i,self.parentPref,function(btnData)
            self:ClickTog(btnData.intData,true)
        end,i)
        self.TogGroup[i]=tog
    end
    self.ScrollView=UIUtil.GetTypeChildWightByParent("ScrollView",self.parentPref,typeof(MoreRowScrollView))
end

function Page_LoginNoviceTaskView:SetData()
    self:ClickTog(LoginTaskDataManager:Get().Day,false)
    self:UpdateRedPoint()
    self:SetTime()
    self:SetTogClick()
    self:SetBoxSlider()
end

function Page_LoginNoviceTaskView:RefreshCurView()
    self:ClickTog(_CurPage,false)
    self:UpdateRedPoint()
    self:SetTime()
    self:SetBoxSlider()
end

function Page_LoginNoviceTaskView:ClickTog(index,flag)
    if index==_CurPage and flag then return end
    _CurPage=index
    if _CurPage>7 then
        _CurPage=7
    end
    for i = 1, #self.TogGroup do
        CommonHelper:SetToggleState(self.TogGroup[i],_CurPage==i)
    end
    _CurData=LoginTaskDataManager:Get().NoviceData[_CurPage]
    self:SetScrollView()
end
function Page_LoginNoviceTaskView:SetTogClick()
    for i = 1, #self.TogGroup do
        CommonHelper:SetGameObjectActive("lock",self.TogGroup[i].gameObject,i>LoginTaskDataManager:Get().Day)
        CommonHelper:SetGameObjectActive("look",self.TogGroup[i].gameObject,i>LoginTaskDataManager:Get().Day)
    end
end

function Page_LoginNoviceTaskView:UpdateRedPoint()
    local tog=LoginTaskDataManager:Get().NoviceDays
    for i = 1, #self.TogGroup do
        CommonHelper:SetGameObjectActive("RedPoint",self.TogGroup[i].gameObject,tog[i])
    end
end

function Page_LoginNoviceTaskView:SetScrollView()
    if _CurData then
        CommonHelper:InitMoreRowScrollView(self.ScrollView,#_CurData,1,function(dataIndex,itemObj,scroll)
            if dataIndex and  _CurData[dataIndex+1] then
                ---@type TaskData
                local taskData=_CurData[dataIndex+1]
                local status1=  CommonHelper:SetGameObjectActive("task_item_1",itemObj,taskData.status<=TaskStatus.IsRally)
                local status2=  CommonHelper:SetGameObjectActive("task_item_2",itemObj,taskData.status==TaskStatus.IsDoneNoGet)
                local status3=  CommonHelper:SetGameObjectActive("task_item_3",itemObj,taskData.status==TaskStatus.IsDoneAndGet)
                local status=nil
                if taskData.status<=TaskStatus.IsRally then
                    status=status1
                end
                if taskData.status==TaskStatus.IsDoneNoGet then
                    status=status2
                end
                if taskData.status==TaskStatus.IsDoneAndGet then
                    status=status3
                end
                CommonHelper:SetText("###taskdesc", status,  taskData.description)
                CommonHelper:SetText("###activevalue", status, CommonHelper:GetTempStr_Default(TemplateStringID.NoviceaActiveAdd,taskData.active))
                local finshNum=taskData.finshNum
                local progress=taskData.progress
                if finshNum>progress then
                    finshNum=progress
                end
                local progress=string.format(ClientDataManager:Get():GetTemplateString(TemplateStringID.TaskItemProgress),finshNum,progress)
                CommonHelper:SetText("###taskprogresscount",status,progress )
                for i = 1, 3 do
                    local tempObj=UIUtil.GetChild("reward"..i,itemObj)
                    if taskData.rewards[i] then
                        CommonHelper:SetPropGroupByRewardData(tempObj,taskData.rewards[i],UIModuleID.TaskLogin)
                    end
                    CommonHelper:CSGameObjectSetActive(tempObj,taskData.rewards[i]~=nil)
                end

                local btnTask=CommonHelper:HButtonSetCallback("btntaskitem",itemObj,function(tempData)
                    if _CurData[tempData.intData+1].status==TaskStatus.IsDoneNoGet then
                        TaskSubsystem:Get():SendMsg_GetReward(_CurData[tempData.intData+1].questType,_CurData[tempData.intData+1].taskId,_CurData[tempData.intData+1].day)
                    end
                    if _CurData[tempData.intData+1].status==TaskStatus.IsRally then
                        FunctionSkipManager:Get():SkipToFunction(_CurData[tempData.intData+1].SkipParam[1],_CurData[tempData.intData+1].SkipParam[2])
                    end
                end,dataIndex)
                CommonHelper:SetGameObjectActive("btntaskitem",itemObj,taskData.status~=TaskStatus.IsDoneAndGet)
                CommonHelper:SetToggleState(btnTask,taskData.status==TaskStatus.IsDoneNoGet and taskData.day<=LoginTaskDataManager:Get().Day)
                CommonHelper:SetHButtonClick(btnTask,(taskData.status==TaskStatus.IsDoneNoGet or  taskData.status==TaskStatus.IsRally) and taskData.day<=LoginTaskDataManager:Get().Day,taskData.day>LoginTaskDataManager:Get().Day)
                local  btnBg=UIUtil.GetTypeChildWightByParent("Bg (2)",btnTask.gameObject,typeof(Image))
                CommonHelper:ImageSetGray(btnBg,taskData.status~=TaskStatus.IsDoneNoGet)
            end
        end)
    end
end
function Page_LoginNoviceTaskView:SetTime()
    CommonHelper:SetText("###subTime",self.parentPref,LoginTaskDataManager:Get().LeftTime)
end

function Page_LoginNoviceTaskView:SetActive()

end
function Page_LoginNoviceTaskView:SetActiveView(prop)
    CommonHelper:SetText("###activenum",self.parentPref,tostring(LoginTaskDataManager:Get().NoviceActiveNum))
    local obj=UIUtil.GetChild("rewardview",self.parentPref)
    CommonHelper:SetPropGroupByRewardData(obj,prop,UIModuleID.TaskLogin)
end



function Page_LoginNoviceTaskView:SetBoxSlider()
    local BoxSlider = {}
    for i = 1, #LoginTaskDataManager:Get().NoviceActive do
        local num=math.modf((LoginTaskDataManager:Get().NoviceActive[i].activeNum/LoginTaskDataManager:Get().NoviceActive[#LoginTaskDataManager:Get().NoviceActive].activeNum)*100)
        table.insert( BoxSlider,num*0.01)
    end
    self.BoxStateSlider=  CommonHelper:SetBoxStateSlider("processgroup", self.parentPref, BoxSlider,function(item,index,boxSlider)
        ---@type NoviceTaskActiveData
        local data =LoginTaskDataManager:Get().NoviceActive[index+1]
        if data then
            CommonHelper:SetBoxState("BoxData", item, data.state)
            CommonHelper:SetText("notopen/###value",item,data.activeNum)
            CommonHelper:SetText("canopen/###value",item,data.activeNum)
            CommonHelper:SetText("haveopen/###value",item,data.activeNum)
            CommonHelper:HButtonSetCallback("BoxBtn",item,function (hbtn)
                local temp = LoginTaskDataManager:Get().NoviceActive[hbtn.intData+1]
                if temp then
                    if temp.state == 0 then
                        CommonHelper:ShowRewardPopup(temp.activeReward,ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardPreview))
                    end
                    if temp.state == 1 then
                        TaskSubsystem:Get():SendMsg_GetActiveReward(temp.activeType,temp.activeNum)
                    end
                    if temp.state == 2 then
                        CommonHelper:ShowRewardPopup(temp.activeReward,ClientDataManager:Get():GetTemplateString(TemplateStringID.RewardGeted))
                    end
                end
            end,index)
        end

    end)
    if LoginTaskDataManager:Get().NoviceActiveNum  then
        local per = LoginTaskDataManager:Get().NoviceActiveNum / LoginTaskDataManager:Get().NoviceActive[#LoginTaskDataManager:Get().NoviceActive].activeNum
        CommonHelper:SetSlider("SliderBaseColor", self.parentPref, per)
        local prop=LoginTaskDataManager:Get().NoviceActive[1].activeReward
        if LoginTaskDataManager:Get().NoviceActiveNum>=LoginTaskDataManager:Get().NoviceActive[#LoginTaskDataManager:Get().NoviceActive].activeNum then
            prop=LoginTaskDataManager:Get().NoviceActive[#LoginTaskDataManager:Get().NoviceActive].activeReward[1]
        else
            for i = 1, #LoginTaskDataManager:Get().NoviceActive do
                if LoginTaskDataManager:Get().NoviceActiveNum<LoginTaskDataManager:Get().NoviceActive[i].activeNum then
                    prop=LoginTaskDataManager:Get().NoviceActive[i].activeReward[1]
                    break
                end
            end
        end
       -- self:SetActiveView(prop)
    end
end


