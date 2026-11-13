---@class RecruitSubsystem
RecruitSubsystem = class("RecruitSubsystem")

function RecruitSubsystem:initialize(...)
    NetResponseEventManager:Get():AddListener(MsgID.RECRUIT_START_S2C_RES, self, self.RecvMsg_RecruitInfo)
    NetResponseEventManager:Get():AddListener(MsgID.RECRUIT_FINISH_S2C_RES, self, self.RecvMsg_Recruit)
    NetResponseEventManager:Get():AddListener(MsgID.RECRUIT_SHARE_S2C_RES, self, self.RecvMsg_Share)
    NetResponseEventManager:Get():AddListener(MsgID.RECRUIT_MINI_EXCHANGE_S2C_RES, self, self.RecvMsg_MiniExchange)
    NetResponseEventManager:Get():AddListener(MsgID.RECRUIT_COUNT_GET_REWARD_S2C_RES, self, self.RecvMsg_RecruitCountGetReward)
    NetResponseEventManager:Get():AddListener(MsgID.RECRUIT_COUNT_INFO_S2C_RES, self, self.RecvMsg_RecruitCountInfo)
end

local _IsRefreshData=true
function RecruitSubsystem:SendMsg_RecruitInfo(isref)
    if isref==nil then isref=0 end _IsRefreshData=isref
    local reqData = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.RECRUIT_START_C2S_REQ, reqData)
end

function RecruitSubsystem:RecvMsg_RecruitInfo(data)
    ---@type SC_UserRecruit
    local msg = assert(Dll_PB.decode("UserRecruit", data))
    print(ProtoMsgHelp.block(msg))
    PopUpGiftDataManager:Get():UpdateDataList(msg.buyItems)
    if not UIManager:Get():IsViewShow("RecruitView") and  _IsRefreshData==0 then
        RecruitDataManager:Get():InitRecruitData(msg.myRecruits,true)
        UIManager:Get():OpenView("RecruitView", CanvasType.MainCanvas, "RecruitView")
        UINotify:Get():SendNotification(UINotifyEvent.RecruitView_SetData,true)
        RedPointManager:Get():UpdateValue(RedPointID.S_RecruitFree,RecruitDataManager:Get():GetRedPointCount()>0)
    elseif  _IsRefreshData==2 then
        RecruitDataManager:Get():UpdateRecruitData(msg.myRecruits)
        UINotify:Get():SendNotification(UINotifyEvent.RecruitView_SetData,false)
    elseif  _IsRefreshData==1 then
        RecruitDataManager:Get():InitRecruitData(msg.myRecruits,false)
        UINotify:Get():SendNotification(UINotifyEvent.RecruitView_SetData,false)
    end

end

----开始抽奖，这时不能弹出邀请界面
---@param count  @招募次数 0免费
---@param selectPay @支付选择 0券 1金币/钻石
function RecruitSubsystem:SendMsg_Recruit(id, count)
    local isGuide=CommonHelper:CheckPlayerIsNewGuide() and 1 or 0
    if isGuide==nil then
        isGuide=0
    end
    local reqData =CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id,count,0,isGuide})
    NetManager:Get():Send(MsgID.RECRUIT_FINISH_C2S_REQ, reqData)
end
----发送分享奖励请求
---@param id  @扭蛋id
function RecruitSubsystem:SendMsg_Share(id)
    local reqData =CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    QuickTaHelper:Get():ShareEvent('ShareRewardREQ')
    NetManager:Get():Send(MsgID.RECRUIT_SHARE_C2S_REQ, reqData)
end

----发送分享奖励请求
---@param id  @扭蛋id
function RecruitSubsystem:SendMsg_MiniChange(id,partid)
    local reqData =CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id,partid})
    NetManager:Get():Send(MsgID.RECRUIT_MINI_EXCHANGE_C2S_REQ, reqData)
end

