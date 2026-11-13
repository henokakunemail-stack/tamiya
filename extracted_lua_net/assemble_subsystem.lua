


---@class AssembleSubsystem
AssembleSubsystem = class("AssembleSubsystem")

function AssembleSubsystem:initialize( ... )
    NetResponseEventManager:Get():AddListener(MsgID.ALTER_PART_S2C_RES , self, self.RecvMsg_AssemblePart)
    NetResponseEventManager:Get():AddListener(MsgID.UNLOAD_PART_S2C_RES , self, self.RecvMsg_DisassemblePart)
    NetResponseEventManager:Get():AddListener(MsgID.USE_GARAGE_KEY_S2C_RES , self, self.RecvMsg_UseGarageKey)
    NetResponseEventManager:Get():AddListener(MsgID.ALTER_PART_COPY_S2C_RES , self, self.RecvMsg_AssemblePartCopy)
end






local _SendGarageType=0
function AssembleSubsystem:SendMsg_AssemblePart(carId,grooveID,bagId,type)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),carId,grooveID,bagId})
    NetManager:Get():Send(MsgID.ALTER_PART_C2S_REQ, reqBytes)
    _SendGarageType=type
end

function AssembleSubsystem:SendMsg_AlterPartCopy(article,destid,color,sticker,hole)
    local str=nil
    if hole then
        str=table.concat(hole,':')
    end
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),article,destid,sticker,color,str})
    NetManager:Get():Send(MsgID.ALTER_PART_COPY_C2S_REQ, reqBytes)
end
function AssembleSubsystem:SendMsg_UseGarageKay(article)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),article})
    NetManager:Get():Send(MsgID.USE_GARAGE_KEY_C2S_REQ, reqBytes)
end

function AssembleSubsystem:SendMsg_DisassemblePart(carId,grooveID,type)
    local reqBytes = CommonHelper:GetNetSendData({PlayerDataManager:Get():GetPlayerRID(),carId,grooveID})
    NetManager:Get():Send(MsgID.UNLOAD_PART_C2S_REQ, reqBytes)
    _SendGarageType=type
end







function AssembleSubsystem:RecvMsg_AssemblePart(data)
    print("---   组装成功")
    ---@type SC_AlterPart
    local msg = assert(Dll_PB.decode("AlterPart", data))
    print(ProtoMsgHelp.block(msg))
    if _SendGarageType==AssembleGarageOpenType.Garage then
        self:UpdateGrooveList(msg.curCar)
        self:UpdatePartUnload(msg.unloadParts)
        self:UpdatePartBelong(msg.loadParts,msg.planSeq)
        KnapsackDataManager:Get():DelArticleByPartsId(msg.deleteParts)
        CarCacheManager:Get():UpdateCache()
        UINotify:Get():SendNotification(UINotifyEvent.Msg_Assemble,true)
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleSucceed))
        RedPointManager:Get():UpdateValue(RedPointID.Garage)
    end
    if _SendGarageType==AssembleGarageOpenType.RaceAssemble then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.AssembleSucceed))
        RaceAssembleManager:Get():UpdateCarData(msg.curCar)
        RaceAssembleManager:Get():UpdatePartUnload(msg.unloadParts)
        RaceAssembleManager:Get():UpdatePartBelong(msg.loadParts,msg.planSeq)
        RaceAssembleManager:Get():DelArticleByPartsId(msg.deleteParts)
        RaceAssembleAddManager:Get():UpdateCarData(msg.curCar)
        RaceAssembleAddManager:Get():UpdatePartUnload(msg.unloadParts)
        RaceAssembleAddManager:Get():UpdatePartBelong(msg.loadParts,msg.planSeq)
        RaceAssembleAddManager:Get():DelArticleByPartsId(msg.deleteParts)
        NewPlayerCarDataManager:Get():UpdateCarData(msg.curCar)
        NewPlayerCarDataManager:Get():UpdatePartUnload(msg.unloadParts)
        NewPlayerCarDataManager:Get():UpdatePartBelong(msg.loadParts,msg.planSeq)
        NewPlayerCarDataManager:Get():DelArticleByPartsId(msg.deleteParts)
        UINotify:Get():SendNotification(UINotifyEvent.AssembleGarageView_Assemble)
    end

end
function AssembleSubsystem:RecvMsg_AssemblePartCopy(data)
    print("---   组装成功")
    ---@type SC_UserCopyPart
    local msg = assert(Dll_PB.decode("UserCopyPart", data))
    print(ProtoMsgHelp.block(msg))
    local data = KnapsackDataManager:Get():GetArticleByID(msg.curPart.partinx)
    data:OnInitPart(msg.curPart)
    self:UpdateUserCar(data:GetCarId())
    if CarDataManager:Get():GetCarDataByCarID(data:GetCarId()) and data:GetPartType()==PartType.Shell then
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetCopyShellId(data:GetChangeIdx())
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetCopyShellColor(data:GetPartChangeShellColor())
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetCopyShellSticker(data:GetPartChangeShellSticker())
        CarDataManager:Get():GetCarDataByCarID(data:GetCarId()):SetCopyLightweight(data:GetPartChangeShellGridList(),data:GetPartChangeLightweight())
    end
    CarCacheManager:Get():UpdateCache()
    KnapsackDataManager:Get():UpdatePropByConsumeGroup(msg.consumeProp.allConsumes)
    UINotify:Get():SendNotification(UINotifyEvent.Msg_PartColor)

    if data:GetPartType()==PartType.Shell then
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GarageShellAlterColorSucceed))
    else
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.GaragePartAlterColorSucceed))
    end

