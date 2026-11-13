

---@class TaskSubsystem
TaskSubsystem = class("TaskSubsystem")

function TaskSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.NOTIFY_TASK_RES , self, self.NotifyMsg_TaskList)
    NetResponseEventManager:Get():AddListener(MsgID.GET_TASK_REWARD_RES , self, self.RecvMsg_TaskReward)
    NetResponseEventManager:Get():AddListener(MsgID.GET_ACTIVE_REWARD_RES , self, self.RecvMsg_TaskActiveReward)
    NetResponseEventManager:Get():AddListener(MsgID.GET_TASK_LIST_RES , self, self.RecvMsg_TaskList)
    NetResponseEventManager:Get():AddListener(MsgID.RET_TRADE_AWARD_S2C_RES , self, self.RecvMsg_TradeAward)

    --RecvMsg_ActiveList
    --NetResponseEventManager:Get():AddListener(MsgID.GET_TASK_REWARD_S2C_RES , self, self.RecvMsg_TaskReward)
    --NetResponseEventManager:Get():AddListener(MsgID.GET_TASK_ACTIVE_REWARD_S2C_RES , self, self.RecActiveReward)
end


function TaskSubsystem:RecvMsg_TaskList(data)
    ---@type SC_TaskList
    local msg = assert(Dll_PB.decode("TaskList", data))
    print(ProtoMsgHelp.block(msg))

    if msg.curTasks and # msg.curTasks>0 and msg.curTasks[1].tasktype==TaskType.Day7 then
        LoginTaskDataManager:Get():Init(msg)
        if not UIManager:Get():IsPersistentViewShow("LoginTaskView") then
            UIManager:Get():ShowPersistentView("LoginTaskView", CanvasType.MainCanvas, "LoginTaskView", false)
        end
        RedPointManager:Get():UpdateValue(RedPointID.S_Task_7,false)
        UINotify:Get():SendNotification(UINotifyEvent.LoginNoviceTaskView_SetData)
    elseif msg.curTasks and #msg.curTasks > 0 and
            (msg.curTasks[1].tasktype == TaskType.Daily or
                    msg.curTasks[1].tasktype == TaskType.GrowUp or
                    msg.curTasks[1].tasktype == TaskType.AD or
                    msg.curTasks[1].tasktype == TaskType.Rank or
                    msg.curTasks[1].tasktype == TaskType.DailyRank or
                    msg.curTasks[1].tasktype == TaskType.SpecialTraining or
                    msg.curTasks[1].tasktype == TaskType.Jcp or
                    msg.curTasks[1].tasktype == TaskType.Xcp or
                    msg.curTasks[1].tasktype == TaskType.Recruit or
                    msg.curTasks[1].tasktype == TaskType.Novice) then
        TaskDataManager:Get():OnInit(msg,msg.curTasks[1].tasktype)
        if UIManager:Get():IsViewShow("TaskView") == false then
            UIManager:Get():OpenView("TaskView", CanvasType.MainCanvas, "TaskView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.TaskViewSetData, msg.curTasks[1].tasktype)
    elseif  msg.curTasks and # msg.curTasks>0 and msg.curTasks[1].tasktype==TaskType.SeasonOrder then
        SeasonOrderDataManager:Get():SetTaskData(msg)
        if UIManager:Get():IsViewShow("SeasonOrderTaskView")==false then
            UIManager:Get():OpenPopup("SeasonOrderTaskView", CanvasType.FrontCanvas, "SeasonOrderTaskView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.SeasonOrderTaskView_SetData)
    elseif msg.curTasks and #msg.curTasks > 0 and msg.curTasks[1].tasktype == TaskType.ReturnOldPlayer then
        ReturnOldPlayerDataManager:Get():SetSignData(msg)
        ReturnOldPlayerDataManager:Get():InitActive(msg.rebackactiveGifts)
        UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetTask)
    elseif msg.curTasks and #msg.curTasks > 0 and msg.curTasks[1].tasktype == TaskType.CommonFestivalLimitTask then
        CommonFestivalDataManager:Get():InitLimitTaskData(msg)
        CommonFestivalDataManager:Get():InitLimitTaskActive(msg)
        --if not UIManager:Get():IsPopViewShow("CommonFestivalView") then
        --    UIManager:Get():OpenPopup("CommonFestivalView", CanvasType.MainCanvas, "CommonFestivalView", true)
        --end
        --UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshLimitTask)

        if not UIManager:Get():IsPopViewShow("CommonNewActView") then
            UIManager:Get():OpenPopup("CommonNewActView", CanvasType.MainCanvas, "CommonNewActView", true)
        end
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_RefreshPage, { msg, CommonFestivalType.LimitTask })
    elseif  msg.curTasks and # msg.curTasks>0 and msg.curTasks[1].tasktype==TaskType.Club then
        TaskDataManager:Get():OnInit(msg,msg.curTasks[1].tasktype)
        RedPointManager:Get():UpdateValue(RedPointID.S_ClubTask,false)

        if not UIManager:Get():IsPersistentViewShow("ClubTaskView") then
            UIManager:Get():ShowPersistentView("ClubTaskView", CanvasType.MainCanvas, "ClubTaskView")
        end
        UINotify:Get():SendNotification(UINotifyEvent.ClubTaskView_SetData)
    elseif  msg.curTasks and # msg.curTasks>0 and msg.curTasks[1].tasktype==TaskType.CommonFestivalTimeToken then
        TimeTokenManager:Get():SetTaskData(msg.curTasks)
        UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction,{-1,"TaskViewRefresh"})
    end
    if msg.curTasks and #msg.curTasks>0 then
        self:UpdateRedPoint(msg.curTasks[1].tasktype)
    end
    if msg.curTasks==nil or  #msg.curTasks<=0 then
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.TaskNoGet))
    end