function RecruitSubsystem:RecvMsg_Recruit(data)
    ---@type SC_UserRecruit
    local msg = assert(Dll_PB.decode("UserRecruit", data))
    print(ProtoMsgHelp.block(msg))
    PopUpGiftDataManager:Get():UpdateDataList(msg.buyItems)
    local isFirstLottery = 1
    CommonHelper:Audio_PauseBGM()

    if #msg.mySomeDown > 0 then
        if msg.curConsume then
            KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)
        end
        KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.mySomeDown[1])

        local recruitData = RecruitDataManager:Get():GetDataById(msg.myRecruits[1].recruitId)


        RecruitDataManager:Get():UpdateRecruitData(msg.myRecruits)

        --UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitBtn, true)

        if msg.myRecruits[1].recruitId ~= RecruitDataManager:Get():GetNewRecruitId() then
            UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
            local recruitData = RecruitDataManager:Get():GetDataById(msg.myRecruits[1].recruitId)
            RecruitDataManager:Get():StartCountTime(recruitData)

            if RecruitDataManager:Get():GetRecruitCount() == 0 then
                RecruitDataManager:Get():UpdateRedDic(recruitData:GetId(), nil)
            end

            --SdkAd:Get():SdkAdjust_Recruit(RecruitDataManager:Get():GetRecruitCount() == 10)
            isFirstLottery = 2
        else
            UINotify:Get():SendNotification(UINotifyEvent.RecruitView_UpdateRecruitList)
            isFirstLottery = 1
        end
    end

    InviteDataManager:Get():SetIsInRecruit(true)

    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_PlayAni, msg)
    local lotteryType = 1
    if RecruitDataManager:Get():GetRecruitCount() == 10 then
        lotteryType = 2
    end
    RedPointManager:Get():UpdateValue(RedPointID.S_RecruitFree,RecruitDataManager:Get():GetRedPointCount()>0)
    --local data= QuickTaData:GetLotteryComplete(
    --        msg.myRecruits[1].recruitId,
    --        isFirstLottery,
    --        lotteryType,
    --        msg.curConsume and msg.curConsume.propsid or 0 ,
    --        msg.curConsume and msg.curConsume.propsnum or 0,
    --        msg.myRecruits[1].prizeNum-msg.myRecruits[1].curPrizeNum,
    --        msg.curConsume and msg.myRecruits[1].curPrizeNum==0 or false
    --)
    --QuickTa:Get():TrackEvent(TrackEventNames.LotteryComplete,data)
    RecruitSubsystem:Get():SendMsg_RecruitInfo(2)
end


function RecruitSubsystem:RecvMsg_Share(data)
    ---@type SC_UserShare
    local msg = assert(Dll_PB.decode("UserShare", data))
    print(" 分享奖励回调 :"..ProtoMsgHelp.block(msg))
    QuickTaHelper:Get():ShareEvent('ShareRewardRET');
    CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist,true)
    UINotify:Get():SendNotification(UINotifyEvent.RecruitShowView_FirstShareClose)
end


function RecruitSubsystem:RecvMsg_MiniExchange(data)
    ---@type SC_UserRecruit
    local msg = assert(Dll_PB.decode("UserRecruit", data))
    print(ProtoMsgHelp.block(msg))
    UIManager:Get():ClosePopup()
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.RecruitSelectSuccess))
    RecruitDataManager:Get():UpdateRecruitData(msg.myRecruits)
    UINotify:Get():SendNotification(UINotifyEvent.RecruitView_InitViewInfo)
end
function RecruitSubsystem:SendMsg_GetRecruitCountInfo(id)
    local reqData =CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id})
    NetManager:Get():Send(MsgID.RECRUIT_COUNT_INFO_C2S_REQ, reqData)
end
function RecruitSubsystem:SendMsg_GetRecruitCountReward(id,num)
    local reqData =CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),id,num})
    NetManager:Get():Send(MsgID.RECRUIT_COUNT_GET_REWARD_C2S_REQ, reqData)
end

function RecruitSubsystem:RecvMsg_RecruitCountInfo(data)
    ---@type SC_UserRecruitCounts
    local msg = assert(Dll_PB.decode("UserRecruitCounts", data))
    print(ProtoMsgHelp.block(msg))
    TaskDataManager:Get():OnInitRecruit(msg,TaskType.RecruitCount)
    if UIManager:Get():IsViewShow("TaskView") == false then
        UIManager:Get():OpenView("TaskView", CanvasType.MainCanvas, "TaskView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.TaskViewSetData, TaskType.RecruitCount)
    self:UpdateRedPoint()
end


function RecruitSubsystem:RecvMsg_RecruitCountGetReward(data)
    ---@type SC_UserRecruitCountGift
    local msg = assert(Dll_PB.decode("UserRecruitCountGift", data))
    print(ProtoMsgHelp.block(msg))
    CommonHelper:ShowGetRewardDataBySomeDown(msg.mySomeDown[1],true)
    TaskDataManager:Get():UpdateTaskById(msg.awardSeq)
    UINotify:Get():SendNotification(UINotifyEvent.RefreshCurView)
    self:UpdateRedPoint()
end

function RecruitSubsystem:UpdateRedPoint()
    local value="Count"
    if TaskDataManager:Get():GetTaskIsDone(TaskType.RecruitCount)==false then
        value=nil
    end
    RecruitDataManager:Get():RecRedPointId(TaskDataManager:Get():GetRecruitID()+100000,value)
end

local __subsystem = RecruitSubsystem()
function RecruitSubsystem:Get()
    return __subsystem
end
return __subsystem