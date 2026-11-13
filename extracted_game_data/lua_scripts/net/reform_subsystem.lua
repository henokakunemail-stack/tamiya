

---@class ReformSubsystem
ReformSubsystem = class("ReformSubsystem")

function ReformSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.UP_PART_STAR_S2C_RES , self, self.RecvMsg_PartStarUp)
    NetResponseEventManager:Get():AddListener(MsgID.UP_PART_REFORM_S2C_RES , self, self.RecvMsg_ReformPos)
    NetResponseEventManager:Get():AddListener(MsgID.PART_UP_REFORM_S2C_RES , self, self.RecvMsg_ReformLv)
    NetResponseEventManager:Get():AddListener(MsgID.PART_REFORM_AGAIN_S2C_RES , self, self.RecvMsg_ReformReplace)
    NetResponseEventManager:Get():AddListener(MsgID.UP_PART_LV_S2C_RES , self, self.RecvMsg_PartLevelUp)
    NetResponseEventManager:Get():AddListener(MsgID.DEL_PART_REFORM_S2C_RES , self, self.RecvMsg_DelReformPos)
    NetResponseEventManager:Get():AddListener(MsgID.VERIFY_CAR_S2C_RES , self, self.RecvMsg_VerifyCor)
    NetResponseEventManager:Get():AddListener(MsgID.INHERIT_PART_S2C_RES , self, self.RecvMsg_Inherit)
    NetResponseEventManager:Get():AddListener(MsgID.INHERIT_PART_LEVEL_UP_S2C_RES , self, self.RecvMsg_InheritLevel)
    NetResponseEventManager:Get():AddListener(MsgID.INHERIT_PART_RECASTING_S2C_RES , self, self.RecvMsg_InheritRecasting)
    NetResponseEventManager:Get():AddListener(MsgID.INHERIT_PART_DEL_S2C_RES , self, self.RecvMsg_InheritDel)
    NetResponseEventManager:Get():AddListener(MsgID.BREAK_UP_S2C_RES, self, self.RecvMsg_RetBreakUp)
    NetResponseEventManager:Get():AddListener(MsgID.PART_AGE_UP_S2C_RET, self, self.RecvMsg_PartAdvanced)
end



-------------------------------------------------------------配件升星
function ReformSubsystem:SendMsg_PartStarUp(partid)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partid})
    NetManager:Get():Send(MsgID.UP_PART_STAR_C2S_REQ, reqBytes)
end
function ReformSubsystem:RecvMsg_PartStarUp(data)
    ---@type SC_StarUpPart
    local msg = assert(Dll_PB.decode("StarUpPart", data))
    print(ProtoMsgHelp.block(msg))


    local data = KnapsackDataManager:Get():GetArticleByID(msg.partInx)
    local oldStar = data:GetStar()
    data:UpdatePartStar(msg.curStar)

    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes)
    UIManager:Get():OpenPopup("DevelopStarResultView",CanvasType.FrontCanvas,"DevelopStarResultView")
    UINotify:Get():SendNotification(UINotifyEvent.PartStarUpView_SetData, data)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartStarUp)

    --local quickData = QuickTaData:GetPartProgress(
    --        "配件进化",
    --        msg.partInx,
    --        data:GetID(),
    --        data:GetPartType(),
    --        data:GetPartSubType(),
    --        data:GetPartQuality(),
    --        data:GetPartLV(),
    --        msg.curStar,
    --        msg.curStar - oldStar,
    --        data:GetCarId())
    --QuickTa:Get():TrackEvent(TrackEventNames.PartProgress, quickData)
end
-------------------------------------------------------------

local _AlterPart=-1
-------------------------------------------------------------改造槽位
function ReformSubsystem:SendMsg_ReformPos(partid, idx, reformid, useItem)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),idx,partid,reformid,useItem})
    NetManager:Get():Send(MsgID.UP_PART_REFORM_C2S_REQ, reqBytes)
    _AlterPart=partid