end
function TaskSubsystem:NotifyMsg_TaskList(data)
    -----@type SC_TaskList
    --local msg = assert(Dll_PB.decode("TaskList", data))
    --print(ProtoMsgHelp.block(msg))
    --if msg.curTasks[1].tasktype==TaskType.Day7 then
    --    LoginTaskDataManager:Get():Init(msg)
    --    UINotify:Get():SendNotification(UINotifyEvent.LoginNoviceTaskView_RefreshCurView)
    --else
    --    TaskDataManager:Get():OnInit(msg)
    --    if UIManager:Get():IsViewShow("TaskView") then
    --        UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
    --    end
    --end
    --UINotify:Get():SendNotification(UINotifyEvent.TaskView_SetView)
    --RedPointManager:Get():UpdateValue(RedPointID.Task)
    --RedPointManager:Get():UpdateValue(RedPointID.Task_Daily)
    --RedPointManager:Get():UpdateValue(RedPointID.Task_Week)
    --RedPointManager:Get():UpdateValue(RedPointID.Task_Achievement)
end
---@param data SC_TaskGift
function TaskSubsystem:RecvMsg_TaskReward(data)
    ---@type SC_TaskGift
    local msg = assert(Dll_PB.decode("TaskGift", data))
    print(ProtoMsgHelp.block(msg))

    if #msg.missionId > 0 then

        CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1],true)
        local taskData = CommonHelper:GetTableDataByID(ConfigNames.task_config, msg.missionId[1])
        TaskDataManager:Get():UpdateTask(msg.missionId,msg.day7taskval,msg.daytaskval)
        LoginTaskDataManager:Get():UpdateTask(msg.missionId,msg.day7taskval,msg.daytaskval)
        SeasonOrderDataManager:Get():UpdateTask(msg.missionId,msg.day7taskval,msg.daytaskval)
        if taskData.missiontype == TaskType.Daily or
                taskData.missiontype == TaskType.GrowUp or
                taskData.missiontype == TaskType.AD or
                taskData.missiontype == TaskType.Club or
                taskData.missiontype == TaskType.Rank or
                taskData.missiontype == TaskType.DailyRank or
                taskData.missiontype == TaskType.SpecialTraining or
                taskData.missiontype == TaskType.Jcp or
                taskData.missiontype == TaskType.Xcp or
                taskData.missiontype == TaskType.Recruit or
                taskData.missiontype == TaskType.Novice  then
            TaskDataManager:Get():UpdateTaskList(msg.nextMission, msg.missionId,msg.curTradeSeq)
            UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
        end
        if taskData.missiontype==TaskType.Day7 then
            UINotify:Get():SendNotification(UINotifyEvent.LoginNoviceTaskView_RefreshCurView)
        end
        if taskData.missiontype==TaskType.SeasonOrder then
            SeasonOrderDataManager:Get():UpdateTaskList(msg.nextMission,msg.missionId)
            SeasonOrderSubsystem:Get():SendMsg_GetSeasonInfo()
        end
        if taskData.missiontype == TaskType.CommonFestivalLimitTask then
            CommonFestivalDataManager:Get():RefreshGotLimitTaskData(msg)
            UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshLimitTask)
        end
        if taskData.missiontype == TaskType.CommonFestivalTimeToken then
            TimeTokenManager:Get():RefreshTaskData(msg)
            UINotify:Get():SendNotification(UINotifyEvent.CommonAct_PageRunAction,{-1,"TaskViewRefresh"})
        end

        if taskData.missiontype == TaskType.ReturnOldPlayer then
            ReturnOldPlayerDataManager:Get():SetCurTasksData(msg)
            UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetTask)
        end
        --TaskDataManager:Get():OnInit(msg)
        if msg.curGuildExp > 0 then
            ClubDataManager:Get():GetCurSelectClubData():SetCoin(msg.curGuildExp)
        end
        self:UpdateRedPoint(taskData.missiontype)

    else
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString("当前无奖励可领取"))
    end
