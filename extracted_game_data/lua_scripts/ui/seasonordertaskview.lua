---@class SeasonOrderTaskView : ViewBase
SeasonOrderTaskView = class("SeasonOrderTaskView", ViewBase)
function SeasonOrderTaskView:initialize()
    ViewBase.initialize(self)
    ViewBase.RegisteAction(self, "SeasonOrderTaskViewAction")
end

function SeasonOrderTaskView:Awake()
    self.ScrollView = self:GetChildWightByParent("ScrollView", self.gameObject, typeof(MoreRowScrollView))

    CommonHelper:HButtonSetCallback("BtnClose",self.gameObject,function(data)
        UIManager:Get():ClosePopup()
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetData,{SeasonOrderDataManager:Get():GetTokenData(),false})
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetLuaViewInfo,{"SeasonOrderTaskView",false})
    end)
    CommonHelper:HButtonSetCallback("BtnClose2",self.gameObject,function(data)
        UIManager:Get():ClosePopup()
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetData,{SeasonOrderDataManager:Get():GetTokenData(),false})
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetLuaViewInfo,{"SeasonOrderTaskView",false})
    end)
    CommonHelper:HButtonSetCallback("BtnGetReward",self.gameObject,function(data)
        UIManager:Get():ClosePopup()
        SeasonOrderSubsystem:Get():SendMsg_GetSeasonInfo()
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetLuaViewInfo,{"SeasonOrderTaskView",false})
    end)
    CommonHelper:HButtonSetCallback("BtnGetLv",self.gameObject,function(data)
        if SeasonOrderDataManager:Get():GetLevelMax() then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderLevelMax))
            return
        end
        local cfg= CommonHelper:GetTableDataByID(ConfigNames.dictcalc_config,CommonCfgKey.SeasonOrderLevelBuySubDay)
        local value=tonumber(cfg.varval)
        if SeasonOrderDataManager:Get():GetDay()>value then
            CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderDayNoBuy))
            return
        end
        UIManager:Get():OpenPopup("SeasonOrderLevelView",CanvasType.FrontCanvas,"SeasonOrderLevelView")
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderLevelView_SetData,{SeasonOrderDataManager:Get():GetTokenData(),1})
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderView_SetLuaViewInfo,{"SeasonOrderTaskView",false})
    end)

end

function SeasonOrderTaskView:OnOpen()

end

function SeasonOrderTaskView:OnClose()

end

function SeasonOrderTaskView:SetData()
    local msg= SeasonOrderDataManager:Get():GetTokenData()
    ---@type act_token_lev_config
    local config= ClientDataManager:Get():GetDataTable(ConfigNames.act_token_lev_config)
    ---@type act_token_lev_config_cell
    local cell_lev=config.GetDataByAndLevel(PlayerDataManager:Get():GetPlayerServerID(),msg.tokenid,msg.lev)
    CommonHelper:SetText("###seasonexp",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderExp,msg.curexp,cell_lev.nextexp))
    CommonHelper:SetText("###seasonlv",self.gameObject,CommonHelper:GetTempStr_Default(TemplateStringID.SeasonOrderLevel,msg.lev))
    CommonHelper:SetSlider("Slider",self.gameObject,msg.curexp/cell_lev.nextexp)
    local _CurData=SeasonOrderDataManager:Get():GetTaskData()
    CommonHelper:InitMoreRowScrollView(self.ScrollView,#_CurData,1,function(dataIndex,itemObj,scroll)
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
        local value=0
      --  if taskData.status~=TaskStatus.IsDoneAndGet then
            value=taskData.finshNum/taskData.progress
        --end
        CommonHelper:SetSlider("taskprogress",itemObj,value)
        CommonHelper:SetText("###taskdesc", status,  taskData.description)
        CommonHelper:SetText("###activevalue", status, "")
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
                local param = Param_ItemArticleParam()
                param.count = taskData.rewards[i].num
                CommonHelper:SetItemComGroup(tempObj,UIModuleID.SeasonOrder,tonumber(taskData.rewards[i].id),param,function(data)
                    CommonHelper:ShowPartInfoByCfgId(tonumber(taskData.rewards[i].id), UIModuleID.SeasonOrder)
                end)
            end
            CommonHelper:CSGameObjectSetActive(tempObj,taskData.rewards[i]~=nil)
        end

        local btnTask=CommonHelper:HButtonSetCallback("btntaskitem",itemObj,function(tempData)
            if _CurData[tempData.intData+1].status==TaskStatus.IsDoneNoGet then
                TaskSubsystem:Get():SendMsg_GetReward(_CurData[tempData.intData+1].questType,_CurData[tempData.intData+1].taskId,_CurData[tempData.intData+1].day)
            end
            if _CurData[tempData.intData+1].status==TaskStatus.IsRally then
                UIManager:Get():ClosePopup()
                FunctionSkipManager:Get():SkipToFunction(_CurData[tempData.intData+1].SkipParam[1],_CurData[tempData.intData+1].SkipParam[2])
            end
        end,dataIndex)
        CommonHelper:SetGameObjectActive("btntaskitem",itemObj,taskData.status~=TaskStatus.IsDoneAndGet)
        CommonHelper:SetToggleState(btnTask,taskData.status==TaskStatus.IsDoneNoGet)
        CommonHelper:SetHButtonClick(btnTask,taskData.status==TaskStatus.IsDoneNoGet or taskData.status==TaskStatus.IsRally,false)
        local  btnBg=UIUtil.GetTypeChildWightByParent("Bg (2)",btnTask.gameObject,typeof(Image))
        CommonHelper:ImageSetGray(btnBg,taskData.status~=TaskStatus.IsDoneNoGet)
    end)
end