end
function ReformSubsystem:RecvMsg_ReformPos(data)
    ---@type SC_RefromPart
    local msg = assert(Dll_PB.decode("RefromPart", data))
    print(ProtoMsgHelp.block(msg))

    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    local oldattr = {}
    if msg.curEntryId > 0 then
        CarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
        local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
        for i = 1, #msg.entryAttrs do
            local oldvalue = data:GetPartAttr(msg.entryAttrs[i].attrId)
            table.insert(oldattr, {msg.entryAttrs[i].attrId,msg.entryAttrs[i].attrVal/1000, oldvalue})
            QuickTaHelper:Get():TrackPartReformEvent("配件改造成功",msg, oldvalue ,msg.entryAttrs[i].attrVal/1000)

        end
        data:OnInitPart(msg.curPart)
    end
    CarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    local iswin = msg.curEntryId > 0

    if iswin then
        UIManager:Get():OpenPopup("ReformResultView",CanvasType.FrontCanvas,"ReformResultView")
        UINotify:Get():SendNotification(UINotifyEvent.ReformSucceedView_SetData,{iswin, msg.curPart.partinx, msg.curEntryId, oldattr,1} )

        UINotify:Get():SendNotification(UINotifyEvent.Msg_PartReform)
    else
        CommonHelper:PlaySfxByReform(0)
        UIManager:Get():OpenPopup("ReformResultView",CanvasType.FrontCanvas,"ReformResultView")
        UINotify:Get():SendNotification(UINotifyEvent.ReformSucceedView_SetData,{false, _AlterPart, -1, {},1} )
        UINotify:Get():SendNotification(UINotifyEvent.Msg_PartReform)
    end


end
-------------------------------------------------------------
-------------------------------------------------------------改造槽位
local _SendGarageType=-1
function ReformSubsystem:SendMsg_DelReformPos(partid, idx,type)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partid,idx,reformid})
    NetManager:Get():Send(MsgID.DEL_PART_REFORM_C2S_REQ, reqBytes)
    _AlterPart=partid
    _SendGarageType=type
end
function ReformSubsystem:RecvMsg_DelReformPos(data)
    ---@type SC_RefromPart
    local msg = assert(Dll_PB.decode("RefromPart", data))
    print(ProtoMsgHelp.block(msg))
    if _SendGarageType==AssembleGarageOpenType.Garage then
        KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
        CarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
        local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
        data:OnInitPart(msg.curPart)
        CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.DelReformPosSuccess))
        UINotify:Get():SendNotification(UINotifyEvent.Msg_PartReform)
    end
    if _SendGarageType==AssembleGarageOpenType.RaceAssemble then
        RaceAssembleManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
        RaceAssembleManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
        UINotify:Get():SendNotification(UINotifyEvent.AssembleGarageView_Assemble)
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.DelReformPosSuccess))
    end
    if _SendGarageType==AssembleGarageOpenType.RaceAssembleAdd then
        RaceAssembleAddManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
        RaceAssembleAddManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
        UINotify:Get():SendNotification(UINotifyEvent.AssembleGarageView_Assemble)
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.DelReformPosSuccess))
    end
    if _SendGarageType==AssembleGarageOpenType.RaceNewPlayer then
        NewPlayerCarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
        NewPlayerCarDataManager:Get():UpdatePartByCarId(msg.curPart.partinx,msg.curPart)
        UINotify:Get():SendNotification(UINotifyEvent.AssembleGarageView_Assemble)
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.DelReformPosSuccess))
    end
end
-------------------------------------------------------------
-------------------------------------------------------------改造槽位
function ReformSubsystem:SendMsg_VerifyCor()
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID()})
    NetManager:Get():Send(MsgID.VERIFY_CAR_C2S_REQ, reqBytes)
end
function ReformSubsystem:RecvMsg_VerifyCor(data)
    ---@type SC_RefromPart
    local msg = assert(Dll_PB.decode("Consume", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsume(msg)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartVerifyAttr,{CarVerifyHistoryOpenType.Save})
end
-------------------------------------------------------------
-------------------------------------------------------------传承槽位
function ReformSubsystem:SendMsg_InheritPart(partidx,inheritid,type,costid)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partidx,inheritid,type,costid})
    NetManager:Get():Send(MsgID.INHERIT_PART_C2S_REQ, reqBytes)
end
function ReformSubsystem:RecvMsg_Inherit(data)
    ---@type SC_PartInherit
    local msg = assert(Dll_PB.decode("PartInherit", data))
    print(ProtoMsgHelp.block(msg))
    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    data:OnInitPart(msg.curPart)
    if data:GetCarId() > 0 then
        CarDataManager:Get():UpdateCarAttrByCarId(data:GetCarId(), msg.carAttrs)
    end
    KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsumes)
    KnapsackDataManager:Get():DelArticleByPartsId(msg.consumePartinxs)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartInherit)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritSuccess))