end

---@param data SC_TaskActiveGift
function TaskSubsystem:RecvMsg_TaskActiveReward(data)
    ---@type SC_ActiveGift
    local msg = assert(Dll_PB.decode("ActiveGift", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist,true)
    if msg.taskgift.activetype==TaskType.Daily then
        TaskDataManager:Get():UpdateActive(msg.taskgift.activeval)
        UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
    elseif msg.taskgift.activetype == TaskType.ReturnOldPlayer then
        ReturnOldPlayerDataManager:Get():SetReBackActiveGifts(msg.taskgift)
        ReturnOldPlayerDataManager:Get():UpdateActive(msg.taskgift.activeval)
        UINotify:Get():SendNotification(UINotifyEvent.ReturnOldPlayer_SetTask)
    elseif msg.taskgift.activetype == TaskType.CommonFestivalLimitTask then
        CommonFestivalDataManager:Get():RefreshLimitTaskGiftData(msg.taskgift)
        UINotify:Get():SendNotification(UINotifyEvent.CommonFestival_RefreshLimitTask)
    elseif msg.taskgift.activetype == TaskType.Day7 then
        LoginTaskDataManager:Get():UpdateActive(msg.taskgift.activeval)
    else

    end
    self:UpdateRedPoint(msg.taskgift.activetype)
end

---@param data SC_ActiveGift
function TaskSubsystem:RecvMsg_ActiveList(data)
    ---@type SC_ActiveGift
    local msg = assert(Dll_PB.decode("ActiveGift", data))
    print(ProtoMsgHelp.block(msg))
   -- CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist[1])
    --TaskDataManager:Get():OnInit(msg)
end

-- 496, --请求引导任务章节奖励 P2=章节号
function TaskSubsystem:SendMsg_TradeAward(_ID)
    local p_data = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), _ID })
    NetManager:Get():Send(MsgID.REQ_TRADE_AWARD_C2S_REQ, p_data)
end