end


function AssembleSubsystem:RecvMsg_DisassemblePart(data)
    print("---   拆除成功")
    ---@type SC_UnloadPart
    local msg = assert(Dll_PB.decode("UnloadPart", data))
    print(ProtoMsgHelp.block(msg))
    if _SendGarageType==AssembleGarageOpenType.RaceAssemble then
        RaceAssembleManager:Get():UpdateCarData(msg.curCar)
        RaceAssembleManager:Get():UpdatePartUnload(msg.unloadParts)
        RaceAssembleManager:Get():DelArticleByPartsId(msg.deleteParts)
        RaceAssembleAddManager:Get():UpdateCarData(msg.curCar)
        RaceAssembleAddManager:Get():UpdatePartUnload(msg.unloadParts)
        RaceAssembleAddManager:Get():DelArticleByPartsId(msg.deleteParts)
        NewPlayerCarDataManager:Get():UpdateCarData(msg.curCar)
        NewPlayerCarDataManager:Get():UpdatePartUnload(msg.unloadParts)
        NewPlayerCarDataManager:Get():DelArticleByPartsId(msg.deleteParts)
        UINotify:Get():SendNotification(UINotifyEvent.AssembleGarageView_Assemble)
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.DisassembleSucceed))
    end
    if _SendGarageType==AssembleGarageOpenType.Garage then
        self:UpdateGrooveList(msg.curCar)
        self:UpdatePartUnload(msg.unloadParts)
        KnapsackDataManager:Get():DelArticleByPartsId(msg.deleteParts)
        CarCacheManager:Get():UpdateCache()
        UINotify:Get():SendNotification(UINotifyEvent.Msg_Assemble,true)
        CommonTipsHelper:ShowCenterTips(ClientDataManager:Get():GetTemplateString(TemplateStringID.DisassembleSucceed))
    end
end
function AssembleSubsystem:RecvMsg_UseGarageKey(data)
    ---@type SC_UserKey
    local msg = assert(Dll_PB.decode("UserKey", data))
    print(ProtoMsgHelp.block(msg))
    KnapsackDataManager:Get():UpdatePropByConsume(msg.curConsume)
    KnapsackDataManager:Get():AddPropAndPartBySomeDown(msg.downlist)
    local data=CarDataManager:Get():AddCar(msg.openCar)
    TeamCacheManager:Get():LoadCar(data:GetCarIdx(), data:GetID())
    CarCacheManager:Get():UpdateCache()
    UINotify:Get():SendNotification(UINotifyEvent.Msg_CarIdxOpen)
end

---@param msg SC_UserCar
function AssembleSubsystem:UpdateGrooveList(msg)
    if msg then
        local cardata = CarDataManager:Get():GetCarDataByCarID(msg.planseq)
        cardata:UpdateData(msg)
        CarDataManager:Get():CheckArticleAdaptationChassis(msg.planseq)
    end
end
---@param idx
function AssembleSubsystem:UpdateUserCar(idx)
    if CarDataManager:Get():GetCarDataByCarID(idx) and CarDataManager:Get():GetCarDataByCarID(idx).LockState==ParkingLotState.Open then
        CarDataManager:Get():GetCarDataByCarID(idx):UpdateParts()
    end
end

---@param msg SC_UserCar
function AssembleSubsystem:UpdatePartBelong(bagid,carid)
    KnapsackDataManager:Get():UpdatePartBelong(bagid,carid)
end
---@param msg table<number,number>
function AssembleSubsystem:UpdatePartUnload(msg)
    KnapsackDataManager:Get():UpdatePartUnload(msg)
end

function AssembleSubsystem:CheckError(msg)
    local cardata = CarDataManager:Get():GetCarDataByCarID(msg.carId)
    for i = 1, #msg.changeParts do
        local grooveId = msg.changeParts[i].num1
        local bagid = msg.changeParts[i].num2
        local node = cardata.assembleMgr:GetNodeByGrooveID(grooveId)
        local articledata = KnapsackDataManager:Get():GetArticleByID(bagid)
        if articledata == nil or articledata:GetPartConfig() == nil then
            print("---   error:更换配件，新配件背包中没有")
        else
            if node:GetPartCfgID() ~= articledata:GetPartConfig().C_ID then
                print("---   error:更换配件，数据不同步",node:GetPartCfgID(), articledata:GetPartConfig().C_ID)
            end
        end
    end

end

local __subsystem = AssembleSubsystem()
function AssembleSubsystem:Get() return __subsystem end
return __subsystem