end
-------------------------------------------------------------
-------------------------------------------------------------传承升级
function ReformSubsystem:SendMsg_InheritLevelUp(partidx,inheritid,partid,articleid,articlenum)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partidx,inheritid,partid,articleid,articlenum})
    NetManager:Get():Send(MsgID.INHERIT_PART_LEVEL_UP_C2S_REQ, reqBytes)
end
function ReformSubsystem:RecvMsg_InheritLevel(data)
    ---@type SC_PartInheritUplev
    local msg = assert(Dll_PB.decode("PartInheritUplev", data))
    print(ProtoMsgHelp.block(msg))
    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    data:OnInitPart(msg.curPart)
    if data:GetCarId() > 0 then
        CarDataManager:Get():UpdateCarAttrByCarId(data:GetCarId(), msg.carAttrs)
    end
    UIManager:Get():HidePersistentView("InheritLevelView")
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    KnapsackDataManager:Get():DelArticleByPartsId(msg.consumePartinxs)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartInherit)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritUpLevelSuccess))
end
-------------------------------------------------------------
-------------------------------------------------------------传承重铸
function ReformSubsystem:SendMsg_InheritRecasting(partid,inheritid)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partid,inheritid})
    NetManager:Get():Send(MsgID.INHERIT_PART_RECASTING_C2S_REQ, reqBytes)
end
function ReformSubsystem:RecvMsg_InheritRecasting(data)
    ---@type SC_PartInheritUplev
    local msg = assert(Dll_PB.decode("PartInheritUplev", data))
    print(ProtoMsgHelp.block(msg))
    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    local oldAttr=data:GetInheritById(msg.inheritId).ReformVal
    data:OnInitPart(msg.curPart)
    if data:GetCarId() > 0 then
        CarDataManager:Get():UpdateCarAttrByCarId(data:GetCarId(), msg.carAttrs)
    end
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    KnapsackDataManager:Get():DelArticleByPartsId(msg.consumePartinxs)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartInherit)
    if UIManager:Get():IsPopViewShow("InheritRecastingResultView")==false then
        UIManager:Get():OpenPopup("InheritRecastingResultView",CanvasType.FrontCanvas,"InheritRecastingResultView")
    end
    UINotify:Get():SendNotification(UINotifyEvent.InheritRecastingResultView_SetData,{msg.curPart.partinx, msg.inheritId,oldAttr} )

end
-------------------------------------------------------------
-------------------------------------------------------------传承删除
function ReformSubsystem:SendMsg_InheritDel(partidx,orginheritid,inheritid,type,costid)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partidx,orginheritid,type,costid,inheritid})
    NetManager:Get():Send(MsgID.INHERIT_PART_DEL_C2S_REQ, reqBytes)
end
function ReformSubsystem:RecvMsg_InheritDel(data)
    ---@type SC_PartInherit
    local msg = assert(Dll_PB.decode("PartInherit", data))
    print(ProtoMsgHelp.block(msg))
    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    data:OnInitPart(msg.curPart)
    if data:GetCarId() > 0 then
        CarDataManager:Get():UpdateCarAttrByCarId(data:GetCarId(), msg.carAttrs)
    end
    KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsumes)
    KnapsackDataManager:Get():DelArticleByPartsId(msg.consumePartinxs)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartInherit)
    CommonTipsHelper:Get():ShowCenterTips(CommonHelper:GetTempStr_Default(TemplateStringID.PartInheritReplaceSuccess))
end
-------------------------------------------------------------

-------------------------------------------------------------改造升级
function ReformSubsystem:SendMsg_ReformLv(partid, idx, uptolv)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partid,idx,uptolv})
    NetManager:Get():Send(MsgID.PART_UP_REFORM_C2S_REQ, reqBytes)