function TaskSubsystem:RecvMsg_TradeAward(data)
    ---@type SC_TaskFinish
    local msg = assert(Dll_PB.decode("TaskFinish", data))
    print(ProtoMsgHelp.block(msg))

    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist,true)
    TaskDataManager:Get():UpdateScheduleData(nil,msg.ifgift)
    if msg.tradeseq==0 then
       TaskDataManager:Get():SetNoviceFlag(1)
    end
    UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
    self:UpdateRedPoint(TaskType.Novice)
end

function TaskSubsystem:SendMsg_GetReward(type,id,day)
    local reqData=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),type,id,day})
    NetManager:Get():Send(MsgID.GET_TASK_REWARD_REQ,reqData)
end


function TaskSubsystem:SendMsg_GetActiveReward(type,id)
    local reqData=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),type,id})
    NetManager:Get():Send(MsgID.GET_ACTIVE_REWARD_REQ,reqData)
end
function TaskSubsystem:SendMsg_GetTaskList(type,uiModuleID,recruitid)
    TaskDataManager:Get():SetOpenModuleType(uiModuleID)
    TaskDataManager:Get():SetRecruitID(recruitid)
    local reqData=CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),type,recruitid or TaskDataManager:Get():GetRecruitID()})
    NetManager:Get():Send(MsgID.GET_TASK_LIST_REQ,reqData)
end

function TaskSubsystem:UpdateRedPoint(type)

    if type==TaskType.GrowUp then
        RedPointManager:Get():UpdateValue(RedPointID.S_TaskAchievement,TaskDataManager:Get():GetTaskIsDone(type))
    end
    if type==TaskType.Daily then
        RedPointManager:Get():UpdateValue(RedPointID.S_TaskDaily,TaskDataManager:Get():GetTaskIsDone(type))
    end
    if type==TaskType.Rank then
        RedPointManager:Get():UpdateValue(RedPointID.S_TaskRank,TaskDataManager:Get():GetTaskIsDone(type))
    end
    if type==TaskType.DailyRank then
        RedPointManager:Get():UpdateValue(RedPointID.S_TaskDailyRank,TaskDataManager:Get():GetTaskIsDone(type))
    end
    if type==TaskType.SpecialTraining then
        RedPointManager:Get():UpdateValue(RedPointID.S_TaskSpecialTraining,TaskDataManager:Get():GetTaskIsDone(type))
    end
    if type==TaskType.Jcp then
        RedPointManager:Get():UpdateValue(RedPointID.S_Jcp,TaskDataManager:Get():GetTaskIsDone(type))
    end
    if type==TaskType.Xcp then
        RedPointManager:Get():UpdateValue(RedPointID.S_Xcp,TaskDataManager:Get():GetTaskIsDone(type))
    end
    if type==TaskType.Recruit then
        local value="Task"
        if TaskDataManager:Get():GetTaskIsDone(type)==false then
            value=nil
        end
        RecruitDataManager:Get():RecRedPointId(TaskDataManager:Get():GetRecruitID(),value)
    end


    if type==TaskType.Novice then
        RedPointManager:Get():UpdateValue(RedPointID.S_TaskNoviceSchedule, TaskDataManager:Get():GetNoviceTaskIsDone())
        RedPointManager:Get():UpdateValue(RedPointID.S_TaskNoviceTrade, TaskDataManager:Get():GetNoviceTradeIsDone())
    end
    if type==TaskType.Day7 then
        RedPointManager:Get():UpdateValue(RedPointID.S_Task_7,LoginTaskDataManager:Get():GetTaskIsDone())
    end
    if type==TaskType.Club then
        RedPointManager:Get():UpdateValue(RedPointID.S_ClubTask,TaskDataManager:Get():GetTaskIsDone(type))
    end
    if type==TaskType.SeasonOrder then
        RedPointManager:Get():UpdateValue(RedPointID.S_TaskSeasonOrder,SeasonOrderDataManager:Get():GetTaskIsDone())
    end

end

local __subsystem=TaskSubsystem()
function TaskSubsystem:Get() return __subsystem end
return __subsystem