end
function ReformSubsystem:RecvMsg_ReformLv(data)
    ---@type SC_RefromPart
    local msg = assert(Dll_PB.decode("RefromPart", data))
    print(ProtoMsgHelp.block(msg))
    if msg.curConsumes then
        KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    end
    CarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    local oldattr = {}
    for i = 1, #msg.entryAttrs do
        local oldvalue = data:GetPartAttr(msg.entryAttrs[i].attrId)
        table.insert(oldattr, {msg.entryAttrs[i].attrId,msg.entryAttrs[i].attrVal/1000, oldvalue})
        QuickTaHelper:Get():TrackPartReformEvent("配件强化成功",msg, oldvalue ,msg.entryAttrs[i].attrVal/1000)

    end
    data:OnInitPart(msg.curPart)
    UIManager:Get():OpenPopup("ReformStrongResultView",CanvasType.FrontCanvas,"ReformStrongResultView")
    UINotify:Get():SendNotification(UINotifyEvent.PartUpSucceedView_SetData,{msg.curPart.partinx, oldattr, msg.curEntryId} )

    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartReformLvup)
    --CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.PartStrongSucceed))

end
-------------------------------------------------------------


-------------------------------------------------------------重铸
function ReformSubsystem:SendMsg_ReformReplace(partid, idx, useItem)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partid,idx,useItem and 1 or 0})
    NetManager:Get():Send(MsgID.PART_REFORM_AGAIN_C2S_REQ, reqBytes)
    _AlterPart=partid
end
function ReformSubsystem:RecvMsg_ReformReplace(data)
    ---@type SC_RefromPart
    local msg = assert(Dll_PB.decode("RefromPart", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    if msg.curEntryId<=0 then
        CommonHelper:PlaySfxByReform(0)
        UIManager:Get():OpenPopup("ReformResultView",CanvasType.FrontCanvas,"ReformResultView")
        UINotify:Get():SendNotification(UINotifyEvent.ReformSucceedView_SetData,{false, _AlterPart, -1, {},2} )
        UINotify:Get():SendNotification(UINotifyEvent.Msg_PartReform)
    else
        local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
        if msg.curPart ==nil then
            UIManager:Get():OpenPopup("ReformResultView",CanvasType.FrontCanvas,"ReformResultView")
            UINotify:Get():SendNotification(UINotifyEvent.ReformSucceedView_SetData,{false, _AlterPart, -1, {},2} )
            UINotify:Get():SendNotification(UINotifyEvent.Msg_PartReform)
            return
        end
        local quality=1
        for i = 1, #msg.curPart.curEntry do
            if msg.curEntryId==msg.curPart.curEntry[i].entryid then
                quality=msg.curPart.curEntry[i].quality
            end
        end
        if quality <=  data:GetPartReformByEntryId(msg.curEntryId).quality then
            UIManager:Get():OpenPopup("ReformResultView",CanvasType.FrontCanvas,"ReformResultView")
            UINotify:Get():SendNotification(UINotifyEvent.ReformSucceedView_SetData,{false, _AlterPart, -1, {},2} )
            UINotify:Get():SendNotification(UINotifyEvent.Msg_PartReform)
            return
        end

        local oldattr = {}
        if msg.curEntryId > 0 then
            CarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
            local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
            for i = 1, #msg.entryAttrs do
                local oldvalue = data:GetPartAttr(msg.entryAttrs[i].attrId)
                table.insert(oldattr, {msg.entryAttrs[i].attrId,msg.entryAttrs[i].attrVal/1000, oldvalue})
                QuickTaHelper:Get():TrackPartReformEvent("配件重置成功",msg, oldvalue ,msg.entryAttrs[i].attrVal/1000)

            end
            data:OnInitPart(msg.curPart)
        end
        CarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)

        UIManager:Get():OpenPopup("ReformResultView",CanvasType.FrontCanvas,"ReformResultView")
        UINotify:Get():SendNotification(UINotifyEvent.ReformSucceedView_SetData,{true, msg.curPart.partinx, msg.curEntryId, oldattr,2} )
    end
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartReform)

end
-------------------------------------------------------------



--{{{配件升级
function ReformSubsystem:SendMsg_PartLevelUp(partid, value)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),partid,value})
    NetManager:Get():Send(MsgID.UP_PART_LV_C2S_REQ, reqBytes)
end
function ReformSubsystem:RecvMsg_PartLevelUp(data)
    ---@type SC_PartLevelUp
    local msg = assert(Dll_PB.decode("PartLevelUp", data))
    print(ProtoMsgHelp.block(msg))

    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)

    local temp = data:GetPartSecondAttrs()
    local oldlv = data:GetPartLV()
    local oldattrs = {}
    for i = 1, #temp do table.insert(oldattrs, temp[i]) end


    data:OnInitPart(msg.curPart)
    CarDataManager:Get():UpdateCarAttrByCarId(msg.planSeq,msg.carAttrs)
    KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)

    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartLevelUp)



    UIManager:Get():OpenPopup("PartLevelupResultView",CanvasType.FrontCanvas,"PartLevelupResultView")
    UINotify:Get():SendNotification(UINotifyEvent.PartLevelupResultView_SetData,{data,oldlv,oldattrs } )

    --local quickData = QuickTaData:GetPartProgress(
    --        "配件升级",
    --        msg.curPart.partinx,
    --        msg.curPart.partid,
    --        data:GetPartType(),
    --        data:GetPartSubType(),
    --        data:GetPartQuality(),
    --        msg.curPart.curlevel,
    --        msg.curPart.curstar,
    --        msg.curPart.curlevel - oldlv,
    --        msg.planSeq)
    --QuickTa:Get():TrackEvent(TrackEventNames.PartProgress, quickData)
end
--}}}

--{{{觉醒

function ReformSubsystem:SendMsg_ReqBreakUp(id)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id })
    NetManager:Get():Send(MsgID.BREAK_UP_C2S_REQ, reqBytes)
end

function ReformSubsystem:RecvMsg_RetBreakUp(data)
    ---@type SC_BreakPart
    local msg = assert(Dll_PB.decode("BreakPart", data))
    print(ProtoMsgHelp.block(msg))

    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.curConsumes.allConsumes)
    local data = KnapsackDataManager:Get():GetArticleByID(msg.breakPart.partinx)
    local oldData={}
    for i = 1, #data:GetPartBreakCfg().attrtypes do
      local value= data:GetPartAttr(data:GetPartBreakCfg().attrtypes[i])
        table.insert(oldData,{data:GetPartBreakCfg().attrtypes[i],value})
    end
    data:OnInitPart(msg.breakPart)
    if data:GetCarId() > 0 then
        CarDataManager:Get():UpdateCarAttrByCarId(data:GetCarId(), msg.carAttrs)
    end
    UIManager:Get():OpenPopup("PartAwakeSuccessView", CanvasType.MainCanvas, "PartAwakeSuccessView")
    UINotify:Get():SendNotification(UINotifyEvent.Part_AwakeResultSetData, {data,oldData,1})
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartAwake)
end

--}}}
--{{{进阶

function ReformSubsystem:SendMsg_PartAdvanced(id, cost)
    local reqBytes = CommonHelper:GetNetSendData({ PlayerDataManager:Get():GetPlayerRID(), id, cost })
    NetManager:Get():Send(MsgID.PART_AGE_UP_C2S_REQ, reqBytes)
end

---586, -- 返回配件进化
function ReformSubsystem:RecvMsg_PartAdvanced(data)
    ---@type SC_UserPartAge
    local msg = assert(Dll_PB.decode("UserPartAge", data))
    print(ProtoMsgHelp.block(msg))
    local oldData={}
    local data = KnapsackDataManager:Get():GetArticleByID(msg.agePart.partinx)
    local NewAttr=data:GetGenerationAttrList()[data:GetGeneration() + 1].NewAttr
    for k, v in pairs(NewAttr) do
        local value= data:GetPartAttr(v.type)
        table.insert(oldData, {v.type,value})
    end
    data:OnInitPart(msg.agePart)
    if data:GetCarId() > 0 then
        CarDataManager:Get():UpdateCarAttrByCarId(data:GetCarId(), msg.carAttrs)
    end

    KnapsackDataManager:Get():DelArticleByPartsId(msg.counsumPartInx)

    if msg.downlist == nil then
        UIManager:Get():OpenPopup("PartAwakeSuccessView", CanvasType.MainCanvas, "PartAwakeSuccessView")
        UINotify:Get():SendNotification(UINotifyEvent.Part_AwakeResultSetData,{data,oldData,2})
    else
        CommonHelper:ShowGetRewardDataBySomeDown(msg.downlist, true, function()
            UIManager:Get():OpenPopup("PartAwakeSuccessView", CanvasType.MainCanvas, "PartAwakeSuccessView")
            UINotify:Get():SendNotification(UINotifyEvent.Part_AwakeResultSetData, {data,oldData,2})
        end)
    end

    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartUp)
end
--}}}



local __subsystem = ReformSubsystem()
function ReformSubsystem:Get() return __subsystem end
return __subsystem